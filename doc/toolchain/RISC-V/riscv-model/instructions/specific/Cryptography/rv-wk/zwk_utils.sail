// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

function zwk_valid_reg_overlap(rs : wregidx, rd : wregidx, emul_pow : int) -> bool = {
  let reg_group_size = if emul_pow > 0 then 2 ^ emul_pow else 1;
  let rs_int = unsigned(wregidx_bits(rs));
  let rd_int = unsigned(wregidx_bits(rd));
  (rs_int + reg_group_size <= rd_int) | (rd_int + reg_group_size <= rs_int)
}

// Crypto groups contain consecutive matrix elements in row-major order.
// EGS counts those elements using logical coordinates [i][j][j].
function zwk_check_encdec(EGW : nat, EGS : nat1) -> bool = {
  if not(valid_wtype()) then return false;
  let LMUL_pow = w_get_lmul_pow();
  let LMUL_times_WLEN = if LMUL_pow < 0 then wlen / (2 ^ abs_int(LMUL_pow)) else (2 ^ LMUL_pow) * wlen in
  LMUL_times_WLEN >= EGW &
  unsigned(wl) <= LMUL_times_WLEN / w_get_sew() &
  (unsigned(wl) % EGS == 0) & (unsigned(wstart) % EGS == 0)
}

// Utility functions for Zwknh[ab]
// ----------------------------------------------------------------------

enum zwk_wsha2_funct6 = {XWK_ZWK_WSHA2CH_WW, XWK_ZWK_WSHA2CL_WW}

function zwknhab_check_encdec(ws2 : wregidx, ws1 : wregidx, wd: wregidx) -> bool = {
  let SEW      = w_get_sew();
  let LMUL_pow = w_get_lmul_pow();
  zwk_check_encdec(4 * SEW, 4) & zwk_valid_reg_overlap(ws1, wd, LMUL_pow) & zwk_valid_reg_overlap(ws2, wd, LMUL_pow);
}

val zwk_sig0 : forall 'n, 'n in {32, 64} . (bits('n), int('n)) -> bits('n)
function zwk_sig0(x, SEW) = {
  match SEW {
    32 => ((x >>> 7) ^ (x >>> 18) ^ (x >> 3)),
    64 => ((x >>> 1) ^ (x >>>  8) ^ (x >> 7)),
  }
}

val zwk_sig1 : forall 'n, 'n in {32, 64} . (bits('n), int('n)) -> bits('n)
function zwk_sig1(x, SEW) = {
  match SEW {
    32 => ((x >>> 17) ^ (x >>> 19) ^ (x >> 10)),
    64 => ((x >>> 19) ^ (x >>> 61) ^ (x >>  6)),
  }
}

val zwk_sum0 : forall 'n, 'n in {32, 64} . (bits('n), int('n)) -> bits('n)
function zwk_sum0(x, SEW) = {
  match SEW {
    32 => ((x >>>  2) ^ (x >>> 13) ^ (x >>> 22)),
    64 => ((x >>> 28) ^ (x >>> 34) ^ (x >>> 39)),
  }
}

val zwk_sum1 : forall 'n, 'n in {32, 64} . (bits('n), int('n)) -> bits('n)
function zwk_sum1(x, SEW) = {
  match SEW {
    32 => ((x >>>  6) ^ (x >>> 11) ^ (x >>> 25)),
    64 => ((x >>> 14) ^ (x >>> 18) ^ (x >>> 41)),
  }
}

val zwk_ch : forall 'n, 'n >= 0. (bits('n), bits('n), bits('n)) -> bits('n)
function zwk_ch(x, y, z) = (x & y) ^ (~(x) & z)

val zwk_maj : forall 'n, 'n >= 0. (bits('n), bits('n), bits('n)) -> bits('n)
function zwk_maj(x, y, z) = (x & y) ^ (x & z) ^ (y & z)

// Utility functions for Zwksed
// ----------------------------------------------------------------------

enum zwk_wsm4r_funct6 = {XWK_ZWK_WSM4R_WW, XWK_ZWK_WSM4R_WS}

function zwk_round_key(X : bits(32), S : bits(32)) -> bits(32) = X ^ (S ^ (S <<< 13) ^ (S <<< 23))

function zwk_sm4_round(X : bits(32), S : bits(32)) -> bits(32) =
  X ^ (S ^ (S <<< 2) ^ (S <<< 10) ^ (S <<< 18) ^ (S <<< 24))

// SM4 Constant Key (CK)
let zwksed_ck : vector(32, bits(32)) = [
  0x00070E15, 0x1C232A31, 0x383F464D, 0x545B6269,
  0x70777E85, 0x8C939AA1, 0xA8AFB6BD, 0xC4CBD2D9,
  0xE0E7EEF5, 0xFC030A11, 0x181F262D, 0x343B4249,
  0x50575E65, 0x6C737A81, 0x888F969D, 0xA4ABB2B9,
  0xC0C7CED5, 0xDCE3EAF1, 0xF8FF060D, 0x141B2229,
  0x30373E45, 0x4C535A61, 0x686F767D, 0x848B9299,
  0xA0A7AEB5, 0xBCC3CAD1, 0xD8DFE6ED, 0xF4FB0209,
  0x10171E25, 0x2C333A41, 0x484F565D, 0x646B7279,
]

function zwksed_box_lookup(x : bits(5), table : vector(32, bits(32))) -> bits(32) = {
  table[31 - unsigned(x)]
}

function zwk_sm4_ck(x : bits(5)) -> bits(32) = zwksed_box_lookup(x, zwksed_ck)

function zwk_sm4_subword(x : bits(32)) -> bits(32) = {
  sm4_sbox(x[31..24]) @
  sm4_sbox(x[23..16]) @
  sm4_sbox(x[15.. 8]) @
  sm4_sbox(x[ 7.. 0])
}

// Utility functions for Zwksh
// ----------------------------------------------------------------------

function zwk_p0(X : bits(32)) -> bits(32) = X ^ (X <<<  9) ^ (X <<< 17)

function zwk_p1(X : bits(32)) -> bits(32) = X ^ (X <<< 15) ^ (X <<< 23)

function zwk_sh_w(A : bits(32), B : bits(32), C : bits(32), D : bits(32), E : bits(32)) -> bits(32) =
  zwk_p1(A ^ B ^ (C <<< 15)) ^ (D <<< 7) ^ E

function zwk_ff1(X : bits(32), Y : bits(32), Z : bits(32)) -> bits(32) =
  X ^ Y ^ Z

function zwk_ff2(X : bits(32), Y : bits(32), Z : bits(32)) -> bits(32) =
  (X & Y) | (X & Z) | (Y & Z)

function zwk_ff_j(X : bits(32), Y : bits(32), Z : bits(32), J : nat) -> bits(32) =
  if J <= 15 then zwk_ff1(X, Y, Z) else zwk_ff2(X, Y, Z)

function zwk_gg1(X : bits(32), Y : bits(32), Z : bits(32)) -> bits(32) =
  X ^ Y ^ Z

function zwk_gg2(X : bits(32), Y : bits(32), Z : bits(32)) -> bits(32) =
  (X & Y) | (~(X) & Z)

function zwk_gg_j(X : bits(32), Y : bits(32), Z : bits(32), J : nat) -> bits(32) =
  if J <= 15 then zwk_gg1(X, Y, Z) else zwk_gg2(X, Y, Z)

function zwk_t_j(J : nat) -> bits(32) =
  if J <= 15 then 0x79CC4519 else 0x7A879D8A

function zwk_sm3_round(A_H : vector(8, bits(32)), w : bits(32), x : bits(32), j : nat) -> vector(8, bits(32)) = {
  let t_j = zwk_t_j(j) <<< (j % 32);
  let ss1 = ((A_H[0] <<< 12) + A_H[4] + t_j) <<< 7;
  let ss2 = ss1 ^ (A_H[0] <<< 12);

  let tt1 = zwk_ff_j(A_H[0], A_H[1], A_H[2], j) + A_H[3] + ss2 + x;
  let tt2 = zwk_gg_j(A_H[4], A_H[5], A_H[6], j) + A_H[7] + ss1 + w;

  let A1 = tt1;
  let C1 = A_H[1] <<< 9;
  let E1 = zwk_p0(tt2);
  let G1 = A_H[5] <<< 19;

  [ A_H[6], G1, A_H[4], E1, A_H[2], C1, A_H[0], A1 ]
}

// Utility functions for Zwkned
// ----------------------------------------------------------------------

enum zwk_waesdf_funct6 = {XWK_ZWK_WAESDF_WW, XWK_ZWK_WAESDF_WS}
enum zwk_waesdm_funct6 = {XWK_ZWK_WAESDM_WW, XWK_ZWK_WAESDM_WS}
enum zwk_waesef_funct6 = {XWK_ZWK_WAESEF_WW, XWK_ZWK_WAESEF_WS}
enum zwk_waesem_funct6 = {XWK_ZWK_WAESEM_WW, XWK_ZWK_WAESEM_WS}
