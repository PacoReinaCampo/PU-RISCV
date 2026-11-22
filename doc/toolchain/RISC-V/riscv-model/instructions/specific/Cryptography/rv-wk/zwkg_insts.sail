// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

function xw_crypto_kg_enabled() -> bool = (config extensions.Xw.crypto.kg : bool) & xw_enabled()

union clause instruction = XWK_WGHSH_WW : (wregidx, wregidx, wregidx)

$[wavedrom "_ _ _ OPMWW _ CUSTOM-2"]
mapping clause encdec = XWK_WGHSH_WW(ws2, ws1, wd)
  <-> 0b1011001 @ encdec_wreg(ws2) @ encdec_wreg(ws1) @ 0b010 @ encdec_wreg(wd) @ 0b1011011
  when valid_wtype() & xw_crypto_kg_enabled() & w_get_sew() == 32 & zwk_check_encdec(128, 4)

function clause execute XWK_WGHSH_WW(ws2, ws1, wd) = {
  let SEW      = w_get_sew();
  let LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(LMUL_pow, SEW);

  if not(w_valid_reg_group(ws1, LMUL_pow)) |
     not(w_valid_reg_group(ws2, LMUL_pow)) |
     not(w_valid_reg_group(wd, LMUL_pow))
  then return Illegal_Instruction();

  assert(SEW == 32);

  let ws2_val = read_wreg(num_elem, SEW, LMUL_pow, ws2);
  let ws1_val = read_wreg(num_elem, SEW, LMUL_pow, ws1);
  let wd_val  = read_wreg(num_elem, SEW, LMUL_pow, wd);

  let group_count = (unsigned(wl) / 4);
  let first_group = (unsigned(wstart) / 4);

  foreach (group_index from first_group to (group_count - 1)) {
    assert(group_index * 4 + 3 < num_elem);

    let Y : bits(128) = get_welem_quad(wd_val, group_index);
    let X : bits(128) = get_welem_quad(ws1_val, group_index);
    var H : bits(128) = brev8(get_welem_quad(ws2_val, group_index));

    var Z : bits(128) = zeros();
    let S : bits(128) = brev8(Y ^ X);

    foreach (b from 0 to 127) {
      if S[b] == 0b1 then Z = Z ^ H;

      let reduce = H[127] == 0b1;
      H = H << 1;
      if reduce then H = H[127..8] @ (H[7..0] ^ 0x87);
    };

    write_welem_quad(wd, SEW, brev8(Z), group_index);
  };

  set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = XWK_WGHSH_WW(ws2, ws1, wd)
  <-> "wghsh.ww" ^ spc() ^ wreg_name(wd) ^ sep() ^ wreg_name(ws2) ^ sep() ^ wreg_name(ws1)

union clause instruction = XWK_WGMUL_WW : (wregidx, wregidx)

$[wavedrom "_ _ _ OPMWW _ CUSTOM-2"]
mapping clause encdec = XWK_WGMUL_WW(ws2, wd)
  <-> 0b1010001 @ encdec_wreg(ws2) @ 0b10001 @ 0b010 @ encdec_wreg(wd) @ 0b1011011
  when valid_wtype() & xw_crypto_kg_enabled() & w_get_sew() == 32 & zwk_check_encdec(128, 4)

function clause execute XWK_WGMUL_WW(ws2, wd) = {
  let SEW      = w_get_sew();
  let LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(LMUL_pow, SEW);

  if not(w_valid_reg_group(ws2, LMUL_pow)) |
     not(w_valid_reg_group(wd, LMUL_pow))
  then return Illegal_Instruction();

  assert(SEW == 32);

  let ws2_val = read_wreg(num_elem, SEW, LMUL_pow, ws2);
  let wd_val  = read_wreg(num_elem, SEW, LMUL_pow, wd);

  let group_count = (unsigned(wl) / 4);
  let first_group = (unsigned(wstart) / 4);

  foreach (group_index from first_group to (group_count - 1)) {
    assert(group_index * 4 + 3 < num_elem);

    let Y : bits(128) = brev8(get_welem_quad(wd_val, group_index));
    var H : bits(128) = brev8(get_welem_quad(ws2_val, group_index));
    var Z : bits(128) = zeros();

    foreach (b from 0 to 127) {
      if Y[b] == 0b1 then Z = Z ^ H;

      let reduce = H[127] == 0b1;
      H = H << 1;
      if reduce then H = H[127..8] @ (H[7..0] ^ 0x87);
    };

    write_welem_quad(wd, SEW, brev8(Z), group_index);
  };

  set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = XWK_WGMUL_WW(ws2, wd)
  <-> "wgmul.ww" ^ spc() ^ wreg_name(wd) ^ sep() ^ wreg_name(ws2)
