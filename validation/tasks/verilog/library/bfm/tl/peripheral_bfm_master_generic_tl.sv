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
//              Peripheral-BFM for MPSoC                                      //
//              Bus Functional Model for MPSoC                                //
//              AMBA4 AXI-Lite Bus Interface                                  //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018-2019 by the author(s)
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

module peripheral_bfm_master_generic_tl (

  // Global Signals
  input wire aclk,
  input wire aresetn, // Active LOW

  // Write Address Channel
  output reg  [ 3:0] awid,     // Address Write ID
  output reg  [31:0] awadr,    // Write Address
  output reg  [ 3:0] awlen,    // Burst Length
  output reg  [ 2:0] awsize,   // Burst Size
  output reg  [ 1:0] abiuurst,  // Burst Type
  output reg  [ 1:0] awlock,   // Lock Type
  output reg  [ 3:0] awcache,  // Cache Type
  output reg  [ 2:0] awprot,   // Protection Type
  output reg         awvalid,  // Write Address Valid   
  input  wire        awready,  // Write Address Ready

  // Write Data Channel
  output reg  [ 3:0] wid,     // Write ID
  output reg  [31:0] wrdata,  // Write Data
  output reg  [ 3:0] wstrb,   // Write Strobes
  output reg         wlast,   // Write Last
  output reg         wvalid,  // Write Valid   
  input  wire        wready,  // Write Ready

  // Write Response Channel
  output reg  [3:0] bid,     // Response ID
  output reg  [1:0] bresp,   // Write Response
  output reg        bvalid,  // Write Response Valid   
  input  wire       bready,  // Response Ready

  // Read Address Channel
  output reg  [ 3:0] arid,     // Read Address ID
  output reg  [31:0] araddr,   // Read Address
  output reg  [ 3:0] arlen,    // Burst Length
  output reg  [ 2:0] arsize,   // Burst Size
  output reg  [ 1:0] arlock,   // Lock Type
  output reg  [ 3:0] arcache,  // Cache Type
  output reg  [ 2:0] arprot,   // Protection Type
  output reg         arvalid,  // Read Address Valid   
  input  wire        arready,  // Read Address Ready

  // Read Data Channel
  input  wire [ 3:0] rid,     // Read ID
  input  wire [31:0] rdata,   // Read Data
  input  wire [ 1:0] rresp,   // Read Response
  input  wire        rlast,   // Read Last
  input  wire        rvalid,  // Read Valid
  output reg         rready,  // Read Ready

  // Test Signals
  output reg test_fail
);

  // Set all output regs to 0
  initial begin
    awid      <= 0;
    awadr     <= 0;
    awlen     <= 0;
    awsize    <= 0;
    abiuurst   <= 0;
    awlock    <= 0;
    awcache   <= 0;
    awprot    <= 0;
    awvalid   <= 0;

    wid       <= 0;
    wrdata    <= 0;
    wstrb     <= 0;
    wlast     <= 0;
    wvalid    <= 0;

    bid       <= 0;
    bresp     <= 0;
    bvalid    <= 0;

    arid      <= 0;
    araddr    <= 0;
    arlen     <= 0;
    arsize    <= 0;
    arlock    <= 0;
    arcache   <= 0;
    arprot    <= 0;
    arvalid   <= 0;
    rready    <= 0;

    test_fail <= 0;
  end

  // Task: Single Write Transaction
  task write_single;
    input [31:0] address;
    input [31:0] data;
    input [2:0] size;
    input [3:0] strobe;
    begin
      test_fail <= 0;

      // Operate in a synchronous manner
      @(posedge aclk);

      $display("TASK: Write Single Addr = 0x%4x Data = 0x%4x Size = 0x%x Strobe = 0x%x Time = %d", address, data, size, strobe, $time);

      // Address Phase
      awid    <= 0;
      awadr   <= address;
      awvalid <= 1;
      awlen   <= AXI_BURST_LENGTH_1;
      awsize  <= size;
      abiuurst <= AXI_BURST_TYPE_FIXED;
      awlock  <= AXI_LOCK_NORMAL;
      awcache <= 0;
      awprot  <= AXI_PROTECTION_NORMAL;
      @(posedge awready);  // This should arrive on a clock edge!

      // Data Phase
      awvalid <= 0;
      awadr   <= 'bX;
      wid     <= 0;
      wvalid  <= 1;
      wrdata  <= data;
      wstrb   <= strobe;
      wlast   <= 1;
      @(posedge wready);

      // Response Phase
      wid    <= 0;
      wvalid <= 0;
      wrdata <= 'bX;
      wstrb  <= 0;
      wlast  <= 0;
    end
  endtask

  // Task: Single Read Transaction
  task read_single;
    input [31:0] address;
    output [31:0] data;
    input [2:0] size;
    input [3:0] strobe;
    begin
      test_fail <= 0;

      // Address Phase
      arid      <= 0;
      araddr    <= address;
      arvalid   <= 1;
      arlen     <= AXI_BURST_LENGTH_1;
      arsize    <= size;
      arlock    <= AXI_LOCK_NORMAL;
      arcache   <= 0;
      arprot    <= AXI_PROTECTION_NORMAL;
      rready    <= 0;
      @(posedge arready);  // This should arrive on a clock edge!

      // Data Phase
      arvalid <= 0;
      rready  <= 1;
      @(posedge rvalid);
      rready <= 0;
      data   <= rdata;
      @(negedge rvalid);
      araddr <= 'bx;

      $display("TASK: Read Single Addr Addr = 0x%4x Data = 0x%4x Size = 0x%x Strobe = 0x%x Time = %d", address, data, size, strobe, $time);
    end
  endtask

  task read_single_and_check;
    input [31:0] address;
    input [31:0] expected_data;
    input [2:0] size;
    input [3:0] strobe;
    reg [31:0] read_data;
    begin
      test_fail <= 0;

      read_single(address, read_data, size, strobe);
      if (read_data !== expected_data) begin
        $display("TASK: Read Single and Check FAIL Read = 0x%04x Expected = 0x%04x @ %d", read_data, expected_data, $time);
        test_fail <= 1;
      end
    end
  endtask
endmodule  // peripheral_bfm_master_tl
