// =======================================================================================
// This Sail RISC-Y architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

// ******************************************************************************
// This file implements part of the tensor extension.
// Mask instructions from Chap 13 (floating-point)
// ******************************************************************************

// ****************************** OPFVV (YYMTYPE) *******************************
// FYYM instructions' destination is a mask register
union clause instruction = Y_FYYMTYPE : (y_fyymfunct6, bits(1), yregidx, yregidx, yregidx)

mapping y_encdec_fyymfunct6 : y_fyymfunct6 <-> bits(6) = {
 Y_FYYM_YMFEQ      <-> 0b011000,
 Y_FYYM_YMFLE      <-> 0b011001,
 Y_FYYM_YMFLT      <-> 0b011011,
 Y_FYYM_YMFNE      <-> 0b011100
}

mapping clause encdec = Y_FYYMTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_encdec_fyymfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ y_encdec_yreg(ys1) @ 0b001 @ y_encdec_yreg(yd) @ 0b0101011
 when ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh))   & y_get_sew() == 16)
  | ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_F)) & y_get_sew() == 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 64)

function clause execute(Y_FYYMTYPE(funct6, ym, ys2, ys1, yd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_fp_yd_unmasked(SEW, rm_3b)
   | not(y_valid_reg_group(ys1, Y_LMUL_pow))
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
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
          Y_FYYM_YMFEQ => y_fp_eq(ys2_val_view[i][j][k], ys1_val_view[i][j][k]),
          Y_FYYM_YMFNE => ~(y_fp_eq(ys2_val_view[i][j][k], ys1_val_view[i][j][k])),
          Y_FYYM_YMFLE => y_fp_le(ys2_val_view[i][j][k], ys1_val_view[i][j][k]),
          Y_FYYM_YMFLT => y_fp_lt(ys2_val_view[i][j][k], ys1_val_view[i][j][k]),
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

mapping y_fyymtype_mnemonic : y_fyymfunct6 <-> string = {
 Y_FYYM_YMFEQ      <-> "ymfeq.yy",
 Y_FYYM_YMFLE      <-> "ymfle.yy",
 Y_FYYM_YMFLT      <-> "ymflt.yy",
 Y_FYYM_YMFNE      <-> "ymfne.yy"
}

mapping clause assembly = Y_FYYMTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_fyymtype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ y_yreg_name(ys1) ^ y_maybe_ymask(ym)

// ****************************** OPFVF (YFMTYPE) *******************************
// YFM instructions' destination is a mask register
union clause instruction = Y_FYFMTYPE : (y_fyfmfunct6, bits(1), yregidx, fregidx, yregidx)

mapping y_encdec_fyfmfunct6 : y_fyfmfunct6 <-> bits(6) = {
 Y_YFM_YMFEQ      <-> 0b011000,
 Y_YFM_YMFLE      <-> 0b011001,
 Y_YFM_YMFLT      <-> 0b011011,
 Y_YFM_YMFNE      <-> 0b011100,
 Y_YFM_YMFGT      <-> 0b011101,
 Y_YFM_YMFGE      <-> 0b011111
}

mapping clause encdec = Y_FYFMTYPE(funct6, ym, ys2, rs1, yd)
 <-> y_encdec_fyfmfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ encdec_freg(rs1) @ 0b101 @ y_encdec_yreg(yd) @ 0b0101011
 when ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh))   & y_get_sew() == 16)
  | ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_F)) & y_get_sew() == 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 64)

function clause execute(Y_FYFMTYPE(funct6, ym, ys2, rs1, yd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_fp_yd_unmasked(SEW, rm_3b)
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW != 8);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let rs1_val : bits('m) = y_get_scalar_fp(rs1, sizeof('m));
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
          Y_YFM_YMFEQ => y_fp_eq(ys2_val_view[i][j][k], rs1_val),
          Y_YFM_YMFNE => ~(y_fp_eq(ys2_val_view[i][j][k], rs1_val)),
          Y_YFM_YMFLE => y_fp_le(ys2_val_view[i][j][k], rs1_val),
          Y_YFM_YMFLT => y_fp_lt(ys2_val_view[i][j][k], rs1_val),
          Y_YFM_YMFGE => y_fp_ge(ys2_val_view[i][j][k], rs1_val),
          Y_YFM_YMFGT => y_fp_gt(ys2_val_view[i][j][k], rs1_val),
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

mapping y_fyfmtype_mnemonic : y_fyfmfunct6 <-> string = {
 Y_YFM_YMFEQ      <-> "ymfeq.yf",
 Y_YFM_YMFLE      <-> "ymfle.yf",
 Y_YFM_YMFLT      <-> "ymflt.yf",
 Y_YFM_YMFNE      <-> "ymfne.yf",
 Y_YFM_YMFGT      <-> "ymfgt.yf",
 Y_YFM_YMFGE      <-> "ymfge.yf"
}

mapping clause assembly = Y_FYFMTYPE(funct6, ym, ys2, rs1, yd)
 <-> y_fyfmtype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ freg_name(rs1) ^ y_maybe_ymask(ym)
