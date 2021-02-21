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
//              RISC-V Package                                                //
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

  `define HADDR_SIZE 64
  `define HDATA_SIZE 64

  //HTRANS
  `define HTRANS_IDLE   2'b00
  `define HTRANS_BUSY   2'b01
  `define HTRANS_NONSEQ 2'b10
  `define HTRANS_SEQ    2'b11

  //HSIZE
  `define HSIZE_B8    3'b000
  `define HSIZE_B16   3'b001
  `define HSIZE_B32   3'b010
  `define HSIZE_B64   3'b011
  `define HSIZE_B128  3'b100  //4-word line
  `define HSIZE_B256  3'b101  //8-word line
  `define HSIZE_B512  3'b110
  `define HSIZE_B1024 3'b111
  `define HSIZE_BYTE  `HSIZE_B8
  `define HSIZE_HWORD `HSIZE_B16
  `define HSIZE_WORD  `HSIZE_B32
  `define HSIZE_DWORD `HSIZE_B64

  //HBURST
  `define HBURST_SINGLE 3'b000
  `define HBURST_INCR   3'b001
  `define HBURST_WRAP4  3'b010
  `define HBURST_INCR4  3'b011
  `define HBURST_WRAP8  3'b100
  `define HBURST_INCR8  3'b101
  `define HBURST_WRAP16 3'b110
  `define HBURST_INCR16 3'b111

  //HPROT
  `define HPROT_OPCODE         4'b0000
  `define HPROT_DATA           4'b0001
  `define HPROT_USER           4'b0000
  `define HPROT_PRIVILEGED     4'b0010
  `define HPROT_NON_BUFFERABLE 4'b0000
  `define HPROT_BUFFERABLE     4'b0100
  `define HPROT_NON_CACHEABLE  4'b0000
  `define HPROT_CACHEABLE      4'b1000

  //HRESP
  `define HRESP_OKAY  1'b0
  `define HRESP_ERROR 1'b1
