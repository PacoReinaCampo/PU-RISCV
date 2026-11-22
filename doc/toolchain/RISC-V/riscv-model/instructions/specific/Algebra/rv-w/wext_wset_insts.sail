// =======================================================================================
// This Sail RISC-W architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

// ******************************************************************************
// This file implements part of the matrix extension.
// Chapter 6: Configuration-Setting Instructions
// ******************************************************************************


mapping w_sew_flag : string <-> bits(3) = {
 "e8"    <-> 0b000,
 "e16"   <-> 0b001,
 "e32"   <-> 0b010,
 "e64"   <-> 0b011,
}

mapping w_maybe_lmul_flag : string <-> bits(3) = {
 sep() ^ "mf8"   <-> 0b101,
 sep() ^ "mf4"   <-> 0b110,
 sep() ^ "mf2"   <-> 0b111,
 sep() ^ "m1"    <-> 0b000,
 sep() ^ "m2"    <-> 0b001,
 sep() ^ "m4"    <-> 0b010,
 sep() ^ "m8"    <-> 0b011,
 forwards ""      => 0b000, // m1 by default
}

mapping w_ta_flag : string <-> bits(1) = {
 sep() ^ "ta" <-> 0b1,
 sep() ^ "tu" <-> 0b0,
}

mapping w_ma_flag : string <-> bits(1) = {
 sep() ^ "ma" <-> 0b1,
 sep() ^ "mu" <-> 0b0,
}

// For wsetwli and wsetiwli, wtr = 0b000 is implicit in the assembly and
// cannot be printed.
val w_wtr_mnemonic : bits(3) <-> string
function w_wtr_mnemonic_forwards(_wtr) = ""
function w_wtr_mnemonic_forwards_matches(_wtr) = true

mapping w_wtype_assembly : (bits(3), bits(1), bits(1), bits(3), bits(3)) <-> string = {
 // Mnemonics are preferable but there's no mnemonic for lmul=0b100.
 (wtr, ma, ta, sew, lmul) <-> w_sew_flag(sew) ^ w_maybe_lmul_flag(lmul) ^ w_ta_flag(ta) ^ w_ma_flag(ma) ^ w_wtr_mnemonic(wtr)
  when sew[2] != 0b1 & lmul != 0b100 & wtr == 0b000,
 // However that is still potentially a legal instruction so you can
 // use an integer for the whole wtype in that case.
 (wtr, ma, ta, sew, lmul) <-> hex_bits_11(wtr @ ma @ ta @ sew @ lmul)
}

private function w_handle_illegal_wtype(rd : regidx) -> ExecutionResult = {
  // Note: wstart should NOT be zeroed out and rd
  //       should NOT be written if trapping.
  match w_illegal_wtype_reserved_behavior {
    IllegalVtype_Illegal => return Illegal_Instruction(),
    IllegalVtype_Fatal   => reserved_behavior("unsupported or reserved vtype"),
    IllegalVtype_SetVill => (),
  };

  wtype.bits = 0b1 @ zeros(xlen - 1); // set wtype.will
  w_dirty_w_context();
  wl = zeros();
  csr_write_callback("wtype", wtype.bits);
  csr_write_callback("wl", zero_extend(wl));
  w_set_wstart(zeros());

  // "The vset{i}vl{i} instructions set the vtype and vl CSRs based on their arguments,
  //  and write the new value of vl into rd."
  // So `rd` should be written even if the arguments were illegal or reserved.
  X(rd) = zero_extend(wl);
  RETIRE_SUCCESS
}

let w_wl_use_ceil : bool = config extensions.W.wl_use_ceil

private function w_calculate_new_wl(AVL : xlenbits, WLMAX : range(1, wlen)) -> range(0, wlen) = {
  let AVL = unsigned(AVL);

  // See "Constraints on Setting vl" in the matrix spec.
  if AVL <= WLMAX then {
    AVL
  } else {
    if AVL < 2 * WLMAX then {
      // If WLMAX < AVL < 2 * WLMAX then we can use any value
      // such that ceil(AVL / 2) <= wl <= WLMAX. Here we provide
      // two options: ceil(AVL / 2) or WLMAX.
      if w_wl_use_ceil then {
        (AVL + 1) / 2
      } else {
        WLMAX
      }
    } else {
      WLMAX
    }
  }
}

// Execute wsetwl, wsetwli, or wsetiwli.
private function w_execute_wsetwl_type(
  ma : bits(1),
  ta : bits(1),
  sew : bits(3),
  lmul : bits(3),
  avl : xlenbits,
  requires_fixed_wlmax : bool,
  rd : regidx,
) -> (
  ExecutionResult
) = {
  // Check new SEW and LMUL have legal encodings. There are some reserved values.
  if w_is_invalid_lmul_pow(lmul) | w_is_invalid_sew_pow(sew) then {
    return w_handle_illegal_wtype(rd)
  };

  let LMUL_pow_new = signed(lmul);
  let SEW_pow_new = unsigned(sew) + 3;

  let lmul_sew_ratio = w_get_lmul_pow() - w_get_sew_pow();
  let lmul_sew_ratio_new = LMUL_pow_new - SEW_pow_new;

  // Check the following:
  // - SEW cannot exceed ELEN.
  // - "For a given supported fractional LMUL setting, implementations must
  //   support SEW settings between SEWMIN and LMUL * ELEN, inclusive."
  // - Also some cases require that WLMAX doesn't change (i.e. LMUL/SEW is constant).
  if   SEW_pow_new
   > welen_exp
   | SEW_pow_new
   > (LMUL_pow_new + welen_exp)
   | (requires_fixed_wlmax & (lmul_sew_ratio != lmul_sew_ratio_new | not(w_valid_wtype()))) then {
    return w_handle_illegal_wtype(rd)
  };

  let WLMAX = 2 ^ (LMUL_pow_new + wlen_exp - SEW_pow_new);

  w_dirty_w_context();
  wl = to_bits(w_calculate_new_wl(avl, WLMAX));
  X(rd) = zero_extend(wl);

  wtype = [Mk_Wtype(zeros()) with will = 0b0, wma = ma, wta = ta, wsew = sew, wlmul = lmul];

  // reset wstart to 0
  w_set_wstart(zeros());

  csr_write_callback("wtype", wtype.bits);
  csr_write_callback("wl", zero_extend(wl));
  csr_write_callback("wstart", zero_extend(wstart));

  RETIRE_SUCCESS
}

// ********************************** wsetwli ***********************************
union clause instruction = W_WSETWLI : (bits(3), bits(1), bits(1), bits(3), bits(3), regidx, regidx)

mapping clause encdec = W_WSETWLI(wtr, ma, ta, sew, lmul, rs1, rd)
 <-> 0b0 @ wtr @ ma @ ta @ sew @ lmul @ encdec_reg(rs1) @ 0b111 @ encdec_reg(rd) @ 0b0001011
 when currentlyEnabled(Ext_W)

function clause execute(W_WSETWLI(wtr, ma, ta, sew, lmul, rs1, rd)) = {
  if wtr != zeros() then {
    return w_handle_illegal_wtype(rd)
  };

  let avl = if rs1 != zreg then {
      X(rs1)
    } else {
      if rd != zreg then {
        ones()
      } else {
        zero_extend(wl)
      }
    };

  let requires_fixed_wlmax = rd == zreg & rs1 == zreg;

  w_execute_wsetwl_type(ma, ta, sew, lmul, avl, requires_fixed_wlmax, rd)
}

mapping clause assembly = W_WSETWLI(wtr, ma, ta, sew, lmul, rs1, rd)
 <-> "wsetwli" ^ spc() ^ reg_name(rd) ^ sep() ^ reg_name(rs1) ^ sep() ^ w_wtype_assembly(wtr, ma, ta, sew, lmul)

// ********************************** wsetwl ************************************
union clause instruction = W_WSETWL : (regidx, regidx, regidx)

mapping clause encdec = W_WSETWL(rs2, rs1, rd)
 <-> 0b1000000 @ encdec_reg(rs2) @ encdec_reg(rs1) @ 0b111 @ encdec_reg(rd) @ 0b0001011
 when currentlyEnabled(Ext_W)

function clause execute(W_WSETWL(rs2, rs1, rd)) = {
  let vt = Mk_Wtype(X(rs2));

  if vt[will] == 0b1 | vt[w_reserved] != zeros() then {
    return w_handle_illegal_wtype(rd)
  };

  let avl = if rs1 != zreg then {
      X(rs1)
    } else {
      if rd != zreg then {
        ones()
      } else {
        zero_extend(wl)
      }
    };

  let requires_fixed_wlmax = rd == zreg & rs1 == zreg;

  w_execute_wsetwl_type(vt[wma], vt[wta], vt[wsew], vt[wlmul], avl, requires_fixed_wlmax, rd)
}

mapping clause assembly = W_WSETWL(rs2, rs1, rd)
 <-> "wsetwl" ^ spc() ^ reg_name(rd) ^ sep() ^ reg_name(rs1) ^ sep() ^ reg_name(rs2)

// ********************************* wsetiwli ***********************************
union clause instruction = W_WSETIWLI : (bits(3), bits(1), bits(1), bits(3), bits(3), bits(5), regidx)

mapping clause encdec = W_WSETIWLI(0b0 @ wtr, ma, ta, sew, lmul, uimm, rd)
 <-> 0b11 @ wtr @ ma @ ta @ sew @ lmul @ uimm @ 0b111 @ encdec_reg(rd) @ 0b0001011
 when currentlyEnabled(Ext_W)

function clause execute(W_WSETIWLI(wtr, ma, ta, sew, lmul, uimm, rd)) = {
  if wtr != zeros() then {
    return w_handle_illegal_wtype(rd)
  };

  let avl : xlenbits = zero_extend(uimm);
  w_execute_wsetwl_type(ma, ta, sew, lmul, avl, false, rd)
}

mapping clause assembly = W_WSETIWLI(wtr, ma, ta, sew, lmul, uimm, rd)
 <-> "wsetiwli" ^ spc() ^ reg_name(rd) ^ sep() ^ hex_bits_5(uimm) ^ sep() ^ w_wtype_assembly(wtr, ma, ta, sew, lmul)
