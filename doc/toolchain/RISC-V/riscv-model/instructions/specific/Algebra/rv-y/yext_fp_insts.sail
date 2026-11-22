// =======================================================================================
// This Sail RISC-Y architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

// ******************************************************************************
// This file implements part of the tensor extension.
// Chapter 13: Tensor Floating-Point Instructions
// Chapter 16: Tensor Permutation Instructions (floating-point part)
// ******************************************************************************

// ****************************** OPFVV (YYTYPE) ********************************
union clause instruction = Y_FYYTYPE : (y_fyyfunct6, bits(1), yregidx, yregidx, yregidx)

mapping y_encdec_fyyfunct6 : y_fyyfunct6 <-> bits(6) = {
 Y_FYY_YADD       <-> 0b000000,
 Y_FYY_YSUB       <-> 0b000010,
 Y_FYY_YMIN       <-> 0b000100,
 Y_FYY_YMAX       <-> 0b000110,
 Y_FYY_YSGNJ      <-> 0b001000,
 Y_FYY_YSGNJN     <-> 0b001001,
 Y_FYY_YSGNJX     <-> 0b001010,
 Y_FYY_YDIV       <-> 0b100000,
 Y_FYY_YMUL       <-> 0b100100
}

mapping clause encdec = Y_FYYTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_encdec_fyyfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ y_encdec_yreg(ys1) @ 0b001 @ y_encdec_yreg(yd) @ 0b0101011
 when ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh))   & y_get_sew() == 16)
  | ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_F)) & y_get_sew() == 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 64)

function clause execute(Y_FYYTYPE(funct6, ym, ys2, ys1, yd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_fp_normal(yd, ym, SEW, rm_3b)
   | not(y_valid_reg_group(ys1, Y_LMUL_pow))
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_reg_group(yd, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys1, SEW))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW != 8);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let ys1_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys1);
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);
  let yd_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = y_init_masked_result(
    num_elem,
    SEW,
    Y_LMUL_pow,
    yd_val,
    ym_val,
  );
  var result = initial_result;

  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    var result_view = y_shape(result, y_columns, y_depth);
    let ys1_val_view = y_shape(ys1_val, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ys1_val_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        result_view[i][j][k] = match funct6 {
          Y_FYY_YADD   => y_fp_add(rm_3b, ys2_val_view[i][j][k], ys1_val_view[i][j][k]),
          Y_FYY_YSUB   => y_fp_sub(rm_3b, ys2_val_view[i][j][k], ys1_val_view[i][j][k]),
          Y_FYY_YMIN   => y_fp_min(ys2_val_view[i][j][k], ys1_val_view[i][j][k]),
          Y_FYY_YMAX   => y_fp_max(ys2_val_view[i][j][k], ys1_val_view[i][j][k]),
          Y_FYY_YMUL   => y_fp_mul(rm_3b, ys2_val_view[i][j][k], ys1_val_view[i][j][k]),
          Y_FYY_YDIV   => y_fp_div(rm_3b, ys2_val_view[i][j][k], ys1_val_view[i][j][k]),
          Y_FYY_YSGNJ  => [ys1_val_view[i][j][k][sizeof('m) - 1]] @ ys2_val_view[i][j][k][sizeof('m) - 2 .. 0],
          Y_FYY_YSGNJN => (0b1 ^ [ys1_val_view[i][j][k][sizeof('m) - 1]]) @
            ys2_val_view[i][j][k][sizeof('m) - 2 .. 0],
          Y_FYY_YSGNJX => ([ys2_val_view[i][j][k][sizeof('m) - 1]] ^ [ys1_val_view[i][j][k][sizeof('m) - 1]]) @
            ys2_val_view[i][j][k][sizeof('m) - 2 .. 0],
        }
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW, Y_LMUL_pow, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_fyytype_mnemonic : y_fyyfunct6 <-> string = {
 Y_FYY_YADD       <-> "yfadd.yy",
 Y_FYY_YSUB       <-> "yfsub.yy",
 Y_FYY_YMIN       <-> "yfmin.yy",
 Y_FYY_YMAX       <-> "yfmax.yy",
 Y_FYY_YSGNJ      <-> "yfsgnj.yy",
 Y_FYY_YSGNJN     <-> "yfsgnjn.yy",
 Y_FYY_YSGNJX     <-> "yfsgnjx.yy",
 Y_FYY_YDIV       <-> "yfdiv.yy",
 Y_FYY_YMUL       <-> "yfmul.yy"
}

mapping clause assembly = Y_FYYTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_fyytype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ y_yreg_name(ys1) ^ y_maybe_ymask(ym)

// ************************ OPFVV (yytype Multiply-Add) *************************
// Multiply-Add instructions switch the order of source operands in assembly (ys1/rs1 before ys2)
union clause instruction = Y_FYYMATYPE : (y_fyymafunct6, bits(1), yregidx, yregidx, yregidx)

mapping y_encdec_fyymafunct6 : y_fyymafunct6 <-> bits(6) = {
 Y_FYY_YMADD      <-> 0b101000,
 Y_FYY_YNMADD     <-> 0b101001,
 Y_FYY_YMSUB      <-> 0b101010,
 Y_FYY_YNMSUB     <-> 0b101011,
 Y_FYY_YMACC      <-> 0b101100,
 Y_FYY_YNMACC     <-> 0b101101,
 Y_FYY_YMSAC      <-> 0b101110,
 Y_FYY_YNMSAC     <-> 0b101111
}

mapping clause encdec = Y_FYYMATYPE(funct6, ym, ys2, ys1, yd)
 <-> y_encdec_fyymafunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ y_encdec_yreg(ys1) @ 0b001 @ y_encdec_yreg(yd) @ 0b0101011
 when ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh))   & y_get_sew() == 16)
  | ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_F)) & y_get_sew() == 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 64)

function clause execute(Y_FYYMATYPE(funct6, ym, ys2, ys1, yd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_fp_normal(yd, ym, SEW, rm_3b)
   | not(y_valid_reg_group(ys1, Y_LMUL_pow))
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_reg_group(yd, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys1, SEW))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW != 8);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let ys1_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys1);
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);
  let yd_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = y_init_masked_result(
    num_elem,
    SEW,
    Y_LMUL_pow,
    yd_val,
    ym_val,
  );
  var result = initial_result;

  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    var result_view = y_shape(result, y_columns, y_depth);
    let yd_val_view = y_shape(yd_val, y_columns, y_depth);
    let ys1_val_view = y_shape(ys1_val, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(yd_val_view));
      assert(i < length(ys1_val_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        result_view[i][j][k] = match funct6 {
          Y_FYY_YMACC  => y_fp_muladd(
            rm_3b,
            ys1_val_view[i][j][k],
            ys2_val_view[i][j][k],
            yd_val_view[i][j][k],
          ),
          Y_FYY_YNMACC => y_fp_nmulsub(
            rm_3b,
            ys1_val_view[i][j][k],
            ys2_val_view[i][j][k],
            yd_val_view[i][j][k],
          ),
          Y_FYY_YMSAC  => y_fp_mulsub(
            rm_3b,
            ys1_val_view[i][j][k],
            ys2_val_view[i][j][k],
            yd_val_view[i][j][k],
          ),
          Y_FYY_YNMSAC => y_fp_nmuladd(
            rm_3b,
            ys1_val_view[i][j][k],
            ys2_val_view[i][j][k],
            yd_val_view[i][j][k],
          ),
          Y_FYY_YMADD  => y_fp_muladd(
            rm_3b,
            ys1_val_view[i][j][k],
            yd_val_view[i][j][k],
            ys2_val_view[i][j][k],
          ),
          Y_FYY_YNMADD => y_fp_nmulsub(
            rm_3b,
            ys1_val_view[i][j][k],
            yd_val_view[i][j][k],
            ys2_val_view[i][j][k],
          ),
          Y_FYY_YMSUB  => y_fp_mulsub(
            rm_3b,
            ys1_val_view[i][j][k],
            yd_val_view[i][j][k],
            ys2_val_view[i][j][k],
          ),
          Y_FYY_YNMSUB => y_fp_nmuladd(
            rm_3b,
            ys1_val_view[i][j][k],
            yd_val_view[i][j][k],
            ys2_val_view[i][j][k],
          ),
        }
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW, Y_LMUL_pow, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_fyymatype_mnemonic : y_fyymafunct6 <-> string = {
 Y_FYY_YMADD      <-> "yfmadd.yy",
 Y_FYY_YNMADD     <-> "yfnmadd.yy",
 Y_FYY_YMSUB      <-> "yfmsub.yy",
 Y_FYY_YNMSUB     <-> "yfnmsub.yy",
 Y_FYY_YMACC      <-> "yfmacc.yy",
 Y_FYY_YNMACC     <-> "yfnmacc.yy",
 Y_FYY_YMSAC      <-> "yfmsac.yy",
 Y_FYY_YNMSAC     <-> "yfnmsac.yy"
}

mapping clause assembly = Y_FYYMATYPE(funct6, ym, ys2, ys1, yd)
 <-> y_fyymatype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys1) ^ sep() ^ y_yreg_name(ys2) ^ y_maybe_ymask(ym)

// ************************** OPFVV (YYTYPE Widening) ***************************
union clause instruction = Y_FWIDE_YYTYPE : (y_fwide_yyfunct6, bits(1), yregidx, yregidx, yregidx)

mapping y_encdec_fwide_yyfunct6 : y_fwide_yyfunct6 <-> bits(6) = {
 Y_FWIDE_YY_YADD       <-> 0b110000,
 Y_FWIDE_YY_YSUB       <-> 0b110010,
 Y_FWIDE_YY_YMUL       <-> 0b111000
}

mapping clause encdec = Y_FWIDE_YYTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_encdec_fwide_yyfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ y_encdec_yreg(ys1) @ 0b001 @ y_encdec_yreg(yd) @ 0b0101011
 when ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh))   & y_get_sew() == 16)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 32)

function clause execute(Y_FWIDE_YYTYPE(funct6, ym, ys2, ys1, yd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = Y_LMUL_pow + 1;

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_fp_variable_width(yd, ym, SEW, rm_3b, SEW_widen, LMUL_pow_widen)
   | not(y_valid_reg_overlap(ys1, yd, Y_LMUL_pow, LMUL_pow_widen))
   | not(y_valid_reg_overlap(ys2, yd, Y_LMUL_pow, LMUL_pow_widen))
   | not(y_valid_ym_src_overlap(ym, ys1, SEW))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW >= 16 & SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let yd_val : vector('n, bits('o)) = y_read_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd);
  let ys1_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys1);
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);

  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = y_init_masked_result(
    num_elem,
    SEW_widen,
    LMUL_pow_widen,
    yd_val,
    ym_val,
  );
  var result = initial_result;

  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    var result_view = y_shape(result, y_columns, y_depth);
    let ys1_val_view = y_shape(ys1_val, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ys1_val_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        result_view[i][j][k] = match funct6 {
          Y_FWIDE_YY_YADD => y_fp_add(
            rm_3b,
            y_fp_widen(ys2_val_view[i][j][k]),
            y_fp_widen(ys1_val_view[i][j][k]),
          ),
          Y_FWIDE_YY_YSUB => y_fp_sub(
            rm_3b,
            y_fp_widen(ys2_val_view[i][j][k]),
            y_fp_widen(ys1_val_view[i][j][k]),
          ),
          Y_FWIDE_YY_YMUL => y_fp_mul(
            rm_3b,
            y_fp_widen(ys2_val_view[i][j][k]),
            y_fp_widen(ys1_val_view[i][j][k]),
          ),
        }
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_fwide_yytype_mnemonic : y_fwide_yyfunct6 <-> string = {
 Y_FWIDE_YY_YADD       <-> "yfwadd.yy",
 Y_FWIDE_YY_YSUB       <-> "yfwsub.yy",
 Y_FWIDE_YY_YMUL       <-> "yfwmul.yy"
}

mapping clause assembly = Y_FWIDE_YYTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_fwide_yytype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ y_yreg_name(ys1) ^ y_maybe_ymask(ym)

// ******************* OPFVV (yytype Widening Multiply-Add) *********************
// Multiply-Add instructions switch the order of source operands in assembly (ys1/rs1 before ys2)
union clause instruction = Y_FWIDE_YYMATYPE : (y_fwide_yymafunct6, bits(1), yregidx, yregidx, yregidx)

mapping y_encdec_fwide_yymafunct6 : y_fwide_yymafunct6 <-> bits(6) = {
 Y_FWIDE_YY_YMACC      <-> 0b111100,
 Y_FWIDE_YY_YNMACC     <-> 0b111101,
 Y_FWIDE_YY_YMSAC      <-> 0b111110,
 Y_FWIDE_YY_YNMSAC     <-> 0b111111
}

mapping clause encdec = Y_FWIDE_YYMATYPE(funct6, ym, ys1, ys2, yd)
 <-> y_encdec_fwide_yymafunct6(funct6) @ ym @ y_encdec_yreg(ys1) @ y_encdec_yreg(ys2) @ 0b001 @ y_encdec_yreg(yd) @ 0b0101011
 when ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh))   & y_get_sew() == 16)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 32)

function clause execute(Y_FWIDE_YYMATYPE(funct6, ym, ys1, ys2, yd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = Y_LMUL_pow + 1;

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_fp_variable_width(yd, ym, SEW, rm_3b, SEW_widen, LMUL_pow_widen)
   | not(y_valid_reg_overlap(ys1, yd, Y_LMUL_pow, LMUL_pow_widen))
   | not(y_valid_reg_overlap(ys2, yd, Y_LMUL_pow, LMUL_pow_widen))
   | // yd is also a source register
    not(y_valid_src_overlap(ys1, SEW, Y_LMUL_pow, yd, SEW_widen, LMUL_pow_widen))
   | not(y_valid_src_overlap(ys2, SEW, Y_LMUL_pow, yd, SEW_widen, LMUL_pow_widen))
   | not(y_valid_ym_src_overlap(ym, ys1, SEW))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW >= 16 & SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let yd_val : vector('n, bits('o)) = y_read_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd);
  let ys1_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys1);
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);

  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = y_init_masked_result(
    num_elem,
    SEW_widen,
    LMUL_pow_widen,
    yd_val,
    ym_val,
  );
  var result = initial_result;

  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    var result_view = y_shape(result, y_columns, y_depth);
    let yd_val_view = y_shape(yd_val, y_columns, y_depth);
    let ys1_val_view = y_shape(ys1_val, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(yd_val_view));
      assert(i < length(ys1_val_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        result_view[i][j][k] = match funct6 {
          Y_FWIDE_YY_YMACC  => y_fp_muladd(
            rm_3b,
            y_fp_widen(ys1_val_view[i][j][k]),
            y_fp_widen(ys2_val_view[i][j][k]),
            yd_val_view[i][j][k],
          ),
          Y_FWIDE_YY_YNMACC => y_fp_nmulsub(
            rm_3b,
            y_fp_widen(ys1_val_view[i][j][k]),
            y_fp_widen(ys2_val_view[i][j][k]),
            yd_val_view[i][j][k],
          ),
          Y_FWIDE_YY_YMSAC  => y_fp_mulsub(
            rm_3b,
            y_fp_widen(ys1_val_view[i][j][k]),
            y_fp_widen(ys2_val_view[i][j][k]),
            yd_val_view[i][j][k],
          ),
          Y_FWIDE_YY_YNMSAC => y_fp_nmuladd(
            rm_3b,
            y_fp_widen(ys1_val_view[i][j][k]),
            y_fp_widen(ys2_val_view[i][j][k]),
            yd_val_view[i][j][k],
          ),
        }
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_fwide_yymatype_mnemonic : y_fwide_yymafunct6 <-> string = {
 Y_FWIDE_YY_YMACC      <-> "yfwmacc.yy",
 Y_FWIDE_YY_YNMACC     <-> "yfwnmacc.yy",
 Y_FWIDE_YY_YMSAC      <-> "yfwmsac.yy",
 Y_FWIDE_YY_YNMSAC     <-> "yfwnmsac.yy"
}

mapping clause assembly = Y_FWIDE_YYMATYPE(funct6, ym, ys1, ys2, yd)
 <-> y_fwide_yymatype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys1) ^ sep() ^ y_yreg_name(ys2) ^ y_maybe_ymask(ym)

// ************************** OPFVV (WIDE_YTYPE Widening) ***************************
union clause instruction = Y_FWIDE_YTYPE : (y_fwide_yfunct6, bits(1), yregidx, yregidx, yregidx)

mapping y_encdec_fwide_yfunct6 : y_fwide_yfunct6 <-> bits(6) = {
 Y_FWIDE_Y_YADD       <-> 0b110100,
 Y_FWIDE_Y_YSUB       <-> 0b110110
}

mapping clause encdec = Y_FWIDE_YTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_encdec_fwide_yfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ y_encdec_yreg(ys1) @ 0b001 @ y_encdec_yreg(yd) @ 0b0101011
 when ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh))   & y_get_sew() == 16)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 32)

function clause execute(Y_FWIDE_YTYPE(funct6, ym, ys2, ys1, yd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = Y_LMUL_pow + 1;

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_fp_variable_width(yd, ym, SEW, rm_3b, SEW_widen, LMUL_pow_widen)
   | not(y_valid_reg_overlap(ys1, yd, Y_LMUL_pow, LMUL_pow_widen))
   | not(y_valid_src_overlap(ys2, SEW_widen, LMUL_pow_widen, ys1, SEW, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys1, SEW))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW_widen)) then {
    return Illegal_Instruction()
  };

  assert(SEW >= 16 & SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let yd_val : vector('n, bits('o)) = y_read_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd);
  let ys1_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys1);
  let ys2_val : vector('n, bits('o)) = y_read_yreg(num_elem, SEW_widen, LMUL_pow_widen, ys2);

  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = y_init_masked_result(
    num_elem,
    SEW_widen,
    LMUL_pow_widen,
    yd_val,
    ym_val,
  );
  var result = initial_result;

  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    var result_view = y_shape(result, y_columns, y_depth);
    let ys1_val_view = y_shape(ys1_val, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ys1_val_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        result_view[i][j][k] = match funct6 {
          Y_FWIDE_Y_YADD => y_fp_add(rm_3b, ys2_val_view[i][j][k], y_fp_widen(ys1_val_view[i][j][k])),
          Y_FWIDE_Y_YSUB => y_fp_sub(rm_3b, ys2_val_view[i][j][k], y_fp_widen(ys1_val_view[i][j][k])),
        }
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_fwide_ytype_mnemonic : y_fwide_yfunct6 <-> string = {
 Y_FWIDE_Y_YADD       <-> "yfwadd.wide.yy",
 Y_FWIDE_Y_YSUB       <-> "yfwsub.wide.yy"
}

mapping clause assembly = Y_FWIDE_YTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_fwide_ytype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ y_yreg_name(ys1) ^ y_maybe_ymask(ym)

// ***************************** OPFVV (YFUNARY0) *******************************
union clause instruction = Y_YFUNARY0 : (bits(1), yregidx, y_yfunary0, yregidx)

mapping y_encdec_yfunary0_ys1 : y_yfunary0 <-> bits(5) = {
 Y_FY_CVT_XU_F       <-> 0b00000,
 Y_FY_CVT_X_F        <-> 0b00001,
 Y_FY_CVT_F_XU       <-> 0b00010,
 Y_FY_CVT_F_X        <-> 0b00011,
 Y_FY_CVT_RTZ_XU_F   <-> 0b00110,
 Y_FY_CVT_RTZ_X_F    <-> 0b00111
}

mapping clause encdec = Y_YFUNARY0(ym, ys2, y_yfunary0, yd)
 <-> 0b010010 @ ym @ y_encdec_yreg(ys2) @ y_encdec_yfunary0_ys1(y_yfunary0) @ 0b001 @ y_encdec_yreg(yd) @ 0b0101011
 when ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh))   & y_get_sew() == 16)
  | ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_F)) & y_get_sew() == 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 64)

function clause execute(Y_YFUNARY0(ym, ys2, y_yfunary0, yd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_fp_normal(yd, ym, SEW, rm_3b)
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_reg_group(yd, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW != 8);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);
  let yd_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = y_init_masked_result(
    num_elem,
    SEW,
    Y_LMUL_pow,
    yd_val,
    ym_val,
  );
  var result = initial_result;

  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    var result_view = y_shape(result, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        result_view[i][j][k] = match y_yfunary0 {
          Y_FY_CVT_XU_F     => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              16 => y_riscv_f16ToUi16(rm_3b, ys2_val_view[i][j][k]),
              32 => riscv_f32ToUi32(rm_3b, ys2_val_view[i][j][k]),
              64 => riscv_f64ToUi64(rm_3b, ys2_val_view[i][j][k]),
            };
            accrue_fflags(fflags);
            elem
          },
          Y_FY_CVT_X_F      => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              16 => y_riscv_f16ToI16(rm_3b, ys2_val_view[i][j][k]),
              32 => riscv_f32ToI32(rm_3b, ys2_val_view[i][j][k]),
              64 => riscv_f64ToI64(rm_3b, ys2_val_view[i][j][k]),
            };
            accrue_fflags(fflags);
            elem
          },
          Y_FY_CVT_F_XU     => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              16 => riscv_ui32ToF16(rm_3b, zero_extend(ys2_val_view[i][j][k])),
              32 => riscv_ui32ToF32(rm_3b, ys2_val_view[i][j][k]),
              64 => riscv_ui64ToF64(rm_3b, ys2_val_view[i][j][k]),
            };
            accrue_fflags(fflags);
            elem
          },
          Y_FY_CVT_F_X      => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              16 => riscv_i32ToF16(rm_3b, sign_extend(ys2_val_view[i][j][k])),
              32 => riscv_i32ToF32(rm_3b, ys2_val_view[i][j][k]),
              64 => riscv_i64ToF64(rm_3b, ys2_val_view[i][j][k]),
            };
            accrue_fflags(fflags);
            elem
          },
          Y_FY_CVT_RTZ_XU_F => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              16 => y_riscv_f16ToUi16(0b001, ys2_val_view[i][j][k]),
              32 => riscv_f32ToUi32(0b001, ys2_val_view[i][j][k]),
              64 => riscv_f64ToUi64(0b001, ys2_val_view[i][j][k]),
            };
            accrue_fflags(fflags);
            elem
          },
          Y_FY_CVT_RTZ_X_F  => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              16 => y_riscv_f16ToI16(0b001, ys2_val_view[i][j][k]),
              32 => riscv_f32ToI32(0b001, ys2_val_view[i][j][k]),
              64 => riscv_f64ToI64(0b001, ys2_val_view[i][j][k]),
            };
            accrue_fflags(fflags);
            elem
          },
        }
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW, Y_LMUL_pow, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_yfunary0_mnemonic : y_yfunary0 <-> string = {
 Y_FY_CVT_XU_F       <-> "yfcvt.xu.f.y",
 Y_FY_CVT_X_F        <-> "yfcvt.x.f.y",
 Y_FY_CVT_F_XU       <-> "yfcvt.f.xu.y",
 Y_FY_CVT_F_X        <-> "yfcvt.f.x.y",
 Y_FY_CVT_RTZ_XU_F   <-> "yfcvt.rtz.xu.f.y",
 Y_FY_CVT_RTZ_X_F    <-> "yfcvt.rtz.x.f.y"
}

mapping clause assembly = Y_YFUNARY0(ym, ys2, y_yfunary0, yd)
 <-> y_yfunary0_mnemonic(y_yfunary0) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ y_maybe_ymask(ym)

// ************************* OPFVV (YFUNARY0 Widening) **************************
union clause instruction = Y_YFWUNARY0 : (bits(1), yregidx, y_vfwunary0, yregidx)

mapping y_encdec_vfwunary0_ys1 : y_vfwunary0 <-> bits(5) = {
 Y_FWIDE_Y_CVT_XU_F      <-> 0b01000,
 Y_FWIDE_Y_CVT_X_F       <-> 0b01001,
 Y_FWIDE_Y_CVT_F_XU      <-> 0b01010,
 Y_FWIDE_Y_CVT_F_X       <-> 0b01011,
 Y_FWIDE_Y_CVT_F_F       <-> 0b01100,
 Y_FWIDE_Y_CVT_RTZ_XU_F  <-> 0b01110,
 Y_FWIDE_Y_CVT_RTZ_X_F   <-> 0b01111
}

mapping clause encdec = Y_YFWUNARY0(ym, ys2, y_vfwunary0, yd)
 <-> 0b010010 @ ym @ y_encdec_yreg(ys2) @ y_encdec_vfwunary0_ys1(y_vfwunary0) @ 0b001 @ y_encdec_yreg(yd) @ 0b0101011
 when y_valid_widening_fp_conversion(y_vfwunary0)

function clause execute(Y_YFWUNARY0(ym, ys2, y_vfwunary0, yd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = Y_LMUL_pow + 1;

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_fp_variable_width(yd, ym, SEW, rm_3b, SEW_widen, LMUL_pow_widen)
   | not(y_valid_reg_overlap(ys2, yd, Y_LMUL_pow, LMUL_pow_widen))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW >= 8 & SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);
  let yd_val : vector('n, bits('o)) = y_read_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd);

  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = y_init_masked_result(
    num_elem,
    SEW_widen,
    LMUL_pow_widen,
    yd_val,
    ym_val,
  );
  var result = initial_result;

  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    var result_view = y_shape(result, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        result_view[i][j][k] = match y_vfwunary0 {
          Y_FWIDE_Y_CVT_XU_F     => {
            let (fflags, elem) : (bits_fflags, bits('o)) = match sizeof('m) {
              8 => return Illegal_Instruction(),
              16 => riscv_f16ToUi32(rm_3b, ys2_val_view[i][j][k]),
              32 => riscv_f32ToUi64(rm_3b, ys2_val_view[i][j][k]),
            };
            accrue_fflags(fflags);
            elem
          },
          Y_FWIDE_Y_CVT_X_F      => {
            let (fflags, elem) : (bits_fflags, bits('o)) = match sizeof('m) {
              8 => return Illegal_Instruction(),
              16 => riscv_f16ToI32(rm_3b, ys2_val_view[i][j][k]),
              32 => riscv_f32ToI64(rm_3b, ys2_val_view[i][j][k]),
            };
            accrue_fflags(fflags);
            elem
          },
          Y_FWIDE_Y_CVT_F_XU     => {
            let (fflags, elem) : (bits_fflags, bits('o)) = match sizeof('m) {
              8 => riscv_ui32ToF16(rm_3b, zero_extend(ys2_val_view[i][j][k])),
              16 => riscv_ui32ToF32(rm_3b, zero_extend(ys2_val_view[i][j][k])),
              32 => riscv_ui32ToF64(rm_3b, ys2_val_view[i][j][k]),
            };
            accrue_fflags(fflags);
            elem
          },
          Y_FWIDE_Y_CVT_F_X      => {
            let (fflags, elem) : (bits_fflags, bits('o)) = match sizeof('m) {
              8 => riscv_i32ToF16(rm_3b, sign_extend(ys2_val_view[i][j][k])),
              16 => riscv_i32ToF32(rm_3b, sign_extend(ys2_val_view[i][j][k])),
              32 => riscv_i32ToF64(rm_3b, ys2_val_view[i][j][k]),
            };
            accrue_fflags(fflags);
            elem
          },
          Y_FWIDE_Y_CVT_F_F      => {
            let (fflags, elem) : (bits_fflags, bits('o)) = match sizeof('m) {
              8 => return Illegal_Instruction(),
              16 => riscv_f16ToF32(rm_3b, ys2_val_view[i][j][k]),
              32 => riscv_f32ToF64(rm_3b, ys2_val_view[i][j][k]),
            };
            accrue_fflags(fflags);
            elem
          },
          Y_FWIDE_Y_CVT_RTZ_XU_F => {
            let (fflags, elem) : (bits_fflags, bits('o)) = match sizeof('m) {
              8 => return Illegal_Instruction(),
              16 => riscv_f16ToUi32(0b001, ys2_val_view[i][j][k]),
              32 => riscv_f32ToUi64(0b001, ys2_val_view[i][j][k]),
            };
            accrue_fflags(fflags);
            elem
          },
          Y_FWIDE_Y_CVT_RTZ_X_F  => {
            let (fflags, elem) : (bits_fflags, bits('o)) = match sizeof('m) {
              8 => return Illegal_Instruction(),
              16 => riscv_f16ToI32(0b001, ys2_val_view[i][j][k]),
              32 => riscv_f32ToI64(0b001, ys2_val_view[i][j][k]),
            };
            accrue_fflags(fflags);
            elem
          },
        }
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_vfwunary0_mnemonic : y_vfwunary0 <-> string = {
 Y_FWIDE_Y_CVT_XU_F      <-> "yfwcvt.xu.f.y",
 Y_FWIDE_Y_CVT_X_F       <-> "yfwcvt.x.f.y",
 Y_FWIDE_Y_CVT_F_XU      <-> "yfwcvt.f.xu.y",
 Y_FWIDE_Y_CVT_F_X       <-> "yfwcvt.f.x.y",
 Y_FWIDE_Y_CVT_F_F       <-> "yfwcvt.f.f.y",
 Y_FWIDE_Y_CVT_RTZ_XU_F  <-> "yfwcvt.rtz.xu.f.y",
 Y_FWIDE_Y_CVT_RTZ_X_F   <-> "yfwcvt.rtz.x.f.y"
}

mapping clause assembly = Y_YFWUNARY0(ym, ys2, y_vfwunary0, yd)
 <-> y_vfwunary0_mnemonic(y_vfwunary0) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ y_maybe_ymask(ym)

// ************************ OPFVV (YFUNARY0 Narrowing) **************************
union clause instruction = Y_YFNUNARY0 : (bits(1), yregidx, y_vfnunary0, yregidx)

mapping y_encdec_vfnunary0_ys1 : y_vfnunary0 <-> bits(5) = {
 Y_FNV_CVT_XU_F      <-> 0b10000,
 Y_FNV_CVT_X_F       <-> 0b10001,
 Y_FNV_CVT_F_XU      <-> 0b10010,
 Y_FNV_CVT_F_X       <-> 0b10011,
 Y_FNV_CVT_F_F       <-> 0b10100,
 Y_FNV_CVT_ROD_F_F   <-> 0b10101,
 Y_FNV_CVT_RTZ_XU_F  <-> 0b10110,
 Y_FNV_CVT_RTZ_X_F   <-> 0b10111
}

mapping clause encdec = Y_YFNUNARY0(ym, ys2, y_vfnunary0, yd)
 <-> 0b010010 @ ym @ y_encdec_yreg(ys2) @ y_encdec_vfnunary0_ys1(y_vfnunary0) @ 0b001 @ y_encdec_yreg(yd) @ 0b0101011
 when y_valid_narrowing_fp_conversion(y_vfnunary0)

function clause execute(Y_YFNUNARY0(ym, ys2, y_vfnunary0, yd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = Y_LMUL_pow + 1;

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_fp_variable_width(yd, ym, SEW, rm_3b, SEW_widen, LMUL_pow_widen)
   | not(y_valid_reg_overlap(ys2, yd, LMUL_pow_widen, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW_widen)) then {
    return Illegal_Instruction()
  };

  assert(SEW != 64);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let ys2_val : vector('n, bits('o)) = y_read_yreg(num_elem, SEW_widen, LMUL_pow_widen, ys2);
  let yd_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = y_init_masked_result(
    num_elem,
    SEW,
    Y_LMUL_pow,
    yd_val,
    ym_val,
  );
  var result = initial_result;

  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    var result_view = y_shape(result, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        result_view[i][j][k] = match y_vfnunary0 {
          Y_FNV_CVT_XU_F     => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              8 => y_riscv_f16ToUi8(rm_3b, ys2_val_view[i][j][k]),
              16 => y_riscv_f32ToUi16(rm_3b, ys2_val_view[i][j][k]),
              32 => riscv_f64ToUi32(rm_3b, ys2_val_view[i][j][k]),
            };
            accrue_fflags(fflags);
            elem
          },
          Y_FNV_CVT_X_F      => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              8 => y_riscv_f16ToI8(rm_3b, ys2_val_view[i][j][k]),
              16 => y_riscv_f32ToI16(rm_3b, ys2_val_view[i][j][k]),
              32 => riscv_f64ToI32(rm_3b, ys2_val_view[i][j][k]),
            };
            accrue_fflags(fflags);
            elem
          },
          Y_FNV_CVT_F_XU     => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              8 => return Illegal_Instruction(),
              16 => riscv_ui32ToF16(rm_3b, ys2_val_view[i][j][k]),
              32 => riscv_ui64ToF32(rm_3b, ys2_val_view[i][j][k]),
            };
            accrue_fflags(fflags);
            elem
          },
          Y_FNV_CVT_F_X      => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              8 => return Illegal_Instruction(),
              16 => riscv_i32ToF16(rm_3b, ys2_val_view[i][j][k]),
              32 => riscv_i64ToF32(rm_3b, ys2_val_view[i][j][k]),
            };
            accrue_fflags(fflags);
            elem
          },
          Y_FNV_CVT_F_F      => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              8 => return Illegal_Instruction(),
              16 => riscv_f32ToF16(rm_3b, ys2_val_view[i][j][k]),
              32 => riscv_f64ToF32(rm_3b, ys2_val_view[i][j][k]),
            };
            accrue_fflags(fflags);
            elem
          },
          Y_FNV_CVT_ROD_F_F  => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              8 => return Illegal_Instruction(),
              16 => riscv_f32ToF16(0b110, ys2_val_view[i][j][k]),
              32 => riscv_f64ToF32(0b110, ys2_val_view[i][j][k]),
            };
            accrue_fflags(fflags);
            elem
          },
          Y_FNV_CVT_RTZ_XU_F => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              8 => y_riscv_f16ToUi8(0b001, ys2_val_view[i][j][k]),
              16 => y_riscv_f32ToUi16(0b001, ys2_val_view[i][j][k]),
              32 => riscv_f64ToUi32(0b001, ys2_val_view[i][j][k]),
            };
            accrue_fflags(fflags);
            elem
          },
          Y_FNV_CVT_RTZ_X_F  => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              8 => y_riscv_f16ToI8(0b001, ys2_val_view[i][j][k]),
              16 => y_riscv_f32ToI16(0b001, ys2_val_view[i][j][k]),
              32 => riscv_f64ToI32(0b001, ys2_val_view[i][j][k]),
            };
            accrue_fflags(fflags);
            elem
          },
        }
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW, Y_LMUL_pow, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_vfnunary0_mnemonic : y_vfnunary0 <-> string = {
 Y_FNV_CVT_XU_F      <-> "yfncvt.xu.f.wide",
 Y_FNV_CVT_X_F       <-> "yfncvt.x.f.wide",
 Y_FNV_CVT_F_XU      <-> "yfncvt.f.xu.wide",
 Y_FNV_CVT_F_X       <-> "yfncvt.f.x.wide",
 Y_FNV_CVT_F_F       <-> "yfncvt.f.f.wide",
 Y_FNV_CVT_ROD_F_F   <-> "yfncvt.rod.f.f.wide",
 Y_FNV_CVT_RTZ_XU_F  <-> "yfncvt.rtz.xu.f.wide",
 Y_FNV_CVT_RTZ_X_F   <-> "yfncvt.rtz.x.f.wide"
}

mapping clause assembly = Y_YFNUNARY0(ym, ys2, y_vfnunary0, yd)
 <-> y_vfnunary0_mnemonic(y_vfnunary0) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ y_maybe_ymask(ym)

// ***************************** OPFVV (YFUNARY1) *******************************
union clause instruction = Y_YFUNARY1 : (bits(1), yregidx, y_yfunary1, yregidx)

mapping y_encdec_yfunary1_ys1 : y_yfunary1 <-> bits(5) = {
 Y_FYY_YSQRT       <-> 0b00000,
 Y_FYY_YRSQRT7     <-> 0b00100,
 Y_FYY_YREC7       <-> 0b00101,
 Y_FYY_YCLASS      <-> 0b10000
}

mapping clause encdec = Y_YFUNARY1(ym, ys2, y_yfunary1, yd)
 <-> 0b010011 @ ym @ y_encdec_yreg(ys2) @ y_encdec_yfunary1_ys1(y_yfunary1) @ 0b001 @ y_encdec_yreg(yd) @ 0b0101011
 when ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh))   & y_get_sew() == 16)
  | ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_F)) & y_get_sew() == 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 64)

function clause execute(Y_YFUNARY1(ym, ys2, y_yfunary1, yd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_fp_normal(yd, ym, SEW, rm_3b)
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_reg_group(yd, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW != 8);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);
  let yd_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = y_init_masked_result(
    num_elem,
    SEW,
    Y_LMUL_pow,
    yd_val,
    ym_val,
  );
  var result = initial_result;

  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    var result_view = y_shape(result, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        result_view[i][j][k] = match y_yfunary1 {
          Y_FYY_YSQRT   => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              16 => riscv_f16Sqrt(rm_3b, ys2_val_view[i][j][k]),
              32 => riscv_f32Sqrt(rm_3b, ys2_val_view[i][j][k]),
              64 => riscv_f64Sqrt(rm_3b, ys2_val_view[i][j][k]),
            };
            accrue_fflags(fflags);
            elem
          },
          Y_FYY_YRSQRT7 => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              16 => y_riscv_f16Rsqrte7(rm_3b, ys2_val_view[i][j][k]),
              32 => y_riscv_f32Rsqrte7(rm_3b, ys2_val_view[i][j][k]),
              64 => y_riscv_f64Rsqrte7(rm_3b, ys2_val_view[i][j][k]),
            };
            accrue_fflags(fflags);
            elem
          },
          Y_FYY_YREC7   => {
            let (fflags, elem) : (bits_fflags, bits('m)) = match sizeof('m) {
              16 => y_riscv_f16Recip7(rm_3b, ys2_val_view[i][j][k]),
              32 => y_riscv_f32Recip7(rm_3b, ys2_val_view[i][j][k]),
              64 => y_riscv_f64Recip7(rm_3b, ys2_val_view[i][j][k]),
            };
            accrue_fflags(fflags);
            elem
          },
          Y_FYY_YCLASS  => zero_extend(float_class_onehot_bits(float_classify(ys2_val_view[i][j][k]))),
        }
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW, Y_LMUL_pow, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_yfunary1_mnemonic : y_yfunary1 <-> string = {
 Y_FYY_YSQRT       <-> "yfsqrt.y",
 Y_FYY_YRSQRT7     <-> "yfrsqrt7.y",
 Y_FYY_YREC7       <-> "yfrec7.y",
 Y_FYY_YCLASS      <-> "yfclass.y"
}

mapping clause assembly = Y_YFUNARY1(ym, ys2, y_yfunary1, yd)
 <-> y_yfunary1_mnemonic(y_yfunary1) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ y_maybe_ymask(ym)

// ***************************** OPFVV (YWFUNARY0) ******************************
union clause instruction = Y_YFMVFS : (yregidx, fregidx)

mapping clause encdec = Y_YFMVFS(ys2, rd)
 <-> 0b010000 @ 0b1 @ y_encdec_yreg(ys2) @ 0b00000 @ 0b001 @ encdec_freg(rd) @ 0b0101011
 when ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh))   & y_get_sew() == 16)
  | ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_F)) & y_get_sew() == 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 64)

function clause execute(Y_YFMVFS(ys2, rd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = y_get_sew();
  let num_elem = y_get_num_elem(0, SEW);

  // See comment in YMVXS for the use of LMUL
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem_ystart = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_SCALAR_MOVE, num_elem_ystart, Y_LMUL_pow)
   | y_illegal_fp_yd_unmasked(SEW, rm_3b)
   | SEW
   > flen then {
    return Illegal_Instruction()
  };

  assert(num_elem > 0 & SEW != 8);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, 0, ys2);
  match sizeof('m) {
    16 => F_H(rd) = y_shape(ys2_val, y_columns, y_depth)[0][0][0],
    32 => F_S(rd) = y_shape(ys2_val, y_columns, y_depth)[0][0][0],
    64 => F_D(rd) = y_shape(ys2_val, y_columns, y_depth)[0][0][0],
  };
  y_set_ystart(zeros());

  RETIRE_SUCCESS
}

mapping clause assembly = Y_YFMVFS(ys2, rd)
 <-> "yfmv.f.s" ^ spc() ^ freg_name(rd) ^ sep() ^ y_yreg_name(ys2)

// ****************************** OPFVF (yftype) ********************************
union clause instruction = Y_FYFTYPE : (y_fyffunct6, bits(1), yregidx, fregidx, yregidx)

mapping y_encdec_fyffunct6 : y_fyffunct6 <-> bits(6) = {
 Y_YF_YADD          <-> 0b000000,
 Y_YF_YSUB          <-> 0b000010,
 Y_YF_YMIN          <-> 0b000100,
 Y_YF_YMAX          <-> 0b000110,
 Y_YF_YSGNJ         <-> 0b001000,
 Y_YF_YSGNJN        <-> 0b001001,
 Y_YF_YSGNJX        <-> 0b001010,
 Y_YF_YSLIDE1UP     <-> 0b001110,
 Y_YF_YSLIDE1DOWN   <-> 0b001111,
 Y_YF_YDIV          <-> 0b100000,
 Y_YF_YRDIV         <-> 0b100001,
 Y_YF_YMUL          <-> 0b100100,
 Y_YF_YRSUB         <-> 0b100111
}

mapping clause encdec = Y_FYFTYPE(funct6, ym, ys2, rs1, yd)
 <-> y_encdec_fyffunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ encdec_freg(rs1) @ 0b101 @ y_encdec_yreg(yd) @ 0b0101011
 when ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh))   & y_get_sew() == 16)
  | ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_F)) & y_get_sew() == 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 64)

function clause execute(Y_FYFTYPE(funct6, ym, ys2, rs1, yd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  // "The vslide1up instruction requires that the destination vector
  // register group does not overlap the source vector register
  // group. Otherwise, the instruction encoding is reserved."
  let src_dst_overlap = funct6 == Y_YF_YSLIDE1UP & ys2 == yd;

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_fp_normal(yd, ym, SEW, rm_3b)
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_reg_group(yd, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW))
   | src_dst_overlap then {
    return Illegal_Instruction()
  };

  assert(SEW != 8);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let rs1_val : bits('m) = y_get_scalar_fp(rs1, sizeof('m));
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);
  let yd_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = y_init_masked_result(
    num_elem,
    SEW,
    Y_LMUL_pow,
    yd_val,
    ym_val,
  );
  var result = initial_result;

  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    var result_view = y_shape(result, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        result_view[i][j][k] = match funct6 {
          Y_YF_YADD        => y_fp_add(rm_3b, ys2_val_view[i][j][k], rs1_val),
          Y_YF_YSUB        => y_fp_sub(rm_3b, ys2_val_view[i][j][k], rs1_val),
          Y_YF_YRSUB       => y_fp_sub(rm_3b, rs1_val, ys2_val_view[i][j][k]),
          Y_YF_YMIN        => y_fp_min(ys2_val_view[i][j][k], rs1_val),
          Y_YF_YMAX        => y_fp_max(ys2_val_view[i][j][k], rs1_val),
          Y_YF_YMUL        => y_fp_mul(rm_3b, ys2_val_view[i][j][k], rs1_val),
          Y_YF_YDIV        => y_fp_div(rm_3b, ys2_val_view[i][j][k], rs1_val),
          Y_YF_YRDIV       => y_fp_div(rm_3b, rs1_val, ys2_val_view[i][j][k]),
          Y_YF_YSGNJ       => [rs1_val[sizeof('m) - 1]] @ ys2_val_view[i][j][k][sizeof('m) - 2 .. 0],
          Y_YF_YSGNJN      => (0b1 ^ [rs1_val[sizeof('m) - 1]]) @ ys2_val_view[i][j][k][sizeof('m) - 2 .. 0],
          Y_YF_YSGNJX      => ([ys2_val_view[i][j][k][sizeof('m) - 1]] ^ [rs1_val[sizeof('m) - 1]]) @
            ys2_val_view[i][j][k][sizeof('m) - 2 .. 0],
          Y_YF_YSLIDE1UP   => {
            if p == 0 then {
              rs1_val
            } else {
              ys2_val_view[(p - 1) / (y_columns * y_depth)][((p - 1) / y_depth) % y_columns][
                (p - 1) % y_depth
              ]
            }
          },
          Y_YF_YSLIDE1DOWN => {
            let last_elem = y_get_end_element();
            assert(last_elem < num_elem);
            if p < last_elem then {
              ys2_val_view[(p + 1) / (y_columns * y_depth)][((p + 1) / y_depth) % y_columns][
                (p + 1) % y_depth
              ]
            } else {
              rs1_val
            }
          },
        }
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW, Y_LMUL_pow, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_fyftype_mnemonic : y_fyffunct6 <-> string = {
 Y_YF_YADD          <-> "yfadd.yf",
 Y_YF_YSUB          <-> "yfsub.yf",
 Y_YF_YMIN          <-> "yfmin.yf",
 Y_YF_YMAX          <-> "yfmax.yf",
 Y_YF_YSGNJ         <-> "yfsgnj.yf",
 Y_YF_YSGNJN        <-> "yfsgnjn.yf",
 Y_YF_YSGNJX        <-> "yfsgnjx.yf",
 Y_YF_YSLIDE1UP     <-> "yfslide1up.yf",
 Y_YF_YSLIDE1DOWN   <-> "yfslide1down.yf",
 Y_YF_YDIV          <-> "yfdiv.yf",
 Y_YF_YRDIV         <-> "yfrdiv.yf",
 Y_YF_YMUL          <-> "yfmul.yf",
 Y_YF_YRSUB         <-> "yfrsub.yf"
}

mapping clause assembly = Y_FYFTYPE(funct6, ym, ys2, rs1, yd)
 <-> y_fyftype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ freg_name(rs1) ^ y_maybe_ymask(ym)

// ************************ OPFVF (yftype Multiply-Add) *************************
// Multiply-Add instructions switch the order of source operands in assembly (ys1/rs1 before ys2)
union clause instruction = Y_FYFMATYPE : (y_fyfmafunct6, bits(1), yregidx, fregidx, yregidx)

mapping y_encdec_fyfmafunct6 : y_fyfmafunct6 <-> bits(6) = {
 Y_YF_YMADD      <-> 0b101000,
 Y_YF_YNMADD     <-> 0b101001,
 Y_YF_YMSUB      <-> 0b101010,
 Y_YF_YNMSUB     <-> 0b101011,
 Y_YF_YMACC      <-> 0b101100,
 Y_YF_YNMACC     <-> 0b101101,
 Y_YF_YMSAC      <-> 0b101110,
 Y_YF_YNMSAC     <-> 0b101111
}

mapping clause encdec = Y_FYFMATYPE(funct6, ym, ys2, rs1, yd)
 <-> y_encdec_fyfmafunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ encdec_freg(rs1) @ 0b101 @ y_encdec_yreg(yd) @ 0b0101011
 when ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh))   & y_get_sew() == 16)
  | ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_F)) & y_get_sew() == 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 64)

function clause execute(Y_FYFMATYPE(funct6, ym, ys2, rs1, yd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_fp_normal(yd, ym, SEW, rm_3b)
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_reg_group(yd, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW != 8);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let rs1_val : bits('m) = y_get_scalar_fp(rs1, sizeof('m));
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);
  let yd_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = y_init_masked_result(
    num_elem,
    SEW,
    Y_LMUL_pow,
    yd_val,
    ym_val,
  );
  var result = initial_result;

  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    var result_view = y_shape(result, y_columns, y_depth);
    let yd_val_view = y_shape(yd_val, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(yd_val_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        result_view[i][j][k] = match funct6 {
          Y_YF_YMACC  => y_fp_muladd(rm_3b, rs1_val, ys2_val_view[i][j][k], yd_val_view[i][j][k]),
          Y_YF_YNMACC => y_fp_nmulsub(rm_3b, rs1_val, ys2_val_view[i][j][k], yd_val_view[i][j][k]),
          Y_YF_YMSAC  => y_fp_mulsub(rm_3b, rs1_val, ys2_val_view[i][j][k], yd_val_view[i][j][k]),
          Y_YF_YNMSAC => y_fp_nmuladd(rm_3b, rs1_val, ys2_val_view[i][j][k], yd_val_view[i][j][k]),
          Y_YF_YMADD  => y_fp_muladd(rm_3b, rs1_val, yd_val_view[i][j][k], ys2_val_view[i][j][k]),
          Y_YF_YNMADD => y_fp_nmulsub(rm_3b, rs1_val, yd_val_view[i][j][k], ys2_val_view[i][j][k]),
          Y_YF_YMSUB  => y_fp_mulsub(rm_3b, rs1_val, yd_val_view[i][j][k], ys2_val_view[i][j][k]),
          Y_YF_YNMSUB => y_fp_nmuladd(rm_3b, rs1_val, yd_val_view[i][j][k], ys2_val_view[i][j][k]),
        }
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW, Y_LMUL_pow, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_fyfmatype_mnemonic : y_fyfmafunct6 <-> string = {
 Y_YF_YMADD      <-> "yfmadd.yf",
 Y_YF_YNMADD     <-> "yfnmadd.yf",
 Y_YF_YMSUB      <-> "yfmsub.yf",
 Y_YF_YNMSUB     <-> "yfnmsub.yf",
 Y_YF_YMACC      <-> "yfmacc.yf",
 Y_YF_YNMACC     <-> "yfnmacc.yf",
 Y_YF_YMSAC      <-> "yfmsac.yf",
 Y_YF_YNMSAC     <-> "yfnmsac.yf"
}

mapping clause assembly = Y_FYFMATYPE(funct6, ym, ys2, rs1, yd)
 <-> y_fyfmatype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ freg_name(rs1) ^ sep() ^ y_yreg_name(ys2) ^ y_maybe_ymask(ym)

// ************************** OPFVF (YFTYPE Widening) ***************************
union clause instruction = Y_FWIDE_YFTYPE : (y_fwide_yffunct6, bits(1), yregidx, fregidx, yregidx)

mapping y_encdec_fwide_yffunct6 : y_fwide_yffunct6 <-> bits(6) = {
 Y_FWIDE_YF_YADD       <-> 0b110000,
 Y_FWIDE_YF_YSUB       <-> 0b110010,
 Y_FWIDE_YF_YMUL       <-> 0b111000
}

mapping clause encdec = Y_FWIDE_YFTYPE(funct6, ym, ys2, rs1, yd)
 <-> y_encdec_fwide_yffunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ encdec_freg(rs1) @ 0b101 @ y_encdec_yreg(yd) @ 0b0101011
 when ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh))   & y_get_sew() == 16)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 32)

function clause execute(Y_FWIDE_YFTYPE(funct6, ym, ys2, rs1, yd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = Y_LMUL_pow + 1;

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_fp_variable_width(yd, ym, SEW, rm_3b, SEW_widen, LMUL_pow_widen)
   | not(y_valid_reg_overlap(ys2, yd, Y_LMUL_pow, LMUL_pow_widen))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW >= 16 & SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let yd_val : vector('n, bits('o)) = y_read_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd);
  let rs1_val : bits('m) = y_get_scalar_fp(rs1, sizeof('m));
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);

  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = y_init_masked_result(
    num_elem,
    SEW_widen,
    LMUL_pow_widen,
    yd_val,
    ym_val,
  );
  var result = initial_result;

  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    var result_view = y_shape(result, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        result_view[i][j][k] = match funct6 {
          Y_FWIDE_YF_YADD => y_fp_add(rm_3b, y_fp_widen(ys2_val_view[i][j][k]), y_fp_widen(rs1_val)),
          Y_FWIDE_YF_YSUB => y_fp_sub(rm_3b, y_fp_widen(ys2_val_view[i][j][k]), y_fp_widen(rs1_val)),
          Y_FWIDE_YF_YMUL => y_fp_mul(rm_3b, y_fp_widen(ys2_val_view[i][j][k]), y_fp_widen(rs1_val)),
        }
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_fwide_yftype_mnemonic : y_fwide_yffunct6 <-> string = {
 Y_FWIDE_YF_YADD       <-> "yfwadd.yf",
 Y_FWIDE_YF_YSUB       <-> "yfwsub.yf",
 Y_FWIDE_YF_YMUL       <-> "yfwmul.yf"
}

mapping clause assembly = Y_FWIDE_YFTYPE(funct6, ym, ys2, rs1, yd)
 <-> y_fwide_yftype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ freg_name(rs1) ^ y_maybe_ymask(ym)

// ******************* OPFVF (yftype Widening Multiply-Add) *********************
// Multiply-Add instructions switch the order of source operands in assembly (ys1/rs1 before ys2)
union clause instruction = Y_FWIDE_YFMATYPE : (y_fwide_yfmafunct6, bits(1), fregidx, yregidx, yregidx)

mapping y_encdec_fwide_yfmafunct6 : y_fwide_yfmafunct6 <-> bits(6) = {
 Y_FWIDE_YF_YMACC      <-> 0b111100,
 Y_FWIDE_YF_YNMACC     <-> 0b111101,
 Y_FWIDE_YF_YMSAC      <-> 0b111110,
 Y_FWIDE_YF_YNMSAC     <-> 0b111111
}

mapping clause encdec = Y_FWIDE_YFMATYPE(funct6, ym, rs1, ys2, yd)
 <-> y_encdec_fwide_yfmafunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ encdec_freg(rs1) @ 0b101 @ y_encdec_yreg(yd) @ 0b0101011
 when ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh))   & y_get_sew() == 16)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 32)

function clause execute(Y_FWIDE_YFMATYPE(funct6, ym, rs1, ys2, yd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = Y_LMUL_pow + 1;

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_fp_variable_width(yd, ym, SEW, rm_3b, SEW_widen, LMUL_pow_widen)
   | not(y_valid_reg_overlap(ys2, yd, Y_LMUL_pow, LMUL_pow_widen))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW >= 16 & SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let yd_val : vector('n, bits('o)) = y_read_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd);
  let rs1_val : bits('m) = y_get_scalar_fp(rs1, sizeof('m));
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);

  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = y_init_masked_result(
    num_elem,
    SEW_widen,
    LMUL_pow_widen,
    yd_val,
    ym_val,
  );
  var result = initial_result;

  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    var result_view = y_shape(result, y_columns, y_depth);
    let yd_val_view = y_shape(yd_val, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(yd_val_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        result_view[i][j][k] = match funct6 {
          Y_FWIDE_YF_YMACC  => y_fp_muladd(
            rm_3b,
            y_fp_widen(rs1_val),
            y_fp_widen(ys2_val_view[i][j][k]),
            yd_val_view[i][j][k],
          ),
          Y_FWIDE_YF_YNMACC => y_fp_nmulsub(
            rm_3b,
            y_fp_widen(rs1_val),
            y_fp_widen(ys2_val_view[i][j][k]),
            yd_val_view[i][j][k],
          ),
          Y_FWIDE_YF_YMSAC  => y_fp_mulsub(
            rm_3b,
            y_fp_widen(rs1_val),
            y_fp_widen(ys2_val_view[i][j][k]),
            yd_val_view[i][j][k],
          ),
          Y_FWIDE_YF_YNMSAC => y_fp_nmuladd(
            rm_3b,
            y_fp_widen(rs1_val),
            y_fp_widen(ys2_val_view[i][j][k]),
            yd_val_view[i][j][k],
          ),
        }
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_fwide_yfmatype_mnemonic : y_fwide_yfmafunct6 <-> string = {
 Y_FWIDE_YF_YMACC      <-> "yfwmacc.yf",
 Y_FWIDE_YF_YNMACC     <-> "yfwnmacc.yf",
 Y_FWIDE_YF_YMSAC      <-> "yfwmsac.yf",
 Y_FWIDE_YF_YNMSAC     <-> "yfwnmsac.yf"
}

mapping clause assembly = Y_FWIDE_YFMATYPE(funct6, ym, rs1, ys2, yd)
 <-> y_fwide_yfmatype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ freg_name(rs1) ^ sep() ^ y_yreg_name(ys2) ^ y_maybe_ymask(ym)

// ************************** OPFVF (WFTYPE Widening) ***************************
union clause instruction = Y_FWIDE_FTYPE : (y_fwide_ffunct6, bits(1), yregidx, fregidx, yregidx)

mapping y_encdec_fwide_ffunct6 : y_fwide_ffunct6 <-> bits(6) = {
 Y_FWIDE_F_YADD       <-> 0b110100,
 Y_FWIDE_F_YSUB       <-> 0b110110
}

mapping clause encdec = Y_FWIDE_FTYPE(funct6, ym, ys2, rs1, yd)
 <-> y_encdec_fwide_ffunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ encdec_freg(rs1) @ 0b101 @ y_encdec_yreg(yd) @ 0b0101011
 when ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh))   & y_get_sew() == 16)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 32)

function clause execute(Y_FWIDE_FTYPE(funct6, ym, ys2, rs1, yd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = Y_LMUL_pow + 1;

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_fp_variable_width(yd, ym, SEW, rm_3b, SEW_widen, LMUL_pow_widen)
   | not(y_valid_reg_group(ys2, LMUL_pow_widen))
   | not(y_valid_reg_group(yd, LMUL_pow_widen))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW_widen)) then {
    return Illegal_Instruction()
  };

  assert(SEW >= 16 & SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let yd_val : vector('n, bits('o)) = y_read_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd);
  let rs1_val : bits('m) = y_get_scalar_fp(rs1, sizeof('m));
  let ys2_val : vector('n, bits('o)) = y_read_yreg(num_elem, SEW_widen, LMUL_pow_widen, ys2);

  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = y_init_masked_result(
    num_elem,
    SEW_widen,
    LMUL_pow_widen,
    yd_val,
    ym_val,
  );
  var result = initial_result;

  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    var result_view = y_shape(result, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        result_view[i][j][k] = match funct6 {
          Y_FWIDE_F_YADD => y_fp_add(rm_3b, ys2_val_view[i][j][k], y_fp_widen(rs1_val)),
          Y_FWIDE_F_YSUB => y_fp_sub(rm_3b, ys2_val_view[i][j][k], y_fp_widen(rs1_val)),
        }
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_fwide_ftype_mnemonic : y_fwide_ffunct6 <-> string = {
 Y_FWIDE_F_YADD       <-> "yfwadd.wide.yf",
 Y_FWIDE_F_YSUB       <-> "yfwsub.wide.yf"
}

mapping clause assembly = Y_FWIDE_FTYPE(funct6, ym, ys2, rs1, yd)
 <-> y_fwide_ftype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ freg_name(rs1) ^ y_maybe_ymask(ym)

// ************************* OPFVF (Merge Instruction) **************************
// This instruction operates on all body elements regardless of mask value
union clause instruction = Y_YFMERGE : (yregidx, fregidx, yregidx)

mapping clause encdec = Y_YFMERGE(ys2, rs1, yd)
 <-> 0b010111 @ 0b0 @ y_encdec_yreg(ys2) @ encdec_freg(rs1) @ 0b101 @ y_encdec_yreg(yd) @ 0b0101011
 when ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh))   & y_get_sew() == 16)
  | ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_F)) & y_get_sew() == 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 64)

function clause execute(Y_YFMERGE(ys2, rs1, yd)) = {
  let rm_3b = fcsr[FRM];
  let start_element = y_get_start_element();
  let end_element = y_get_end_element();
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW); // max(YLMAX,YLEN/SEW))
  let real_num_elem = if Y_LMUL_pow >= 0 then {
      num_elem
    } else {
      num_elem / (0 - Y_LMUL_pow)
    }; // YLMAX

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_fp_yd_masked(yd, SEW, rm_3b)
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_reg_group(yd, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(0b0, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW != 8);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem, 0b0, y_zyreg);
  let rs1_val : bits('m) = y_get_scalar_fp(rs1, sizeof('m));
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);
  let yd_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, yd);
  var result : vector('n, bits('m)) = vector_init(zeros());

  let tail_ag : y_agtype = y_get_ytype_yta();
  {
    var result_view = y_shape(result, y_columns, y_depth);
    let yd_val_view = y_shape(yd_val, y_columns, y_depth);
    let ym_val_view = y_shape(ym_val, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(result_view));
      assert(i < length(yd_val_view));
      assert(i < length(ym_val_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if p < start_element then {
        result_view[i][j][k] = yd_val_view[i][j][k]
      } else {
        if p > end_element | p >= real_num_elem then {
          result_view[i][j][k] = match tail_ag {
            Y_UNDISTURBED => yd_val_view[i][j][k],
            Y_AGNOSTIC    => yd_val_view[i][j][k], // TODO: configuration support
          }
        } else {
          // the merge operates on all body elements
          result_view[i][j][k] =
            if ym_val_view[i][j][k] == 0b1 then {
              rs1_val
            } else {
              ys2_val_view[i][j][k]
            }
        }
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW, Y_LMUL_pow, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = Y_YFMERGE(ys2, rs1, yd)
 <-> "yfmerge.yfm" ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ freg_name(rs1) ^ sep() ^ "y0"

// ************************* OPFVF (Move Instruction) ***************************
// This instruction shares the encoding with vfmerge.vfm, but with ym=1 and ys2=v0
union clause instruction = Y_YFMV : (fregidx, yregidx)

mapping clause encdec = Y_YFMV(rs1, yd)
 <-> 0b010111 @ 0b1 @ 0b00000 @ encdec_freg(rs1) @ 0b101 @ y_encdec_yreg(yd) @ 0b0101011
 when ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh))   & y_get_sew() == 16)
  | ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_F)) & y_get_sew() == 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 64)

function clause execute(Y_YFMV(rs1, yd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_fp_yd_unmasked(SEW, rm_3b)
   | not(y_valid_reg_group(yd, Y_LMUL_pow)) then {
    return Illegal_Instruction()
  };

  assert(SEW != 8);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let rs1_val : bits('m) = y_get_scalar_fp(rs1, sizeof('m));
  let yd_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = y_init_masked_result(
    num_elem,
    SEW,
    Y_LMUL_pow,
    yd_val,
    ones(),
  );
  var result = initial_result;

  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    var result_view = y_shape(result, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        result_view[i][j][k] = rs1_val
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW, Y_LMUL_pow, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = Y_YFMV(rs1, yd)
 <-> "yfmv.y.f" ^ spc() ^ y_yreg_name(yd) ^ sep() ^ freg_name(rs1)

// ***************************** OPFVF (YRFUNARY0) ******************************
union clause instruction = Y_YFMVSF : (fregidx, yregidx)

mapping clause encdec = Y_YFMVSF(rs1, yd)
 <-> 0b010000 @ 0b1 @ 0b00000 @ encdec_freg(rs1) @ 0b101 @ y_encdec_yreg(yd) @ 0b0101011
 when ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh))   & y_get_sew() == 16)
  | ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_F)) & y_get_sew() == 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 64)

function clause execute(Y_YFMVSF(rs1, yd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = y_get_sew();
  let num_elem = y_get_num_elem(0, SEW);

  // See YMVXS for LMUL usage here
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem_ystart = y_get_num_elem(Y_LMUL_pow, SEW);

  if y_illegal_ystart(Y_YSTART_SCALAR_MOVE, num_elem_ystart, Y_LMUL_pow) | y_illegal_fp_yd_unmasked(SEW, rm_3b) then {
    return Illegal_Instruction()
  };

  assert(num_elem > 0 & SEW != 8);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let rs1_val : bits('m) = y_get_scalar_fp(rs1, sizeof('m));
  let yd_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, 0, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = y_init_masked_result(
    num_elem,
    SEW,
    0,
    yd_val,
    ones(),
  );
  var result = initial_result;

  // one body element
  if y_shape(mask, y_columns, y_depth)[0][0][0] == 0b1 then {
    var origin_view = y_shape(result, y_columns, y_depth);
    origin_view[0][0][0] = rs1_val;
    result = y_unshape_vector(length(result), origin_view, y_columns, y_depth)
  };

  // others treated as tail elements
  let tail_ag : y_agtype = y_get_ytype_yta();
  {
    var result_view = y_shape(result, y_columns, y_depth);
    let yd_val_view = y_shape(yd_val, y_columns, y_depth);
    foreach (p from 1 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(result_view));
      assert(i < length(yd_val_view));
      assert(j < y_columns & k < y_depth);

      result_view[i][j][k] = match tail_ag {
        Y_UNDISTURBED => yd_val_view[i][j][k],
        Y_AGNOSTIC    => yd_val_view[i][j][k], // TODO: configuration support
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW, 0, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = Y_YFMVSF(rs1, yd)
 <-> "yfmv.s.f" ^ spc() ^ y_yreg_name(yd) ^ sep() ^ freg_name(rs1)
