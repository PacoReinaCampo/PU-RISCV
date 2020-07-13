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
//              Core - Memory Unit                                            //
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

`include "riscv_mpsoc_pkg.sv"

module riscv_memory #(
  parameter XLEN = 64,
  parameter ILEN = 64,

  parameter EXCEPTION_SIZE = 16,

  parameter [XLEN-1:0] PC_INIT = 'h8000_0000
)
  (
    input                           rstn,
    input                           clk,

    input                           wb_stall,

    //Program counter
    input      [XLEN          -1:0] ex_pc,
    output reg [XLEN          -1:0] mem_pc,

    //Instruction
    input                           ex_bubble,
    input      [ILEN          -1:0] ex_instr,
    output reg                      mem_bubble,
    output reg [ILEN          -1:0] mem_instr,

    input      [EXCEPTION_SIZE-1:0] ex_exception,
    input      [EXCEPTION_SIZE-1:0] wb_exception,
    output reg [EXCEPTION_SIZE-1:0] mem_exception,

    //From EX
    input      [XLEN          -1:0] ex_r,
                                  dmem_adr,
    //To WB
    output reg [XLEN          -1:0] mem_r,
    output reg [XLEN          -1:0] mem_memadr
  );

  ////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

  //Program Counter
  always @(posedge clk, negedge rstn) begin
    if      (!rstn    ) mem_pc <= PC_INIT;
    else if (!wb_stall) mem_pc <= ex_pc;
  end

  //Instruction
  always @(posedge clk) begin
    if (!wb_stall) mem_instr <= ex_instr;
  end

  always @(posedge clk, negedge rstn) begin
    if      (!rstn    ) mem_bubble <= 1'b1;
    else if (!wb_stall) mem_bubble <= ex_bubble;
  end

  //Data
  always @(posedge clk) begin
    if (!wb_stall) mem_r <= ex_r;
  end

  always @(posedge clk) begin
    if (!wb_stall) mem_memadr <= dmem_adr;
  end

  //Exception
  always @(posedge clk, negedge rstn) begin
    if      (!rstn    )     mem_exception <= 'h0;
    else if (|mem_exception ||
             |wb_exception) mem_exception <= 'h0;
    else if (!wb_stall)     mem_exception <= ex_exception;
  end
endmodule
