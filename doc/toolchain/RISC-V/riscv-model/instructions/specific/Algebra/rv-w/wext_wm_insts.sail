// =======================================================================================
// This Sail RISC-W architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

// ******************************************************************************
// This file implements part of the matrix extension.
// Mask instructions from Chap 11 (integer arithmetic)
// ******************************************************************************

// ****************************** OPIVV (WWMTYPE) *******************************
// WWM instructions' destination is a mask register (e.g. carry out)
// Instructions with no carry out will set mask result to current mask value
// May or may not read from source mask register (e.g. carry in)
union clause instruction = W_WWMTYPE : (w_wwmfunct6, wregidx, wregidx, wregidx)

mapping w_encdec_wwmfunct6 : w_wwmfunct6 <-> bits(6) = {
 W_WWM_WMADC    <-> 0b010001, // carry in, carry out
 W_WWM_WMSBC    <-> 0b010011
}

mapping clause encdec = W_WWMTYPE(funct6, ws2, ws1, wd)
 <-> w_encdec_wwmfunct6(funct6) @ 0b0 @ w_encdec_wreg(ws2) @ w_encdec_wreg(ws1) @ 0b000 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WWMTYPE(funct6, ws2, ws1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_wd_unmasked()
   | not(w_valid_reg_group(ws1, W_LMUL_pow))
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(0b0, ws1, SEW))
   | not(w_valid_wm_src_overlap(0b0, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask_carry(num_elem, 0b0, w_zwreg);
  let ws1_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws1);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
  let wd_val : bits('n) = w_read_wmask(num_elem, 0b0, wd);

  let (initial_result, mask) : (bits('n), bits('n)) = w_init_masked_result_carry(num_elem, SEW, W_LMUL_pow, wd_val);
  var result = initial_result;

  {
    let mask_view = w_shape(mask, w_columns);
    var result_view = w_shape(result, w_columns);
    let wm_val_view = w_shape(wm_val, w_columns);
    let ws1_val_view = w_shape(ws1_val, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(wm_val_view));
      assert(i < length(ws1_val_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        let res : bool = match funct6 {
          W_WWM_WMADC =>   unsigned(ws2_val_view[i][j])
                 + unsigned(ws1_val_view[i][j])
                 + (if wm_val_view[i][j] == 0b1 then 1 else 0)
                 > 2 ^ SEW
                 - 1,
          W_WWM_WMSBC =>   unsigned(ws2_val_view[i][j])
                 - unsigned(ws1_val_view[i][j])
                 - (if wm_val_view[i][j] == 0b1 then 1 else 0)
                 < 0,
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

mapping w_wwmtype_mnemonic : w_wwmfunct6 <-> string = {
 W_WWM_WMADC    <-> "wmadc.wwm", // carry in, carry out
 W_WWM_WMSBC    <-> "wmsbc.wwm"
}

mapping clause assembly = W_WWMTYPE(funct6, ws2, ws1, wd)
 <-> w_wwmtype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ w_wreg_name(ws1) ^ sep() ^ "w0"

// ***************************** OPIVV (WWMCTYPE) *******************************
// WWMC instructions' destination is a mask register (e.g. carry out)
// Instructions with no carry out will set mask result to current mask value
// May or may not read from source mask register (e.g. carry in)
union clause instruction = W_WWMCTYPE : (w_wwmcfunct6, wregidx, wregidx, wregidx)

mapping w_encdec_wwmcfunct6 : w_wwmcfunct6 <-> bits(6) = {
 W_WWMC_WMADC    <-> 0b010001, // no carry in, carry out
 W_WWMC_WMSBC    <-> 0b010011
}

mapping clause encdec = W_WWMCTYPE(funct6, ws2, ws1, wd)
 <-> w_encdec_wwmcfunct6(funct6) @ 0b1 @ w_encdec_wreg(ws2) @ w_encdec_wreg(ws1) @ 0b000 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WWMCTYPE(funct6, ws2, ws1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_wd_unmasked()
   | not(w_valid_reg_group(ws1, W_LMUL_pow))
   | not(w_valid_reg_group(ws2, W_LMUL_pow)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ws1_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws1);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
  let wd_val : bits('n) = w_read_wmask(num_elem, 0b0, wd);

  let (initial_result, mask) : (bits('n), bits('n)) = w_init_masked_result_carry(num_elem, SEW, W_LMUL_pow, wd_val);
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
          W_WWMC_WMADC => unsigned(ws2_val_view[i][j]) + unsigned(ws1_val_view[i][j]) > 2 ^ SEW - 1,
          W_WWMC_WMSBC => unsigned(ws2_val_view[i][j]) - unsigned(ws1_val_view[i][j]) < 0,
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

mapping w_wwmctype_mnemonic : w_wwmcfunct6 <-> string = {
 W_WWMC_WMADC    <-> "wmadc.ww", // no carry in, carry out
 W_WWMC_WMSBC    <-> "wmsbc.ww"
}

mapping clause assembly = W_WWMCTYPE(funct6, ws2, ws1, wd)
 <-> w_wwmctype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ w_wreg_name(ws1)

// ***************************** OPIVV (WWMSTYPE) *******************************
// WWMS instructions' destination is a matrix register (e.g. actual sum)
// Instructions with no carry out will set mask result to current mask value
// May or may not read from source mask register (e.g. carry in)
union clause instruction = W_WWMSTYPE : (w_wwmsfunct6, wregidx, wregidx, wregidx)

mapping w_encdec_wwmsfunct6 : w_wwmsfunct6 <-> bits(6) = {
 W_WWMS_WADC     <-> 0b010000, // carry in, no carry out
 W_WWMS_WSBC     <-> 0b010010
}

mapping clause encdec = W_WWMSTYPE(funct6, ws2, ws1, wd)
 <-> w_encdec_wwmsfunct6(funct6) @ 0b0 @ w_encdec_wreg(ws2) @ w_encdec_wreg(ws1) @ 0b000 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WWMSTYPE(funct6, ws2, ws1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_wd_masked(wd)
   | not(w_valid_reg_group(ws1, W_LMUL_pow))
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_reg_group(wd, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(0b0, ws1, SEW))
   | not(w_valid_wm_src_overlap(0b0, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  // for bypassing normal masking in init_masked_result
  let vec_trues : bits('n) = ones();

  let wm_val : bits('n) = w_read_wmask_carry(num_elem, 0b0, w_zwreg);
  let ws1_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws1);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW,
    W_LMUL_pow,
    wd_val,
    vec_trues,
  );
  var result = initial_result;

  {
    let mask_view = w_shape(mask, w_columns);
    var result_view = w_shape(result, w_columns);
    let wm_val_view = w_shape(wm_val, w_columns);
    let ws1_val_view = w_shape(ws1_val, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(wm_val_view));
      assert(i < length(ws1_val_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_WWMS_WADC => to_bits_unsafe(
            SEW,
             unsigned(ws2_val_view[i][j])
            + unsigned(ws1_val_view[i][j])
            + (if wm_val_view[i][j] == 0b1 then 1 else 0),
          ),
          W_WWMS_WSBC => to_bits_unsafe(
            SEW,
             unsigned(ws2_val_view[i][j])
            - unsigned(ws1_val_view[i][j])
            - (if wm_val_view[i][j] == 0b1 then 1 else 0),
          ),
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_wwmstype_mnemonic : w_wwmsfunct6 <-> string = {
 W_WWMS_WADC     <-> "wadc.wwm", // carry in, no carry out
 W_WWMS_WSBC     <-> "wsbc.wwm"
}

mapping clause assembly = W_WWMSTYPE(funct6, ws2, ws1, wd)
 <-> w_wwmstype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ w_wreg_name(ws1) ^ sep() ^ "w0"

// **************** OPIVV (Matrix Integer Compare Instructions) *****************
// WWCMP instructions' destination is a mask register
union clause instruction = W_WWCMPTYPE : (w_wwcmpfunct6, bits(1), wregidx, wregidx, wregidx)

mapping w_encdec_wwcmpfunct6 : w_wwcmpfunct6 <-> bits(6) = {
 W_WWCMP_WMSEQ    <-> 0b011000,
 W_WWCMP_WMSNE    <-> 0b011001,
 W_WWCMP_WMSLTU   <-> 0b011010,
 W_WWCMP_WMSLT    <-> 0b011011,
 W_WWCMP_WMSLEU   <-> 0b011100,
 W_WWCMP_WMSLE    <-> 0b011101
}

mapping clause encdec = W_WWCMPTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_encdec_wwcmpfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ w_encdec_wreg(ws1) @ 0b000 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WWCMPTYPE(funct6, wm, ws2, ws1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_wd_unmasked()
   | not(w_valid_reg_group(ws1, W_LMUL_pow))
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws1, SEW))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW)) then {
    return Illegal_Instruction()
  };

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
          W_WWCMP_WMSEQ  => ws2_val_view[i][j] == ws1_val_view[i][j],
          W_WWCMP_WMSNE  => ws2_val_view[i][j] != ws1_val_view[i][j],
          W_WWCMP_WMSLTU => unsigned(ws2_val_view[i][j]) < unsigned(ws1_val_view[i][j]),
          W_WWCMP_WMSLT  => signed(ws2_val_view[i][j]) < signed(ws1_val_view[i][j]),
          W_WWCMP_WMSLEU => unsigned(ws2_val_view[i][j]) <= unsigned(ws1_val_view[i][j]),
          W_WWCMP_WMSLE  => signed(ws2_val_view[i][j]) <= signed(ws1_val_view[i][j]),
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

mapping w_wwcmptype_mnemonic : w_wwcmpfunct6 <-> string = {
 W_WWCMP_WMSEQ    <-> "wmseq.ww",
 W_WWCMP_WMSNE    <-> "wmsne.ww",
 W_WWCMP_WMSLTU   <-> "wmsltu.ww",
 W_WWCMP_WMSLT    <-> "wmslt.ww",
 W_WWCMP_WMSLEU   <-> "wmsleu.ww",
 W_WWCMP_WMSLE    <-> "wmsle.ww"
}

mapping clause assembly = W_WWCMPTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_wwcmptype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ w_wreg_name(ws1) ^ w_maybe_wmask(wm)

// ****************************** OPIVX (WXMTYPE) *******************************
// WXM instructions' destination is a mask register (e.g. carry out)
// Instructions with no carry out will set mask result to current mask value
// May or may not read from source mask register (e.g. carry in)
union clause instruction = W_WXMTYPE : (w_wxmfunct6, wregidx, regidx, wregidx)

mapping w_encdec_wxmfunct6 : w_wxmfunct6 <-> bits(6) = {
 W_WXM_WMADC    <-> 0b010001, // carry in, carry out
 W_WXM_WMSBC    <-> 0b010011
}

mapping clause encdec = W_WXMTYPE(funct6, ws2, rs1, wd)
 <-> w_encdec_wxmfunct6(funct6) @ 0b0 @ w_encdec_wreg(ws2) @ encdec_reg(rs1) @ 0b100 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WXMTYPE(funct6, ws2, rs1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_wd_unmasked()
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(0b0, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask_carry(num_elem, 0b0, w_zwreg);
  let rs1_val : bits('m) = w_get_scalar(rs1, SEW);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
  let wd_val : bits('n) = w_read_wmask(num_elem, 0b0, wd);

  let (initial_result, mask) : (bits('n), bits('n)) = w_init_masked_result_carry(num_elem, SEW, W_LMUL_pow, wd_val);
  var result = initial_result;

  {
    let mask_view = w_shape(mask, w_columns);
    var result_view = w_shape(result, w_columns);
    let wm_val_view = w_shape(wm_val, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(wm_val_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        let res : bool = match funct6 {
          W_WXM_WMADC =>   unsigned(ws2_val_view[i][j])
                 + unsigned(rs1_val)
                 + (if wm_val_view[i][j] == 0b1 then 1 else 0)
                 > 2 ^ SEW
                 - 1,
          W_WXM_WMSBC =>   unsigned(ws2_val_view[i][j])
                 - unsigned(rs1_val)
                 - (if wm_val_view[i][j] == 0b1 then 1 else 0)
                 < 0,
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

mapping w_wxmtype_mnemonic : w_wxmfunct6 <-> string = {
 W_WXM_WMADC    <-> "wmadc.wxm", // carry in, carry out
 W_WXM_WMSBC    <-> "wmsbc.wxm"
}

mapping clause assembly = W_WXMTYPE(funct6, ws2, rs1, wd)
 <-> w_wxmtype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ reg_name(rs1) ^ sep() ^ "w0"

// ***************************** OPIVX (WXMCTYPE) *******************************
// WXMC instructions' destination is a mask register (e.g. carry out)
// Instructions with no carry out will set mask result to current mask value
// May or may not read from source mask register (e.g. carry in)
union clause instruction = W_WXMCTYPE : (w_wxmcfunct6, wregidx, regidx, wregidx)

mapping w_encdec_wxmcfunct6 : w_wxmcfunct6 <-> bits(6) = {
 W_WXMC_WMADC    <-> 0b010001, // carry in, carry out
 W_WXMC_WMSBC    <-> 0b010011
}

mapping clause encdec = W_WXMCTYPE(funct6, ws2, rs1, wd)
 <-> w_encdec_wxmcfunct6(funct6) @ 0b1 @ w_encdec_wreg(ws2) @ encdec_reg(rs1) @ 0b100 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WXMCTYPE(funct6, ws2, rs1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_wd_unmasked()
   | not(w_valid_reg_group(ws2, W_LMUL_pow)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let rs1_val : bits('m) = w_get_scalar(rs1, SEW);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
  let wd_val : bits('n) = w_read_wmask(num_elem, 0b0, wd);

  let (initial_result, mask) : (bits('n), bits('n)) = w_init_masked_result_carry(num_elem, SEW, W_LMUL_pow, wd_val);
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
          W_WXMC_WMADC => unsigned(ws2_val_view[i][j]) + unsigned(rs1_val) > 2 ^ SEW - 1,
          W_WXMC_WMSBC => unsigned(ws2_val_view[i][j]) - unsigned(rs1_val) < 0,
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

mapping w_wxmctype_mnemonic : w_wxmcfunct6 <-> string = {
 W_WXMC_WMADC    <-> "wmadc.wx", // carry in, carry out
 W_WXMC_WMSBC    <-> "wmsbc.wx"
}

mapping clause assembly = W_WXMCTYPE(funct6, ws2, rs1, wd)
 <-> w_wxmctype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ reg_name(rs1)

// ***************************** OPIVX (WXMSTYPE) *******************************
// WXMS instructions' destination is a matrix register (e.g. actual sum)
// Instructions with no carry out will set mask result to current mask value
// May or may not read from source mask register (e.g. carry in)
union clause instruction = W_WXMSTYPE : (w_wxmsfunct6, wregidx, regidx, wregidx)

mapping w_encdec_wxmsfunct6 : w_wxmsfunct6 <-> bits(6) = {
 W_WXMS_WADC     <-> 0b010000, // carry in, no carry out
 W_WXMS_WSBC     <-> 0b010010
}

mapping clause encdec = W_WXMSTYPE(funct6, ws2, rs1, wd)
 <-> w_encdec_wxmsfunct6(funct6) @ 0b0 @ w_encdec_wreg(ws2) @ encdec_reg(rs1) @ 0b100 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WXMSTYPE(funct6, ws2, rs1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_wd_masked(wd)
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_reg_group(wd, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(0b0, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  // for bypassing normal masking in init_masked_result
  let vec_trues : bits('n) = ones();

  let wm_val : bits('n) = w_read_wmask_carry(num_elem, 0b0, w_zwreg);
  let rs1_val : bits('m) = w_get_scalar(rs1, SEW);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW,
    W_LMUL_pow,
    wd_val,
    vec_trues,
  );
  var result = initial_result;

  {
    let mask_view = w_shape(mask, w_columns);
    var result_view = w_shape(result, w_columns);
    let wm_val_view = w_shape(wm_val, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(wm_val_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_WXMS_WADC => to_bits_unsafe(
            SEW,
            unsigned(ws2_val_view[i][j]) + unsigned(rs1_val) + (if wm_val_view[i][j] == 0b1 then 1 else 0),
          ),
          W_WXMS_WSBC => to_bits_unsafe(
            SEW,
            unsigned(ws2_val_view[i][j]) - unsigned(rs1_val) - (if wm_val_view[i][j] == 0b1 then 1 else 0),
          ),
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_wxmstype_mnemonic : w_wxmsfunct6 <-> string = {
 W_WXMS_WADC     <-> "wadc.wxm", // carry in, no carry out
 W_WXMS_WSBC     <-> "wsbc.wxm"
}

mapping clause assembly = W_WXMSTYPE(funct6, ws2, rs1, wd)
 <-> w_wxmstype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ reg_name(rs1) ^ sep() ^ "w0"

// **************** OPIVX (Matrix Integer Compare Instructions) *****************
// WXCMP instructions' destination is a mask register
union clause instruction = W_WXCMPTYPE : (w_wxcmpfunct6, bits(1), wregidx, regidx, wregidx)

mapping w_encdec_wxcmpfunct6 : w_wxcmpfunct6 <-> bits(6) = {
 W_WXCMP_WMSEQ    <-> 0b011000,
 W_WXCMP_WMSNE    <-> 0b011001,
 W_WXCMP_WMSLTU   <-> 0b011010,
 W_WXCMP_WMSLT    <-> 0b011011,
 W_WXCMP_WMSLEU   <-> 0b011100,
 W_WXCMP_WMSLE    <-> 0b011101,
 W_WXCMP_WMSGTU   <-> 0b011110,
 W_WXCMP_WMSGT    <-> 0b011111
}

mapping clause encdec = W_WXCMPTYPE(funct6, wm, ws2, rs1, wd)
 <-> w_encdec_wxcmpfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ encdec_reg(rs1) @ 0b100 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WXCMPTYPE(funct6, wm, ws2, rs1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_wd_unmasked()
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let rs1_val : bits('m) = w_get_scalar(rs1, SEW);
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
          W_WXCMP_WMSEQ  => ws2_val_view[i][j] == rs1_val,
          W_WXCMP_WMSNE  => ws2_val_view[i][j] != rs1_val,
          W_WXCMP_WMSLTU => unsigned(ws2_val_view[i][j]) < unsigned(rs1_val),
          W_WXCMP_WMSLT  => signed(ws2_val_view[i][j]) < signed(rs1_val),
          W_WXCMP_WMSLEU => unsigned(ws2_val_view[i][j]) <= unsigned(rs1_val),
          W_WXCMP_WMSLE  => signed(ws2_val_view[i][j]) <= signed(rs1_val),
          W_WXCMP_WMSGTU => unsigned(ws2_val_view[i][j]) > unsigned(rs1_val),
          W_WXCMP_WMSGT  => signed(ws2_val_view[i][j]) > signed(rs1_val),
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

mapping w_wxcmptype_mnemonic : w_wxcmpfunct6 <-> string = {
 W_WXCMP_WMSEQ    <-> "wmseq.wx",
 W_WXCMP_WMSNE    <-> "wmsne.wx",
 W_WXCMP_WMSLTU   <-> "wmsltu.wx",
 W_WXCMP_WMSLT    <-> "wmslt.wx",
 W_WXCMP_WMSLEU   <-> "wmsleu.wx",
 W_WXCMP_WMSLE    <-> "wmsle.wx",
 W_WXCMP_WMSGTU   <-> "wmsgtu.wx",
 W_WXCMP_WMSGT    <-> "wmsgt.wx"
}

mapping clause assembly = W_WXCMPTYPE(funct6, wm, ws2, rs1, wd)
 <-> w_wxcmptype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ reg_name(rs1) ^ w_maybe_wmask(wm)

// ****************************** OPIVI (WIMTYPE) *******************************
// WIM instructions' destination is a mask register (e.g. carry out)
// Instructions with no carry out will set mask result to current mask value
// May or may not read from source mask register (e.g. carry in)
union clause instruction = W_WIMTYPE : (w_wimfunct6, wregidx, bits(5), wregidx)

mapping w_encdec_wimfunct6 : w_wimfunct6 <-> bits(6) = {
 W_WIM_WMADC    <-> 0b010001 // carry in, carry out
}

mapping clause encdec = W_WIMTYPE(funct6, ws2, simm, wd)
 <-> w_encdec_wimfunct6(funct6) @ 0b0 @ w_encdec_wreg(ws2) @ simm @ 0b011 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WIMTYPE(funct6, ws2, simm, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_wd_unmasked()
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(0b0, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask_carry(num_elem, 0b0, w_zwreg);
  let imm_val : bits('m) = sign_extend(simm);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
  let wd_val : bits('n) = w_read_wmask(num_elem, 0b0, wd);

  let (initial_result, mask) : (bits('n), bits('n)) = w_init_masked_result_carry(num_elem, SEW, W_LMUL_pow, wd_val);
  var result = initial_result;

  {
    let mask_view = w_shape(mask, w_columns);
    var result_view = w_shape(result, w_columns);
    let wm_val_view = w_shape(wm_val, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(wm_val_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        let res : bool = match funct6 {
          W_WIM_WMADC =>   unsigned(ws2_val_view[i][j])
                 + unsigned(imm_val)
                 + (if wm_val_view[i][j] == 0b1 then 1 else 0)
                 > 2 ^ SEW
                 - 1,
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

mapping w_wimtype_mnemonic : w_wimfunct6 <-> string = {
 W_WIM_WMADC    <-> "wmadc.wim" // carry in, carry out
}

mapping clause assembly = W_WIMTYPE(funct6, ws2, simm, wd)
 <-> w_wimtype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ hex_bits_signed_5(simm) ^ sep() ^ "w0"

// ***************************** OPIVI (WIMCTYPE) *******************************
// WIMC instructions' destination is a mask register (e.g. carry out)
// Instructions with no carry out will set mask result to current mask value
// May or may not read from source mask register (e.g. carry in)
union clause instruction = W_WIMCTYPE : (w_wimcfunct6, wregidx, bits(5), wregidx)

mapping w_encdec_wimcfunct6 : w_wimcfunct6 <-> bits(6) = {
 W_WIMC_WMADC    <-> 0b010001 // carry in, carry out
}

mapping clause encdec = W_WIMCTYPE(funct6, ws2, simm, wd)
 <-> w_encdec_wimcfunct6(funct6) @ 0b1 @ w_encdec_wreg(ws2) @ simm @ 0b011 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WIMCTYPE(funct6, ws2, simm, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_wd_unmasked()
   | not(w_valid_reg_group(ws2, W_LMUL_pow)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let imm_val : bits('m) = sign_extend(simm);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
  let wd_val : bits('n) = w_read_wmask(num_elem, 0b0, wd);

  let (initial_result, mask) : (bits('n), bits('n)) = w_init_masked_result_carry(num_elem, SEW, W_LMUL_pow, wd_val);
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
          W_WIMC_WMADC => unsigned(ws2_val_view[i][j]) + unsigned(imm_val) > 2 ^ SEW - 1,
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

mapping w_wimctype_mnemonic : w_wimcfunct6 <-> string = {
 W_WIMC_WMADC    <-> "wmadc.wi" // Carry in, carry out
}

mapping clause assembly = W_WIMCTYPE(funct6, ws2, simm, wd)
 <-> w_wimctype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ hex_bits_signed_5(simm)

// ***************************** OPIVI (WIMSTYPE) *******************************
// WIMS instructions' destination is a matrix register (e.g. actual sum)
// Instructions with no carry out will set mask result to current mask value
// May or may not read from source mask register (e.g. carry in)
union clause instruction = W_WIMSTYPE : (w_wimsfunct6, wregidx, bits(5), wregidx)

mapping w_encdec_wimsfunct6 : w_wimsfunct6 <-> bits(6) = {
 W_WIMS_WADC     <-> 0b010000 // Carry in, no carry out
}

mapping clause encdec = W_WIMSTYPE(funct6, ws2, simm, wd)
 <-> w_encdec_wimsfunct6(funct6) @ 0b0 @ w_encdec_wreg(ws2) @ simm @ 0b011 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WIMSTYPE(funct6, ws2, simm, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_wd_masked(wd)
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_reg_group(wd, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(0b0, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  // for bypassing normal masking in init_masked_result
  let vec_trues : bits('n) = ones();

  let wm_val : bits('n) = w_read_wmask_carry(num_elem, 0b0, w_zwreg);
  let imm_val : bits('m) = sign_extend(simm);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW,
    W_LMUL_pow,
    wd_val,
    vec_trues,
  );
  var result = initial_result;

  {
    let mask_view = w_shape(mask, w_columns);
    var result_view = w_shape(result, w_columns);
    let wm_val_view = w_shape(wm_val, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(wm_val_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_WIMS_WADC => to_bits_unsafe(
            SEW,
            unsigned(ws2_val_view[i][j]) + unsigned(imm_val) + (if wm_val_view[i][j] == 0b1 then 1 else 0),
          ),
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_wimstype_mnemonic : w_wimsfunct6 <-> string = {
 W_WIMS_WADC     <-> "wadc.wim" // Carry in, no carry out
}

mapping clause assembly = W_WIMSTYPE(funct6, ws2, simm, wd)
 <-> w_wimstype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ hex_bits_signed_5(simm) ^ sep() ^ "w0"

// **************** OPIVI (Matrix Integer Compare Instructions) *****************
// WICMP instructions' destination is a mask register
union clause instruction = W_WICMPTYPE : (w_wicmpfunct6, bits(1), wregidx, bits(5), wregidx)

mapping w_encdec_wicmpfunct6 : w_wicmpfunct6 <-> bits(6) = {
 W_WICMP_WMSEQ    <-> 0b011000,
 W_WICMP_WMSNE    <-> 0b011001,
 W_WICMP_WMSLEU   <-> 0b011100,
 W_WICMP_WMSLE    <-> 0b011101,
 W_WICMP_WMSGTU   <-> 0b011110,
 W_WICMP_WMSGT    <-> 0b011111
}

mapping clause encdec = W_WICMPTYPE(funct6, wm, ws2, simm, wd)
 <-> w_encdec_wicmpfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ simm @ 0b011 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WICMPTYPE(funct6, wm, ws2, simm, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_wd_unmasked()
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let imm_val : bits('m) = sign_extend(simm);
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
          W_WICMP_WMSEQ  => ws2_val_view[i][j] == imm_val,
          W_WICMP_WMSNE  => ws2_val_view[i][j] != imm_val,
          W_WICMP_WMSLEU => unsigned(ws2_val_view[i][j]) <= unsigned(imm_val),
          W_WICMP_WMSLE  => signed(ws2_val_view[i][j]) <= signed(imm_val),
          W_WICMP_WMSGTU => unsigned(ws2_val_view[i][j]) > unsigned(imm_val),
          W_WICMP_WMSGT  => signed(ws2_val_view[i][j]) > signed(imm_val),
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

mapping w_wicmptype_mnemonic : w_wicmpfunct6 <-> string = {
 W_WICMP_WMSEQ    <-> "wmseq.wi",
 W_WICMP_WMSNE    <-> "wmsne.wi",
 W_WICMP_WMSLEU   <-> "wmsleu.wi",
 W_WICMP_WMSLE    <-> "wmsle.wi",
 W_WICMP_WMSGTU   <-> "wmsgtu.wi",
 W_WICMP_WMSGT    <-> "wmsgt.wi"
}

mapping clause assembly = W_WICMPTYPE(funct6, wm, ws2, simm, wd)
 <-> w_wicmptype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ hex_bits_signed_5(simm) ^ w_maybe_wmask(wm)
