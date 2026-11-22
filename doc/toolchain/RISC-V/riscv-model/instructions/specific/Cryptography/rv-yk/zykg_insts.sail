// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

function xy_crypto_kg_enabled() -> bool = (config extensions.Xy.crypto.kg : bool) & xy_enabled()

union clause instruction = XYK_YGHSH_YY : (yregidx, yregidx, yregidx)

$[wavedrom "_ _ _ OPMYY _ CUSTOM-3"]
mapping clause encdec = XYK_YGHSH_YY(ys2, ys1, yd)
  <-> 0b1011001 @ encdec_yreg(ys2) @ encdec_yreg(ys1) @ 0b010 @ encdec_yreg(yd) @ 0b1111011
  when valid_ytype() & xy_crypto_kg_enabled() & y_get_sew() == 32 & zyk_check_encdec(128, 4)

function clause execute XYK_YGHSH_YY(ys2, ys1, yd) = {
  let SEW      = y_get_sew();
  let LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(LMUL_pow, SEW);

  if not(y_valid_reg_group(ys1, LMUL_pow)) |
     not(y_valid_reg_group(ys2, LMUL_pow)) |
     not(y_valid_reg_group(yd, LMUL_pow))
  then return Illegal_Instruction();

  assert(SEW == 32);

  let ys2_val = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let ys1_val = read_yreg(num_elem, SEW, LMUL_pow, ys1);
  let yd_val  = read_yreg(num_elem, SEW, LMUL_pow, yd);

  let group_count = (unsigned(yl) / 4);
  let first_group = (unsigned(ystart) / 4);

  foreach (group_index from first_group to (group_count - 1)) {
    assert(group_index * 4 + 3 < num_elem);

    let Y : bits(128) = get_yelem_quad(yd_val, group_index);
    let X : bits(128) = get_yelem_quad(ys1_val, group_index);
    var H : bits(128) = brev8(get_yelem_quad(ys2_val, group_index));

    var Z : bits(128) = zeros();
    let S : bits(128) = brev8(Y ^ X);

    foreach (b from 0 to 127) {
      if S[b] == 0b1 then Z = Z ^ H;

      let reduce = H[127] == 0b1;
      H = H << 1;
      if reduce then H = H[127..8] @ (H[7..0] ^ 0x87);
    };

    write_yelem_quad(yd, SEW, brev8(Z), group_index);
  };

  set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = XYK_YGHSH_YY(ys2, ys1, yd)
  <-> "yghsh.yy" ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2) ^ sep() ^ yreg_name(ys1)

union clause instruction = XYK_YGMUL_YY : (yregidx, yregidx)

$[wavedrom "_ _ _ OPMYY _ CUSTOM-3"]
mapping clause encdec = XYK_YGMUL_YY(ys2, yd)
  <-> 0b1010001 @ encdec_yreg(ys2) @ 0b10001 @ 0b010 @ encdec_yreg(yd) @ 0b1111011
  when valid_ytype() & xy_crypto_kg_enabled() & y_get_sew() == 32 & zyk_check_encdec(128, 4)

function clause execute XYK_YGMUL_YY(ys2, yd) = {
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

    let Y : bits(128) = brev8(get_yelem_quad(yd_val, group_index));
    var H : bits(128) = brev8(get_yelem_quad(ys2_val, group_index));
    var Z : bits(128) = zeros();

    foreach (b from 0 to 127) {
      if Y[b] == 0b1 then Z = Z ^ H;

      let reduce = H[127] == 0b1;
      H = H << 1;
      if reduce then H = H[127..8] @ (H[7..0] ^ 0x87);
    };

    write_yelem_quad(yd, SEW, brev8(Z), group_index);
  };

  set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = XYK_YGMUL_YY(ys2, yd)
  <-> "ygmul.yy" ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2)
