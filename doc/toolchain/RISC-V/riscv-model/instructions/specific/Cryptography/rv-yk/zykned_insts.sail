// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

function xy_crypto_kned_enabled() -> bool = (config extensions.Xy.crypto.kned : bool) & xy_enabled()

union clause instruction = XYK_YAESDF : (zyk_yaesdf_funct6, yregidx, yregidx)

mapping yk_encdec_vaesdf : zyk_yaesdf_funct6 <-> bits(6) = {
  XYK_ZYK_YAESDF_YY <-> 0b101000,
  XYK_ZYK_YAESDF_YS <-> 0b101001,
}

$[wavedrom "YAESDF.OP _ _ _ OPMYY _ CUSTOM-3"]
mapping clause encdec = XYK_YAESDF(funct6, ys2, yd)
  <-> yk_encdec_vaesdf(funct6) @ 0b1 @ encdec_yreg(ys2) @ 0b00001 @ 0b010 @ encdec_yreg(yd) @ 0b1111011
  when valid_ytype() & xy_crypto_kned_enabled() & y_get_sew() == 32 & zyk_check_encdec(128, 4) & (funct6 == XYK_ZYK_YAESDF_YY |
  zyk_valid_reg_overlap(ys2, yd, y_get_lmul_pow()))

function clause execute XYK_YAESDF(funct6, ys2, yd) = {
  let SEW      = y_get_sew();
  let LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(LMUL_pow, SEW);

  if not(y_valid_reg_group(ys2, LMUL_pow)) |
     not(y_valid_reg_group(yd, LMUL_pow))
  then return Illegal_Instruction();

  assert(SEW == 32);

  let ys2_val = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let yd_val  = read_yreg(num_elem, SEW, LMUL_pow, yd);

  let group_count = (unsigned(yl) / 4);
  let first_group = (unsigned(ystart) / 4);

  foreach (group_index from first_group to (group_count - 1)) {
    assert(group_index * 4 + 3 < num_elem);

    let state = get_yelem_quad(yd_val, group_index);
    let rkey : bits(128) = match funct6 {
      XYK_ZYK_YAESDF_YY => get_yelem_quad(ys2_val, group_index),
      XYK_ZYK_YAESDF_YS => get_yelem_quad(ys2_val, 0),
    };
    let sr  = aes_shift_rows_inv(state);
    let sb  = aes_subbytes_inv(sr);
    let ark = sb ^ rkey;

    write_yelem_quad(yd, SEW, ark, group_index);
  };

  set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping yk_aesdf_mnemonic : zyk_yaesdf_funct6 <-> string = {
  XYK_ZYK_YAESDF_YY <-> "yaesdf.yy",
  XYK_ZYK_YAESDF_YS <-> "yaesdf.ys",
}

mapping clause assembly = XYK_YAESDF(funct6, ys2, yd)
  <-> yk_aesdf_mnemonic(funct6) ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2)

union clause instruction = XYK_YAESDM : (zyk_yaesdm_funct6, yregidx, yregidx)

mapping yk_encdec_vaesdm : zyk_yaesdm_funct6 <-> bits(6) = {
  XYK_ZYK_YAESDM_YY <-> 0b101000,
  XYK_ZYK_YAESDM_YS <-> 0b101001,
}

$[wavedrom "YAESDM.OP _ _ _ OPMYY _ CUSTOM-3"]
mapping clause encdec = XYK_YAESDM(funct6, ys2, yd)
  <-> yk_encdec_vaesdm(funct6) @ 0b1 @ encdec_yreg(ys2) @ 0b00000 @ 0b010 @ encdec_yreg(yd) @ 0b1111011
  when valid_ytype() & xy_crypto_kned_enabled() & y_get_sew() == 32 & zyk_check_encdec(128, 4) & (funct6 == XYK_ZYK_YAESDM_YY |
  zyk_valid_reg_overlap(ys2, yd, y_get_lmul_pow()))

function clause execute XYK_YAESDM(funct6, ys2, yd) = {
  let SEW      = y_get_sew();
  let LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(LMUL_pow, SEW);

  if not(y_valid_reg_group(ys2, LMUL_pow)) |
     not(y_valid_reg_group(yd, LMUL_pow))
  then return Illegal_Instruction();

  assert(SEW == 32);

  let ys2_val = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let yd_val  = read_yreg(num_elem, SEW, LMUL_pow, yd);

  let group_count = (unsigned(yl) / 4);
  let first_group = (unsigned(ystart) / 4);

  foreach (group_index from first_group to (group_count - 1)) {
    assert(group_index * 4 + 3 < num_elem);

    let state = get_yelem_quad(yd_val, group_index);
    let rkey : bits(128) = match funct6 {
      XYK_ZYK_YAESDM_YY => get_yelem_quad(ys2_val, group_index),
      XYK_ZYK_YAESDM_YS => get_yelem_quad(ys2_val, 0),
    };
    let sr    = aes_shift_rows_inv(state);
    let sb    = aes_subbytes_inv(sr);
    let ark   = sb ^ rkey;
    let mix   = aes_mixcolumns_inv(ark);

    write_yelem_quad(yd, SEW, mix, group_index);
  };

  set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping yk_aesdm_mnemonic : zyk_yaesdm_funct6 <-> string = {
  XYK_ZYK_YAESDM_YY <-> "yaesdm.yy",
  XYK_ZYK_YAESDM_YS <-> "yaesdm.ys",
}

mapping clause assembly = XYK_YAESDM(funct6, ys2, yd)
  <-> yk_aesdm_mnemonic(funct6) ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2)

union clause instruction = XYK_YAESEF : (zyk_yaesef_funct6, yregidx, yregidx)

mapping yk_encdec_vaesef : zyk_yaesef_funct6 <-> bits(6) = {
  XYK_ZYK_YAESEF_YY <-> 0b101000,
  XYK_ZYK_YAESEF_YS <-> 0b101001,
}

$[wavedrom "YAESEF.OP _ _ _ OPMYY _ CUSTOM-3"]
mapping clause encdec = XYK_YAESEF(funct6, ys2, yd)
  <-> yk_encdec_vaesef(funct6) @ 0b1 @ encdec_yreg(ys2) @ 0b00011 @ 0b010 @ encdec_yreg(yd) @ 0b1111011
  when valid_ytype() & xy_crypto_kned_enabled() & y_get_sew() == 32 & zyk_check_encdec(128, 4) & (funct6 == XYK_ZYK_YAESEF_YY |
  zyk_valid_reg_overlap(ys2, yd, y_get_lmul_pow()))

function clause execute XYK_YAESEF(funct6, ys2, yd) = {
  let SEW = y_get_sew();
  let LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(LMUL_pow, SEW);

  if not(y_valid_reg_group(ys2, LMUL_pow)) |
     not(y_valid_reg_group(yd, LMUL_pow))
  then return Illegal_Instruction();

  assert(SEW == 32);

  let ys2_val = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let yd_val  = read_yreg(num_elem, SEW, LMUL_pow, yd);

  let group_count = (unsigned(yl) / 4);
  let first_group = (unsigned(ystart) / 4);

  foreach (group_index from first_group to (group_count - 1)) {
    assert(group_index * 4 + 3 < num_elem);

    let state = get_yelem_quad(yd_val, group_index);
    let rkey : bits(128) = match funct6 {
      XYK_ZYK_YAESEF_YY => get_yelem_quad(ys2_val, group_index),
      XYK_ZYK_YAESEF_YS => get_yelem_quad(ys2_val, 0),
    };
    let sb    = aes_subbytes_fwd(state);
    let sr    = aes_shift_rows_fwd(sb);
    let ark   = sr ^ rkey;

    write_yelem_quad(yd, SEW, ark, group_index);
  };

  set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping yk_aesef_mnemonic : zyk_yaesef_funct6 <-> string = {
  XYK_ZYK_YAESEF_YY <-> "yaesef.yy",
  XYK_ZYK_YAESEF_YS <-> "yaesef.ys",
}

mapping clause assembly = XYK_YAESEF(funct6, ys2, yd)
  <-> yk_aesef_mnemonic(funct6) ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2)

union clause instruction = XYK_YAESEM : (zyk_yaesem_funct6, yregidx, yregidx)

mapping yk_encdec_vaesem : zyk_yaesem_funct6 <-> bits(6) = {
  XYK_ZYK_YAESEM_YY <-> 0b101000,
  XYK_ZYK_YAESEM_YS <-> 0b101001,
}

$[wavedrom "YAESEM.OP _ _ _ OPMYY _ CUSTOM-3"]
mapping clause encdec = XYK_YAESEM(funct6, ys2, yd)
  <-> yk_encdec_vaesem(funct6) @ 0b1 @ encdec_yreg(ys2) @ 0b00010 @ 0b010 @ encdec_yreg(yd) @ 0b1111011
  when valid_ytype() & xy_crypto_kned_enabled() & y_get_sew() == 32 & zyk_check_encdec(128, 4) & (funct6 == XYK_ZYK_YAESEM_YY |
  zyk_valid_reg_overlap(ys2, yd, y_get_lmul_pow()))

function clause execute XYK_YAESEM(funct6, ys2, yd) = {
  let SEW = y_get_sew();
  let LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(LMUL_pow, SEW);

  if not(y_valid_reg_group(ys2, LMUL_pow)) |
     not(y_valid_reg_group(yd, LMUL_pow))
  then return Illegal_Instruction();

  assert(SEW == 32);

  let ys2_val = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let yd_val  = read_yreg(num_elem, SEW, LMUL_pow, yd);

  let group_count = (unsigned(yl) / 4);
  let first_group = (unsigned(ystart) / 4);

  foreach (group_index from first_group to (group_count - 1)) {
    assert(group_index * 4 + 3 < num_elem);

    let state = get_yelem_quad(yd_val, group_index);
    let rkey : bits(128) = match funct6 {
      XYK_ZYK_YAESEM_YY => get_yelem_quad(ys2_val, group_index),
      XYK_ZYK_YAESEM_YS => get_yelem_quad(ys2_val, 0),
    };
    let sb    = aes_subbytes_fwd(state);
    let sr    = aes_shift_rows_fwd(sb);
    let mix   = aes_mixcolumns_fwd(sr);
    let ark   = mix ^ rkey;

    write_yelem_quad(yd, SEW, ark, group_index);
  };

  set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping yk_aesem_mnemonic : zyk_yaesem_funct6 <-> string = {
  XYK_ZYK_YAESEM_YY <-> "yaesem.yy",
  XYK_ZYK_YAESEM_YS <-> "yaesem.ys",
}

mapping clause assembly = XYK_YAESEM(funct6, ys2, yd)
  <-> yk_aesem_mnemonic(funct6) ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2)

union clause instruction = XYK_YAESKF1_YI : (yregidx, bits(5), yregidx)

$[wavedrom "_ _ _ OPMYY _ CUSTOM-3"]
mapping clause encdec = XYK_YAESKF1_YI(ys2, rnd, yd)
  <-> 0b1000101 @ encdec_yreg(ys2) @ rnd @ 0b010 @ encdec_yreg(yd) @ 0b1111011
  when valid_ytype() & xy_crypto_kned_enabled() & y_get_sew() == 32 & zyk_check_encdec(128, 4)

function clause execute XYK_YAESKF1_YI(ys2, rnd, yd) = {
  let SEW = y_get_sew();
  let LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(LMUL_pow, SEW);

  if not(y_valid_reg_group(ys2, LMUL_pow)) |
     not(y_valid_reg_group(yd, LMUL_pow))
  then return Illegal_Instruction();

  assert(SEW == 32);

  let ys2_val = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let yd_val  = read_yreg(num_elem, SEW, LMUL_pow, yd);

  var rnd_val : bits(5) = rnd;

  if (unsigned(rnd_val[3..0]) > 10) | (unsigned(rnd_val[3..0]) == 0)
  then rnd_val[3] = not_bit(rnd_val[3]);

  let r : bits(4) = rnd_val[3..0] - 1;

  var w : vector(4, bits(32)) = vector_init(zeros());

  let group_count = (unsigned(yl) / 4);
  let first_group = (unsigned(ystart) / 4);

  foreach (group_index from first_group to (group_count - 1)) {
    assert(group_index * 4 + 3 < num_elem);

    let current_round_key = get_yelem_quad_vec(ys2_val, group_index);

    w[0] = aes_subword_fwd(current_round_key[3] >>> 8) ^
           aes_decode_rcon(r) ^ current_round_key[0];
    w[1] = w[0] ^ current_round_key[1];
    w[2] = w[1] ^ current_round_key[2];
    w[3] = w[2] ^ current_round_key[3];

    write_yelem_quad_vec(yd, SEW, w, group_index);
  };

  set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = XYK_YAESKF1_YI(ys2, rnd, yd)
  <-> "yaeskf1.yi" ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2) ^ sep() ^ hex_bits_5(rnd)

union clause instruction = XYK_YAESKF2_YI : (yregidx, bits(5), yregidx)

$[wavedrom "_ _ _ _ OPMYY _ CUSTOM-3"]
mapping clause encdec = XYK_YAESKF2_YI(ys2, rnd, yd)
  <-> 0b101010 @ 0b1 @ encdec_yreg(ys2) @ rnd @ 0b010 @ encdec_yreg(yd) @ 0b1111011
  when valid_ytype() & xy_crypto_kned_enabled() & y_get_sew() == 32 & zyk_check_encdec(128, 4)

function clause execute XYK_YAESKF2_YI(ys2, rnd, yd) = {
  let SEW      = y_get_sew();
  let LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(LMUL_pow, SEW);

  if not(y_valid_reg_group(ys2, LMUL_pow)) |
     not(y_valid_reg_group(yd, LMUL_pow))
  then return Illegal_Instruction();

  assert(SEW == 32);

  let ys2_val = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let yd_val  = read_yreg(num_elem, SEW, LMUL_pow, yd);

  var rnd_val : bits(4) = rnd[3..0];

  if (unsigned(rnd_val) < 2) | (unsigned(rnd_val) > 14)
  then rnd_val[3] = not_bit(rnd_val[3]);

  var w : vector(4, bits(32)) = vector_init(zeros());

  let group_count = (unsigned(yl) / 4);
  let first_group = (unsigned(ystart) / 4);

  foreach (group_index from first_group to (group_count - 1)) {
    assert(group_index * 4 + 3 < num_elem);

    let current_round_key = get_yelem_quad_vec(ys2_val, group_index);
    let round_key_b       = get_yelem_quad_vec(yd_val, group_index);

    w[0] = if (rnd_val[0] == 0b1)
           then aes_subword_fwd(current_round_key[3]) ^ round_key_b[0]
           else aes_subword_fwd(current_round_key[3] >>> 8) ^
                aes_decode_rcon((rnd_val >> 1) - 1) ^ round_key_b[0];
    w[1] = w[0] ^ round_key_b[1];
    w[2] = w[1] ^ round_key_b[2];
    w[3] = w[2] ^ round_key_b[3];

    write_yelem_quad_vec(yd, SEW, w, group_index)
  };

  set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = XYK_YAESKF2_YI(ys2, rnd, yd)
  <-> "yaeskf2.yi" ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2) ^ sep() ^ hex_bits_5(rnd)

union clause instruction = XYK_YAESZ_YS : (yregidx, yregidx)

$[wavedrom "_ _ _ _ OPMYY _ CUSTOM-3"]
mapping clause encdec = XYK_YAESZ_YS(ys2, yd)
  <-> 0b101001 @ 0b1 @ encdec_yreg(ys2) @ 0b00111 @ 0b010 @ encdec_yreg(yd) @ 0b1111011
  when valid_ytype() & xy_crypto_kned_enabled() & y_get_sew() == 32 & zyk_check_encdec(128, 4) & zyk_valid_reg_overlap(ys2, yd, y_get_lmul_pow())

function clause execute XYK_YAESZ_YS(ys2, yd) = {
  let SEW      = y_get_sew();
  let LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(LMUL_pow, SEW);

  if not(y_valid_reg_group(ys2, LMUL_pow)) |
     not(y_valid_reg_group(yd, LMUL_pow))
  then return Illegal_Instruction();

  assert(SEW == 32);

  let ys2_val = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let yd_val  = read_yreg(num_elem, SEW, LMUL_pow, yd);

  let group_count = (unsigned(yl) / 4);
  let first_group = (unsigned(ystart) / 4);

  foreach (group_index from first_group to (group_count - 1)) {
    assert(group_index * 4 + 3 < num_elem);

    let state = get_yelem_quad(yd_val, group_index);
    let rkey  = get_yelem_quad(ys2_val, 0);
    let ark   = state ^ rkey;

    write_yelem_quad(yd, SEW, ark, group_index)
  };

  set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = XYK_YAESZ_YS(ys2, yd)
  <-> "yaesz.ys" ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2)
