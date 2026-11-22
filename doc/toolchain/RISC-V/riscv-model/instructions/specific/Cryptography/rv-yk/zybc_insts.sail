// SPDX-License-Identifier: BSD-2-Clause
// Experimental Zybc: SEW=64; private bank state; shared pure polynomial product.

function clause currentlyEnabled(Ext_Zybc) = hartSupports(Ext_Zybc) & currentlyEnabled(Ext_Y)

union clause instruction = Y_CLMUL_YY : (bits(1), yregidx, yregidx, yregidx)
mapping clause encdec = Y_CLMUL_YY(mask_bit, src2, ys1, dst)
 <-> 0b001100 @ mask_bit @ y_encdec_yreg(src2) @ y_encdec_yreg(ys1) @ 0b010 @ y_encdec_yreg(dst) @ 0b0101011
 when currentlyEnabled(Ext_Zybc) & y_get_sew() == 64
mapping clause assembly = Y_CLMUL_YY(mask_bit, src2, ys1, dst)
 <-> "yclmul.yy" ^ spc() ^ y_yreg_name(dst) ^ sep() ^ y_yreg_name(src2) ^ sep() ^ y_yreg_name(ys1) ^ y_maybe_ymask(mask_bit)
function clause execute(Y_CLMUL_YY(mask_bit, src2, ys1, dst)) = {
  let sew = y_get_sew();
  let lmul = y_get_lmul_pow();
  let n = y_get_num_elem(lmul, sew);
  if y_illegal_ystart(Y_YSTART_ARITH, n, lmul) |
     y_illegal_normal(dst, mask_bit) |
     not(y_valid_reg_group(src2, lmul)) |
     not(y_valid_reg_group(dst, lmul)) |
     not(y_valid_ym_src_overlap(mask_bit, src2, sew))

     | not(y_valid_reg_group(ys1, lmul)) | not(y_valid_ym_src_overlap(mask_bit, ys1, sew))

  then return Illegal_Instruction();
  let rhs = y_read_yreg(n, sew, lmul, src2);

  let lhs = y_read_yreg(n, sew, lmul, ys1);

  let previous = y_read_yreg(n, sew, lmul, dst);
  let input_mask = y_read_ymask(n, mask_bit, y_zyreg);
  let (initial, active) = y_init_masked_result(n, sew, lmul, previous, input_mask);
  var result = initial;
  foreach (p from 0 to n - 1) {
    if active[p] == 0b1 then {
      let product = carryless_mul(lhs[p], rhs[p]);
      result[p] = product[sew - 1 .. 0]
    }
  };
  y_write_yreg(n, sew, lmul, dst, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = Y_CLMUL_YX : (bits(1), yregidx, regidx, yregidx)
mapping clause encdec = Y_CLMUL_YX(mask_bit, src2, rs1, dst)
 <-> 0b001100 @ mask_bit @ y_encdec_yreg(src2) @ encdec_reg(rs1) @ 0b110 @ y_encdec_yreg(dst) @ 0b0101011
 when currentlyEnabled(Ext_Zybc) & y_get_sew() == 64
mapping clause assembly = Y_CLMUL_YX(mask_bit, src2, rs1, dst)
 <-> "yclmul.yx" ^ spc() ^ y_yreg_name(dst) ^ sep() ^ y_yreg_name(src2) ^ sep() ^ reg_name(rs1) ^ y_maybe_ymask(mask_bit)
function clause execute(Y_CLMUL_YX(mask_bit, src2, rs1, dst)) = {
  let sew = y_get_sew();
  let lmul = y_get_lmul_pow();
  let n = y_get_num_elem(lmul, sew);
  if y_illegal_ystart(Y_YSTART_ARITH, n, lmul) |
     y_illegal_normal(dst, mask_bit) |
     not(y_valid_reg_group(src2, lmul)) |
     not(y_valid_reg_group(dst, lmul)) |
     not(y_valid_ym_src_overlap(mask_bit, src2, sew))

  then return Illegal_Instruction();
  let rhs = y_read_yreg(n, sew, lmul, src2);

  let lhs = y_get_scalar(rs1, sew);

  let previous = y_read_yreg(n, sew, lmul, dst);
  let input_mask = y_read_ymask(n, mask_bit, y_zyreg);
  let (initial, active) = y_init_masked_result(n, sew, lmul, previous, input_mask);
  var result = initial;
  foreach (p from 0 to n - 1) {
    if active[p] == 0b1 then {
      let product = carryless_mul(lhs, rhs[p]);
      result[p] = product[sew - 1 .. 0]
    }
  };
  y_write_yreg(n, sew, lmul, dst, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = Y_CLMULH_YY : (bits(1), yregidx, yregidx, yregidx)
mapping clause encdec = Y_CLMULH_YY(mask_bit, src2, ys1, dst)
 <-> 0b001101 @ mask_bit @ y_encdec_yreg(src2) @ y_encdec_yreg(ys1) @ 0b010 @ y_encdec_yreg(dst) @ 0b0101011
 when currentlyEnabled(Ext_Zybc) & y_get_sew() == 64
mapping clause assembly = Y_CLMULH_YY(mask_bit, src2, ys1, dst)
 <-> "yclmulh.yy" ^ spc() ^ y_yreg_name(dst) ^ sep() ^ y_yreg_name(src2) ^ sep() ^ y_yreg_name(ys1) ^ y_maybe_ymask(mask_bit)
function clause execute(Y_CLMULH_YY(mask_bit, src2, ys1, dst)) = {
  let sew = y_get_sew();
  let lmul = y_get_lmul_pow();
  let n = y_get_num_elem(lmul, sew);
  if y_illegal_ystart(Y_YSTART_ARITH, n, lmul) |
     y_illegal_normal(dst, mask_bit) |
     not(y_valid_reg_group(src2, lmul)) |
     not(y_valid_reg_group(dst, lmul)) |
     not(y_valid_ym_src_overlap(mask_bit, src2, sew))

     | not(y_valid_reg_group(ys1, lmul)) | not(y_valid_ym_src_overlap(mask_bit, ys1, sew))

  then return Illegal_Instruction();
  let rhs = y_read_yreg(n, sew, lmul, src2);

  let lhs = y_read_yreg(n, sew, lmul, ys1);

  let previous = y_read_yreg(n, sew, lmul, dst);
  let input_mask = y_read_ymask(n, mask_bit, y_zyreg);
  let (initial, active) = y_init_masked_result(n, sew, lmul, previous, input_mask);
  var result = initial;
  foreach (p from 0 to n - 1) {
    if active[p] == 0b1 then {
      let product = carryless_mul(lhs[p], rhs[p]);
      result[p] = product[2 * sew - 1 .. sew]
    }
  };
  y_write_yreg(n, sew, lmul, dst, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = Y_CLMULH_YX : (bits(1), yregidx, regidx, yregidx)
mapping clause encdec = Y_CLMULH_YX(mask_bit, src2, rs1, dst)
 <-> 0b001101 @ mask_bit @ y_encdec_yreg(src2) @ encdec_reg(rs1) @ 0b110 @ y_encdec_yreg(dst) @ 0b0101011
 when currentlyEnabled(Ext_Zybc) & y_get_sew() == 64
mapping clause assembly = Y_CLMULH_YX(mask_bit, src2, rs1, dst)
 <-> "yclmulh.yx" ^ spc() ^ y_yreg_name(dst) ^ sep() ^ y_yreg_name(src2) ^ sep() ^ reg_name(rs1) ^ y_maybe_ymask(mask_bit)
function clause execute(Y_CLMULH_YX(mask_bit, src2, rs1, dst)) = {
  let sew = y_get_sew();
  let lmul = y_get_lmul_pow();
  let n = y_get_num_elem(lmul, sew);
  if y_illegal_ystart(Y_YSTART_ARITH, n, lmul) |
     y_illegal_normal(dst, mask_bit) |
     not(y_valid_reg_group(src2, lmul)) |
     not(y_valid_reg_group(dst, lmul)) |
     not(y_valid_ym_src_overlap(mask_bit, src2, sew))

  then return Illegal_Instruction();
  let rhs = y_read_yreg(n, sew, lmul, src2);

  let lhs = y_get_scalar(rs1, sew);

  let previous = y_read_yreg(n, sew, lmul, dst);
  let input_mask = y_read_ymask(n, mask_bit, y_zyreg);
  let (initial, active) = y_init_masked_result(n, sew, lmul, previous, input_mask);
  var result = initial;
  foreach (p from 0 to n - 1) {
    if active[p] == 0b1 then {
      let product = carryless_mul(lhs, rhs[p]);
      result[p] = product[2 * sew - 1 .. sew]
    }
  };
  y_write_yreg(n, sew, lmul, dst, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}
