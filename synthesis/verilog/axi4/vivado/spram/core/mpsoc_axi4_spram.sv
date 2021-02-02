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
//              Single Port SRAM                                              //
//              AMBA4 AXI-Lite Bus Interface                                  //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

/* Copyright (c) 2018-2019 by the author(s)
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

module mpsoc_axi4_spram #(
  parameter int unsigned AXI_ID_WIDTH      = 10,
  parameter int unsigned AXI_ADDR_WIDTH    = 64,
  parameter int unsigned AXI_DATA_WIDTH    = 64,
  parameter int unsigned AXI_STRB_WIDTH    = 8,
  parameter int unsigned AXI_USER_WIDTH    = 10
)
  (
    input  logic                        clk_i,   // Clock
    input  logic                        rst_ni,  // Asynchronous reset active low

    input  logic [AXI_ID_WIDTH    -1:0] axi_aw_id,
    input  logic [AXI_ADDR_WIDTH  -1:0] axi_aw_addr,
    input  logic [                 7:0] axi_aw_len,
    input  logic [                 2:0] axi_aw_size,
    input  logic [                 1:0] axi_aw_burst,
    input  logic                        axi_aw_lock,
    input  logic [                 3:0] axi_aw_cache,
    input  logic [                 2:0] axi_aw_prot,
    input  logic [                 3:0] axi_aw_qos,
    input  logic [                 3:0] axi_aw_region,
    input  logic [AXI_USER_WIDTH  -1:0] axi_aw_user,
    input  logic                        axi_aw_valid,
    output logic                        axi_aw_ready,

    input  logic [AXI_ID_WIDTH    -1:0] axi_ar_id,
    input  logic [AXI_ADDR_WIDTH  -1:0] axi_ar_addr,
    input  logic [                 7:0] axi_ar_len,
    input  logic [                 2:0] axi_ar_size,
    input  logic [                 1:0] axi_ar_burst,
    input  logic                        axi_ar_lock,
    input  logic [                 3:0] axi_ar_cache,
    input  logic [                 2:0] axi_ar_prot,
    input  logic [                 3:0] axi_ar_qos,
    input  logic [                 3:0] axi_ar_region,
    input  logic [AXI_USER_WIDTH  -1:0] axi_ar_user,
    input  logic                        axi_ar_valid,
    output logic                        axi_ar_ready,

    input  logic [AXI_DATA_WIDTH  -1:0] axi_w_data,
    input  logic [AXI_STRB_WIDTH  -1:0] axi_w_strb,
    input  logic                        axi_w_last,
    input  logic [AXI_USER_WIDTH  -1:0] axi_w_user,
    input  logic                        axi_w_valid,
    output logic                        axi_w_ready,

    output logic [AXI_ID_WIDTH    -1:0] axi_r_id,
    output logic [AXI_DATA_WIDTH  -1:0] axi_r_data,
    output logic [                 1:0] axi_r_resp,
    output logic                        axi_r_last,
    output logic [AXI_USER_WIDTH  -1:0] axi_r_user,
    output logic                        axi_r_valid,
    input  logic                        axi_r_ready,

    output logic [AXI_ID_WIDTH    -1:0] axi_b_id,
    output logic [                 1:0] axi_b_resp,
    output logic [AXI_USER_WIDTH  -1:0] axi_b_user,
    output logic                        axi_b_valid,
    input  logic                        axi_b_ready,

    output logic                        req_o,
    output logic                        we_o,
    output logic [AXI_ADDR_WIDTH  -1:0] addr_o,
    output logic [AXI_DATA_WIDTH/8-1:0] be_o,
    output logic [AXI_DATA_WIDTH  -1:0] data_o,
    input  logic [AXI_DATA_WIDTH  -1:0] data_i
  );

  // AXI has the following rules governing the use of bursts:
  // - for wrapping bursts, the burst length must be 2, 4, 8, or 16
  // - a burst must not cross a 4KB address boundary
  // - early termination of bursts is not supported.
  typedef enum logic [1:0] { FIXED = 2'b00, INCR = 2'b01, WRAP = 2'b10} axi_burst_t;

  localparam LOG_NR_BYTES = $clog2(AXI_DATA_WIDTH/8);

  typedef struct packed {
    logic [AXI_ID_WIDTH  -1:0] id;
    logic [AXI_ADDR_WIDTH-1:0] addr;
    logic [               7:0] len;
    logic [               2:0] size;
    axi_burst_t                burst;
  } ax_req_t;

  // Registers
  enum logic [2:0] { IDLE, READ, WRITE, SEND_B, WAIT_WVALID }  state_d, state_q;
  ax_req_t                   ax_req_d, ax_req_q;
  logic [AXI_ADDR_WIDTH-1:0] req_addr_d, req_addr_q;
  logic [               7:0] cnt_d, cnt_q;

  function automatic logic [AXI_ADDR_WIDTH-1:0] get_wrap_boundary (
    input logic [AXI_ADDR_WIDTH-1:0] unaligned_address,
    input logic [               7:0] len
  );
    logic [AXI_ADDR_WIDTH-1:0] warp_address = '0;
    //  for wrapping transfers ax_len can only be of size 1, 3, 7 or 15
    if      (len == 4'b0001) begin
      warp_address[AXI_ADDR_WIDTH-1:1+LOG_NR_BYTES] = unaligned_address[AXI_ADDR_WIDTH-1:1+LOG_NR_BYTES];
    end
    else if (len == 4'b0011) begin
      warp_address[AXI_ADDR_WIDTH-1:2+LOG_NR_BYTES] = unaligned_address[AXI_ADDR_WIDTH-1:2+LOG_NR_BYTES];
    end
    else if (len == 4'b0111) begin
      warp_address[AXI_ADDR_WIDTH-1:3+LOG_NR_BYTES] = unaligned_address[AXI_ADDR_WIDTH-3:2+LOG_NR_BYTES];
    end
    else if (len == 4'b1111) begin
      warp_address[AXI_ADDR_WIDTH-1:4+LOG_NR_BYTES] = unaligned_address[AXI_ADDR_WIDTH-3:4+LOG_NR_BYTES];
    end

    return warp_address;
  endfunction

  logic [AXI_ADDR_WIDTH-1:0] aligned_address;
  logic [AXI_ADDR_WIDTH-1:0] wrap_boundary;
  logic [AXI_ADDR_WIDTH-1:0] upper_wrap_boundary;
  logic [AXI_ADDR_WIDTH-1:0] cons_addr;

  always_comb begin
    // address generation
    aligned_address = {ax_req_q.addr[AXI_ADDR_WIDTH-1:LOG_NR_BYTES], {{LOG_NR_BYTES}{1'b0}}};
    wrap_boundary = get_wrap_boundary(ax_req_q.addr, ax_req_q.len);
    // this will overflow
    upper_wrap_boundary = wrap_boundary + ((ax_req_q.len + 1) << LOG_NR_BYTES);
    // calculate consecutive address
    cons_addr = aligned_address + (cnt_q << LOG_NR_BYTES);

    // Transaction attributes
    // default assignments
    state_d    = state_q;
    ax_req_d   = ax_req_q;
    req_addr_d = req_addr_q;
    cnt_d      = cnt_q;
    // Memory default assignments
    data_o = axi_w_data;
    be_o   = axi_w_strb;
    we_o   = 1'b0;
    req_o  = 1'b0;
    addr_o = '0;
    // AXI assignments
    // request
    axi_aw_ready = 1'b0;
    axi_ar_ready = 1'b0;
    // read response channel
    axi_r_valid  = 1'b0;
    axi_r_data   = data_i;
    axi_r_resp   = '0;
    axi_r_last   = '0;
    axi_r_id     = ax_req_q.id;
    axi_r_user   = '0;
    // slave write data channel
    axi_w_ready  = 1'b0;
    // write response channel
    axi_b_valid  = 1'b0;
    axi_b_resp   = 1'b0;
    axi_b_id     = 1'b0;
    axi_b_user   = 1'b0;

    case (state_q)

      IDLE: begin
        // Wait for a read or write
        // Read
        if (axi_ar_valid) begin
          axi_ar_ready = 1'b1;
          // sample ax
          ax_req_d       = {axi_ar_id, axi_ar_addr, axi_ar_len, axi_ar_size, axi_ar_burst};
          state_d        = READ;
          //  we can request the first address, this saves us time
          req_o          = 1'b1;
          addr_o         = axi_ar_addr;
          // save the address
          req_addr_d     = axi_ar_addr;
          // save the ar_len
          cnt_d          = 1;
          // Write
        end
        else if (axi_aw_valid) begin
          axi_aw_ready = 1'b1;
          axi_w_ready  = 1'b1;
          addr_o         = axi_aw_addr;
          // sample ax
          ax_req_d       = {axi_aw_id, axi_aw_addr, axi_aw_len, axi_aw_size, axi_aw_burst};
          // we've got our first w_valid so start the write process
          if (axi_w_valid) begin
            req_o          = 1'b1;
            we_o           = 1'b1;
            state_d        = (axi_w_last) ? SEND_B : WRITE;
            cnt_d          = 1;
            // we still have to wait for the first w_valid to arrive
          end
          else
            state_d = WAIT_WVALID;
        end
      end

      // ~> we are still missing a w_valid
      WAIT_WVALID: begin
        axi_w_ready = 1'b1;
        addr_o = ax_req_q.addr;
        // we can now make our first request
        if (axi_w_valid) begin
          req_o          = 1'b1;
          we_o           = 1'b1;
          state_d        = (axi_w_last) ? SEND_B : WRITE;
          cnt_d          = 1;
        end
      end

      READ: begin
        // keep request to memory high
        req_o  = 1'b1;
        addr_o = req_addr_q;
        // send the response
        axi_r_valid = 1'b1;
        axi_r_data  = data_i;
        axi_r_id    = ax_req_q.id;
        axi_r_last  = (cnt_q == ax_req_q.len + 1);

        // check that the master is ready, the slave must not wait on this
        if (axi_r_ready) begin
          // Next address generation
          // handle the correct burst type
          case (ax_req_q.burst)
            FIXED, INCR: addr_o = cons_addr;
            WRAP:  begin
              // check if the address reached warp boundary
              if (cons_addr == upper_wrap_boundary) begin
                addr_o = wrap_boundary;
                // address warped beyond boundary
              end
              else if (cons_addr > upper_wrap_boundary) begin
                addr_o = ax_req_q.addr + ((cnt_q - ax_req_q.len) << LOG_NR_BYTES);
                // we are still in the incremental regime
              end
              else begin
                addr_o = cons_addr;
              end
            end
          endcase
          // we need to change the address here for the upcoming request
          // we sent the last byte -> go back to idle
          if (axi_r_last) begin
            state_d = IDLE;
            // we already got everything
            req_o = 1'b0;
          end
          // save the request address for the next cycle
          req_addr_d = addr_o;
          // we can decrease the counter as the master has consumed the read data
          cnt_d = cnt_q + 1;
          // TODO: configure correct byte-lane
        end
      end
      // ~> we already wrote the first word here
      WRITE: begin

        axi_w_ready = 1'b1;

        // consume a word here
        if (axi_w_valid) begin
          req_o         = 1'b1;
          we_o          = 1'b1;
          // Next address generation
          // handle the correct burst type
          case (ax_req_q.burst)

            FIXED, INCR: addr_o = cons_addr;
            WRAP:  begin
              // check if the address reached warp boundary
              if (cons_addr == upper_wrap_boundary) begin
                addr_o = wrap_boundary;
                // address warped beyond boundary
              end
              else if (cons_addr > upper_wrap_boundary) begin
                addr_o = ax_req_q.addr + ((cnt_q - ax_req_q.len) << LOG_NR_BYTES);
                // we are still in the incremental regime
              end
              else begin
                addr_o = cons_addr;
              end
            end
          endcase
          // save the request address for the next cycle
          req_addr_d = addr_o;
          // we can decrease the counter as the master has consumed the read data
          cnt_d = cnt_q + 1;

          if (axi_w_last)
            state_d = SEND_B;
        end
      end
      // ~> send a write acknowledge back
      SEND_B: begin
        axi_b_valid = 1'b1;
        axi_b_id    = ax_req_q.id;
        if (axi_b_ready)
          state_d = IDLE;
      end
    endcase
  end

  // Registers
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      state_q    <= IDLE;
      ax_req_q   <= '0;
      req_addr_q <= '0;
      cnt_q      <= '0;
    end
    else begin
      state_q    <= state_d;
      ax_req_q   <= ax_req_d;
      req_addr_q <= req_addr_d;
      cnt_q      <= cnt_d;
    end
  end
endmodule
