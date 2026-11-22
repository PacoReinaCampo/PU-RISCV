// =======================================================================================
// This Sail RISC-Y architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

// ******************************************************************************
// This file implements part of the tensor extension.
// Mask instructions from Chap 11 (integer arithmetic)
// ******************************************************************************

// ****************************** OPIVV (YYMTYPE) *******************************
// YYM instructions' destination is a mask register (e.g. carry out)
// Instructions with no carry out will set mask result to current mask value
// May or may not read from source mask register (e.g. carry in)
union clause instruction = Y_YYMTYPE : (y_yymfunct6, yregidx, yregidx, yregidx)

mapping y_encdec_yymfunct6 : y_yymfunct6 <-> bits(6) = {
 Y_YYM_YMADC    <-> 0b010001, // carry in, carry out
 Y_YYM_YMSBC    <-> 0b010011
}

mapping clause encdec = Y_YYMTYPE(funct6, ys2, ys1, yd)
 <-> y_encdec_yymfunct6(funct6) @ 0b0 @ y_encdec_yreg(ys2) @ y_encdec_yreg(ys1) @ 0b000 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YYMTYPE(funct6, ys2, ys1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_yd_unmasked()
   | not(y_valid_reg_group(ys1, Y_LMUL_pow))
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(0b0, ys1, SEW))
   | not(y_valid_ym_src_overlap(0b0, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask_carry(num_elem, 0b0, y_zyreg);
  let ys1_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys1);
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);
  let yd_val : bits('n) = y_read_ymask(num_elem, 0b0, yd);

  let (initial_result, mask) : (bits('n), bits('n)) = y_init_masked_result_carry(num_elem, SEW, Y_LMUL_pow, yd_val);
  var result = initial_result;

  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    var result_view = y_shape(result, y_columns, y_depth);
    let ym_val_view = y_shape(ym_val, y_columns, y_depth);
    let ys1_val_view = y_shape(ys1_val, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ym_val_view));
      assert(i < length(ys1_val_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        let res : bool = match funct6 {
          Y_YYM_YMADC =>   unsigned(ys2_val_view[i][j][k])
                 + unsigned(ys1_val_view[i][j][k])
                 + (if ym_val_view[i][j][k] == 0b1 then 1 else 0)
                 > 2 ^ SEW
                 - 1,
          Y_YYM_YMSBC =>   unsigned(ys2_val_view[i][j][k])
                 - unsigned(ys1_val_view[i][j][k])
                 - (if ym_val_view[i][j][k] == 0b1 then 1 else 0)
                 < 0,
        };
        result_view[i][j][k] = bool_to_bit(res)
      }
    };
    result = y_unshape_bits(length(result), result_view, y_columns, y_depth)
  };

  y_write_ymask(num_elem, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_yymtype_mnemonic : y_yymfunct6 <-> string = {
 Y_YYM_YMADC    <-> "ymadc.yym", // carry in, carry out
 Y_YYM_YMSBC    <-> "ymsbc.yym"
}

mapping clause assembly = Y_YYMTYPE(funct6, ys2, ys1, yd)
 <-> y_yymtype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ y_yreg_name(ys1) ^ sep() ^ "y0"

// ***************************** OPIVV (YYMCTYPE) *******************************
// YYMC instructions' destination is a mask register (e.g. carry out)
// Instructions with no carry out will set mask result to current mask value
// May or may not read from source mask register (e.g. carry in)
union clause instruction = Y_YYMCTYPE : (y_yymcfunct6, yregidx, yregidx, yregidx)

mapping y_encdec_yymcfunct6 : y_yymcfunct6 <-> bits(6) = {
 Y_YYMC_YMADC    <-> 0b010001, // no carry in, carry out
 Y_YYMC_YMSBC    <-> 0b010011
}

mapping clause encdec = Y_YYMCTYPE(funct6, ys2, ys1, yd)
 <-> y_encdec_yymcfunct6(funct6) @ 0b1 @ y_encdec_yreg(ys2) @ y_encdec_yreg(ys1) @ 0b000 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YYMCTYPE(funct6, ys2, ys1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_yd_unmasked()
   | not(y_valid_reg_group(ys1, Y_LMUL_pow))
   | not(y_valid_reg_group(ys2, Y_LMUL_pow)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ys1_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys1);
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);
  let yd_val : bits('n) = y_read_ymask(num_elem, 0b0, yd);

  let (initial_result, mask) : (bits('n), bits('n)) = y_init_masked_result_carry(num_elem, SEW, Y_LMUL_pow, yd_val);
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
        let res : bool = match funct6 {
          Y_YYMC_YMADC => unsigned(ys2_val_view[i][j][k]) + unsigned(ys1_val_view[i][j][k]) > 2 ^ SEW - 1,
          Y_YYMC_YMSBC => unsigned(ys2_val_view[i][j][k]) - unsigned(ys1_val_view[i][j][k]) < 0,
        };
        result_view[i][j][k] = bool_to_bit(res)
      }
    };
    result = y_unshape_bits(length(result), result_view, y_columns, y_depth)
  };

  y_write_ymask(num_elem, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_yymctype_mnemonic : y_yymcfunct6 <-> string = {
 Y_YYMC_YMADC    <-> "ymadc.yy", // no carry in, carry out
 Y_YYMC_YMSBC    <-> "ymsbc.yy"
}

mapping clause assembly = Y_YYMCTYPE(funct6, ys2, ys1, yd)
 <-> y_yymctype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ y_yreg_name(ys1)

// ***************************** OPIVV (YYMSTYPE) *******************************
// YYMS instructions' destination is a tensor register (e.g. actual sum)
// Instructions with no carry out will set mask result to current mask value
// May or may not read from source mask register (e.g. carry in)
union clause instruction = Y_YYMSTYPE : (y_yymsfunct6, yregidx, yregidx, yregidx)

mapping y_encdec_yymsfunct6 : y_yymsfunct6 <-> bits(6) = {
 Y_YYMS_YADC     <-> 0b010000, // carry in, no carry out
 Y_YYMS_YSBC     <-> 0b010010
}

mapping clause encdec = Y_YYMSTYPE(funct6, ys2, ys1, yd)
 <-> y_encdec_yymsfunct6(funct6) @ 0b0 @ y_encdec_yreg(ys2) @ y_encdec_yreg(ys1) @ 0b000 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YYMSTYPE(funct6, ys2, ys1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_yd_masked(yd)
   | not(y_valid_reg_group(ys1, Y_LMUL_pow))
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_reg_group(yd, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(0b0, ys1, SEW))
   | not(y_valid_ym_src_overlap(0b0, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  // for bypassing normal masking in init_masked_result
  let vec_trues : bits('n) = ones();

  let ym_val : bits('n) = y_read_ymask_carry(num_elem, 0b0, y_zyreg);
  let ys1_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys1);
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);
  let yd_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = y_init_masked_result(
    num_elem,
    SEW,
    Y_LMUL_pow,
    yd_val,
    vec_trues,
  );
  var result = initial_result;

  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    var result_view = y_shape(result, y_columns, y_depth);
    let ym_val_view = y_shape(ym_val, y_columns, y_depth);
    let ys1_val_view = y_shape(ys1_val, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ym_val_view));
      assert(i < length(ys1_val_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        result_view[i][j][k] = match funct6 {
          Y_YYMS_YADC => to_bits_unsafe(
            SEW,
             unsigned(ys2_val_view[i][j][k])
            + unsigned(ys1_val_view[i][j][k])
            + (if ym_val_view[i][j][k] == 0b1 then 1 else 0),
          ),
          Y_YYMS_YSBC => to_bits_unsafe(
            SEW,
             unsigned(ys2_val_view[i][j][k])
            - unsigned(ys1_val_view[i][j][k])
            - (if ym_val_view[i][j][k] == 0b1 then 1 else 0),
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

mapping y_yymstype_mnemonic : y_yymsfunct6 <-> string = {
 Y_YYMS_YADC     <-> "yadc.yym", // carry in, no carry out
 Y_YYMS_YSBC     <-> "ysbc.yym"
}

mapping clause assembly = Y_YYMSTYPE(funct6, ys2, ys1, yd)
 <-> y_yymstype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ y_yreg_name(ys1) ^ sep() ^ "y0"

// **************** OPIVV (Tensor Integer Compare Instructions) *****************
// YYCMP instructions' destination is a mask register
union clause instruction = Y_YYCMPTYPE : (y_yycmpfunct6, bits(1), yregidx, yregidx, yregidx)

mapping y_encdec_yycmpfunct6 : y_yycmpfunct6 <-> bits(6) = {
 Y_YYCMP_YMSEQ    <-> 0b011000,
 Y_YYCMP_YMSNE    <-> 0b011001,
 Y_YYCMP_YMSLTU   <-> 0b011010,
 Y_YYCMP_YMSLT    <-> 0b011011,
 Y_YYCMP_YMSLEU   <-> 0b011100,
 Y_YYCMP_YMSLE    <-> 0b011101
}

mapping clause encdec = Y_YYCMPTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_encdec_yycmpfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ y_encdec_yreg(ys1) @ 0b000 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YYCMPTYPE(funct6, ym, ys2, ys1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_yd_unmasked()
   | not(y_valid_reg_group(ys1, Y_LMUL_pow))
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys1, SEW))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let ys1_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys1);
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);
  let yd_val : bits('n) = y_read_ymask(num_elem, 0b0, yd);

  let (initial_result, mask) : (bits('n), bits('n)) = y_init_masked_result_cmp(
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
        let res : bool = match funct6 {
          Y_YYCMP_YMSEQ  => ys2_val_view[i][j][k] == ys1_val_view[i][j][k],
          Y_YYCMP_YMSNE  => ys2_val_view[i][j][k] != ys1_val_view[i][j][k],
          Y_YYCMP_YMSLTU => unsigned(ys2_val_view[i][j][k]) < unsigned(ys1_val_view[i][j][k]),
          Y_YYCMP_YMSLT  => signed(ys2_val_view[i][j][k]) < signed(ys1_val_view[i][j][k]),
          Y_YYCMP_YMSLEU => unsigned(ys2_val_view[i][j][k]) <= unsigned(ys1_val_view[i][j][k]),
          Y_YYCMP_YMSLE  => signed(ys2_val_view[i][j][k]) <= signed(ys1_val_view[i][j][k]),
        };
        result_view[i][j][k] = bool_to_bit(res)
      }
    };
    result = y_unshape_bits(length(result), result_view, y_columns, y_depth)
  };

  y_write_ymask(num_elem, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_yycmptype_mnemonic : y_yycmpfunct6 <-> string = {
 Y_YYCMP_YMSEQ    <-> "ymseq.yy",
 Y_YYCMP_YMSNE    <-> "ymsne.yy",
 Y_YYCMP_YMSLTU   <-> "ymsltu.yy",
 Y_YYCMP_YMSLT    <-> "ymslt.yy",
 Y_YYCMP_YMSLEU   <-> "ymsleu.yy",
 Y_YYCMP_YMSLE    <-> "ymsle.yy"
}

mapping clause assembly = Y_YYCMPTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_yycmptype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ y_yreg_name(ys1) ^ y_maybe_ymask(ym)

// ****************************** OPIVX (YXMTYPE) *******************************
// YXM instructions' destination is a mask register (e.g. carry out)
// Instructions with no carry out will set mask result to current mask value
// May or may not read from source mask register (e.g. carry in)
union clause instruction = Y_YXMTYPE : (y_yxmfunct6, yregidx, regidx, yregidx)

mapping y_encdec_yxmfunct6 : y_yxmfunct6 <-> bits(6) = {
 Y_YXM_YMADC    <-> 0b010001, // carry in, carry out
 Y_YXM_YMSBC    <-> 0b010011
}

mapping clause encdec = Y_YXMTYPE(funct6, ys2, rs1, yd)
 <-> y_encdec_yxmfunct6(funct6) @ 0b0 @ y_encdec_yreg(ys2) @ encdec_reg(rs1) @ 0b100 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YXMTYPE(funct6, ys2, rs1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_yd_unmasked()
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(0b0, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask_carry(num_elem, 0b0, y_zyreg);
  let rs1_val : bits('m) = y_get_scalar(rs1, SEW);
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);
  let yd_val : bits('n) = y_read_ymask(num_elem, 0b0, yd);

  let (initial_result, mask) : (bits('n), bits('n)) = y_init_masked_result_carry(num_elem, SEW, Y_LMUL_pow, yd_val);
  var result = initial_result;

  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    var result_view = y_shape(result, y_columns, y_depth);
    let ym_val_view = y_shape(ym_val, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ym_val_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        let res : bool = match funct6 {
          Y_YXM_YMADC =>   unsigned(ys2_val_view[i][j][k])
                 + unsigned(rs1_val)
                 + (if ym_val_view[i][j][k] == 0b1 then 1 else 0)
                 > 2 ^ SEW
                 - 1,
          Y_YXM_YMSBC =>   unsigned(ys2_val_view[i][j][k])
                 - unsigned(rs1_val)
                 - (if ym_val_view[i][j][k] == 0b1 then 1 else 0)
                 < 0,
        };
        result_view[i][j][k] = bool_to_bit(res)
      }
    };
    result = y_unshape_bits(length(result), result_view, y_columns, y_depth)
  };

  y_write_ymask(num_elem, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_yxmtype_mnemonic : y_yxmfunct6 <-> string = {
 Y_YXM_YMADC    <-> "ymadc.yxm", // carry in, carry out
 Y_YXM_YMSBC    <-> "ymsbc.yxm"
}

mapping clause assembly = Y_YXMTYPE(funct6, ys2, rs1, yd)
 <-> y_yxmtype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ reg_name(rs1) ^ sep() ^ "y0"

// ***************************** OPIVX (YXMCTYPE) *******************************
// YXMC instructions' destination is a mask register (e.g. carry out)
// Instructions with no carry out will set mask result to current mask value
// May or may not read from source mask register (e.g. carry in)
union clause instruction = Y_YXMCTYPE : (y_yxmcfunct6, yregidx, regidx, yregidx)

mapping y_encdec_yxmcfunct6 : y_yxmcfunct6 <-> bits(6) = {
 Y_YXMC_YMADC    <-> 0b010001, // carry in, carry out
 Y_YXMC_YMSBC    <-> 0b010011
}

mapping clause encdec = Y_YXMCTYPE(funct6, ys2, rs1, yd)
 <-> y_encdec_yxmcfunct6(funct6) @ 0b1 @ y_encdec_yreg(ys2) @ encdec_reg(rs1) @ 0b100 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YXMCTYPE(funct6, ys2, rs1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_yd_unmasked()
   | not(y_valid_reg_group(ys2, Y_LMUL_pow)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let rs1_val : bits('m) = y_get_scalar(rs1, SEW);
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);
  let yd_val : bits('n) = y_read_ymask(num_elem, 0b0, yd);

  let (initial_result, mask) : (bits('n), bits('n)) = y_init_masked_result_carry(num_elem, SEW, Y_LMUL_pow, yd_val);
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
        let res : bool = match funct6 {
          Y_YXMC_YMADC => unsigned(ys2_val_view[i][j][k]) + unsigned(rs1_val) > 2 ^ SEW - 1,
          Y_YXMC_YMSBC => unsigned(ys2_val_view[i][j][k]) - unsigned(rs1_val) < 0,
        };
        result_view[i][j][k] = bool_to_bit(res)
      }
    };
    result = y_unshape_bits(length(result), result_view, y_columns, y_depth)
  };

  y_write_ymask(num_elem, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_yxmctype_mnemonic : y_yxmcfunct6 <-> string = {
 Y_YXMC_YMADC    <-> "ymadc.yx", // carry in, carry out
 Y_YXMC_YMSBC    <-> "ymsbc.yx"
}

mapping clause assembly = Y_YXMCTYPE(funct6, ys2, rs1, yd)
 <-> y_yxmctype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ reg_name(rs1)

// ***************************** OPIVX (YXMSTYPE) *******************************
// YXMS instructions' destination is a tensor register (e.g. actual sum)
// Instructions with no carry out will set mask result to current mask value
// May or may not read from source mask register (e.g. carry in)
union clause instruction = Y_YXMSTYPE : (y_yxmsfunct6, yregidx, regidx, yregidx)

mapping y_encdec_yxmsfunct6 : y_yxmsfunct6 <-> bits(6) = {
 Y_YXMS_YADC     <-> 0b010000, // carry in, no carry out
 Y_YXMS_YSBC     <-> 0b010010
}

mapping clause encdec = Y_YXMSTYPE(funct6, ys2, rs1, yd)
 <-> y_encdec_yxmsfunct6(funct6) @ 0b0 @ y_encdec_yreg(ys2) @ encdec_reg(rs1) @ 0b100 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YXMSTYPE(funct6, ys2, rs1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_yd_masked(yd)
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_reg_group(yd, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(0b0, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  // for bypassing normal masking in init_masked_result
  let vec_trues : bits('n) = ones();

  let ym_val : bits('n) = y_read_ymask_carry(num_elem, 0b0, y_zyreg);
  let rs1_val : bits('m) = y_get_scalar(rs1, SEW);
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);
  let yd_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = y_init_masked_result(
    num_elem,
    SEW,
    Y_LMUL_pow,
    yd_val,
    vec_trues,
  );
  var result = initial_result;

  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    var result_view = y_shape(result, y_columns, y_depth);
    let ym_val_view = y_shape(ym_val, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ym_val_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        result_view[i][j][k] = match funct6 {
          Y_YXMS_YADC => to_bits_unsafe(
            SEW,
             unsigned(ys2_val_view[i][j][k])
            + unsigned(rs1_val)
            + (if ym_val_view[i][j][k] == 0b1 then 1 else 0),
          ),
          Y_YXMS_YSBC => to_bits_unsafe(
            SEW,
             unsigned(ys2_val_view[i][j][k])
            - unsigned(rs1_val)
            - (if ym_val_view[i][j][k] == 0b1 then 1 else 0),
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

mapping y_yxmstype_mnemonic : y_yxmsfunct6 <-> string = {
 Y_YXMS_YADC     <-> "yadc.yxm", // carry in, no carry out
 Y_YXMS_YSBC     <-> "ysbc.yxm"
}

mapping clause assembly = Y_YXMSTYPE(funct6, ys2, rs1, yd)
 <-> y_yxmstype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ reg_name(rs1) ^ sep() ^ "y0"

// **************** OPIVX (Tensor Integer Compare Instructions) *****************
// YXCMP instructions' destination is a mask register
union clause instruction = Y_YXCMPTYPE : (y_yxcmpfunct6, bits(1), yregidx, regidx, yregidx)

mapping y_encdec_yxcmpfunct6 : y_yxcmpfunct6 <-> bits(6) = {
 Y_YXCMP_YMSEQ    <-> 0b011000,
 Y_YXCMP_YMSNE    <-> 0b011001,
 Y_YXCMP_YMSLTU   <-> 0b011010,
 Y_YXCMP_YMSLT    <-> 0b011011,
 Y_YXCMP_YMSLEU   <-> 0b011100,
 Y_YXCMP_YMSLE    <-> 0b011101,
 Y_YXCMP_YMSGTU   <-> 0b011110,
 Y_YXCMP_YMSGT    <-> 0b011111
}

mapping clause encdec = Y_YXCMPTYPE(funct6, ym, ys2, rs1, yd)
 <-> y_encdec_yxcmpfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ encdec_reg(rs1) @ 0b100 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YXCMPTYPE(funct6, ym, ys2, rs1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_yd_unmasked()
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let rs1_val : bits('m) = y_get_scalar(rs1, SEW);
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);
  let yd_val : bits('n) = y_read_ymask(num_elem, 0b0, yd);

  let (initial_result, mask) : (bits('n), bits('n)) = y_init_masked_result_cmp(
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
        let res : bool = match funct6 {
          Y_YXCMP_YMSEQ  => ys2_val_view[i][j][k] == rs1_val,
          Y_YXCMP_YMSNE  => ys2_val_view[i][j][k] != rs1_val,
          Y_YXCMP_YMSLTU => unsigned(ys2_val_view[i][j][k]) < unsigned(rs1_val),
          Y_YXCMP_YMSLT  => signed(ys2_val_view[i][j][k]) < signed(rs1_val),
          Y_YXCMP_YMSLEU => unsigned(ys2_val_view[i][j][k]) <= unsigned(rs1_val),
          Y_YXCMP_YMSLE  => signed(ys2_val_view[i][j][k]) <= signed(rs1_val),
          Y_YXCMP_YMSGTU => unsigned(ys2_val_view[i][j][k]) > unsigned(rs1_val),
          Y_YXCMP_YMSGT  => signed(ys2_val_view[i][j][k]) > signed(rs1_val),
        };
        result_view[i][j][k] = bool_to_bit(res)
      }
    };
    result = y_unshape_bits(length(result), result_view, y_columns, y_depth)
  };

  y_write_ymask(num_elem, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_yxcmptype_mnemonic : y_yxcmpfunct6 <-> string = {
 Y_YXCMP_YMSEQ    <-> "ymseq.yx",
 Y_YXCMP_YMSNE    <-> "ymsne.yx",
 Y_YXCMP_YMSLTU   <-> "ymsltu.yx",
 Y_YXCMP_YMSLT    <-> "ymslt.yx",
 Y_YXCMP_YMSLEU   <-> "ymsleu.yx",
 Y_YXCMP_YMSLE    <-> "ymsle.yx",
 Y_YXCMP_YMSGTU   <-> "ymsgtu.yx",
 Y_YXCMP_YMSGT    <-> "ymsgt.yx"
}

mapping clause assembly = Y_YXCMPTYPE(funct6, ym, ys2, rs1, yd)
 <-> y_yxcmptype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ reg_name(rs1) ^ y_maybe_ymask(ym)

// ****************************** OPIVI (YIMTYPE) *******************************
// YIM instructions' destination is a mask register (e.g. carry out)
// Instructions with no carry out will set mask result to current mask value
// May or may not read from source mask register (e.g. carry in)
union clause instruction = Y_YIMTYPE : (y_yimfunct6, yregidx, bits(5), yregidx)

mapping y_encdec_yimfunct6 : y_yimfunct6 <-> bits(6) = {
 Y_YIM_YMADC    <-> 0b010001 // carry in, carry out
}

mapping clause encdec = Y_YIMTYPE(funct6, ys2, simm, yd)
 <-> y_encdec_yimfunct6(funct6) @ 0b0 @ y_encdec_yreg(ys2) @ simm @ 0b011 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YIMTYPE(funct6, ys2, simm, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_yd_unmasked()
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(0b0, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask_carry(num_elem, 0b0, y_zyreg);
  let imm_val : bits('m) = sign_extend(simm);
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);
  let yd_val : bits('n) = y_read_ymask(num_elem, 0b0, yd);

  let (initial_result, mask) : (bits('n), bits('n)) = y_init_masked_result_carry(num_elem, SEW, Y_LMUL_pow, yd_val);
  var result = initial_result;

  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    var result_view = y_shape(result, y_columns, y_depth);
    let ym_val_view = y_shape(ym_val, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ym_val_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        let res : bool = match funct6 {
          Y_YIM_YMADC =>   unsigned(ys2_val_view[i][j][k])
                 + unsigned(imm_val)
                 + (if ym_val_view[i][j][k] == 0b1 then 1 else 0)
                 > 2 ^ SEW
                 - 1,
        };
        result_view[i][j][k] = bool_to_bit(res)
      }
    };
    result = y_unshape_bits(length(result), result_view, y_columns, y_depth)
  };

  y_write_ymask(num_elem, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_yimtype_mnemonic : y_yimfunct6 <-> string = {
 Y_YIM_YMADC    <-> "ymadc.yim" // carry in, carry out
}

mapping clause assembly = Y_YIMTYPE(funct6, ys2, simm, yd)
 <-> y_yimtype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ hex_bits_signed_5(simm) ^ sep() ^ "y0"

// ***************************** OPIVI (YIMCTYPE) *******************************
// YIMC instructions' destination is a mask register (e.g. carry out)
// Instructions with no carry out will set mask result to current mask value
// May or may not read from source mask register (e.g. carry in)
union clause instruction = Y_YIMCTYPE : (y_yimcfunct6, yregidx, bits(5), yregidx)

mapping y_encdec_yimcfunct6 : y_yimcfunct6 <-> bits(6) = {
 Y_YIMC_YMADC    <-> 0b010001 // carry in, carry out
}

mapping clause encdec = Y_YIMCTYPE(funct6, ys2, simm, yd)
 <-> y_encdec_yimcfunct6(funct6) @ 0b1 @ y_encdec_yreg(ys2) @ simm @ 0b011 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YIMCTYPE(funct6, ys2, simm, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_yd_unmasked()
   | not(y_valid_reg_group(ys2, Y_LMUL_pow)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let imm_val : bits('m) = sign_extend(simm);
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);
  let yd_val : bits('n) = y_read_ymask(num_elem, 0b0, yd);

  let (initial_result, mask) : (bits('n), bits('n)) = y_init_masked_result_carry(num_elem, SEW, Y_LMUL_pow, yd_val);
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
        let res : bool = match funct6 {
          Y_YIMC_YMADC => unsigned(ys2_val_view[i][j][k]) + unsigned(imm_val) > 2 ^ SEW - 1,
        };
        result_view[i][j][k] = bool_to_bit(res)
      }
    };
    result = y_unshape_bits(length(result), result_view, y_columns, y_depth)
  };

  y_write_ymask(num_elem, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_yimctype_mnemonic : y_yimcfunct6 <-> string = {
 Y_YIMC_YMADC    <-> "ymadc.yi" // Carry in, carry out
}

mapping clause assembly = Y_YIMCTYPE(funct6, ys2, simm, yd)
 <-> y_yimctype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ hex_bits_signed_5(simm)

// ***************************** OPIVI (YIMSTYPE) *******************************
// YIMS instructions' destination is a tensor register (e.g. actual sum)
// Instructions with no carry out will set mask result to current mask value
// May or may not read from source mask register (e.g. carry in)
union clause instruction = Y_YIMSTYPE : (y_yimsfunct6, yregidx, bits(5), yregidx)

mapping y_encdec_yimsfunct6 : y_yimsfunct6 <-> bits(6) = {
 Y_YIMS_YADC     <-> 0b010000 // Carry in, no carry out
}

mapping clause encdec = Y_YIMSTYPE(funct6, ys2, simm, yd)
 <-> y_encdec_yimsfunct6(funct6) @ 0b0 @ y_encdec_yreg(ys2) @ simm @ 0b011 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YIMSTYPE(funct6, ys2, simm, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_yd_masked(yd)
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_reg_group(yd, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(0b0, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  // for bypassing normal masking in init_masked_result
  let vec_trues : bits('n) = ones();

  let ym_val : bits('n) = y_read_ymask_carry(num_elem, 0b0, y_zyreg);
  let imm_val : bits('m) = sign_extend(simm);
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);
  let yd_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = y_init_masked_result(
    num_elem,
    SEW,
    Y_LMUL_pow,
    yd_val,
    vec_trues,
  );
  var result = initial_result;

  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    var result_view = y_shape(result, y_columns, y_depth);
    let ym_val_view = y_shape(ym_val, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ym_val_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        result_view[i][j][k] = match funct6 {
          Y_YIMS_YADC => to_bits_unsafe(
            SEW,
             unsigned(ys2_val_view[i][j][k])
            + unsigned(imm_val)
            + (if ym_val_view[i][j][k] == 0b1 then 1 else 0),
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

mapping y_yimstype_mnemonic : y_yimsfunct6 <-> string = {
 Y_YIMS_YADC     <-> "yadc.yim" // Carry in, no carry out
}

mapping clause assembly = Y_YIMSTYPE(funct6, ys2, simm, yd)
 <-> y_yimstype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ hex_bits_signed_5(simm) ^ sep() ^ "y0"

// **************** OPIVI (Tensor Integer Compare Instructions) *****************
// YICMP instructions' destination is a mask register
union clause instruction = Y_YICMPTYPE : (y_yicmpfunct6, bits(1), yregidx, bits(5), yregidx)

mapping y_encdec_yicmpfunct6 : y_yicmpfunct6 <-> bits(6) = {
 Y_YICMP_YMSEQ    <-> 0b011000,
 Y_YICMP_YMSNE    <-> 0b011001,
 Y_YICMP_YMSLEU   <-> 0b011100,
 Y_YICMP_YMSLE    <-> 0b011101,
 Y_YICMP_YMSGTU   <-> 0b011110,
 Y_YICMP_YMSGT    <-> 0b011111
}

mapping clause encdec = Y_YICMPTYPE(funct6, ym, ys2, simm, yd)
 <-> y_encdec_yicmpfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ simm @ 0b011 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YICMPTYPE(funct6, ym, ys2, simm, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_yd_unmasked()
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let imm_val : bits('m) = sign_extend(simm);
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);
  let yd_val : bits('n) = y_read_ymask(num_elem, 0b0, yd);

  let (initial_result, mask) : (bits('n), bits('n)) = y_init_masked_result_cmp(
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
        let res : bool = match funct6 {
          Y_YICMP_YMSEQ  => ys2_val_view[i][j][k] == imm_val,
          Y_YICMP_YMSNE  => ys2_val_view[i][j][k] != imm_val,
          Y_YICMP_YMSLEU => unsigned(ys2_val_view[i][j][k]) <= unsigned(imm_val),
          Y_YICMP_YMSLE  => signed(ys2_val_view[i][j][k]) <= signed(imm_val),
          Y_YICMP_YMSGTU => unsigned(ys2_val_view[i][j][k]) > unsigned(imm_val),
          Y_YICMP_YMSGT  => signed(ys2_val_view[i][j][k]) > signed(imm_val),
        };
        result_view[i][j][k] = bool_to_bit(res)
      }
    };
    result = y_unshape_bits(length(result), result_view, y_columns, y_depth)
  };

  y_write_ymask(num_elem, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_yicmptype_mnemonic : y_yicmpfunct6 <-> string = {
 Y_YICMP_YMSEQ    <-> "ymseq.yi",
 Y_YICMP_YMSNE    <-> "ymsne.yi",
 Y_YICMP_YMSLEU   <-> "ymsleu.yi",
 Y_YICMP_YMSLE    <-> "ymsle.yi",
 Y_YICMP_YMSGTU   <-> "ymsgtu.yi",
 Y_YICMP_YMSGT    <-> "ymsgt.yi"
}

mapping clause assembly = Y_YICMPTYPE(funct6, ym, ys2, simm, yd)
 <-> y_yicmptype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ hex_bits_signed_5(simm) ^ y_maybe_ymask(ym)
