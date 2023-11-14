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

module peripheral_bfm_slave_axi4 (

  // Global Signals
  input wire aclk,
  input wire aresetn, // Active LOW

  // Write Address Channel
  input  wire [ 3:0] awid,     // Address Write ID
  input  wire [31:0] awadr,    // Write Address
  input  wire [ 3:0] awlen,    // Burst Length
  input  wire [ 2:0] awsize,   // Burst Size
  input  wire [ 1:0] awburst,  // Burst Type
  input  wire [ 1:0] awlock,   // Lock Type
  input  wire [ 3:0] awcache,  // Cache Type
  input  wire [ 2:0] awprot,   // Protection Type
  input  wire        awvalid,  // Write Address Valid
  output reg         awready,  // Write Address Ready

  // Write Data Channel
  input  wire [ 3:0] wid,     // Write ID
  input  wire [31:0] wrdata,  // Write Data
  input  wire [ 3:0] wstrb,   // Write Strobes
  input  wire        wlast,   // Write Last
  input  wire        wvalid,  // Write Valid
  output reg         wready,  // Write Ready

  // Write Response CHannel
  output reg  [3:0] bid,     // Response ID
  output reg  [1:0] bresp,   // Write Response
  output reg        bvalid,  // Write Response Valid
  input  wire       bready,  // Response Ready

  // Read Address Channel
  input  wire [ 3:0] arid,     // Read Address ID
  input  wire [31:0] araddr,   // Read Address
  input  wire [ 3:0] arlen,    // Burst Length
  input  wire [ 2:0] arsize,   // Burst Size
  input  wire [ 1:0] arlock,   // Lock Type
  input  wire [ 3:0] arcache,  // Cache Type
  input  wire [ 2:0] arprot,   // Protection Type
  input  wire        arvalid,  // Read Address Valid
  output reg         arready,  // Read Address Ready
  output reg  [ 3:0] rid,      // Read ID
  output reg  [31:0] rdata,    // Read Data
  output reg  [ 1:0] rresp,    // Read Response
  output reg         rlast,    // Read Last
  output reg         rvalid,   // Read Valid
  input  wire        rready    // Read Ready
);
endmodule  // peripheral_bfm_slave_axi4
