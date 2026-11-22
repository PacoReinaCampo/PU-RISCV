// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

function xw_crypto_ksed_enabled() -> bool = (config extensions.Xw.crypto.ksed : bool) & xw_enabled()

union clause instruction = XWK_WSM4K_WI : (wregidx, bits(5), wregidx)

$[wavedrom "_ _ _ _ OPMWW _ CUSTOM-2"]
mapping clause encdec = XWK_WSM4K_WI(ws2, uimm, wd)
  <-> 0b100001 @ 0b1 @ encdec_wreg(ws2) @ uimm @ 0b010 @ encdec_wreg(wd) @ 0b1011011
  when valid_wtype() & xw_crypto_ksed_enabled() & w_get_sew() == 32 & zwk_check_encdec(128, 4)

function clause execute XWK_WSM4K_WI(ws2, uimm, wd) = {
  let SEW      = w_get_sew();
  let LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(LMUL_pow, SEW);

  if not(w_valid_reg_group(ws2, LMUL_pow)) |
     not(w_valid_reg_group(wd, LMUL_pow))
  then return Illegal_Instruction();

  assert(SEW == 32);

  let ws2_val = read_wreg(num_elem, SEW, LMUL_pow, ws2);

  let ck_index : bits(5) = uimm[2..0] @ 0b00;

  let group_count = (unsigned(wl) / 4);
  let first_group = (unsigned(wstart) / 4);

  foreach (group_index from first_group to (group_count - 1)) {
    assert(group_index * 4 + 3 < num_elem);

    let rk_in = get_welem_quad_vec(ws2_val, group_index);

    var rk_out : vector(4, bits(32)) = vector_init(zeros());

    var B = rk_in[1] ^ rk_in[2] ^ rk_in[3] ^ zwk_sm4_ck(ck_index);
    var S = zwk_sm4_subword(B);
    rk_out[0] = zwk_round_key(rk_in[0], S);

    B = rk_in[2]  ^ rk_in[3]  ^ rk_out[0] ^ zwk_sm4_ck(ck_index + to_bits(5, 1));
    S = zwk_sm4_subword(B);
    rk_out[1] = zwk_round_key(rk_in[1], S);

    B = rk_in[3]  ^ rk_out[0] ^ rk_out[1] ^ zwk_sm4_ck(ck_index + to_bits(5, 2));
    S = zwk_sm4_subword(B);
    rk_out[2] = zwk_round_key(rk_in[2], S);

    B = rk_out[0] ^ rk_out[1] ^ rk_out[2] ^ zwk_sm4_ck(ck_index + to_bits(5, 3));
    S = zwk_sm4_subword(B);
    rk_out[3] = zwk_round_key(rk_in[3], S);

    write_welem_quad_vec(wd, SEW, rk_out, group_index);
  };

  set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = XWK_WSM4K_WI(ws2, uimm, wd)
  <-> "wsm4k.wi" ^ spc() ^ wreg_name(wd) ^ sep() ^ wreg_name(ws2) ^ sep() ^ hex_bits_5(uimm)

union clause instruction = XWK_ZWKSM4RTYPE : (zwk_wsm4r_funct6, wregidx, wregidx)

$[wavedrom "_ _ _ _ OPMWW _ CUSTOM-2"]
mapping clause encdec = XWK_ZWKSM4RTYPE(XWK_ZWK_WSM4R_WW, ws2, wd)
  <-> 0b101000 @ 0b1 @ encdec_wreg(ws2) @ 0b10000 @ 0b010 @ encdec_wreg(wd) @ 0b1011011
  when valid_wtype() & xw_crypto_ksed_enabled() & w_get_sew() == 32 & zwk_check_encdec(128, 4)

$[wavedrom "_ _ _ _ OPMWW _ CUSTOM-2"]
mapping clause encdec = XWK_ZWKSM4RTYPE(XWK_ZWK_WSM4R_WS, ws2, wd)
  <-> 0b101001 @ 0b1 @ encdec_wreg(ws2) @ 0b10000 @ 0b010 @ encdec_wreg(wd) @ 0b1011011
  when valid_wtype() & xw_crypto_ksed_enabled() & w_get_sew() == 32 & zwk_check_encdec(128, 4) & zwk_valid_reg_overlap(ws2, wd, w_get_lmul_pow())

function clause execute XWK_ZWKSM4RTYPE(funct6, ws2, wd) = {
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

    let rk_in = if funct6 == XWK_ZWK_WSM4R_WW
                then get_welem_quad_vec(ws2_val, group_index)
                else get_welem_quad_vec(ws2_val, 0);

    let x_in  = get_welem_quad_vec(wd_val, group_index);

    var x_out : vector(4, bits(32)) = vector_init(zeros());

    var B = x_in[1] ^ x_in[2] ^ x_in[3] ^ rk_in[0];
    var S = zwk_sm4_subword(B);
    x_out[0] = zwk_sm4_round(x_in[0], S);

    B = x_in[2]  ^ x_in[3]  ^ x_out[0] ^ rk_in[1];
    S = zwk_sm4_subword(B);
    x_out[1] = zwk_sm4_round(x_in[1], S);

    B = x_in[3]  ^ x_out[0] ^ x_out[1] ^ rk_in[2];
    S = zwk_sm4_subword(B);
    x_out[2] = zwk_sm4_round(x_in[2], S);

    B = x_out[0] ^ x_out[1] ^ x_out[2] ^ rk_in[3];
    S = zwk_sm4_subword(B);
    x_out[3] = zwk_sm4_round(x_in[3], S);

    write_welem_quad_vec(wd, SEW, x_out, group_index);
  };

  set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping wk_sm4r_mnemonic : zwk_wsm4r_funct6 <-> string = {
   XWK_ZWK_WSM4R_WW <-> "wsm4r.ww",
   XWK_ZWK_WSM4R_WS <-> "wsm4r.ws",
}

mapping clause assembly = XWK_ZWKSM4RTYPE(funct6, ws2, wd)
  <-> wk_sm4r_mnemonic(funct6) ^ spc() ^ wreg_name(wd) ^ sep() ^ wreg_name(ws2)
