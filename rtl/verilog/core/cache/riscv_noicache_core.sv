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
//              Core - No-Instruction Cache Core Logic                        //
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

import peripheral_biu_pkg::*;

module riscv_noicache_core #(
  parameter XLEN        = 64,
  parameter PLEN        = 64,
  parameter PARCEL_SIZE = 64
)
  (
    input                           rstn,
    input                           clk,

  //CPU side
    output                          if_stall_nxt_pc,
    input                           if_stall,
    input                           if_flush,
    input        [XLEN        -1:0] if_nxt_pc,
    output       [XLEN        -1:0] if_parcel_pc,
    output       [PARCEL_SIZE -1:0] if_parcel,
    output                          if_parcel_valid,
    output                          if_parcel_misaligned,
    input                           bu_cacheflush,
    input                           dcflush_rdy,
    input        [             1:0] st_prv,

  //To BIU
    output                          biu_stb,
    input                           biu_stb_ack,
    output       [PLEN        -1:0] biu_adri,
    input        [PLEN        -1:0] biu_adro,
    output reg   [             2:0] biu_size,     //transfer size
    output reg   [             2:0] biu_type,     //burst type -AHB style
    output                          biu_lock,
    output                          biu_we,
    output       [XLEN        -1:0] biu_di,
    input        [XLEN        -1:0] biu_do,
    input                           biu_ack,      //data acknowledge, 1 per data
    input                           biu_err,      //data error

    output                          biu_is_cacheable,
    output                          biu_is_instruction,
    output       [             1:0] biu_prv
  );

  //////////////////////////////////////////////////////////////////
  //
  // Variables
  //
  logic                        is_cacheable;

  logic [                 1:0] biu_stb_cnt;

  logic [                 2:0] biu_fifo_valid;
  logic [XLEN            -1:0] biu_fifo_dat [3];
  logic [PLEN            -1:0] biu_fifo_adr [3];

  logic                        if_flush_dly;

  //////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

  //Is this a cacheable region?
  //MSB=1 non-cacheable (IO region)
  //MSB=0 cacheabel (instruction/data region)
  assign is_cacheable = ~if_nxt_pc[PLEN-1];

  //For now don't support 16bit accesses
  assign if_parcel_misaligned = |if_nxt_pc[1:0]; //send out together with instruction

  //delay IF-flush
  always @(posedge clk,negedge rstn) begin
    if (!rstn) if_flush_dly <= 1'b0;
    else       if_flush_dly <= if_flush;
  end

  // To CPU
  assign if_stall_nxt_pc = ~dcflush_rdy | ~biu_stb_ack | biu_fifo_valid[1];
  assign if_parcel_valid =  dcflush_rdy & ~(if_flush | if_flush_dly) & ~if_stall & biu_fifo_valid[0];
  assign if_parcel_pc    = { {XLEN-PLEN{1'b0}},biu_fifo_adr[0]};
  assign if_parcel       = biu_fifo_dat[0][ if_parcel_pc[$clog2(XLEN/32)+1:1]*16 +: PARCEL_SIZE ];

  //External Interface
  assign biu_stb   = dcflush_rdy & ~if_flush & ~if_stall & ~biu_fifo_valid[1]; //TODO when is ~biu_fifo[1] required?
  assign biu_adri  = if_nxt_pc[PLEN -1:0];
  assign biu_size  = XLEN==64 ? DWORD : WORD;
  assign biu_lock  = 1'b0;
  assign biu_we    = 1'b0;   //no writes
  assign biu_di    =  'h0;
  assign biu_type  = SINGLE; //single access

  //Instruction cache..
  assign biu_is_instruction = 1'b1;
  assign biu_is_cacheable   = is_cacheable;
  assign biu_prv            = st_prv;

  //FIFO
  always @(posedge clk,negedge rstn) begin
    if      (!rstn       ) biu_stb_cnt <= 2'h0;
    else if ( if_flush   ) biu_stb_cnt <= 2'h0;
    else if ( biu_stb_ack) biu_stb_cnt <= {1'b1,biu_stb_cnt[1]};
  end

  //valid bits
  always @(posedge clk,negedge rstn) begin
    if (!rstn) begin
      biu_fifo_valid[0] <= 1'b0;
      biu_fifo_valid[1] <= 1'b0;
      biu_fifo_valid[2] <= 1'b0;
    end
    else if (!biu_stb_cnt[0]) begin
      biu_fifo_valid[0] <= 1'b0;
      biu_fifo_valid[1] <= 1'b0;
      biu_fifo_valid[2] <= 1'b0;
    end
    else begin
      case ({biu_ack,if_parcel_valid})
        2'b00: ; //no action
        2'b10:   //FIFO write
          case ({biu_fifo_valid[1],biu_fifo_valid[0]})
            2'b11  : begin
              //entry 0,1 full. Fill entry2
              biu_fifo_valid[2] <= 1'b1;
            end
            2'b01  : begin
              //entry 0 full. Fill entry1, clear entry2
              biu_fifo_valid[1] <= 1'b1;
              biu_fifo_valid[2] <= 1'b0;
            end
            default: begin
              //Fill entry0, clear entry1,2
              biu_fifo_valid[0] <= 1'b1;
              biu_fifo_valid[1] <= 1'b0;
              biu_fifo_valid[2] <= 1'b0;
            end
          endcase
        2'b01: begin  //FIFO read
          biu_fifo_valid[0] <= biu_fifo_valid[1];
          biu_fifo_valid[1] <= biu_fifo_valid[2];
          biu_fifo_valid[2] <= 1'b0;
        end
        2'b11: ; //FIFO read/write, no change
      endcase
    end
  end

  //Address & Data
  always @(posedge clk) begin
    case ({biu_ack,if_parcel_valid})
      2'b00: ;
      2'b10: case({biu_fifo_valid[1],biu_fifo_valid[0]})
        2'b11 : begin
          //fill entry2
          biu_fifo_dat[2] <= biu_do;
          biu_fifo_adr[2] <= biu_adro;
        end
        2'b01 : begin
          //fill entry1
          biu_fifo_dat[1] <= biu_do;
          biu_fifo_adr[1] <= biu_adro;
        end
        default:begin
          //fill entry0
          biu_fifo_dat[0] <= biu_do;
          biu_fifo_adr[0] <= biu_adro;
        end
      endcase
      2'b01: begin
        biu_fifo_dat[0] <= biu_fifo_dat[1];
        biu_fifo_adr[0] <= biu_fifo_adr[1];
        biu_fifo_dat[1] <= biu_fifo_dat[2];
        biu_fifo_adr[1] <= biu_fifo_adr[2];
        biu_fifo_dat[2] <= 'hx;
        biu_fifo_adr[2] <= 'hx;
      end
      2'b11: casex({biu_fifo_valid[2],biu_fifo_valid[1],biu_fifo_valid[0]})
        3'b1?? : begin
          //fill entry2
          biu_fifo_dat[2] <= biu_do;
          biu_fifo_adr[2] <= biu_adro;

          //push other entries
          biu_fifo_dat[0] <= biu_fifo_dat[1];
          biu_fifo_adr[0] <= biu_fifo_adr[1];
          biu_fifo_dat[1] <= biu_fifo_dat[2];
          biu_fifo_adr[1] <= biu_fifo_adr[2];
        end
        3'b01? : begin
          //fill entry1
          biu_fifo_dat[1] <= biu_do;
          biu_fifo_adr[1] <= biu_adro;

          //push entry0
          biu_fifo_dat[0] <= biu_fifo_dat[1];
          biu_fifo_adr[0] <= biu_fifo_adr[1];

          //don't care
          biu_fifo_dat[2] <= 'hx;
          biu_fifo_adr[2] <= 'hx;
        end
        default:begin
          //fill entry0
          biu_fifo_dat[0] <= biu_do;
          biu_fifo_adr[0] <= biu_adro;

          //don't care
          biu_fifo_dat[1] <= 'hx;
          biu_fifo_adr[1] <= 'hx;
          biu_fifo_dat[2] <= 'hx;
          biu_fifo_adr[2] <= 'hx;
        end
      endcase
    endcase
  end
endmodule
