// =======================================================================================
// This Sail RISC-Y architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

// ******************************************************************************
// This file implements part of the tensor extension.
// Chapter 11: Tensor Integer Arithmetic Instructions
// Chapter 12: Tensor Fixed-Point Arithmetic Instructions
// Chapter 16: Tensor Permutation Instructions (integer part)
// ******************************************************************************

// ****************************** OPIVV (YYTYPE) ********************************
union clause instruction = Y_YYTYPE : (y_yyfunct6, bits(1), yregidx, yregidx, yregidx)

mapping y_encdec_yyfunct6 : y_yyfunct6 <-> bits(6) = {
 Y_YY_YADD          <-> 0b000000,
 Y_YY_YSUB          <-> 0b000010,
 Y_YY_YMINU         <-> 0b000100,
 Y_YY_YMIN          <-> 0b000101,
 Y_YY_YMAXU         <-> 0b000110,
 Y_YY_YMAX          <-> 0b000111,
 Y_YY_YAND          <-> 0b001001,
 Y_YY_YOR           <-> 0b001010,
 Y_YY_YXOR          <-> 0b001011,
 Y_YY_YRGATHER      <-> 0b001100,
 Y_YY_YRGATHEREI16  <-> 0b001110,
 Y_YY_YSADDU        <-> 0b100000,
 Y_YY_YSADD         <-> 0b100001,
 Y_YY_YSSUBU        <-> 0b100010,
 Y_YY_YSSUB         <-> 0b100011,
 Y_YY_YSLL          <-> 0b100101,
 Y_YY_YSMUL         <-> 0b100111,
 Y_YY_YSRL          <-> 0b101000,
 Y_YY_YSRA          <-> 0b101001,
 Y_YY_YSSRL         <-> 0b101010,
 Y_YY_YSSRA         <-> 0b101011
}

mapping clause encdec = Y_YYTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_encdec_yyfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ y_encdec_yreg(ys1) @ 0b000 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64 & y_valid_wide_yytype(funct6))

function clause execute(Y_YYTYPE(funct6, ym, ys2, ys1, yd)) = {
  let Y_SEW_pow = y_get_sew_pow();
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  // "The vrgatherei16.vv form uses SEW/LMUL for the data in vs2 but
  // EEW=16 and EMUL = (16/SEW)*LMUL for the indices in vs1."  Other
  // than that, all the other instructions here use a uniform SEW/LMUL
  // for their tensor operands.  Also, "For any vrgather instruction,
  // the destination vector register group cannot overlap with the
  // source vector register groups, otherwise the instruction encoding
  // is reserved."

  let ys1_emul_pow = if funct6 == Y_YY_YRGATHEREI16 then {
      4 + Y_LMUL_pow - Y_SEW_pow
    } else {
      Y_LMUL_pow
    };

  // Check for source destination overlaps for vrgather instructions.
  let src_dst_overlap : bool = if funct6 == Y_YY_YRGATHER then {
      ys1 == yd | ys2 == yd
    } else {
      if funct6 == Y_YY_YRGATHEREI16 then {
        not(y_valid_disjoint_reg_groups(ys1, yd, ys1_emul_pow, Y_LMUL_pow)) | ys2 == yd
      } else {
        false
      }
    };

  let src_mask_overlap = not(y_valid_ym_src_overlap(ym, ys1, SEW)) | not(y_valid_ym_src_overlap(ym, ys2, SEW));

  let src_src_overlap : bool = if funct6 == Y_YY_YRGATHEREI16 then {
      not(y_valid_src_overlap(ys1, 16, ys1_emul_pow, ys2, SEW, Y_LMUL_pow))
    } else {
      false
    };

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_normal(yd, ym)
   | not(y_valid_reg_overlap(ys1, yd, ys1_emul_pow, Y_LMUL_pow))
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | src_dst_overlap
   | src_src_overlap
   | src_mask_overlap then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let ys1_val : vector('n, bits('m)) = if funct6 == Y_YY_YRGATHEREI16 then {
      vector_init(zeros())
    } else {
      y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys1)
    };
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);
  let yd_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, yd);

  // See above for the ys1 operand of vrgatherei16.yy.  This is a
  // different variable from `ys1_val` due to its different type.
  let ys1_val_yrgatherei16 : vector('n, bits(16)) = if funct6 == Y_YY_YRGATHEREI16 then {
      y_read_yreg(num_elem, 16, ys1_emul_pow, ys1)
    } else {
      vector_init(zeros())
    };

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
    let ys1_val_yrgatherei16_view = y_shape(ys1_val_yrgatherei16, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ys1_val_view));
      assert(i < length(ys1_val_yrgatherei16_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        result_view[i][j][k] = match funct6 {
          Y_YY_YADD         => ys2_val_view[i][j][k] + ys1_val_view[i][j][k],
          Y_YY_YSUB         => ys2_val_view[i][j][k] - ys1_val_view[i][j][k],
          Y_YY_YAND         => ys2_val_view[i][j][k] & ys1_val_view[i][j][k],
          Y_YY_YOR          => ys2_val_view[i][j][k] | ys1_val_view[i][j][k],
          Y_YY_YXOR         => ys2_val_view[i][j][k] ^ ys1_val_view[i][j][k],
          Y_YY_YSADDU       => y_unsigned_saturation(
            sizeof('m),
            zero_extend(sizeof('m) + 1, ys2_val_view[i][j][k]) +
              zero_extend(sizeof('m) + 1, ys1_val_view[i][j][k]),
          ),
          Y_YY_YSADD        => y_signed_saturation(
            sizeof('m),
            sign_extend(sizeof('m) + 1, ys2_val_view[i][j][k]) +
              sign_extend(sizeof('m) + 1, ys1_val_view[i][j][k]),
          ),
          Y_YY_YSSUBU       => {
            if unsigned(ys2_val_view[i][j][k]) < unsigned(ys1_val_view[i][j][k]) then {
              y_write_yxsat(0b1);
              zeros()
            } else {
              y_unsigned_saturation(
                sizeof('m),
                zero_extend(sizeof('m) + 1, ys2_val_view[i][j][k]) -
                  zero_extend(sizeof('m) + 1, ys1_val_view[i][j][k]),
              )
            }
          },
          Y_YY_YSSUB        => y_signed_saturation(
            sizeof('m),
            sign_extend(sizeof('m) + 1, ys2_val_view[i][j][k]) -
              sign_extend(sizeof('m) + 1, ys1_val_view[i][j][k]),
          ),
          Y_YY_YSMUL        => {
            let result_mul = to_bits_unsafe(
              sizeof('m) * 2,
              signed(ys2_val_view[i][j][k]) * signed(ys1_val_view[i][j][k]),
            );
            let rounding_incr = y_get_fixed_rounding_incr(result_mul, sizeof('m) - 1);
            let result_wide = (result_mul >> (sizeof('m) - 1)) + zero_extend(sizeof('m) * 2, rounding_incr);
            y_signed_saturation(sizeof('m), result_wide[sizeof('m) .. 0])
          },
          Y_YY_YSLL         => {
            let shift_amount = y_get_shift_amount(ys1_val_view[i][j][k], SEW);
            ys2_val_view[i][j][k] << shift_amount
          },
          Y_YY_YSRL         => {
            let shift_amount = y_get_shift_amount(ys1_val_view[i][j][k], SEW);
            ys2_val_view[i][j][k] >> shift_amount
          },
          Y_YY_YSRA         => {
            let shift_amount = y_get_shift_amount(ys1_val_view[i][j][k], SEW);
            let y_double : bits('m * 2) = sign_extend(ys2_val_view[i][j][k]);
            (y_double >> shift_amount)[SEW - 1 .. 0]
          },
          Y_YY_YSSRL        => {
            let shift_amount = y_get_shift_amount(ys1_val_view[i][j][k], SEW);
            let rounding_incr = y_get_fixed_rounding_incr(ys2_val_view[i][j][k], shift_amount);
            (ys2_val_view[i][j][k] >> shift_amount) + zero_extend(sizeof('m), rounding_incr)
          },
          Y_YY_YSSRA        => {
            let shift_amount = y_get_shift_amount(ys1_val_view[i][j][k], SEW);
            let rounding_incr = y_get_fixed_rounding_incr(ys2_val_view[i][j][k], shift_amount);
            let y_double : bits('m * 2) = sign_extend(ys2_val_view[i][j][k]);
            (y_double >> shift_amount)[SEW - 1 .. 0] + zero_extend(sizeof('m), rounding_incr)
          },
          Y_YY_YMINU        => to_bits_unsafe(
            SEW,
            min(unsigned(ys2_val_view[i][j][k]), unsigned(ys1_val_view[i][j][k])),
          ),
          Y_YY_YMIN         => to_bits_unsafe(SEW, min(signed(ys2_val_view[i][j][k]), signed(ys1_val_view[i][j][k]))),
          Y_YY_YMAXU        => to_bits_unsafe(
            SEW,
            max(unsigned(ys2_val_view[i][j][k]), unsigned(ys1_val_view[i][j][k])),
          ),
          Y_YY_YMAX         => to_bits_unsafe(SEW, max(signed(ys2_val_view[i][j][k]), signed(ys1_val_view[i][j][k]))),
          Y_YY_YRGATHER     => {
            let idx = unsigned(ys1_val_view[i][j][k]);
            assert(Y_LMUL_pow + ylen_exp - Y_SEW_pow >= 0);
            let YLMAX = 2 ^ (Y_LMUL_pow + ylen_exp - Y_SEW_pow);
            assert(YLMAX <= sizeof('n));
            if idx < YLMAX then {
              ys2_val_view[idx / (y_columns * y_depth)][(idx / y_depth) % y_columns][idx % y_depth]
            } else {
              zeros()
            }
          },
          Y_YY_YRGATHEREI16 => {
            let idx = unsigned(ys1_val_yrgatherei16_view[i][j][k]);
            assert(Y_LMUL_pow + ylen_exp - Y_SEW_pow >= 0);
            let YLMAX = 2 ^ (Y_LMUL_pow + ylen_exp - Y_SEW_pow);
            assert(YLMAX <= sizeof('n));
            if idx < YLMAX then {
              ys2_val_view[idx / (y_columns * y_depth)][(idx / y_depth) % y_columns][idx % y_depth]
            } else {
              zeros()
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

mapping y_yytype_mnemonic : y_yyfunct6 <-> string = {
 Y_YY_YADD          <-> "yadd.yy",
 Y_YY_YSUB          <-> "ysub.yy",
 Y_YY_YAND          <-> "yand.yy",
 Y_YY_YOR           <-> "yor.yy",
 Y_YY_YXOR          <-> "yxor.yy",
 Y_YY_YRGATHER      <-> "yrgather.yy",
 Y_YY_YRGATHEREI16  <-> "yrgatherei16.yy",
 Y_YY_YSADDU        <-> "ysaddu.yy",
 Y_YY_YSADD         <-> "ysadd.yy",
 Y_YY_YSSUBU        <-> "yssubu.yy",
 Y_YY_YSSUB         <-> "yssub.yy",
 Y_YY_YSLL          <-> "ysll.yy",
 Y_YY_YSMUL         <-> "ysmul.yy",
 Y_YY_YSRL          <-> "ysrl.yy",
 Y_YY_YSRA          <-> "ysra.yy",
 Y_YY_YSSRL         <-> "yssrl.yy",
 Y_YY_YSSRA         <-> "yssra.yy",
 Y_YY_YMINU         <-> "yminu.yy",
 Y_YY_YMIN          <-> "ymin.yy",
 Y_YY_YMAXU         <-> "ymaxu.yy",
 Y_YY_YMAX          <-> "ymax.yy"
}

mapping clause assembly = Y_YYTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_yytype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ y_yreg_name(ys1) ^ y_maybe_ymask(ym)

// ************************* OPIVV (WIDE_YTYPE Narrowing) ***************************
// ************* Tensor Narrowing Integer Right Shift Instructions **************
union clause instruction = Y_NYSTYPE : (y_nysfunct6, bits(1), yregidx, yregidx, yregidx)

mapping y_encdec_nysfunct6 : y_nysfunct6 <-> bits(6) = {
 Y_NYS_YNSRL       <-> 0b101100,
 Y_NYS_YNSRA       <-> 0b101101
}

mapping clause encdec = Y_NYSTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_encdec_nysfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ y_encdec_yreg(ys1) @ 0b000 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 16)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 32)

function clause execute(Y_NYSTYPE(funct6, ym, ys2, ys1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = Y_LMUL_pow + 1;

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_variable_width(yd, ym, SEW_widen, LMUL_pow_widen)
   | not(y_valid_reg_overlap(ys2, yd, LMUL_pow_widen, Y_LMUL_pow))
   | not(y_valid_src_overlap(ys2, SEW_widen, LMUL_pow_widen, ys1, SEW, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys1, SEW))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW_widen)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let yd_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, yd);
  let ys1_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys1);
  let ys2_val : vector('n, bits('o)) = y_read_yreg(num_elem, SEW_widen, LMUL_pow_widen, ys2);

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
          Y_NYS_YNSRL => {
            let shift_amount = y_get_shift_amount(ys1_val_view[i][j][k], SEW_widen);
            (ys2_val_view[i][j][k] >> shift_amount)[SEW - 1 .. 0]
          },
          Y_NYS_YNSRA => {
            let shift_amount = y_get_shift_amount(ys1_val_view[i][j][k], SEW_widen);
            let y_double : bits('o * 2) = sign_extend(ys2_val_view[i][j][k]);
            let arith_shifted : bits('o) = (y_double >> shift_amount)[SEW_widen - 1 .. 0];
            arith_shifted[SEW - 1 .. 0]
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

mapping y_nystype_mnemonic : y_nysfunct6 <-> string = {
 Y_NYS_YNSRL       <-> "ynsrl.wide.yy",
 Y_NYS_YNSRA       <-> "ynsra.wide.yy"
}

mapping clause assembly = Y_NYSTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_nystype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ y_yreg_name(ys1) ^ y_maybe_ymask(ym)

// ************************* OPIVV (WIDE_YTYPE Narrowing) ***************************
// ************** Tensor Narrowing Fixed-Point Clip Instructions ****************
union clause instruction = Y_NYTYPE : (y_nyfunct6, bits(1), yregidx, yregidx, yregidx)

mapping y_encdec_nyfunct6 : y_nyfunct6 <-> bits(6) = {
 Y_NY_YNCLIPU     <-> 0b101110,
 Y_NY_YNCLIP      <-> 0b101111
}

mapping clause encdec = Y_NYTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_encdec_nyfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ y_encdec_yreg(ys1) @ 0b000 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 16)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 32)

function clause execute(Y_NYTYPE(funct6, ym, ys2, ys1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = Y_LMUL_pow + 1;

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_variable_width(yd, ym, SEW_widen, LMUL_pow_widen)
   | not(y_valid_reg_overlap(ys2, yd, LMUL_pow_widen, Y_LMUL_pow))
   | not(y_valid_src_overlap(ys2, SEW_widen, LMUL_pow_widen, ys1, SEW, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys1, SEW))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW_widen)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let yd_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, yd);
  let ys1_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys1);
  let ys2_val : vector('n, bits('o)) = y_read_yreg(num_elem, SEW_widen, LMUL_pow_widen, ys2);

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
        let shift_amount = y_get_shift_amount(ys1_val_view[i][j][k], SEW_widen);
        let rounding_incr = y_get_fixed_rounding_incr(ys2_val_view[i][j][k], shift_amount);
        result_view[i][j][k] = match funct6 {
          Y_NY_YNCLIPU => {
            let result_wide = (ys2_val_view[i][j][k] >> shift_amount) +
                zero_extend(sizeof('o), rounding_incr);
            y_unsigned_saturation(sizeof('m), result_wide)
          },
          Y_NY_YNCLIP  => {
            let y_double : bits('m * 4) = sign_extend(ys2_val_view[i][j][k]);
            let result_wide = (y_double >> shift_amount)[sizeof('o) - 1 .. 0] +
                zero_extend(sizeof('o), rounding_incr);
            y_signed_saturation(sizeof('m), result_wide)
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

mapping y_nytype_mnemonic : y_nyfunct6 <-> string = {
 Y_NY_YNCLIPU     <-> "ynclipu.wide.yy",
 Y_NY_YNCLIP      <-> "ynclip.wide.yy"
}

mapping clause assembly = Y_NYTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_nytype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ y_yreg_name(ys1) ^ y_maybe_ymask(ym)

// ********************* OPIVV (Integer Merge Instruction) **********************
union clause instruction = Y_MASKTYPEY : (yregidx, yregidx, yregidx)

mapping clause encdec = Y_MASKTYPEY (ys2, ys1,  yd)
 <-> 0b010111 @ 0b0 @ y_encdec_yreg(ys2) @ y_encdec_yreg(ys1) @ 0b000 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_MASKTYPEY(ys2, ys1, yd)) = {
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

  let ym_val : bits('n) = y_read_ymask(num_elem, 0b0, y_zyreg);
  let ys1_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys1);
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);
  let yd_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, yd);
  var result : vector('n, bits('m)) = vector_init(zeros());

  let tail_ag : y_agtype = y_get_ytype_yta();
  {
    var result_view = y_shape(result, y_columns, y_depth);
    let yd_val_view = y_shape(yd_val, y_columns, y_depth);
    let ym_val_view = y_shape(ym_val, y_columns, y_depth);
    let ys1_val_view = y_shape(ys1_val, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(result_view));
      assert(i < length(yd_val_view));
      assert(i < length(ym_val_view));
      assert(i < length(ys1_val_view));
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
              ys1_val_view[i][j][k]
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

mapping clause assembly = Y_MASKTYPEY(ys2, ys1, yd)
<-> "ymerge.yym" ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ y_yreg_name(ys1) ^ sep() ^ "y0"

// ********************* OPIVV (Integer Move Instruction) ***********************
union clause instruction = Y_MOVETYPEY : (yregidx, yregidx)

mapping clause encdec = Y_MOVETYPEY (ys1, yd)
 <-> 0b010111 @ 0b1 @ 0b00000 @ y_encdec_yreg(ys1) @ 0b000 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_MOVETYPEY(ys1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_yd_unmasked()
   | not(y_valid_reg_group(ys1, Y_LMUL_pow))
   | not(y_valid_reg_group(yd, Y_LMUL_pow)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ys1_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys1);
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
    let ys1_val_view = y_shape(ys1_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ys1_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        result_view[i][j][k] = ys1_val_view[i][j][k]
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW, Y_LMUL_pow, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = Y_MOVETYPEY(ys1, yd)
 <-> "ymv.y.y" ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys1)

// ****************************** OPIVX (YXTYPE) ********************************
union clause instruction = Y_YXTYPE : (y_yxfunct6, bits(1), yregidx, regidx, yregidx)

mapping y_encdec_yxfunct6 : y_yxfunct6 <-> bits(6) = {
 Y_YX_YADD       <-> 0b000000,
 Y_YX_YSUB       <-> 0b000010,
 Y_YX_YRSUB      <-> 0b000011,
 Y_YX_YMINU      <-> 0b000100,
 Y_YX_YMIN       <-> 0b000101,
 Y_YX_YMAXU      <-> 0b000110,
 Y_YX_YMAX       <-> 0b000111,
 Y_YX_YAND       <-> 0b001001,
 Y_YX_YOR        <-> 0b001010,
 Y_YX_YXOR       <-> 0b001011,
 Y_YX_YSADDU     <-> 0b100000,
 Y_YX_YSADD      <-> 0b100001,
 Y_YX_YSSUBU     <-> 0b100010,
 Y_YX_YSSUB      <-> 0b100011,
 Y_YX_YSLL       <-> 0b100101,
 Y_YX_YSMUL      <-> 0b100111,
 Y_YX_YSRL       <-> 0b101000,
 Y_YX_YSRA       <-> 0b101001,
 Y_YX_YSSRL      <-> 0b101010,
 Y_YX_YSSRA      <-> 0b101011
}

mapping clause encdec = Y_YXTYPE(funct6, ym, ys2, rs1, yd)
 <-> y_encdec_yxfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ encdec_reg(rs1) @ 0b100 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64 & y_valid_wide_yxtype(funct6))

function clause execute(Y_YXTYPE(funct6, ym, ys2, rs1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_normal(yd, ym)
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_reg_group(yd, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let rs1_val : bits('m) = y_get_scalar(rs1, SEW);
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
          Y_YX_YADD   => ys2_val_view[i][j][k] + rs1_val,
          Y_YX_YSUB   => ys2_val_view[i][j][k] - rs1_val,
          Y_YX_YRSUB  => rs1_val - ys2_val_view[i][j][k],
          Y_YX_YAND   => ys2_val_view[i][j][k] & rs1_val,
          Y_YX_YOR    => ys2_val_view[i][j][k] | rs1_val,
          Y_YX_YXOR   => ys2_val_view[i][j][k] ^ rs1_val,
          Y_YX_YSADDU => y_unsigned_saturation(
            sizeof('m),
            zero_extend(sizeof('m) + 1, ys2_val_view[i][j][k]) + zero_extend(sizeof('m) + 1, rs1_val),
          ),
          Y_YX_YSADD  => y_signed_saturation(
            sizeof('m),
            sign_extend(sizeof('m) + 1, ys2_val_view[i][j][k]) + sign_extend(sizeof('m) + 1, rs1_val),
          ),
          Y_YX_YSSUBU => {
            if unsigned(ys2_val_view[i][j][k]) < unsigned(rs1_val) then {
              y_write_yxsat(0b1);
              zeros()
            } else {
              y_unsigned_saturation(
                sizeof('m),
                zero_extend(sizeof('m) + 1, ys2_val_view[i][j][k]) -
                  zero_extend(sizeof('m) + 1, rs1_val),
              )
            }
          },
          Y_YX_YSSUB  => y_signed_saturation(
            sizeof('m),
            sign_extend(sizeof('m) + 1, ys2_val_view[i][j][k]) - sign_extend(sizeof('m) + 1, rs1_val),
          ),
          Y_YX_YSMUL  => {
            let result_mul = to_bits_unsafe(sizeof('m) * 2, signed(ys2_val_view[i][j][k]) * signed(rs1_val));
            let rounding_incr = y_get_fixed_rounding_incr(result_mul, sizeof('m) - 1);
            let result_wide = (result_mul >> (sizeof('m) - 1)) + zero_extend(sizeof('m) * 2, rounding_incr);
            y_signed_saturation(sizeof('m), result_wide[sizeof('m) .. 0])
          },
          Y_YX_YSLL   => {
            let shift_amount = y_get_shift_amount(rs1_val, SEW);
            ys2_val_view[i][j][k] << shift_amount
          },
          Y_YX_YSRL   => {
            let shift_amount = y_get_shift_amount(rs1_val, SEW);
            ys2_val_view[i][j][k] >> shift_amount
          },
          Y_YX_YSRA   => {
            let shift_amount = y_get_shift_amount(rs1_val, SEW);
            let y_double : bits('m * 2) = sign_extend(ys2_val_view[i][j][k]);
            (y_double >> shift_amount)[SEW - 1 .. 0]
          },
          Y_YX_YSSRL  => {
            let shift_amount = y_get_shift_amount(rs1_val, SEW);
            let rounding_incr = y_get_fixed_rounding_incr(ys2_val_view[i][j][k], shift_amount);
            (ys2_val_view[i][j][k] >> shift_amount) + zero_extend(sizeof('m), rounding_incr)
          },
          Y_YX_YSSRA  => {
            let shift_amount = y_get_shift_amount(rs1_val, SEW);
            let rounding_incr = y_get_fixed_rounding_incr(ys2_val_view[i][j][k], shift_amount);
            let y_double : bits('m * 2) = sign_extend(ys2_val_view[i][j][k]);
            (y_double >> shift_amount)[SEW - 1 .. 0] + zero_extend(sizeof('m), rounding_incr)
          },
          Y_YX_YMINU  => to_bits_unsafe(SEW, min(unsigned(ys2_val_view[i][j][k]), unsigned(rs1_val))),
          Y_YX_YMIN   => to_bits_unsafe(SEW, min(signed(ys2_val_view[i][j][k]), signed(rs1_val))),
          Y_YX_YMAXU  => to_bits_unsafe(SEW, max(unsigned(ys2_val_view[i][j][k]), unsigned(rs1_val))),
          Y_YX_YMAX   => to_bits_unsafe(SEW, max(signed(ys2_val_view[i][j][k]), signed(rs1_val))),
        }
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW, Y_LMUL_pow, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_yxtype_mnemonic : y_yxfunct6 <-> string = {
 Y_YX_YADD       <-> "yadd.yx",
 Y_YX_YSUB       <-> "ysub.yx",
 Y_YX_YRSUB      <-> "yrsub.yx",
 Y_YX_YAND       <-> "yand.yx",
 Y_YX_YOR        <-> "yor.yx",
 Y_YX_YXOR       <-> "yxor.yx",
 Y_YX_YSADDU     <-> "ysaddu.yx",
 Y_YX_YSADD      <-> "ysadd.yx",
 Y_YX_YSSUBU     <-> "yssubu.yx",
 Y_YX_YSSUB      <-> "yssub.yx",
 Y_YX_YSLL       <-> "ysll.yx",
 Y_YX_YSMUL      <-> "ysmul.yx",
 Y_YX_YSRL       <-> "ysrl.yx",
 Y_YX_YSRA       <-> "ysra.yx",
 Y_YX_YSSRL      <-> "yssrl.yx",
 Y_YX_YSSRA      <-> "yssra.yx",
 Y_YX_YMINU      <-> "yminu.yx",
 Y_YX_YMIN       <-> "ymin.yx",
 Y_YX_YMAXU      <-> "ymaxu.yx",
 Y_YX_YMAX       <-> "ymax.yx"
}

mapping clause assembly = Y_YXTYPE(funct6, ym, ys2, rs1, yd)
 <-> y_yxtype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ reg_name(rs1) ^ y_maybe_ymask(ym)

// ************************* OPIVX (WIDE_XTYPE Narrowing) ***************************
// ************* Tensor Narrowing Integer Right Shift Instructions **************
union clause instruction = Y_NXSTYPE : (y_nxsfunct6, bits(1), yregidx, regidx, yregidx)

mapping y_encdec_nxsfunct6 : y_nxsfunct6 <-> bits(6) = {
 Y_NXS_YNSRL       <-> 0b101100,
 Y_NXS_YNSRA       <-> 0b101101
}

mapping clause encdec = Y_NXSTYPE(funct6, ym, ys2, rs1, yd)
 <-> y_encdec_nxsfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ encdec_reg(rs1) @ 0b100 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 16)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 32)

function clause execute(Y_NXSTYPE(funct6, ym, ys2, rs1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = Y_LMUL_pow + 1;

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_variable_width(yd, ym, SEW_widen, LMUL_pow_widen)
   | not(y_valid_reg_overlap(ys2, yd, LMUL_pow_widen, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW_widen)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let yd_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, yd);
  let rs1_val : bits('m) = y_get_scalar(rs1, SEW);
  let ys2_val : vector('n, bits('o)) = y_read_yreg(num_elem, SEW_widen, LMUL_pow_widen, ys2);

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
          Y_NXS_YNSRL => {
            let shift_amount = y_get_shift_amount(rs1_val, SEW_widen);
            (ys2_val_view[i][j][k] >> shift_amount)[SEW - 1 .. 0]
          },
          Y_NXS_YNSRA => {
            let shift_amount = y_get_shift_amount(rs1_val, SEW_widen);
            let y_double : bits('o * 2) = sign_extend(ys2_val_view[i][j][k]);
            let arith_shifted : bits('o) = (y_double >> shift_amount)[SEW_widen - 1 .. 0];
            arith_shifted[SEW - 1 .. 0]
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

mapping y_nxstype_mnemonic : y_nxsfunct6 <-> string = {
 Y_NXS_YNSRL       <-> "ynsrl.wide.yx",
 Y_NXS_YNSRA       <-> "ynsra.wide.yx"
}

mapping clause assembly = Y_NXSTYPE(funct6, ym, ys2, rs1, yd)
 <-> y_nxstype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ reg_name(rs1) ^ y_maybe_ymask(ym)

// ************************* OPIVX (WIDE_XTYPE Narrowing) ***************************
// ************** Tensor Narrowing Fixed-Point Clip Instructions ****************
union clause instruction = Y_NXTYPE : (y_nxfunct6, bits(1), yregidx, regidx, yregidx)

mapping y_encdec_nxfunct6 : y_nxfunct6 <-> bits(6) = {
 Y_NX_YNCLIPU     <-> 0b101110,
 Y_NX_YNCLIP      <-> 0b101111
}

mapping clause encdec = Y_NXTYPE(funct6, ym, ys2, rs1, yd)
 <-> y_encdec_nxfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ encdec_reg(rs1) @ 0b100 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 16)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 32)

function clause execute(Y_NXTYPE(funct6, ym, ys2, rs1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = Y_LMUL_pow + 1;

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_variable_width(yd, ym, SEW_widen, LMUL_pow_widen)
   | not(y_valid_reg_overlap(ys2, yd, LMUL_pow_widen, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW_widen)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let yd_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, yd);
  let rs1_val : bits('m) = y_get_scalar(rs1, SEW);
  let ys2_val : vector('n, bits('o)) = y_read_yreg(num_elem, SEW_widen, LMUL_pow_widen, ys2);

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
        let shift_amount = y_get_shift_amount(rs1_val, SEW_widen);
        let rounding_incr = y_get_fixed_rounding_incr(ys2_val_view[i][j][k], shift_amount);
        result_view[i][j][k] = match funct6 {
          Y_NX_YNCLIPU => {
            let result_wide = (ys2_val_view[i][j][k] >> shift_amount) +
                zero_extend(sizeof('o), rounding_incr);
            y_unsigned_saturation(sizeof('m), result_wide)
          },
          Y_NX_YNCLIP  => {
            let y_double : bits('m * 4) = sign_extend(ys2_val_view[i][j][k]);
            let result_wide = (y_double >> shift_amount)[sizeof('o) - 1 .. 0] +
                zero_extend(sizeof('o), rounding_incr);
            y_signed_saturation(sizeof('m), result_wide)
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

mapping y_nxtype_mnemonic : y_nxfunct6 <-> string = {
 Y_NX_YNCLIPU     <-> "ynclipu.wide.yx",
 Y_NX_YNCLIP      <-> "ynclip.wide.yx"
}

mapping clause assembly = Y_NXTYPE(funct6, ym, ys2, rs1, yd)
 <-> y_nxtype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ reg_name(rs1) ^ y_maybe_ymask(ym)

// **************** OPIVX (Tensor Slide & Gather Instructions) ******************
// Slide and gather instructions extend rs1/imm to XLEN instead of SEW bits
union clause instruction = Y_YXSG : (y_yxsgfunct6, bits(1), yregidx, regidx, yregidx)

mapping y_encdec_yxsgfunct6 : y_yxsgfunct6 <-> bits(6) = {
 Y_YX_YSLIDEUP     <-> 0b001110,
 Y_YX_YSLIDEDOWN   <-> 0b001111,
 Y_YX_YRGATHER     <-> 0b001100
}

mapping clause encdec = Y_YXSG(funct6, ym, ys2, rs1, yd)
 <-> y_encdec_yxsgfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ encdec_reg(rs1) @ 0b100 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YXSG(funct6, ym, ys2, rs1, yd)) = {
  let Y_SEW_pow = y_get_sew_pow();
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  // For `vslideup` and `vrgather`, "the destination vector register
  // group cannot overlap with the source vector register groups,
  // otherwise the instruction encoding is reserved."
  let src_dst_overlap : bool = match funct6 {
    Y_YX_YSLIDEUP   => yd == ys2,
    Y_YX_YSLIDEDOWN => false,
    Y_YX_YRGATHER   => yd == ys2,
  };

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_normal(yd, ym)
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_reg_group(yd, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW))
   | src_dst_overlap then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let rs1_val : nat = unsigned(X(rs1));
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
          Y_YX_YSLIDEUP   => {
            if p >= rs1_val then {
              ys2_val_view[(p - rs1_val) / (y_columns * y_depth)][((p - rs1_val) / y_depth) % y_columns][
                (p - rs1_val) % y_depth
              ]
            } else {
              yd_val_view[i][j][k]
            }
          },
          Y_YX_YSLIDEDOWN => {
            assert(Y_LMUL_pow + ylen_exp - Y_SEW_pow >= 0);
            let YLMAX = 2 ^ (Y_LMUL_pow + ylen_exp - Y_SEW_pow);
            assert(YLMAX > 0 & YLMAX <= sizeof('n));
            if p + rs1_val < YLMAX then {
              ys2_val_view[(p + rs1_val) / (y_columns * y_depth)][((p + rs1_val) / y_depth) % y_columns][
                (p + rs1_val) % y_depth
              ]
            } else {
              zeros()
            }
          },
          Y_YX_YRGATHER   => {
            assert(Y_LMUL_pow + ylen_exp - Y_SEW_pow >= 0);
            let YLMAX = 2 ^ (Y_LMUL_pow + ylen_exp - Y_SEW_pow);
            assert(YLMAX > 0 & YLMAX <= sizeof('n));
            if rs1_val < YLMAX then {
              ys2_val_view[rs1_val / (y_columns * y_depth)][(rs1_val / y_depth) % y_columns][
                rs1_val % y_depth
              ]
            } else {
              zeros()
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

mapping y_yxsg_mnemonic : y_yxsgfunct6 <-> string = {
 Y_YX_YSLIDEUP     <-> "yslideup.yx",
 Y_YX_YSLIDEDOWN   <-> "yslidedown.yx",
 Y_YX_YRGATHER     <-> "yrgather.yx"
}

mapping clause assembly = Y_YXSG(funct6, ym, ys2, rs1, yd)
 <-> y_yxsg_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ reg_name(rs1) ^ y_maybe_ymask(ym)

// ********************* OPIVX (Integer Merge Instruction) **********************
union clause instruction = Y_MASKTYPEX : (yregidx, regidx, yregidx)

mapping clause encdec = Y_MASKTYPEX(ys2, rs1, yd)
 <-> 0b010111 @ 0b0 @ y_encdec_yreg(ys2) @ encdec_reg(rs1) @ 0b100 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_MASKTYPEX(ys2, rs1, yd)) = {
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
   | y_illegal_yd_masked(yd)
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_reg_group(yd, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(0b0, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem, 0b0, y_zyreg);
  let rs1_val : bits('m) = y_get_scalar(rs1, SEW);
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

mapping clause assembly = Y_MASKTYPEX(ys2, rs1, yd)
 <-> "ymerge.yxm" ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ reg_name(rs1) ^ sep() ^ "y0"

// ********************* OPIVX (Integer Move Instruction) ***********************
union clause instruction = Y_MOVETYPEX : (regidx, yregidx)

mapping clause encdec = Y_MOVETYPEX (rs1, yd)
 <-> 0b010111 @ 0b1 @ 0b00000 @ encdec_reg(rs1) @ 0b100 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_MOVETYPEX(rs1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_yd_unmasked()
   | not(y_valid_reg_group(yd, Y_LMUL_pow)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let rs1_val : bits('m) = y_get_scalar(rs1, sizeof('m));
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

mapping clause assembly = Y_MOVETYPEX(rs1, yd)
 <-> "ymv.y.x" ^ spc() ^ y_yreg_name(yd) ^ sep() ^ reg_name(rs1)

// ****************************** OPIVI (YITYPE) ********************************
union clause instruction = Y_YITYPE : (y_yifunct6, bits(1), yregidx, bits(5), yregidx)

mapping y_encdec_yifunct6 : y_yifunct6 <-> bits(6) = {
 Y_YI_YADD       <-> 0b000000,
 Y_YI_YRSUB      <-> 0b000011,
 Y_YI_YAND       <-> 0b001001,
 Y_YI_YOR        <-> 0b001010,
 Y_YI_YXOR       <-> 0b001011,
 Y_YI_YSADDU     <-> 0b100000,
 Y_YI_YSADD      <-> 0b100001,
 Y_YI_YSLL       <-> 0b100101,
 Y_YI_YSRL       <-> 0b101000,
 Y_YI_YSRA       <-> 0b101001,
 Y_YI_YSSRL      <-> 0b101010,
 Y_YI_YSSRA      <-> 0b101011
}

mapping clause encdec = Y_YITYPE(funct6, ym, ys2, simm, yd)
 <-> y_encdec_yifunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ simm @ 0b011 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YITYPE(funct6, ym, ys2, simm, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_normal(yd, ym)
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_reg_group(yd, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let imm_val : bits('m) = sign_extend(simm);
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
          Y_YI_YADD   => ys2_val_view[i][j][k] + imm_val,
          Y_YI_YRSUB  => imm_val - ys2_val_view[i][j][k],
          Y_YI_YAND   => ys2_val_view[i][j][k] & imm_val,
          Y_YI_YOR    => ys2_val_view[i][j][k] | imm_val,
          Y_YI_YXOR   => ys2_val_view[i][j][k] ^ imm_val,
          Y_YI_YSADDU => y_unsigned_saturation(
            sizeof('m),
            zero_extend(sizeof('m) + 1, ys2_val_view[i][j][k]) + zero_extend(sizeof('m) + 1, imm_val),
          ),
          Y_YI_YSADD  => y_signed_saturation(
            sizeof('m),
            sign_extend(sizeof('m) + 1, ys2_val_view[i][j][k]) + sign_extend(sizeof('m) + 1, imm_val),
          ),
          Y_YI_YSLL   => {
            let shift_amount = y_get_shift_amount(zero_extend(sizeof('m), simm), SEW);
            ys2_val_view[i][j][k] << shift_amount
          },
          Y_YI_YSRL   => {
            let shift_amount = y_get_shift_amount(zero_extend(sizeof('m), simm), SEW);
            ys2_val_view[i][j][k] >> shift_amount
          },
          Y_YI_YSRA   => {
            let shift_amount = y_get_shift_amount(zero_extend(sizeof('m), simm), SEW);
            let y_double : bits('m * 2) = sign_extend(ys2_val_view[i][j][k]);
            (y_double >> shift_amount)[SEW - 1 .. 0]
          },
          Y_YI_YSSRL  => {
            let shift_amount = y_get_shift_amount(zero_extend(sizeof('m), simm), SEW);
            let rounding_incr = y_get_fixed_rounding_incr(ys2_val_view[i][j][k], shift_amount);
            (ys2_val_view[i][j][k] >> shift_amount) + zero_extend(sizeof('m), rounding_incr)
          },
          Y_YI_YSSRA  => {
            let shift_amount = y_get_shift_amount(zero_extend(sizeof('m), simm), SEW);
            let rounding_incr = y_get_fixed_rounding_incr(ys2_val_view[i][j][k], shift_amount);
            let y_double : bits('m * 2) = sign_extend(ys2_val_view[i][j][k]);
            (y_double >> shift_amount)[SEW - 1 .. 0] + zero_extend(sizeof('m), rounding_incr)
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

mapping y_yitype_mnemonic : y_yifunct6 <-> string = {
 Y_YI_YADD   <-> "yadd.yi",
 Y_YI_YRSUB  <-> "yrsub.yi",
 Y_YI_YAND   <-> "yand.yi",
 Y_YI_YOR    <-> "yor.yi",
 Y_YI_YXOR   <-> "yxor.yi",
 Y_YI_YSADDU <-> "ysaddu.yi",
 Y_YI_YSADD  <-> "ysadd.yi",
 Y_YI_YSLL   <-> "ysll.yi",
 Y_YI_YSRL   <-> "ysrl.yi",
 Y_YI_YSRA   <-> "ysra.yi",
 Y_YI_YSSRL  <-> "yssrl.yi",
 Y_YI_YSSRA  <-> "yssra.yi"
}

mapping clause assembly = Y_YITYPE(funct6, ym, ys2, simm, yd)
 <-> y_yitype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ hex_bits_signed_5(simm) ^ y_maybe_ymask(ym)

// ************************* OPIVI (WITYPE Narrowing) ***************************
// ************* Tensor Narrowing Integer Right Shift Instructions **************
union clause instruction = Y_NISTYPE : (y_nisfunct6, bits(1), yregidx, bits(5), yregidx)

mapping y_encdec_nisfunct6 : y_nisfunct6 <-> bits(6) = {
 Y_NIS_YNSRL       <-> 0b101100,
 Y_NIS_YNSRA       <-> 0b101101
}

mapping clause encdec = Y_NISTYPE(funct6, ym, ys2, uimm, yd)
 <-> y_encdec_nisfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ uimm @ 0b011 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 16)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 32)

function clause execute(Y_NISTYPE(funct6, ym, ys2, uimm, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = Y_LMUL_pow + 1;

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_variable_width(yd, ym, SEW_widen, LMUL_pow_widen)
   | not(y_valid_reg_overlap(ys2, yd, LMUL_pow_widen, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW_widen)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let yd_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, yd);
  let imm_val : bits('m) = zero_extend(uimm);
  let ys2_val : vector('n, bits('o)) = y_read_yreg(num_elem, SEW_widen, LMUL_pow_widen, ys2);

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
          Y_NIS_YNSRL => {
            let shift_amount = y_get_shift_amount(imm_val, SEW_widen);
            (ys2_val_view[i][j][k] >> shift_amount)[SEW - 1 .. 0]
          },
          Y_NIS_YNSRA => {
            let shift_amount = y_get_shift_amount(imm_val, SEW_widen);
            let y_double : bits('o * 2) = sign_extend(ys2_val_view[i][j][k]);
            let arith_shifted : bits('o) = (y_double >> shift_amount)[SEW_widen - 1 .. 0];
            arith_shifted[SEW - 1 .. 0]
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

mapping y_nistype_mnemonic : y_nisfunct6 <-> string = {
 Y_NIS_YNSRL       <-> "ynsrl.wide.yi",
 Y_NIS_YNSRA       <-> "ynsra.wide.yi"
}

mapping clause assembly = Y_NISTYPE(funct6, ym, ys2, uimm, yd)
 <-> y_nistype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ hex_bits_5(uimm) ^ y_maybe_ymask(ym)

// ************************* OPIVI (WITYPE Narrowing) ***************************
// ************** Tensor Narrowing Fixed-Point Clip Instructions ****************
union clause instruction = Y_NITYPE : (y_nifunct6, bits(1), yregidx, bits(5), yregidx)

mapping y_encdec_nifunct6 : y_nifunct6 <-> bits(6) = {
 Y_NI_YNCLIPU     <-> 0b101110,
 Y_NI_YNCLIP      <-> 0b101111
}

mapping clause encdec = Y_NITYPE(funct6, ym, ys2, uimm, yd)
 <-> y_encdec_nifunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ uimm @ 0b011 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 16)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 32)

function clause execute(Y_NITYPE(funct6, ym, ys2, uimm, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = Y_LMUL_pow + 1;

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_variable_width(yd, ym, SEW_widen, LMUL_pow_widen)
   | not(y_valid_reg_overlap(ys2, yd, LMUL_pow_widen, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW_widen)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let yd_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, yd);
  let imm_val : bits('m) = zero_extend(uimm);
  let ys2_val : vector('n, bits('o)) = y_read_yreg(num_elem, SEW_widen, LMUL_pow_widen, ys2);

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
        let shift_amount = y_get_shift_amount(imm_val, SEW_widen);
        let rounding_incr = y_get_fixed_rounding_incr(ys2_val_view[i][j][k], shift_amount);
        result_view[i][j][k] = match funct6 {
          Y_NI_YNCLIPU => {
            let result_wide = (ys2_val_view[i][j][k] >> shift_amount) +
                zero_extend(sizeof('o), rounding_incr);
            y_unsigned_saturation(sizeof('m), result_wide)
          },
          Y_NI_YNCLIP  => {
            let y_double : bits('m * 4) = sign_extend(ys2_val_view[i][j][k]);
            let result_wide = (y_double >> shift_amount)[sizeof('o) - 1 .. 0] +
                zero_extend(sizeof('o), rounding_incr);
            y_signed_saturation(sizeof('m), result_wide)
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

mapping y_nitype_mnemonic : y_nifunct6 <-> string = {
 Y_NI_YNCLIPU     <-> "ynclipu.wide.yi",
 Y_NI_YNCLIP      <-> "ynclip.wide.yi"
}

mapping clause assembly = Y_NITYPE(funct6, ym, ys2, uimm, yd)
 <-> y_nitype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ hex_bits_5(uimm) ^ y_maybe_ymask(ym)

// **************** OPIVI (Tensor Slide & Gather Instructions) ******************
// Slide and gather instructions extend rs1/imm to XLEN instead of SEW bits
union clause instruction = Y_YISG : (y_yisgfunct6, bits(1), yregidx, bits(5), yregidx)

mapping y_encdec_yisgfunct6 : y_yisgfunct6 <-> bits(6) = {
 Y_YI_YSLIDEUP     <-> 0b001110,
 Y_YI_YSLIDEDOWN   <-> 0b001111,
 Y_YI_YRGATHER     <-> 0b001100
}

mapping clause encdec = Y_YISG(funct6, ym, ys2, simm, yd)
 <-> y_encdec_yisgfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ simm @ 0b011 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YISG(funct6, ym, ys2, simm, yd)) = {
  let Y_SEW_pow = y_get_sew_pow();
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  // For `vslideup` and `vrgather`, "the destination vector register
  // group cannot overlap with the source vector register groups,
  // otherwise the instruction encoding is reserved."
  let src_dst_overlap : bool = match funct6 {
    Y_YI_YSLIDEUP   => yd == ys2,
    Y_YI_YSLIDEDOWN => false,
    Y_YI_YRGATHER   => yd == ys2,
  };
  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_normal(yd, ym)
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_reg_group(yd, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW))
   | src_dst_overlap then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let imm_val : nat = unsigned(zero_extend(xlen, simm));
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
          Y_YI_YSLIDEUP   => {
            if p >= imm_val then {
              ys2_val_view[(p - imm_val) / (y_columns * y_depth)][((p - imm_val) / y_depth) % y_columns][
                (p - imm_val) % y_depth
              ]
            } else {
              yd_val_view[i][j][k]
            }
          },
          Y_YI_YSLIDEDOWN => {
            assert(Y_LMUL_pow + ylen_exp - Y_SEW_pow >= 0);
            let YLMAX = 2 ^ (Y_LMUL_pow + ylen_exp - Y_SEW_pow);
            assert(YLMAX > 0 & YLMAX <= sizeof('n));
            if p + imm_val < YLMAX then {
              ys2_val_view[(p + imm_val) / (y_columns * y_depth)][((p + imm_val) / y_depth) % y_columns][
                (p + imm_val) % y_depth
              ]
            } else {
              zeros()
            }
          },
          Y_YI_YRGATHER   => {
            assert(Y_LMUL_pow + ylen_exp - Y_SEW_pow >= 0);
            let YLMAX = 2 ^ (Y_LMUL_pow + ylen_exp - Y_SEW_pow);
            assert(YLMAX > 0 & YLMAX <= sizeof('n));
            if imm_val < YLMAX then {
              ys2_val_view[imm_val / (y_columns * y_depth)][(imm_val / y_depth) % y_columns][
                imm_val % y_depth
              ]
            } else {
              zeros()
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

mapping y_yisg_mnemonic : y_yisgfunct6 <-> string = {
 Y_YI_YSLIDEUP     <-> "yslideup.yi",
 Y_YI_YSLIDEDOWN   <-> "yslidedown.yi",
 Y_YI_YRGATHER     <-> "yrgather.yi"
}

mapping clause assembly = Y_YISG(funct6, ym, ys2, simm, yd)
 <-> y_yisg_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ hex_bits_signed_5(simm) ^ y_maybe_ymask(ym)

// ********************* OPIVI (Integer Merge Instruction) **********************
union clause instruction = Y_MASKTYPEI : (yregidx, bits(5), yregidx)

mapping clause encdec = Y_MASKTYPEI(ys2, simm, yd)
 <-> 0b010111 @ 0b0 @ y_encdec_yreg(ys2) @ simm @ 0b011 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_MASKTYPEI(ys2, simm, yd)) = {
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
   | y_illegal_yd_masked(yd)
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_reg_group(yd, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(0b0, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem, 0b0, y_zyreg);
  let imm_val : bits('m) = sign_extend(simm);
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
              imm_val
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

mapping clause assembly = Y_MASKTYPEI(ys2, simm, yd)
 <-> "ymerge.yim" ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ hex_bits_signed_5(simm) ^ sep() ^ "y0"

// ********************* OPIVI (Integer Move Instruction) ***********************
union clause instruction = Y_MOVETYPEI : (yregidx, bits(5))

mapping clause encdec = Y_MOVETYPEI (yd, simm)
 <-> 0b010111 @ 0b1 @ 0b00000 @ simm @ 0b011 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_MOVETYPEI(yd, simm)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_yd_unmasked()
   | not(y_valid_reg_group(yd, Y_LMUL_pow)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let imm_val : bits('m) = sign_extend(simm);
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
        result_view[i][j][k] = imm_val
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW, Y_LMUL_pow, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = Y_MOVETYPEI(yd, simm)
 <-> "ymv.y.i" ^ spc() ^ y_yreg_name(yd) ^ sep() ^ hex_bits_signed_5(simm)

// ******************** OPIVI (Whole Tensor Register Move) **********************
union clause instruction = Y_YMVRTYPE : (yregidx, {1, 2, 4, 8}, yregidx)

// "The number of vector registers to copy is encoded in the low three
// bits of the simm field (simm[2:0]) using the same encoding as the nf[2:0]
// field for memory instructions, i.e., simm[2:0] = NREG-1.
//
// The value of NREG must be 1, 2, 4, or 8, and values of simm[4:0] other
// than 0, 1, 3, and 7 are reserved."
mapping y_encdec_nreg : bits(5) <-> {1, 2, 4, 8} = {
 0b00000 <-> 1,
 0b00001 <-> 2,
 0b00011 <-> 4,
 0b00111 <-> 8,
}

mapping clause encdec = Y_YMVRTYPE(ys2, nreg, yd)
 <-> 0b100111 @ 0b1 @ y_encdec_yreg(ys2) @ y_encdec_nreg(nreg) @ 0b011 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YMVRTYPE(ys2, nreg, yd)) = {
  let start_element = y_get_start_element();
  let SEW = y_get_sew();
  let EMUL = nreg;

  let EMUL_pow : range(0, 3) = match EMUL {
    1 => 0,
    2 => 1,
    4 => 2,
    8 => 3,
  };
  let num_elem = y_get_num_elem(EMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, EMUL_pow)
   | y_illegal_yd_unmasked()
   | not(y_valid_reg_group(ys2, EMUL_pow))
   | not(y_valid_reg_group(yd, EMUL_pow)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, EMUL_pow, ys2);
  let yd_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, EMUL_pow, yd);
  var result : vector('n, bits('m)) = vector_init(zeros());

  {
    var result_view = y_shape(result, y_columns, y_depth);
    let yd_val_view = y_shape(yd_val, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(result_view));
      assert(i < length(yd_val_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      result_view[i][j][k] =
        if p < start_element then {
          yd_val_view[i][j][k]
        } else {
          ys2_val_view[i][j][k]
        }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW, EMUL_pow, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

// This is unfortunate. See https://github.com/rems-project/sail/issues/768
mapping y_nreg_string : {1, 2, 4, 8} <-> string = {
 1 <-> "1",
 2 <-> "2",
 4 <-> "4",
 8 <-> "8",
}

mapping clause assembly = Y_YMVRTYPE(ys2, nreg, yd)
 <-> "ymv" ^ y_nreg_string(nreg) ^ "r.y" ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2)

// ****************************** OPMVV (YYTYPE) ********************************
union clause instruction = Y_MYYTYPE : (y_myyfunct6, bits(1), yregidx, yregidx, yregidx)

mapping y_encdec_myyfunct6 : y_myyfunct6 <-> bits(6) = {
 Y_MYY_YAADDU      <-> 0b001000,
 Y_MYY_YAADD       <-> 0b001001,
 Y_MYY_YASUBU      <-> 0b001010,
 Y_MYY_YASUB       <-> 0b001011,
 Y_MYY_YMUL        <-> 0b100101,
 Y_MYY_YMULH       <-> 0b100111,
 Y_MYY_YMULHU      <-> 0b100100,
 Y_MYY_YMULHSU     <-> 0b100110,
 Y_MYY_YDIVU       <-> 0b100000,
 Y_MYY_YDIV        <-> 0b100001,
 Y_MYY_YREMU       <-> 0b100010,
 Y_MYY_YREM        <-> 0b100011
}

mapping clause encdec = Y_MYYTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_encdec_myyfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ y_encdec_yreg(ys1) @ 0b010 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64 & y_valid_wide_myytype(funct6))

function clause execute(Y_MYYTYPE(funct6, ym, ys2, ys1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_normal(yd, ym)
   | not(y_valid_reg_group(ys1, Y_LMUL_pow))
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_reg_group(yd, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys1, SEW))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW)) then {
    return Illegal_Instruction()
  };

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
          Y_MYY_YAADDU  => {
            let result_add = zero_extend(sizeof('m) + 1, ys2_val_view[i][j][k]) +
                zero_extend(sizeof('m) + 1, ys1_val_view[i][j][k]);
            let rounding_incr = y_get_fixed_rounding_incr(result_add, 1);
            (result_add >> 1)[sizeof('m) - 1 .. 0] + zero_extend(sizeof('m), rounding_incr)
          },
          Y_MYY_YAADD   => {
            let result_add = sign_extend(sizeof('m) + 1, ys2_val_view[i][j][k]) +
                sign_extend(sizeof('m) + 1, ys1_val_view[i][j][k]);
            let rounding_incr = y_get_fixed_rounding_incr(result_add, 1);
            (result_add >> 1)[sizeof('m) - 1 .. 0] + zero_extend(sizeof('m), rounding_incr)
          },
          Y_MYY_YASUBU  => {
            let result_sub = zero_extend(sizeof('m) + 1, ys2_val_view[i][j][k]) -
                zero_extend(sizeof('m) + 1, ys1_val_view[i][j][k]);
            let rounding_incr = y_get_fixed_rounding_incr(result_sub, 1);
            (result_sub >> 1)[sizeof('m) - 1 .. 0] + zero_extend(sizeof('m), rounding_incr)
          },
          Y_MYY_YASUB   => {
            let result_sub = sign_extend(sizeof('m) + 1, ys2_val_view[i][j][k]) -
                sign_extend(sizeof('m) + 1, ys1_val_view[i][j][k]);
            let rounding_incr = y_get_fixed_rounding_incr(result_sub, 1);
            (result_sub >> 1)[sizeof('m) - 1 .. 0] + zero_extend(sizeof('m), rounding_incr)
          },
          Y_MYY_YMUL    => mult_to_bits_half(
            SEW,
            Signed,
            Signed,
            ys2_val_view[i][j][k],
            ys1_val_view[i][j][k],
            Low,
          ),
          Y_MYY_YMULH   => mult_to_bits_half(
            SEW,
            Signed,
            Signed,
            ys2_val_view[i][j][k],
            ys1_val_view[i][j][k],
            High,
          ),
          Y_MYY_YMULHU  => mult_to_bits_half(
            SEW,
            Unsigned,
            Unsigned,
            ys2_val_view[i][j][k],
            ys1_val_view[i][j][k],
            High,
          ),
          Y_MYY_YMULHSU => mult_to_bits_half(
            SEW,
            Signed,
            Unsigned,
            ys2_val_view[i][j][k],
            ys1_val_view[i][j][k],
            High,
          ),
          Y_MYY_YDIVU   => {
            let divisor = unsigned(ys1_val_view[i][j][k]);
            let dividend = unsigned(ys2_val_view[i][j][k]);
            let q : int = if divisor == 0 then {
                -1
              } else {
                quot_round_zero(dividend, divisor)
              };
            to_bits_unsafe(SEW, q)
          },
          Y_MYY_YDIV    => {
            let elem_max : int = 2 ^ (SEW - 1) - 1;
            let elem_min : int = 0 - 2 ^ (SEW - 1);
            let divisor = signed(ys1_val_view[i][j][k]);
            let dividend = signed(ys2_val_view[i][j][k]);
            let q : int = if divisor == 0 then {
                -1
              } else {
                quot_round_zero(dividend, divisor)
              };

            // check for signed overflow
            let q' : int = if q > elem_max then { elem_min } else { q };
            to_bits_unsafe(SEW, q')
          },
          Y_MYY_YREMU   => {
            let divisor = unsigned(ys1_val_view[i][j][k]);
            let dividend = unsigned(ys2_val_view[i][j][k]);
            let r : int = if divisor == 0 then {
                dividend
              } else {
                rem_round_zero(dividend, divisor)
              };

            // signed overflow case returns zero naturally as required due to -1 divisor
            to_bits_unsafe(SEW, r)
          },
          Y_MYY_YREM    => {
            let divisor = signed(ys1_val_view[i][j][k]);
            let dividend = signed(ys2_val_view[i][j][k]);
            let r : int = if divisor == 0 then {
                dividend
              } else {
                rem_round_zero(dividend, divisor)
              };

            // signed overflow case returns zero naturally as required due to -1 divisor
            to_bits_unsafe(SEW, r)
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

mapping y_myytype_mnemonic : y_myyfunct6 <-> string = {
 Y_MYY_YAADDU   <-> "yaaddu.yy",
 Y_MYY_YAADD    <-> "yaadd.yy",
 Y_MYY_YASUBU   <-> "yasubu.yy",
 Y_MYY_YASUB    <-> "yasub.yy",
 Y_MYY_YMUL     <-> "ymul.yy",
 Y_MYY_YMULH    <-> "ymulh.yy",
 Y_MYY_YMULHU   <-> "ymulhu.yy",
 Y_MYY_YMULHSU  <-> "ymulhsu.yy",
 Y_MYY_YDIVU    <-> "ydivu.yy",
 Y_MYY_YDIV     <-> "ydiv.yy",
 Y_MYY_YREMU    <-> "yremu.yy",
 Y_MYY_YREM     <-> "yrem.yy"
}

mapping clause assembly = Y_MYYTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_myytype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ y_yreg_name(ys1) ^ y_maybe_ymask(ym)

// ************************ OPMVV (yytype Multiply-Add) *************************
// Multiply-Add instructions switch the order of source operands in assembly (ys1/rs1 before ys2)
union clause instruction = Y_MYYMATYPE : (y_myymafunct6, bits(1), yregidx, yregidx, yregidx)

mapping y_encdec_myymafunct6 : y_myymafunct6 <-> bits(6) = {
 Y_MYY_YMACC       <-> 0b101101,
 Y_MYY_YNMSAC      <-> 0b101111,
 Y_MYY_YMADD       <-> 0b101001,
 Y_MYY_YNMSUB      <-> 0b101011
}

mapping clause encdec = Y_MYYMATYPE(funct6, ym, ys2, ys1, yd)
 <-> y_encdec_myymafunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ y_encdec_yreg(ys1) @ 0b010 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_MYYMATYPE(funct6, ym, ys2, ys1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_normal(yd, ym)
   | not(y_valid_reg_group(ys1, Y_LMUL_pow))
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_reg_group(yd, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys1, SEW))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW)) then {
    return Illegal_Instruction()
  };

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
          Y_MYY_YMACC  => mult_to_bits_half(
            SEW,
            Signed,
            Signed,
            ys1_val_view[i][j][k],
            ys2_val_view[i][j][k],
            Low,
          ) +
            yd_val_view[i][j][k],
          Y_MYY_YNMSAC => yd_val_view[i][j][k] -
            mult_to_bits_half(SEW, Signed, Signed, ys1_val_view[i][j][k], ys2_val_view[i][j][k], Low),
          Y_MYY_YMADD  => mult_to_bits_half(
            SEW,
            Signed,
            Signed,
            ys1_val_view[i][j][k],
            yd_val_view[i][j][k],
            Low,
          ) +
            ys2_val_view[i][j][k],
          Y_MYY_YNMSUB => ys2_val_view[i][j][k] -
            mult_to_bits_half(SEW, Signed, Signed, ys1_val_view[i][j][k], yd_val_view[i][j][k], Low),
        }
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW, Y_LMUL_pow, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_myymatype_mnemonic : y_myymafunct6 <-> string = {
 Y_MYY_YMACC    <-> "ymacc.yy",
 Y_MYY_YNMSAC   <-> "ynmsac.yy",
 Y_MYY_YMADD    <-> "ymadd.yy",
 Y_MYY_YNMSUB   <-> "ynmsub.yy"
}

mapping clause assembly = Y_MYYMATYPE(funct6, ym, ys2, ys1, yd)
 <-> y_myymatype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys1) ^ sep() ^ y_yreg_name(ys2) ^ y_maybe_ymask(ym)

// ************************** OPMVV (YYTYPE Widening) ***************************
union clause instruction = Y_WIDE_YYTYPE : (y_wide_yyfunct6, bits(1), yregidx, yregidx, yregidx)
mapping y_encdec_wide_yyfunct6 : y_wide_yyfunct6 <-> bits(6) = {
 Y_WIDE_YY_YADD       <-> 0b110001,
 Y_WIDE_YY_YSUB       <-> 0b110011,
 Y_WIDE_YY_YADDU      <-> 0b110000,
 Y_WIDE_YY_YSUBU      <-> 0b110010,
 Y_WIDE_YY_YWMUL      <-> 0b111011,
 Y_WIDE_YY_YWMULU     <-> 0b111000,
 Y_WIDE_YY_YWMULSU    <-> 0b111010
}

mapping clause encdec = Y_WIDE_YYTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_encdec_wide_yyfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ y_encdec_yreg(ys1) @ 0b010 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 16)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 32)

function clause execute(Y_WIDE_YYTYPE(funct6, ym, ys2, ys1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = Y_LMUL_pow + 1;

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_variable_width(yd, ym, SEW_widen, LMUL_pow_widen)
   | not(y_valid_reg_overlap(ys1, yd, Y_LMUL_pow, LMUL_pow_widen))
   | not(y_valid_reg_overlap(ys2, yd, Y_LMUL_pow, LMUL_pow_widen))
   | not(y_valid_ym_src_overlap(ym, ys1, SEW))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);
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
          Y_WIDE_YY_YADD    => to_bits_unsafe(
            SEW_widen,
            signed(ys2_val_view[i][j][k]) + signed(ys1_val_view[i][j][k]),
          ),
          Y_WIDE_YY_YSUB    => to_bits_unsafe(
            SEW_widen,
            signed(ys2_val_view[i][j][k]) - signed(ys1_val_view[i][j][k]),
          ),
          Y_WIDE_YY_YADDU   => to_bits_unsafe(
            SEW_widen,
            unsigned(ys2_val_view[i][j][k]) + unsigned(ys1_val_view[i][j][k]),
          ),
          Y_WIDE_YY_YSUBU   => to_bits_unsafe(
            SEW_widen,
            unsigned(ys2_val_view[i][j][k]) - unsigned(ys1_val_view[i][j][k]),
          ),
          Y_WIDE_YY_YWMUL   => to_bits_unsafe(
            SEW_widen,
            signed(ys2_val_view[i][j][k]) * signed(ys1_val_view[i][j][k]),
          ),
          Y_WIDE_YY_YWMULU  => to_bits_unsafe(
            SEW_widen,
            unsigned(ys2_val_view[i][j][k]) * unsigned(ys1_val_view[i][j][k]),
          ),
          Y_WIDE_YY_YWMULSU => to_bits_unsafe(
            SEW_widen,
            signed(ys2_val_view[i][j][k]) * unsigned(ys1_val_view[i][j][k]),
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

mapping y_wide_yytype_mnemonic : y_wide_yyfunct6 <-> string = {
 Y_WIDE_YY_YADD       <-> "ywadd.yy",
 Y_WIDE_YY_YSUB       <-> "ywsub.yy",
 Y_WIDE_YY_YADDU      <-> "ywaddu.yy",
 Y_WIDE_YY_YSUBU      <-> "ywsubu.yy",
 Y_WIDE_YY_YWMUL      <-> "ywmul.yy",
 Y_WIDE_YY_YWMULU     <-> "ywmulu.yy",
 Y_WIDE_YY_YWMULSU    <-> "ywmulsu.yy"
}

mapping clause assembly = Y_WIDE_YYTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_wide_yytype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ y_yreg_name(ys1) ^ y_maybe_ymask(ym)

// ************************** OPMVV (WIDE_YTYPE Widening) ***************************
union clause instruction = Y_WIDE_YTYPE : (y_wide_yfunct6, bits(1), yregidx, yregidx, yregidx)

mapping y_encdec_wide_yfunct6 : y_wide_yfunct6 <-> bits(6) = {
 Y_WIDE_Y_YADD       <-> 0b110101,
 Y_WIDE_Y_YSUB       <-> 0b110111,
 Y_WIDE_Y_YADDU      <-> 0b110100,
 Y_WIDE_Y_YSUBU      <-> 0b110110
}

mapping clause encdec = Y_WIDE_YTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_encdec_wide_yfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ y_encdec_yreg(ys1) @ 0b010 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 16)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 32)

function clause execute(Y_WIDE_YTYPE(funct6, ym, ys2, ys1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = Y_LMUL_pow + 1;

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_variable_width(yd, ym, SEW_widen, LMUL_pow_widen)
   | not(y_valid_reg_overlap(ys1, yd, Y_LMUL_pow, LMUL_pow_widen))
   | not(y_valid_src_overlap(ys2, SEW_widen, LMUL_pow_widen, ys1, SEW, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys1, SEW))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW_widen)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);
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
          Y_WIDE_Y_YADD  => to_bits_unsafe(
            SEW_widen,
            signed(ys2_val_view[i][j][k]) + signed(ys1_val_view[i][j][k]),
          ),
          Y_WIDE_Y_YSUB  => to_bits_unsafe(
            SEW_widen,
            signed(ys2_val_view[i][j][k]) - signed(ys1_val_view[i][j][k]),
          ),
          Y_WIDE_Y_YADDU => to_bits_unsafe(
            SEW_widen,
            unsigned(ys2_val_view[i][j][k]) + unsigned(ys1_val_view[i][j][k]),
          ),
          Y_WIDE_Y_YSUBU => to_bits_unsafe(
            SEW_widen,
            unsigned(ys2_val_view[i][j][k]) - unsigned(ys1_val_view[i][j][k]),
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

mapping y_wide_ytype_mnemonic : y_wide_yfunct6 <-> string = {
 Y_WIDE_Y_YADD       <-> "ywadd.wide.yy",
 Y_WIDE_Y_YSUB       <-> "ywsub.wide.yy",
 Y_WIDE_Y_YADDU      <-> "ywaddu.wide.yy",
 Y_WIDE_Y_YSUBU      <-> "ywsubu.wide.yy"
}

mapping clause assembly = Y_WIDE_YTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_wide_ytype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ y_yreg_name(ys1) ^ y_maybe_ymask(ym)

// ******************* OPMVV (yytype Widening Multiply-Add) *********************
// Multiply-Add instructions switch the order of source operands in assembly (ys1/rs1 before ys2)
union clause instruction = Y_WIDE_MYYTYPE : (y_wide_myyfunct6, bits(1), yregidx, yregidx, yregidx)

mapping y_encdec_wide_myyfunct6 : y_wide_myyfunct6 <-> bits(6) = {
 Y_WIDE_MYY_YWMACCU   <-> 0b111100,
 Y_WIDE_MYY_YWMACC    <-> 0b111101,
 Y_WIDE_MYY_YWMACCSU  <-> 0b111111
}

mapping clause encdec =  Y_WIDE_MYYTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_encdec_wide_myyfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ y_encdec_yreg(ys1) @ 0b010 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 16)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 32)

function clause execute(Y_WIDE_MYYTYPE(funct6, ym, ys2, ys1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = Y_LMUL_pow + 1;

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_variable_width(yd, ym, SEW_widen, LMUL_pow_widen)
   | not(y_valid_reg_overlap(ys1, yd, Y_LMUL_pow, LMUL_pow_widen))
   | not(y_valid_reg_overlap(ys2, yd, Y_LMUL_pow, LMUL_pow_widen))
   | // yd is also a source register
    not(y_valid_src_overlap(ys1, SEW, Y_LMUL_pow, yd, SEW_widen, LMUL_pow_widen))
   | not(y_valid_src_overlap(ys2, SEW, Y_LMUL_pow, yd, SEW_widen, LMUL_pow_widen))
   | not(y_valid_ym_src_overlap(ym, ys1, SEW))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);
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
          Y_WIDE_MYY_YWMACC   => to_bits_unsafe(
            SEW_widen,
            signed(ys1_val_view[i][j][k]) * signed(ys2_val_view[i][j][k]),
          ) +
            yd_val_view[i][j][k],
          Y_WIDE_MYY_YWMACCU  => to_bits_unsafe(
            SEW_widen,
            unsigned(ys1_val_view[i][j][k]) * unsigned(ys2_val_view[i][j][k]),
          ) +
            yd_val_view[i][j][k],
          Y_WIDE_MYY_YWMACCSU => to_bits_unsafe(
            SEW_widen,
            signed(ys1_val_view[i][j][k]) * unsigned(ys2_val_view[i][j][k]),
          ) +
            yd_val_view[i][j][k],
        }
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_wide_myytype_mnemonic : y_wide_myyfunct6 <-> string = {
 Y_WIDE_MYY_YWMACCU     <-> "ywmaccu.yy",
 Y_WIDE_MYY_YWMACC      <-> "ywmacc.yy",
 Y_WIDE_MYY_YWMACCSU    <-> "ywmaccsu.yy"
}

mapping clause assembly = Y_WIDE_MYYTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_wide_myytype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys1) ^ sep() ^ y_yreg_name(ys2) ^ y_maybe_ymask(ym)

// ***************************** OPMVV (YXUNARY0) *******************************
// ****************** Tensor Integer Extension (SEW/2 source) *******************
union clause instruction = Y_YEXTTYPE : (y_yextfunct6, bits(1), yregidx, yregidx)

mapping y_yext_ys1 : y_yextfunct6 <-> bits(5) = {
 Y_YEXT2_ZVF2  <-> 0b00110,
 Y_YEXT2_SVF2  <-> 0b00111,
 Y_YEXT4_ZVF4  <-> 0b00100,
 Y_YEXT4_SVF4  <-> 0b00101,
 Y_YEXT8_ZVF8  <-> 0b00010,
 Y_YEXT8_SVF8  <-> 0b00011,
}

mapping clause encdec = Y_YEXTTYPE(funct6, ym, ys2, yd)
 <-> 0b010010 @ ym @ y_encdec_yreg(ys2) @ y_yext_ys1(funct6) @ 0b010 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YEXTTYPE(funct6, ym, ys2, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  let SEW_frac_pow : {1, 2, 3} = match funct6 {
    Y_YEXT2_ZVF2 => 1,
    Y_YEXT2_SVF2 => 1,
    Y_YEXT4_ZVF4 => 2,
    Y_YEXT4_SVF4 => 2,
    Y_YEXT8_ZVF8 => 3,
    Y_YEXT8_SVF8 => 3,
  };
  let LMUL_pow_div = Y_LMUL_pow - SEW_frac_pow;
  let SEW_div = SEW / (2 ^ SEW_frac_pow);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_variable_width(yd, ym, SEW_div, LMUL_pow_div)
   | not(y_valid_reg_overlap(ys2, yd, LMUL_pow_div, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW_div)) then {
    return Illegal_Instruction()
  };

  assert(SEW_div >= 8);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_div;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let yd_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, yd);
  let ys2_val : vector('n, bits('o)) = y_read_yreg(num_elem, SEW_div, LMUL_pow_div, ys2);

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
          Y_YEXT2_ZVF2 => zero_extend(ys2_val_view[i][j][k]),
          Y_YEXT2_SVF2 => sign_extend(ys2_val_view[i][j][k]),
          Y_YEXT4_ZVF4 => zero_extend(ys2_val_view[i][j][k]),
          Y_YEXT4_SVF4 => sign_extend(ys2_val_view[i][j][k]),
          Y_YEXT8_ZVF8 => zero_extend(ys2_val_view[i][j][k]),
          Y_YEXT8_SVF8 => sign_extend(ys2_val_view[i][j][k]),
        }
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW, Y_LMUL_pow, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_yexttype_mnemonic : y_yextfunct6 <-> string = {
 Y_YEXT2_ZVF2  <-> "yzext.yf2",
 Y_YEXT2_SVF2  <-> "ysext.yf2",
 Y_YEXT4_ZVF4  <-> "yzext.yf4",
 Y_YEXT4_SVF4  <-> "ysext.yf4",
 Y_YEXT8_ZVF8  <-> "yzext.yf8",
 Y_YEXT8_SVF8  <-> "ysext.yf8",
}

mapping clause assembly = Y_YEXTTYPE(funct6, ym, ys2, yd)
 <-> y_yexttype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ y_maybe_ymask(ym)

// *********************** OPMVV (vmv.x.s in YWXUNARY0) *************************
union clause instruction = Y_YMVXS : (yregidx, regidx)

mapping clause encdec = Y_YMVXS(ys2, rd)
 <-> 0b010000 @ 0b1 @ y_encdec_yreg(ys2) @ 0b00000 @ 0b010 @ encdec_reg(rd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YMVXS(ys2, rd)) = {
  let SEW = y_get_sew();
  let num_elem = y_get_num_elem(0, SEW);

  // Scalar move instructions disregard LMUL, but for the purposes of finding an illegal ystart,
  // some implementations use LMUL for the bounds check, and this helps match those implementations.
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem_ystart = y_get_num_elem(Y_LMUL_pow, SEW);

  if y_illegal_ystart(Y_YSTART_SCALAR_MOVE, num_elem_ystart, Y_LMUL_pow) | y_illegal_yd_unmasked() then {
    return Illegal_Instruction()
  };

  assert(num_elem > 0);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, 0, ys2);
  X(rd) =
    if xlen < SEW then {
      y_shape(ys2_val, y_columns, y_depth)[0][0][0][xlen - 1 .. 0]
    } else {
      if xlen > SEW then {
        sign_extend(y_shape(ys2_val, y_columns, y_depth)[0][0][0])
      } else {
        y_shape(ys2_val, y_columns, y_depth)[0][0][0]
      }
    };
  y_set_ystart(zeros());

  RETIRE_SUCCESS
}

mapping clause assembly = Y_YMVXS(ys2, rd)
 <-> "ymv.x.s" ^ spc() ^ reg_name(rd) ^ sep() ^ y_yreg_name(ys2)

// ******************** OPMVV (Tensor Compress Instruction) *********************
union clause instruction = Y_MYYCOMPRESS : (yregidx, yregidx, yregidx)

mapping clause encdec = Y_MYYCOMPRESS(ys2, ys1, yd)
 <-> 0b010111 @ 0b1 @ y_encdec_yreg(ys2) @ y_encdec_yreg(ys1) @ 0b010 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_MYYCOMPRESS(ys2, ys1, yd)) = {
  let start_element = y_get_start_element();
  let end_element = y_get_end_element();
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if    y_illegal_ystart(Y_YSTART_MANDATORY, num_elem, Y_LMUL_pow)
   |  y_illegal_yd_unmasked()
   |  not(y_valid_disjoint_reg_groups(ys1, yd, 0, Y_LMUL_pow))
   |  ys2
   == yd
   |  not(y_valid_src_overlap(ys2, SEW, Y_LMUL_pow, ys1, 1, 0)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ys1_val : bits('n) = y_read_ymask(num_elem, 0b0, ys1);
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, ys2);
  let yd_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, yd);
  var result : vector('n, bits('m)) = vector_init(zeros());

  // body elements
  var yd_idx : nat = 0;
  {
    var result_view = y_shape(result, y_columns, y_depth);
    let ys1_val_view = y_shape(ys1_val, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(result_view));
      assert(i < length(ys1_val_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if p <= end_element then {
        if ys1_val_view[i][j][k] == 0b1 then {
          let (p as 'p) = yd_idx;
          assert(sizeof('p) < sizeof('n));
          result_view[sizeof('p) / (y_columns * y_depth)][(sizeof('p) / y_depth) % y_columns][
            sizeof('p) % y_depth
          ] =
            ys2_val_view[i][j][k];
          yd_idx = yd_idx + 1
        }
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  // tail elements
  if yd_idx < num_elem then {
    let tail_ag : y_agtype = y_get_ytype_yta();
    let (p as 'p) = yd_idx;
    {
      var result_view = y_shape(result, y_columns, y_depth);
      let yd_val_view = y_shape(yd_val, y_columns, y_depth);
      foreach (p from sizeof('p) to (num_elem - 1)) {
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
    }
  };

  y_write_yreg(num_elem, SEW, Y_LMUL_pow, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = Y_MYYCOMPRESS(ys2, ys1, yd)
 <-> "ycompress.ym" ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ y_yreg_name(ys1)

// ****************************** OPMVX (YXTYPE) ********************************
union clause instruction = Y_MYXTYPE : (y_myxfunct6, bits(1), yregidx, regidx, yregidx)

mapping y_encdec_myxfunct6 : y_myxfunct6 <-> bits(6) = {
 Y_MYX_YAADDU        <-> 0b001000,
 Y_MYX_YAADD         <-> 0b001001,
 Y_MYX_YASUBU        <-> 0b001010,
 Y_MYX_YASUB         <-> 0b001011,
 Y_MYX_YSLIDE1UP     <-> 0b001110,
 Y_MYX_YSLIDE1DOWN   <-> 0b001111,
 Y_MYX_YMUL          <-> 0b100101,
 Y_MYX_YMULH         <-> 0b100111,
 Y_MYX_YMULHU        <-> 0b100100,
 Y_MYX_YMULHSU       <-> 0b100110,
 Y_MYX_YDIVU         <-> 0b100000,
 Y_MYX_YDIV          <-> 0b100001,
 Y_MYX_YREMU         <-> 0b100010,
 Y_MYX_YREM          <-> 0b100011
}

// vmulh.yx, vmulhu.yx and vmulhsu.yx are not included for EEW=64 in Zve64*.
mapping clause encdec = Y_MYXTYPE(funct6, ym, ys2, rs1, yd)
 <-> y_encdec_myxfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ encdec_reg(rs1) @ 0b110 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64 & y_valid_wide_myxtype(funct6))

function clause execute(Y_MYXTYPE(funct6, ym, ys2, rs1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  // "The vslide1up instruction requires that the destination vector
  // register group does not overlap the source vector register
  // group. Otherwise, the instruction encoding is reserved."
  let src_dst_overlap = funct6 == Y_MYX_YSLIDE1UP & ys2 == yd;
  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_normal(yd, ym)
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_reg_group(yd, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW))
   | src_dst_overlap then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let rs1_val : bits('m) = y_get_scalar(rs1, SEW);
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
          Y_MYX_YAADDU      => {
            let result_add = zero_extend(sizeof('m) + 1, ys2_val_view[i][j][k]) +
                zero_extend(sizeof('m) + 1, rs1_val);
            let rounding_incr = y_get_fixed_rounding_incr(result_add, 1);
            (result_add >> 1)[sizeof('m) - 1 .. 0] + zero_extend(sizeof('m), rounding_incr)
          },
          Y_MYX_YAADD       => {
            let result_add = sign_extend(sizeof('m) + 1, ys2_val_view[i][j][k]) +
                sign_extend(sizeof('m) + 1, rs1_val);
            let rounding_incr = y_get_fixed_rounding_incr(result_add, 1);
            (result_add >> 1)[sizeof('m) - 1 .. 0] + zero_extend(sizeof('m), rounding_incr)
          },
          Y_MYX_YASUBU      => {
            let result_sub = zero_extend(sizeof('m) + 1, ys2_val_view[i][j][k]) -
                zero_extend(sizeof('m) + 1, rs1_val);
            let rounding_incr = y_get_fixed_rounding_incr(result_sub, 1);
            (result_sub >> 1)[sizeof('m) - 1 .. 0] + zero_extend(sizeof('m), rounding_incr)
          },
          Y_MYX_YASUB       => {
            let result_sub = sign_extend(sizeof('m) + 1, ys2_val_view[i][j][k]) -
                sign_extend(sizeof('m) + 1, rs1_val);
            let rounding_incr = y_get_fixed_rounding_incr(result_sub, 1);
            (result_sub >> 1)[sizeof('m) - 1 .. 0] + zero_extend(sizeof('m), rounding_incr)
          },
          Y_MYX_YSLIDE1UP   => if p == 0 then {
            rs1_val
          } else {
            ys2_val_view[(p - 1) / (y_columns * y_depth)][((p - 1) / y_depth) % y_columns][
              (p - 1) % y_depth
            ]
          },
          Y_MYX_YSLIDE1DOWN => {
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
          Y_MYX_YMUL        => mult_to_bits_half(SEW, Signed, Signed, ys2_val_view[i][j][k], rs1_val, Low),
          Y_MYX_YMULH       => mult_to_bits_half(SEW, Signed, Signed, ys2_val_view[i][j][k], rs1_val, High),
          Y_MYX_YMULHU      => mult_to_bits_half(SEW, Unsigned, Unsigned, ys2_val_view[i][j][k], rs1_val, High),
          Y_MYX_YMULHSU     => mult_to_bits_half(SEW, Signed, Unsigned, ys2_val_view[i][j][k], rs1_val, High),
          Y_MYX_YDIVU       => {
            let divisor = unsigned(rs1_val);
            let dividend = unsigned(ys2_val_view[i][j][k]);
            let q : int = if divisor == 0 then {
                -1
              } else {
                quot_round_zero(dividend, divisor)
              };
            to_bits_unsafe(SEW, q)
          },
          Y_MYX_YDIV        => {
            let elem_max : int = 2 ^ (SEW - 1) - 1;
            let elem_min : int = 0 - 2 ^ (SEW - 1);
            let divisor = signed(rs1_val);
            let dividend = signed(ys2_val_view[i][j][k]);
            let q : int = if divisor == 0 then {
                -1
              } else {
                quot_round_zero(dividend, divisor)
              };

            // check for signed overflow
            let q' : int = if q > elem_max then { elem_min } else { q };
            to_bits_unsafe(SEW, q')
          },
          Y_MYX_YREMU       => {
            let divisor = unsigned(rs1_val);
            let dividend = unsigned(ys2_val_view[i][j][k]);
            let r : int = if divisor == 0 then {
                dividend
              } else {
                rem_round_zero(dividend, divisor)
              };

            // signed overflow case returns zero naturally as required due to -1 divisor
            to_bits_unsafe(SEW, r)
          },
          Y_MYX_YREM        => {
            let divisor = signed(rs1_val);
            let dividend = signed(ys2_val_view[i][j][k]);
            let r : int = if divisor == 0 then {
                dividend
              } else {
                rem_round_zero(dividend, divisor)
              };

            // signed overflow case returns zero naturally as required due to -1 divisor
            to_bits_unsafe(SEW, r)
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

mapping y_myxtype_mnemonic : y_myxfunct6 <-> string = {
 Y_MYX_YAADDU        <-> "yaaddu.yx",
 Y_MYX_YAADD         <-> "yaadd.yx",
 Y_MYX_YASUBU        <-> "yasubu.yx",
 Y_MYX_YASUB         <-> "yasub.yx",
 Y_MYX_YSLIDE1UP     <-> "yslide1up.yx",
 Y_MYX_YSLIDE1DOWN   <-> "yslide1down.yx",
 Y_MYX_YMUL          <-> "ymul.yx",
 Y_MYX_YMULH         <-> "ymulh.yx",
 Y_MYX_YMULHU        <-> "ymulhu.yx",
 Y_MYX_YMULHSU       <-> "ymulhsu.yx",
 Y_MYX_YDIVU         <-> "ydivu.yx",
 Y_MYX_YDIV          <-> "ydiv.yx",
 Y_MYX_YREMU         <-> "yremu.yx",
 Y_MYX_YREM          <-> "yrem.yx"
}

mapping clause assembly = Y_MYXTYPE(funct6, ym, ys2, rs1, yd)
 <-> y_myxtype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ reg_name(rs1) ^ y_maybe_ymask(ym)

// ************************ OPMVX (yxtype Multiply-Add) *************************
// Multiply-Add instructions switch the order of source operands in assembly (ys1/rs1 before ys2)
union clause instruction = Y_MYXMATYPE : (y_myxmafunct6, bits(1), yregidx, regidx, yregidx)

mapping y_encdec_myxmafunct6 : y_myxmafunct6 <-> bits(6) = {
 Y_MYX_YMACC         <-> 0b101101,
 Y_MYX_YNMSAC        <-> 0b101111,
 Y_MYX_YMADD         <-> 0b101001,
 Y_MYX_YNMSUB        <-> 0b101011
}

mapping clause encdec = Y_MYXMATYPE(funct6, ym, ys2, rs1, yd)
 <-> y_encdec_myxmafunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ encdec_reg(rs1) @ 0b110 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_MYXMATYPE(funct6, ym, ys2, rs1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_normal(yd, ym)
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_reg_group(yd, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let rs1_val : bits('m) = y_get_scalar(rs1, SEW);
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
          Y_MYX_YMACC  => mult_to_bits_half(SEW, Signed, Signed, rs1_val, ys2_val_view[i][j][k], Low) +
            yd_val_view[i][j][k],
          Y_MYX_YNMSAC => yd_val_view[i][j][k] -
            mult_to_bits_half(SEW, Signed, Signed, rs1_val, ys2_val_view[i][j][k], Low),
          Y_MYX_YMADD  => mult_to_bits_half(SEW, Signed, Signed, rs1_val, yd_val_view[i][j][k], Low) +
            ys2_val_view[i][j][k],
          Y_MYX_YNMSUB => ys2_val_view[i][j][k] -
            mult_to_bits_half(SEW, Signed, Signed, rs1_val, yd_val_view[i][j][k], Low),
        }
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW, Y_LMUL_pow, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_myxmatype_mnemonic : y_myxmafunct6 <-> string = {
 Y_MYX_YMACC         <-> "ymacc.yx",
 Y_MYX_YNMSAC        <-> "ynmsac.yx",
 Y_MYX_YMADD         <-> "ymadd.yx",
 Y_MYX_YNMSUB        <-> "ynmsub.yx"
}

mapping clause assembly = Y_MYXMATYPE(funct6, ym, ys2, rs1, yd)
 <-> y_myxmatype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ reg_name(rs1) ^ sep() ^ y_yreg_name(ys2) ^ y_maybe_ymask(ym)

// ************************** OPMVX (YXTYPE Widening) ***************************
union clause instruction = Y_WIDE_YXTYPE : (y_wide_yxfunct6, bits(1), yregidx, regidx, yregidx)

mapping y_encdec_wide_yxfunct6 : y_wide_yxfunct6 <-> bits(6) = {
 Y_WIDE_YX_YADD       <-> 0b110001,
 Y_WIDE_YX_YSUB       <-> 0b110011,
 Y_WIDE_YX_YADDU      <-> 0b110000,
 Y_WIDE_YX_YSUBU      <-> 0b110010,
 Y_WIDE_YX_YWMUL      <-> 0b111011,
 Y_WIDE_YX_YWMULU     <-> 0b111000,
 Y_WIDE_YX_YWMULSU    <-> 0b111010
}

mapping clause encdec = Y_WIDE_YXTYPE(funct6, ym, ys2, rs1, yd)
 <-> y_encdec_wide_yxfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ encdec_reg(rs1) @ 0b110 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 16)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 32)

function clause execute(Y_WIDE_YXTYPE(funct6, ym, ys2, rs1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = Y_LMUL_pow + 1;

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_variable_width(yd, ym, SEW_widen, LMUL_pow_widen)
   | not(y_valid_reg_overlap(ys2, yd, Y_LMUL_pow, LMUL_pow_widen))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let yd_val : vector('n, bits('o)) = y_read_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd);
  let rs1_val : bits('m) = y_get_scalar(rs1, SEW);
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
          Y_WIDE_YX_YADD    => to_bits_unsafe(SEW_widen, signed(ys2_val_view[i][j][k]) + signed(rs1_val)),
          Y_WIDE_YX_YSUB    => to_bits_unsafe(SEW_widen, signed(ys2_val_view[i][j][k]) - signed(rs1_val)),
          Y_WIDE_YX_YADDU   => to_bits_unsafe(SEW_widen, unsigned(ys2_val_view[i][j][k]) + unsigned(rs1_val)),
          Y_WIDE_YX_YSUBU   => to_bits_unsafe(SEW_widen, unsigned(ys2_val_view[i][j][k]) - unsigned(rs1_val)),
          Y_WIDE_YX_YWMUL   => to_bits_unsafe(SEW_widen, signed(ys2_val_view[i][j][k]) * signed(rs1_val)),
          Y_WIDE_YX_YWMULU  => to_bits_unsafe(SEW_widen, unsigned(ys2_val_view[i][j][k]) * unsigned(rs1_val)),
          Y_WIDE_YX_YWMULSU => to_bits_unsafe(SEW_widen, signed(ys2_val_view[i][j][k]) * unsigned(rs1_val)),
        }
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_wide_yxtype_mnemonic : y_wide_yxfunct6 <-> string = {
 Y_WIDE_YX_YADD       <-> "ywadd.yx",
 Y_WIDE_YX_YSUB       <-> "ywsub.yx",
 Y_WIDE_YX_YADDU      <-> "ywaddu.yx",
 Y_WIDE_YX_YSUBU      <-> "ywsubu.yx",
 Y_WIDE_YX_YWMUL      <-> "ywmul.yx",
 Y_WIDE_YX_YWMULU     <-> "ywmulu.yx",
 Y_WIDE_YX_YWMULSU    <-> "ywmulsu.yx"
}

mapping clause assembly = Y_WIDE_YXTYPE(funct6, ym, ys2, rs1, yd)
 <-> y_wide_yxtype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ reg_name(rs1) ^ y_maybe_ymask(ym)

// ************************** OPMVX (WIDE_XTYPE Widening) ***************************
union clause instruction = Y_WIDE_XTYPE : (y_wide_xfunct6, bits(1), yregidx, regidx, yregidx)

mapping y_encdec_wide_xfunct6 : y_wide_xfunct6 <-> bits(6) = {
 Y_WIDE_X_YADD       <-> 0b110101,
 Y_WIDE_X_YSUB       <-> 0b110111,
 Y_WIDE_X_YADDU      <-> 0b110100,
 Y_WIDE_X_YSUBU      <-> 0b110110
}

mapping clause encdec = Y_WIDE_XTYPE(funct6, ym, ys2, rs1, yd)
 <-> y_encdec_wide_xfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ encdec_reg(rs1) @ 0b110 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 16)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 32)

function clause execute(Y_WIDE_XTYPE(funct6, ym, ys2, rs1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = Y_LMUL_pow + 1;

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_variable_width(yd, ym, SEW_widen, LMUL_pow_widen)
   | not(y_valid_reg_group(ys2, LMUL_pow_widen))
   | not(y_valid_reg_group(yd, LMUL_pow_widen))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW_widen)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let yd_val : vector('n, bits('o)) = y_read_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd);
  let rs1_val : bits('m) = y_get_scalar(rs1, SEW);
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
          Y_WIDE_X_YADD  => to_bits_unsafe(SEW_widen, signed(ys2_val_view[i][j][k]) + signed(rs1_val)),
          Y_WIDE_X_YSUB  => to_bits_unsafe(SEW_widen, signed(ys2_val_view[i][j][k]) - signed(rs1_val)),
          Y_WIDE_X_YADDU => to_bits_unsafe(SEW_widen, unsigned(ys2_val_view[i][j][k]) + unsigned(rs1_val)),
          Y_WIDE_X_YSUBU => to_bits_unsafe(SEW_widen, unsigned(ys2_val_view[i][j][k]) - unsigned(rs1_val)),
        }
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_wide_xtype_mnemonic : y_wide_xfunct6 <-> string = {
 Y_WIDE_X_YADD       <-> "ywadd.wide.yx",
 Y_WIDE_X_YSUB       <-> "ywsub.wide.yx",
 Y_WIDE_X_YADDU      <-> "ywaddu.wide.yx",
 Y_WIDE_X_YSUBU      <-> "ywsubu.wide.yx"
}

mapping clause assembly = Y_WIDE_XTYPE(funct6, ym, ys2, rs1, yd)
 <-> y_wide_xtype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ reg_name(rs1) ^ y_maybe_ymask(ym)

// ******************* OPMVX (yxtype Widening Multiply-Add) *********************
// Multiply-Add instructions switch the order of source operands in assembly (ys1/rs1 before ys2)
union clause instruction =  Y_WIDE_MYXTYPE : (y_wide_myxfunct6, bits(1), yregidx, regidx, yregidx)

mapping y_encdec_wide_myxfunct6 : y_wide_myxfunct6 <-> bits(6) = {
 Y_WIDE_MYX_YWMACCU    <-> 0b111100,
 Y_WIDE_MYX_YWMACC     <-> 0b111101,
 Y_WIDE_MYX_YWMACCUS   <-> 0b111110,
 Y_WIDE_MYX_YWMACCSU   <-> 0b111111
}

mapping clause encdec = Y_WIDE_MYXTYPE(funct6, ym, ys2, rs1, yd)
 <-> y_encdec_wide_myxfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ encdec_reg(rs1) @ 0b110 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 16)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 32)

function clause execute(Y_WIDE_MYXTYPE(funct6, ym, ys2, rs1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = Y_LMUL_pow + 1;

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_variable_width(yd, ym, SEW_widen, LMUL_pow_widen)
   | not(y_valid_reg_overlap(ys2, yd, Y_LMUL_pow, LMUL_pow_widen))
   | // yd is also a source register
    not(y_valid_src_overlap(ys2, SEW, Y_LMUL_pow, yd, SEW_widen, LMUL_pow_widen))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let yd_val : vector('n, bits('o)) = y_read_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd);
  let rs1_val : bits('m) = y_get_scalar(rs1, SEW);
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
          Y_WIDE_MYX_YWMACCU  => to_bits_unsafe(SEW_widen, unsigned(rs1_val) * unsigned(ys2_val_view[i][j][k])) +
            yd_val_view[i][j][k],
          Y_WIDE_MYX_YWMACC   => to_bits_unsafe(SEW_widen, signed(rs1_val) * signed(ys2_val_view[i][j][k])) +
            yd_val_view[i][j][k],
          Y_WIDE_MYX_YWMACCUS => to_bits_unsafe(SEW_widen, unsigned(rs1_val) * signed(ys2_val_view[i][j][k])) +
            yd_val_view[i][j][k],
          Y_WIDE_MYX_YWMACCSU => to_bits_unsafe(SEW_widen, signed(rs1_val) * unsigned(ys2_val_view[i][j][k])) +
            yd_val_view[i][j][k],
        }
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_wide_myxtype_mnemonic : y_wide_myxfunct6 <-> string = {
 Y_WIDE_MYX_YWMACCU     <-> "ywmaccu.yx",
 Y_WIDE_MYX_YWMACC      <-> "ywmacc.yx",
 Y_WIDE_MYX_YWMACCUS    <-> "ywmaccus.yx",
 Y_WIDE_MYX_YWMACCSU    <-> "ywmaccsu.yx"
}

mapping clause assembly = Y_WIDE_MYXTYPE(funct6, ym, ys2, rs1, yd)
 <-> y_wide_myxtype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ reg_name(rs1) ^ sep() ^ y_yreg_name(ys2) ^ y_maybe_ymask(ym)

// ***************************** OPMVX (YRXUNARY0) ******************************
union clause instruction = Y_YMVSX : (regidx, yregidx)

mapping clause encdec = Y_YMVSX(rs1, yd)
 <-> 0b010000 @ 0b1 @ 0b00000 @ encdec_reg(rs1) @ 0b110 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YMVSX(rs1, yd)) = {
  let SEW = y_get_sew();
  let num_elem = y_get_num_elem(0, SEW);

  // See above comment in YMVXS for why LMUL is used here
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem_ystart = y_get_num_elem(Y_LMUL_pow, SEW);

  if y_illegal_ystart(Y_YSTART_SCALAR_MOVE, num_elem_ystart, Y_LMUL_pow) | y_illegal_yd_unmasked() then {
    return Illegal_Instruction()
  };

  assert(num_elem > 0);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let rs1_val : bits('m) = y_get_scalar(rs1, sizeof('m));
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

mapping clause assembly = Y_YMVSX(rs1, yd)
 <-> "ymv.s.x" ^ spc() ^ y_yreg_name(yd) ^ sep() ^ reg_name(rs1)
