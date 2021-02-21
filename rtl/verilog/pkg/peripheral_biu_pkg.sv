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

  //BIU Constants Package
  `define BYTE       3'b000
  `define HWORD      3'b001
  `define WORD       3'b010
  `define DWORD      3'b011
  `define QWORD      3'b100
  `define UNDEF_SIZE 3'bxxx

  `define SINGLE      3'b000
  `define INCR        3'b001
  `define WRAP4       3'b010
  `define INCR4       3'b011
  `define WRAP8       3'b100
  `define INCR8       3'b101
  `define WRAP16      3'b110
  `define INCR16      3'b111
  `define UNDEF_BURST 3'bxxx

  //Enumeration Codes
  `define PROT_INSTRUCTION  3'b000
  `define PROT_DATA         3'b001
  `define PROT_USER         3'b000
  `define PROT_PRIVILEGED   3'b010
  `define PROT_NONCACHEABLE 3'b000
  `define PROT_CACHEABLE    3'b100

  //Complex Enumerations
  `define NONCACHEABLE_USER_INSTRUCTION       3'b000
  `define NONCACHEABLE_USER_DATA              3'b001
  `define NONCACHEABLE_PRIVILEGED_INSTRUCTION 3'b010
  `define NONCACHEABLE_PRIVILEGED_DATA        3'b011
  `define CACHEABLE_USER_INSTRUCTION          3'b100
  `define CACHEABLE_USER_DATA                 3'b101
  `define CACHEABLE_PRIVILEGED_INSTRUCTION    3'b110
  `define CACHEABLE_PRIVILEGED_DATA           3'b111
