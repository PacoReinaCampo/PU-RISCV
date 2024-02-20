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

module peripheral_bfm_testbench;

  // Free running clock
  reg aclk;

  initial begin
    aclk <= 0;
    forever #5 aclk <= ~aclk;
  end

  // Reset
  reg aresetn;

  initial begin
    aresetn <= 1;
    #11;
    aresetn <= 0;
    repeat (10) @(posedge aclk);
    aresetn <= 1;
  end

  // Write Address Channel
  wire [ 3:0] awid;
  wire [31:0] awadr;
  wire [ 3:0] awlen;
  wire [ 2:0] awsize;
  wire [ 1:0] awburst;
  wire [ 1:0] awlock;
  wire [ 3:0] awcache;
  wire [ 2:0] awprot;
  wire        awvalid;
  wire        awready;

  // Write Data Channel
  wire [ 3:0] wid;
  wire [31:0] wrdata;
  wire [ 3:0] wstrb;
  wire        wlast;
  wire        wvalid;
  wire        wready;

  // Write Response Channel
  wire [ 3:0] bid;
  wire [ 1:0] bresp;
  wire        bvalid;
  wire        bready;

  // Read Address Channel
  wire [ 3:0] arid;
  wire [31:0] araddr;
  wire [ 3:0] arlen;
  wire [ 2:0] arsize;
  wire [ 1:0] arlock;
  wire [ 3:0] arcache;
  wire [ 2:0] arprot;
  wire        arvalid;
  wire        arready;

  // Read Data Channel
  wire [ 3:0] rid;
  wire [31:0] rdata;
  wire [ 1:0] rresp;
  wire        rlast;
  wire        rvalid;
  wire        rready;

  // Test Signals
  reg         test_passed;
  wire        test_fail;

  peripheral_bfm_master_generic_axi4 master (
    // Global Signals
    .aclk   (aclk),
    .aresetn(aresetn),

    // Write Address Channel
    .awid   (awid),
    .awadr  (awadr),
    .awlen  (awlen),
    .awsize (awsize),
    .awburst(awburst),
    .awlock (awlock),
    .awcache(awcache),
    .awprot (awprot),
    .awvalid(awvalid),
    .awready(awready),

    // Write Data Channel
    .wid   (wid),
    .wrdata(wrdata),
    .wstrb (wstrb),
    .wlast (wlast),
    .wvalid(wvalid),
    .wready(wready),

    // Write Response Channel
    .bid   (bid),
    .bresp (bresp),
    .bvalid(bvalid),
    .bready(bready),

    // Read Address Channel
    .arid   (arid),
    .araddr (araddr),
    .arlen  (arlen),
    .arsize (arsize),
    .arlock (arlock),
    .arcache(arcache),
    .arprot (arprot),
    .arvalid(arvalid),
    .arready(arready),

    // Read Data Channel
    .rid   (rid),
    .rdata (rdata),
    .rresp (rresp),
    .rlast (rlast),
    .rvalid(rvalid),
    .rready(rready),

    // Test Signals
    .test_fail(test_fail)
  );

  peripheral_bfm_slave_generic_axi4 slave (
    // Global Signals
    .aclk   (aclk),
    .aresetn(aresetn),

    // Write Address Channel
    .awid   (awid),
    .awadr  (awadr),
    .awlen  (awlen),
    .awsize (awsize),
    .awburst(awburst),
    .awlock (awlock),
    .awcache(awcache),
    .awprot (awprot),
    .awvalid(awvalid),
    .awready(awready),

    // Write Data Channel
    .wid   (wid),
    .wrdata(wrdata),
    .wstrb (wstrb),
    .wlast (wlast),
    .wvalid(wvalid),
    .wready(wready),

    // Write Response Channel
    .bid   (bid),
    .bresp (bresp),
    .bvalid(bvalid),
    .bready(bready),

    // Read Address Channel
    .arid   (arid),
    .araddr (araddr),
    .arlen  (arlen),
    .arsize (arsize),
    .arlock (arlock),
    .arcache(arcache),
    .arprot (arprot),
    .arvalid(arvalid),
    .arready(arready),

    // Read Data Channel
    .rid   (rid),
    .rdata (rdata),
    .rresp (rresp),
    .rlast (rlast),
    .rvalid(rvalid),
    .rready(rready)
  );

  peripheral_bfm_basic test ();
  initial begin
    @(posedge test_fail);
    $display("TEST FAIL @ %d", $time);
    repeat (10) @(posedge aclk);
    $finish;
  end

  initial begin
    test_passed <= 0;
    @(posedge test_passed);
    $display("TEST PASSED: @ %d", $time);
    repeat (10) @(posedge aclk);
    $finish;
  end
endmodule  // peripheral_bfm_testbench
