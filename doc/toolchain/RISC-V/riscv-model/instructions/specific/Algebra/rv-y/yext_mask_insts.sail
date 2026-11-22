// =======================================================================================
// This Sail RISC-Y architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

// ******************************************************************************
// This file implements part of the tensor extension.
// Chapter 15: tensor mask instructions
// ******************************************************************************

// ****************************** OPMVV (MMTYPE) ********************************
union clause instruction = Y_MMTYPE : (y_mmfunct6, yregidx, yregidx, yregidx)

mapping y_encdec_mmfunct6 : y_mmfunct6 <-> bits(6) = {
 Y_MM_YMAND     <-> 0b011001,
 Y_MM_YMNAND    <-> 0b011101,
 Y_MM_YMANDN    <-> 0b011000,
 Y_MM_YMXOR     <-> 0b011011,
 Y_MM_YMOR      <-> 0b011010,
 Y_MM_YMNOR     <-> 0b011110,
 Y_MM_YMORN     <-> 0b011100,
 Y_MM_YMXNOR    <-> 0b011111
}

mapping clause encdec = Y_MMTYPE(funct6, ys2, ys1, yd)
 <-> y_encdec_mmfunct6(funct6) @ 0b1 @ y_encdec_yreg(ys2) @ y_encdec_yreg(ys1) @ 0b010 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_MMTYPE(funct6, ys2, ys1, yd)) = {
  let SEW = y_get_sew();
  let num_elem = ylen;

  if y_illegal_yd_unmasked() | y_illegal_ystart(Y_YSTART_ARITH, num_elem, 0) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ys1_val : bits('n) = y_read_ymask(num_elem, 0b0, ys1);
  let ys2_val : bits('n) = y_read_ymask(num_elem, 0b0, ys2);
  let yd_val : bits('n) = y_read_ymask(num_elem, 0b0, yd);

  let (initial_result, mask) : (bits('n), bits('n)) = y_init_masked_result_carry(num_elem, SEW, 0, yd_val);
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
          Y_MM_YMAND  => bool_to_bit((ys2_val_view[i][j][k] == bitone) & (ys1_val_view[i][j][k] == bitone)),
          Y_MM_YMNAND => bool_to_bit(
            not((ys2_val_view[i][j][k] == bitone) & (ys1_val_view[i][j][k] == bitone)),
          ),
          Y_MM_YMANDN => bool_to_bit((ys2_val_view[i][j][k] == bitone) & not(ys1_val_view[i][j][k] == bitone)),
          Y_MM_YMXOR  => bool_to_bit((ys2_val_view[i][j][k] == bitone) != (ys1_val_view[i][j][k] == bitone)),
          Y_MM_YMOR   => bool_to_bit((ys2_val_view[i][j][k] == bitone) | (ys1_val_view[i][j][k] == bitone)),
          Y_MM_YMNOR  => bool_to_bit(
            not((ys2_val_view[i][j][k] == bitone) | (ys1_val_view[i][j][k] == bitone)),
          ),
          Y_MM_YMORN  => bool_to_bit((ys2_val_view[i][j][k] == bitone) | not(ys1_val_view[i][j][k] == bitone)),
          Y_MM_YMXNOR => bool_to_bit((ys2_val_view[i][j][k] == bitone) == (ys1_val_view[i][j][k] == bitone)),
        }
      }
    };
    result = y_unshape_bits(length(result), result_view, y_columns, y_depth)
  };

  y_write_ymask(num_elem, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_mmtype_mnemonic : y_mmfunct6 <-> string = {
 Y_MM_YMAND     <-> "ymand.mm",
 Y_MM_YMNAND    <-> "ymnand.mm",
 Y_MM_YMANDN    <-> "ymandn.mm",
 Y_MM_YMXOR     <-> "ymxor.mm",
 Y_MM_YMOR      <-> "ymor.mm",
 Y_MM_YMNOR     <-> "ymnor.mm",
 Y_MM_YMORN     <-> "ymorn.mm",
 Y_MM_YMXNOR    <-> "ymxnor.mm"
}

mapping clause assembly = Y_MMTYPE(funct6, ys2, ys1, yd)
 <-> y_mmtype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ y_yreg_name(ys1)

// ************************ OPMVV (vcpop in YWXUNARY0) **************************
union clause instruction = Y_YCPOP_M : (bits(1), yregidx, regidx)

mapping clause encdec = Y_YCPOP_M(ym, ys2, rd)
 <-> 0b010000 @ ym @ y_encdec_yreg(ys2) @ 0b10000 @ 0b010 @ encdec_reg(rd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YCPOP_M(ym, ys2, rd)) = {
  let num_elem = ylen;

  if y_illegal_yd_unmasked() | y_illegal_ystart(Y_YSTART_MANDATORY, num_elem, 0) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let ys2_val : bits('n) = y_read_ymask(num_elem, 0b0, ys2);

  let mask : bits('n) = y_init_masked_source(num_elem, 0, ym_val);

  X(rd) = to_bits(xlen, count_ones(mask & ys2_val));
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = Y_YCPOP_M(ym, ys2, rd)
 <-> "ycpop.m" ^ spc() ^ reg_name(rd) ^ sep() ^ y_yreg_name(ys2) ^ y_maybe_ymask(ym)

// ************************ OPMVV (vfirst in YWXUNARY0) *************************
union clause instruction = Y_YFIRST_M : (bits(1), yregidx, regidx)

mapping clause encdec = Y_YFIRST_M(ym, ys2, rd)
 <-> 0b010000 @ ym @ y_encdec_yreg(ys2) @ 0b10001 @ 0b010 @ encdec_reg(rd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YFIRST_M(ym, ys2, rd)) = {
  let num_elem = ylen;

  if y_illegal_yd_unmasked() | y_illegal_ystart(Y_YSTART_MANDATORY, num_elem, 0) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let ys2_val : bits('n) = y_read_ymask(num_elem, 0b0, ys2);

  let mask : bits('n) = y_init_masked_source(num_elem, 0, ym_val);

  let active = mask & ys2_val;

  X(rd) =
    if active == zeros() then {
      ones()
    } else {
      to_bits(count_trailing_zeros(active))
    };
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = Y_YFIRST_M(ym, ys2, rd)
 <-> "yfirst.m" ^ spc() ^ reg_name(rd) ^ sep() ^ y_yreg_name(ys2) ^ y_maybe_ymask(ym)

// ************************* OPMVV (vmsbf in YMUNARY0) **************************
union clause instruction = Y_YMSBF_M : (bits(1), yregidx, yregidx)

mapping clause encdec = Y_YMSBF_M(ym, ys2, yd)
 <-> 0b010100 @ ym @ y_encdec_yreg(ys2) @ 0b00001 @ 0b010 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YMSBF_M(ym, ys2, yd)) = {
  let SEW = y_get_sew();
  let num_elem = ylen;

  if y_illegal_ystart(Y_YSTART_MANDATORY, num_elem, 0) | y_illegal_normal(yd, ym) | yd == ys2 then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let ys2_val : bits('n) = y_read_ymask(num_elem, 0b0, ys2);
  let yd_val : bits('n) = y_read_ymask(num_elem, 0b0, yd);

  let (initial_result, mask) : (bits('n), bits('n)) = y_init_masked_result_cmp(num_elem, SEW, 0, yd_val, ym_val);
  var result = initial_result;

  var found_elem : bool = false;
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
        if ys2_val_view[i][j][k] == 0b1 then {
          found_elem = true
        };
        result_view[i][j][k] = bool_to_bit(not(found_elem))
      }
    };
    result = y_unshape_bits(length(result), result_view, y_columns, y_depth)
  };

  y_write_ymask(num_elem, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = Y_YMSBF_M(ym, ys2, yd)
 <-> "ymsbf.m" ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ y_maybe_ymask(ym)

// ************************* OPMVV (vmsif in YMUNARY0) **************************
union clause instruction = Y_YMSIF_M : (bits(1), yregidx, yregidx)

mapping clause encdec = Y_YMSIF_M(ym, ys2, yd)
 <-> 0b010100 @ ym @ y_encdec_yreg(ys2) @ 0b00011 @ 0b010 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YMSIF_M(ym, ys2, yd)) = {
  let SEW = y_get_sew();
  let num_elem = ylen;

  if y_illegal_ystart(Y_YSTART_MANDATORY, num_elem, 0) | y_illegal_normal(yd, ym) | yd == ys2 then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let ys2_val : bits('n) = y_read_ymask(num_elem, 0b0, ys2);
  let yd_val : bits('n) = y_read_ymask(num_elem, 0b0, yd);

  let (initial_result, mask) : (bits('n), bits('n)) = y_init_masked_result_cmp(num_elem, SEW, 0, yd_val, ym_val);
  var result = initial_result;

  var found_elem : bool = false;
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
        result_view[i][j][k] = bool_to_bit(not(found_elem));
        if ys2_val_view[i][j][k] == 0b1 then {
          found_elem = true
        }
      }
    };
    result = y_unshape_bits(length(result), result_view, y_columns, y_depth)
  };

  y_write_ymask(num_elem, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = Y_YMSIF_M(ym, ys2, yd)
 <-> "ymsif.m" ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ y_maybe_ymask(ym)

// ************************* OPMVV (vmsof in YMUNARY0) **************************
union clause instruction = Y_YMSOF_M : (bits(1), yregidx, yregidx)

mapping clause encdec = Y_YMSOF_M(ym, ys2, yd)
 <-> 0b010100 @ ym @ y_encdec_yreg(ys2) @ 0b00010 @ 0b010 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YMSOF_M(ym, ys2, yd)) = {
  let SEW = y_get_sew();
  let num_elem = ylen;

  if y_illegal_ystart(Y_YSTART_MANDATORY, num_elem, 0) | y_illegal_normal(yd, ym) | yd == ys2 then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let ys2_val : bits('n) = y_read_ymask(num_elem, 0b0, ys2);
  let yd_val : bits('n) = y_read_ymask(num_elem, 0b0, yd);

  let (initial_result, mask) : (bits('n), bits('n)) = y_init_masked_result_cmp(num_elem, SEW, 0, yd_val, ym_val);
  var result = initial_result;

  var found_elem : bool = false;
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
        if (ys2_val_view[i][j][k] == 0b1) & not(found_elem) then {
          result_view[i][j][k] = 0b1;
          found_elem = true
        } else {
          result_view[i][j][k] = 0b0
        }
      }
    };
    result = y_unshape_bits(length(result), result_view, y_columns, y_depth)
  };

  y_write_ymask(num_elem, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = Y_YMSOF_M(ym, ys2, yd)
 <-> "ymsof.m" ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ y_maybe_ymask(ym)

// ************************* OPMVV (viota in YMUNARY0) **************************
union clause instruction = Y_YIOTA_M : (bits(1), yregidx, yregidx)

mapping clause encdec = Y_YIOTA_M(ym, ys2, yd)
 <-> 0b010100 @ ym @ y_encdec_yreg(ys2) @ 0b10000 @ 0b010 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YIOTA_M(ym, ys2, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if    y_illegal_ystart(Y_YSTART_MANDATORY, num_elem, Y_LMUL_pow)
   |  y_illegal_normal(yd, ym)
   |  not(y_valid_reg_group(yd, Y_LMUL_pow))
   |  yd
   == ys2 then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
  let ys2_val : bits('n) = y_read_ymask(num_elem, 0b0, ys2);
  let yd_val : vector('n, bits('m)) = y_read_yreg(num_elem, SEW, Y_LMUL_pow, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = y_init_masked_result(
    num_elem,
    SEW,
    Y_LMUL_pow,
    yd_val,
    ym_val,
  );
  var result = initial_result;

  var sum : int = 0;
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
        result_view[i][j][k] = to_bits_unsafe(SEW, sum);
        if ys2_val_view[i][j][k] == 0b1 then {
          sum = sum + 1
        }
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW, Y_LMUL_pow, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = Y_YIOTA_M(ym, ys2, yd)
 <-> "yiota.m" ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ y_maybe_ymask(ym)

// ************************** OPMVV (vid in YMUNARY0) ***************************
union clause instruction = Y_YID_Y : (bits(1), yregidx)

mapping clause encdec = Y_YID_Y(ym, yd)
 <-> 0b010100 @ ym @ 0b00000 @ 0b10001 @ 0b010 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_YID_Y(ym, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_ARITH, num_elem, Y_LMUL_pow)
   | y_illegal_normal(yd, ym)
   | not(y_valid_reg_group(yd, Y_LMUL_pow)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem, ym, y_zyreg);
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
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        result_view[i][j][k] = to_bits_unsafe(SEW, p)
      }
    };
    result = y_unshape_vector(length(result), result_view, y_columns, y_depth)
  };

  y_write_yreg(num_elem, SEW, Y_LMUL_pow, yd, result);
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = Y_YID_Y(ym, yd)
 <-> "yid.y" ^ spc() ^ y_yreg_name(yd) ^ y_maybe_ymask(ym)
