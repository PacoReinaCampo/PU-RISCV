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

module riscv_mmio_if_axi4 #(
  parameter AXI_ID_WIDTH   = 10,
  parameter AXI_ADDR_WIDTH = 64,
  parameter AXI_DATA_WIDTH = 64,
  parameter AXI_STRB_WIDTH = 10,
  parameter AXI_USER_WIDTH = 10,

  parameter AHB_ADDR_WIDTH = 64,
  parameter AHB_DATA_WIDTH = 64,

  parameter CATCH_TEST    = 80001000,
  parameter CATCH_UART_TX = 80001080
)
  (
    input                               HRESETn,
    input                               HCLK,

    //AXI4 instruction
    input  wire  [AXI_ID_WIDTH    -1:0] axi4_aw_id,
    input  wire  [AXI_ADDR_WIDTH  -1:0] axi4_aw_addr,
    input  wire  [                 7:0] axi4_aw_len,
    input  wire  [                 2:0] axi4_aw_size,
    input  wire  [                 1:0] axi4_aw_burst,
    input  wire                         axi4_aw_lock,
    input  wire  [                 3:0] axi4_aw_cache,
    input  wire  [                 2:0] axi4_aw_prot,
    input  wire  [                 3:0] axi4_aw_qos,
    input  wire  [                 3:0] axi4_aw_region,
    input  wire  [AXI_USER_WIDTH  -1:0] axi4_aw_user,
    input  wire                         axi4_aw_valid,
    output reg                          axi4_aw_ready,

    input  wire  [AXI_ID_WIDTH    -1:0] axi4_ar_id,
    input  wire  [AXI_ADDR_WIDTH  -1:0] axi4_ar_addr,
    input  wire  [                 7:0] axi4_ar_len,
    input  wire  [                 2:0] axi4_ar_size,
    input  wire  [                 1:0] axi4_ar_burst,
    input  wire                         axi4_ar_lock,
    input  wire  [                 3:0] axi4_ar_cache,
    input  wire  [                 2:0] axi4_ar_prot,
    input  wire  [                 3:0] axi4_ar_qos,
    input  wire  [                 3:0] axi4_ar_region,
    input  wire  [AXI_USER_WIDTH  -1:0] axi4_ar_user,
    input  wire                         axi4_ar_valid,
    output reg                          axi4_ar_ready,

    input  wire  [AXI_DATA_WIDTH  -1:0] axi4_w_data,
    input  wire  [AXI_STRB_WIDTH  -1:0] axi4_w_strb,
    input  wire                         axi4_w_last,
    input  wire  [AXI_USER_WIDTH  -1:0] axi4_w_user,
    input  wire                         axi4_w_valid,
    output reg                          axi4_w_ready,

    output reg   [AXI_ID_WIDTH    -1:0] axi4_r_id,
    output reg   [AXI_DATA_WIDTH  -1:0] axi4_r_data,
    output reg   [                 1:0] axi4_r_resp,
    output reg                          axi4_r_last,
    output reg   [AXI_USER_WIDTH  -1:0] axi4_r_user,
    output reg                          axi4_r_valid,
    input  wire                         axi4_r_ready,

    output reg   [AXI_ID_WIDTH    -1:0] axi4_b_id,
    output reg   [                 1:0] axi4_b_resp,
    output reg   [AXI_USER_WIDTH  -1:0] axi4_b_user,
    output reg                          axi4_b_valid,
    input  wire                         axi4_b_ready
  );

  ////////////////////////////////////////////////////////////////
  //
  // Variables
  //
  logic [AHB_DATA_WIDTH-1:0] data_reg;
  logic                      catch_test,
                             catch_uart_tx;

  logic [               1:0] dHTRANS;
  logic [AHB_ADDR_WIDTH-1:0] dHADDR;
  logic                      dHWRITE;

  integer watchdog_cnt;

  logic                      hsel;
  logic [AHB_ADDR_WIDTH-1:0] haddr;
  logic [AHB_DATA_WIDTH-1:0] hrdata;
  logic [AHB_DATA_WIDTH-1:0] hwdata;
  logic                      hwrite;
  logic [               2:0] hsize;
  logic [               2:0] hburst;
  logic [               3:0] hprot;
  logic [               1:0] htrans;
  logic                      hmastlock;
  logic                      hreadyout;
  logic                      hresp;

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
    dHTRANS <= htrans;
    dHADDR  <= haddr;
    dHWRITE <= hwrite;
  end

  always @(posedge HCLK,negedge HRESETn) begin
    if (!HRESETn) begin
      hreadyout <= 1'b1;
    end
    else if (htrans == `HTRANS_IDLE) begin
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
      data_reg      <= hwdata;
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
        if (~|data_reg[AHB_DATA_WIDTH-1:1])
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

  riscv_axi2ahb #(
    .AXI_ID_WIDTH   ( AXI_ID_WIDTH   ),
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH ),
    .AXI_STRB_WIDTH ( AXI_STRB_WIDTH ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH ),

    .AHB_ADDR_WIDTH ( AHB_ADDR_WIDTH ),
    .AHB_DATA_WIDTH ( AHB_DATA_WIDTH )
  )
  axi2ahb (
    .clk   ( HCLK    ),
    .rst_l ( HRESETn ),

    .scan_mode    (1'b1),
    .bus_clk_en   (1'b1),
    .clk_override (1'b1),

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
