// =======================================================================================
// This Sail RISC-W architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

// ******************************************************************************
// This file implements part of the matrix extension.
// Chapter 13: Matrix Floating-Point Instructions
// Chapter 16: Matrix Permutation Instructions (floating-point part)
// ******************************************************************************

// ****************************** OPFVV (WWTYPE) ********************************
union clause instruction = W_FWWTYPE : (w_fwwfunct6, bits(1), wregidx, wregidx, wregidx)

mapping w_encdec_fwwfunct6 : w_fwwfunct6 <-> bits(6) = {
 W_FWW_WADD       <-> 0b000000,
 W_FWW_WSUB       <-> 0b000010,
 W_FWW_WMIN       <-> 0b000100,
 W_FWW_WMAX       <-> 0b000110,
 W_FWW_WSGNJ      <-> 0b001000,
 W_FWW_WSGNJN     <-> 0b001001,
 W_FWW_WSGNJX     <-> 0b001010,
 W_FWW_WDIV       <-> 0b100000,
 W_FWW_WMUL       <-> 0b100100
}

mapping clause encdec = W_FWWTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_encdec_fwwfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ w_encdec_wreg(ws1) @ 0b001 @ w_encdec_wreg(wd) @ 0b0001011
 when ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh))   & w_get_sew() == 16)
  | ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_F)) & w_get_sew() == 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 64)

function clause execute(W_FWWTYPE(funct6, wm, ws2, ws1, wd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_fp_normal(wd, wm, SEW, rm_3b)
   | not(w_valid_reg_group(ws1, W_LMUL_pow))
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_reg_group(wd, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws1, SEW))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW != 8);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let ws1_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws1);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW,
    W_LMUL_pow,
    wd_val,
    wm_val,
  );
  var result = initial_result;

  {
    let mask_view = w_shape(mask, w_columns);
    var result_view = w_shape(result, w_columns);
    let ws1_val_view = w_shape(ws1_val, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ws1_val_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_FWW_WADD   => w_fp_add(rm_3b, ws2_val_view[i][j], ws1_val_view[i][j]),
          W_FWW_WSUB   => w_fp_sub(rm_3b, ws2_val_view[i][j], ws1_val_view[i][j]),
          W_FWW_WMIN   => w_fp_min(ws2_val_view[i][j], ws1_val_view[i][j]),
          W_FWW_WMAX   => w_fp_max(ws2_val_view[i][j], ws1_val_view[i][j]),
          W_FWW_WMUL   => w_fp_mul(rm_3b, ws2_val_view[i][j], ws1_val_view[i][j]),
          W_FWW_WDIV   => w_fp_div(rm_3b, ws2_val_view[i][j], ws1_val_view[i][j]),
          W_FWW_WSGNJ  => [ws1_val_view[i][j][sizeof('m) - 1]] @ ws2_val_view[i][j][sizeof('m) - 2 .. 0],
          W_FWW_WSGNJN => (0b1 ^ [ws1_val_view[i][j][sizeof('m) - 1]]) @
            ws2_val_view[i][j][sizeof('m) - 2 .. 0],
          W_FWW_WSGNJX => ([ws2_val_view[i][j][sizeof('m) - 1]] ^ [ws1_val_view[i][j][sizeof('m) - 1]]) @
            ws2_val_view[i][j][sizeof('m) - 2 .. 0],
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_fwwtype_mnemonic : w_fwwfunct6 <-> string = {
 W_FWW_WADD       <-> "wfadd.ww",
 W_FWW_WSUB       <-> "wfsub.ww",
 W_FWW_WMIN       <-> "wfmin.ww",
 W_FWW_WMAX       <-> "wfmax.ww",
 W_FWW_WSGNJ      <-> "wfsgnj.ww",
 W_FWW_WSGNJN     <-> "wfsgnjn.ww",
 W_FWW_WSGNJX     <-> "wfsgnjx.ww",
 W_FWW_WDIV       <-> "wfdiv.ww",
 W_FWW_WMUL       <-> "wfmul.ww"
}

mapping clause assembly = W_FWWTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_fwwtype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ w_wreg_name(ws1) ^ w_maybe_wmask(wm)

// ************************ OPFVV (wwtype Multiply-Add) *************************
// Multiply-Add instructions switch the order of source operands in assembly (ws1/rs1 before ws2)
union clause instruction = W_FWWMATYPE : (w_fwwmafunct6, bits(1), wregidx, wregidx, wregidx)

mapping w_encdec_fwwmafunct6 : w_fwwmafunct6 <-> bits(6) = {
 W_FWW_WMADD      <-> 0b101000,
 W_FWW_WNMADD     <-> 0b101001,
 W_FWW_WMSUB      <-> 0b101010,
 W_FWW_WNMSUB     <-> 0b101011,
 W_FWW_WMACC      <-> 0b101100,
 W_FWW_WNMACC     <-> 0b101101,
 W_FWW_WMSAC      <-> 0b101110,
 W_FWW_WNMSAC     <-> 0b101111
}

mapping clause encdec = W_FWWMATYPE(funct6, wm, ws2, ws1, wd)
 <-> w_encdec_fwwmafunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ w_encdec_wreg(ws1) @ 0b001 @ w_encdec_wreg(wd) @ 0b0001011
 when ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh))   & w_get_sew() == 16)
  | ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_F)) & w_get_sew() == 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 64)

function clause execute(W_FWWMATYPE(funct6, wm, ws2, ws1, wd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_fp_normal(wd, wm, SEW, rm_3b)
   | not(w_valid_reg_group(ws1, W_LMUL_pow))
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_reg_group(wd, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws1, SEW))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW != 8);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let ws1_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws1);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW,
    W_LMUL_pow,
    wd_val,
    wm_val,
  );
  var result = initial_result;

  {
    let mask_view = w_shape(mask, w_columns);
    var result_view = w_shape(result, w_columns);
    let wd_val_view = w_shape(wd_val, w_columns);
    let ws1_val_view = w_shape(ws1_val, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(wd_val_view));
      assert(i < length(ws1_val_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_FWW_WMACC  => w_fp_muladd(rm_3b, ws1_val_view[i][j], ws2_val_view[i][j], wd_val_view[i][j]),
          W_FWW_WNMACC => w_fp_nmulsub(rm_3b, ws1_val_view[i][j], ws2_val_view[i][j], wd_val_view[i][j]),
          W_FWW_WMSAC  => w_fp_mulsub(rm_3b, ws1_val_view[i][j], ws2_val_view[i][j], wd_val_view[i][j]),
          W_FWW_WNMSAC => w_fp_nmuladd(rm_3b, ws1_val_view[i][j], ws2_val_view[i][j], wd_val_view[i][j]),
          W_FWW_WMADD  => w_fp_muladd(rm_3b, ws1_val_view[i][j], wd_val_view[i][j], ws2_val_view[i][j]),
          W_FWW_WNMADD => w_fp_nmulsub(rm_3b, ws1_val_view[i][j], wd_val_view[i][j], ws2_val_view[i][j]),
          W_FWW_WMSUB  => w_fp_mulsub(rm_3b, ws1_val_view[i][j], wd_val_view[i][j], ws2_val_view[i][j]),
          W_FWW_WNMSUB => w_fp_nmuladd(rm_3b, ws1_val_view[i][j], wd_val_view[i][j], ws2_val_view[i][j]),
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_fwwmatype_mnemonic : w_fwwmafunct6 <-> string = {
 W_FWW_WMADD      <-> "wfmadd.ww",
 W_FWW_WNMADD     <-> "wfnmadd.ww",
 W_FWW_WMSUB      <-> "wfmsub.ww",
 W_FWW_WNMSUB     <-> "wfnmsub.ww",
 W_FWW_WMACC      <-> "wfmacc.ww",
 W_FWW_WNMACC     <-> "wfnmacc.ww",
 W_FWW_WMSAC      <-> "wfmsac.ww",
 W_FWW_WNMSAC     <-> "wfnmsac.ww"
}

mapping clause assembly = W_FWWMATYPE(funct6, wm, ws2, ws1, wd)
 <-> w_fwwmatype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws1) ^ sep() ^ w_wreg_name(ws2) ^ w_maybe_wmask(wm)

// ************************** OPFVV (WWTYPE Widening) ***************************
union clause instruction = W_FWIDE_WWTYPE : (w_fwide_wwfunct6, bits(1), wregidx, wregidx, wregidx)

mapping w_encdec_fwide_wwfunct6 : w_fwide_wwfunct6 <-> bits(6) = {
 W_FWIDE_WW_WADD       <-> 0b110000,
 W_FWIDE_WW_WSUB       <-> 0b110010,
 W_FWIDE_WW_WMUL       <-> 0b111000
}

mapping clause encdec = W_FWIDE_WWTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_encdec_fwide_wwfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ w_encdec_wreg(ws1) @ 0b001 @ w_encdec_wreg(wd) @ 0b0001011
 when ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh))   & w_get_sew() == 16)
  | ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 32)

function clause execute(W_FWIDE_WWTYPE(funct6, wm, ws2, ws1, wd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = W_LMUL_pow + 1;

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_fp_variable_width(wd, wm, SEW, rm_3b, SEW_widen, LMUL_pow_widen)
   | not(w_valid_reg_overlap(ws1, wd, W_LMUL_pow, LMUL_pow_widen))
   | not(w_valid_reg_overlap(ws2, wd, W_LMUL_pow, LMUL_pow_widen))
   | not(w_valid_wm_src_overlap(wm, ws1, SEW))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW >= 16 & SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let wd_val : vector('n, bits('o)) = w_read_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd);
  let ws1_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws1);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);

  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW_widen,
    LMUL_pow_widen,
    wd_val,
    wm_val,
  );
  var result = initial_result;

  {
    let mask_view = w_shape(mask, w_columns);
    var result_view = w_shape(result, w_columns);
    let ws1_val_view = w_shape(ws1_val, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ws1_val_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_FWIDE_WW_WADD => w_fp_add(rm_3b, w_fp_widen(ws2_val_view[i][j]), w_fp_widen(ws1_val_view[i][j])),
          W_FWIDE_WW_WSUB => w_fp_sub(rm_3b, w_fp_widen(ws2_val_view[i][j]), w_fp_widen(ws1_val_view[i][j])),
          W_FWIDE_WW_WMUL => w_fp_mul(rm_3b, w_fp_widen(ws2_val_view[i][j]), w_fp_widen(ws1_val_view[i][j])),
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_fwide_wwtype_mnemonic : w_fwide_wwfunct6 <-> string = {
 W_FWIDE_WW_WADD       <-> "wfwadd.ww",
 W_FWIDE_WW_WSUB       <-> "wfwsub.ww",
 W_FWIDE_WW_WMUL       <-> "wfwmul.ww"
}

mapping clause assembly = W_FWIDE_WWTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_fwide_wwtype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ w_wreg_name(ws1) ^ w_maybe_wmask(wm)

// ******************* OPFVV (wwtype Widening Multiply-Add) *********************
// Multiply-Add instructions switch the order of source operands in assembly (ws1/rs1 before ws2)
union clause instruction = W_FWIDE_WWMATYPE : (w_fwide_wwmafunct6, bits(1), wregidx, wregidx, wregidx)

mapping w_encdec_fwide_wwmafunct6 : w_fwide_wwmafunct6 <-> bits(6) = {
 W_FWIDE_WW_WMACC      <-> 0b111100,
 W_FWIDE_WW_WNMACC     <-> 0b111101,
 W_FWIDE_WW_WMSAC      <-> 0b111110,
 W_FWIDE_WW_WNMSAC     <-> 0b111111
}

mapping clause encdec = W_FWIDE_WWMATYPE(funct6, wm, ws1, ws2, wd)
 <-> w_encdec_fwide_wwmafunct6(funct6) @ wm @ w_encdec_wreg(ws1) @ w_encdec_wreg(ws2) @ 0b001 @ w_encdec_wreg(wd) @ 0b0001011
 when ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh))   & w_get_sew() == 16)
  | ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 32)

function clause execute(W_FWIDE_WWMATYPE(funct6, wm, ws1, ws2, wd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = W_LMUL_pow + 1;

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_fp_variable_width(wd, wm, SEW, rm_3b, SEW_widen, LMUL_pow_widen)
   | not(w_valid_reg_overlap(ws1, wd, W_LMUL_pow, LMUL_pow_widen))
   | not(w_valid_reg_overlap(ws2, wd, W_LMUL_pow, LMUL_pow_widen))
   | // wd is also a source register
    not(w_valid_src_overlap(ws1, SEW, W_LMUL_pow, wd, SEW_widen, LMUL_pow_widen))
   | not(w_valid_src_overlap(ws2, SEW, W_LMUL_pow, wd, SEW_widen, LMUL_pow_widen))
   | not(w_valid_wm_src_overlap(wm, ws1, SEW))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW >= 16 & SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let wd_val : vector('n, bits('o)) = w_read_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd);
  let ws1_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws1);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);

  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW_widen,
    LMUL_pow_widen,
    wd_val,
    wm_val,
  );
  var result = initial_result;

  {
    let mask_view = w_shape(mask, w_columns);
    var result_view = w_shape(result, w_columns);
    let wd_val_view = w_shape(wd_val, w_columns);
    let ws1_val_view = w_shape(ws1_val, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(wd_val_view));
      assert(i < length(ws1_val_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_FWIDE_WW_WMACC  => w_fp_muladd(
            rm_3b,
            w_fp_widen(ws1_val_view[i][j]),
            w_fp_widen(ws2_val_view[i][j]),
            wd_val_view[i][j],
          ),
          W_FWIDE_WW_WNMACC => w_fp_nmulsub(
            rm_3b,
            w_fp_widen(ws1_val_view[i][j]),
            w_fp_widen(ws2_val_view[i][j]),
            wd_val_view[i][j],
          ),
          W_FWIDE_WW_WMSAC  => w_fp_mulsub(
            rm_3b,
            w_fp_widen(ws1_val_view[i][j]),
            w_fp_widen(ws2_val_view[i][j]),
            wd_val_view[i][j],
          ),
          W_FWIDE_WW_WNMSAC => w_fp_nmuladd(
            rm_3b,
            w_fp_widen(ws1_val_view[i][j]),
            w_fp_widen(ws2_val_view[i][j]),
            wd_val_view[i][j],
          ),
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_fwide_wwmatype_mnemonic : w_fwide_wwmafunct6 <-> string = {
 W_FWIDE_WW_WMACC      <-> "wfwmacc.ww",
 W_FWIDE_WW_WNMACC     <-> "wfwnmacc.ww",
 W_FWIDE_WW_WMSAC      <-> "wfwmsac.ww",
 W_FWIDE_WW_WNMSAC     <-> "wfwnmsac.ww"
}

mapping clause assembly = W_FWIDE_WWMATYPE(funct6, wm, ws1, ws2, wd)
 <-> w_fwide_wwmatype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws1) ^ sep() ^ w_wreg_name(ws2) ^ w_maybe_wmask(wm)

// ************************** OPFVV (WIDE_WTYPE Widening) ***************************
union clause instruction = W_FWIDE_WTYPE : (w_fwide_wfunct6, bits(1), wregidx, wregidx, wregidx)

mapping w_encdec_fwide_wfunct6 : w_fwide_wfunct6 <-> bits(6) = {
 W_FWIDE_W_WADD       <-> 0b110100,
 W_FWIDE_W_WSUB       <-> 0b110110
}

mapping clause encdec = W_FWIDE_WTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_encdec_fwide_wfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ w_encdec_wreg(ws1) @ 0b001 @ w_encdec_wreg(wd) @ 0b0001011
 when ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh))   & w_get_sew() == 16)
  | ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 32)

function clause execute(W_FWIDE_WTYPE(funct6, wm, ws2, ws1, wd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = W_LMUL_pow + 1;

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_fp_variable_width(wd, wm, SEW, rm_3b, SEW_widen, LMUL_pow_widen)
   | not(w_valid_reg_overlap(ws1, wd, W_LMUL_pow, LMUL_pow_widen))
   | not(w_valid_src_overlap(ws2, SEW_widen, LMUL_pow_widen, ws1, SEW, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws1, SEW))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW_widen)) then {
    return Illegal_Instruction()
  };

  assert(SEW >= 16 & SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let wd_val : vector('n, bits('o)) = w_read_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd);
  let ws1_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws1);
  let ws2_val : vector('n, bits('o)) = w_read_wreg(num_elem, SEW_widen, LMUL_pow_widen, ws2);

  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW_widen,
    LMUL_pow_widen,
    wd_val,
    wm_val,
  );
  var result = initial_result;

  {
    let mask_view = w_shape(mask, w_columns);
    var result_view = w_shape(result, w_columns);
    let ws1_val_view = w_shape(ws1_val, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ws1_val_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_FWIDE_W_WADD => w_fp_add(rm_3b, ws2_val_view[i][j], w_fp_widen(ws1_val_view[i][j])),
          W_FWIDE_W_WSUB => w_fp_sub(rm_3b, ws2_val_view[i][j], w_fp_widen(ws1_val_view[i][j])),
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_fwide_wtype_mnemonic : w_fwide_wfunct6 <-> string = {
 W_FWIDE_W_WADD       <-> "wfwadd.wide.ww",
 W_FWIDE_W_WSUB       <-> "wfwsub.wide.ww"
}

mapping clause assembly = W_FWIDE_WTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_fwide_wtype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ w_wreg_name(ws1) ^ w_maybe_wmask(wm)

// ***************************** OPFVV (WFUNARY0) *******************************
union clause instruction = W_WFUNARY0 : (bits(1), wregidx, w_wfunary0, wregidx)

mapping w_encdec_wfunary0_ws1 : w_wfunary0 <-> bits(5) = {
 W_FW_CVT_XU_F       <-> 0b00000,
 W_FW_CVT_X_F        <-> 0b00001,
 W_FW_CVT_F_XU       <-> 0b00010,
 W_FW_CVT_F_X        <-> 0b00011,
 W_FW_CVT_RTZ_XU_F   <-> 0b00110,
 W_FW_CVT_RTZ_X_F    <-> 0b00111
}

mapping clause encdec = W_WFUNARY0(wm, ws2, w_wfunary0, wd)
 <-> 0b010010 @ wm @ w_encdec_wreg(ws2) @ w_encdec_wfunary0_ws1(w_wfunary0) @ 0b001 @ w_encdec_wreg(wd) @ 0b0001011
 when ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh))   & w_get_sew() == 16)
  | ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_F)) & w_get_sew() == 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 64)

function clause execute(W_WFUNARY0(wm, ws2, w_wfunary0, wd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_fp_normal(wd, wm, SEW, rm_3b)
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_reg_group(wd, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW != 8);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW,
    W_LMUL_pow,
    wd_val,
    wm_val,
  );
  var result = initial_result;

  {
    let mask_view = w_shape(mask, w_columns);
    var result_view = w_shape(result, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match w_wfunary0 {
          W_FW_CVT_XU_F     => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              16 => w_riscv_f16ToUi16(rm_3b, ws2_val_view[i][j]),
              32 => riscv_f32ToUi32(rm_3b, ws2_val_view[i][j]),
              64 => riscv_f64ToUi64(rm_3b, ws2_val_view[i][j]),
            };
            accrue_fflags(fflags);
            elem
          },
          W_FW_CVT_X_F      => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              16 => w_riscv_f16ToI16(rm_3b, ws2_val_view[i][j]),
              32 => riscv_f32ToI32(rm_3b, ws2_val_view[i][j]),
              64 => riscv_f64ToI64(rm_3b, ws2_val_view[i][j]),
            };
            accrue_fflags(fflags);
            elem
          },
          W_FW_CVT_F_XU     => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              16 => riscv_ui32ToF16(rm_3b, zero_extend(ws2_val_view[i][j])),
              32 => riscv_ui32ToF32(rm_3b, ws2_val_view[i][j]),
              64 => riscv_ui64ToF64(rm_3b, ws2_val_view[i][j]),
            };
            accrue_fflags(fflags);
            elem
          },
          W_FW_CVT_F_X      => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              16 => riscv_i32ToF16(rm_3b, sign_extend(ws2_val_view[i][j])),
              32 => riscv_i32ToF32(rm_3b, ws2_val_view[i][j]),
              64 => riscv_i64ToF64(rm_3b, ws2_val_view[i][j]),
            };
            accrue_fflags(fflags);
            elem
          },
          W_FW_CVT_RTZ_XU_F => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              16 => w_riscv_f16ToUi16(0b001, ws2_val_view[i][j]),
              32 => riscv_f32ToUi32(0b001, ws2_val_view[i][j]),
              64 => riscv_f64ToUi64(0b001, ws2_val_view[i][j]),
            };
            accrue_fflags(fflags);
            elem
          },
          W_FW_CVT_RTZ_X_F  => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              16 => w_riscv_f16ToI16(0b001, ws2_val_view[i][j]),
              32 => riscv_f32ToI32(0b001, ws2_val_view[i][j]),
              64 => riscv_f64ToI64(0b001, ws2_val_view[i][j]),
            };
            accrue_fflags(fflags);
            elem
          },
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_wfunary0_mnemonic : w_wfunary0 <-> string = {
 W_FW_CVT_XU_F       <-> "wfcvt.xu.f.w",
 W_FW_CVT_X_F        <-> "wfcvt.x.f.w",
 W_FW_CVT_F_XU       <-> "wfcvt.f.xu.w",
 W_FW_CVT_F_X        <-> "wfcvt.f.x.w",
 W_FW_CVT_RTZ_XU_F   <-> "wfcvt.rtz.xu.f.w",
 W_FW_CVT_RTZ_X_F    <-> "wfcvt.rtz.x.f.w"
}

mapping clause assembly = W_WFUNARY0(wm, ws2, w_wfunary0, wd)
 <-> w_wfunary0_mnemonic(w_wfunary0) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ w_maybe_wmask(wm)

// ************************* OPFVV (WFUNARY0 Widening) **************************
union clause instruction = W_WFWUNARY0 : (bits(1), wregidx, w_vfwunary0, wregidx)

mapping w_encdec_vfwunary0_ws1 : w_vfwunary0 <-> bits(5) = {
 W_FWIDE_W_CVT_XU_F      <-> 0b01000,
 W_FWIDE_W_CVT_X_F       <-> 0b01001,
 W_FWIDE_W_CVT_F_XU      <-> 0b01010,
 W_FWIDE_W_CVT_F_X       <-> 0b01011,
 W_FWIDE_W_CVT_F_F       <-> 0b01100,
 W_FWIDE_W_CVT_RTZ_XU_F  <-> 0b01110,
 W_FWIDE_W_CVT_RTZ_X_F   <-> 0b01111
}

mapping clause encdec = W_WFWUNARY0(wm, ws2, w_vfwunary0, wd)
 <-> 0b010010 @ wm @ w_encdec_wreg(ws2) @ w_encdec_vfwunary0_ws1(w_vfwunary0) @ 0b001 @ w_encdec_wreg(wd) @ 0b0001011
 when w_valid_widening_fp_conversion(w_vfwunary0)

function clause execute(W_WFWUNARY0(wm, ws2, w_vfwunary0, wd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = W_LMUL_pow + 1;

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_fp_variable_width(wd, wm, SEW, rm_3b, SEW_widen, LMUL_pow_widen)
   | not(w_valid_reg_overlap(ws2, wd, W_LMUL_pow, LMUL_pow_widen))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW >= 8 & SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
  let wd_val : vector('n, bits('o)) = w_read_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd);

  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW_widen,
    LMUL_pow_widen,
    wd_val,
    wm_val,
  );
  var result = initial_result;

  {
    let mask_view = w_shape(mask, w_columns);
    var result_view = w_shape(result, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match w_vfwunary0 {
          W_FWIDE_W_CVT_XU_F     => {
            let (fflags, elem) : (bits_fflags, bits('o)) = match sizeof('m) {
              8 => return Illegal_Instruction(),
              16 => riscv_f16ToUi32(rm_3b, ws2_val_view[i][j]),
              32 => riscv_f32ToUi64(rm_3b, ws2_val_view[i][j]),
            };
            accrue_fflags(fflags);
            elem
          },
          W_FWIDE_W_CVT_X_F      => {
            let (fflags, elem) : (bits_fflags, bits('o)) = match sizeof('m) {
              8 => return Illegal_Instruction(),
              16 => riscv_f16ToI32(rm_3b, ws2_val_view[i][j]),
              32 => riscv_f32ToI64(rm_3b, ws2_val_view[i][j]),
            };
            accrue_fflags(fflags);
            elem
          },
          W_FWIDE_W_CVT_F_XU     => {
            let (fflags, elem) : (bits_fflags, bits('o)) = match sizeof('m) {
              8 => riscv_ui32ToF16(rm_3b, zero_extend(ws2_val_view[i][j])),
              16 => riscv_ui32ToF32(rm_3b, zero_extend(ws2_val_view[i][j])),
              32 => riscv_ui32ToF64(rm_3b, ws2_val_view[i][j]),
            };
            accrue_fflags(fflags);
            elem
          },
          W_FWIDE_W_CVT_F_X      => {
            let (fflags, elem) : (bits_fflags, bits('o)) = match sizeof('m) {
              8 => riscv_i32ToF16(rm_3b, sign_extend(ws2_val_view[i][j])),
              16 => riscv_i32ToF32(rm_3b, sign_extend(ws2_val_view[i][j])),
              32 => riscv_i32ToF64(rm_3b, ws2_val_view[i][j]),
            };
            accrue_fflags(fflags);
            elem
          },
          W_FWIDE_W_CVT_F_F      => {
            let (fflags, elem) : (bits_fflags, bits('o)) = match sizeof('m) {
              8 => return Illegal_Instruction(),
              16 => riscv_f16ToF32(rm_3b, ws2_val_view[i][j]),
              32 => riscv_f32ToF64(rm_3b, ws2_val_view[i][j]),
            };
            accrue_fflags(fflags);
            elem
          },
          W_FWIDE_W_CVT_RTZ_XU_F => {
            let (fflags, elem) : (bits_fflags, bits('o)) = match sizeof('m) {
              8 => return Illegal_Instruction(),
              16 => riscv_f16ToUi32(0b001, ws2_val_view[i][j]),
              32 => riscv_f32ToUi64(0b001, ws2_val_view[i][j]),
            };
            accrue_fflags(fflags);
            elem
          },
          W_FWIDE_W_CVT_RTZ_X_F  => {
            let (fflags, elem) : (bits_fflags, bits('o)) = match sizeof('m) {
              8 => return Illegal_Instruction(),
              16 => riscv_f16ToI32(0b001, ws2_val_view[i][j]),
              32 => riscv_f32ToI64(0b001, ws2_val_view[i][j]),
            };
            accrue_fflags(fflags);
            elem
          },
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_vfwunary0_mnemonic : w_vfwunary0 <-> string = {
 W_FWIDE_W_CVT_XU_F      <-> "wfwcvt.xu.f.w",
 W_FWIDE_W_CVT_X_F       <-> "wfwcvt.x.f.w",
 W_FWIDE_W_CVT_F_XU      <-> "wfwcvt.f.xu.w",
 W_FWIDE_W_CVT_F_X       <-> "wfwcvt.f.x.w",
 W_FWIDE_W_CVT_F_F       <-> "wfwcvt.f.f.w",
 W_FWIDE_W_CVT_RTZ_XU_F  <-> "wfwcvt.rtz.xu.f.w",
 W_FWIDE_W_CVT_RTZ_X_F   <-> "wfwcvt.rtz.x.f.w"
}

mapping clause assembly = W_WFWUNARY0(wm, ws2, w_vfwunary0, wd)
 <-> w_vfwunary0_mnemonic(w_vfwunary0) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ w_maybe_wmask(wm)

// ************************ OPFVV (WFUNARY0 Narrowing) **************************
union clause instruction = W_WFNUNARY0 : (bits(1), wregidx, w_vfnunary0, wregidx)

mapping w_encdec_vfnunary0_ws1 : w_vfnunary0 <-> bits(5) = {
 W_FNV_CVT_XU_F      <-> 0b10000,
 W_FNV_CVT_X_F       <-> 0b10001,
 W_FNV_CVT_F_XU      <-> 0b10010,
 W_FNV_CVT_F_X       <-> 0b10011,
 W_FNV_CVT_F_F       <-> 0b10100,
 W_FNV_CVT_ROD_F_F   <-> 0b10101,
 W_FNV_CVT_RTZ_XU_F  <-> 0b10110,
 W_FNV_CVT_RTZ_X_F   <-> 0b10111
}

mapping clause encdec = W_WFNUNARY0(wm, ws2, w_vfnunary0, wd)
 <-> 0b010010 @ wm @ w_encdec_wreg(ws2) @ w_encdec_vfnunary0_ws1(w_vfnunary0) @ 0b001 @ w_encdec_wreg(wd) @ 0b0001011
 when w_valid_narrowing_fp_conversion(w_vfnunary0)

function clause execute(W_WFNUNARY0(wm, ws2, w_vfnunary0, wd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = W_LMUL_pow + 1;

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_fp_variable_width(wd, wm, SEW, rm_3b, SEW_widen, LMUL_pow_widen)
   | not(w_valid_reg_overlap(ws2, wd, LMUL_pow_widen, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW_widen)) then {
    return Illegal_Instruction()
  };

  assert(SEW != 64);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let ws2_val : vector('n, bits('o)) = w_read_wreg(num_elem, SEW_widen, LMUL_pow_widen, ws2);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW,
    W_LMUL_pow,
    wd_val,
    wm_val,
  );
  var result = initial_result;

  {
    let mask_view = w_shape(mask, w_columns);
    var result_view = w_shape(result, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match w_vfnunary0 {
          W_FNV_CVT_XU_F     => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              8 => w_riscv_f16ToUi8(rm_3b, ws2_val_view[i][j]),
              16 => w_riscv_f32ToUi16(rm_3b, ws2_val_view[i][j]),
              32 => riscv_f64ToUi32(rm_3b, ws2_val_view[i][j]),
            };
            accrue_fflags(fflags);
            elem
          },
          W_FNV_CVT_X_F      => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              8 => w_riscv_f16ToI8(rm_3b, ws2_val_view[i][j]),
              16 => w_riscv_f32ToI16(rm_3b, ws2_val_view[i][j]),
              32 => riscv_f64ToI32(rm_3b, ws2_val_view[i][j]),
            };
            accrue_fflags(fflags);
            elem
          },
          W_FNV_CVT_F_XU     => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              8 => return Illegal_Instruction(),
              16 => riscv_ui32ToF16(rm_3b, ws2_val_view[i][j]),
              32 => riscv_ui64ToF32(rm_3b, ws2_val_view[i][j]),
            };
            accrue_fflags(fflags);
            elem
          },
          W_FNV_CVT_F_X      => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              8 => return Illegal_Instruction(),
              16 => riscv_i32ToF16(rm_3b, ws2_val_view[i][j]),
              32 => riscv_i64ToF32(rm_3b, ws2_val_view[i][j]),
            };
            accrue_fflags(fflags);
            elem
          },
          W_FNV_CVT_F_F      => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              8 => return Illegal_Instruction(),
              16 => riscv_f32ToF16(rm_3b, ws2_val_view[i][j]),
              32 => riscv_f64ToF32(rm_3b, ws2_val_view[i][j]),
            };
            accrue_fflags(fflags);
            elem
          },
          W_FNV_CVT_ROD_F_F  => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              8 => return Illegal_Instruction(),
              16 => riscv_f32ToF16(0b110, ws2_val_view[i][j]),
              32 => riscv_f64ToF32(0b110, ws2_val_view[i][j]),
            };
            accrue_fflags(fflags);
            elem
          },
          W_FNV_CVT_RTZ_XU_F => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              8 => w_riscv_f16ToUi8(0b001, ws2_val_view[i][j]),
              16 => w_riscv_f32ToUi16(0b001, ws2_val_view[i][j]),
              32 => riscv_f64ToUi32(0b001, ws2_val_view[i][j]),
            };
            accrue_fflags(fflags);
            elem
          },
          W_FNV_CVT_RTZ_X_F  => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              8 => w_riscv_f16ToI8(0b001, ws2_val_view[i][j]),
              16 => w_riscv_f32ToI16(0b001, ws2_val_view[i][j]),
              32 => riscv_f64ToI32(0b001, ws2_val_view[i][j]),
            };
            accrue_fflags(fflags);
            elem
          },
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_vfnunary0_mnemonic : w_vfnunary0 <-> string = {
 W_FNV_CVT_XU_F      <-> "wfncvt.xu.f.wide",
 W_FNV_CVT_X_F       <-> "wfncvt.x.f.wide",
 W_FNV_CVT_F_XU      <-> "wfncvt.f.xu.wide",
 W_FNV_CVT_F_X       <-> "wfncvt.f.x.wide",
 W_FNV_CVT_F_F       <-> "wfncvt.f.f.wide",
 W_FNV_CVT_ROD_F_F   <-> "wfncvt.rod.f.f.wide",
 W_FNV_CVT_RTZ_XU_F  <-> "wfncvt.rtz.xu.f.wide",
 W_FNV_CVT_RTZ_X_F   <-> "wfncvt.rtz.x.f.wide"
}

mapping clause assembly = W_WFNUNARY0(wm, ws2, w_vfnunary0, wd)
 <-> w_vfnunary0_mnemonic(w_vfnunary0) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ w_maybe_wmask(wm)

// ***************************** OPFVV (WFUNARY1) *******************************
union clause instruction = W_WFUNARY1 : (bits(1), wregidx, w_wfunary1, wregidx)

mapping w_encdec_wfunary1_ws1 : w_wfunary1 <-> bits(5) = {
 W_FWW_WSQRT       <-> 0b00000,
 W_FWW_WRSQRT7     <-> 0b00100,
 W_FWW_WREC7       <-> 0b00101,
 W_FWW_WCLASS      <-> 0b10000
}

mapping clause encdec = W_WFUNARY1(wm, ws2, w_wfunary1, wd)
 <-> 0b010011 @ wm @ w_encdec_wreg(ws2) @ w_encdec_wfunary1_ws1(w_wfunary1) @ 0b001 @ w_encdec_wreg(wd) @ 0b0001011
 when ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh))   & w_get_sew() == 16)
  | ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_F)) & w_get_sew() == 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 64)

function clause execute(W_WFUNARY1(wm, ws2, w_wfunary1, wd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_fp_normal(wd, wm, SEW, rm_3b)
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_reg_group(wd, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW != 8);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW,
    W_LMUL_pow,
    wd_val,
    wm_val,
  );
  var result = initial_result;

  {
    let mask_view = w_shape(mask, w_columns);
    var result_view = w_shape(result, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match w_wfunary1 {
          W_FWW_WSQRT   => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              16 => riscv_f16Sqrt(rm_3b, ws2_val_view[i][j]),
              32 => riscv_f32Sqrt(rm_3b, ws2_val_view[i][j]),
              64 => riscv_f64Sqrt(rm_3b, ws2_val_view[i][j]),
            };
            accrue_fflags(fflags);
            elem
          },
          W_FWW_WRSQRT7 => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              16 => w_riscv_f16Rsqrte7(rm_3b, ws2_val_view[i][j]),
              32 => w_riscv_f32Rsqrte7(rm_3b, ws2_val_view[i][j]),
              64 => w_riscv_f64Rsqrte7(rm_3b, ws2_val_view[i][j]),
            };
            accrue_fflags(fflags);
            elem
          },
          W_FWW_WREC7   => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              16 => w_riscv_f16Recip7(rm_3b, ws2_val_view[i][j]),
              32 => w_riscv_f32Recip7(rm_3b, ws2_val_view[i][j]),
              64 => w_riscv_f64Recip7(rm_3b, ws2_val_view[i][j]),
            };
            accrue_fflags(fflags);
            elem
          },
          W_FWW_WCLASS  => zero_extend(float_class_onehot_bits(float_classify(ws2_val_view[i][j]))),
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_wfunary1_mnemonic : w_wfunary1 <-> string = {
 W_FWW_WSQRT       <-> "wfsqrt.w",
 W_FWW_WRSQRT7     <-> "wfrsqrt7.w",
 W_FWW_WREC7       <-> "wfrec7.w",
 W_FWW_WCLASS      <-> "wfclass.w"
}

mapping clause assembly = W_WFUNARY1(wm, ws2, w_wfunary1, wd)
 <-> w_wfunary1_mnemonic(w_wfunary1) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ w_maybe_wmask(wm)

// ***************************** OPFVV (WWFUNARY0) ******************************
union clause instruction = W_WFMVFS : (wregidx, fregidx)

mapping clause encdec = W_WFMVFS(ws2, rd)
 <-> 0b010000 @ 0b1 @ w_encdec_wreg(ws2) @ 0b00000 @ 0b001 @ encdec_freg(rd) @ 0b0001011
 when ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh))   & w_get_sew() == 16)
  | ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_F)) & w_get_sew() == 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 64)

function clause execute(W_WFMVFS(ws2, rd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = w_get_sew();
  let num_elem = w_get_num_elem(0, SEW);

  // See comment in WMVXS for the use of LMUL
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem_wstart = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_SCALAR_MOVE, num_elem_wstart, W_LMUL_pow)
   | w_illegal_fp_wd_unmasked(SEW, rm_3b)
   | SEW
   > flen then {
    return Illegal_Instruction()
  };

  assert(num_elem > 0 & SEW != 8);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, 0, ws2);
  match sizeof('m) {
    16 => F_H(rd) = w_shape(ws2_val, w_columns)[0][0],
    32 => F_S(rd) = w_shape(ws2_val, w_columns)[0][0],
    64 => F_D(rd) = w_shape(ws2_val, w_columns)[0][0],
  };
  w_set_wstart(zeros());

  RETIRE_SUCCESS
}

mapping clause assembly = W_WFMVFS(ws2, rd)
 <-> "wfmv.f.s" ^ spc() ^ freg_name(rd) ^ sep() ^ w_wreg_name(ws2)

// ****************************** OPFVF (wftype) ********************************
union clause instruction = W_FWFTYPE : (w_fwffunct6, bits(1), wregidx, fregidx, wregidx)

mapping w_encdec_fwffunct6 : w_fwffunct6 <-> bits(6) = {
 W_WF_WADD          <-> 0b000000,
 W_WF_WSUB          <-> 0b000010,
 W_WF_WMIN          <-> 0b000100,
 W_WF_WMAX          <-> 0b000110,
 W_WF_WSGNJ         <-> 0b001000,
 W_WF_WSGNJN        <-> 0b001001,
 W_WF_WSGNJX        <-> 0b001010,
 W_WF_WSLIDE1UP     <-> 0b001110,
 W_WF_WSLIDE1DOWN   <-> 0b001111,
 W_WF_WDIV          <-> 0b100000,
 W_WF_WRDIV         <-> 0b100001,
 W_WF_WMUL          <-> 0b100100,
 W_WF_WRSUB         <-> 0b100111
}

mapping clause encdec = W_FWFTYPE(funct6, wm, ws2, rs1, wd)
 <-> w_encdec_fwffunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ encdec_freg(rs1) @ 0b101 @ w_encdec_wreg(wd) @ 0b0001011
 when ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh))   & w_get_sew() == 16)
  | ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_F)) & w_get_sew() == 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 64)

function clause execute(W_FWFTYPE(funct6, wm, ws2, rs1, wd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  // "The vslide1up instruction requires that the destination vector
  // register group does not overlap the source vector register
  // group. Otherwise, the instruction encoding is reserved."
  let src_dst_overlap = funct6 == W_WF_WSLIDE1UP & ws2 == wd;

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_fp_normal(wd, wm, SEW, rm_3b)
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_reg_group(wd, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW))
   | src_dst_overlap then {
    return Illegal_Instruction()
  };

  assert(SEW != 8);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let rs1_val : bits('m) = w_get_scalar_fp(rs1, sizeof('m));
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW,
    W_LMUL_pow,
    wd_val,
    wm_val,
  );
  var result = initial_result;

  {
    let mask_view = w_shape(mask, w_columns);
    var result_view = w_shape(result, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_WF_WADD        => w_fp_add(rm_3b, ws2_val_view[i][j], rs1_val),
          W_WF_WSUB        => w_fp_sub(rm_3b, ws2_val_view[i][j], rs1_val),
          W_WF_WRSUB       => w_fp_sub(rm_3b, rs1_val, ws2_val_view[i][j]),
          W_WF_WMIN        => w_fp_min(ws2_val_view[i][j], rs1_val),
          W_WF_WMAX        => w_fp_max(ws2_val_view[i][j], rs1_val),
          W_WF_WMUL        => w_fp_mul(rm_3b, ws2_val_view[i][j], rs1_val),
          W_WF_WDIV        => w_fp_div(rm_3b, ws2_val_view[i][j], rs1_val),
          W_WF_WRDIV       => w_fp_div(rm_3b, rs1_val, ws2_val_view[i][j]),
          W_WF_WSGNJ       => [rs1_val[sizeof('m) - 1]] @ ws2_val_view[i][j][sizeof('m) - 2 .. 0],
          W_WF_WSGNJN      => (0b1 ^ [rs1_val[sizeof('m) - 1]]) @ ws2_val_view[i][j][sizeof('m) - 2 .. 0],
          W_WF_WSGNJX      => ([ws2_val_view[i][j][sizeof('m) - 1]] ^ [rs1_val[sizeof('m) - 1]]) @
            ws2_val_view[i][j][sizeof('m) - 2 .. 0],
          W_WF_WSLIDE1UP   => {
            if p == 0 then {
              rs1_val
            } else {
              ws2_val_view[(p - 1) / w_columns][(p - 1) % w_columns]
            }
          },
          W_WF_WSLIDE1DOWN => {
            let last_elem = w_get_end_element();
            assert(last_elem < num_elem);
            if p < last_elem then {
              ws2_val_view[(p + 1) / w_columns][(p + 1) % w_columns]
            } else {
              rs1_val
            }
          },
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_fwftype_mnemonic : w_fwffunct6 <-> string = {
 W_WF_WADD          <-> "wfadd.wf",
 W_WF_WSUB          <-> "wfsub.wf",
 W_WF_WMIN          <-> "wfmin.wf",
 W_WF_WMAX          <-> "wfmax.wf",
 W_WF_WSGNJ         <-> "wfsgnj.wf",
 W_WF_WSGNJN        <-> "wfsgnjn.wf",
 W_WF_WSGNJX        <-> "wfsgnjx.wf",
 W_WF_WSLIDE1UP     <-> "wfslide1up.wf",
 W_WF_WSLIDE1DOWN   <-> "wfslide1down.wf",
 W_WF_WDIV          <-> "wfdiv.wf",
 W_WF_WRDIV         <-> "wfrdiv.wf",
 W_WF_WMUL          <-> "wfmul.wf",
 W_WF_WRSUB         <-> "wfrsub.wf"
}

mapping clause assembly = W_FWFTYPE(funct6, wm, ws2, rs1, wd)
 <-> w_fwftype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ freg_name(rs1) ^ w_maybe_wmask(wm)

// ************************ OPFVF (wftype Multiply-Add) *************************
// Multiply-Add instructions switch the order of source operands in assembly (ws1/rs1 before ws2)
union clause instruction = W_FWFMATYPE : (w_fwfmafunct6, bits(1), wregidx, fregidx, wregidx)

mapping w_encdec_fwfmafunct6 : w_fwfmafunct6 <-> bits(6) = {
 W_WF_WMADD      <-> 0b101000,
 W_WF_WNMADD     <-> 0b101001,
 W_WF_WMSUB      <-> 0b101010,
 W_WF_WNMSUB     <-> 0b101011,
 W_WF_WMACC      <-> 0b101100,
 W_WF_WNMACC     <-> 0b101101,
 W_WF_WMSAC      <-> 0b101110,
 W_WF_WNMSAC     <-> 0b101111
}

mapping clause encdec = W_FWFMATYPE(funct6, wm, ws2, rs1, wd)
 <-> w_encdec_fwfmafunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ encdec_freg(rs1) @ 0b101 @ w_encdec_wreg(wd) @ 0b0001011
 when ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh))   & w_get_sew() == 16)
  | ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_F)) & w_get_sew() == 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 64)

function clause execute(W_FWFMATYPE(funct6, wm, ws2, rs1, wd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_fp_normal(wd, wm, SEW, rm_3b)
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_reg_group(wd, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW != 8);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let rs1_val : bits('m) = w_get_scalar_fp(rs1, sizeof('m));
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW,
    W_LMUL_pow,
    wd_val,
    wm_val,
  );
  var result = initial_result;

  {
    let mask_view = w_shape(mask, w_columns);
    var result_view = w_shape(result, w_columns);
    let wd_val_view = w_shape(wd_val, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(wd_val_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_WF_WMACC  => w_fp_muladd(rm_3b, rs1_val, ws2_val_view[i][j], wd_val_view[i][j]),
          W_WF_WNMACC => w_fp_nmulsub(rm_3b, rs1_val, ws2_val_view[i][j], wd_val_view[i][j]),
          W_WF_WMSAC  => w_fp_mulsub(rm_3b, rs1_val, ws2_val_view[i][j], wd_val_view[i][j]),
          W_WF_WNMSAC => w_fp_nmuladd(rm_3b, rs1_val, ws2_val_view[i][j], wd_val_view[i][j]),
          W_WF_WMADD  => w_fp_muladd(rm_3b, rs1_val, wd_val_view[i][j], ws2_val_view[i][j]),
          W_WF_WNMADD => w_fp_nmulsub(rm_3b, rs1_val, wd_val_view[i][j], ws2_val_view[i][j]),
          W_WF_WMSUB  => w_fp_mulsub(rm_3b, rs1_val, wd_val_view[i][j], ws2_val_view[i][j]),
          W_WF_WNMSUB => w_fp_nmuladd(rm_3b, rs1_val, wd_val_view[i][j], ws2_val_view[i][j]),
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_fwfmatype_mnemonic : w_fwfmafunct6 <-> string = {
 W_WF_WMADD      <-> "wfmadd.wf",
 W_WF_WNMADD     <-> "wfnmadd.wf",
 W_WF_WMSUB      <-> "wfmsub.wf",
 W_WF_WNMSUB     <-> "wfnmsub.wf",
 W_WF_WMACC      <-> "wfmacc.wf",
 W_WF_WNMACC     <-> "wfnmacc.wf",
 W_WF_WMSAC      <-> "wfmsac.wf",
 W_WF_WNMSAC     <-> "wfnmsac.wf"
}

mapping clause assembly = W_FWFMATYPE(funct6, wm, ws2, rs1, wd)
 <-> w_fwfmatype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ freg_name(rs1) ^ sep() ^ w_wreg_name(ws2) ^ w_maybe_wmask(wm)

// ************************** OPFVF (WFTYPE Widening) ***************************
union clause instruction = W_FWIDE_WFTYPE : (w_fwide_wffunct6, bits(1), wregidx, fregidx, wregidx)

mapping w_encdec_fwide_wffunct6 : w_fwide_wffunct6 <-> bits(6) = {
 W_FWIDE_WF_WADD       <-> 0b110000,
 W_FWIDE_WF_WSUB       <-> 0b110010,
 W_FWIDE_WF_WMUL       <-> 0b111000
}

mapping clause encdec = W_FWIDE_WFTYPE(funct6, wm, ws2, rs1, wd)
 <-> w_encdec_fwide_wffunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ encdec_freg(rs1) @ 0b101 @ w_encdec_wreg(wd) @ 0b0001011
 when ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh))   & w_get_sew() == 16)
  | ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 32)

function clause execute(W_FWIDE_WFTYPE(funct6, wm, ws2, rs1, wd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = W_LMUL_pow + 1;

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_fp_variable_width(wd, wm, SEW, rm_3b, SEW_widen, LMUL_pow_widen)
   | not(w_valid_reg_overlap(ws2, wd, W_LMUL_pow, LMUL_pow_widen))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW >= 16 & SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let wd_val : vector('n, bits('o)) = w_read_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd);
  let rs1_val : bits('m) = w_get_scalar_fp(rs1, sizeof('m));
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);

  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW_widen,
    LMUL_pow_widen,
    wd_val,
    wm_val,
  );
  var result = initial_result;

  {
    let mask_view = w_shape(mask, w_columns);
    var result_view = w_shape(result, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_FWIDE_WF_WADD => w_fp_add(rm_3b, w_fp_widen(ws2_val_view[i][j]), w_fp_widen(rs1_val)),
          W_FWIDE_WF_WSUB => w_fp_sub(rm_3b, w_fp_widen(ws2_val_view[i][j]), w_fp_widen(rs1_val)),
          W_FWIDE_WF_WMUL => w_fp_mul(rm_3b, w_fp_widen(ws2_val_view[i][j]), w_fp_widen(rs1_val)),
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_fwide_wftype_mnemonic : w_fwide_wffunct6 <-> string = {
 W_FWIDE_WF_WADD       <-> "wfwadd.wf",
 W_FWIDE_WF_WSUB       <-> "wfwsub.wf",
 W_FWIDE_WF_WMUL       <-> "wfwmul.wf"
}

mapping clause assembly = W_FWIDE_WFTYPE(funct6, wm, ws2, rs1, wd)
 <-> w_fwide_wftype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ freg_name(rs1) ^ w_maybe_wmask(wm)

// ******************* OPFVF (wftype Widening Multiply-Add) *********************
// Multiply-Add instructions switch the order of source operands in assembly (ws1/rs1 before ws2)
union clause instruction = W_FWIDE_WFMATYPE : (w_fwide_wfmafunct6, bits(1), fregidx, wregidx, wregidx)

mapping w_encdec_fwide_wfmafunct6 : w_fwide_wfmafunct6 <-> bits(6) = {
 W_FWIDE_WF_WMACC      <-> 0b111100,
 W_FWIDE_WF_WNMACC     <-> 0b111101,
 W_FWIDE_WF_WMSAC      <-> 0b111110,
 W_FWIDE_WF_WNMSAC     <-> 0b111111
}

mapping clause encdec = W_FWIDE_WFMATYPE(funct6, wm, rs1, ws2, wd)
 <-> w_encdec_fwide_wfmafunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ encdec_freg(rs1) @ 0b101 @ w_encdec_wreg(wd) @ 0b0001011
 when ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh))   & w_get_sew() == 16)
  | ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 32)

function clause execute(W_FWIDE_WFMATYPE(funct6, wm, rs1, ws2, wd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = W_LMUL_pow + 1;

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_fp_variable_width(wd, wm, SEW, rm_3b, SEW_widen, LMUL_pow_widen)
   | not(w_valid_reg_overlap(ws2, wd, W_LMUL_pow, LMUL_pow_widen))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW >= 16 & SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let wd_val : vector('n, bits('o)) = w_read_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd);
  let rs1_val : bits('m) = w_get_scalar_fp(rs1, sizeof('m));
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);

  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW_widen,
    LMUL_pow_widen,
    wd_val,
    wm_val,
  );
  var result = initial_result;

  {
    let mask_view = w_shape(mask, w_columns);
    var result_view = w_shape(result, w_columns);
    let wd_val_view = w_shape(wd_val, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(wd_val_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_FWIDE_WF_WMACC  => w_fp_muladd(
            rm_3b,
            w_fp_widen(rs1_val),
            w_fp_widen(ws2_val_view[i][j]),
            wd_val_view[i][j],
          ),
          W_FWIDE_WF_WNMACC => w_fp_nmulsub(
            rm_3b,
            w_fp_widen(rs1_val),
            w_fp_widen(ws2_val_view[i][j]),
            wd_val_view[i][j],
          ),
          W_FWIDE_WF_WMSAC  => w_fp_mulsub(
            rm_3b,
            w_fp_widen(rs1_val),
            w_fp_widen(ws2_val_view[i][j]),
            wd_val_view[i][j],
          ),
          W_FWIDE_WF_WNMSAC => w_fp_nmuladd(
            rm_3b,
            w_fp_widen(rs1_val),
            w_fp_widen(ws2_val_view[i][j]),
            wd_val_view[i][j],
          ),
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_fwide_wfmatype_mnemonic : w_fwide_wfmafunct6 <-> string = {
 W_FWIDE_WF_WMACC      <-> "wfwmacc.wf",
 W_FWIDE_WF_WNMACC     <-> "wfwnmacc.wf",
 W_FWIDE_WF_WMSAC      <-> "wfwmsac.wf",
 W_FWIDE_WF_WNMSAC     <-> "wfwnmsac.wf"
}

mapping clause assembly = W_FWIDE_WFMATYPE(funct6, wm, rs1, ws2, wd)
 <-> w_fwide_wfmatype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ freg_name(rs1) ^ sep() ^ w_wreg_name(ws2) ^ w_maybe_wmask(wm)

// ************************** OPFVF (WFTYPE Widening) ***************************
union clause instruction = W_FWIDE_FTYPE : (w_fwide_ffunct6, bits(1), wregidx, fregidx, wregidx)

mapping w_encdec_fwide_ffunct6 : w_fwide_ffunct6 <-> bits(6) = {
 W_FWIDE_F_WADD       <-> 0b110100,
 W_FWIDE_F_WSUB       <-> 0b110110
}

mapping clause encdec = W_FWIDE_FTYPE(funct6, wm, ws2, rs1, wd)
 <-> w_encdec_fwide_ffunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ encdec_freg(rs1) @ 0b101 @ w_encdec_wreg(wd) @ 0b0001011
 when ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh))   & w_get_sew() == 16)
  | ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 32)

function clause execute(W_FWIDE_FTYPE(funct6, wm, ws2, rs1, wd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = W_LMUL_pow + 1;

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_fp_variable_width(wd, wm, SEW, rm_3b, SEW_widen, LMUL_pow_widen)
   | not(w_valid_reg_group(ws2, LMUL_pow_widen))
   | not(w_valid_reg_group(wd, LMUL_pow_widen))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW_widen)) then {
    return Illegal_Instruction()
  };

  assert(SEW >= 16 & SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let wd_val : vector('n, bits('o)) = w_read_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd);
  let rs1_val : bits('m) = w_get_scalar_fp(rs1, sizeof('m));
  let ws2_val : vector('n, bits('o)) = w_read_wreg(num_elem, SEW_widen, LMUL_pow_widen, ws2);

  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW_widen,
    LMUL_pow_widen,
    wd_val,
    wm_val,
  );
  var result = initial_result;

  {
    let mask_view = w_shape(mask, w_columns);
    var result_view = w_shape(result, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_FWIDE_F_WADD => w_fp_add(rm_3b, ws2_val_view[i][j], w_fp_widen(rs1_val)),
          W_FWIDE_F_WSUB => w_fp_sub(rm_3b, ws2_val_view[i][j], w_fp_widen(rs1_val)),
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_fwide_ftype_mnemonic : w_fwide_ffunct6 <-> string = {
 W_FWIDE_F_WADD       <-> "wfwadd.wide.wf",
 W_FWIDE_F_WSUB       <-> "wfwsub.wide.wf"
}

mapping clause assembly = W_FWIDE_FTYPE(funct6, wm, ws2, rs1, wd)
 <-> w_fwide_ftype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ freg_name(rs1) ^ w_maybe_wmask(wm)

// ************************* OPFVF (Merge Instruction) **************************
// This instruction operates on all body elements regardless of mask value
union clause instruction = W_WFMERGE : (wregidx, fregidx, wregidx)

mapping clause encdec = W_WFMERGE(ws2, rs1, wd)
 <-> 0b010111 @ 0b0 @ w_encdec_wreg(ws2) @ encdec_freg(rs1) @ 0b101 @ w_encdec_wreg(wd) @ 0b0001011
 when ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh))   & w_get_sew() == 16)
  | ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_F)) & w_get_sew() == 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 64)

function clause execute(W_WFMERGE(ws2, rs1, wd)) = {
  let rm_3b = fcsr[FRM];
  let start_element = w_get_start_element();
  let end_element = w_get_end_element();
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW); // max(WLMAX,WLEN/SEW))
  let real_num_elem = if W_LMUL_pow >= 0 then {
      num_elem
    } else {
      num_elem / (0 - W_LMUL_pow)
    }; // WLMAX

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_fp_wd_masked(wd, SEW, rm_3b)
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_reg_group(wd, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(0b0, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW != 8);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, 0b0, w_zwreg);
  let rs1_val : bits('m) = w_get_scalar_fp(rs1, sizeof('m));
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);
  var result : vector('n, bits('m)) = vector_init(zeros());

  let tail_ag : w_agtype = w_get_wtype_wta();
  {
    var result_view = w_shape(result, w_columns);
    let wd_val_view = w_shape(wd_val, w_columns);
    let wm_val_view = w_shape(wm_val, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(result_view));
      assert(i < length(wd_val_view));
      assert(i < length(wm_val_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if p < start_element then {
        result_view[i][j] = wd_val_view[i][j]
      } else {
        if p > end_element | p >= real_num_elem then {
          result_view[i][j] = match tail_ag {
            W_UNDISTURBED => wd_val_view[i][j],
            W_AGNOSTIC    => wd_val_view[i][j], // TODO: configuration support
          }
        } else {
          // the merge operates on all body elements
          result_view[i][j] =
            if wm_val_view[i][j] == 0b1 then {
              rs1_val
            } else {
              ws2_val_view[i][j]
            }
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_WFMERGE(ws2, rs1, wd)
 <-> "wfmerge.wfm" ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ freg_name(rs1) ^ sep() ^ "w0"

// ************************* OPFVF (Move Instruction) ***************************
// This instruction shares the encoding with vfmerge.vfm, but with wm=1 and ws2=v0
union clause instruction = W_WFMV : (fregidx, wregidx)

mapping clause encdec = W_WFMV(rs1, wd)
 <-> 0b010111 @ 0b1 @ 0b00000 @ encdec_freg(rs1) @ 0b101 @ w_encdec_wreg(wd) @ 0b0001011
 when ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh))   & w_get_sew() == 16)
  | ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_F)) & w_get_sew() == 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 64)

function clause execute(W_WFMV(rs1, wd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_fp_wd_unmasked(SEW, rm_3b)
   | not(w_valid_reg_group(wd, W_LMUL_pow)) then {
    return Illegal_Instruction()
  };

  assert(SEW != 8);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let rs1_val : bits('m) = w_get_scalar_fp(rs1, sizeof('m));
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW,
    W_LMUL_pow,
    wd_val,
    ones(),
  );
  var result = initial_result;

  {
    let mask_view = w_shape(mask, w_columns);
    var result_view = w_shape(result, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = rs1_val
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_WFMV(rs1, wd)
 <-> "wfmv.w.f" ^ spc() ^ w_wreg_name(wd) ^ sep() ^ freg_name(rs1)

// ***************************** OPFVF (WRFUNARY0) ******************************
union clause instruction = W_WFMVSF : (fregidx, wregidx)

mapping clause encdec = W_WFMVSF(rs1, wd)
 <-> 0b010000 @ 0b1 @ 0b00000 @ encdec_freg(rs1) @ 0b101 @ w_encdec_wreg(wd) @ 0b0001011
 when ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh))   & w_get_sew() == 16)
  | ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_F)) & w_get_sew() == 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 64)

function clause execute(W_WFMVSF(rs1, wd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = w_get_sew();
  let num_elem = w_get_num_elem(0, SEW);

  // See WMVXS for LMUL usage here
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem_wstart = w_get_num_elem(W_LMUL_pow, SEW);

  if w_illegal_wstart(W_WSTART_SCALAR_MOVE, num_elem_wstart, W_LMUL_pow) | w_illegal_fp_wd_unmasked(SEW, rm_3b) then {
    return Illegal_Instruction()
  };

  assert(num_elem > 0 & SEW != 8);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let rs1_val : bits('m) = w_get_scalar_fp(rs1, sizeof('m));
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, 0, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW,
    0,
    wd_val,
    ones(),
  );
  var result = initial_result;

  // one body element
  if w_shape(mask, w_columns)[0][0] == 0b1 then {
    var origin_view = w_shape(result, w_columns);
    origin_view[0][0] = rs1_val;
    result = w_unshape_vector(length(result), origin_view, w_columns)
  };

  // others treated as tail elements
  let tail_ag : w_agtype = w_get_wtype_wta();
  {
    var result_view = w_shape(result, w_columns);
    let wd_val_view = w_shape(wd_val, w_columns);
    foreach (p from 1 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(result_view));
      assert(i < length(wd_val_view));
      assert(j < w_columns);

      result_view[i][j] = match tail_ag {
        W_UNDISTURBED => wd_val_view[i][j],
        W_AGNOSTIC    => wd_val_view[i][j], // TODO: configuration support
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, 0, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_WFMVSF(rs1, wd)
 <-> "wfmv.s.f" ^ spc() ^ w_wreg_name(wd) ^ sep() ^ freg_name(rs1)
