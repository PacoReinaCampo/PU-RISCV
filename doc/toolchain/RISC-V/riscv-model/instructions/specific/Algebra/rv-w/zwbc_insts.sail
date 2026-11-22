// SPDX-License-Identifier: BSD-2-Clause
// Experimental Zwbc: SEW=64; private bank state; shared pure polynomial product.

function clause currentlyEnabled(Ext_Zwbc) = hartSupports(Ext_Zwbc) & currentlyEnabled(Ext_W)

union clause instruction = W_CLMUL_WW : (bits(1), wregidx, wregidx, wregidx)
mapping clause encdec = W_CLMUL_WW(mask_bit, src2, ws1, dst)
 <-> 0b001100 @ mask_bit @ w_encdec_wreg(src2) @ w_encdec_wreg(ws1) @ 0b010 @ w_encdec_wreg(dst) @ 0b0001011
 when currentlyEnabled(Ext_Zwbc) & w_get_sew() == 64
mapping clause assembly = W_CLMUL_WW(mask_bit, src2, ws1, dst)
 <-> "wclmul.ww" ^ spc() ^ w_wreg_name(dst) ^ sep() ^ w_wreg_name(src2) ^ sep() ^ w_wreg_name(ws1) ^ w_maybe_wmask(mask_bit)
function clause execute(W_CLMUL_WW(mask_bit, src2, ws1, dst)) = {
  let sew = w_get_sew();
  let lmul = w_get_lmul_pow();
  let n = w_get_num_elem(lmul, sew);
  if w_illegal_wstart(W_WSTART_ARITH, n, lmul) |
     w_illegal_normal(dst, mask_bit) |
     not(w_valid_reg_group(src2, lmul)) |
     not(w_valid_reg_group(dst, lmul)) |
     not(w_valid_wm_src_overlap(mask_bit, src2, sew))

     | not(w_valid_reg_group(ws1, lmul)) | not(w_valid_wm_src_overlap(mask_bit, ws1, sew))

  then return Illegal_Instruction();
  let rhs = w_read_wreg(n, sew, lmul, src2);

  let lhs = w_read_wreg(n, sew, lmul, ws1);

  let previous = w_read_wreg(n, sew, lmul, dst);
  let input_mask = w_read_wmask(n, mask_bit, w_zwreg);
  let (initial, active) = w_init_masked_result(n, sew, lmul, previous, input_mask);
  var result = initial;
  foreach (p from 0 to n - 1) {
    if active[p] == 0b1 then {
      let product = carryless_mul(lhs[p], rhs[p]);
      result[p] = product[sew - 1 .. 0]
    }
  };
  w_write_wreg(n, sew, lmul, dst, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = W_CLMUL_WX : (bits(1), wregidx, regidx, wregidx)
mapping clause encdec = W_CLMUL_WX(mask_bit, src2, rs1, dst)
 <-> 0b001100 @ mask_bit @ w_encdec_wreg(src2) @ encdec_reg(rs1) @ 0b110 @ w_encdec_wreg(dst) @ 0b0001011
 when currentlyEnabled(Ext_Zwbc) & w_get_sew() == 64
mapping clause assembly = W_CLMUL_WX(mask_bit, src2, rs1, dst)
 <-> "wclmul.wx" ^ spc() ^ w_wreg_name(dst) ^ sep() ^ w_wreg_name(src2) ^ sep() ^ reg_name(rs1) ^ w_maybe_wmask(mask_bit)
function clause execute(W_CLMUL_WX(mask_bit, src2, rs1, dst)) = {
  let sew = w_get_sew();
  let lmul = w_get_lmul_pow();
  let n = w_get_num_elem(lmul, sew);
  if w_illegal_wstart(W_WSTART_ARITH, n, lmul) |
     w_illegal_normal(dst, mask_bit) |
     not(w_valid_reg_group(src2, lmul)) |
     not(w_valid_reg_group(dst, lmul)) |
     not(w_valid_wm_src_overlap(mask_bit, src2, sew))

  then return Illegal_Instruction();
  let rhs = w_read_wreg(n, sew, lmul, src2);

  let lhs = w_get_scalar(rs1, sew);

  let previous = w_read_wreg(n, sew, lmul, dst);
  let input_mask = w_read_wmask(n, mask_bit, w_zwreg);
  let (initial, active) = w_init_masked_result(n, sew, lmul, previous, input_mask);
  var result = initial;
  foreach (p from 0 to n - 1) {
    if active[p] == 0b1 then {
      let product = carryless_mul(lhs, rhs[p]);
      result[p] = product[sew - 1 .. 0]
    }
  };
  w_write_wreg(n, sew, lmul, dst, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = W_CLMULH_WW : (bits(1), wregidx, wregidx, wregidx)
mapping clause encdec = W_CLMULH_WW(mask_bit, src2, ws1, dst)
 <-> 0b001101 @ mask_bit @ w_encdec_wreg(src2) @ w_encdec_wreg(ws1) @ 0b010 @ w_encdec_wreg(dst) @ 0b0001011
 when currentlyEnabled(Ext_Zwbc) & w_get_sew() == 64
mapping clause assembly = W_CLMULH_WW(mask_bit, src2, ws1, dst)
 <-> "wclmulh.ww" ^ spc() ^ w_wreg_name(dst) ^ sep() ^ w_wreg_name(src2) ^ sep() ^ w_wreg_name(ws1) ^ w_maybe_wmask(mask_bit)
function clause execute(W_CLMULH_WW(mask_bit, src2, ws1, dst)) = {
  let sew = w_get_sew();
  let lmul = w_get_lmul_pow();
  let n = w_get_num_elem(lmul, sew);
  if w_illegal_wstart(W_WSTART_ARITH, n, lmul) |
     w_illegal_normal(dst, mask_bit) |
     not(w_valid_reg_group(src2, lmul)) |
     not(w_valid_reg_group(dst, lmul)) |
     not(w_valid_wm_src_overlap(mask_bit, src2, sew))

     | not(w_valid_reg_group(ws1, lmul)) | not(w_valid_wm_src_overlap(mask_bit, ws1, sew))

  then return Illegal_Instruction();
  let rhs = w_read_wreg(n, sew, lmul, src2);

  let lhs = w_read_wreg(n, sew, lmul, ws1);

  let previous = w_read_wreg(n, sew, lmul, dst);
  let input_mask = w_read_wmask(n, mask_bit, w_zwreg);
  let (initial, active) = w_init_masked_result(n, sew, lmul, previous, input_mask);
  var result = initial;
  foreach (p from 0 to n - 1) {
    if active[p] == 0b1 then {
      let product = carryless_mul(lhs[p], rhs[p]);
      result[p] = product[2 * sew - 1 .. sew]
    }
  };
  w_write_wreg(n, sew, lmul, dst, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = W_CLMULH_WX : (bits(1), wregidx, regidx, wregidx)
mapping clause encdec = W_CLMULH_WX(mask_bit, src2, rs1, dst)
 <-> 0b001101 @ mask_bit @ w_encdec_wreg(src2) @ encdec_reg(rs1) @ 0b110 @ w_encdec_wreg(dst) @ 0b0001011
 when currentlyEnabled(Ext_Zwbc) & w_get_sew() == 64
mapping clause assembly = W_CLMULH_WX(mask_bit, src2, rs1, dst)
 <-> "wclmulh.wx" ^ spc() ^ w_wreg_name(dst) ^ sep() ^ w_wreg_name(src2) ^ sep() ^ reg_name(rs1) ^ w_maybe_wmask(mask_bit)
function clause execute(W_CLMULH_WX(mask_bit, src2, rs1, dst)) = {
  let sew = w_get_sew();
  let lmul = w_get_lmul_pow();
  let n = w_get_num_elem(lmul, sew);
  if w_illegal_wstart(W_WSTART_ARITH, n, lmul) |
     w_illegal_normal(dst, mask_bit) |
     not(w_valid_reg_group(src2, lmul)) |
     not(w_valid_reg_group(dst, lmul)) |
     not(w_valid_wm_src_overlap(mask_bit, src2, sew))

  then return Illegal_Instruction();
  let rhs = w_read_wreg(n, sew, lmul, src2);

  let lhs = w_get_scalar(rs1, sew);

  let previous = w_read_wreg(n, sew, lmul, dst);
  let input_mask = w_read_wmask(n, mask_bit, w_zwreg);
  let (initial, active) = w_init_masked_result(n, sew, lmul, previous, input_mask);
  var result = initial;
  foreach (p from 0 to n - 1) {
    if active[p] == 0b1 then {
      let product = carryless_mul(lhs, rhs[p]);
      result[p] = product[2 * sew - 1 .. sew]
    }
  };
  w_write_wreg(n, sew, lmul, dst, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}
