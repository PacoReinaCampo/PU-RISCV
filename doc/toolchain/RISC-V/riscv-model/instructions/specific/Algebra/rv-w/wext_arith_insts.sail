// =======================================================================================
// This Sail RISC-W architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

// ******************************************************************************
// This file implements part of the matrix extension.
// Chapter 11: Matrix Integer Arithmetic Instructions
// Chapter 12: Matrix Fixed-Point Arithmetic Instructions
// Chapter 16: Matrix Permutation Instructions (integer part)
// ******************************************************************************

// ****************************** OPIVV (WWTYPE) ********************************
union clause instruction = W_WWTYPE : (w_wwfunct6, bits(1), wregidx, wregidx, wregidx)

mapping w_encdec_wwfunct6 : w_wwfunct6 <-> bits(6) = {
 W_WW_WADD          <-> 0b000000,
 W_WW_WSUB          <-> 0b000010,
 W_WW_WMINU         <-> 0b000100,
 W_WW_WMIN          <-> 0b000101,
 W_WW_WMAXU         <-> 0b000110,
 W_WW_WMAX          <-> 0b000111,
 W_WW_WAND          <-> 0b001001,
 W_WW_WOR           <-> 0b001010,
 W_WW_WXOR          <-> 0b001011,
 W_WW_WRGATHER      <-> 0b001100,
 W_WW_WRGATHEREI16  <-> 0b001110,
 W_WW_WSADDU        <-> 0b100000,
 W_WW_WSADD         <-> 0b100001,
 W_WW_WSSUBU        <-> 0b100010,
 W_WW_WSSUB         <-> 0b100011,
 W_WW_WSLL          <-> 0b100101,
 W_WW_WSMUL         <-> 0b100111,
 W_WW_WSRL          <-> 0b101000,
 W_WW_WSRA          <-> 0b101001,
 W_WW_WSSRL         <-> 0b101010,
 W_WW_WSSRA         <-> 0b101011
}

mapping clause encdec = W_WWTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_encdec_wwfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ w_encdec_wreg(ws1) @ 0b000 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64 & w_valid_wide_wwtype(funct6))

function clause execute(W_WWTYPE(funct6, wm, ws2, ws1, wd)) = {
  let W_SEW_pow = w_get_sew_pow();
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  // "The vrgatherei16.vv form uses SEW/LMUL for the data in vs2 but
  // EEW=16 and EMUL = (16/SEW)*LMUL for the indices in vs1."  Other
  // than that, all the other instructions here use a uniform SEW/LMUL
  // for their matrix operands.  Also, "For any vrgather instruction,
  // the destination vector register group cannot overlap with the
  // source vector register groups, otherwise the instruction encoding
  // is reserved."

  let ws1_emul_pow = if funct6 == W_WW_WRGATHEREI16 then {
      4 + W_LMUL_pow - W_SEW_pow
    } else {
      W_LMUL_pow
    };

  // Check for source destination overlaps for vrgather instructions.
  let src_dst_overlap : bool = if funct6 == W_WW_WRGATHER then {
      ws1 == wd | ws2 == wd
    } else {
      if funct6 == W_WW_WRGATHEREI16 then {
        not(w_valid_disjoint_reg_groups(ws1, wd, ws1_emul_pow, W_LMUL_pow)) | ws2 == wd
      } else {
        false
      }
    };

  let src_mask_overlap = not(w_valid_wm_src_overlap(wm, ws1, SEW)) | not(w_valid_wm_src_overlap(wm, ws2, SEW));

  let src_src_overlap : bool = if funct6 == W_WW_WRGATHEREI16 then {
      not(w_valid_src_overlap(ws1, 16, ws1_emul_pow, ws2, SEW, W_LMUL_pow))
    } else {
      false
    };

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_normal(wd, wm)
   | not(w_valid_reg_overlap(ws1, wd, ws1_emul_pow, W_LMUL_pow))
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | src_dst_overlap
   | src_src_overlap
   | src_mask_overlap then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let ws1_val : vector('n, bits('m)) = if funct6 == W_WW_WRGATHEREI16 then {
      vector_init(zeros())
    } else {
      w_read_wreg(num_elem, SEW, W_LMUL_pow, ws1)
    };
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);

  // See above for the ws1 operand of vrgatherei16.ww.  This is a
  // different variable from `ws1_val` due to its different type.
  let ws1_val_wrgatherei16 : vector('n, bits(16)) = if funct6 == W_WW_WRGATHEREI16 then {
      w_read_wreg(num_elem, 16, ws1_emul_pow, ws1)
    } else {
      vector_init(zeros())
    };

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
    let ws1_val_view = w_shape(ws1_val, w_columns);
    let ws1_val_wrgatherei16_view = w_shape(ws1_val_wrgatherei16, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ws1_val_view));
      assert(i < length(ws1_val_wrgatherei16_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_WW_WADD         => ws2_val_view[i][j] + ws1_val_view[i][j],
          W_WW_WSUB         => ws2_val_view[i][j] - ws1_val_view[i][j],
          W_WW_WAND         => ws2_val_view[i][j] & ws1_val_view[i][j],
          W_WW_WOR          => ws2_val_view[i][j] | ws1_val_view[i][j],
          W_WW_WXOR         => ws2_val_view[i][j] ^ ws1_val_view[i][j],
          W_WW_WSADDU       => w_unsigned_saturation(
            sizeof('m),
            zero_extend(sizeof('m) + 1, ws2_val_view[i][j]) +
              zero_extend(sizeof('m) + 1, ws1_val_view[i][j]),
          ),
          W_WW_WSADD        => w_signed_saturation(
            sizeof('m),
            sign_extend(sizeof('m) + 1, ws2_val_view[i][j]) +
              sign_extend(sizeof('m) + 1, ws1_val_view[i][j]),
          ),
          W_WW_WSSUBU       => {
            if unsigned(ws2_val_view[i][j]) < unsigned(ws1_val_view[i][j]) then {
              w_write_wxsat(0b1);
              zeros()
            } else {
              w_unsigned_saturation(
                sizeof('m),
                zero_extend(sizeof('m) + 1, ws2_val_view[i][j]) -
                  zero_extend(sizeof('m) + 1, ws1_val_view[i][j]),
              )
            }
          },
          W_WW_WSSUB        => w_signed_saturation(
            sizeof('m),
            sign_extend(sizeof('m) + 1, ws2_val_view[i][j]) -
              sign_extend(sizeof('m) + 1, ws1_val_view[i][j]),
          ),
          W_WW_WSMUL        => {
            let result_mul = to_bits_unsafe(
              sizeof('m) * 2,
              signed(ws2_val_view[i][j]) * signed(ws1_val_view[i][j]),
            );
            let rounding_incr = w_get_fixed_rounding_incr(result_mul, sizeof('m) - 1);
            let result_wide = (result_mul >> (sizeof('m) - 1)) + zero_extend(sizeof('m) * 2, rounding_incr);
            w_signed_saturation(sizeof('m), result_wide[sizeof('m) .. 0])
          },
          W_WW_WSLL         => {
            let shift_amount = w_get_shift_amount(ws1_val_view[i][j], SEW);
            ws2_val_view[i][j] << shift_amount
          },
          W_WW_WSRL         => {
            let shift_amount = w_get_shift_amount(ws1_val_view[i][j], SEW);
            ws2_val_view[i][j] >> shift_amount
          },
          W_WW_WSRA         => {
            let shift_amount = w_get_shift_amount(ws1_val_view[i][j], SEW);
            let w_double : bits('m * 2) = sign_extend(ws2_val_view[i][j]);
            (w_double >> shift_amount)[SEW - 1 .. 0]
          },
          W_WW_WSSRL        => {
            let shift_amount = w_get_shift_amount(ws1_val_view[i][j], SEW);
            let rounding_incr = w_get_fixed_rounding_incr(ws2_val_view[i][j], shift_amount);
            (ws2_val_view[i][j] >> shift_amount) + zero_extend(sizeof('m), rounding_incr)
          },
          W_WW_WSSRA        => {
            let shift_amount = w_get_shift_amount(ws1_val_view[i][j], SEW);
            let rounding_incr = w_get_fixed_rounding_incr(ws2_val_view[i][j], shift_amount);
            let w_double : bits('m * 2) = sign_extend(ws2_val_view[i][j]);
            (w_double >> shift_amount)[SEW - 1 .. 0] + zero_extend(sizeof('m), rounding_incr)
          },
          W_WW_WMINU        => to_bits_unsafe(SEW, min(unsigned(ws2_val_view[i][j]), unsigned(ws1_val_view[i][j]))),
          W_WW_WMIN         => to_bits_unsafe(SEW, min(signed(ws2_val_view[i][j]), signed(ws1_val_view[i][j]))),
          W_WW_WMAXU        => to_bits_unsafe(SEW, max(unsigned(ws2_val_view[i][j]), unsigned(ws1_val_view[i][j]))),
          W_WW_WMAX         => to_bits_unsafe(SEW, max(signed(ws2_val_view[i][j]), signed(ws1_val_view[i][j]))),
          W_WW_WRGATHER     => {
            let idx = unsigned(ws1_val_view[i][j]);
            assert(W_LMUL_pow + wlen_exp - W_SEW_pow >= 0);
            let WLMAX = 2 ^ (W_LMUL_pow + wlen_exp - W_SEW_pow);
            assert(WLMAX <= sizeof('n));
            if idx < WLMAX then {
              ws2_val_view[idx / w_columns][idx % w_columns]
            } else {
              zeros()
            }
          },
          W_WW_WRGATHEREI16 => {
            let idx = unsigned(ws1_val_wrgatherei16_view[i][j]);
            assert(W_LMUL_pow + wlen_exp - W_SEW_pow >= 0);
            let WLMAX = 2 ^ (W_LMUL_pow + wlen_exp - W_SEW_pow);
            assert(WLMAX <= sizeof('n));
            if idx < WLMAX then {
              ws2_val_view[idx / w_columns][idx % w_columns]
            } else {
              zeros()
            }
          },
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_wwtype_mnemonic : w_wwfunct6 <-> string = {
 W_WW_WADD          <-> "wadd.ww",
 W_WW_WSUB          <-> "wsub.ww",
 W_WW_WAND          <-> "wand.ww",
 W_WW_WOR           <-> "wor.ww",
 W_WW_WXOR          <-> "wxor.ww",
 W_WW_WRGATHER      <-> "wrgather.ww",
 W_WW_WRGATHEREI16  <-> "wrgatherei16.ww",
 W_WW_WSADDU        <-> "wsaddu.ww",
 W_WW_WSADD         <-> "wsadd.ww",
 W_WW_WSSUBU        <-> "wssubu.ww",
 W_WW_WSSUB         <-> "wssub.ww",
 W_WW_WSLL          <-> "wsll.ww",
 W_WW_WSMUL         <-> "wsmul.ww",
 W_WW_WSRL          <-> "wsrl.ww",
 W_WW_WSRA          <-> "wsra.ww",
 W_WW_WSSRL         <-> "wssrl.ww",
 W_WW_WSSRA         <-> "wssra.ww",
 W_WW_WMINU         <-> "wminu.ww",
 W_WW_WMIN          <-> "wmin.ww",
 W_WW_WMAXU         <-> "wmaxu.ww",
 W_WW_WMAX          <-> "wmax.ww"
}

mapping clause assembly = W_WWTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_wwtype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ w_wreg_name(ws1) ^ w_maybe_wmask(wm)

// ************************* OPIVV (WIDE_WTYPE Narrowing) ***************************
// ************* Matrix Narrowing Integer Right Shift Instructions **************
union clause instruction = W_NWSTYPE : (w_nwsfunct6, bits(1), wregidx, wregidx, wregidx)

mapping w_encdec_nwsfunct6 : w_nwsfunct6 <-> bits(6) = {
 W_NWS_WNSRL       <-> 0b101100,
 W_NWS_WNSRA       <-> 0b101101
}

mapping clause encdec = W_NWSTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_encdec_nwsfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ w_encdec_wreg(ws1) @ 0b000 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 16)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 32)

function clause execute(W_NWSTYPE(funct6, wm, ws2, ws1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = W_LMUL_pow + 1;

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_variable_width(wd, wm, SEW_widen, LMUL_pow_widen)
   | not(w_valid_reg_overlap(ws2, wd, LMUL_pow_widen, W_LMUL_pow))
   | not(w_valid_src_overlap(ws2, SEW_widen, LMUL_pow_widen, ws1, SEW, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws1, SEW))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW_widen)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);
  let ws1_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws1);
  let ws2_val : vector('n, bits('o)) = w_read_wreg(num_elem, SEW_widen, LMUL_pow_widen, ws2);

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
          W_NWS_WNSRL => {
            let shift_amount = w_get_shift_amount(ws1_val_view[i][j], SEW_widen);
            (ws2_val_view[i][j] >> shift_amount)[SEW - 1 .. 0]
          },
          W_NWS_WNSRA => {
            let shift_amount = w_get_shift_amount(ws1_val_view[i][j], SEW_widen);
            let w_double : bits('o * 2) = sign_extend(ws2_val_view[i][j]);
            let arith_shifted : bits('o) = (w_double >> shift_amount)[SEW_widen - 1 .. 0];
            arith_shifted[SEW - 1 .. 0]
          },
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_nwstype_mnemonic : w_nwsfunct6 <-> string = {
 W_NWS_WNSRL       <-> "wnsrl.wide.ww",
 W_NWS_WNSRA       <-> "wnsra.wide.ww"
}

mapping clause assembly = W_NWSTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_nwstype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ w_wreg_name(ws1) ^ w_maybe_wmask(wm)

// ************************* OPIVV (WIDE_WTYPE Narrowing) ***************************
// ************** Matrix Narrowing Fixed-Point Clip Instructions ****************
union clause instruction = W_NWTYPE : (w_nwfunct6, bits(1), wregidx, wregidx, wregidx)

mapping w_encdec_nwfunct6 : w_nwfunct6 <-> bits(6) = {
 W_NW_WNCLIPU     <-> 0b101110,
 W_NW_WNCLIP      <-> 0b101111
}

mapping clause encdec = W_NWTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_encdec_nwfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ w_encdec_wreg(ws1) @ 0b000 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 16)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 32)

function clause execute(W_NWTYPE(funct6, wm, ws2, ws1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = W_LMUL_pow + 1;

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_variable_width(wd, wm, SEW_widen, LMUL_pow_widen)
   | not(w_valid_reg_overlap(ws2, wd, LMUL_pow_widen, W_LMUL_pow))
   | not(w_valid_src_overlap(ws2, SEW_widen, LMUL_pow_widen, ws1, SEW, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws1, SEW))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW_widen)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);
  let ws1_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws1);
  let ws2_val : vector('n, bits('o)) = w_read_wreg(num_elem, SEW_widen, LMUL_pow_widen, ws2);

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
        let shift_amount = w_get_shift_amount(ws1_val_view[i][j], SEW_widen);
        let rounding_incr = w_get_fixed_rounding_incr(ws2_val_view[i][j], shift_amount);
        result_view[i][j] = match funct6 {
          W_NW_WNCLIPU => {
            let result_wide = (ws2_val_view[i][j] >> shift_amount) + zero_extend(sizeof('o), rounding_incr);
            w_unsigned_saturation(sizeof('m), result_wide)
          },
          W_NW_WNCLIP  => {
            let w_double : bits('m * 4) = sign_extend(ws2_val_view[i][j]);
            let result_wide = (w_double >> shift_amount)[sizeof('o) - 1 .. 0] +
                zero_extend(sizeof('o), rounding_incr);
            w_signed_saturation(sizeof('m), result_wide)
          },
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_nwtype_mnemonic : w_nwfunct6 <-> string = {
 W_NW_WNCLIPU     <-> "wnclipu.wide.ww",
 W_NW_WNCLIP      <-> "wnclip.wide.ww"
}

mapping clause assembly = W_NWTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_nwtype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ w_wreg_name(ws1) ^ w_maybe_wmask(wm)

// ********************* OPIVV (Integer Merge Instruction) **********************
union clause instruction = W_MASKTYPEW : (wregidx, wregidx, wregidx)

mapping clause encdec = W_MASKTYPEW (ws2, ws1,  wd)
 <-> 0b010111 @ 0b0 @ w_encdec_wreg(ws2) @ w_encdec_wreg(ws1) @ 0b000 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_MASKTYPEW(ws2, ws1, wd)) = {
  let start_element = w_get_start_element();
  let end_element = w_get_end_element();
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW); // max(WLMAX,WLEN/SEW))
  let real_num_elem = if W_LMUL_pow >= 0 then {
      num_elem
    } else {
      num_elem / (0 - W_LMUL_pow)
    }; // WLMAX

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

  let wm_val : bits('n) = w_read_wmask(num_elem, 0b0, w_zwreg);
  let ws1_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws1);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);
  var result : vector('n, bits('m)) = vector_init(zeros());

  let tail_ag : w_agtype = w_get_wtype_wta();
  {
    var result_view = w_shape(result, w_columns);
    let wd_val_view = w_shape(wd_val, w_columns);
    let wm_val_view = w_shape(wm_val, w_columns);
    let ws1_val_view = w_shape(ws1_val, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(result_view));
      assert(i < length(wd_val_view));
      assert(i < length(wm_val_view));
      assert(i < length(ws1_val_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if p < start_element then {
        result_view[i][j] = wd_val_view[i][j]
      } else {
        if p > end_element | p >= real_num_elem then {
          result_view[i][j] = match tail_ag {
            W_UNDISTURBED => wd_val_view[i][j],
            W_AGNOSTIC    => wd_val_view[i][j], // TODO: configuration support
          }
        } else {
          // the merge operates on all body elements
          result_view[i][j] =
            if wm_val_view[i][j] == 0b1 then {
              ws1_val_view[i][j]
            } else {
              ws2_val_view[i][j]
            }
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_MASKTYPEW(ws2, ws1, wd)
<-> "wmerge.wwm" ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ w_wreg_name(ws1) ^ sep() ^ "w0"

// ********************* OPIVV (Integer Move Instruction) ***********************
union clause instruction = W_MOVETYPEW : (wregidx, wregidx)

mapping clause encdec = W_MOVETYPEW (ws1, wd)
 <-> 0b010111 @ 0b1 @ 0b00000 @ w_encdec_wreg(ws1) @ 0b000 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_MOVETYPEW(ws1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_wd_unmasked()
   | not(w_valid_reg_group(ws1, W_LMUL_pow))
   | not(w_valid_reg_group(wd, W_LMUL_pow)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ws1_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws1);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW,
    W_LMUL_pow,
    wd_val,
    ones(),
  );
  var result = initial_result;

  {
    let mask_view = w_shape(mask, w_columns);
    var result_view = w_shape(result, w_columns);
    let ws1_val_view = w_shape(ws1_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ws1_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = ws1_val_view[i][j]
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_MOVETYPEW(ws1, wd)
 <-> "wmv.w.w" ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws1)

// ****************************** OPIVX (WXTYPE) ********************************
union clause instruction = W_WXTYPE : (w_wxfunct6, bits(1), wregidx, regidx, wregidx)

mapping w_encdec_wxfunct6 : w_wxfunct6 <-> bits(6) = {
 W_WX_WADD       <-> 0b000000,
 W_WX_WSUB       <-> 0b000010,
 W_WX_WRSUB      <-> 0b000011,
 W_WX_WMINU      <-> 0b000100,
 W_WX_WMIN       <-> 0b000101,
 W_WX_WMAXU      <-> 0b000110,
 W_WX_WMAX       <-> 0b000111,
 W_WX_WAND       <-> 0b001001,
 W_WX_WOR        <-> 0b001010,
 W_WX_WXOR       <-> 0b001011,
 W_WX_WSADDU     <-> 0b100000,
 W_WX_WSADD      <-> 0b100001,
 W_WX_WSSUBU     <-> 0b100010,
 W_WX_WSSUB      <-> 0b100011,
 W_WX_WSLL       <-> 0b100101,
 W_WX_WSMUL      <-> 0b100111,
 W_WX_WSRL       <-> 0b101000,
 W_WX_WSRA       <-> 0b101001,
 W_WX_WSSRL      <-> 0b101010,
 W_WX_WSSRA      <-> 0b101011
}

mapping clause encdec = W_WXTYPE(funct6, wm, ws2, rs1, wd)
 <-> w_encdec_wxfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ encdec_reg(rs1) @ 0b100 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64 & w_valid_wide_wxtype(funct6))

function clause execute(W_WXTYPE(funct6, wm, ws2, rs1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_normal(wd, wm)
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_reg_group(wd, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let rs1_val : bits('m) = w_get_scalar(rs1, SEW);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
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
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_WX_WADD   => ws2_val_view[i][j] + rs1_val,
          W_WX_WSUB   => ws2_val_view[i][j] - rs1_val,
          W_WX_WRSUB  => rs1_val - ws2_val_view[i][j],
          W_WX_WAND   => ws2_val_view[i][j] & rs1_val,
          W_WX_WOR    => ws2_val_view[i][j] | rs1_val,
          W_WX_WXOR   => ws2_val_view[i][j] ^ rs1_val,
          W_WX_WSADDU => w_unsigned_saturation(
            sizeof('m),
            zero_extend(sizeof('m) + 1, ws2_val_view[i][j]) + zero_extend(sizeof('m) + 1, rs1_val),
          ),
          W_WX_WSADD  => w_signed_saturation(
            sizeof('m),
            sign_extend(sizeof('m) + 1, ws2_val_view[i][j]) + sign_extend(sizeof('m) + 1, rs1_val),
          ),
          W_WX_WSSUBU => {
            if unsigned(ws2_val_view[i][j]) < unsigned(rs1_val) then {
              w_write_wxsat(0b1);
              zeros()
            } else {
              w_unsigned_saturation(
                sizeof('m),
                zero_extend(sizeof('m) + 1, ws2_val_view[i][j]) - zero_extend(sizeof('m) + 1, rs1_val),
              )
            }
          },
          W_WX_WSSUB  => w_signed_saturation(
            sizeof('m),
            sign_extend(sizeof('m) + 1, ws2_val_view[i][j]) - sign_extend(sizeof('m) + 1, rs1_val),
          ),
          W_WX_WSMUL  => {
            let result_mul = to_bits_unsafe(sizeof('m) * 2, signed(ws2_val_view[i][j]) * signed(rs1_val));
            let rounding_incr = w_get_fixed_rounding_incr(result_mul, sizeof('m) - 1);
            let result_wide = (result_mul >> (sizeof('m) - 1)) + zero_extend(sizeof('m) * 2, rounding_incr);
            w_signed_saturation(sizeof('m), result_wide[sizeof('m) .. 0])
          },
          W_WX_WSLL   => {
            let shift_amount = w_get_shift_amount(rs1_val, SEW);
            ws2_val_view[i][j] << shift_amount
          },
          W_WX_WSRL   => {
            let shift_amount = w_get_shift_amount(rs1_val, SEW);
            ws2_val_view[i][j] >> shift_amount
          },
          W_WX_WSRA   => {
            let shift_amount = w_get_shift_amount(rs1_val, SEW);
            let w_double : bits('m * 2) = sign_extend(ws2_val_view[i][j]);
            (w_double >> shift_amount)[SEW - 1 .. 0]
          },
          W_WX_WSSRL  => {
            let shift_amount = w_get_shift_amount(rs1_val, SEW);
            let rounding_incr = w_get_fixed_rounding_incr(ws2_val_view[i][j], shift_amount);
            (ws2_val_view[i][j] >> shift_amount) + zero_extend(sizeof('m), rounding_incr)
          },
          W_WX_WSSRA  => {
            let shift_amount = w_get_shift_amount(rs1_val, SEW);
            let rounding_incr = w_get_fixed_rounding_incr(ws2_val_view[i][j], shift_amount);
            let w_double : bits('m * 2) = sign_extend(ws2_val_view[i][j]);
            (w_double >> shift_amount)[SEW - 1 .. 0] + zero_extend(sizeof('m), rounding_incr)
          },
          W_WX_WMINU  => to_bits_unsafe(SEW, min(unsigned(ws2_val_view[i][j]), unsigned(rs1_val))),
          W_WX_WMIN   => to_bits_unsafe(SEW, min(signed(ws2_val_view[i][j]), signed(rs1_val))),
          W_WX_WMAXU  => to_bits_unsafe(SEW, max(unsigned(ws2_val_view[i][j]), unsigned(rs1_val))),
          W_WX_WMAX   => to_bits_unsafe(SEW, max(signed(ws2_val_view[i][j]), signed(rs1_val))),
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_wxtype_mnemonic : w_wxfunct6 <-> string = {
 W_WX_WADD       <-> "wadd.wx",
 W_WX_WSUB       <-> "wsub.wx",
 W_WX_WRSUB      <-> "wrsub.wx",
 W_WX_WAND       <-> "wand.wx",
 W_WX_WOR        <-> "wor.wx",
 W_WX_WXOR       <-> "wxor.wx",
 W_WX_WSADDU     <-> "wsaddu.wx",
 W_WX_WSADD      <-> "wsadd.wx",
 W_WX_WSSUBU     <-> "wssubu.wx",
 W_WX_WSSUB      <-> "wssub.wx",
 W_WX_WSLL       <-> "wsll.wx",
 W_WX_WSMUL      <-> "wsmul.wx",
 W_WX_WSRL       <-> "wsrl.wx",
 W_WX_WSRA       <-> "wsra.wx",
 W_WX_WSSRL      <-> "wssrl.wx",
 W_WX_WSSRA      <-> "wssra.wx",
 W_WX_WMINU      <-> "wminu.wx",
 W_WX_WMIN       <-> "wmin.wx",
 W_WX_WMAXU      <-> "wmaxu.wx",
 W_WX_WMAX       <-> "wmax.wx"
}

mapping clause assembly = W_WXTYPE(funct6, wm, ws2, rs1, wd)
 <-> w_wxtype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ reg_name(rs1) ^ w_maybe_wmask(wm)

// ************************* OPIVX (WIDE_XTYPE Narrowing) ***************************
// ************* Matrix Narrowing Integer Right Shift Instructions **************
union clause instruction = W_NXSTYPE : (w_nxsfunct6, bits(1), wregidx, regidx, wregidx)

mapping w_encdec_nxsfunct6 : w_nxsfunct6 <-> bits(6) = {
 W_NXS_WNSRL       <-> 0b101100,
 W_NXS_WNSRA       <-> 0b101101
}

mapping clause encdec = W_NXSTYPE(funct6, wm, ws2, rs1, wd)
 <-> w_encdec_nxsfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ encdec_reg(rs1) @ 0b100 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 16)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 32)

function clause execute(W_NXSTYPE(funct6, wm, ws2, rs1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = W_LMUL_pow + 1;

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_variable_width(wd, wm, SEW_widen, LMUL_pow_widen)
   | not(w_valid_reg_overlap(ws2, wd, LMUL_pow_widen, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW_widen)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);
  let rs1_val : bits('m) = w_get_scalar(rs1, SEW);
  let ws2_val : vector('n, bits('o)) = w_read_wreg(num_elem, SEW_widen, LMUL_pow_widen, ws2);

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
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_NXS_WNSRL => {
            let shift_amount = w_get_shift_amount(rs1_val, SEW_widen);
            (ws2_val_view[i][j] >> shift_amount)[SEW - 1 .. 0]
          },
          W_NXS_WNSRA => {
            let shift_amount = w_get_shift_amount(rs1_val, SEW_widen);
            let w_double : bits('o * 2) = sign_extend(ws2_val_view[i][j]);
            let arith_shifted : bits('o) = (w_double >> shift_amount)[SEW_widen - 1 .. 0];
            arith_shifted[SEW - 1 .. 0]
          },
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_nxstype_mnemonic : w_nxsfunct6 <-> string = {
 W_NXS_WNSRL       <-> "wnsrl.wide.wx",
 W_NXS_WNSRA       <-> "wnsra.wide.wx"
}

mapping clause assembly = W_NXSTYPE(funct6, wm, ws2, rs1, wd)
 <-> w_nxstype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ reg_name(rs1) ^ w_maybe_wmask(wm)

// ************************* OPIVX (WIDE_XTYPE Narrowing) ***************************
// ************** Matrix Narrowing Fixed-Point Clip Instructions ****************
union clause instruction = W_NXTYPE : (w_nxfunct6, bits(1), wregidx, regidx, wregidx)

mapping w_encdec_nxfunct6 : w_nxfunct6 <-> bits(6) = {
 W_NX_WNCLIPU     <-> 0b101110,
 W_NX_WNCLIP      <-> 0b101111
}

mapping clause encdec = W_NXTYPE(funct6, wm, ws2, rs1, wd)
 <-> w_encdec_nxfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ encdec_reg(rs1) @ 0b100 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 16)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 32)

function clause execute(W_NXTYPE(funct6, wm, ws2, rs1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = W_LMUL_pow + 1;

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_variable_width(wd, wm, SEW_widen, LMUL_pow_widen)
   | not(w_valid_reg_overlap(ws2, wd, LMUL_pow_widen, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW_widen)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);
  let rs1_val : bits('m) = w_get_scalar(rs1, SEW);
  let ws2_val : vector('n, bits('o)) = w_read_wreg(num_elem, SEW_widen, LMUL_pow_widen, ws2);

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
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        let shift_amount = w_get_shift_amount(rs1_val, SEW_widen);
        let rounding_incr = w_get_fixed_rounding_incr(ws2_val_view[i][j], shift_amount);
        result_view[i][j] = match funct6 {
          W_NX_WNCLIPU => {
            let result_wide = (ws2_val_view[i][j] >> shift_amount) + zero_extend(sizeof('o), rounding_incr);
            w_unsigned_saturation(sizeof('m), result_wide)
          },
          W_NX_WNCLIP  => {
            let w_double : bits('m * 4) = sign_extend(ws2_val_view[i][j]);
            let result_wide = (w_double >> shift_amount)[sizeof('o) - 1 .. 0] +
                zero_extend(sizeof('o), rounding_incr);
            w_signed_saturation(sizeof('m), result_wide)
          },
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_nxtype_mnemonic : w_nxfunct6 <-> string = {
 W_NX_WNCLIPU     <-> "wnclipu.wide.wx",
 W_NX_WNCLIP      <-> "wnclip.wide.wx"
}

mapping clause assembly = W_NXTYPE(funct6, wm, ws2, rs1, wd)
 <-> w_nxtype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ reg_name(rs1) ^ w_maybe_wmask(wm)

// **************** OPIVX (Matrix Slide & Gather Instructions) ******************
// Slide and gather instructions extend rs1/imm to XLEN instead of SEW bits
union clause instruction = W_WXSG : (w_wxsgfunct6, bits(1), wregidx, regidx, wregidx)

mapping w_encdec_wxsgfunct6 : w_wxsgfunct6 <-> bits(6) = {
 W_WX_WSLIDEUP     <-> 0b001110,
 W_WX_WSLIDEDOWN   <-> 0b001111,
 W_WX_WRGATHER     <-> 0b001100
}

mapping clause encdec = W_WXSG(funct6, wm, ws2, rs1, wd)
 <-> w_encdec_wxsgfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ encdec_reg(rs1) @ 0b100 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WXSG(funct6, wm, ws2, rs1, wd)) = {
  let W_SEW_pow = w_get_sew_pow();
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  // For `vslideup` and `vrgather`, "the destination vector register
  // group cannot overlap with the source vector register groups,
  // otherwise the instruction encoding is reserved."
  let src_dst_overlap : bool = match funct6 {
    W_WX_WSLIDEUP   => wd == ws2,
    W_WX_WSLIDEDOWN => false,
    W_WX_WRGATHER   => wd == ws2,
  };

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_normal(wd, wm)
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_reg_group(wd, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW))
   | src_dst_overlap then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let rs1_val : nat = unsigned(X(rs1));
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
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
    let wd_val_view = w_shape(wd_val, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(wd_val_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_WX_WSLIDEUP   => {
            if p >= rs1_val then {
              ws2_val_view[(p - rs1_val) / w_columns][(p - rs1_val) % w_columns]
            } else {
              wd_val_view[i][j]
            }
          },
          W_WX_WSLIDEDOWN => {
            assert(W_LMUL_pow + wlen_exp - W_SEW_pow >= 0);
            let WLMAX = 2 ^ (W_LMUL_pow + wlen_exp - W_SEW_pow);
            assert(WLMAX > 0 & WLMAX <= sizeof('n));
            if p + rs1_val < WLMAX then {
              ws2_val_view[(p + rs1_val) / w_columns][(p + rs1_val) % w_columns]
            } else {
              zeros()
            }
          },
          W_WX_WRGATHER   => {
            assert(W_LMUL_pow + wlen_exp - W_SEW_pow >= 0);
            let WLMAX = 2 ^ (W_LMUL_pow + wlen_exp - W_SEW_pow);
            assert(WLMAX > 0 & WLMAX <= sizeof('n));
            if rs1_val < WLMAX then {
              ws2_val_view[rs1_val / w_columns][rs1_val % w_columns]
            } else {
              zeros()
            }
          },
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_wxsg_mnemonic : w_wxsgfunct6 <-> string = {
 W_WX_WSLIDEUP     <-> "wslideup.wx",
 W_WX_WSLIDEDOWN   <-> "wslidedown.wx",
 W_WX_WRGATHER     <-> "wrgather.wx"
}

mapping clause assembly = W_WXSG(funct6, wm, ws2, rs1, wd)
 <-> w_wxsg_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ reg_name(rs1) ^ w_maybe_wmask(wm)

// ********************* OPIVX (Integer Merge Instruction) **********************
union clause instruction = W_MASKTYPEX : (wregidx, regidx, wregidx)

mapping clause encdec = W_MASKTYPEX(ws2, rs1, wd)
 <-> 0b010111 @ 0b0 @ w_encdec_wreg(ws2) @ encdec_reg(rs1) @ 0b100 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_MASKTYPEX(ws2, rs1, wd)) = {
  let start_element = w_get_start_element();
  let end_element = w_get_end_element();
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW); // max(WLMAX,WLEN/SEW))
  let real_num_elem = if W_LMUL_pow >= 0 then {
      num_elem
    } else {
      num_elem / (0 - W_LMUL_pow)
    }; // WLMAX

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_wd_masked(wd)
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_reg_group(wd, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(0b0, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, 0b0, w_zwreg);
  let rs1_val : bits('m) = w_get_scalar(rs1, SEW);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);
  var result : vector('n, bits('m)) = vector_init(zeros());

  let tail_ag : w_agtype = w_get_wtype_wta();
  {
    var result_view = w_shape(result, w_columns);
    let wd_val_view = w_shape(wd_val, w_columns);
    let wm_val_view = w_shape(wm_val, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(result_view));
      assert(i < length(wd_val_view));
      assert(i < length(wm_val_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if p < start_element then {
        result_view[i][j] = wd_val_view[i][j]
      } else {
        if p > end_element | p >= real_num_elem then {
          result_view[i][j] = match tail_ag {
            W_UNDISTURBED => wd_val_view[i][j],
            W_AGNOSTIC    => wd_val_view[i][j], // TODO: configuration support
          }
        } else {
          // the merge operates on all body elements
          result_view[i][j] =
            if wm_val_view[i][j] == 0b1 then {
              rs1_val
            } else {
              ws2_val_view[i][j]
            }
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_MASKTYPEX(ws2, rs1, wd)
 <-> "wmerge.wxm" ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ reg_name(rs1) ^ sep() ^ "w0"

// ********************* OPIVX (Integer Move Instruction) ***********************
union clause instruction = W_MOVETYPEX : (regidx, wregidx)

mapping clause encdec = W_MOVETYPEX (rs1, wd)
 <-> 0b010111 @ 0b1 @ 0b00000 @ encdec_reg(rs1) @ 0b100 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_MOVETYPEX(rs1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_wd_unmasked()
   | not(w_valid_reg_group(wd, W_LMUL_pow)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let rs1_val : bits('m) = w_get_scalar(rs1, sizeof('m));
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW,
    W_LMUL_pow,
    wd_val,
    ones(),
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
        result_view[i][j] = rs1_val
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_MOVETYPEX(rs1, wd)
 <-> "wmv.w.x" ^ spc() ^ w_wreg_name(wd) ^ sep() ^ reg_name(rs1)

// ****************************** OPIVI (WITYPE) ********************************
union clause instruction = W_WITYPE : (w_wifunct6, bits(1), wregidx, bits(5), wregidx)

mapping w_encdec_wifunct6 : w_wifunct6 <-> bits(6) = {
 W_WI_WADD       <-> 0b000000,
 W_WI_WRSUB      <-> 0b000011,
 W_WI_WAND       <-> 0b001001,
 W_WI_WOR        <-> 0b001010,
 W_WI_WXOR       <-> 0b001011,
 W_WI_WSADDU     <-> 0b100000,
 W_WI_WSADD      <-> 0b100001,
 W_WI_WSLL       <-> 0b100101,
 W_WI_WSRL       <-> 0b101000,
 W_WI_WSRA       <-> 0b101001,
 W_WI_WSSRL      <-> 0b101010,
 W_WI_WSSRA      <-> 0b101011
}

mapping clause encdec = W_WITYPE(funct6, wm, ws2, simm, wd)
 <-> w_encdec_wifunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ simm @ 0b011 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WITYPE(funct6, wm, ws2, simm, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_normal(wd, wm)
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_reg_group(wd, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let imm_val : bits('m) = sign_extend(simm);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
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
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_WI_WADD   => ws2_val_view[i][j] + imm_val,
          W_WI_WRSUB  => imm_val - ws2_val_view[i][j],
          W_WI_WAND   => ws2_val_view[i][j] & imm_val,
          W_WI_WOR    => ws2_val_view[i][j] | imm_val,
          W_WI_WXOR   => ws2_val_view[i][j] ^ imm_val,
          W_WI_WSADDU => w_unsigned_saturation(
            sizeof('m),
            zero_extend(sizeof('m) + 1, ws2_val_view[i][j]) + zero_extend(sizeof('m) + 1, imm_val),
          ),
          W_WI_WSADD  => w_signed_saturation(
            sizeof('m),
            sign_extend(sizeof('m) + 1, ws2_val_view[i][j]) + sign_extend(sizeof('m) + 1, imm_val),
          ),
          W_WI_WSLL   => {
            let shift_amount = w_get_shift_amount(zero_extend(sizeof('m), simm), SEW);
            ws2_val_view[i][j] << shift_amount
          },
          W_WI_WSRL   => {
            let shift_amount = w_get_shift_amount(zero_extend(sizeof('m), simm), SEW);
            ws2_val_view[i][j] >> shift_amount
          },
          W_WI_WSRA   => {
            let shift_amount = w_get_shift_amount(zero_extend(sizeof('m), simm), SEW);
            let w_double : bits('m * 2) = sign_extend(ws2_val_view[i][j]);
            (w_double >> shift_amount)[SEW - 1 .. 0]
          },
          W_WI_WSSRL  => {
            let shift_amount = w_get_shift_amount(zero_extend(sizeof('m), simm), SEW);
            let rounding_incr = w_get_fixed_rounding_incr(ws2_val_view[i][j], shift_amount);
            (ws2_val_view[i][j] >> shift_amount) + zero_extend(sizeof('m), rounding_incr)
          },
          W_WI_WSSRA  => {
            let shift_amount = w_get_shift_amount(zero_extend(sizeof('m), simm), SEW);
            let rounding_incr = w_get_fixed_rounding_incr(ws2_val_view[i][j], shift_amount);
            let w_double : bits('m * 2) = sign_extend(ws2_val_view[i][j]);
            (w_double >> shift_amount)[SEW - 1 .. 0] + zero_extend(sizeof('m), rounding_incr)
          },
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_witype_mnemonic : w_wifunct6 <-> string = {
 W_WI_WADD   <-> "wadd.wi",
 W_WI_WRSUB  <-> "wrsub.wi",
 W_WI_WAND   <-> "wand.wi",
 W_WI_WOR    <-> "wor.wi",
 W_WI_WXOR   <-> "wxor.wi",
 W_WI_WSADDU <-> "wsaddu.wi",
 W_WI_WSADD  <-> "wsadd.wi",
 W_WI_WSLL   <-> "wsll.wi",
 W_WI_WSRL   <-> "wsrl.wi",
 W_WI_WSRA   <-> "wsra.wi",
 W_WI_WSSRL  <-> "wssrl.wi",
 W_WI_WSSRA  <-> "wssra.wi"
}

mapping clause assembly = W_WITYPE(funct6, wm, ws2, simm, wd)
 <-> w_witype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ hex_bits_signed_5(simm) ^ w_maybe_wmask(wm)

// ************************* OPIVI (WITYPE Narrowing) ***************************
// ************* Matrix Narrowing Integer Right Shift Instructions **************
union clause instruction = W_NISTYPE : (w_nisfunct6, bits(1), wregidx, bits(5), wregidx)

mapping w_encdec_nisfunct6 : w_nisfunct6 <-> bits(6) = {
 W_NIS_WNSRL       <-> 0b101100,
 W_NIS_WNSRA       <-> 0b101101
}

mapping clause encdec = W_NISTYPE(funct6, wm, ws2, uimm, wd)
 <-> w_encdec_nisfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ uimm @ 0b011 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 16)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 32)

function clause execute(W_NISTYPE(funct6, wm, ws2, uimm, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = W_LMUL_pow + 1;

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_variable_width(wd, wm, SEW_widen, LMUL_pow_widen)
   | not(w_valid_reg_overlap(ws2, wd, LMUL_pow_widen, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW_widen)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);
  let imm_val : bits('m) = zero_extend(uimm);
  let ws2_val : vector('n, bits('o)) = w_read_wreg(num_elem, SEW_widen, LMUL_pow_widen, ws2);

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
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_NIS_WNSRL => {
            let shift_amount = w_get_shift_amount(imm_val, SEW_widen);
            (ws2_val_view[i][j] >> shift_amount)[SEW - 1 .. 0]
          },
          W_NIS_WNSRA => {
            let shift_amount = w_get_shift_amount(imm_val, SEW_widen);
            let w_double : bits('o * 2) = sign_extend(ws2_val_view[i][j]);
            let arith_shifted : bits('o) = (w_double >> shift_amount)[SEW_widen - 1 .. 0];
            arith_shifted[SEW - 1 .. 0]
          },
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_nistype_mnemonic : w_nisfunct6 <-> string = {
 W_NIS_WNSRL       <-> "wnsrl.wide.wi",
 W_NIS_WNSRA       <-> "wnsra.wide.wi"
}

mapping clause assembly = W_NISTYPE(funct6, wm, ws2, uimm, wd)
 <-> w_nistype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ hex_bits_5(uimm) ^ w_maybe_wmask(wm)

// ************************* OPIVI (WITYPE Narrowing) ***************************
// ************** Matrix Narrowing Fixed-Point Clip Instructions ****************
union clause instruction = W_NITYPE : (w_nifunct6, bits(1), wregidx, bits(5), wregidx)

mapping w_encdec_nifunct6 : w_nifunct6 <-> bits(6) = {
 W_NI_WNCLIPU     <-> 0b101110,
 W_NI_WNCLIP      <-> 0b101111
}

mapping clause encdec = W_NITYPE(funct6, wm, ws2, uimm, wd)
 <-> w_encdec_nifunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ uimm @ 0b011 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 16)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 32)

function clause execute(W_NITYPE(funct6, wm, ws2, uimm, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = W_LMUL_pow + 1;

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_variable_width(wd, wm, SEW_widen, LMUL_pow_widen)
   | not(w_valid_reg_overlap(ws2, wd, LMUL_pow_widen, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW_widen)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);
  let imm_val : bits('m) = zero_extend(uimm);
  let ws2_val : vector('n, bits('o)) = w_read_wreg(num_elem, SEW_widen, LMUL_pow_widen, ws2);

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
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        let shift_amount = w_get_shift_amount(imm_val, SEW_widen);
        let rounding_incr = w_get_fixed_rounding_incr(ws2_val_view[i][j], shift_amount);
        result_view[i][j] = match funct6 {
          W_NI_WNCLIPU => {
            let result_wide = (ws2_val_view[i][j] >> shift_amount) + zero_extend(sizeof('o), rounding_incr);
            w_unsigned_saturation(sizeof('m), result_wide)
          },
          W_NI_WNCLIP  => {
            let w_double : bits('m * 4) = sign_extend(ws2_val_view[i][j]);
            let result_wide = (w_double >> shift_amount)[sizeof('o) - 1 .. 0] +
                zero_extend(sizeof('o), rounding_incr);
            w_signed_saturation(sizeof('m), result_wide)
          },
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_nitype_mnemonic : w_nifunct6 <-> string = {
 W_NI_WNCLIPU     <-> "wnclipu.wide.wi",
 W_NI_WNCLIP      <-> "wnclip.wide.wi"
}

mapping clause assembly = W_NITYPE(funct6, wm, ws2, uimm, wd)
 <-> w_nitype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ hex_bits_5(uimm) ^ w_maybe_wmask(wm)

// **************** OPIVI (Matrix Slide & Gather Instructions) ******************
// Slide and gather instructions extend rs1/imm to XLEN instead of SEW bits
union clause instruction = W_WISG : (w_wisgfunct6, bits(1), wregidx, bits(5), wregidx)

mapping w_encdec_wisgfunct6 : w_wisgfunct6 <-> bits(6) = {
 W_WI_WSLIDEUP     <-> 0b001110,
 W_WI_WSLIDEDOWN   <-> 0b001111,
 W_WI_WRGATHER     <-> 0b001100
}

mapping clause encdec = W_WISG(funct6, wm, ws2, simm, wd)
 <-> w_encdec_wisgfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ simm @ 0b011 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WISG(funct6, wm, ws2, simm, wd)) = {
  let W_SEW_pow = w_get_sew_pow();
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  // For `vslideup` and `vrgather`, "the destination vector register
  // group cannot overlap with the source vector register groups,
  // otherwise the instruction encoding is reserved."
  let src_dst_overlap : bool = match funct6 {
    W_WI_WSLIDEUP   => wd == ws2,
    W_WI_WSLIDEDOWN => false,
    W_WI_WRGATHER   => wd == ws2,
  };
  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_normal(wd, wm)
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_reg_group(wd, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW))
   | src_dst_overlap then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let imm_val : nat = unsigned(zero_extend(xlen, simm));
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
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
    let wd_val_view = w_shape(wd_val, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(wd_val_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_WI_WSLIDEUP   => {
            if p >= imm_val then {
              ws2_val_view[(p - imm_val) / w_columns][(p - imm_val) % w_columns]
            } else {
              wd_val_view[i][j]
            }
          },
          W_WI_WSLIDEDOWN => {
            assert(W_LMUL_pow + wlen_exp - W_SEW_pow >= 0);
            let WLMAX = 2 ^ (W_LMUL_pow + wlen_exp - W_SEW_pow);
            assert(WLMAX > 0 & WLMAX <= sizeof('n));
            if p + imm_val < WLMAX then {
              ws2_val_view[(p + imm_val) / w_columns][(p + imm_val) % w_columns]
            } else {
              zeros()
            }
          },
          W_WI_WRGATHER   => {
            assert(W_LMUL_pow + wlen_exp - W_SEW_pow >= 0);
            let WLMAX = 2 ^ (W_LMUL_pow + wlen_exp - W_SEW_pow);
            assert(WLMAX > 0 & WLMAX <= sizeof('n));
            if imm_val < WLMAX then {
              ws2_val_view[imm_val / w_columns][imm_val % w_columns]
            } else {
              zeros()
            }
          },
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_wisg_mnemonic : w_wisgfunct6 <-> string = {
 W_WI_WSLIDEUP     <-> "wslideup.wi",
 W_WI_WSLIDEDOWN   <-> "wslidedown.wi",
 W_WI_WRGATHER     <-> "wrgather.wi"
}

mapping clause assembly = W_WISG(funct6, wm, ws2, simm, wd)
 <-> w_wisg_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ hex_bits_signed_5(simm) ^ w_maybe_wmask(wm)

// ********************* OPIVI (Integer Merge Instruction) **********************
union clause instruction = W_MASKTYPEI : (wregidx, bits(5), wregidx)

mapping clause encdec = W_MASKTYPEI(ws2, simm, wd)
 <-> 0b010111 @ 0b0 @ w_encdec_wreg(ws2) @ simm @ 0b011 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_MASKTYPEI(ws2, simm, wd)) = {
  let start_element = w_get_start_element();
  let end_element = w_get_end_element();
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW); // max(WLMAX,WLEN/SEW))
  let real_num_elem = if W_LMUL_pow >= 0 then {
      num_elem
    } else {
      num_elem / (0 - W_LMUL_pow)
    }; // WLMAX

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_wd_masked(wd)
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_reg_group(wd, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(0b0, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, 0b0, w_zwreg);
  let imm_val : bits('m) = sign_extend(simm);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);
  var result : vector('n, bits('m)) = vector_init(zeros());

  let tail_ag : w_agtype = w_get_wtype_wta();
  {
    var result_view = w_shape(result, w_columns);
    let wd_val_view = w_shape(wd_val, w_columns);
    let wm_val_view = w_shape(wm_val, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(result_view));
      assert(i < length(wd_val_view));
      assert(i < length(wm_val_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if p < start_element then {
        result_view[i][j] = wd_val_view[i][j]
      } else {
        if p > end_element | p >= real_num_elem then {
          result_view[i][j] = match tail_ag {
            W_UNDISTURBED => wd_val_view[i][j],
            W_AGNOSTIC    => wd_val_view[i][j], // TODO: configuration support
          }
        } else {
          // the merge operates on all body elements
          result_view[i][j] =
            if wm_val_view[i][j] == 0b1 then {
              imm_val
            } else {
              ws2_val_view[i][j]
            }
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_MASKTYPEI(ws2, simm, wd)
 <-> "wmerge.wim" ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ hex_bits_signed_5(simm) ^ sep() ^ "w0"

// ********************* OPIVI (Integer Move Instruction) ***********************
union clause instruction = W_MOVETYPEI : (wregidx, bits(5))

mapping clause encdec = W_MOVETYPEI (wd, simm)
 <-> 0b010111 @ 0b1 @ 0b00000 @ simm @ 0b011 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_MOVETYPEI(wd, simm)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_wd_unmasked()
   | not(w_valid_reg_group(wd, W_LMUL_pow)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let imm_val : bits('m) = sign_extend(simm);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW,
    W_LMUL_pow,
    wd_val,
    ones(),
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
        result_view[i][j] = imm_val
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_MOVETYPEI(wd, simm)
 <-> "wmv.w.i" ^ spc() ^ w_wreg_name(wd) ^ sep() ^ hex_bits_signed_5(simm)

// ******************** OPIVI (Whole Matrix Register Move) **********************
union clause instruction = W_WMVRTYPE : (wregidx, {1, 2, 4, 8}, wregidx)

// "The number of vector registers to copy is encoded in the low three
// bits of the simm field (simm[2:0]) using the same encoding as the nf[2:0]
// field for memory instructions, i.e., simm[2:0] = NREG-1.
//
// The value of NREG must be 1, 2, 4, or 8, and values of simm[4:0] other
// than 0, 1, 3, and 7 are reserved."
mapping w_encdec_nreg : bits(5) <-> {1, 2, 4, 8} = {
 0b00000 <-> 1,
 0b00001 <-> 2,
 0b00011 <-> 4,
 0b00111 <-> 8,
}

mapping clause encdec = W_WMVRTYPE(ws2, nreg, wd)
 <-> 0b100111 @ 0b1 @ w_encdec_wreg(ws2) @ w_encdec_nreg(nreg) @ 0b011 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WMVRTYPE(ws2, nreg, wd)) = {
  let start_element = w_get_start_element();
  let SEW = w_get_sew();
  let EMUL = nreg;

  let EMUL_pow : range(0, 3) = match EMUL {
    1 => 0,
    2 => 1,
    4 => 2,
    8 => 3,
  };
  let num_elem = w_get_num_elem(EMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, EMUL_pow)
   | w_illegal_wd_unmasked()
   | not(w_valid_reg_group(ws2, EMUL_pow))
   | not(w_valid_reg_group(wd, EMUL_pow)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, EMUL_pow, ws2);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, EMUL_pow, wd);
  var result : vector('n, bits('m)) = vector_init(zeros());

  {
    var result_view = w_shape(result, w_columns);
    let wd_val_view = w_shape(wd_val, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(result_view));
      assert(i < length(wd_val_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      result_view[i][j] =
        if p < start_element then {
          wd_val_view[i][j]
        } else {
          ws2_val_view[i][j]
        }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, EMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

// This is unfortunate. See https://github.com/rems-project/sail/issues/768
mapping w_nreg_string : {1, 2, 4, 8} <-> string = {
 1 <-> "1",
 2 <-> "2",
 4 <-> "4",
 8 <-> "8",
}

mapping clause assembly = W_WMVRTYPE(ws2, nreg, wd)
 <-> "wmv" ^ w_nreg_string(nreg) ^ "r.w" ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2)

// ****************************** OPMVV (WWTYPE) ********************************
union clause instruction = W_MWWTYPE : (w_mwwfunct6, bits(1), wregidx, wregidx, wregidx)

mapping w_encdec_mwwfunct6 : w_mwwfunct6 <-> bits(6) = {
 W_MWW_WAADDU      <-> 0b001000,
 W_MWW_WAADD       <-> 0b001001,
 W_MWW_WASUBU      <-> 0b001010,
 W_MWW_WASUB       <-> 0b001011,
 W_MWW_WMUL        <-> 0b100101,
 W_MWW_WMULH       <-> 0b100111,
 W_MWW_WMULHU      <-> 0b100100,
 W_MWW_WMULHSU     <-> 0b100110,
 W_MWW_WDIVU       <-> 0b100000,
 W_MWW_WDIV        <-> 0b100001,
 W_MWW_WREMU       <-> 0b100010,
 W_MWW_WREM        <-> 0b100011
}

mapping clause encdec = W_MWWTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_encdec_mwwfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ w_encdec_wreg(ws1) @ 0b010 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64 & w_valid_wide_mwwtype(funct6))

function clause execute(W_MWWTYPE(funct6, wm, ws2, ws1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_normal(wd, wm)
   | not(w_valid_reg_group(ws1, W_LMUL_pow))
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_reg_group(wd, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws1, SEW))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let ws1_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws1);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
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
          W_MWW_WAADDU  => {
            let result_add = zero_extend(sizeof('m) + 1, ws2_val_view[i][j]) +
                zero_extend(sizeof('m) + 1, ws1_val_view[i][j]);
            let rounding_incr = w_get_fixed_rounding_incr(result_add, 1);
            (result_add >> 1)[sizeof('m) - 1 .. 0] + zero_extend(sizeof('m), rounding_incr)
          },
          W_MWW_WAADD   => {
            let result_add = sign_extend(sizeof('m) + 1, ws2_val_view[i][j]) +
                sign_extend(sizeof('m) + 1, ws1_val_view[i][j]);
            let rounding_incr = w_get_fixed_rounding_incr(result_add, 1);
            (result_add >> 1)[sizeof('m) - 1 .. 0] + zero_extend(sizeof('m), rounding_incr)
          },
          W_MWW_WASUBU  => {
            let result_sub = zero_extend(sizeof('m) + 1, ws2_val_view[i][j]) -
                zero_extend(sizeof('m) + 1, ws1_val_view[i][j]);
            let rounding_incr = w_get_fixed_rounding_incr(result_sub, 1);
            (result_sub >> 1)[sizeof('m) - 1 .. 0] + zero_extend(sizeof('m), rounding_incr)
          },
          W_MWW_WASUB   => {
            let result_sub = sign_extend(sizeof('m) + 1, ws2_val_view[i][j]) -
                sign_extend(sizeof('m) + 1, ws1_val_view[i][j]);
            let rounding_incr = w_get_fixed_rounding_incr(result_sub, 1);
            (result_sub >> 1)[sizeof('m) - 1 .. 0] + zero_extend(sizeof('m), rounding_incr)
          },
          W_MWW_WMUL    => mult_to_bits_half(SEW, Signed, Signed, ws2_val_view[i][j], ws1_val_view[i][j], Low),
          W_MWW_WMULH   => mult_to_bits_half(SEW, Signed, Signed, ws2_val_view[i][j], ws1_val_view[i][j], High),
          W_MWW_WMULHU  => mult_to_bits_half(
            SEW,
            Unsigned,
            Unsigned,
            ws2_val_view[i][j],
            ws1_val_view[i][j],
            High,
          ),
          W_MWW_WMULHSU => mult_to_bits_half(
            SEW,
            Signed,
            Unsigned,
            ws2_val_view[i][j],
            ws1_val_view[i][j],
            High,
          ),
          W_MWW_WDIVU   => {
            let divisor = unsigned(ws1_val_view[i][j]);
            let dividend = unsigned(ws2_val_view[i][j]);
            let q : int = if divisor == 0 then {
                -1
              } else {
                quot_round_zero(dividend, divisor)
              };
            to_bits_unsafe(SEW, q)
          },
          W_MWW_WDIV    => {
            let elem_max : int = 2 ^ (SEW - 1) - 1;
            let elem_min : int = 0 - 2 ^ (SEW - 1);
            let divisor = signed(ws1_val_view[i][j]);
            let dividend = signed(ws2_val_view[i][j]);
            let q : int = if divisor == 0 then {
                -1
              } else {
                quot_round_zero(dividend, divisor)
              };

            // check for signed overflow
            let q' : int = if q > elem_max then { elem_min } else { q };
            to_bits_unsafe(SEW, q')
          },
          W_MWW_WREMU   => {
            let divisor = unsigned(ws1_val_view[i][j]);
            let dividend = unsigned(ws2_val_view[i][j]);
            let r : int = if divisor == 0 then {
                dividend
              } else {
                rem_round_zero(dividend, divisor)
              };

            // signed overflow case returns zero naturally as required due to -1 divisor
            to_bits_unsafe(SEW, r)
          },
          W_MWW_WREM    => {
            let divisor = signed(ws1_val_view[i][j]);
            let dividend = signed(ws2_val_view[i][j]);
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
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_mwwtype_mnemonic : w_mwwfunct6 <-> string = {
 W_MWW_WAADDU   <-> "waaddu.ww",
 W_MWW_WAADD    <-> "waadd.ww",
 W_MWW_WASUBU   <-> "wasubu.ww",
 W_MWW_WASUB    <-> "wasub.ww",
 W_MWW_WMUL     <-> "wmul.ww",
 W_MWW_WMULH    <-> "wmulh.ww",
 W_MWW_WMULHU   <-> "wmulhu.ww",
 W_MWW_WMULHSU  <-> "wmulhsu.ww",
 W_MWW_WDIVU    <-> "wdivu.ww",
 W_MWW_WDIV     <-> "wdiv.ww",
 W_MWW_WREMU    <-> "wremu.ww",
 W_MWW_WREM     <-> "wrem.ww"
}

mapping clause assembly = W_MWWTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_mwwtype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ w_wreg_name(ws1) ^ w_maybe_wmask(wm)

// ************************ OPMVV (wwtype Multiply-Add) *************************
// Multiply-Add instructions switch the order of source operands in assembly (ws1/rs1 before ws2)
union clause instruction = W_MWWMATYPE : (w_mwwmafunct6, bits(1), wregidx, wregidx, wregidx)

mapping w_encdec_mwwmafunct6 : w_mwwmafunct6 <-> bits(6) = {
 W_MWW_WMACC       <-> 0b101101,
 W_MWW_WNMSAC      <-> 0b101111,
 W_MWW_WMADD       <-> 0b101001,
 W_MWW_WNMSUB      <-> 0b101011
}

mapping clause encdec = W_MWWMATYPE(funct6, wm, ws2, ws1, wd)
 <-> w_encdec_mwwmafunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ w_encdec_wreg(ws1) @ 0b010 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_MWWMATYPE(funct6, wm, ws2, ws1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_normal(wd, wm)
   | not(w_valid_reg_group(ws1, W_LMUL_pow))
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_reg_group(wd, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws1, SEW))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let ws1_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws1);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
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
    let wd_val_view = w_shape(wd_val, w_columns);
    let ws1_val_view = w_shape(ws1_val, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(wd_val_view));
      assert(i < length(ws1_val_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_MWW_WMACC  => mult_to_bits_half(SEW, Signed, Signed, ws1_val_view[i][j], ws2_val_view[i][j], Low) +
            wd_val_view[i][j],
          W_MWW_WNMSAC => wd_val_view[i][j] -
            mult_to_bits_half(SEW, Signed, Signed, ws1_val_view[i][j], ws2_val_view[i][j], Low),
          W_MWW_WMADD  => mult_to_bits_half(SEW, Signed, Signed, ws1_val_view[i][j], wd_val_view[i][j], Low) +
            ws2_val_view[i][j],
          W_MWW_WNMSUB => ws2_val_view[i][j] -
            mult_to_bits_half(SEW, Signed, Signed, ws1_val_view[i][j], wd_val_view[i][j], Low),
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_mwwmatype_mnemonic : w_mwwmafunct6 <-> string = {
 W_MWW_WMACC    <-> "wmacc.ww",
 W_MWW_WNMSAC   <-> "wnmsac.ww",
 W_MWW_WMADD    <-> "wmadd.ww",
 W_MWW_WNMSUB   <-> "wnmsub.ww"
}

mapping clause assembly = W_MWWMATYPE(funct6, wm, ws2, ws1, wd)
 <-> w_mwwmatype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws1) ^ sep() ^ w_wreg_name(ws2) ^ w_maybe_wmask(wm)

// ************************** OPMVV (WWTYPE Widening) ***************************
union clause instruction = W_WIDE_WWTYPE : (w_wide_wwfunct6, bits(1), wregidx, wregidx, wregidx)
mapping w_encdec_wide_wwfunct6 : w_wide_wwfunct6 <-> bits(6) = {
 W_WIDE_WW_WADD       <-> 0b110001,
 W_WIDE_WW_WSUB       <-> 0b110011,
 W_WIDE_WW_WADDU      <-> 0b110000,
 W_WIDE_WW_WSUBU      <-> 0b110010,
 W_WIDE_WW_WWMUL      <-> 0b111011,
 W_WIDE_WW_WWMULU     <-> 0b111000,
 W_WIDE_WW_WWMULSU    <-> 0b111010
}

mapping clause encdec = W_WIDE_WWTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_encdec_wide_wwfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ w_encdec_wreg(ws1) @ 0b010 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 16)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 32)

function clause execute(W_WIDE_WWTYPE(funct6, wm, ws2, ws1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = W_LMUL_pow + 1;

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_variable_width(wd, wm, SEW_widen, LMUL_pow_widen)
   | not(w_valid_reg_overlap(ws1, wd, W_LMUL_pow, LMUL_pow_widen))
   | not(w_valid_reg_overlap(ws2, wd, W_LMUL_pow, LMUL_pow_widen))
   | not(w_valid_wm_src_overlap(wm, ws1, SEW))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let wd_val : vector('n, bits('o)) = w_read_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd);
  let ws1_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws1);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);

  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW_widen,
    LMUL_pow_widen,
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
        result_view[i][j] = match funct6 {
          W_WIDE_WW_WADD    => to_bits_unsafe(SEW_widen, signed(ws2_val_view[i][j]) + signed(ws1_val_view[i][j])),
          W_WIDE_WW_WSUB    => to_bits_unsafe(SEW_widen, signed(ws2_val_view[i][j]) - signed(ws1_val_view[i][j])),
          W_WIDE_WW_WADDU   => to_bits_unsafe(
            SEW_widen,
            unsigned(ws2_val_view[i][j]) + unsigned(ws1_val_view[i][j]),
          ),
          W_WIDE_WW_WSUBU   => to_bits_unsafe(
            SEW_widen,
            unsigned(ws2_val_view[i][j]) - unsigned(ws1_val_view[i][j]),
          ),
          W_WIDE_WW_WWMUL   => to_bits_unsafe(
            SEW_widen,
            signed(ws2_val_view[i][j]) * signed(ws1_val_view[i][j]),
          ),
          W_WIDE_WW_WWMULU  => to_bits_unsafe(
            SEW_widen,
            unsigned(ws2_val_view[i][j]) * unsigned(ws1_val_view[i][j]),
          ),
          W_WIDE_WW_WWMULSU => to_bits_unsafe(
            SEW_widen,
            signed(ws2_val_view[i][j]) * unsigned(ws1_val_view[i][j]),
          ),
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_wide_wwtype_mnemonic : w_wide_wwfunct6 <-> string = {
 W_WIDE_WW_WADD       <-> "wwadd.ww",
 W_WIDE_WW_WSUB       <-> "wwsub.ww",
 W_WIDE_WW_WADDU      <-> "wwaddu.ww",
 W_WIDE_WW_WSUBU      <-> "wwsubu.ww",
 W_WIDE_WW_WWMUL      <-> "wwmul.ww",
 W_WIDE_WW_WWMULU     <-> "wwmulu.ww",
 W_WIDE_WW_WWMULSU    <-> "wwmulsu.ww"
}

mapping clause assembly = W_WIDE_WWTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_wide_wwtype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ w_wreg_name(ws1) ^ w_maybe_wmask(wm)

// ************************** OPMVV (WIDE_WTYPE Widening) ***************************
union clause instruction = W_WIDE_WTYPE : (w_wide_wfunct6, bits(1), wregidx, wregidx, wregidx)

mapping w_encdec_wide_wfunct6 : w_wide_wfunct6 <-> bits(6) = {
 W_WIDE_W_WADD       <-> 0b110101,
 W_WIDE_W_WSUB       <-> 0b110111,
 W_WIDE_W_WADDU      <-> 0b110100,
 W_WIDE_W_WSUBU      <-> 0b110110
}

mapping clause encdec = W_WIDE_WTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_encdec_wide_wfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ w_encdec_wreg(ws1) @ 0b010 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 16)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 32)

function clause execute(W_WIDE_WTYPE(funct6, wm, ws2, ws1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = W_LMUL_pow + 1;

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_variable_width(wd, wm, SEW_widen, LMUL_pow_widen)
   | not(w_valid_reg_overlap(ws1, wd, W_LMUL_pow, LMUL_pow_widen))
   | not(w_valid_src_overlap(ws2, SEW_widen, LMUL_pow_widen, ws1, SEW, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws1, SEW))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW_widen)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let wd_val : vector('n, bits('o)) = w_read_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd);
  let ws1_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws1);
  let ws2_val : vector('n, bits('o)) = w_read_wreg(num_elem, SEW_widen, LMUL_pow_widen, ws2);

  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW_widen,
    LMUL_pow_widen,
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
        result_view[i][j] = match funct6 {
          W_WIDE_W_WADD  => to_bits_unsafe(SEW_widen, signed(ws2_val_view[i][j]) + signed(ws1_val_view[i][j])),
          W_WIDE_W_WSUB  => to_bits_unsafe(SEW_widen, signed(ws2_val_view[i][j]) - signed(ws1_val_view[i][j])),
          W_WIDE_W_WADDU => to_bits_unsafe(
            SEW_widen,
            unsigned(ws2_val_view[i][j]) + unsigned(ws1_val_view[i][j]),
          ),
          W_WIDE_W_WSUBU => to_bits_unsafe(
            SEW_widen,
            unsigned(ws2_val_view[i][j]) - unsigned(ws1_val_view[i][j]),
          ),
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_wide_wtype_mnemonic : w_wide_wfunct6 <-> string = {
 W_WIDE_W_WADD       <-> "wwadd.wide.ww",
 W_WIDE_W_WSUB       <-> "wwsub.wide.ww",
 W_WIDE_W_WADDU      <-> "wwaddu.wide.ww",
 W_WIDE_W_WSUBU      <-> "wwsubu.wide.ww"
}

mapping clause assembly = W_WIDE_WTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_wide_wtype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ w_wreg_name(ws1) ^ w_maybe_wmask(wm)

// ******************* OPMVV (wwtype Widening Multiply-Add) *********************
// Multiply-Add instructions switch the order of source operands in assembly (ws1/rs1 before ws2)
union clause instruction = W_WIDE_MWWTYPE : (w_wide_mwwfunct6, bits(1), wregidx, wregidx, wregidx)

mapping w_encdec_wide_mwwfunct6 : w_wide_mwwfunct6 <-> bits(6) = {
 W_WIDE_MWW_WWMACCU   <-> 0b111100,
 W_WIDE_MWW_WWMACC    <-> 0b111101,
 W_WIDE_MWW_WWMACCSU  <-> 0b111111
}

mapping clause encdec =  W_WIDE_MWWTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_encdec_wide_mwwfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ w_encdec_wreg(ws1) @ 0b010 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 16)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 32)

function clause execute(W_WIDE_MWWTYPE(funct6, wm, ws2, ws1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = W_LMUL_pow + 1;

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_variable_width(wd, wm, SEW_widen, LMUL_pow_widen)
   | not(w_valid_reg_overlap(ws1, wd, W_LMUL_pow, LMUL_pow_widen))
   | not(w_valid_reg_overlap(ws2, wd, W_LMUL_pow, LMUL_pow_widen))
   | // wd is also a source register
    not(w_valid_src_overlap(ws1, SEW, W_LMUL_pow, wd, SEW_widen, LMUL_pow_widen))
   | not(w_valid_src_overlap(ws2, SEW, W_LMUL_pow, wd, SEW_widen, LMUL_pow_widen))
   | not(w_valid_wm_src_overlap(wm, ws1, SEW))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let wd_val : vector('n, bits('o)) = w_read_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd);
  let ws1_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws1);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);

  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW_widen,
    LMUL_pow_widen,
    wd_val,
    wm_val,
  );
  var result = initial_result;

  {
    let mask_view = w_shape(mask, w_columns);
    var result_view = w_shape(result, w_columns);
    let wd_val_view = w_shape(wd_val, w_columns);
    let ws1_val_view = w_shape(ws1_val, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(wd_val_view));
      assert(i < length(ws1_val_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_WIDE_MWW_WWMACC   => to_bits_unsafe(
            SEW_widen,
            signed(ws1_val_view[i][j]) * signed(ws2_val_view[i][j]),
          ) +
            wd_val_view[i][j],
          W_WIDE_MWW_WWMACCU  => to_bits_unsafe(
            SEW_widen,
            unsigned(ws1_val_view[i][j]) * unsigned(ws2_val_view[i][j]),
          ) +
            wd_val_view[i][j],
          W_WIDE_MWW_WWMACCSU => to_bits_unsafe(
            SEW_widen,
            signed(ws1_val_view[i][j]) * unsigned(ws2_val_view[i][j]),
          ) +
            wd_val_view[i][j],
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_wide_mwwtype_mnemonic : w_wide_mwwfunct6 <-> string = {
 W_WIDE_MWW_WWMACCU     <-> "wwmaccu.ww",
 W_WIDE_MWW_WWMACC      <-> "wwmacc.ww",
 W_WIDE_MWW_WWMACCSU    <-> "wwmaccsu.ww"
}

mapping clause assembly = W_WIDE_MWWTYPE(funct6, wm, ws2, ws1, wd)
 <-> w_wide_mwwtype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws1) ^ sep() ^ w_wreg_name(ws2) ^ w_maybe_wmask(wm)

// ***************************** OPMVV (WXUNARY0) *******************************
// ****************** Matrix Integer Extension (SEW/2 source) *******************
union clause instruction = W_WEXTTYPE : (w_wextfunct6, bits(1), wregidx, wregidx)

mapping w_wext_ws1 : w_wextfunct6 <-> bits(5) = {
 W_WEXT2_ZVF2  <-> 0b00110,
 W_WEXT2_SVF2  <-> 0b00111,
 W_WEXT4_ZVF4  <-> 0b00100,
 W_WEXT4_SVF4  <-> 0b00101,
 W_WEXT8_ZVF8  <-> 0b00010,
 W_WEXT8_SVF8  <-> 0b00011,
}

mapping clause encdec = W_WEXTTYPE(funct6, wm, ws2, wd)
 <-> 0b010010 @ wm @ w_encdec_wreg(ws2) @ w_wext_ws1(funct6) @ 0b010 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WEXTTYPE(funct6, wm, ws2, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  let SEW_frac_pow : {1, 2, 3} = match funct6 {
    W_WEXT2_ZVF2 => 1,
    W_WEXT2_SVF2 => 1,
    W_WEXT4_ZVF4 => 2,
    W_WEXT4_SVF4 => 2,
    W_WEXT8_ZVF8 => 3,
    W_WEXT8_SVF8 => 3,
  };
  let LMUL_pow_div = W_LMUL_pow - SEW_frac_pow;
  let SEW_div = SEW / (2 ^ SEW_frac_pow);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_variable_width(wd, wm, SEW_div, LMUL_pow_div)
   | not(w_valid_reg_overlap(ws2, wd, LMUL_pow_div, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW_div)) then {
    return Illegal_Instruction()
  };

  assert(SEW_div >= 8);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_div;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);
  let ws2_val : vector('n, bits('o)) = w_read_wreg(num_elem, SEW_div, LMUL_pow_div, ws2);

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
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_WEXT2_ZVF2 => zero_extend(ws2_val_view[i][j]),
          W_WEXT2_SVF2 => sign_extend(ws2_val_view[i][j]),
          W_WEXT4_ZVF4 => zero_extend(ws2_val_view[i][j]),
          W_WEXT4_SVF4 => sign_extend(ws2_val_view[i][j]),
          W_WEXT8_ZVF8 => zero_extend(ws2_val_view[i][j]),
          W_WEXT8_SVF8 => sign_extend(ws2_val_view[i][j]),
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_wexttype_mnemonic : w_wextfunct6 <-> string = {
 W_WEXT2_ZVF2  <-> "wzext.wf2",
 W_WEXT2_SVF2  <-> "wsext.wf2",
 W_WEXT4_ZVF4  <-> "wzext.wf4",
 W_WEXT4_SVF4  <-> "wsext.wf4",
 W_WEXT8_ZVF8  <-> "wzext.wf8",
 W_WEXT8_SVF8  <-> "wsext.wf8",
}

mapping clause assembly = W_WEXTTYPE(funct6, wm, ws2, wd)
 <-> w_wexttype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ w_maybe_wmask(wm)

// *********************** OPMVV (vmv.x.s in WWXUNARY0) *************************
union clause instruction = W_WMVXS : (wregidx, regidx)

mapping clause encdec = W_WMVXS(ws2, rd)
 <-> 0b010000 @ 0b1 @ w_encdec_wreg(ws2) @ 0b00000 @ 0b010 @ encdec_reg(rd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WMVXS(ws2, rd)) = {
  let SEW = w_get_sew();
  let num_elem = w_get_num_elem(0, SEW);

  // Scalar move instructions disregard LMUL, but for the purposes of finding an illegal wstart,
  // some implementations use LMUL for the bounds check, and this helps match those implementations.
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem_wstart = w_get_num_elem(W_LMUL_pow, SEW);

  if w_illegal_wstart(W_WSTART_SCALAR_MOVE, num_elem_wstart, W_LMUL_pow) | w_illegal_wd_unmasked() then {
    return Illegal_Instruction()
  };

  assert(num_elem > 0);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, 0, ws2);
  X(rd) =
    if xlen < SEW then {
      w_shape(ws2_val, w_columns)[0][0][xlen - 1 .. 0]
    } else {
      if xlen > SEW then {
        sign_extend(w_shape(ws2_val, w_columns)[0][0])
      } else {
        w_shape(ws2_val, w_columns)[0][0]
      }
    };
  w_set_wstart(zeros());

  RETIRE_SUCCESS
}

mapping clause assembly = W_WMVXS(ws2, rd)
 <-> "wmv.x.s" ^ spc() ^ reg_name(rd) ^ sep() ^ w_wreg_name(ws2)

// ******************** OPMVV (Matrix Compress Instruction) *********************
union clause instruction = W_MWWCOMPRESS : (wregidx, wregidx, wregidx)

mapping clause encdec = W_MWWCOMPRESS(ws2, ws1, wd)
 <-> 0b010111 @ 0b1 @ w_encdec_wreg(ws2) @ w_encdec_wreg(ws1) @ 0b010 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_MWWCOMPRESS(ws2, ws1, wd)) = {
  let start_element = w_get_start_element();
  let end_element = w_get_end_element();
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if    w_illegal_wstart(W_WSTART_MANDATORY, num_elem, W_LMUL_pow)
   |  w_illegal_wd_unmasked()
   |  not(w_valid_disjoint_reg_groups(ws1, wd, 0, W_LMUL_pow))
   |  ws2
   == wd
   |  not(w_valid_src_overlap(ws2, SEW, W_LMUL_pow, ws1, 1, 0)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let ws1_val : bits('n) = w_read_wmask(num_elem, 0b0, ws1);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, wd);
  var result : vector('n, bits('m)) = vector_init(zeros());

  // body elements
  var wd_idx : nat = 0;
  {
    var result_view = w_shape(result, w_columns);
    let ws1_val_view = w_shape(ws1_val, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(result_view));
      assert(i < length(ws1_val_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if p <= end_element then {
        if ws1_val_view[i][j] == 0b1 then {
          let (p as 'p) = wd_idx;
          assert(sizeof('p) < sizeof('n));
          result_view[sizeof('p) / w_columns][sizeof('p) % w_columns] = ws2_val_view[i][j];
          wd_idx = wd_idx + 1
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  // tail elements
  if wd_idx < num_elem then {
    let tail_ag : w_agtype = w_get_wtype_wta();
    let (p as 'p) = wd_idx;
    {
      var result_view = w_shape(result, w_columns);
      let wd_val_view = w_shape(wd_val, w_columns);
      foreach (p from sizeof('p) to (num_elem - 1)) {
        let i = p / w_columns;
        let j = p % w_columns;
        assert(i < length(result_view));
        assert(i < length(wd_val_view));
        assert(j < w_columns);

        result_view[i][j] = match tail_ag {
          W_UNDISTURBED => wd_val_view[i][j],
          W_AGNOSTIC    => wd_val_view[i][j], // TODO: configuration support
        }
      };
      result = w_unshape_vector(length(result), result_view, w_columns)
    }
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_MWWCOMPRESS(ws2, ws1, wd)
 <-> "wcompress.wm" ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ w_wreg_name(ws1)

// ****************************** OPMVX (WXTYPE) ********************************
union clause instruction = W_MWXTYPE : (w_mwxfunct6, bits(1), wregidx, regidx, wregidx)

mapping w_encdec_mwxfunct6 : w_mwxfunct6 <-> bits(6) = {
 W_MWX_WAADDU        <-> 0b001000,
 W_MWX_WAADD         <-> 0b001001,
 W_MWX_WASUBU        <-> 0b001010,
 W_MWX_WASUB         <-> 0b001011,
 W_MWX_WSLIDE1UP     <-> 0b001110,
 W_MWX_WSLIDE1DOWN   <-> 0b001111,
 W_MWX_WMUL          <-> 0b100101,
 W_MWX_WMULH         <-> 0b100111,
 W_MWX_WMULHU        <-> 0b100100,
 W_MWX_WMULHSU       <-> 0b100110,
 W_MWX_WDIVU         <-> 0b100000,
 W_MWX_WDIV          <-> 0b100001,
 W_MWX_WREMU         <-> 0b100010,
 W_MWX_WREM          <-> 0b100011
}

// vmulh.wx, vmulhu.wx and vmulhsu.wx are not included for EEW=64 in Zve64*.
mapping clause encdec = W_MWXTYPE(funct6, wm, ws2, rs1, wd)
 <-> w_encdec_mwxfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ encdec_reg(rs1) @ 0b110 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64 & w_valid_wide_mwxtype(funct6))

function clause execute(W_MWXTYPE(funct6, wm, ws2, rs1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  // "The vslide1up instruction requires that the destination vector
  // register group does not overlap the source vector register
  // group. Otherwise, the instruction encoding is reserved."
  let src_dst_overlap = funct6 == W_MWX_WSLIDE1UP & ws2 == wd;
  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_normal(wd, wm)
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_reg_group(wd, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW))
   | src_dst_overlap then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let rs1_val : bits('m) = w_get_scalar(rs1, SEW);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
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
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_MWX_WAADDU      => {
            let result_add = zero_extend(sizeof('m) + 1, ws2_val_view[i][j]) +
                zero_extend(sizeof('m) + 1, rs1_val);
            let rounding_incr = w_get_fixed_rounding_incr(result_add, 1);
            (result_add >> 1)[sizeof('m) - 1 .. 0] + zero_extend(sizeof('m), rounding_incr)
          },
          W_MWX_WAADD       => {
            let result_add = sign_extend(sizeof('m) + 1, ws2_val_view[i][j]) +
                sign_extend(sizeof('m) + 1, rs1_val);
            let rounding_incr = w_get_fixed_rounding_incr(result_add, 1);
            (result_add >> 1)[sizeof('m) - 1 .. 0] + zero_extend(sizeof('m), rounding_incr)
          },
          W_MWX_WASUBU      => {
            let result_sub = zero_extend(sizeof('m) + 1, ws2_val_view[i][j]) -
                zero_extend(sizeof('m) + 1, rs1_val);
            let rounding_incr = w_get_fixed_rounding_incr(result_sub, 1);
            (result_sub >> 1)[sizeof('m) - 1 .. 0] + zero_extend(sizeof('m), rounding_incr)
          },
          W_MWX_WASUB       => {
            let result_sub = sign_extend(sizeof('m) + 1, ws2_val_view[i][j]) -
                sign_extend(sizeof('m) + 1, rs1_val);
            let rounding_incr = w_get_fixed_rounding_incr(result_sub, 1);
            (result_sub >> 1)[sizeof('m) - 1 .. 0] + zero_extend(sizeof('m), rounding_incr)
          },
          W_MWX_WSLIDE1UP   => if p == 0 then {
            rs1_val
          } else {
            ws2_val_view[(p - 1) / w_columns][(p - 1) % w_columns]
          },
          W_MWX_WSLIDE1DOWN => {
            let last_elem = w_get_end_element();
            assert(last_elem < num_elem);
            if p < last_elem then {
              ws2_val_view[(p + 1) / w_columns][(p + 1) % w_columns]
            } else {
              rs1_val
            }
          },
          W_MWX_WMUL        => mult_to_bits_half(SEW, Signed, Signed, ws2_val_view[i][j], rs1_val, Low),
          W_MWX_WMULH       => mult_to_bits_half(SEW, Signed, Signed, ws2_val_view[i][j], rs1_val, High),
          W_MWX_WMULHU      => mult_to_bits_half(SEW, Unsigned, Unsigned, ws2_val_view[i][j], rs1_val, High),
          W_MWX_WMULHSU     => mult_to_bits_half(SEW, Signed, Unsigned, ws2_val_view[i][j], rs1_val, High),
          W_MWX_WDIVU       => {
            let divisor = unsigned(rs1_val);
            let dividend = unsigned(ws2_val_view[i][j]);
            let q : int = if divisor == 0 then {
                -1
              } else {
                quot_round_zero(dividend, divisor)
              };
            to_bits_unsafe(SEW, q)
          },
          W_MWX_WDIV        => {
            let elem_max : int = 2 ^ (SEW - 1) - 1;
            let elem_min : int = 0 - 2 ^ (SEW - 1);
            let divisor = signed(rs1_val);
            let dividend = signed(ws2_val_view[i][j]);
            let q : int = if divisor == 0 then {
                -1
              } else {
                quot_round_zero(dividend, divisor)
              };

            // check for signed overflow
            let q' : int = if q > elem_max then { elem_min } else { q };
            to_bits_unsafe(SEW, q')
          },
          W_MWX_WREMU       => {
            let divisor = unsigned(rs1_val);
            let dividend = unsigned(ws2_val_view[i][j]);
            let r : int = if divisor == 0 then {
                dividend
              } else {
                rem_round_zero(dividend, divisor)
              };

            // signed overflow case returns zero naturally as required due to -1 divisor
            to_bits_unsafe(SEW, r)
          },
          W_MWX_WREM        => {
            let divisor = signed(rs1_val);
            let dividend = signed(ws2_val_view[i][j]);
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
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_mwxtype_mnemonic : w_mwxfunct6 <-> string = {
 W_MWX_WAADDU        <-> "waaddu.wx",
 W_MWX_WAADD         <-> "waadd.wx",
 W_MWX_WASUBU        <-> "wasubu.wx",
 W_MWX_WASUB         <-> "wasub.wx",
 W_MWX_WSLIDE1UP     <-> "wslide1up.wx",
 W_MWX_WSLIDE1DOWN   <-> "wslide1down.wx",
 W_MWX_WMUL          <-> "wmul.wx",
 W_MWX_WMULH         <-> "wmulh.wx",
 W_MWX_WMULHU        <-> "wmulhu.wx",
 W_MWX_WMULHSU       <-> "wmulhsu.wx",
 W_MWX_WDIVU         <-> "wdivu.wx",
 W_MWX_WDIV          <-> "wdiv.wx",
 W_MWX_WREMU         <-> "wremu.wx",
 W_MWX_WREM          <-> "wrem.wx"
}

mapping clause assembly = W_MWXTYPE(funct6, wm, ws2, rs1, wd)
 <-> w_mwxtype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ reg_name(rs1) ^ w_maybe_wmask(wm)

// ************************ OPMVX (wxtype Multiply-Add) *************************
// Multiply-Add instructions switch the order of source operands in assembly (ws1/rs1 before ws2)
union clause instruction = W_MWXMATYPE : (w_mwxmafunct6, bits(1), wregidx, regidx, wregidx)

mapping w_encdec_mwxmafunct6 : w_mwxmafunct6 <-> bits(6) = {
 W_MWX_WMACC         <-> 0b101101,
 W_MWX_WNMSAC        <-> 0b101111,
 W_MWX_WMADD         <-> 0b101001,
 W_MWX_WNMSUB        <-> 0b101011
}

mapping clause encdec = W_MWXMATYPE(funct6, wm, ws2, rs1, wd)
 <-> w_encdec_mwxmafunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ encdec_reg(rs1) @ 0b110 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_MWXMATYPE(funct6, wm, ws2, rs1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_normal(wd, wm)
   | not(w_valid_reg_group(ws2, W_LMUL_pow))
   | not(w_valid_reg_group(wd, W_LMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let rs1_val : bits('m) = w_get_scalar(rs1, SEW);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);
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
    let wd_val_view = w_shape(wd_val, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(wd_val_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_MWX_WMACC  => mult_to_bits_half(SEW, Signed, Signed, rs1_val, ws2_val_view[i][j], Low) +
            wd_val_view[i][j],
          W_MWX_WNMSAC => wd_val_view[i][j] -
            mult_to_bits_half(SEW, Signed, Signed, rs1_val, ws2_val_view[i][j], Low),
          W_MWX_WMADD  => mult_to_bits_half(SEW, Signed, Signed, rs1_val, wd_val_view[i][j], Low) +
            ws2_val_view[i][j],
          W_MWX_WNMSUB => ws2_val_view[i][j] -
            mult_to_bits_half(SEW, Signed, Signed, rs1_val, wd_val_view[i][j], Low),
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, W_LMUL_pow, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_mwxmatype_mnemonic : w_mwxmafunct6 <-> string = {
 W_MWX_WMACC         <-> "wmacc.wx",
 W_MWX_WNMSAC        <-> "wnmsac.wx",
 W_MWX_WMADD         <-> "wmadd.wx",
 W_MWX_WNMSUB        <-> "wnmsub.wx"
}

mapping clause assembly = W_MWXMATYPE(funct6, wm, ws2, rs1, wd)
 <-> w_mwxmatype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ reg_name(rs1) ^ sep() ^ w_wreg_name(ws2) ^ w_maybe_wmask(wm)

// ************************** OPMVX (WXTYPE Widening) ***************************
union clause instruction = W_WIDE_WXTYPE : (w_wide_wxfunct6, bits(1), wregidx, regidx, wregidx)

mapping w_encdec_wide_wxfunct6 : w_wide_wxfunct6 <-> bits(6) = {
 W_WIDE_WX_WADD       <-> 0b110001,
 W_WIDE_WX_WSUB       <-> 0b110011,
 W_WIDE_WX_WADDU      <-> 0b110000,
 W_WIDE_WX_WSUBU      <-> 0b110010,
 W_WIDE_WX_WWMUL      <-> 0b111011,
 W_WIDE_WX_WWMULU     <-> 0b111000,
 W_WIDE_WX_WWMULSU    <-> 0b111010
}

mapping clause encdec = W_WIDE_WXTYPE(funct6, wm, ws2, rs1, wd)
 <-> w_encdec_wide_wxfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ encdec_reg(rs1) @ 0b110 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 16)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 32)

function clause execute(W_WIDE_WXTYPE(funct6, wm, ws2, rs1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = W_LMUL_pow + 1;

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_variable_width(wd, wm, SEW_widen, LMUL_pow_widen)
   | not(w_valid_reg_overlap(ws2, wd, W_LMUL_pow, LMUL_pow_widen))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let wd_val : vector('n, bits('o)) = w_read_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd);
  let rs1_val : bits('m) = w_get_scalar(rs1, SEW);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);

  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW_widen,
    LMUL_pow_widen,
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
        result_view[i][j] = match funct6 {
          W_WIDE_WX_WADD    => to_bits_unsafe(SEW_widen, signed(ws2_val_view[i][j]) + signed(rs1_val)),
          W_WIDE_WX_WSUB    => to_bits_unsafe(SEW_widen, signed(ws2_val_view[i][j]) - signed(rs1_val)),
          W_WIDE_WX_WADDU   => to_bits_unsafe(SEW_widen, unsigned(ws2_val_view[i][j]) + unsigned(rs1_val)),
          W_WIDE_WX_WSUBU   => to_bits_unsafe(SEW_widen, unsigned(ws2_val_view[i][j]) - unsigned(rs1_val)),
          W_WIDE_WX_WWMUL   => to_bits_unsafe(SEW_widen, signed(ws2_val_view[i][j]) * signed(rs1_val)),
          W_WIDE_WX_WWMULU  => to_bits_unsafe(SEW_widen, unsigned(ws2_val_view[i][j]) * unsigned(rs1_val)),
          W_WIDE_WX_WWMULSU => to_bits_unsafe(SEW_widen, signed(ws2_val_view[i][j]) * unsigned(rs1_val)),
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_wide_wxtype_mnemonic : w_wide_wxfunct6 <-> string = {
 W_WIDE_WX_WADD       <-> "wwadd.wx",
 W_WIDE_WX_WSUB       <-> "wwsub.wx",
 W_WIDE_WX_WADDU      <-> "wwaddu.wx",
 W_WIDE_WX_WSUBU      <-> "wwsubu.wx",
 W_WIDE_WX_WWMUL      <-> "wwmul.wx",
 W_WIDE_WX_WWMULU     <-> "wwmulu.wx",
 W_WIDE_WX_WWMULSU    <-> "wwmulsu.wx"
}

mapping clause assembly = W_WIDE_WXTYPE(funct6, wm, ws2, rs1, wd)
 <-> w_wide_wxtype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ reg_name(rs1) ^ w_maybe_wmask(wm)

// ************************** OPMVX (WIDE_XTYPE Widening) ***************************
union clause instruction = W_WIDE_XTYPE : (w_wide_xfunct6, bits(1), wregidx, regidx, wregidx)

mapping w_encdec_wide_xfunct6 : w_wide_xfunct6 <-> bits(6) = {
 W_WIDE_X_WADD       <-> 0b110101,
 W_WIDE_X_WSUB       <-> 0b110111,
 W_WIDE_X_WADDU      <-> 0b110100,
 W_WIDE_X_WSUBU      <-> 0b110110
}

mapping clause encdec = W_WIDE_XTYPE(funct6, wm, ws2, rs1, wd)
 <-> w_encdec_wide_xfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ encdec_reg(rs1) @ 0b110 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 16)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 32)

function clause execute(W_WIDE_XTYPE(funct6, wm, ws2, rs1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = W_LMUL_pow + 1;

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_variable_width(wd, wm, SEW_widen, LMUL_pow_widen)
   | not(w_valid_reg_group(ws2, LMUL_pow_widen))
   | not(w_valid_reg_group(wd, LMUL_pow_widen))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW_widen)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let wd_val : vector('n, bits('o)) = w_read_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd);
  let rs1_val : bits('m) = w_get_scalar(rs1, SEW);
  let ws2_val : vector('n, bits('o)) = w_read_wreg(num_elem, SEW_widen, LMUL_pow_widen, ws2);

  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW_widen,
    LMUL_pow_widen,
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
        result_view[i][j] = match funct6 {
          W_WIDE_X_WADD  => to_bits_unsafe(SEW_widen, signed(ws2_val_view[i][j]) + signed(rs1_val)),
          W_WIDE_X_WSUB  => to_bits_unsafe(SEW_widen, signed(ws2_val_view[i][j]) - signed(rs1_val)),
          W_WIDE_X_WADDU => to_bits_unsafe(SEW_widen, unsigned(ws2_val_view[i][j]) + unsigned(rs1_val)),
          W_WIDE_X_WSUBU => to_bits_unsafe(SEW_widen, unsigned(ws2_val_view[i][j]) - unsigned(rs1_val)),
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_wide_xtype_mnemonic : w_wide_xfunct6 <-> string = {
 W_WIDE_X_WADD       <-> "wwadd.wide.wx",
 W_WIDE_X_WSUB       <-> "wwsub.wide.wx",
 W_WIDE_X_WADDU      <-> "wwaddu.wide.wx",
 W_WIDE_X_WSUBU      <-> "wwsubu.wide.wx"
}

mapping clause assembly = W_WIDE_XTYPE(funct6, wm, ws2, rs1, wd)
 <-> w_wide_xtype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ w_wreg_name(ws2) ^ sep() ^ reg_name(rs1) ^ w_maybe_wmask(wm)

// ******************* OPMVX (wxtype Widening Multiply-Add) *********************
// Multiply-Add instructions switch the order of source operands in assembly (ws1/rs1 before ws2)
union clause instruction =  W_WIDE_MWXTYPE : (w_wide_mwxfunct6, bits(1), wregidx, regidx, wregidx)

mapping w_encdec_wide_mwxfunct6 : w_wide_mwxfunct6 <-> bits(6) = {
 W_WIDE_MWX_WWMACCU    <-> 0b111100,
 W_WIDE_MWX_WWMACC     <-> 0b111101,
 W_WIDE_MWX_WWMACCUS   <-> 0b111110,
 W_WIDE_MWX_WWMACCSU   <-> 0b111111
}

mapping clause encdec = W_WIDE_MWXTYPE(funct6, wm, ws2, rs1, wd)
 <-> w_encdec_wide_mwxfunct6(funct6) @ wm @ w_encdec_wreg(ws2) @ encdec_reg(rs1) @ 0b110 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 16)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 32)

function clause execute(W_WIDE_MWXTYPE(funct6, wm, ws2, rs1, wd)) = {
  let SEW = w_get_sew();
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(W_LMUL_pow, SEW);

  let SEW_widen = SEW * 2;
  let LMUL_pow_widen = W_LMUL_pow + 1;

  if   w_illegal_wstart(W_WSTART_ARITH, num_elem, W_LMUL_pow)
   | w_illegal_variable_width(wd, wm, SEW_widen, LMUL_pow_widen)
   | not(w_valid_reg_overlap(ws2, wd, W_LMUL_pow, LMUL_pow_widen))
   | // wd is also a source register
    not(w_valid_src_overlap(ws2, SEW, W_LMUL_pow, wd, SEW_widen, LMUL_pow_widen))
   | not(w_valid_wm_src_overlap(wm, ws2, SEW)) then {
    return Illegal_Instruction()
  };

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;
  let (o as 'o) = SEW_widen;

  let wm_val : bits('n) = w_read_wmask(num_elem, wm, w_zwreg);
  let wd_val : vector('n, bits('o)) = w_read_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd);
  let rs1_val : bits('m) = w_get_scalar(rs1, SEW);
  let ws2_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, W_LMUL_pow, ws2);

  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW_widen,
    LMUL_pow_widen,
    wd_val,
    wm_val,
  );
  var result = initial_result;

  {
    let mask_view = w_shape(mask, w_columns);
    var result_view = w_shape(result, w_columns);
    let wd_val_view = w_shape(wd_val, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(wd_val_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        result_view[i][j] = match funct6 {
          W_WIDE_MWX_WWMACCU  => to_bits_unsafe(SEW_widen, unsigned(rs1_val) * unsigned(ws2_val_view[i][j])) +
            wd_val_view[i][j],
          W_WIDE_MWX_WWMACC   => to_bits_unsafe(SEW_widen, signed(rs1_val) * signed(ws2_val_view[i][j])) +
            wd_val_view[i][j],
          W_WIDE_MWX_WWMACCUS => to_bits_unsafe(SEW_widen, unsigned(rs1_val) * signed(ws2_val_view[i][j])) +
            wd_val_view[i][j],
          W_WIDE_MWX_WWMACCSU => to_bits_unsafe(SEW_widen, signed(rs1_val) * unsigned(ws2_val_view[i][j])) +
            wd_val_view[i][j],
        }
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_wide_mwxtype_mnemonic : w_wide_mwxfunct6 <-> string = {
 W_WIDE_MWX_WWMACCU     <-> "wwmaccu.wx",
 W_WIDE_MWX_WWMACC      <-> "wwmacc.wx",
 W_WIDE_MWX_WWMACCUS    <-> "wwmaccus.wx",
 W_WIDE_MWX_WWMACCSU    <-> "wwmaccsu.wx"
}

mapping clause assembly = W_WIDE_MWXTYPE(funct6, wm, ws2, rs1, wd)
 <-> w_wide_mwxtype_mnemonic(funct6) ^ spc() ^ w_wreg_name(wd) ^ sep() ^ reg_name(rs1) ^ sep() ^ w_wreg_name(ws2) ^ w_maybe_wmask(wm)

// ***************************** OPMVX (WRXUNARY0) ******************************
union clause instruction = W_WMVSX : (regidx, wregidx)

mapping clause encdec = W_WMVSX(rs1, wd)
 <-> 0b010000 @ 0b1 @ 0b00000 @ encdec_reg(rs1) @ 0b110 @ w_encdec_wreg(wd) @ 0b0001011
 when (currentlyEnabled(Ext_W) & w_get_sew() <= 32)
  | ((currentlyEnabled(Ext_W) & welen >= 64) & w_get_sew() <= 64)

function clause execute(W_WMVSX(rs1, wd)) = {
  let SEW = w_get_sew();
  let num_elem = w_get_num_elem(0, SEW);

  // See above comment in WMVXS for why LMUL is used here
  let W_LMUL_pow = w_get_lmul_pow();
  let num_elem_wstart = w_get_num_elem(W_LMUL_pow, SEW);

  if w_illegal_wstart(W_WSTART_SCALAR_MOVE, num_elem_wstart, W_LMUL_pow) | w_illegal_wd_unmasked() then {
    return Illegal_Instruction()
  };

  assert(num_elem > 0);

  let (n as 'n) = num_elem;
  let (m as 'm) = SEW;

  let rs1_val : bits('m) = w_get_scalar(rs1, sizeof('m));
  let wd_val : vector('n, bits('m)) = w_read_wreg(num_elem, SEW, 0, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = w_init_masked_result(
    num_elem,
    SEW,
    0,
    wd_val,
    ones(),
  );
  var result = initial_result;

  // one body element
  if w_shape(mask, w_columns)[0][0] == 0b1 then {
    var origin_view = w_shape(result, w_columns);
    origin_view[0][0] = rs1_val;
    result = w_unshape_vector(length(result), origin_view, w_columns)
  };

  // others treated as tail elements
  let tail_ag : w_agtype = w_get_wtype_wta();
  {
    var result_view = w_shape(result, w_columns);
    let wd_val_view = w_shape(wd_val, w_columns);
    foreach (p from 1 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(result_view));
      assert(i < length(wd_val_view));
      assert(j < w_columns);

      result_view[i][j] = match tail_ag {
        W_UNDISTURBED => wd_val_view[i][j],
        W_AGNOSTIC    => wd_val_view[i][j], // TODO: configuration support
      }
    };
    result = w_unshape_vector(length(result), result_view, w_columns)
  };

  w_write_wreg(num_elem, SEW, 0, wd, result);
  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_WMVSX(rs1, wd)
 <-> "wmv.s.x" ^ spc() ^ w_wreg_name(wd) ^ sep() ^ reg_name(rs1)
