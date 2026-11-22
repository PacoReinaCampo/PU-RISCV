// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

function xw_crypto_knha_enabled() -> bool = (config extensions.Xw.crypto.knha : bool) & xw_enabled()
function xw_crypto_knhb_enabled() -> bool = (config extensions.Xw.crypto.knhb : bool) & xw_64_enabled()

union clause instruction = XWK_WSHA2MS_WW : (wregidx, wregidx, wregidx)

$[wavedrom "_ _ _ _ OPMWW _ CUSTOM-2"]
mapping clause encdec = XWK_WSHA2MS_WW(ws2, ws1, wd)
  <-> 0b101101 @ 0b1 @ encdec_wreg(ws2) @ encdec_wreg(ws1) @ 0b010 @ encdec_wreg(wd) @ 0b1011011
  when valid_wtype() & ((xw_crypto_knha_enabled() & w_get_sew() == 32) | (xw_crypto_knhb_enabled() & (w_get_sew() == 32 | w_get_sew() == 64))) & zwknhab_check_encdec(ws2, ws1, wd)

mapping clause assembly = XWK_WSHA2MS_WW(ws2, ws1, wd)
  <-> "wsha2ms.ww" ^ spc() ^ wreg_name(wd) ^ sep() ^ wreg_name(ws2) ^ sep() ^ wreg_name(ws1)

function clause execute XWK_WSHA2MS_WW(ws2, ws1, wd) = {
  let 'SEW     = w_get_sew();
  let LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(LMUL_pow, SEW);

  if not(w_valid_reg_group(ws1, LMUL_pow)) |
     not(w_valid_reg_group(ws2, LMUL_pow)) |
     not(w_valid_reg_group(wd, LMUL_pow))
  then return Illegal_Instruction();

  assert(SEW == 32 | SEW == 64);

  let ws2_val = read_wreg(num_elem, SEW, LMUL_pow, ws2);
  let ws1_val = read_wreg(num_elem, SEW, LMUL_pow, ws1);
  let wd_val  = read_wreg(num_elem, SEW, LMUL_pow, wd);

  var w : vector(20, bits('SEW)) = vector_init(zeros());

  let group_count = (unsigned(wl) / 4);
  let first_group = (unsigned(wstart) / 4);

  foreach (group_index from first_group to (group_count - 1)) {
    let position = group_index * 4;
    assert(position + 3 < num_elem);

    w = [w with
      0  = wd_val[position],
      1  = wd_val[position + 1],
      2  = wd_val[position + 2],
      3  = wd_val[position + 3],

      4  = ws2_val[position],
      9  = ws2_val[position + 1],
      10 = ws2_val[position + 2],
      11 = ws2_val[position + 3],

      12 = ws1_val[position],
      13 = ws1_val[position + 1],
      14 = ws1_val[position + 2],
      15 = ws1_val[position + 3]
    ];

    w[16] = zwk_sig1(w[14], SEW) + w[9]  + zwk_sig0(w[1], SEW) + w[0];
    w[17] = zwk_sig1(w[15], SEW) + w[10] + zwk_sig0(w[2], SEW) + w[1];
    w[18] = zwk_sig1(w[16], SEW) + w[11] + zwk_sig0(w[3], SEW) + w[2];
    w[19] = zwk_sig1(w[17], SEW) + w[12] + zwk_sig0(w[4], SEW) + w[3];

    write_welem_quad(wd, SEW, w[19] @ w[18] @ w[17] @ w[16], group_index);
  };

  set_wstart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XWK_ZWKSHA2TYPE : (zwk_wsha2_funct6, wregidx, wregidx, wregidx)

mapping wk_encdec_vsha2 : zwk_wsha2_funct6 <-> bits(6) = {
  XWK_ZWK_WSHA2CH_WW <-> 0b101110,
  XWK_ZWK_WSHA2CL_WW <-> 0b101111,
}

$[wavedrom "WSHA2C.OP _ _ _ OPMWW _ CUSTOM-2"]
mapping clause encdec = XWK_ZWKSHA2TYPE(funct6, ws2, ws1, wd)
  <-> wk_encdec_vsha2(funct6) @ 0b1 @ encdec_wreg(ws2) @ encdec_wreg(ws1) @ 0b010 @ encdec_wreg(wd) @ 0b1011011
  when valid_wtype() & ((xw_crypto_knha_enabled() & w_get_sew() == 32) | (xw_crypto_knhb_enabled() & (w_get_sew() == 32 | w_get_sew() == 64))) & zwknhab_check_encdec(ws2, ws1, wd)

mapping wk_sha2_mnemonic : zwk_wsha2_funct6 <-> string = {
  XWK_ZWK_WSHA2CH_WW <-> "wsha2ch.ww",
  XWK_ZWK_WSHA2CL_WW <-> "wsha2cl.ww",
}

mapping clause assembly = XWK_ZWKSHA2TYPE(funct6, ws2, ws1, wd)
  <-> wk_sha2_mnemonic(funct6) ^ spc() ^ wreg_name(wd) ^ sep() ^ wreg_name(ws2) ^ sep() ^ wreg_name(ws1)

function clause execute XWK_ZWKSHA2TYPE(funct6, ws2, ws1, wd) = {
  let SEW      = w_get_sew();
  let LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(LMUL_pow, SEW);

  if not(w_valid_reg_group(ws1, LMUL_pow)) |
     not(w_valid_reg_group(ws2, LMUL_pow)) |
     not(w_valid_reg_group(wd, LMUL_pow))
  then return Illegal_Instruction();

  assert(SEW == 32 | SEW == 64);

  let ws2_val = read_wreg(num_elem, SEW, LMUL_pow, ws2);
  let ws1_val = read_wreg(num_elem, SEW, LMUL_pow, ws1);
  let wd_val  = read_wreg(num_elem, SEW, LMUL_pow, wd);

  let group_count = (unsigned(wl) / 4);
  let first_group = (unsigned(wstart) / 4);

  foreach (group_index from first_group to (group_count - 1)) {
    let position = group_index * 4;
    assert(position + 3 < num_elem);

    var f = ws2_val[position + 0];
    var e = ws2_val[position + 1];
    var b = ws2_val[position + 2];
    var a = ws2_val[position + 3];

    var h = wd_val[position + 0];
    var g = wd_val[position + 1];
    var d = wd_val[position + 2];
    var c = wd_val[position + 3];

    let message_sched_plus_c = get_welem_quad(ws1_val, group_index);

    let w0 = if funct6 == XWK_ZWK_WSHA2CL_WW
             then message_sched_plus_c[(SEW * 1) - 1 .. 0]
             else message_sched_plus_c[(SEW * 3) - 1 .. (SEW * 2)];

    let w1 = if funct6 == XWK_ZWK_WSHA2CL_WW
             then message_sched_plus_c[(SEW * 2) - 1 .. SEW]
             else message_sched_plus_c[(SEW * 4) - 1 .. (SEW * 3)];

    var T1 = h + zwk_sum1(e, SEW) + zwk_ch(e,f,g) + w0;
    var T2 = zwk_sum0(a, SEW) + zwk_maj(a, b, c);

    h  = g;
    g  = f;
    f  = e;
    e  = d + T1;
    d  = c;
    c  = b;
    b  = a;
    a  = T1 + T2;

    T1 = h + zwk_sum1(e, SEW) + zwk_ch(e, f, g) + w1;
    T2 = zwk_sum0(a, SEW) + zwk_maj(a, b, c);
    h  = g;
    g  = f;
    f  = e;
    e  = d + T1;
    d  = c;
    c  = b;
    b  = a;
    a  = T1 + T2;

    write_welem_quad(wd, SEW, a @ b @ e @ f, group_index);
  };

  set_wstart(zeros());
  RETIRE_SUCCESS
}
