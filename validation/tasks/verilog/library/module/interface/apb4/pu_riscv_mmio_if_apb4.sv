////////////////////////////////////////////////////////////////////////////////
//                                           __ _      _     _                //
//                                          / _(_)    | |   | |               //
//               __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |               //
//              / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |               //
//             | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |               //
//              \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|               //
//                 | |                                                        //
//                 |_|                                                        //
//                                                                            //
//                                                                            //
//             MPSoC-RISCV CPU                                                //
//             Debug Controller Simulation Model                              //
//             AMBA4 AHB-Lite Bus Interface                                   //
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

import peripheral_apb4_verilog_pkg::*;

module pu_riscv_mmio_if_apb4 #(
  parameter HDATA_SIZE    = 32,
  parameter HADDR_SIZE    = 32,
  parameter CATCH_TEST    = 80001000,
  parameter CATCH_UART_TX = 80001080
) (
  input HRESETn,
  input HCLK,

  input      [           1:0] HTRANS,
  input      [HADDR_SIZE-1:0] HADDR,
  input                       HWRITE,
  input      [           2:0] HSIZE,
  input      [           2:0] HBURST,
  input      [HDATA_SIZE-1:0] HWDATA,
  output reg [HDATA_SIZE-1:0] HRDATA,

  output reg HREADYOUT,
  output     HRESP
);

  //////////////////////////////////////////////////////////////////////////////
  // Variables
  //////////////////////////////////////////////////////////////////////////////

  logic   [HDATA_SIZE-1:0] data_reg;
  logic                    catch_test;
  logic                    catch_uart_tx;

  logic   [           1:0] dHTRANS;
  logic   [HADDR_SIZE-1:0] dHADDR;
  logic                    dHWRITE;

  integer                  watchdog_cnt;

  //////////////////////////////////////////////////////////////////////////////
  // Functions
  //////////////////////////////////////////////////////////////////////////////

  function string hostcode_to_string;
    input integer hostcode;

    case (hostcode)
      1337: hostcode_to_string = "OTHER EXCEPTION";
    endcase
  endfunction

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // Generate watchdog counter
  always @(posedge HCLK, negedge HRESETn) begin
    if (!HRESETn) begin
      watchdog_cnt <= 0;
    end else begin
      watchdog_cnt <= watchdog_cnt + 1;
    end
  end

  // Catch write to host address
  assign HRESP = HRESP_OKAY;

  always @(posedge HCLK) begin
    dHTRANS <= HTRANS;
    dHADDR  <= HADDR;
    dHWRITE <= HWRITE;
  end

  always @(posedge HCLK, negedge HRESETn) begin
    if (!HRESETn) begin
      HREADYOUT <= 1'b1;
    end else if (HTRANS == HTRANS_IDLE) begin
    end
  end

  always @(posedge HCLK, negedge HRESETn) begin
    if (!HRESETn) begin
      catch_test    <= 1'b0;
      catch_uart_tx <= 1'b0;
    end else begin
      catch_test    <= dHTRANS == HTRANS_NONSEQ && dHWRITE && dHADDR == CATCH_TEST;
      catch_uart_tx <= dHTRANS == HTRANS_NONSEQ && dHWRITE && dHADDR == CATCH_UART_TX;
      data_reg      <= HWDATA;
    end
  end

  // Generate output

  // Simulated UART Tx (prints characters on screen)
  always @(posedge HCLK) begin
    if (catch_uart_tx) begin
      $write("%0c", data_reg);
    end
  end

  // Tests ...
  always @(posedge HCLK) begin
    if (watchdog_cnt > 1000_000 || catch_test) begin
      $display("\n");
      $display("-------------------------------------------------------------");
      $display("* RISC-V test bench finished");
      if (data_reg[0] == 1'b1) begin
        if (~|data_reg[HDATA_SIZE-1:1]) begin
          $display("* PASSED %0d", data_reg);
        end else begin
          $display("* FAILED: code: 0x%h (%0d: %s)", data_reg >> 1, data_reg >> 1, hostcode_to_string(data_reg >> 1));
        end
      end else begin
        $display("* FAILED: watchdog count reached (%0d) @%0t", watchdog_cnt, $time);
      end
      $display("-------------------------------------------------------------");
      $display("\n");

      $finish();
    end
  end
endmodule
