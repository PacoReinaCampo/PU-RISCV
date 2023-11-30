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
//              Core - Instruction Cache (Write Back)                         //
//              AMBA3 AHB-Lite Bus Interface                                  //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2017-2018 by the author(s)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////
// Author(s):
//   Paco Reina Campo <pacoreinacampo@queenfield.tech>

import peripheral_biu_verilog_pkg::*;

module pu_riscv_icache_core #(
  parameter XLEN = 64,
  parameter PLEN = 64,

  parameter PARCEL_SIZE = 64,

  parameter ICACHE_SIZE        = 64,
  parameter ICACHE_BLOCK_SIZE  = 64,
  parameter ICACHE_WAYS        = 2,
  parameter ICACHE_REPLACE_ALG = 0,

  parameter TECHNOLOGY = "GENERIC"
) (
  input wire rst_ni,
  input wire clk_i,
  input wire clr_i,   // clear any pending request

  // CPU side
  input  wire                   mem_vreq_i,
  input  wire                   mem_preq_i,
  input  wire [XLEN       -1:0] mem_vadr_i,
  input  wire [PLEN       -1:0] mem_padr_i,
  input  wire [            2:0] mem_size_i,
  input                         mem_lock_i,
  input  wire [            2:0] mem_prot_i,
  output reg  [PARCEL_SIZE-1:0] mem_q_o,
  output reg                    mem_ack_o,
  output reg                    mem_err_o,
  input  wire                   flush_i,
  input  wire                   flushrdy_i,

  // To BIU
  output reg                    biu_stb_o,      // access request
  input  wire                   biu_stb_ack_i,  // access acknowledge
  input  wire                   biu_d_ack_i,    // BIU needs new data (biu_d_o)
  output reg  [PLEN       -1:0] biu_adri_o,     // access start address
  input  wire [PLEN       -1:0] biu_adro_i,
  output reg  [            2:0] biu_size_o,     // transfer size
  output reg  [            2:0] biu_type_o,     // burst type
  output reg                    biu_lock_o,     // locked transfer
  output reg  [            2:0] biu_prot_o,     // protection bits
  output reg                    biu_we_o,       // write enable
  output reg  [XLEN       -1:0] biu_d_o,        // write data
  input  wire [XLEN       -1:0] biu_q_i,        // read data
  input  wire                   biu_ack_i,      // transfer acknowledge
  input  wire                   biu_err_i       // transfer error
);

  //////////////////////////////////////////////////////////////////////////////
  // Constants
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////
  // Cache
  //////////////////////////////////////////////////////////////////////////////
  localparam PAGE_SIZE = 4 * 1024;  // 4KB pages
  localparam MAX_IDX_BITS = $clog2(PAGE_SIZE) - $clog2(ICACHE_BLOCK_SIZE);  // Maximum IDX_BITS

  localparam SETS = (ICACHE_SIZE * 1024) / ICACHE_BLOCK_SIZE / ICACHE_WAYS;  // Number of sets TO-DO:SETS=1 doesn't work
  localparam BLK_OFF_BITS = $clog2(ICACHE_BLOCK_SIZE);  // Number of BlockOffset bits
  localparam IDX_BITS = $clog2(SETS);  // Number of Index-bits
  localparam TAG_BITS = XLEN - IDX_BITS - BLK_OFF_BITS;  // Number of TAG-bits
  localparam BLK_BITS = 8 * ICACHE_BLOCK_SIZE;  // Total number of bits in a Block
  localparam BURST_SIZE = BLK_BITS / XLEN;  // Number of transfers to load 1 Block
  localparam BURST_BITS = $clog2(BURST_SIZE);
  localparam BURST_OFF = XLEN / 8;
  localparam BURST_LSB = $clog2(BURST_OFF);

  // BLOCK decoding
  localparam DAT_OFF_BITS = $clog2(BLK_BITS / XLEN);  // Offset in block
  localparam PARCEL_OFF_BITS = $clog2(XLEN / PARCEL_SIZE);

  //////////////////////////////////////////////////////////////////////////////
  // Functions
  //////////////////////////////////////////////////////////////////////////////

  function automatic [XLEN/8-1:0] size2be;
    input [2:0] size;
    input [XLEN-1:0] adr;

    logic [$clog2(XLEN/8)-1:0] adr_lsbs;

    adr_lsbs = adr[$clog2(XLEN/8)-1:0];

    case (size)
      BYTE: begin
        size2be = 'h1 << adr_lsbs;
      end
      HWORD: begin
        size2be = 'h3 << adr_lsbs;
      end
      WORD: begin
        size2be = 'hf << adr_lsbs;
      end
      DWORD: begin
        size2be = 'hff << adr_lsbs;
      end
      default: begin
      end
    endcase
  endfunction

  //////////////////////////////////////////////////////////////////////////////
  // Constants
  //////////////////////////////////////////////////////////////////////////////

  localparam ARMED = 0;
  localparam FLUSH = 1;
  localparam WAIT4BIUCMD0 = 2;
  localparam RECOVER = 4;

  localparam [1:0] IDLE = 2'b00;
  localparam [1:0] WAIT4BIU = 2'b01;
  localparam [1:0] BURST = 2'b10;

  localparam NOP = 0;
  localparam WRITE_WAY = 1;
  localparam READ_WAY = 2;

  //////////////////////////////////////////////////////////////////////////////
  // Variables
  //////////////////////////////////////////////////////////////////////////////

  genvar way;
  integer                                            n;

  // Memory Interface State Machine Section
  logic                                              mem_vreq_dly;
  logic                                              mem_preq_dly;
  logic   [XLEN                  -1:0]               mem_vadr_dly;
  logic   [PLEN                  -1:0]               mem_padr_dly;
  logic   [XLEN/8                -1:0]               mem_be;
  logic   [XLEN/8                -1:0]               mem_be_dly;

  logic   [TAG_BITS              -1:0]               core_tag;
  logic   [TAG_BITS              -1:0]               core_tag_hold;

  logic                                              hold_flush;  // stretch flush_i until FSM is ready to serve

  logic   [                       2:0]               memfsm_state;

  // Cache Section
  logic   [IDX_BITS              -1:0]               tag_idx;
  logic   [IDX_BITS              -1:0]               tag_idx_dly;  // delayed version for writing valid/dirty
  logic   [IDX_BITS              -1:0]               tag_idx_hold;  // stretched version for writing TAG during fill
  logic   [IDX_BITS              -1:0]               vadr_idx;  // index bits extracted from vadr_i
  logic   [IDX_BITS              -1:0]               vadr_dly_idx;  // index bits extracted from vadr_dly
  logic   [IDX_BITS              -1:0]               padr_idx;
  logic   [IDX_BITS              -1:0]               padr_dly_idx;

  logic   [ICACHE_WAYS           -1:0]               tag_we;

  logic   [ICACHE_WAYS           -1:0]               tag_in_valid;
  logic   [ICACHE_WAYS           -1:0][TAG_BITS-1:0] tag_in_tag;

  logic   [ICACHE_WAYS           -1:0]               tag_out_valid;
  logic   [ICACHE_WAYS           -1:0][TAG_BITS-1:0] tag_out_tag;

  logic   [ICACHE_WAYS           -1:0][IDX_BITS-1:0] tag_byp_idx;
  logic   [ICACHE_WAYS           -1:0][TAG_BITS-1:0] tag_byp_tag;
  logic   [ICACHE_WAYS           -1:0][SETS    -1:0] tag_valid;

  logic   [IDX_BITS              -1:0]               dat_idx;
  logic   [IDX_BITS              -1:0]               dat_idx_dly;
  logic   [ICACHE_WAYS           -1:0]               dat_we;
  logic   [BLK_BITS/8            -1:0]               dat_be;
  logic   [BLK_BITS              -1:0]               dat_in;
  logic   [ICACHE_WAYS           -1:0][BLK_BITS-1:0] dat_out;

  logic   [ICACHE_WAYS           -1:0][BLK_BITS-1:0] way_q_mux;
  logic   [ICACHE_WAYS           -1:0]               way_hit;

  logic   [DAT_OFF_BITS          -1:0]               dat_offset;
  logic   [       PARCEL_OFF_BITS : 0]               parcel_offset;

  logic                                              cache_hit;
  logic   [XLEN                  -1:0]               cache_q;

  logic   [                      19:0]               way_random;
  logic   [ICACHE_WAYS           -1:0]               fill_way_select;
  logic   [ICACHE_WAYS           -1:0]               fill_way_select_hold;

  logic                                              biu_adro_eq_cache_adr_dly;
  logic                                              flushing;
  logic                                              filling;
  logic   [IDX_BITS              -1:0]               flush_idx;

  // Bus Interface State Machine Section
  logic   [                       1:0]               biufsm_state;

  logic   [                       1:0]               biucmd;

  logic                                              biufsm_ack;
  logic                                              biufsm_err;
  logic                                              biufsm_ack_write_way;  // BIU FSM should generate biufsm_ack on WRITE_WAY
  logic   [BLK_BITS              -1:0]               biu_buffer;
  logic   [BURST_SIZE            -1:0]               biu_buffer_valid;
  logic                                              in_biubuffer;

  logic   [PLEN                  -1:0]               biu_adri_hold;
  logic   [XLEN                  -1:0]               biu_d_hold;

  logic   [BURST_BITS            -1:0]               burst_cnt;

  //////////////////////////////////////////////////////////////////////////////
  // Module Body
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////
  // Memory Interface State Machine
  //////////////////////////////////////////////////////////////////////////////

  // generate cache_* signals
  assign mem_be = size2be(mem_size_i, mem_vadr_i);

  // generate delayed mem_* signals
  always @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) begin
      mem_vreq_dly <= 1'b0;
    end else if (clr_i) begin
      mem_vreq_dly <= 1'b0;
    end else begin
      mem_vreq_dly <= mem_vreq_i | (mem_vreq_dly & ~mem_ack_o);
    end
  end

  always @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) begin
      mem_preq_dly <= 1'b0;
    end else if (clr_i) begin
      mem_preq_dly <= 1'b0;
    end else begin
      mem_preq_dly <= (mem_preq_i | mem_preq_dly) & ~mem_ack_o;
    end
  end

  // register memory signals
  always @(posedge clk_i) begin
    if (mem_vreq_i) begin
      mem_vadr_dly <= mem_vadr_i;
      mem_be_dly   <= mem_be;
    end
  end

  always @(posedge clk_i) begin
    if (mem_preq_i) begin
      mem_padr_dly <= mem_padr_i;
    end
  end

  // extract index bits from virtual address(es)
  assign vadr_idx     = mem_vadr_i[BLK_OFF_BITS +: IDX_BITS];
  assign vadr_dly_idx = mem_vadr_dly[BLK_OFF_BITS +: IDX_BITS];
  assign padr_idx     = mem_padr_i[BLK_OFF_BITS +: IDX_BITS];
  assign padr_dly_idx = mem_padr_dly[BLK_OFF_BITS +: IDX_BITS];

  // extract core_tag from physical address
  assign core_tag     = mem_padr_i[XLEN-1 -: TAG_BITS];

  // hold core_tag during filling. Prevents new mem_req (during fill) to mess up the 'tag' value
  always @(posedge clk_i) begin
    if (!filling) begin
      core_tag_hold <= core_tag;
    end
  end

  // hold flush until ready to service it
  always @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) begin
      hold_flush <= 1'b0;
    end else begin
      hold_flush <= ~flushing & (flush_i | hold_flush);
    end
  end

  // State Machine
  always @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) begin
      memfsm_state <= ARMED;
      flushing     <= 1'b0;
      filling      <= 1'b0;
      biucmd       <= NOP;
    end else begin
      case (memfsm_state)
        ARMED: begin
          if (flush_i || hold_flush) begin
            memfsm_state <= FLUSH;
            flushing     <= 1'b1;
          end else if (mem_vreq_dly && !cache_hit && (mem_preq_i || mem_preq_dly)) begin  // it takes 1 cycle to read TAG
            // Load way
            memfsm_state <= WAIT4BIUCMD0;
            biucmd       <= READ_WAY;
            filling      <= 1'b1;
          end else begin
            biucmd <= NOP;
          end
        end
        FLUSH: begin
          if (flushrdy_i) begin
            memfsm_state <= RECOVER;  // allow to read new tag_idx
            flushing     <= 1'b0;
          end
        end
        WAIT4BIUCMD0: begin
          if (biufsm_err) begin
            memfsm_state <= vadr_idx != tag_idx_hold ? RECOVER : ARMED;
            biucmd       <= NOP;
            filling      <= 1'b0;
          end else if (biufsm_ack) begin
            memfsm_state <= vadr_idx != tag_idx_hold ? RECOVER : ARMED;
            biucmd       <= NOP;
            filling      <= 1'b0;
          end
        end
        RECOVER: begin
          // Allow DATA memory read after writing/filling
          memfsm_state <= ARMED;
          biucmd       <= NOP;
          filling      <= 1'b0;
        end
      endcase
    end
  end

  // address check, used in a few places
  assign biu_adro_eq_cache_adr_dly = (biu_adro_i[PLEN-1:BURST_LSB] == mem_padr_i[PLEN-1:BURST_LSB]);

  // signal downstream that data is ready
  always @(*) begin
    case (memfsm_state)
      ARMED:        mem_ack_o = mem_vreq_dly & (mem_preq_i | mem_preq_dly) & cache_hit;
      WAIT4BIUCMD0: mem_ack_o = mem_vreq_dly & (mem_preq_i | mem_preq_dly) & biu_ack_i & biu_adro_eq_cache_adr_dly;
      default:      mem_ack_o = 1'b0;
    endcase
  end

  // signal downstream the BIU reported an error
  assign mem_err_o     = biu_err_i;

  // Assign mem_q
  // biu_q_i and cache_q are XLEN size. If PARCEL_SIZE is smaller, adjust
  assign parcel_offset = mem_vadr_dly[1 + PARCEL_OFF_BITS : 1];  // [1 +: PARCEL_OFF_BITS] errors out

  always @(*) begin
    case (memfsm_state)
      WAIT4BIUCMD0: mem_q_o = biu_q_i >> (parcel_offset * 16);
      default:      mem_q_o = cache_q >> (parcel_offset * 16);
    endcase
  end

  //////////////////////////////////////////////////////////////////////////////
  // End Memory Interface State Machine
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////
  // TAG and Data memory
  //////////////////////////////////////////////////////////////////////////////

  // TAG
  generate
    for (way = 0; way < ICACHE_WAYS; way = way + 1) begin : gen_ways_tag
      // TAG is stored in RAM
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

      // tag-register for bypass (RAW hazard)
      always @(posedge clk_i) begin
        if (tag_we[way]) begin
          tag_byp_tag[way] <= tag_in_tag[way];
          tag_byp_idx[way] <= tag_idx;
        end
      end

      // Valid is stored in DFF
      always @(posedge clk_i, negedge rst_ni) begin
        if (!rst_ni) begin
          tag_valid[way] <= 'h0;
        end else if (flush_i) begin
          tag_valid[way] <= 'h0;
        end else if (tag_we[way]) begin
          tag_valid[way] <= tag_in_valid[way];
        end
      end

      assign tag_out_valid[way] = tag_valid[way][tag_idx_dly];

      // compare way-tag to TAG;
      assign way_hit[way]       = tag_out_valid[way] & (core_tag == (tag_idx_dly == tag_byp_idx[way] ? tag_byp_tag[way] : tag_out_tag[way]));
    end
  endgenerate

  // Generate 'hit'
  assign cache_hit = |way_hit;  // & mem_vreq_dly;

  // DATA
  generate
    for (way = 0; way < ICACHE_WAYS; way = way + 1) begin : gen_ways_dat
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

      // assign way_q; Build MUX (AND/OR) structure
      if (way == 0) begin
        assign way_q_mux[way] = dat_out[way] & {BLK_BITS{way_hit[way]}};
      end else begin
        assign way_q_mux[way] = (dat_out[way] & {BLK_BITS{way_hit[way]}}) | way_q_mux[way - 1];
      end
    end
  endgenerate

  // get requested data (XLEN-size) from way_q_mux(BLK_BITS-size)
  assign in_biubuffer = mem_preq_dly ? (biu_adri_hold[PLEN-1:BLK_OFF_BITS] == mem_padr_dly[PLEN-1:BLK_OFF_BITS]) & (biu_buffer_valid >> dat_offset)
                                     : (biu_adri_hold[PLEN-1:BLK_OFF_BITS] == mem_padr_i  [PLEN-1:BLK_OFF_BITS]) & (biu_buffer_valid >> dat_offset);

  assign cache_q = (in_biubuffer ? biu_buffer : way_q_mux[ICACHE_WAYS-1]) >> (dat_offset * XLEN);

  //////////////////////////////////////////////////////////////////////////////
  // END TAG and Data memory
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////
  // TAG and Data memory control signals
  //////////////////////////////////////////////////////////////////////////////

  // Random generator for RANDOM replacement algorithm
  always @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) begin
      way_random <= 'h0;
    end else if (!filling) begin
      way_random <= {way_random, way_random[19] ~^ way_random[16]};
    end
  end

  // select which way to fill
  assign fill_way_select = (ICACHE_WAYS <= 1) ? 1 : 1 << way_random[ICACHE_WAYS-1:0];

  // FILL / WRITE_WAYS use fill_way_select 1 cycle later
  always @(posedge clk_i) begin
    case (memfsm_state)
      ARMED: begin
        fill_way_select_hold <= fill_way_select;
      end
      default: begin
      end
    endcase
  end

  // TAG Index
  always @(*) begin
    case (memfsm_state)
      // TAG write
      WAIT4BIUCMD0: tag_idx = tag_idx_hold;
      // TAG read
      FLUSH:        tag_idx = flush_idx;
      // pending access or new access
      RECOVER:      tag_idx = mem_vreq_dly ? vadr_dly_idx : vadr_idx;
      default:      tag_idx = vadr_idx;  // current access
    endcase
  end

  // registered version, for tag_valid
  always @(posedge clk_i) begin
    tag_idx_dly <= tag_idx;
  end

  // hold tag-idx; prevent new mem_vreq_i from messing up tag during filling
  always @(posedge clk_i) begin
    case (memfsm_state)
      ARMED: begin
        if (mem_vreq_dly && !cache_hit) begin
          tag_idx_hold <= vadr_dly_idx;
        end
      end
      // pending access or current access
      RECOVER: tag_idx_hold <= mem_vreq_dly ? vadr_dly_idx : vadr_idx;
      default: begin
      end
    endcase
  end

  generate
    // TAG Write Enable
    // Update tag during flushing    (clear valid bits)
    for (way = 0; way < ICACHE_WAYS; way = way + 1) begin : gen_way_we
      always @(*) begin
        case (memfsm_state)
          default: begin
            tag_we[way] = filling & fill_way_select_hold[way] & biufsm_ack;
          end
        endcase
      end
    end

    // TAG Write Data
    for (way = 0; way < ICACHE_WAYS; way = way + 1) begin : gen_tag
      // clear valid tag during flushing and cache-coherency checks
      assign tag_in_valid[way] = ~flushing;

      assign tag_in_tag[way]   = core_tag_hold;
    end
  endgenerate

  // Shift amount for data
  assign dat_offset = mem_vadr_dly[BLK_OFF_BITS-1 -: DAT_OFF_BITS];

  // DAT Byte Enable
  assign dat_be     = {BLK_BITS / 8{1'b1}};

  // DAT Index
  always @(*) begin
    case (memfsm_state)
      ARMED:   dat_idx = vadr_idx;  // read access
      // read pending cycle or read new access
      RECOVER: dat_idx = mem_vreq_dly ? vadr_dly_idx : vadr_idx;
      default: dat_idx = tag_idx_hold;
    endcase
  end

  // delayed dat_idx
  always @(posedge clk_i) begin
    dat_idx_dly <= dat_idx;
  end

  generate
    // DAT Write Enable
    for (way = 0; way < ICACHE_WAYS; way = way + 1) begin : gen_dat_we
      always @(*) begin
        case (memfsm_state)
          WAIT4BIUCMD0: begin
            dat_we[way] = fill_way_select_hold[way] & biufsm_ack;  // write BIU data
          end
          default: begin
            dat_we[way] = 1'b0;
          end
        endcase
      end
    end
  endgenerate

  // DAT Write Data
  always @(*) begin
    dat_in                                                            = biu_buffer;  // dat_in = biu_buffer
    dat_in[biu_adro_i[BLK_OFF_BITS-1 -: DAT_OFF_BITS] * XLEN +: XLEN] = biu_q_i;  // except for last transaction
  end

  //////////////////////////////////////////////////////////////////////////////
  // TAG and Data memory control signals
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////
  // Bus Interface State Machine
  //////////////////////////////////////////////////////////////////////////////
  assign biu_lock_o = 1'b0;
  assign biu_prot_o = (mem_prot_i | PROT_CACHEABLE);

  always @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) begin
      biufsm_state <= IDLE;
    end else begin
      case (biufsm_state)
        IDLE: begin
          case (biucmd)
            NOP: begin
              // do nothing
            end

            READ_WAY: begin
              // read a way from main memory
              if (biu_stb_ack_i) begin
                biufsm_state <= BURST;
              end else begin
                // BIU is not ready to start a new transfer
                biufsm_state <= WAIT4BIU;
              end
            end

            WRITE_WAY: begin
              // write way back to main memory
              if (biu_stb_ack_i) begin
                biufsm_state <= BURST;
              end else begin
                // BIU is not ready to start a new transfer
                biufsm_state <= WAIT4BIU;
              end
            end
          endcase
        end

        WAIT4BIU: begin
          if (biu_stb_ack_i) begin
            // BIU acknowledged burst transfer
            biufsm_state <= BURST;
          end
        end

        BURST: begin
          if (biu_err_i || (~|burst_cnt && biu_ack_i)) begin
            // write complete
            biufsm_state <= IDLE;  // TO-DO: detect if another BURST request is pending, skip IDLE
          end
        end
      endcase
    end
  end

  // write data
  always @(posedge clk_i) begin
    case (biufsm_state)
      IDLE: begin
        biu_buffer       <= 'h0;
        biu_buffer_valid <= 'h0;
      end
      BURST: begin
        if (biu_ack_i) begin  // latch incoming data when transfer-acknowledged
          biu_buffer[biu_adro_i[BLK_OFF_BITS-1 -: DAT_OFF_BITS] * XLEN +: XLEN] <= biu_q_i;
          biu_buffer_valid[biu_adro_i[BLK_OFF_BITS-1 -: DAT_OFF_BITS]]          <= 1'b1;
        end
      end
      default: begin
      end
    endcase
  end

  // acknowledge burst to memfsm
  always @(*) begin
    case (biufsm_state)
      BURST:   biufsm_ack = (~|burst_cnt & biu_ack_i) | biu_err_i;
      default: biufsm_ack = 1'b0;
    endcase
  end

  always @(posedge clk_i) begin
    case (biufsm_state)
      IDLE: begin
        case (biucmd)
          READ_WAY:  burst_cnt <= {BURST_BITS{1'b1}};
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

  // output BIU signals asynchronously for speed reasons. BIU will synchronize ...
  assign biu_d_o    = 'h0;
  assign biu_we_o   = 1'b0;

  always @(*) begin
    case (biufsm_state)
      IDLE: begin
        case (biucmd)
          NOP: begin
            biu_stb_o  = 1'b0;
            biu_adri_o = 'hx;
          end
          READ_WAY: begin
            biu_stb_o  = 1'b1;
            biu_adri_o = {mem_padr_dly[PLEN-1 : BURST_LSB], {BURST_LSB{1'b0}}};
          end
        endcase
      end
      WAIT4BIU: begin
        // stretch biu_*_o signals until BIU acknowledges strobe
        biu_stb_o  = 1'b1;
        biu_adri_o = biu_adri_hold;
      end
      BURST: begin
        biu_stb_o  = 1'b0;
        biu_adri_o = 'hx;  // don't care
      end
      default: begin
        biu_stb_o  = 1'b0;
        biu_adri_o = 'hx;  // don't care
      end
    endcase
  end

  // store biu_we/adri/d used when stretching biu_stb
  always @(posedge clk_i) begin
    if (biufsm_state == IDLE) begin
      biu_adri_hold <= biu_adri_o;
      biu_d_hold    <= biu_d_o;
    end
  end

  // transfer size
  assign biu_size_o = XLEN == 64 ? DWORD : WORD;

  // burst length
  assign biu_type_o = BURST_SIZE == 16 ? WRAP16 : BURST_SIZE == 8 ? WRAP8 : WRAP4;
endmodule
