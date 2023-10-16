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
 *   Paco Reina Campo <pacoreinacampo@queenfield.tech>
 */

import peripheral_ahb3_pkg::*;

module pu_riscv_memory_model_ahb3 #(
  parameter XLEN = 64,
  parameter PLEN = 64,

  parameter BASE = 'h0,

  parameter MEM_LATENCY = 1,

  parameter LATENCY = 1,
  parameter BURST   = 8,

  parameter INIT_FILE = "test.hex"
) (
  input HCLK,
  input HRESETn,

  input  [1:0][1:0] HTRANS,
  output [1:0]      HREADY,
  output [1:0]      HRESP,

  input      [1:0][PLEN   -1:0] HADDR,
  input      [1:0]              HWRITE,
  input      [1:0][        2:0] HSIZE,
  input      [1:0][        2:0] HBURST,
  input      [1:0][XLEN   -1:0] HWDATA,
  output reg [1:0][XLEN   -1:0] HRDATA
);

  ////////////////////////////////////////////////////////////////
  //
  // Constants
  //
  localparam RADRCNT_MSB = $clog2(BURST) + $clog2(XLEN / 8) - 1;

  ////////////////////////////////////////////////////////////////
  //
  // Typedefs
  //
  typedef logic [PLEN-1:0] addr_type;

  ////////////////////////////////////////////////////////////////
  //
  // Variables
  //
  integer m, n;
  genvar u, i, j, k, p;

  logic [XLEN         -1:0] mem_array  [addr_type];

  logic [PLEN         -1:0] iaddr      [        2];
  logic [PLEN         -1:0] raddr      [        2];
  logic [PLEN         -1:0] waddr      [        2];
  logic [  RADRCNT_MSB : 0] radrcnt    [        2];

  logic                     wreq       [        2];
  logic [XLEN/8       -1:0] dbe        [        2];

  logic [  MEM_LATENCY : 1] ack_latency[        2];


  logic [              1:0] dHTRANS    [        2];
  logic                     dHWRITE    [        2];
  logic [              2:0] dHSIZE     [        2];
  logic [              2:0] dHBURST    [        2];

  ////////////////////////////////////////////////////////////////
  //
  // Tasks
  //

  //Read Intel HEX
  task automatic read_ihex;
    integer              m;
    integer              fd;
    integer              cnt;
    integer              eof;

    reg     [ 31:0]      tmp;

    bit     [  7:0]      byte_cnt;
    bit     [  1:0][7:0] address;
    bit     [  7:0]      record_type;
    bit     [255:0][7:0] data;
    bit            [7:0] checksum;
    bit            [7:0] crc;

    logic [PLEN-1:0] base_addr = BASE;

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

    fd = $fopen(INIT_FILE, "r");  //open file
    if (fd < 32'h8000_0000) begin
      $display("ERROR  : Skip reading file %s. Reason file not found", INIT_FILE);
      $finish();
    end

    eof = 0;
    while (eof == 0) begin
      if ($fscanf(fd, ":%2h%4h%2h", byte_cnt, address, record_type) != 3) begin
        $display("ERROR  : Read error while processing %s", INIT_FILE);
      end

      //initial CRC value
      crc = byte_cnt + address[1] + address[0] + record_type;

      for (m = 0; m < byte_cnt; m = m + 1) begin
        if ($fscanf(fd, "%2h", data[m]) != 1) begin
          $display("ERROR  : Read error while processing %s", INIT_FILE);
        end

        //update CRC
        crc = crc + data[m];
      end

      if ($fscanf(fd, "%2h", checksum) != 1) begin
        $display("ERROR  : Read error while processing %s", INIT_FILE);
      end

      if (checksum + crc) $display("ERROR  : CRC error while processing %s", INIT_FILE);

      case (record_type)
        8'h00: begin
          for (m = 0; m < byte_cnt; m = m + 1) begin
            //mem_array[ base_addr + address + (m & ~(XLEN/8 -1)) ][ (m%(XLEN/8))*8+:8 ] = data[m];
            mem_array[(base_addr + address + m) & ~(XLEN/8 - 1)][((base_addr + address + m) % (XLEN/8))*8+:8] = data[m];
            //$display ("write %2h to %8h (base_addr=%8h, address=%4h, m=%2h)", data[m], base_addr+address+ (m & ~(XLEN/8 -1)), base_addr, address, m);
            //$display ("(%8h)=%8h",base_addr+address+4*(m/4), mem_array[ base_addr+address+4*(m/4) ]);
          end
        end
        8'h01:   eof = 1;
        8'h02:   base_addr = {data[0], data[1]} << 4;
        8'h03:   $display("INFO   : Ignored record type %0d while processing %s", record_type, INIT_FILE);
        8'h04:   base_addr = {data[0], data[1]} << 16;
        8'h05:   base_addr = {data[0], data[1], data[2], data[3]};
        default: $display("ERROR  : Unknown record type while processing %s", INIT_FILE);
      endcase
    end

    $fclose(fd);  //close file
  endtask

  //Read HEX generated by RISC-V elf2hex
  task automatic read_elf2hex;
    integer            fd;
    integer            m;
    integer            line = 0;

    reg     [   127:0] data;

    logic   [PLEN-1:0] base_addr = BASE;

    fd = $fopen(INIT_FILE, "r");  //open file
    if (fd < 32'h8000_0000) begin
      $display("ERROR  : Skip reading file %s. File not found", INIT_FILE);
      $finish();
    end else begin
      $display("INFO   : Reading %s", INIT_FILE);
    end

    //Read data from file
    while (!$feof(
      fd
    )) begin
      line = line + 1;
      if ($fscanf(fd, "%32h", data) != 1) begin
        $display("ERROR  : Read error while processing %s (line %0d)", INIT_FILE, line);
      end

      for (m = 0; m < 128 / XLEN; m = m + 1) begin
        //$display("[%8h]:%8h",base_addr,data[m*XLEN +: XLEN]);
        mem_array[base_addr] = data[m*XLEN +: XLEN];
        base_addr            = base_addr + (XLEN / 8);
      end
    end

    //close file
    $fclose(fd);
  endtask

  //Dump memory
  task dump;
    foreach (mem_array[m]) $display("[%8h]:%8h", m, mem_array[m]);
  endtask

  ////////////////////////////////////////////////////////////////
  //
  // Module body
  //

  generate
    for (u = 0; u < 2; u = u + 1) begin

      //Generate ACK

      if (MEM_LATENCY > 0) begin
        always @(posedge HCLK, negedge HRESETn) begin
          if (!HRESETn) begin
            ack_latency[u] <= {MEM_LATENCY{1'b1}};
          end else if (HREADY[u]) begin
            if (HTRANS[u] == HTRANS_IDLE) begin
              ack_latency[u] <= {MEM_LATENCY{1'b1}};
            end else if (HTRANS[u] == HTRANS_NONSEQ) begin
              ack_latency[u] <= 'h0;
            end
          end else begin
            ack_latency[u] <= {ack_latency[u], 1'b1};
          end
        end
        assign HREADY[u] = ack_latency[u][MEM_LATENCY];
      end else begin
        assign HREADY[u] = 1'b1;
      end

      assign HRESP[u] = HRESP_OKAY;

      //Write Section

      //delay control signals
      always @(posedge HCLK) begin
        if (HREADY[u]) begin
          dHTRANS[u] <= HTRANS[u];
          dHWRITE[u] <= HWRITE[u];
          dHSIZE[u]  <= HSIZE[u];
          dHBURST[u] <= HBURST[u];
        end
      end

      always @(posedge HCLK) begin
        if (HREADY[u] && HTRANS[u] != HTRANS_BUSY) begin
          waddr[u] <= HADDR[u] & ({XLEN{1'b1}} << $clog2(XLEN / 8));

          case (HSIZE[u])
            HSIZE_BYTE:  dbe[u] <= 1'h1 << HADDR[u][$clog2(XLEN/8)-1:0];
            HSIZE_HWORD: dbe[u] <= 2'h3 << HADDR[u][$clog2(XLEN/8)-1:0];
            HSIZE_WORD:  dbe[u] <= 4'hf << HADDR[u][$clog2(XLEN/8)-1:0];
            HSIZE_DWORD: dbe[u] <= 8'hff << HADDR[u][$clog2(XLEN/8)-1:0];
          endcase
        end
      end

      always @(posedge HCLK) begin
        if (HREADY[u]) begin
          wreq[u] <= (HTRANS[u] != HTRANS_IDLE & HTRANS[u] != HTRANS_BUSY) & HWRITE[u];
        end
      end

      always @(posedge HCLK) begin
        if (HREADY[u] && wreq[u]) begin
          for (m = 0; m < XLEN / 8; m = m + 1) begin
            if (dbe[u][m]) begin
              mem_array[waddr[u]][m*8+:8] = HWDATA[u][m*8+:8];
            end
          end
        end
      end

      //Read Section
      assign iaddr[u] = HADDR[u] & ({XLEN{1'b1}} << $clog2(XLEN / 8));

      always @(posedge HCLK) begin
        if (HREADY[u] && (HTRANS[u] != HTRANS_IDLE) && (HTRANS[u] != HTRANS_BUSY) && !HWRITE[u]) begin
          if (iaddr[u] == waddr[u] && wreq[u]) begin
            for (n = 0; n < XLEN / 8; n++) begin
              if (dbe[u]) begin
                HRDATA[u][n*8+:8] <= HWDATA[u][n*8+:8];
              end else begin
                HRDATA[u][n*8+:8] <= mem_array[iaddr[u]][n*8+:8];
              end
            end
          end else begin
            HRDATA[u] <= mem_array[iaddr[u]];
          end
        end
      end
    end
  endgenerate
endmodule
