// =======================================================================================
// This Sail RISC-W architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

// ******************************************************************************
// This file implements part of the matrix extension.
// Chapter 14: Matrix Reduction Instructions
// ******************************************************************************

// ******************** OPIVV (Widening Integer Reduction) **********************
union clause instruction = W_RIWWTYPE : (w_riwwfunct6, bits(1), wregidx, wregidx, wregidx)

mapping w_encdec_riwwfunct6 : w_riwwfunct6 <-> bits(6) = {
 W_IVV_WWREDSUMU   <-> 0b110000,
 W_IVV_WWREDSUM    <-> 0b110001
}

mapping clause encdec = W_RIWWTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_encdec_riwwfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ w_encdec_wreg(ws1) @ 0b000 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 16)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 32)

function clause execute(W_RIWWTYPE(funct6, wm, ws2, ws1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let SEW_widen = SEW * 2;
  let num_elem_vs = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_MANDATORY, num_elem_vs, W_LMUL_pow)
   | w_illegal_widening_reduction(SEW_widen)
   | not(w_valid_src_overlap(ws2, SEW, W_LMUL_pow, ws1, SEW_widen, 0))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW))
   | not(w_valid_wm_src_overlap(wm, ws1, SEW_widen)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);

  let num_elem_wd = w_get_num_elem(0, SEW_widen); // wd regardless of LMUL setting

  if unsigned(wl) == 0 then {
    return RETIRE_SUCCESS
  }; // if wl=0, no operation is performed

  let (n as 'n) = num_elem_vs;
  let (d as 'd) = num_elem_wd;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let wm_val : bits('n) = w_read_wmask(num_elem_vs, wm, w_zwreg);
  let wd_val : vector('d, bits('o)) = w_read_wreg(num_elem_wd, SEW_widen, 0, wd);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem_vs, SEW, W_LMUL_pow, ws2);

  let mask : bits('n) = w_init_masked_source(num_elem_vs, W_LMUL_pow, wm_val);

  var sum : bits('o) = w_read_element(SEW_widen, 0, 0, ws1); // ws1 regardless of LMUL setting
  {
    let mask_view = w_shape(mask, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem_vs - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        let elem : bits('o) = match funct6 {
          W_IVV_WWREDSUMU => to_bits_unsafe(SEW_widen, unsigned(ws2_val_view[i][j])),
          W_IVV_WWREDSUM  => to_bits_unsafe(SEW_widen, signed(ws2_val_view[i][j])),
        };
        sum = sum + elem
      }
    }
  };

  w_write_element(SEW_widen, 0, 0, wd, sum);

  // other elements in wd are treated as tail elements, currently remain unchanged
  // TODO: configuration support for agnostic behavior
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_riwwtype_mnemonic : w_riwwfunct6 <-> string = {
 W_IVV_WWREDSUMU  <-> "wwredsumu.ws",
 W_IVV_WWREDSUM   <-> "wwredsum.ws"
}

mapping clause assembly = W_RIWWTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_riwwtype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ w_wreg_name(ws1) ^ w_maybe_wmask(wm)

// ****************** OPMVV (Single-Width Integer Reduction) ********************
union clause instruction = W_RMWWTYPE : (w_rmwwfunct6, bits(1), wregidx, wregidx, wregidx)

mapping w_encdec_rmwwfunct6 : w_rmwwfunct6 <-> bits(6) = {
 W_MWW_WREDSUM     <-> 0b000000,
 W_MWW_WREDAND     <-> 0b000001,
 W_MWW_WREDOR      <-> 0b000010,
 W_MWW_WREDXOR     <-> 0b000011,
 W_MWW_WREDMINU    <-> 0b000100,
 W_MWW_WREDMIN     <-> 0b000101,
 W_MWW_WREDMAXU    <-> 0b000110,
 W_MWW_WREDMAX     <-> 0b000111
}

mapping clause encdec = W_RMWWTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_encdec_rmwwfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ w_encdec_wreg(ws1) @ 0b010 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_RMWWTYPE(funct6, wm, ws2, ws1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem_vs = w_get_num_elem(W_LMUL_pow, SEW);
  let num_elem_wd = w_get_num_elem(0, SEW); // wd regardless of LMUL setting

  if   w_illegal_wstart(W_WSTART_MANDATORY, num_elem_vs, W_LMUL_pow)
   | w_illegal_reduction()
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW))
   | not(w_valid_wm_src_overlap(wm, ws1, SEW)) then {
    return Illegal_Instruction()
  };

  if unsigned(wl) == 0 then {
    return RETIRE_SUCCESS
  }; // if wl=0, no operation is performed

  let (n as 'n) = num_elem_vs;
  let (d as 'd) = num_elem_wd;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem_vs, wm, w_zwreg);
  let wd_val : vector('d, bits('m)) = w_read_wreg(num_elem_wd, SEW, 0, wd);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem_vs, SEW, W_LMUL_pow, ws2);

  let mask : bits('n) = w_init_masked_source(num_elem_vs, W_LMUL_pow, wm_val);

  var sum : bits('m) = w_read_element(SEW, 0, 0, ws1); // ws1 regardless of LMUL setting
  {
    let mask_view = w_shape(mask, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem_vs - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        sum = match funct6 {
          W_MWW_WREDSUM  => sum + ws2_val_view[i][j],
          W_MWW_WREDAND  => sum & ws2_val_view[i][j],
          W_MWW_WREDOR   => sum | ws2_val_view[i][j],
          W_MWW_WREDXOR  => sum ^ ws2_val_view[i][j],
          W_MWW_WREDMIN  => to_bits_unsafe(SEW, min(signed(ws2_val_view[i][j]), signed(sum))),
          W_MWW_WREDMINU => to_bits_unsafe(SEW, min(unsigned(ws2_val_view[i][j]), unsigned(sum))),
          W_MWW_WREDMAX  => to_bits_unsafe(SEW, max(signed(ws2_val_view[i][j]), signed(sum))),
          W_MWW_WREDMAXU => to_bits_unsafe(SEW, max(unsigned(ws2_val_view[i][j]), unsigned(sum))),
        }
      }
    }
  };

  w_write_element(SEW, 0, 0, wd, sum);

  // other elements in wd are treated as tail elements, currently remain unchanged
  // TODO: configuration support for agnostic behavior
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_rmwwtype_mnemonic : w_rmwwfunct6 <-> string = {
 W_MWW_WREDSUM   <-> "wredsum.ws",
 W_MWW_WREDAND   <-> "wredand.ws",
 W_MWW_WREDOR    <-> "wredor.ws",
 W_MWW_WREDXOR   <-> "wredxor.ws",
 W_MWW_WREDMINU  <-> "wredminu.ws",
 W_MWW_WREDMIN   <-> "wredmin.ws",
 W_MWW_WREDMAXU  <-> "wredmaxu.ws",
 W_MWW_WREDMAX   <-> "wredmax.ws"
}

mapping clause assembly = W_RMWWTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_rmwwtype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ w_wreg_name(ws1) ^ w_maybe_wmask(wm)
