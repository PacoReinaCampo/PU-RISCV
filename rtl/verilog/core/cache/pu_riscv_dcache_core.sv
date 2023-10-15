////////////////////////////////////////////////////////////////////////////////
//                                            __ _      _     _               //
//                                           / _(_)    | |   | |              //
//                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |              //
//               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |              //
//              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |              //
//               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|              //
//                  | |                                                       //
//                  |_|                                                       //
//                                                                            //
//                                                                            //
//              MPSoC-RISCV CPU                                               //
//              Core - Data Cache (Write Back)                                //
//              AMBA3 AHB-Lite Bus Interface                                  //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

/* Copyright (c) 2017-2018 by the author(s)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * =============================================================================
 * Author(s):
 *   Paco Reina Campo <pacoreinacampo@queenfield.tech>
 */

import peripheral_biu_pkg::*;

module pu_riscv_dcache_core #(
  parameter XLEN = 64,
  parameter PLEN = 64,

  parameter DCACHE_SIZE        = 64,
  parameter DCACHE_BLOCK_SIZE  = 64,
  parameter DCACHE_WAYS        = 2,
  parameter DCACHE_REPLACE_ALG = 0,

  parameter TECHNOLOGY = "GENERIC"
) (
  input wire rst_ni,
  input wire clk_i,

  //CPU side
  input  wire            mem_vreq_i,
  input  wire            mem_preq_i,
  input  wire [XLEN-1:0] mem_vadr_i,
  input  wire [PLEN-1:0] mem_padr_i,
  input  wire [     2:0] mem_size_i,
  input                  mem_lock_i,
  input  wire [     2:0] mem_prot_i,
  input  wire [XLEN-1:0] mem_d_i,
  input  wire            mem_we_i,
  output reg  [XLEN-1:0] mem_q_o,
  output reg             mem_ack_o,
  output reg             mem_err_o,
  input  wire            flush_i,
  output reg             flushrdy_o,

  //To BIU
  output reg             biu_stb_o,      //access request
  input  wire            biu_stb_ack_i,  //access acknowledge
  input  wire            biu_d_ack_i,    //BIU needs new data (biu_d_o)
  output reg  [PLEN-1:0] biu_adri_o,     //access start address
  input  wire [PLEN-1:0] biu_adro_i,
  output reg  [     2:0] biu_size_o,     //transfer size
  output reg  [     2:0] biu_type_o,     //burst type
  output reg             biu_lock_o,     //locked transfer
  output reg  [     2:0] biu_prot_o,     //protection bits
  output reg             biu_we_o,       //write enable
  output reg  [XLEN-1:0] biu_d_o,        //write data
  input  wire [XLEN-1:0] biu_q_i,        //read data
  input  wire            biu_ack_i,      //transfer acknowledge
  input  wire            biu_err_i       //transfer error
);

  //////////////////////////////////////////////////////////////////////////////
  //
  // Constants
  //

  //----------------------------------------------------------------
  // Cache
  //----------------------------------------------------------------
  localparam PAGE_SIZE = 4 * 1024;  //4KB pages
  localparam MAX_IDX_BITS = $clog2(PAGE_SIZE) - $clog2(DCACHE_BLOCK_SIZE);  //Maximum IDX_BITS

  localparam SETS = (DCACHE_SIZE * 1024) / DCACHE_BLOCK_SIZE / DCACHE_WAYS;  //Number of sets TODO:SETS=1 doesn't work
  localparam BLK_OFF_BITS = $clog2(DCACHE_BLOCK_SIZE);  //Number of BlockOffset bits
  localparam IDX_BITS = $clog2(SETS);  //Number of Index-bits
  localparam TAG_BITS = XLEN - IDX_BITS - BLK_OFF_BITS;  //Number of TAG-bits
  localparam BLK_BITS = 8 * DCACHE_BLOCK_SIZE;  //Total number of bits in a Block
  localparam BURST_SIZE = BLK_BITS / XLEN;  //Number of transfers to load 1 Block
  localparam BURST_BITS = $clog2(BURST_SIZE);
  localparam BURST_OFF = XLEN / 8;
  localparam BURST_LSB = $clog2(BURST_OFF);

  //BLOCK decoding
  localparam DAT_OFF_BITS = $clog2(BLK_BITS / XLEN);  //Byte offset in block

  //Memory FIFO
  localparam MEM_FIFO_DEPTH = 4;

  //////////////////////////////////////////////////////////////////////////////
  //
  // Functions
  //
  function automatic integer onehot2int;
    input [DCACHE_WAYS-1:0] a;

    integer i;

    onehot2int = 0;

    for (i = 0; i < DCACHE_WAYS; i = i + 1) if (a[i]) onehot2int = i;
  endfunction

  function automatic [XLEN/8-1:0] size2be;
    input [2:0] size;
    input [XLEN-1:0] adr;

    logic [$clog2(XLEN/8)-1:0] adr_lsbs;

    adr_lsbs = adr[$clog2(XLEN/8)-1:0];

    case (size)
      BYTE:    size2be = 'h1 << adr_lsbs;
      HWORD:   size2be = 'h3 << adr_lsbs;
      WORD:    size2be = 'hf << adr_lsbs;
      DWORD:   size2be = 'hff << adr_lsbs;
      default: ;
    endcase
  endfunction

  function automatic [XLEN-1:0] be_mux;
    input [XLEN/8-1:0] be;
    input [XLEN  -1:0] o;  //old data
    input [XLEN  -1:0] n;  //new data

    be_mux[0*8 +: 8] = be[0] ? n[0*8 +: 8] : o[0*8 +: 8];
    be_mux[1*8 +: 8] = be[1] ? n[1*8 +: 8] : o[1*8 +: 8];
    be_mux[2*8 +: 8] = be[2] ? n[2*8 +: 8] : o[2*8 +: 8];
    be_mux[3*8 +: 8] = be[3] ? n[3*8 +: 8] : o[3*8 +: 8];
  endfunction

  //////////////////////////////////////////////////////////////////////////////
  //
  // Constants
  //
  parameter ARMED = 0;
  parameter FLUSH = 1;
  parameter FLUSHWAYS = 2;
  parameter WAIT4BIUCMD1 = 4;
  parameter WAIT4BIUCMD0 = 8;
  parameter RECOVER = 16;

  parameter IDLE = 2'b10;
  parameter WAIT4BIU = 2'b01;
  parameter BURST = 2'b00;

  parameter NOP = 0;
  parameter WRITE_WAY = 1;
  parameter READ_WAY = 2;

  //////////////////////////////////////////////////////////////////////////////
  //
  // Variables
  //
  genvar way;
  genvar set;

  //Memory Interface State Machine Section
  logic                                           mem_vreq_dly;
  logic                                           mem_preq_dly;
  logic [XLEN                 -1:0]               mem_vadr_dly;
  logic [PLEN                 -1:0]               mem_padr_dly;
  logic [XLEN/8               -1:0]               mem_be;
  logic [XLEN/8               -1:0]               mem_be_dly;
  logic                                           mem_we_dly;
  logic [XLEN                 -1:0]               mem_d_dly;

  logic [TAG_BITS             -1:0]               core_tag;
  logic [TAG_BITS             -1:0]               core_tag_hold;

  logic                                           hold_flush;  //stretch flush_i until FSM is ready to serve

  logic [                      4:0]               memfsm_state;

  //Cache Section
  logic [IDX_BITS             -1:0]               tag_idx;
  logic [IDX_BITS             -1:0]               tag_idx_dly;  //delayed version for writing valid/dirty
  logic [IDX_BITS             -1:0]               tag_idx_hold;  //stretched version for writing TAG during fill
  logic [IDX_BITS             -1:0]               tag_dirty_write_idx;  //index for writing tag.dirty
  logic [IDX_BITS             -1:0]               vadr_idx;  //index bits extracted from vadr_i
  logic [IDX_BITS             -1:0]               vadr_dly_idx;  //index bits extracted from vadr_dly
  logic [IDX_BITS             -1:0]               padr_idx;
  logic [IDX_BITS             -1:0]               padr_dly_idx;

  logic [DCACHE_WAYS          -1:0]               tag_we;
  logic [DCACHE_WAYS          -1:0]               tag_we_dirty;

  logic [          DCACHE_WAYS-1:0]               tag_in_valid;
  logic [          DCACHE_WAYS-1:0]               tag_in_dirty;
  logic [          DCACHE_WAYS-1:0][TAG_BITS-1:0] tag_in_tag;

  logic [          DCACHE_WAYS-1:0]               tag_out_valid;
  logic [          DCACHE_WAYS-1:0]               tag_out_dirty;
  logic [          DCACHE_WAYS-1:0][TAG_BITS-1:0] tag_out_tag;

  logic [          DCACHE_WAYS-1:0][IDX_BITS-1:0] tag_byp_idx;
  logic [          DCACHE_WAYS-1:0][TAG_BITS-1:0] tag_byp_tag;
  logic [          DCACHE_WAYS-1:0][    SETS-1:0] tag_valid;
  logic [          DCACHE_WAYS-1:0][    SETS-1:0] tag_dirty;

  logic [IDX_BITS             -1:0]               write_buffer_idx;
  logic [PLEN                 -1:0]               write_buffer_adr;  //physical address
  logic [XLEN/8               -1:0]               write_buffer_be;
  logic [XLEN                 -1:0]               write_buffer_data;
  logic [DCACHE_WAYS          -1:0]               write_buffer_hit;
  logic                                           write_buffer_was_write;

  logic                                           in_writebuffer;

  logic [IDX_BITS             -1:0]               dat_idx;
  logic [IDX_BITS             -1:0]               dat_idx_dly;
  logic [DCACHE_WAYS          -1:0]               dat_we;
  logic                                           dat_we_enable;
  logic [BLK_BITS/8           -1:0]               dat_be;
  logic [BLK_BITS             -1:0]               dat_in;
  logic [          DCACHE_WAYS-1:0][BLK_BITS-1:0] dat_out;

  logic [          DCACHE_WAYS-1:0][BLK_BITS-1:0] way_q_mux;
  logic [XLEN                 -1:0]               way_q;  //Only use XLEN bits from way_q
  logic [DCACHE_WAYS          -1:0]               way_hit;
  logic [DCACHE_WAYS          -1:0]               way_dirty;

  logic [DAT_OFF_BITS         -1:0]               dat_offset;

  logic                                           cache_hit;
  logic [XLEN                 -1:0]               cache_q;

  logic [                     19:0]               way_random;
  logic [DCACHE_WAYS          -1:0]               fill_way_select;
  logic [DCACHE_WAYS          -1:0]               fill_way_select_hold;

  logic                                           biu_adro_eq_cache_adr_dly;
  logic                                           flushing;
  logic                                           filling;
  logic [IDX_BITS             -1:0]               flush_idx;

  //Bus Interface State Machine Section
  logic [                      1:0]               biufsm_state;

  logic [                      1:0]               biucmd;

  logic                                           biufsm_ack;
  logic                                           biufsm_err;
  logic                                           biufsm_ack_write_way;  //BIU FSM should generate biufsm_ack on WRITE_WAY
  logic [XLEN                 -1:0]               biu_q;
  logic [BLK_BITS             -1:0]               biu_buffer;
  logic [BURST_SIZE           -1:0]               biu_buffer_valid;
  logic                                           biu_buffer_dirty;
  logic                                           in_biubuffer;

  logic                                           biu_we_hold;
  logic [PLEN                 -1:0]               biu_adri_hold;
  logic [XLEN                 -1:0]               biu_d_hold;

  logic [PLEN                 -1:0]               evict_buffer_adr;
  logic [BLK_BITS             -1:0]               evict_buffer_data;

  logic                                           is_read_way;
  logic                                           is_read_way_dly;
  logic                                           write_evict_buffer;

  logic [BURST_BITS           -1:0]               burst_cnt;

  logic [$clog2(DCACHE_WAYS)  -1:0]               get_dirty_way_idx;
  logic [IDX_BITS             -1:0]               get_dirty_set_idx;

  logic [SETS                 -1:0]               dirty_sets;

  //Riviera bug workaround
  wire  [PLEN                 -1:0]               pwb_adr;
  wire  [DAT_OFF_BITS         -1:0]               pwb_dat_offset;

  //////////////////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

  //----------------------------------------------------------------
  // Memory Interface State Machine
  //----------------------------------------------------------------

  //generate cache_* signals
  assign mem_be = size2be(mem_size_i, mem_vadr_i);

  //generate delayed mem_* signals
  always @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) mem_vreq_dly <= 'b0;
    else mem_vreq_dly <= mem_vreq_i | (mem_vreq_dly & ~mem_ack_o);
  end

  always @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) mem_preq_dly <= 'b0;
    else mem_preq_dly <= (mem_preq_i | mem_preq_dly) & ~mem_ack_o;
  end

  //register memory signals
  always @(posedge clk_i) begin
    if (mem_vreq_i) begin
      mem_vadr_dly <= mem_vadr_i;
      mem_we_dly   <= mem_we_i;
      mem_be_dly   <= mem_be;
      mem_d_dly    <= mem_d_i;
    end
  end

  always @(posedge clk_i) begin
    if (mem_preq_i) mem_padr_dly <= mem_padr_i;
  end

  //extract index bits from virtual address(es)
  assign vadr_idx     = mem_vadr_i[BLK_OFF_BITS +: IDX_BITS];
  assign vadr_dly_idx = mem_vadr_dly[BLK_OFF_BITS +: IDX_BITS];
  assign padr_idx     = mem_padr_i[BLK_OFF_BITS +: IDX_BITS];
  assign padr_dly_idx = mem_padr_dly[BLK_OFF_BITS +: IDX_BITS];

  //extract core_tag from physical address
  assign core_tag     = mem_padr_i[XLEN-1 -: TAG_BITS];

  //hold core_tag during filling. Prevents new mem_req (during fill) to mess up the 'tag' value
  always @(posedge clk_i) begin
    if (!filling) core_tag_hold <= core_tag;
  end

  //hold flush until ready to service it
  always @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) hold_flush <= 1'b0;
    else hold_flush <= ~flushing & (flush_i | hold_flush);
  end

  //signal Instruction Cache when FLUSH is done
  assign flushrdy_o = ~(flush_i | hold_flush | flushing);

  //State Machine
  always @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) begin
      memfsm_state <= ARMED;
      flushing     <= 1'b0;
      filling      <= 1'b0;
      biucmd       <= NOP;
    end else begin
      case (memfsm_state)
        ARMED:
        if ((flush_i || hold_flush) && !(mem_vreq_i && mem_we_i) && !(mem_vreq_dly && mem_we_dly && (mem_preq_i || mem_preq_dly))) begin
          memfsm_state <= FLUSH;
          flushing     <= 1'b1;
        end else if (mem_vreq_dly && !cache_hit && (mem_preq_i || mem_preq_dly)) begin  //it takes 1 cycle to read TAG
          if (tag_out_valid[onehot2int(fill_way_select)] && tag_out_dirty[onehot2int(fill_way_select)]) begin
            //selected way is dirty, write back to upstream
            memfsm_state <= WAIT4BIUCMD1;
            biucmd       <= READ_WAY;
            filling      <= 1'b1;
          end else begin
            //selected way not dirty, overwrite
            memfsm_state <= WAIT4BIUCMD0;
            biucmd       <= READ_WAY;
            filling      <= 1'b1;
          end
        end else begin
          biucmd <= NOP;
        end

        FLUSH:
        if (|tag_dirty) begin
          //There are dirty ways in this set
          //TODO
          //First determine dat_idx; this reads all ways for that index (FLUSH)
          //then check which ways are dirty (FLUSHWAYS)
          //write dirty way
          //clear dirty bit
          memfsm_state <= FLUSHWAYS;
        end else begin
          memfsm_state <= RECOVER;  //allow to read new tag_idx
          flushing     <= 1'b0;
        end
        FLUSHWAYS: begin
          //assert WRITE_WAY here (instead of in FLUSH) to allow time to load evict_buffer
          biucmd <= WRITE_WAY;

          if (biufsm_ack) begin
            //Check if there are more dirty ways in this set
            if (~|way_dirty) begin
              memfsm_state <= FLUSH;
              biucmd       <= NOP;
            end
          end
        end
        //TODO: Can we merge WAIT4BIUCMD0 and WAIT4BIUCMD1?
        WAIT4BIUCMD1:
        if (biufsm_err) begin
          //if tag_idx already selected, go to ARMED
          //otherwise go to RECOVER to read tag (1 cycle delay)
          memfsm_state <= ((mem_preq_dly && mem_we_dly) ? write_buffer_idx : vadr_idx) != tag_idx_hold ? RECOVER : ARMED;
          biucmd       <= WRITE_WAY;
          filling      <= 1'b0;
        end else if (biufsm_ack) begin  //wait for READ_WAY to complete
          //if tag_idx already selected, go to ARMED
          //otherwise go to recover to read tag (1 cycle delay)
          memfsm_state <= ((mem_preq_dly && mem_we_dly) ? write_buffer_idx : vadr_idx) != tag_idx_hold ? RECOVER : ARMED;
          biucmd       <= WRITE_WAY;
          filling      <= 1'b0;
        end
        WAIT4BIUCMD0:
        if (biufsm_err) begin
          memfsm_state <= ((mem_preq_dly && mem_we_dly) ? write_buffer_idx : vadr_idx) != tag_idx_hold ? RECOVER : ARMED;
          biucmd       <= NOP;
          filling      <= 1'b0;
        end else if (biufsm_ack) begin
          memfsm_state <= ((mem_preq_dly && mem_we_dly) ? write_buffer_idx : vadr_idx) != tag_idx_hold ? RECOVER : ARMED;
          biucmd       <= NOP;
          filling      <= 1'b0;
        end
        RECOVER: begin
          //Allow DATA memory read after writing/filling
          memfsm_state <= ARMED;
          biucmd       <= NOP;
          filling      <= 1'b0;
        end
      endcase
    end
  end

  //address check, used in a few places
  assign biu_adro_eq_cache_adr_dly = (biu_adro_i[PLEN-1:BURST_LSB] == mem_padr_i[PLEN-1:BURST_LSB]);

  //dat/tag index during flushing
  assign flush_idx                 = get_dirty_set_idx;

  //return which SET has dirty WAYs
  generate
    for (set = 0; set < SETS; set = set + 1) begin
      assign dirty_sets[set] = |{tag_dirty[1][set], tag_dirty[0][set]};
    end
  endgenerate

  generate
    for (set = 0; set < SETS; set = set + 1) begin
      always @(*) begin
        if (dirty_sets[set]) get_dirty_set_idx <= set;
        else get_dirty_set_idx <= 0;
      end
    end
  endgenerate

  //signal downstream that data is ready
  always @(*) begin
    case (memfsm_state)
      ARMED:        mem_ack_o = mem_vreq_dly & cache_hit & (mem_preq_i | mem_preq_dly);  //cache_hit
      WAIT4BIUCMD1: mem_ack_o = biu_ack_i & biu_adro_eq_cache_adr_dly;
      WAIT4BIUCMD0: mem_ack_o = biu_ack_i & biu_adro_eq_cache_adr_dly;
      default:      mem_ack_o = 1'b0;
    endcase
  end

  //signal downstream the BIU reported an error
  assign mem_err_o = biu_err_i;

  //Assign mem_q
  always @(*) begin
    case (memfsm_state)
      WAIT4BIUCMD1: mem_q_o = biu_q_i;
      WAIT4BIUCMD0: mem_q_o = biu_q_i;
      default:      mem_q_o = cache_q;
    endcase
  end

  //----------------------------------------------------------------
  // End Memory Interface State Machine
  //----------------------------------------------------------------

  //----------------------------------------------------------------
  // TAG and Data memory
  //----------------------------------------------------------------

  //TAG
  generate
    for (way = 0; way < DCACHE_WAYS; way = way + 1) begin : gen_ways_tag
      //TAG is stored in RAM
      pu_riscv_ram_1rw #(
        .ABITS     (IDX_BITS),
        .DBITS     (TAG_BITS),
        .TECHNOLOGY(TECHNOLOGY)
      ) tag_ram (
        .rst_ni(rst_ni),
        .clk_i (clk_i),
        .addr_i(tag_idx),
        .we_i  (tag_we[way]),
        .be_i  ({(TAG_BITS + 7) / 8{1'b1}}),
        .din_i (tag_in_tag[way]),
        .dout_o(tag_out_tag[way])
      );

      //tag-register for bypass (RAW hazard)
      always @(posedge clk_i) begin
        if (tag_we[way]) begin
          tag_byp_tag[way] <= tag_in_tag[way];
          tag_byp_idx[way] <= tag_idx;
        end
      end

      //Valid is stored in DFF
      always @(posedge clk_i, negedge rst_ni) begin
        if (!rst_ni) tag_valid[way][tag_idx] <= 1'h0;
        else if (tag_we[way]) tag_valid[way][tag_idx] <= tag_in_valid[way];
      end

      assign tag_out_valid[way] = tag_valid[way][tag_idx_dly];

      //Dirty is stored in DFF
      always @(posedge clk_i, negedge rst_ni) begin
        if (!rst_ni) tag_dirty[way][tag_dirty_write_idx] <= 1'h0;
        else if (tag_we_dirty[way]) tag_dirty[way][tag_dirty_write_idx] <= tag_in_dirty[way];
      end

      assign tag_out_dirty[way] = tag_dirty[way][tag_idx_dly];

      //extract 'dirty' from tag
      assign way_dirty[way]     = tag_out_dirty[way];

      //compare way-tag to TAG
      assign way_hit[way]       = tag_out_valid[way] & (core_tag == (tag_idx_dly == tag_byp_idx[way] ? tag_byp_tag[way] : tag_out_tag[way]));
    end
  endgenerate

  // Generate 'hit'
  assign cache_hit     = |way_hit;  // & mem_vreq_dly;

  //DATA

  //pipelined write buffer
  assign dat_we_enable = (mem_vreq_i & mem_we_i) | ~mem_vreq_i;  //enable writing to data memory

  always @(posedge clk_i) begin
    write_buffer_was_write <= (mem_vreq_i & mem_we_i);
  end

  always @(posedge clk_i) begin
    if (mem_vreq_i && mem_we_i) begin  //must store during vreq, otherwise data gets lost
      write_buffer_idx  <= vadr_idx;
      write_buffer_data <= mem_d_i;
      write_buffer_be   <= mem_be;
    end
  end

  always @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) write_buffer_hit <= 'h0;
    else if (write_buffer_was_write) write_buffer_hit <= way_hit & {DCACHE_WAYS{mem_preq_i}};  //store current transaction's hit, qualify with preq
    else if (dat_we_enable) write_buffer_hit <= 'h0;  //data written into RAM
  end

  always @(posedge clk_i) begin
    if (write_buffer_was_write && mem_preq_i) write_buffer_adr <= mem_padr_i;
  end

  generate
    for (way = 0; way < DCACHE_WAYS; way = way + 1) begin : gen_ways_dat
      pu_riscv_ram_1rw #(
        .ABITS     (IDX_BITS),
        .DBITS     (BLK_BITS),
        .TECHNOLOGY(TECHNOLOGY)
      ) data_ram (
        .rst_ni(rst_ni),
        .clk_i (clk_i),
        .addr_i(dat_idx),
        .we_i  (dat_we[way]),
        .be_i  (dat_be),
        .din_i (dat_in),
        .dout_o(dat_out[way])
      );

      //assign way_q; Build MUX (AND/OR) structure
      if (way == 0) assign way_q_mux[way] = dat_out[way] & {BLK_BITS{way_hit[way]}};
      else assign way_q_mux[way] = (dat_out[way] & {BLK_BITS{way_hit[way]}}) | way_q_mux[way - 1];
    end
  endgenerate

  //get requested data (XLEN-size) from way_q_mux(BLK_BITS-size)
  assign way_q = way_q_mux[DCACHE_WAYS-1] >> (dat_offset * XLEN);


  assign in_biubuffer = mem_preq_dly ? (biu_adri_hold[PLEN-1:BLK_OFF_BITS] == mem_padr_dly[PLEN-1:BLK_OFF_BITS]) & (biu_buffer_valid >> dat_offset)
                                     : (biu_adri_hold[PLEN-1:BLK_OFF_BITS] == mem_padr_i  [PLEN-1:BLK_OFF_BITS]) & (biu_buffer_valid >> dat_offset);

  assign in_writebuffer = (mem_padr_i == write_buffer_adr) & |write_buffer_hit;

  assign cache_q = in_biubuffer ? biu_buffer >> (dat_offset * XLEN) : in_writebuffer ? be_mux(write_buffer_be, way_q, write_buffer_data) : way_q;

  //----------------------------------------------------------------
  // END TAG and Data memory
  //----------------------------------------------------------------

  //----------------------------------------------------------------
  // TAG and Data memory control signals
  //----------------------------------------------------------------

  //Random generator for RANDOM replacement algorithm
  always @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) way_random <= 'h0;
    else if (!filling) way_random <= {way_random, way_random[19] ~^ way_random[16]};
  end

  //select which way to fill
  assign fill_way_select = (DCACHE_WAYS == 1) ? 1 : 1 << way_random[$clog2(DCACHE_WAYS)-1:0];

  //FILL / WRITE_WAYS use fill_way_select 1 cycle later
  always @(posedge clk_i) begin
    case (memfsm_state)
      ARMED:   fill_way_select_hold <= fill_way_select;
      default: ;
    endcase
  end

  //TAG Index
  always @(*) begin
    case (memfsm_state)
      //TAG write
      WAIT4BIUCMD1: tag_idx = tag_idx_hold;
      WAIT4BIUCMD0: tag_idx = tag_idx_hold;

      //TAG read
      FLUSH:     tag_idx = flush_idx;
      FLUSHWAYS: tag_idx = flush_idx;
      RECOVER:   tag_idx = mem_vreq_dly ? vadr_dly_idx  //pending access
 : vadr_idx;  //new access
      default:   tag_idx = vadr_idx;  //current access
    endcase
  end

  always @(*) begin
    case (memfsm_state)
      //TAG write
      WAIT4BIUCMD1: tag_dirty_write_idx = tag_idx_dly;
      WAIT4BIUCMD0: tag_dirty_write_idx = tag_idx_dly;
      default:      tag_dirty_write_idx = (mem_preq_dly && mem_we_dly) ? write_buffer_idx : tag_idx_dly;
    endcase
  end

  //registered version, for tag_valid/dirty
  always @(posedge clk_i) begin
    tag_idx_dly <= tag_idx;
  end

  //hold tag-idx; prevent new mem_vreq_i from messing up tag during filling
  always @(posedge clk_i) begin
    case (memfsm_state)
      ARMED:   if (mem_vreq_dly && !cache_hit) tag_idx_hold <= vadr_dly_idx;
      RECOVER: tag_idx_hold <= mem_vreq_dly ? vadr_dly_idx  //pending access
 : vadr_idx;  //current access
      default: ;
    endcase
  end

  generate
    //TAG Write Enable
    //Update tag
    // 1. during flushing    (clear valid/dirty bits)
    // 2. during cache-write (set dirty bit)
    for (way = 0; way < DCACHE_WAYS; way = way + 1) begin : gen_way_we
      always @(*) begin
        case (memfsm_state)
          default: tag_we[way] = filling & fill_way_select_hold[way] & biufsm_ack;
        endcase
      end

      always @(*) begin
        case (memfsm_state)
          ARMED:   tag_we_dirty[way] = way_hit[way] & ((mem_vreq_dly & mem_we_dly & mem_preq_i) | (mem_preq_dly & mem_we_dly));
          default: tag_we_dirty[way] = (filling & fill_way_select_hold[way] & biufsm_ack) | (flushing & write_evict_buffer & (get_dirty_way_idx == way));
        endcase
      end
    end

    //TAG Write Data
    for (way = 0; way < DCACHE_WAYS; way = way + 1) begin : gen_tag
      //clear valid tag during cache-coherency checks
      assign tag_in_valid[way] = 1'b1;  //~flushing;

      //set dirty bit when
      // 1. read new line from memory and data in new line is overwritten
      // 2. during a write to a valid line
      //clear dirty bit when flushing
      assign tag_in_tag[way]   = core_tag_hold;

      always @(*) begin
        case (biufsm_ack)
          1: tag_in_dirty[way] = biu_buffer_dirty | (mem_we_dly & biu_adro_eq_cache_adr_dly);
          0: tag_in_dirty[way] = ~flushing & mem_we_dly;
        endcase
      end
    end
  endgenerate

  //Shift amount for data
  assign dat_offset     = mem_vadr_dly[BLK_OFF_BITS-1 -: DAT_OFF_BITS];

  //Riviera bug workaround
  assign pwb_adr        = write_buffer_adr;
  assign pwb_dat_offset = (write_buffer_was_write && mem_preq_i) ? mem_padr_i[BLK_OFF_BITS-1 -: DAT_OFF_BITS] : pwb_adr[BLK_OFF_BITS-1 -: DAT_OFF_BITS];
  //TODO: Can't we use vadr?

  //DAT Byte Enable
  assign dat_be         = biufsm_ack ? {BLK_BITS / 8{1'b1}} : write_buffer_be << (pwb_dat_offset * XLEN / 8);

  //DAT Index
  always @(*) begin
    case (memfsm_state)
      ARMED:     dat_idx = dat_we_enable ? write_buffer_idx  //write old 'write-data'
 : vadr_idx;  //read access
      RECOVER:   dat_idx = mem_vreq_dly ? vadr_dly_idx  //read pending cycle
 : vadr_idx;  //read new access
      FLUSH:     dat_idx = flush_idx;
      FLUSHWAYS: dat_idx = flush_idx;
      default:   dat_idx = tag_idx_hold;
    endcase
  end

  //delayed dat_idx
  always @(posedge clk_i) begin
    dat_idx_dly <= dat_idx;
  end

  generate
    //DAT Write Enable
    for (way = 0; way < DCACHE_WAYS; way = way + 1) begin : gen_dat_we
      always @(*) begin
        case (memfsm_state)
          WAIT4BIUCMD0: dat_we[way] = fill_way_select_hold[way] & biufsm_ack;  //write BIU data
          WAIT4BIUCMD1: dat_we[way] = fill_way_select_hold[way] & biufsm_ack;
          RECOVER:      dat_we[way] = 1'b0;

          //current cycle and previous cycle are writes, no time to write 'hit' into write buffer, use way_hit directly
          //current access is a write and there's still a write request pending (e.g. write during READ_WAY), use way_hit directly
          default: dat_we[way] = dat_we_enable & ((write_buffer_was_write && mem_preq_i) || (mem_preq_dly && mem_we_dly) ? way_hit[way] : write_buffer_hit[way]);
        endcase
      end
    end
  endgenerate

  //DAT Write Data
  always @(*) begin
    case (biufsm_ack)
      1: begin
        dat_in                                                            = biu_buffer;  //dat_in = biu_buffer
        dat_in[biu_adro_i[BLK_OFF_BITS-1 -: DAT_OFF_BITS] * XLEN +: XLEN] = biu_q;  //except for last transaction
      end
      0: dat_in = {BURST_SIZE{write_buffer_data}};  //dat_in = write-data over all words
      //dat_be gates writing
    endcase
  end

  //----------------------------------------------------------------
  // TAG and Data memory control signals
  //----------------------------------------------------------------

  //----------------------------------------------------------------
  // Bus Interface State Machine
  //----------------------------------------------------------------
  assign biu_lock_o = 1'b0;
  assign biu_prot_o = (mem_prot_i | PROT_CACHEABLE);

  always @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) begin
      biufsm_state <= IDLE;
    end else begin
      case (biufsm_state)
        IDLE:
        case (biucmd)
          NOP: ;  //do nothing
          READ_WAY: begin
            //read a way from main memory
            if (biu_stb_ack_i) begin
              biufsm_state <= BURST;
            end else begin
              //BIU is not ready to start a new transfer
              biufsm_state <= WAIT4BIU;
            end
          end

          WRITE_WAY: begin
            //write way back to main memory
            if (biu_stb_ack_i) begin
              biufsm_state <= BURST;
            end else begin
              //BIU is not ready to start a new transfer
              biufsm_state <= WAIT4BIU;
            end
          end
        endcase
        WAIT4BIU:
        if (biu_stb_ack_i) begin
          //BIU acknowledged burst transfer
          biufsm_state <= BURST;
        end
        BURST:
        if (biu_err_i || (~|burst_cnt && biu_ack_i)) begin
          //write complete
          biufsm_state <= IDLE;  //TODO: detect if another BURST request is pending, skip IDLE
        end
      endcase
    end
  end

  //handle writing bits in read-cache-line
  assign biu_q = mem_we_dly && biu_adro_eq_cache_adr_dly ? be_mux(mem_be_dly, biu_q_i, mem_d_dly) : biu_q_i;

  //write data
  always @(posedge clk_i) begin
    case (biufsm_state)
      IDLE: begin
        if (biucmd == WRITE_WAY) biu_buffer <= evict_buffer_data >> XLEN;  //first XLEN bits went out already
        biu_buffer_valid <= 'h0;
        biu_buffer_dirty <= 1'b0;
      end

      BURST: begin
        if (!biu_we_hold) begin
          if (biu_ack_i) begin  //latch incoming data when transfer-acknowledged
            biu_buffer[biu_adro_i[BLK_OFF_BITS-1 -: DAT_OFF_BITS] * XLEN +: XLEN] <= biu_q;
            biu_buffer_valid[biu_adro_i[BLK_OFF_BITS-1 -: DAT_OFF_BITS]]          <= 1'b1;
            biu_buffer_dirty                                                      <= biu_buffer_dirty | (mem_we_dly & biu_adro_eq_cache_adr_dly);
          end
        end else begin
          if (biu_d_ack_i) begin  //present new data when previous transfer acknowledged
            biu_buffer       <= biu_buffer >> XLEN;
            biu_buffer_valid <= 'h0;
            biu_buffer_dirty <= 1'b0;
          end
        end
      end
      default: ;
    endcase
  end

  //store dirty line in evict buffer
  //TODO: change name
  always @(posedge clk_i) begin
    is_read_way <= (biucmd == READ_WAY) || (memfsm_state == FLUSH) || (memfsm_state == FLUSHWAYS & biufsm_ack & |way_dirty);
  end

  always @(posedge clk_i) begin
    is_read_way_dly <= is_read_way;
  end

  //ARMED: write evict buffer 1 cycle after starting READ_WAY. That ensures DAT and TAG are valid
  //        and there no new data from the BIU yet
  //FLUSH: write evict buffer when entering FLUSHWAYS state and as long as current SET has dirty WAYs.
  assign write_evict_buffer = is_read_way & ~is_read_way_dly;

  always @(posedge clk_i) begin
    if (write_evict_buffer) begin
      evict_buffer_adr  <= flushing ? {tag_out_tag[get_dirty_way_idx], flush_idx, {BLK_OFF_BITS{1'b0}}} : {tag_out_tag[onehot2int(fill_way_select_hold)], padr_dly_idx, {BLK_OFF_BITS{1'b0}}};
      evict_buffer_data <= flushing ? dat_out[get_dirty_way_idx] : dat_out[onehot2int(fill_way_select_hold)];
    end
  end

  //return next dirty WAY in dirty SET
  generate
    for (way = 0; way < DCACHE_WAYS; way = way + 1) begin
      always @(*) begin
        if (tag_dirty[way][flush_idx]) get_dirty_way_idx = way;
        else get_dirty_way_idx = 0;
      end
    end
  endgenerate

  //acknowledge burst to memfsm
  always @(*) begin
    case (biufsm_state)
      BURST:   biufsm_ack = (~|burst_cnt & biu_ack_i & (~biu_we_hold | flushing)) | biu_err_i;
      default: biufsm_ack = 1'b0;
    endcase
  end

  always @(posedge clk_i) begin
    case (biufsm_state)
      IDLE: begin
        case (biucmd)
          READ_WAY: burst_cnt <= {BURST_BITS{1'b1}};
          WRITE_WAY: burst_cnt <= {BURST_BITS{1'b1}};
        endcase
      end
      BURST: begin
        if (biu_ack_i) begin
          burst_cnt <= burst_cnt - 1;
        end
      end
    endcase
  end

  assign biufsm_err = biu_err_i;

  //output BIU signals asynchronously for speed reasons. BIU will synchronize ...
  always @(*) begin
    case (biufsm_state)
      IDLE:
      case (biucmd)
        NOP: begin
          biu_stb_o  = 1'b0;
          biu_we_o   = 1'bx;
          biu_adri_o = 'hx;
          biu_d_o    = 'hx;
        end
        READ_WAY: begin
          biu_stb_o  = 1'b1;
          biu_we_o   = 1'b0;  //read
          biu_adri_o = {mem_padr_dly[PLEN-1 : BURST_LSB], {BURST_LSB{1'b0}}};
          biu_d_o    = 'hx;
        end
        WRITE_WAY: begin
          biu_stb_o  = 1'b1;
          biu_we_o   = 1'b1;
          biu_adri_o = evict_buffer_adr;
          biu_d_o    = evict_buffer_data[XLEN-1:0];
        end
      endcase
      WAIT4BIU: begin
        //stretch biu_*_o signals until BIU acknowledges strobe
        biu_stb_o  = 1'b1;
        biu_we_o   = biu_we_hold;
        biu_adri_o = biu_adri_hold;
        biu_d_o    = evict_buffer_data[XLEN-1:0];  //retain same data
      end
      BURST: begin
        biu_stb_o  = 1'b0;
        biu_we_o   = 1'bx;  //don't care
        biu_adri_o = 'hx;  //don't care
        biu_d_o    = biu_buffer[0 +: XLEN];
      end
      default: begin
        biu_stb_o  = 1'b0;
        biu_we_o   = 1'bx;  //don't care
        biu_adri_o = 'hx;  //don't care
        biu_d_o    = 'hx;  //don't care
      end
    endcase
  end

  //store biu_we/adri/d used when stretching biu_stb
  always @(posedge clk_i) begin
    if (biufsm_state == IDLE) begin
      biu_we_hold   <= biu_we_o;
      biu_adri_hold <= biu_adri_o;
      biu_d_hold    <= biu_d_o;
    end
  end

  //transfer size
  assign biu_size_o = XLEN == 64 ? DWORD : WORD;

  //burst length
  assign biu_type_o = BURST_SIZE == 16 ? WRAP16 : BURST_SIZE == 8 ? WRAP8 : WRAP4;
endmodule
