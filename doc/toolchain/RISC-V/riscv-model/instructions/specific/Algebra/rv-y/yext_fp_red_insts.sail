// =======================================================================================
// This Sail RISC-Y architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

// ******************************************************************************
// This file implements part of the tensor extension.
// Chapter 14: Tensor Reduction Instructions
// ******************************************************************************

// ********************* OPFVV (Single-Width Floating-Point Reduction) ***********************
union clause instruction = Y_RFYYTYPE : (y_rfyyfunct6, bits(1), yregidx, yregidx, yregidx)

mapping y_encdec_rfyyfunct6 : y_rfyyfunct6 <-> bits(6) = {
 Y_FYY_YFREDOSUM   <-> 0b000011,
 Y_FYY_YFREDUSUM   <-> 0b000001,
 Y_FYY_YFREDMAX    <-> 0b000111,
 Y_FYY_YFREDMIN    <-> 0b000101,
}

mapping clause encdec = Y_RFYYTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_encdec_rfyyfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ y_encdec_yreg(ys1) @ 0b001 @ y_encdec_yreg(yd) @ 0b0101011
 when ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh))   & y_get_sew() == 16)
  | ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_F)) & y_get_sew() == 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 64)

function clause execute(Y_RFYYTYPE(funct6, ym, ys2, ys1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem_vs = y_get_num_elem(Y_LMUL_pow, SEW);
  let rm_3b = fcsr[FRM];
  let num_elem_yd = y_get_num_elem(0, SEW); // yd regardless of LMUL setting

  if   y_illegal_ystart(Y_YSTART_MANDATORY, num_elem_vs, Y_LMUL_pow)
   | y_illegal_fp_reduction(SEW, rm_3b)
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys1, SEW))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW != 8);

  if unsigned(yl) == 0 then {
    return RETIRE_SUCCESS
  }; // if yl=0, no operation is performed

  let (n as 'n) = num_elem_vs;
  let (d as 'd) = num_elem_yd;
  let (m as 'm) = SEW;

  let ym_val : bits('n) = y_read_ymask(num_elem_vs, ym, y_zyreg);
  let yd_val : vector('d, bits('m)) = y_read_yreg(num_elem_yd, SEW, 0, yd);
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem_vs, SEW, Y_LMUL_pow, ys2);

  let mask : bits('n) = y_init_masked_source(num_elem_vs, Y_LMUL_pow, ym_val);

  var sum : bits('m) = y_read_element(SEW, 0, 0, 0, ys1); // ys1 regardless of LMUL setting
  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem_vs - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        sum = match funct6 {
          // currently ordered/unordered sum reductions do the same operations
          Y_FYY_YFREDOSUM => y_fp_add(rm_3b, sum, ys2_val_view[i][j][k]),
          Y_FYY_YFREDUSUM => y_fp_add(rm_3b, sum, ys2_val_view[i][j][k]),
          Y_FYY_YFREDMAX  => y_fp_max(sum, ys2_val_view[i][j][k]),
          Y_FYY_YFREDMIN  => y_fp_min(sum, ys2_val_view[i][j][k]),
        }
      }
    }
  };

  y_write_element(SEW, 0, 0, 0, yd, sum);

  // other elements in yd are treated as tail elements, currently remain unchanged
  // TODO: configuration support for agnostic behavior
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_rfyytype_mnemonic : y_rfyyfunct6 <-> string = {
 Y_FYY_YFREDOSUM   <-> "yfredosum.ys",
 Y_FYY_YFREDUSUM   <-> "yfredusum.ys",
 Y_FYY_YFREDMAX    <-> "yfredmax.ys",
 Y_FYY_YFREDMIN    <-> "yfredmin.ys",
}

mapping clause assembly = Y_RFYYTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_rfyytype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ y_yreg_name(ys1) ^ y_maybe_ymask(ym)

// ********************* OPFVV (Widening Floating-Point Reduction) ***********************

union clause instruction = Y_RFWIDE_YYTYPE : (y_rfwide_yyfunct6, bits(1), yregidx, yregidx, yregidx)

mapping y_encdec_rfwide_yyfunct6 : y_rfwide_yyfunct6 <-> bits(6) = {
 Y_FYY_YFWREDOSUM  <-> 0b110011,
 Y_FYY_YFWREDUSUM  <-> 0b110001,
}

mapping clause encdec = Y_RFWIDE_YYTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_encdec_rfwide_yyfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ y_encdec_yreg(ys1) @ 0b001 @ y_encdec_yreg(yd) @ 0b0101011
 when ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh))   & y_get_sew() == 16)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 32)

// `funct6` selects between the ordered (`vfredosum`) and unordered
// (`vfredusum`) variants of the instruction.  This function currently
// only implements the ordered variant, as it is a valid
// implementation of the unordered variant; hence `funct6` is ignored.
function clause execute(Y_RFWIDE_YYTYPE(_funct6, ym, ys2, ys1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem_vs = y_get_num_elem(Y_LMUL_pow, SEW);
  let rm_3b = fcsr[FRM];
  let SEW_widen = SEW * 2;

  if   y_illegal_ystart(Y_YSTART_MANDATORY, num_elem_vs, Y_LMUL_pow)
   | y_illegal_fp_widening_reduction(SEW, rm_3b, SEW_widen)
   | not(y_valid_src_overlap(ys2, SEW, Y_LMUL_pow, ys1, SEW_widen, 0))
   | not(y_valid_ym_src_overlap(ym, ys1, SEW_widen))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW >= 16 & SEW_widen <= 64);

  let num_elem_yd = y_get_num_elem(0, SEW_widen); // yd regardless of LMUL setting

  if unsigned(yl) == 0 then {
    return RETIRE_SUCCESS
  }; // if yl=0, no operation is performed

  let (n as 'n) = num_elem_vs;
  let (d as 'd) = num_elem_yd;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let ym_val : bits('n) = y_read_ymask(num_elem_vs, ym, y_zyreg);
  let yd_val : vector('d, bits('o)) = y_read_yreg(num_elem_yd, SEW_widen, 0, yd);
  let ys2_val : vector('n, bits('m)) = y_read_yreg(num_elem_vs, SEW, Y_LMUL_pow, ys2);

  let mask : bits('n) = y_init_masked_source(num_elem_vs, Y_LMUL_pow, ym_val);

  var sum : bits('o) = y_read_element(SEW_widen, 0, 0, 0, ys1); // ys1 regardless of LMUL setting
  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem_vs - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        // currently ordered/unordered sum reductions do the same operations
        sum = y_fp_add(rm_3b, sum, y_fp_widen(ys2_val_view[i][j][k]))
      }
    }
  };

  y_write_element(SEW_widen, 0, 0, 0, yd, sum);

  // other elements in yd are treated as tail elements, currently remain unchanged
  // TODO: configuration support for agnostic behavior
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_rfwide_yytype_mnemonic : y_rfwide_yyfunct6 <-> string = {
 Y_FYY_YFWREDOSUM  <-> "yfwredosum.ys",
 Y_FYY_YFWREDUSUM  <-> "yfwredusum.ys",
}

mapping clause assembly = Y_RFWIDE_YYTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_rfwide_yytype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ y_yreg_name(ys1) ^ y_maybe_ymask(ym)
