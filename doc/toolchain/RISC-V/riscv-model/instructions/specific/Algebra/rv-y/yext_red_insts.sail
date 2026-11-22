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

// ******************** OPIVV (Widening Integer Reduction) **********************
union clause instruction = Y_RIYYTYPE : (y_riyyfunct6, bits(1), yregidx, yregidx, yregidx)

mapping y_encdec_riyyfunct6 : y_riyyfunct6 <-> bits(6) = {
 Y_IVV_YWREDSUMU   <-> 0b110000,
 Y_IVV_YWREDSUM    <-> 0b110001
}

mapping clause encdec = Y_RIYYTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_encdec_riyyfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ y_encdec_yreg(ys1) @ 0b000 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 16)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 32)

function clause execute(Y_RIYYTYPE(funct6, ym, ys2, ys1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let SEW_widen = SEW * 2;
  let num_elem_vs = y_get_num_elem(Y_LMUL_pow, SEW);

  if   y_illegal_ystart(Y_YSTART_MANDATORY, num_elem_vs, Y_LMUL_pow)
   | y_illegal_widening_reduction(SEW_widen)
   | not(y_valid_src_overlap(ys2, SEW, Y_LMUL_pow, ys1, SEW_widen, 0))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW))
   | not(y_valid_ym_src_overlap(ym, ys1, SEW_widen)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);

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
        let elem : bits('o) = match funct6 {
          Y_IVV_YWREDSUMU => to_bits_unsafe(SEW_widen, unsigned(ys2_val_view[i][j][k])),
          Y_IVV_YWREDSUM  => to_bits_unsafe(SEW_widen, signed(ys2_val_view[i][j][k])),
        };
        sum = sum + elem
      }
    }
  };

  y_write_element(SEW_widen, 0, 0, 0, yd, sum);

  // other elements in yd are treated as tail elements, currently remain unchanged
  // TODO: configuration support for agnostic behavior
  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_riyytype_mnemonic : y_riyyfunct6 <-> string = {
 Y_IVV_YWREDSUMU  <-> "ywredsumu.ys",
 Y_IVV_YWREDSUM   <-> "ywredsum.ys"
}

mapping clause assembly = Y_RIYYTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_riyytype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ y_yreg_name(ys1) ^ y_maybe_ymask(ym)

// ****************** OPMVV (Single-Width Integer Reduction) ********************
union clause instruction = Y_RMYYTYPE : (y_rmyyfunct6, bits(1), yregidx, yregidx, yregidx)

mapping y_encdec_rmyyfunct6 : y_rmyyfunct6 <-> bits(6) = {
 Y_MYY_YREDSUM     <-> 0b000000,
 Y_MYY_YREDAND     <-> 0b000001,
 Y_MYY_YREDOR      <-> 0b000010,
 Y_MYY_YREDXOR     <-> 0b000011,
 Y_MYY_YREDMINU    <-> 0b000100,
 Y_MYY_YREDMIN     <-> 0b000101,
 Y_MYY_YREDMAXU    <-> 0b000110,
 Y_MYY_YREDMAX     <-> 0b000111
}

mapping clause encdec = Y_RMYYTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_encdec_rmyyfunct6(funct6) @ ym @ y_encdec_yreg(ys2) @ y_encdec_yreg(ys1) @ 0b010 @ y_encdec_yreg(yd) @ 0b0101011
 when (currentlyEnabled(Ext_Y) & y_get_sew() <= 32)
  | ((currentlyEnabled(Ext_Y) & yelen >= 64) & y_get_sew() <= 64)

function clause execute(Y_RMYYTYPE(funct6, ym, ys2, ys1, yd)) = {
  let SEW = y_get_sew();
  let Y_LMUL_pow = y_get_lmul_pow();
  let num_elem_vs = y_get_num_elem(Y_LMUL_pow, SEW);
  let num_elem_yd = y_get_num_elem(0, SEW); // yd regardless of LMUL setting

  if   y_illegal_ystart(Y_YSTART_MANDATORY, num_elem_vs, Y_LMUL_pow)
   | y_illegal_reduction()
   | not(y_valid_reg_group(ys2, Y_LMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys2, SEW))
   | not(y_valid_ym_src_overlap(ym, ys1, SEW)) then {
    return Illegal_Instruction()
  };

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
          Y_MYY_YREDSUM  => sum + ys2_val_view[i][j][k],
          Y_MYY_YREDAND  => sum & ys2_val_view[i][j][k],
          Y_MYY_YREDOR   => sum | ys2_val_view[i][j][k],
          Y_MYY_YREDXOR  => sum ^ ys2_val_view[i][j][k],
          Y_MYY_YREDMIN  => to_bits_unsafe(SEW, min(signed(ys2_val_view[i][j][k]), signed(sum))),
          Y_MYY_YREDMINU => to_bits_unsafe(SEW, min(unsigned(ys2_val_view[i][j][k]), unsigned(sum))),
          Y_MYY_YREDMAX  => to_bits_unsafe(SEW, max(signed(ys2_val_view[i][j][k]), signed(sum))),
          Y_MYY_YREDMAXU => to_bits_unsafe(SEW, max(unsigned(ys2_val_view[i][j][k]), unsigned(sum))),
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

mapping y_rmyytype_mnemonic : y_rmyyfunct6 <-> string = {
 Y_MYY_YREDSUM   <-> "yredsum.ys",
 Y_MYY_YREDAND   <-> "yredand.ys",
 Y_MYY_YREDOR    <-> "yredor.ys",
 Y_MYY_YREDXOR   <-> "yredxor.ys",
 Y_MYY_YREDMINU  <-> "yredminu.ys",
 Y_MYY_YREDMIN   <-> "yredmin.ys",
 Y_MYY_YREDMAXU  <-> "yredmaxu.ys",
 Y_MYY_YREDMAX   <-> "yredmax.ys"
}

mapping clause assembly = Y_RMYYTYPE(funct6, ym, ys2, ys1, yd)
 <-> y_rmyytype_mnemonic(funct6) ^ spc() ^ y_yreg_name(yd) ^ sep() ^ y_yreg_name(ys2) ^ sep() ^ y_yreg_name(ys1) ^ y_maybe_ymask(ym)
