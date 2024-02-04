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
//              Peripheral-NTM for MPSoC                                      //
//              Neural Turing Machine for MPSoC                               //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022-2025 by the author(s)
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

import pu_riscv_verilog_pkg::*;

interface peripheral_design_if (
  input logic HCLK,
  input logic HRESETn
);

  // PMA configuration
  logic [PMA_CNT-1:0][    13:0] pma_cfg;
  logic [PMA_CNT-1:0][PLEN-1:0] pma_adr;

  // Instruction interface
  logic                         ins_HSEL;
  logic [   PLEN-1:0]           ins_HADDR;
  logic [   XLEN-1:0]           ins_HRDATA;
  logic [   XLEN-1:0]           ins_HWDATA;
  logic                         ins_HWRITE;
  logic [        2:0]           ins_HSIZE;
  logic [        2:0]           ins_HBURST;
  logic [        3:0]           ins_HPROT;
  logic [        1:0]           ins_HTRANS;
  logic                         ins_HMASTLOCK;
  logic                         ins_HREADY;
  logic                         ins_HRESP;

  // Data interface
  logic                         dat_HSEL;
  logic [   PLEN-1:0]           dat_HADDR;
  logic [   XLEN-1:0]           dat_HWDATA;
  logic [   XLEN-1:0]           dat_HRDATA;
  logic                         dat_HWRITE;
  logic [        2:0]           dat_HSIZE;
  logic [        2:0]           dat_HBURST;
  logic [        3:0]           dat_HPROT;
  logic [        1:0]           dat_HTRANS;
  logic                         dat_HMASTLOCK;
  logic                         dat_HREADY;
  logic                         dat_HRESP;

  // Debug Interface
  logic                         dbg_stall;
  logic                         dbg_strb;
  logic                         dbg_we;
  logic [   PLEN-1:0]           dbg_addr;
  logic [   XLEN-1:0]           dbg_dati;
  logic [   XLEN-1:0]           dbg_dato;
  logic                         dbg_ack;
  logic                         dbg_bp;
endinterface
