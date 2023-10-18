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
//              Core - Correlating Branch Prediction Unit                     //
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
 
      pu_riscv_bp #(
        .XLEN(XLEN),

        .BP_GLOBAL_BITS   (BP_GLOBAL_BITS),
        .BP_LOCAL_BITS    (BP_LOCAL_BITS),
        .BP_LOCAL_BITS_LSB(BP_LOCAL_BITS_LSB),

        .TECHNOLOGY(TECHNOLOGY),

        .PC_INIT(PC_INIT)
      ) bp_unit (
        .rst_ni(rstn),
        .clk_i (clk),

        .id_stall_i     (id_stall),
        .if_parcel_pc_i (if_parcel_pc),
        .bp_bp_predict_o(bp_bp_predict),

        .ex_pc_i        (ex_pc),
        .bu_bp_history_i(bu_bp_history),
        .bu_bp_predict_i(bu_bp_predict),  // prediction bits for branch
        .bu_bp_btaken_i (bu_bp_btaken),
        .bu_bp_update_i (bu_bp_update)
      );
