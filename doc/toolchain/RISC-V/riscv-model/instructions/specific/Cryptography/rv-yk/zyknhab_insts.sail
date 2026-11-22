// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

function xy_crypto_knha_enabled() -> bool = (config extensions.Xy.crypto.knha : bool) & xy_enabled()
function xy_crypto_knhb_enabled() -> bool = (config extensions.Xy.crypto.knhb : bool) & xy_64_enabled()

union clause instruction = XYK_YSHA2MS_YY : (yregidx, yregidx, yregidx)

$[wavedrom "_ _ _ _ OPMYY _ CUSTOM-3"]
mapping clause encdec = XYK_YSHA2MS_YY(ys2, ys1, yd)
  <-> 0b101101 @ 0b1 @ encdec_yreg(ys2) @ encdec_yreg(ys1) @ 0b010 @ encdec_yreg(yd) @ 0b1111011
  when valid_ytype() & ((xy_crypto_knha_enabled() & y_get_sew() == 32) | (xy_crypto_knhb_enabled() & (y_get_sew() == 32 | y_get_sew() == 64))) & zyknhab_check_encdec(ys2, ys1, yd)

mapping clause assembly = XYK_YSHA2MS_YY(ys2, ys1, yd)
  <-> "ysha2ms.yy" ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2) ^ sep() ^ yreg_name(ys1)

function clause execute XYK_YSHA2MS_YY(ys2, ys1, yd) = {
  let 'SEW     = y_get_sew();
  let LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(LMUL_pow, SEW);

  if not(y_valid_reg_group(ys1, LMUL_pow)) |
     not(y_valid_reg_group(ys2, LMUL_pow)) |
     not(y_valid_reg_group(yd, LMUL_pow))
  then return Illegal_Instruction();

  assert(SEW == 32 | SEW == 64);

  let ys2_val = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let ys1_val = read_yreg(num_elem, SEW, LMUL_pow, ys1);
  let yd_val  = read_yreg(num_elem, SEW, LMUL_pow, yd);

  var w : vector(20, bits('SEW)) = vector_init(zeros());

  let group_count = (unsigned(yl) / 4);
  let first_group = (unsigned(ystart) / 4);

  foreach (group_index from first_group to (group_count - 1)) {
    let position = group_index * 4;
    assert(position + 3 < num_elem);

    w = [w with
      0  = yd_val[position],
      1  = yd_val[position + 1],
      2  = yd_val[position + 2],
      3  = yd_val[position + 3],

      4  = ys2_val[position],
      9  = ys2_val[position + 1],
      10 = ys2_val[position + 2],
      11 = ys2_val[position + 3],

      12 = ys1_val[position],
      13 = ys1_val[position + 1],
      14 = ys1_val[position + 2],
      15 = ys1_val[position + 3]
    ];

    w[16] = zyk_sig1(w[14], SEW) + w[9]  + zyk_sig0(w[1], SEW) + w[0];
    w[17] = zyk_sig1(w[15], SEW) + w[10] + zyk_sig0(w[2], SEW) + w[1];
    w[18] = zyk_sig1(w[16], SEW) + w[11] + zyk_sig0(w[3], SEW) + w[2];
    w[19] = zyk_sig1(w[17], SEW) + w[12] + zyk_sig0(w[4], SEW) + w[3];

    write_yelem_quad(yd, SEW, w[19] @ w[18] @ w[17] @ w[16], group_index);
  };

  set_ystart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XYK_ZYKSHA2TYPE : (zyk_ysha2_funct6, yregidx, yregidx, yregidx)

mapping yk_encdec_vsha2 : zyk_ysha2_funct6 <-> bits(6) = {
  XYK_ZYK_YSHA2CH_YY <-> 0b101110,
  XYK_ZYK_YSHA2CL_YY <-> 0b101111,
}

$[wavedrom "YSHA2C.OP _ _ _ OPMYY _ CUSTOM-3"]
mapping clause encdec = XYK_ZYKSHA2TYPE(funct6, ys2, ys1, yd)
  <-> yk_encdec_vsha2(funct6) @ 0b1 @ encdec_yreg(ys2) @ encdec_yreg(ys1) @ 0b010 @ encdec_yreg(yd) @ 0b1111011
  when valid_ytype() & ((xy_crypto_knha_enabled() & y_get_sew() == 32) | (xy_crypto_knhb_enabled() & (y_get_sew() == 32 | y_get_sew() == 64))) & zyknhab_check_encdec(ys2, ys1, yd)

mapping yk_sha2_mnemonic : zyk_ysha2_funct6 <-> string = {
  XYK_ZYK_YSHA2CH_YY <-> "ysha2ch.yy",
  XYK_ZYK_YSHA2CL_YY <-> "ysha2cl.yy",
}

mapping clause assembly = XYK_ZYKSHA2TYPE(funct6, ys2, ys1, yd)
  <-> yk_sha2_mnemonic(funct6) ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2) ^ sep() ^ yreg_name(ys1)

function clause execute XYK_ZYKSHA2TYPE(funct6, ys2, ys1, yd) = {
  let SEW      = y_get_sew();
  let LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(LMUL_pow, SEW);

  if not(y_valid_reg_group(ys1, LMUL_pow)) |
     not(y_valid_reg_group(ys2, LMUL_pow)) |
     not(y_valid_reg_group(yd, LMUL_pow))
  then return Illegal_Instruction();

  assert(SEW == 32 | SEW == 64);

  let ys2_val = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let ys1_val = read_yreg(num_elem, SEW, LMUL_pow, ys1);
  let yd_val  = read_yreg(num_elem, SEW, LMUL_pow, yd);

  let group_count = (unsigned(yl) / 4);
  let first_group = (unsigned(ystart) / 4);

  foreach (group_index from first_group to (group_count - 1)) {
    let position = group_index * 4;
    assert(position + 3 < num_elem);

    var f = ys2_val[position + 0];
    var e = ys2_val[position + 1];
    var b = ys2_val[position + 2];
    var a = ys2_val[position + 3];

    var h = yd_val[position + 0];
    var g = yd_val[position + 1];
    var d = yd_val[position + 2];
    var c = yd_val[position + 3];

    let message_sched_plus_c = get_yelem_quad(ys1_val, group_index);

    let w0 = if funct6 == XYK_ZYK_YSHA2CL_YY
             then message_sched_plus_c[(SEW * 1) - 1 .. 0]
             else message_sched_plus_c[(SEW * 3) - 1 .. (SEW * 2)];

    let w1 = if funct6 == XYK_ZYK_YSHA2CL_YY
             then message_sched_plus_c[(SEW * 2) - 1 .. SEW]
             else message_sched_plus_c[(SEW * 4) - 1 .. (SEW * 3)];

    var T1 = h + zyk_sum1(e, SEW) + zyk_ch(e,f,g) + w0;
    var T2 = zyk_sum0(a, SEW) + zyk_maj(a, b, c);

    h  = g;
    g  = f;
    f  = e;
    e  = d + T1;
    d  = c;
    c  = b;
    b  = a;
    a  = T1 + T2;

    T1 = h + zyk_sum1(e, SEW) + zyk_ch(e, f, g) + w1;
    T2 = zyk_sum0(a, SEW) + zyk_maj(a, b, c);
    h  = g;
    g  = f;
    f  = e;
    e  = d + T1;
    d  = c;
    c  = b;
    b  = a;
    a  = T1 + T2;

    write_yelem_quad(yd, SEW, a @ b @ e @ f, group_index);
  };

  set_ystart(zeros());
  RETIRE_SUCCESS
}
