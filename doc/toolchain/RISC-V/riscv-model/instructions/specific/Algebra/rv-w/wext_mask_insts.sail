// =======================================================================================
// This Sail RISC-W architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

// ******************************************************************************
// This file implements part of the matrix extension.
// Chapter 15: matrix mask instructions
// ******************************************************************************

// ****************************** OPMVV (MMTYPE) ********************************
union clause instruction = W_MMTYPE : (w_mmfunct6, wregidx, wregidx, wregidx)

mapping w_encdec_mmfunct6 : w_mmfunct6 <-> bits(6) = {
 W_MM_WMAND     <-> 0b011001,
 W_MM_WMNAND    <-> 0b011101,
 W_MM_WMANDN    <-> 0b011000,
 W_MM_WMXOR     <-> 0b011011,
 W_MM_WMOR      <-> 0b011010,
 W_MM_WMNOR     <-> 0b011110,
 W_MM_WMORN     <-> 0b011100,
 W_MM_WMXNOR    <-> 0b011111
}

mapping clause encdec = W_MMTYPE(funct6, ws2, ws1, wd)
 <-> w_encdec_mmfunct6(funct6) @ 0b1 @ w_encdec_wreg(ws2) @ w_encdec_wreg(ws1) @ 0b010 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_MMTYPE(funct6, ws2, ws1, wd)) = {
  let SEW = w_get_sew();
  let num_elem = wlen;

  if w_illegal_wd_unmasked() | w_illegal_wstart(W_WSTART_ARITH, num_elem, 0) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ws1_val : bits('n) = w_read_wmask(num_elem, 0b0, ws1);
  let ws2_val : bits('n) = w_read_wmask(num_elem, 0b0, ws2);
  let wd_val : bits('n) = w_read_wmask(num_elem, 0b0, wd);

  let (initial_result, mask) : (bits('n), bits('n)) = w_init_masked_result_carry(num_elem, SEW, 0, wd_val);
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
        result_view[i][j] = match funct6 {
          W_MM_WMAND  => bool_to_bit((ws2_val_view[i][j] == bitone) & (ws1_val_view[i][j] == bitone)),
          W_MM_WMNAND => bool_to_bit(not((ws2_val_view[i][j] == bitone) & (ws1_val_view[i][j] == bitone))),
          W_MM_WMANDN => bool_to_bit((ws2_val_view[i][j] == bitone) & not(ws1_val_view[i][j] == bitone)),
          W_MM_WMXOR  => bool_to_bit((ws2_val_view[i][j] == bitone) != (ws1_val_view[i][j] == bitone)),
          W_MM_WMOR   => bool_to_bit((ws2_val_view[i][j] == bitone) | (ws1_val_view[i][j] == bitone)),
          W_MM_WMNOR  => bool_to_bit(not((ws2_val_view[i][j] == bitone) | (ws1_val_view[i][j] == bitone))),
          W_MM_WMORN  => bool_to_bit((ws2_val_view[i][j] == bitone) | not(ws1_val_view[i][j] == bitone)),
          W_MM_WMXNOR => bool_to_bit((ws2_val_view[i][j] == bitone) == (ws1_val_view[i][j] == bitone)),
        }
      }
    };
    result = w_unshape_bits(length(result), result_view, w_columns)
  };

  w_write_wmask(num_elem, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_mmtype_mnemonic : w_mmfunct6 <-> string = {
 W_MM_WMAND     <-> "wmand.mm",
 W_MM_WMNAND    <-> "wmnand.mm",
 W_MM_WMANDN    <-> "wmandn.mm",
 W_MM_WMXOR     <-> "wmxor.mm",
 W_MM_WMOR      <-> "wmor.mm",
 W_MM_WMNOR     <-> "wmnor.mm",
 W_MM_WMORN     <-> "wmorn.mm",
 W_MM_WMXNOR    <-> "wmxnor.mm"
}

mapping clause assembly = W_MMTYPE(funct6, ws2, ws1, wd)
 <-> w_mmtype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ w_wreg_name(ws1)

// ************************ OPMVV (vcpop in WWXUNARY0) **************************
union clause instruction = W_WCPOP_M : (bits(1), wregidx, regidx)

mapping clause encdec = W_WCPOP_M(wm, ws2, rd)
 <-> 0b010000 @ wm @ w_encdec_wreg(ws2) @ 0b10000 @ 0b010 @ encdec_reg(rd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WCPOP_M(wm, ws2, rd)) = {
  let num_elem = wlen;

  if w_illegal_wd_unmasked() | w_illegal_wstart(W_WSTART_MANDATORY, num_elem, 0) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let ws2_val : bits('n) = w_read_wmask(num_elem, 0b0, ws2);

  let mask : bits('n) = w_init_masked_source(num_elem, 0, wm_val);

  X(rd) = to_bits(xlen, count_ones(mask & ws2_val));
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_WCPOP_M(wm, ws2, rd)
 <-> "wcpop.m" ^ spc() ^ reg_name(rd) ^ sep() ^ w_wreg_name(ws2) ^ w_maybe_wmask(wm)

// ************************ OPMVV (vfirst in WWXUNARY0) *************************
union clause instruction = W_WFIRST_M : (bits(1), wregidx, regidx)

mapping clause encdec = W_WFIRST_M(wm, ws2, rd)
 <-> 0b010000 @ wm @ w_encdec_wreg(ws2) @ 0b10001 @ 0b010 @ encdec_reg(rd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WFIRST_M(wm, ws2, rd)) = {
  let num_elem = wlen;

  if w_illegal_wd_unmasked() | w_illegal_wstart(W_WSTART_MANDATORY, num_elem, 0) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let ws2_val : bits('n) = w_read_wmask(num_elem, 0b0, ws2);

  let mask : bits('n) = w_init_masked_source(num_elem, 0, wm_val);

  let active = mask & ws2_val;

  X(rd) =
    if active == zeros() then {
      ones()
    } else {
      to_bits(count_trailing_zeros(active))
    };
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_WFIRST_M(wm, ws2, rd)
 <-> "wfirst.m" ^ spc() ^ reg_name(rd) ^ sep() ^ w_wreg_name(ws2) ^ w_maybe_wmask(wm)

// ************************* OPMVV (vmsbf in WMUNARY0) **************************
union clause instruction = W_WMSBF_M : (bits(1), wregidx, wregidx)

mapping clause encdec = W_WMSBF_M(wm, ws2, wd)
 <-> 0b010100 @ wm @ w_encdec_wreg(ws2) @ 0b00001 @ 0b010 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WMSBF_M(wm, ws2, wd)) = {
  let SEW = w_get_sew();
  let num_elem = wlen;

  if w_illegal_wstart(W_WSTART_MANDATORY, num_elem, 0) | w_illegal_normal(wd, wm) | wd == ws2 then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let ws2_val : bits('n) = w_read_wmask(num_elem, 0b0, ws2);
  let wd_val : bits('n) = w_read_wmask(num_elem, 0b0, wd);

  let (initial_result, mask) : (bits('n), bits('n)) = w_init_masked_result_cmp(num_elem, SEW, 0, wd_val, wm_val);
  var result = initial_result;

  var found_elem : bool = false;
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
        if ws2_val_view[i][j] == 0b1 then {
          found_elem = true
        };
        result_view[i][j] = bool_to_bit(not(found_elem))
      }
    };
    result = w_unshape_bits(length(result), result_view, w_columns)
  };

  w_write_wmask(num_elem, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_WMSBF_M(wm, ws2, wd)
 <-> "wmsbf.m" ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ w_maybe_wmask(wm)

// ************************* OPMVV (vmsif in WMUNARY0) **************************
union clause instruction = W_WMSIF_M : (bits(1), wregidx, wregidx)

mapping clause encdec = W_WMSIF_M(wm, ws2, wd)
 <-> 0b010100 @ wm @ w_encdec_wreg(ws2) @ 0b00011 @ 0b010 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WMSIF_M(wm, ws2, wd)) = {
  let SEW = w_get_sew();
  let num_elem = wlen;

  if w_illegal_wstart(W_WSTART_MANDATORY, num_elem, 0) | w_illegal_normal(wd, wm) | wd == ws2 then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let ws2_val : bits('n) = w_read_wmask(num_elem, 0b0, ws2);
  let wd_val : bits('n) = w_read_wmask(num_elem, 0b0, wd);

  let (initial_result, mask) : (bits('n), bits('n)) = w_init_masked_result_cmp(num_elem, SEW, 0, wd_val, wm_val);
  var result = initial_result;

  var found_elem : bool = false;
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
        result_view[i][j] = bool_to_bit(not(found_elem));
        if ws2_val_view[i][j] == 0b1 then {
          found_elem = true
        }
      }
    };
    result = w_unshape_bits(length(result), result_view, w_columns)
  };

  w_write_wmask(num_elem, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_WMSIF_M(wm, ws2, wd)
 <-> "wmsif.m" ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ w_maybe_wmask(wm)

// ************************* OPMVV (vmsof in WMUNARY0) **************************
union clause instruction = W_WMSOF_M : (bits(1), wregidx, wregidx)

mapping clause encdec = W_WMSOF_M(wm, ws2, wd)
 <-> 0b010100 @ wm @ w_encdec_wreg(ws2) @ 0b00010 @ 0b010 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WMSOF_M(wm, ws2, wd)) = {
  let SEW = w_get_sew();
  let num_elem = wlen;

  if w_illegal_wstart(W_WSTART_MANDATORY, num_elem, 0) | w_illegal_normal(wd, wm) | wd == ws2 then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let ws2_val : bits('n) = w_read_wmask(num_elem, 0b0, ws2);
  let wd_val : bits('n) = w_read_wmask(num_elem, 0b0, wd);

  let (initial_result, mask) : (bits('n), bits('n)) = w_init_masked_result_cmp(num_elem, SEW, 0, wd_val, wm_val);
  var result = initial_result;

  var found_elem : bool = false;
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
        if (ws2_val_view[i][j] == 0b1) & not(found_elem) then {
          result_view[i][j] = 0b1;
          found_elem = true
        } else {
          result_view[i][j] = 0b0
        }
      }
    };
    result = w_unshape_bits(length(result), result_view, w_columns)
  };

  w_write_wmask(num_elem, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_WMSOF_M(wm, ws2, wd)
 <-> "wmsof.m" ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ w_maybe_wmask(wm)

// ************************* OPMVV (viota in WMUNARY0) **************************
union clause instruction = W_WIOTA_M : (bits(1), wregidx, wregidx)

mapping clause encdec = W_WIOTA_M(wm, ws2, wd)
 <-> 0b010100 @ wm @ w_encdec_wreg(ws2) @ 0b10000 @ 0b010 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WIOTA_M(wm, ws2, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if    w_illegal_wstart(W_WSTART_MANDATORY, num_elem, W_LMUL_pow)
   |  w_illegal_normal(wd, wm)
   |  not(w_valid_reg_group(wd, W_LMUL_pow))
   |  wd
   == ws2 then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let ws2_val : bits('n) = w_read_wmask(num_elem, 0b0, ws2);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW,
    W_LMUL_pow,
    wd_val,
    wm_val,
  );
  var result = initial_result;

  var sum : int = 0;
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
        result_view[i][j] = to_bits_unsafe(SEW, sum);
        if ws2_val_view[i][j] == 0b1 then {
          sum = sum + 1
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_WIOTA_M(wm, ws2, wd)
 <-> "wiota.m" ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ w_maybe_wmask(wm)

// ************************** OPMVV (vid in WMUNARY0) ***************************
union clause instruction = W_WID_W : (bits(1), wregidx)

mapping clause encdec = W_WID_W(wm, wd)
 <-> 0b010100 @ wm @ 0b00000 @ 0b10001 @ 0b010 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WID_W(wm, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_normal(wd, wm)
   | not(w_valid_reg_group(wd, W_LMUL_pow)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = w_init_masked_result(
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
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = to_bits_unsafe(SEW, p)
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_WID_W(wm, wd)
 <-> "wid.w" ^ spc() ^ w_wreg_name(wd) ^ w_maybe_wmask(wm)
