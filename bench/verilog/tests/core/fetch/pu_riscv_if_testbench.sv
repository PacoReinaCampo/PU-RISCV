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
//              Core - Instruction Fetch                                      //
//              AMBA3 AHB-Lite Bus Interface                                  //
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

  pu_riscv_if #(
    .XLEN(XLEN),
    .ILEN(ILEN),

    .PARCEL_SIZE   (PARCEL_SIZE),
    .EXCEPTION_SIZE(EXCEPTION_SIZE)
  ) if_unit (
    .rstn                (rstn),
    .clk                 (clk),
    .id_stall            (id_stall),
    .if_stall_nxt_pc     (if_stall_nxt_pc),
    .if_parcel           (if_parcel),
    .if_parcel_pc        (if_parcel_pc),
    .if_parcel_valid     (if_parcel_valid),
    .if_parcel_misaligned(if_parcel_misaligned),
    .if_parcel_page_fault(if_parcel_page_fault),
    .if_instr            (if_instr),
    .if_bubble           (if_bubble),
    .if_exception        (if_exception),
    .bp_bp_predict       (bp_bp_predict),
    .if_bp_predict       (if_bp_predict),
    .bu_flush            (bu_flush),
    .st_flush            (st_flush),
    .du_flush            (du_flush),
    .bu_nxt_pc           (bu_nxt_pc),
    .st_nxt_pc           (st_nxt_pc),
    .if_nxt_pc           (if_nxt_pc),
    .if_stall            (if_stall),
    .if_flush            (if_flush),
    .if_pc               (if_pc)
  );
