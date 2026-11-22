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

// ********************* OPFVV (Single-Width Floating-Point Reduction) ***********************
union clause instruction = W_RFWWTYPE : (w_rfwwfunct6, bits(1), wregidx, wregidx, wregidx)

mapping w_encdec_rfwwfunct6 : w_rfwwfunct6 <-> bits(6) = {
 W_FWW_WFREDOSUM   <-> 0b000011,
 W_FWW_WFREDUSUM   <-> 0b000001,
 W_FWW_WFREDMAX    <-> 0b000111,
 W_FWW_WFREDMIN    <-> 0b000101,
}

mapping clause encdec = W_RFWWTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_encdec_rfwwfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ w_encdec_wreg(ws1) @ 0b001 @ w_encdec_wreg(wd) @ 0b0001011
 when ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh))   & w_get_sew() == 16)
  | ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_F)) & w_get_sew() == 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 64)

function clause execute(W_RFWWTYPE(funct6, wm, ws2, ws1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem_vs = w_get_num_elem(W_LMUL_pow, SEW);
  let rm_3b = fcsr[FRM];
  let num_elem_wd = w_get_num_elem(0, SEW); // wd regardless of LMUL setting

  if   w_illegal_wstart(W_WSTART_MANDATORY, num_elem_vs, W_LMUL_pow)
   | w_illegal_fp_reduction(SEW, rm_3b)
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws1, SEW))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW != 8);

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
          // currently ordered/unordered sum reductions do the same operations
          W_FWW_WFREDOSUM => w_fp_add(rm_3b, sum, ws2_val_view[i][j]),
          W_FWW_WFREDUSUM => w_fp_add(rm_3b, sum, ws2_val_view[i][j]),
          W_FWW_WFREDMAX  => w_fp_max(sum, ws2_val_view[i][j]),
          W_FWW_WFREDMIN  => w_fp_min(sum, ws2_val_view[i][j]),
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

mapping w_rfwwtype_mnemonic : w_rfwwfunct6 <-> string = {
 W_FWW_WFREDOSUM   <-> "wfredosum.ws",
 W_FWW_WFREDUSUM   <-> "wfredusum.ws",
 W_FWW_WFREDMAX    <-> "wfredmax.ws",
 W_FWW_WFREDMIN    <-> "wfredmin.ws",
}

mapping clause assembly = W_RFWWTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_rfwwtype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ w_wreg_name(ws1) ^ w_maybe_wmask(wm)

// ********************* OPFVV (Widening Floating-Point Reduction) ***********************

union clause instruction = W_RFWIDE_WWTYPE : (w_rfwide_wwfunct6, bits(1), wregidx, wregidx, wregidx)

mapping w_encdec_rfwide_wwfunct6 : w_rfwide_wwfunct6 <-> bits(6) = {
 W_FWW_WFWREDOSUM  <-> 0b110011,
 W_FWW_WFWREDUSUM  <-> 0b110001,
}

mapping clause encdec = W_RFWIDE_WWTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_encdec_rfwide_wwfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ w_encdec_wreg(ws1) @ 0b001 @ w_encdec_wreg(wd) @ 0b0001011
 when ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh))   & w_get_sew() == 16)
  | ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 32)

// `funct6` selects between the ordered (`vfredosum`) and unordered
// (`vfredusum`) variants of the instruction.  This function currently
// only implements the ordered variant, as it is a valid
// implementation of the unordered variant; hence `funct6` is ignored.
function clause execute(W_RFWIDE_WWTYPE(_funct6, wm, ws2, ws1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem_vs = w_get_num_elem(W_LMUL_pow, SEW);
  let rm_3b = fcsr[FRM];
  let SEW_widen = SEW * 2;

  if   w_illegal_wstart(W_WSTART_MANDATORY, num_elem_vs, W_LMUL_pow)
   | w_illegal_fp_widening_reduction(SEW, rm_3b, SEW_widen)
   | not(w_valid_src_overlap(ws2, SEW, W_LMUL_pow, ws1, SEW_widen, 0))
   | not(w_valid_wm_src_overlap(wm, ws1, SEW_widen))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW >= 16 & SEW_widen <= 64);

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
        // currently ordered/unordered sum reductions do the same operations
        sum = w_fp_add(rm_3b, sum, w_fp_widen(ws2_val_view[i][j]))
      }
    }
  };

  w_write_element(SEW_widen, 0, 0, wd, sum);

  // other elements in wd are treated as tail elements, currently remain unchanged
  // TODO: configuration support for agnostic behavior
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_rfwide_wwtype_mnemonic : w_rfwide_wwfunct6 <-> string = {
 W_FWW_WFWREDOSUM  <-> "wfwredosum.ws",
 W_FWW_WFWREDUSUM  <-> "wfwredusum.ws",
}

mapping clause assembly = W_RFWIDE_WWTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_rfwide_wwtype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ w_wreg_name(ws1) ^ w_maybe_wmask(wm)
