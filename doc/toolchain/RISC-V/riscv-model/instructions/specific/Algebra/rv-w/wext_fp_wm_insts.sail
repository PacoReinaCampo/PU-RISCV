// =======================================================================================
// This Sail RISC-W architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

// ******************************************************************************
// This file implements part of the matrix extension.
// Mask instructions from Chap 13 (floating-point)
// ******************************************************************************

// ****************************** OPFVV (WWMTYPE) *******************************
// FWWM instructions' destination is a mask register
union clause instruction = W_FWWMTYPE : (w_fwwmfunct6, bits(1), wregidx, wregidx, wregidx)

mapping w_encdec_fwwmfunct6 : w_fwwmfunct6 <-> bits(6) = {
 W_FWWM_WMFEQ      <-> 0b011000,
 W_FWWM_WMFLE      <-> 0b011001,
 W_FWWM_WMFLT      <-> 0b011011,
 W_FWWM_WMFNE      <-> 0b011100
}

mapping clause encdec = W_FWWMTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_encdec_fwwmfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ w_encdec_wreg(ws1) @ 0b001 @ w_encdec_wreg(wd) @ 0b0001011
 when ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh))   & w_get_sew() == 16)
  | ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_F)) & w_get_sew() == 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 64)

function clause execute(W_FWWMTYPE(funct6, wm, ws2, ws1, wd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_fp_wd_unmasked(SEW, rm_3b)
   | not(w_valid_reg_group(ws1, W_LMUL_pow))
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
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
  let wd_val : bits('n) = w_read_wmask(num_elem, 0b0, wd);

  let (initial_result, mask) : (bits('n), bits('n)) = w_init_masked_result_cmp(
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
        let res : bool = match funct6 {
          W_FWWM_WMFEQ => w_fp_eq(ws2_val_view[i][j], ws1_val_view[i][j]),
          W_FWWM_WMFNE => ~(w_fp_eq(ws2_val_view[i][j], ws1_val_view[i][j])),
          W_FWWM_WMFLE => w_fp_le(ws2_val_view[i][j], ws1_val_view[i][j]),
          W_FWWM_WMFLT => w_fp_lt(ws2_val_view[i][j], ws1_val_view[i][j]),
        };
        result_view[i][j] = bool_to_bit(res)
      }
    };
    result = w_unshape_bits(length(result), result_view, w_columns)
  };

  w_write_wmask(num_elem, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_fwwmtype_mnemonic : w_fwwmfunct6 <-> string = {
 W_FWWM_WMFEQ      <-> "wmfeq.ww",
 W_FWWM_WMFLE      <-> "wmfle.ww",
 W_FWWM_WMFLT      <-> "wmflt.ww",
 W_FWWM_WMFNE      <-> "wmfne.ww"
}

mapping clause assembly = W_FWWMTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_fwwmtype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ w_wreg_name(ws1) ^ w_maybe_wmask(wm)

// ****************************** OPFVF (WFMTYPE) *******************************
// WFM instructions' destination is a mask register
union clause instruction = W_FWFMTYPE : (w_fwfmfunct6, bits(1), wregidx, fregidx, wregidx)

mapping w_encdec_fwfmfunct6 : w_fwfmfunct6 <-> bits(6) = {
 W_WFM_WMFEQ      <-> 0b011000,
 W_WFM_WMFLE      <-> 0b011001,
 W_WFM_WMFLT      <-> 0b011011,
 W_WFM_WMFNE      <-> 0b011100,
 W_WFM_WMFGT      <-> 0b011101,
 W_WFM_WMFGE      <-> 0b011111
}

mapping clause encdec = W_FWFMTYPE(funct6, wm, ws2, rs1, wd)
 <-> w_encdec_fwfmfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ encdec_freg(rs1) @ 0b101 @ w_encdec_wreg(wd) @ 0b0001011
 when ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh))   & w_get_sew() == 16)
  | ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_F)) & w_get_sew() == 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 64)

function clause execute(W_FWFMTYPE(funct6, wm, ws2, rs1, wd)) = {
  let rm_3b = fcsr[FRM];
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_fp_wd_unmasked(SEW, rm_3b)
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW != 8);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let rs1_val : bits('m) = w_get_scalar_fp(rs1, sizeof('m));
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
  let wd_val : bits('n) = w_read_wmask(num_elem, 0b0, wd);

  let (initial_result, mask) : (bits('n), bits('n)) = w_init_masked_result_cmp(
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
        let res : bool = match funct6 {
          W_WFM_WMFEQ => w_fp_eq(ws2_val_view[i][j], rs1_val),
          W_WFM_WMFNE => ~(w_fp_eq(ws2_val_view[i][j], rs1_val)),
          W_WFM_WMFLE => w_fp_le(ws2_val_view[i][j], rs1_val),
          W_WFM_WMFLT => w_fp_lt(ws2_val_view[i][j], rs1_val),
          W_WFM_WMFGE => w_fp_ge(ws2_val_view[i][j], rs1_val),
          W_WFM_WMFGT => w_fp_gt(ws2_val_view[i][j], rs1_val),
        };
        result_view[i][j] = bool_to_bit(res)
      }
    };
    result = w_unshape_bits(length(result), result_view, w_columns)
  };

  w_write_wmask(num_elem, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_fwfmtype_mnemonic : w_fwfmfunct6 <-> string = {
 W_WFM_WMFEQ      <-> "wmfeq.wf",
 W_WFM_WMFLE      <-> "wmfle.wf",
 W_WFM_WMFLT      <-> "wmflt.wf",
 W_WFM_WMFNE      <-> "wmfne.wf",
 W_WFM_WMFGT      <-> "wmfgt.wf",
 W_WFM_WMFGE      <-> "wmfge.wf"
}

mapping clause assembly = W_FWFMTYPE(funct6, wm, ws2, rs1, wd)
 <-> w_fwfmtype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ freg_name(rs1) ^ w_maybe_wmask(wm)
