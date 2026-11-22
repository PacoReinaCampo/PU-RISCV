// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

function xy_crypto_ksh_enabled() -> bool = (config extensions.Xy.crypto.ksh : bool) & xy_enabled()

union clause instruction = XYK_YSM3ME_YY : (yregidx, yregidx, yregidx)

$[wavedrom "_ _ _ _ OPMYY _ CUSTOM-3"]
mapping clause encdec = XYK_YSM3ME_YY(ys2, ys1, yd)
  <-> 0b100000 @ 0b1 @ encdec_yreg(ys2) @ encdec_yreg(ys1) @ 0b010 @ encdec_yreg(yd) @ 0b1111011
   when valid_ytype() & xy_crypto_ksh_enabled() & y_get_sew() == 32 & zyk_check_encdec(256, 8) & zyk_valid_reg_overlap(ys2, yd, y_get_lmul_pow())

function clause execute XYK_YSM3ME_YY(ys2, ys1, yd) = {
  let 'SEW     = y_get_sew();
  let LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(LMUL_pow, SEW);

  if not(y_valid_reg_group(ys1, LMUL_pow)) |
     not(y_valid_reg_group(ys2, LMUL_pow)) |
     not(y_valid_reg_group(yd, LMUL_pow))
  then return Illegal_Instruction();

  assert(SEW == 32);

  let ys2_val = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let ys1_val = read_yreg(num_elem, SEW, LMUL_pow, ys1);

  var w : vector(24, bits(32)) = vector_init(zeros());

  let group_count = (unsigned(yl) / 8);
  let first_group = (unsigned(ystart) / 8);

  foreach (group_index from first_group to (group_count - 1)) {
    let position = group_index * 8;
    assert(position + 7 < num_elem);

    foreach (j from 0 to 7) {
      w[j]     = rev8(ys1_val[position + j]);
      w[j + 8] = rev8(ys2_val[position + j]);
    };

    foreach (j from 16 to 23)
      w[j] = zyk_sh_w(w[j - 16], w[j - 9], w[j - 3], w[j - 13], w[j - 6]);

    write_yelem_oct_vec(yd, SEW,
      yrev8([w[23], w[22], w[21], w[20], w[19], w[18], w[17], w[16]]), group_index);
  };

  set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = XYK_YSM3ME_YY(ys2, ys1, yd)
  <-> "ysm3me.yy" ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2) ^ sep() ^ yreg_name(ys1)

union clause instruction = XYK_YSM3C_YI : (yregidx, bits(5), yregidx)

$[wavedrom "_ _ _ OPMYY _ CUSTOM-3"]
mapping clause encdec = XYK_YSM3C_YI(ys2, uimm, yd)
  <-> 0b1010111 @ encdec_yreg(ys2) @ uimm @ 0b010 @ encdec_yreg(yd) @ 0b1111011
  when valid_ytype() & xy_crypto_ksh_enabled() & y_get_sew() == 32 & zyk_check_encdec(256, 8) & zyk_valid_reg_overlap(ys2, yd, y_get_lmul_pow())

function clause execute XYK_YSM3C_YI(ys2, uimm, yd) = {
  let SEW      = y_get_sew();
  let LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(LMUL_pow, SEW);

  if not(y_valid_reg_group(ys2, LMUL_pow)) |
     not(y_valid_reg_group(yd, LMUL_pow))
  then return Illegal_Instruction();

  assert(SEW == 32);

  let ys2_val = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let yd_val  = read_yreg(num_elem, SEW, LMUL_pow, yd);

  let rnds = unsigned(uimm);

  let group_count = (unsigned(yl) / 8);
  let first_group = (unsigned(ystart) / 8);

  foreach (group_index from first_group to (group_count - 1)) {
    assert(group_index * 8 + 7 < num_elem);

    let A_H : vector(8, bits(32)) = yrev8(get_yelem_oct_vec(yd_val,  group_index));
    let w   : vector(8, bits(32)) = yrev8(get_yelem_oct_vec(ys2_val, group_index));

    let x_0 = w[0] ^ w[4];
    let x_1 = w[1] ^ w[5];

    let A1_H1 = zyk_sm3_round(  A_H, w[0], x_0, 2 * rnds);
    let A2_H2 = zyk_sm3_round(A1_H1, w[1], x_1, 2 * rnds + 1);

    write_yelem_oct_vec(yd, SEW,
      yrev8([A1_H1[6], A2_H2[6], A1_H1[4], A2_H2[4], A1_H1[2], A2_H2[2], A1_H1[0], A2_H2[0]]), group_index);
  };

  set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = XYK_YSM3C_YI(ys2, uimm, yd)
  <-> "ysm3c.yi" ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2) ^ sep() ^ hex_bits_5(uimm)
