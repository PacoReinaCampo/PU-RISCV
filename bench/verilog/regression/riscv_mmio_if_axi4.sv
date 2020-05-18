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
//              Debug Controller Simulation Model                             //
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

module riscv_mmio_if_ahb3 #(
  parameter HDATA_SIZE    = 32,
  parameter HADDR_SIZE    = 32,
  parameter CATCH_TEST    = 80001000,
  parameter CATCH_UART_TX = 80001080
)
  (
    input                               HRESETn,
    input                               HCLK,

    //AXI4 instruction
    output logic [AXI_ID_WIDTH    -1:0] axi4_aw_id,
    output logic [AXI_ADDR_WIDTH  -1:0] axi4_aw_addr,
    output logic [                 7:0] axi4_aw_len,
    output logic [                 2:0] axi4_aw_size,
    output logic [                 1:0] axi4_aw_burst,
    output logic                        axi4_aw_lock,
    output logic [                 3:0] axi4_aw_cache,
    output logic [                 2:0] axi4_aw_prot,
    output logic [                 3:0] axi4_aw_qos,
    output logic [                 3:0] axi4_aw_region,
    output logic [AXI_USER_WIDTH  -1:0] axi4_aw_user,
    output logic                        axi4_aw_valid,
    input  logic                        axi4_aw_ready,

    output logic [AXI_ID_WIDTH    -1:0] axi4_ar_id,
    output logic [AXI_ADDR_WIDTH  -1:0] axi4_ar_addr,
    output logic [                 7:0] axi4_ar_len,
    output logic [                 2:0] axi4_ar_size,
    output logic [                 1:0] axi4_ar_burst,
    output logic                        axi4_ar_lock,
    output logic [                 3:0] axi4_ar_cache,
    output logic [                 2:0] axi4_ar_prot,
    output logic [                 3:0] axi4_ar_qos,
    output logic [                 3:0] axi4_ar_region,
    output logic [AXI_USER_WIDTH  -1:0] axi4_ar_user,
    output logic                        axi4_ar_valid,
    input  logic                        axi4_ar_ready,

    output logic [AXI_DATA_WIDTH  -1:0] axi4_w_data,
    output logic [AXI_STRB_WIDTH  -1:0] axi4_w_strb,
    output logic                        axi4_w_last,
    output logic [AXI_USER_WIDTH  -1:0] axi4_w_user,
    output logic                        axi4_w_valid,
    input  logic                        axi4_w_ready,

    input  logic [AXI_ID_WIDTH    -1:0] axi4_r_id,
    input  logic [AXI_DATA_WIDTH  -1:0] axi4_r_data,
    input  logic [                 1:0] axi4_r_resp,
    input  logic                        axi4_r_last,
    input  logic [AXI_USER_WIDTH  -1:0] axi4_r_user,
    input  logic                        axi4_r_valid,
    output logic                        axi4_r_ready,

    input  logic [AXI_ID_WIDTH    -1:0] axi4_b_id,
    input  logic [                 1:0] axi4_b_resp,
    input  logic [AXI_USER_WIDTH  -1:0] axi4_b_user,
    input  logic                        axi4_b_valid,
    output logic                        axi4_b_ready
  );

  ////////////////////////////////////////////////////////////////
  //
  // Variables
  //
  logic [HDATA_SIZE-1:0] data_reg;
  logic                  catch_test,
                         catch_uart_tx;

  logic [           1:0] dHTRANS;
  logic [HADDR_SIZE-1:0] dHADDR;
  logic                  dHWRITE;

  integer watchdog_cnt;

  logic             hsel;
  logic [PLEN -1:0] haddr;
  logic [XLEN -1:0] hrdata;
  logic [XLEN -1:0] hwdata;
  logic             hwrite;
  logic [      2:0] hsize;
  logic [      2:0] hburst;
  logic [      3:0] hprot;
  logic [      1:0] htrans;
  logic             hmastlock;
  logic             hready;
  logic             hresp;

  ////////////////////////////////////////////////////////////////
  //
  // Functions
  //
  function string hostcode_to_string;
    input integer hostcode;

    case (hostcode)
      1337: hostcode_to_string = "OTHER EXCEPTION";
    endcase
  endfunction

  ////////////////////////////////////////////////////////////////
  //
  // Module body
  //

  //Generate watchdog counter
  always @(posedge HCLK,negedge HRESETn) begin
    if (!HRESETn) watchdog_cnt <= 0;
    else          watchdog_cnt <= watchdog_cnt + 1;
  end

  //Catch write to host address
  assign HRESP = `HRESP_OKAY;

  always @(posedge HCLK) begin
    dHTRANS <= HTRANS;
    dHADDR  <= HADDR;
    dHWRITE <= HWRITE;
  end

  always @(posedge HCLK,negedge HRESETn) begin
    if (!HRESETn) begin
      HREADYOUT <= 1'b1;
    end
    else if (HTRANS == `HTRANS_IDLE) begin
    end
  end

  always @(posedge HCLK,negedge HRESETn) begin
    if (!HRESETn) begin
      catch_test    <= 1'b0;
      catch_uart_tx <= 1'b0;
    end
    else begin
      catch_test    <= dHTRANS == `HTRANS_NONSEQ && dHWRITE && dHADDR == CATCH_TEST;
      catch_uart_tx <= dHTRANS == `HTRANS_NONSEQ && dHWRITE && dHADDR == CATCH_UART_TX;
      data_reg      <= HWDATA;
    end
  end
  //Generate output

  //Simulated UART Tx (prints characters on screen)
  always @(posedge HCLK) begin
    if (catch_uart_tx) $write ("%0c", data_reg);
  end
  //Tests ...
  always @(posedge HCLK) begin
    if (watchdog_cnt > 1000_000 || catch_test) begin
      $display("\n");
      $display("-------------------------------------------------------------");
      $display("* RISC-V test bench finished");
      if (data_reg[0] == 1'b1) begin
        if (~|data_reg[HDATA_SIZE-1:1])
          $display("* PASSED %0d", data_reg);
        else
          $display ("* FAILED: code: 0x%h (%0d: %s)", data_reg >> 1, data_reg >> 1, hostcode_to_string(data_reg >> 1) );
      end
      else
        $display ("* FAILED: watchdog count reached (%0d) @%0t", watchdog_cnt, $time);
      $display("-------------------------------------------------------------");
      $display("\n");

      $finish();
    end
  end
endmodule
