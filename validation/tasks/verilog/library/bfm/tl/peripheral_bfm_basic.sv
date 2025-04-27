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

import peripheral_axi4_verilog_pkg::*;

module peripheral_bfm_basic;

  initial begin
    $dumpfile("basic.vcd");
    $dumpvars(0, peripheral_bfm_testbench);
  end

  integer        i;

  reg     [31:0] read_data;

  initial begin
    repeat (100) @(posedge peripheral_bfm_testbench.aclk);
    $display("BASIC: Timeout Failure! @ %d", $time);
    $finish;
  end

  initial begin
    $display("AXI Master BFM Test: Basic");

    @(negedge peripheral_bfm_testbench.aresetn);
    @(posedge peripheral_bfm_testbench.aresetn);
    repeat (10) @(posedge peripheral_bfm_testbench.aclk);
    peripheral_bfm_testbench.master.write_single(32'h0000_0004, 32'hdead_beef, AXI_BURST_SIZE_WORD, 4'hF);
    peripheral_bfm_testbench.master.write_single(32'h0000_0008, 32'h1234_5678, AXI_BURST_SIZE_WORD, 4'hF);
    peripheral_bfm_testbench.master.write_single(32'h0000_000C, 32'hABCD_EF00, AXI_BURST_SIZE_WORD, 4'hF);
    peripheral_bfm_testbench.master.write_single(32'h0000_0010, 32'hAA55_66BB, AXI_BURST_SIZE_WORD, 4'hF);
    repeat (10) @(posedge peripheral_bfm_testbench.aclk);

    peripheral_bfm_testbench.master.read_single_and_check(32'h0000_0004, 32'hdead_beef, AXI_BURST_SIZE_WORD, 4'hF);
    peripheral_bfm_testbench.master.read_single_and_check(32'h0000_0008, 32'h1234_5678, AXI_BURST_SIZE_WORD, 4'hF);
    peripheral_bfm_testbench.master.read_single_and_check(32'h0000_000C, 32'hABCD_EF00, AXI_BURST_SIZE_WORD, 4'hF);
    peripheral_bfm_testbench.master.read_single_and_check(32'h0000_0010, 32'hAA55_66BB, AXI_BURST_SIZE_WORD, 4'hF);

    for (i = 0; i < 5; i = i + 1) begin
      $display("MEMORY[%d] = 0x%04x", i, peripheral_bfm_testbench.slave.memory[i]);
    end

    peripheral_bfm_testbench.test_passed <= 1;
  end
endmodule  // peripheral_bfm_basic
