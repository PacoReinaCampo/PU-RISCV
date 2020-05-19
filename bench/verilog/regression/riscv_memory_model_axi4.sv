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
//              Memory Model                                                  //
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
 *   Francisco Javier Reina Campo <frareicam@gmail.com>
 */

`include "riscv_mpsoc_pkg.sv"

module riscv_memory_model_ahb3 #(
  parameter XLEN = 64,
  parameter PLEN = 64,

  parameter BASE = 'h0,

  parameter MEM_LATENCY = 1,

  parameter LATENCY = 1,
  parameter BURST   = 8,

  parameter INIT_FILE = "test.hex"
)
  (

    input                                    HRESETn,
    input                                    HCLK,

    //AXI4 instruction
    output logic [1:0][AXI_ID_WIDTH    -1:0] axi4_aw_id,
    output logic [1:0][AXI_ADDR_WIDTH  -1:0] axi4_aw_addr,
    output logic [1:0][                 7:0] axi4_aw_len,
    output logic [1:0][                 2:0] axi4_aw_size,
    output logic [1:0][                 1:0] axi4_aw_burst,
    output logic [1:0]                       axi4_aw_lock,
    output logic [1:0][                 3:0] axi4_aw_cache,
    output logic [1:0][                 2:0] axi4_aw_prot,
    output logic [1:0][                 3:0] axi4_aw_qos,
    output logic [1:0][                 3:0] axi4_aw_region,
    output logic [1:0][AXI_USER_WIDTH  -1:0] axi4_aw_user,
    output logic [1:0]                       axi4_aw_valid,
    input  logic [1:0]                       axi4_aw_ready,

    output logic [1:0][AXI_ID_WIDTH    -1:0] axi4_ar_id,
    output logic [1:0][AXI_ADDR_WIDTH  -1:0] axi4_ar_addr,
    output logic [1:0][                 7:0] axi4_ar_len,
    output logic [1:0][                 2:0] axi4_ar_size,
    output logic [1:0][                 1:0] axi4_ar_burst,
    output logic [1:0]                       axi4_ar_lock,
    output logic [1:0][                 3:0] axi4_ar_cache,
    output logic [1:0][                 2:0] axi4_ar_prot,
    output logic [1:0][                 3:0] axi4_ar_qos,
    output logic [1:0][                 3:0] axi4_ar_region,
    output logic [1:0][AXI_USER_WIDTH  -1:0] axi4_ar_user,
    output logic [1:0]                       axi4_ar_valid,
    input  logic [1:0]                       axi4_ar_ready,

    output logic [1:0][AXI_DATA_WIDTH  -1:0] axi4_w_data,
    output logic [1:0][AXI_STRB_WIDTH  -1:0] axi4_w_strb,
    output logic [1:0]                       axi4_w_last,
    output logic [1:0][AXI_USER_WIDTH  -1:0] axi4_w_user,
    output logic [1:0]                       axi4_w_valid,
    input  logic [1:0]                       axi4_w_ready,

    input  logic [1:0][AXI_ID_WIDTH    -1:0] axi4_r_id,
    input  logic [1:0][AXI_DATA_WIDTH  -1:0] axi4_r_data,
    input  logic [1:0][                 1:0] axi4_r_resp,
    input  logic [1:0]                       axi4_r_last,
    input  logic [1:0][AXI_USER_WIDTH  -1:0] axi4_r_user,
    input  logic [1:0]                       axi4_r_valid,
    output logic [1:0]                       axi4_r_ready,

    input  logic [1:0][AXI_ID_WIDTH    -1:0] axi4_b_id,
    input  logic [1:0][                 1:0] axi4_b_resp,
    input  logic [1:0][AXI_USER_WIDTH  -1:0] axi4_b_user,
    input  logic [1:0]                       axi4_b_valid,
    output logic [1:0]                       axi4_b_ready
  );

  ////////////////////////////////////////////////////////////////
  //
  // Constants
  //
  localparam RADRCNT_MSB = $clog2(BURST) + $clog2(XLEN/8) - 1;

  ////////////////////////////////////////////////////////////////
  //
  // Typedefs
  //
  typedef bit   [     7:0] octet;
  typedef bit   [XLEN-1:0] data_type;
  typedef logic [PLEN-1:0] addr_type;

  ////////////////////////////////////////////////////////////////
  //
  // Variables
  //
  integer m,n;
  genvar  u,i,j,k,p;

  data_type mem_array[addr_type];

  logic [PLEN         -1:0] iaddr       [2],
                            raddr       [2],
                            waddr       [2];
  logic [RADRCNT_MSB    :0] radrcnt     [2];

  logic                     wreq        [2];
  logic [XLEN/8       -1:0] dbe         [2];

  logic [MEM_LATENCY    :1] ack_latency [2];


  logic [              1:0] dHTRANS     [2];
  logic                     dHWRITE     [2];
  logic [              2:0] dHSIZE      [2];
  logic [              2:0] dHBURST     [2];

  logic [1:0]            hsel;
  logic [1:0][PLEN -1:0] haddr;
  logic [1:0][XLEN -1:0] hrdata;
  logic [1:0][XLEN -1:0] hwdata;
  logic [1:0]            hwrite;
  logic [1:0][      2:0] hsize;
  logic [1:0][      2:0] hburst;
  logic [1:0][      3:0] hprot;
  logic [1:0][      1:0] htrans;
  logic [1:0]            hmastlock;
  logic [1:0]            hready;
  logic [1:0]            hresp;

  ////////////////////////////////////////////////////////////////
  //
  // Tasks
  //

  //Read Intel HEX
  task automatic read_ihex;
    integer m;
    integer fd;
    integer cnt;
    integer eof;

    reg [31:0] tmp;

    bit [7:0]        byte_cnt;
    octet    [  1:0] address;
    bit [7:0]        record_type;
    octet    [255:0] data;
    bit [7:0]        checksum, crc;

    logic [PLEN-1:0] base_addr=BASE;

    /*
     * 1: start code
     * 2: byte count  (2 hex digits)
     * 3: address     (4 hex digits)
     * 4: record type (2 hex digits)
     *    00: data
     *    01: end of file
     *    02: extended segment address
     *    03: start segment address
     *    04: extended linear address (16lsbs of 32bit address)
     *    05: start linear address
     * 5: data
     * 6: checksum    (2 hex digits)
     */

    fd = $fopen(INIT_FILE, "r"); //open file
    if (fd < 32'h8000_0000) begin
      $display ("ERROR  : Skip reading file %s. Reason file not found", INIT_FILE);
      $finish();
    end

    eof = 0;
    while (eof == 0) begin
      if ($fscanf(fd, ":%2h%4h%2h", byte_cnt, address, record_type) != 3)
        $display ("ERROR  : Read error while processing %s", INIT_FILE);

      //initial CRC value
      crc = byte_cnt + address[1] + address[0] + record_type;

      for (m=0; m<byte_cnt; m=m+1) begin
        if ($fscanf(fd, "%2h", data[m]) != 1)
          $display ("ERROR  : Read error while processing %s", INIT_FILE);

        //update CRC
        crc = crc + data[m];
      end

      if ($fscanf(fd, "%2h", checksum) != 1)
        $display ("ERROR  : Read error while processing %s", INIT_FILE);

      if (checksum + crc)
        $display ("ERROR  : CRC error while processing %s", INIT_FILE);

      case (record_type)
        8'h00  : begin
          for (m=0; m<byte_cnt; m=m+1) begin
            //mem_array[ base_addr + address + (m & ~(XLEN/8 -1)) ][ (m%(XLEN/8))*8+:8 ] = data[m];
            mem_array[ (base_addr + address + m) & ~(XLEN/8 -1) ][ ((base_addr + address + m) % (XLEN/8))*8+:8 ] = data[m];
            //$display ("write %2h to %8h (base_addr=%8h, address=%4h, m=%2h)", data[m], base_addr+address+ (m & ~(XLEN/8 -1)), base_addr, address, m);
            //$display ("(%8h)=%8h",base_addr+address+4*(m/4), mem_array[ base_addr+address+4*(m/4) ]);
          end
        end
        8'h01  : eof = 1;
        8'h02  : base_addr = {data[0],data[1]} << 4;
        8'h03  : $display("INFO   : Ignored record type %0d while processing %s", record_type, INIT_FILE);
        8'h04  : base_addr = {data[0], data[1]} << 16;
        8'h05  : base_addr = {data[0], data[1], data[2], data[3]};
        default: $display("ERROR  : Unknown record type while processing %s", INIT_FILE);
      endcase
    end

    $fclose (fd); //close file
  endtask

  //Read HEX generated by RISC-V elf2hex
  task automatic read_elf2hex;
    integer fd;
    integer m;
    integer line=0;

    reg [127:0] data;

    logic [PLEN-1:0] base_addr = BASE;

    fd = $fopen(INIT_FILE, "r"); //open file
    if (fd < 32'h8000_0000) begin
      $display ("ERROR  : Skip reading file %s. File not found", INIT_FILE);
      $finish();
    end
    else begin
      $display ("INFO   : Reading %s", INIT_FILE);
    end

    //Read data from file
    while ( !$feof(fd) ) begin
      line=line+1;
      if ($fscanf(fd, "%32h", data) != 1) begin
        $display("ERROR  : Read error while processing %s (line %0d)", INIT_FILE, line);
      end

      for (m=0; m< 128/XLEN; m=m+1) begin
        //$display("[%8h]:%8h",base_addr,data[m*XLEN +: XLEN]);
        mem_array[ base_addr ] = data[m*XLEN +: XLEN];
        base_addr = base_addr + (XLEN/8);
      end
    end

    //close file
    $fclose(fd);
  endtask

  //Dump memory
  task dump;
    foreach (mem_array[m])
      $display("[%8h]:%8h", m,mem_array[m]);
  endtask

  ////////////////////////////////////////////////////////////////
  //
  // Module body
  //

  generate
    for (u=0; u < 2; u=u+1) begin

      //Generate ACK

      if (MEM_LATENCY > 0) begin
        always @(posedge HCLK,negedge HRESETn) begin
          if (!HRESETn) begin
            ack_latency[u] <= {MEM_LATENCY{1'b1}};
          end
          else if (HREADY[u]) begin
            if      ( HTRANS[u] == `HTRANS_IDLE  ) begin
              ack_latency[u] <= {MEM_LATENCY{1'b1}};
            end
            else if ( HTRANS[u] == `HTRANS_NONSEQ) begin
              ack_latency[u] <= 'h0;
            end
          end
          else begin
            ack_latency[u] <= {ack_latency[u],1'b1};
          end
        end
        assign HREADY[u] = ack_latency[u][MEM_LATENCY];
      end
      else begin
        assign HREADY[u] = 1'b1;
      end

      assign HRESP[u] = `HRESP_OKAY;

      //Write Section

      //delay control signals
      always @(posedge HCLK) begin
        if (HREADY[u]) begin
          dHTRANS[u] <= HTRANS[u];
          dHWRITE[u] <= HWRITE[u];
          dHSIZE [u] <= HSIZE [u];
          dHBURST[u] <= HBURST[u];
        end
      end

      always @(posedge HCLK) begin
        if (HREADY[u] && HTRANS[u] != `HTRANS_BUSY) begin
          waddr[u] <= HADDR[u] & ( {XLEN{1'b1}} << $clog2(XLEN/8) );

          case (HSIZE[u])
            `HSIZE_BYTE : dbe[u] <= 1'h1  << HADDR[u][$clog2(XLEN/8)-1:0];
            `HSIZE_HWORD: dbe[u] <= 2'h3  << HADDR[u][$clog2(XLEN/8)-1:0];
            `HSIZE_WORD : dbe[u] <= 4'hf  << HADDR[u][$clog2(XLEN/8)-1:0];
            `HSIZE_DWORD: dbe[u] <= 8'hff << HADDR[u][$clog2(XLEN/8)-1:0];
          endcase
        end
      end

      always @(posedge HCLK) begin
        if (HREADY[u]) begin
          wreq[u] <= (HTRANS[u] != `HTRANS_IDLE & HTRANS[u] != `HTRANS_BUSY) & HWRITE[u];
        end
      end

      always @(posedge HCLK) begin
        if (HREADY[u] && wreq[u]) begin
          for (m=0; m<XLEN/8; m=m+1) begin
            if (dbe[u][m]) begin
              mem_array[waddr[u]][m*8+:8] = HWDATA[u][m*8+:8];
            end
          end
        end
      end

      //Read Section
      assign iaddr[u] = HADDR[u] & ( {XLEN{1'b1}} << $clog2(XLEN/8) );

      always @(posedge HCLK) begin
        if (HREADY[u] && (HTRANS[u] != `HTRANS_IDLE) && (HTRANS[u] != `HTRANS_BUSY) && !HWRITE[u])
          if (iaddr[u] == waddr[u] && wreq[u]) begin
            for (n=0; n<XLEN/8; n++) begin
              if (dbe[u]) HRDATA[u][n*8+:8] <= HWDATA[u][n*8+:8];
              else        HRDATA[u][n*8+:8] <= mem_array[ iaddr[u] ][n*8+:8];
            end
          end
        else begin
          HRDATA[u] <= mem_array[ iaddr[u] ];
        end
      end
    end
  endgenerate

  riscv_ahb2axi #(
    .AXI_ID_WIDTH   ( AXI_ID_WIDTH   ),
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH ),
    .AXI_STRB_WIDTH ( AXI_STRB_WIDTH ),

    .AHB_ADDR_WIDTH ( AHB_ADDR_WIDTH ),
    .AHB_DATA_WIDTH ( AHB_DATA_WIDTH )
  )
  ahb2axi (
    .clk   ( HCLK    ),
    .rst_l ( HRESETn ),

    .bus_clk_en (1'b1),

    // AXI4 signals
    .axi4_aw_id     (axi4_aw_id),
    .axi4_aw_addr   (axi4_aw_addr),
    .axi4_aw_len    (axi4_aw_len),
    .axi4_aw_size   (axi4_aw_size),
    .axi4_aw_burst  (axi4_aw_burst),
    .axi4_aw_lock   (axi4_aw_lock),
    .axi4_aw_cache  (axi4_aw_cache),
    .axi4_aw_prot   (axi4_aw_prot),
    .axi4_aw_qos    (axi4_aw_qos),
    .axi4_aw_region (axi4_aw_region),
    .axi4_aw_user   (axi4_aw_user),
    .axi4_aw_valid  (axi4_aw_valid),
    .axi4_aw_ready  (axi4_aw_ready),
 
    .axi4_ar_id     (axi4_ar_id),
    .axi4_ar_addr   (axi4_ar_addr),
    .axi4_ar_len    (axi4_ar_len),
    .axi4_ar_size   (axi4_ar_size),
    .axi4_ar_burst  (axi4_ar_burst),
    .axi4_ar_lock   (axi4_ar_lock),
    .axi4_ar_cache  (axi4_ar_cache),
    .axi4_ar_prot   (axi4_ar_prot),
    .axi4_ar_qos    (axi4_ar_qos),
    .axi4_ar_region (axi4_ar_region),
    .axi4_ar_user   (axi4_ar_user),
    .axi4_ar_valid  (axi4_ar_valid),
    .axi4_ar_ready  (axi4_ar_ready),
 
    .axi4_w_data    (axi4_w_data),
    .axi4_w_strb    (axi4_w_strb),
    .axi4_w_last    (axi4_w_last),
    .axi4_w_user    (axi4_w_user),
    .axi4_w_valid   (axi4_w_valid),
    .axi4_w_ready   (axi4_w_ready),
 
    .axi4_r_id      (axi4_r_id),
    .axi4_r_data    (axi4_r_data),
    .axi4_r_resp    (axi4_r_resp),
    .axi4_r_last    (axi4_r_last),
    .axi4_r_user    (axi4_r_user),
    .axi4_r_valid   (axi4_r_valid),
    .axi4_r_ready   (axi4_r_ready),
 
    .axi4_b_id      (axi4_b_id),
    .axi4_b_resp    (axi4_b_resp),
    .axi4_b_user    (axi4_b_user),
    .axi4_b_valid   (axi4_b_valid),
    .axi4_b_ready   (axi4_b_ready),

    // AHB3 signals
    .ahb3_hsel      (hsel),
    .ahb3_haddr     (haddr),
    .ahb3_hwdata    (hwdata),
    .ahb3_hrdata    (hrdata),
    .ahb3_hwrite    (hwrite),
    .ahb3_hsize     (hsize),
    .ahb3_hburst    (hburst),
    .ahb3_hprot     (hprot),
    .ahb3_htrans    (htrans),
    .ahb3_hmastlock (hmastlock),
    .ahb3_hreadyin  (hreadyin),
    .ahb3_hreadyout (hreadyout),
    .ahb3_hresp     (hresp)
  );
endmodule
