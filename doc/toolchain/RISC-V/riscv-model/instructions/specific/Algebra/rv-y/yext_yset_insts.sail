// =======================================================================================
// This Sail RISC-Y architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

// ******************************************************************************
// This file implements part of the tensor extension.
// Chapter 6: Configuration-Setting Instructions
// ******************************************************************************


mapping y_sew_flag : string <-> bits(3) = {
 "e8"    <-> 0b000,
 "e16"   <-> 0b001,
 "e32"   <-> 0b010,
 "e64"   <-> 0b011,
}

mapping y_maybe_lmul_flag : string <-> bits(3) = {
 sep() ^ "mf8"   <-> 0b101,
 sep() ^ "mf4"   <-> 0b110,
 sep() ^ "mf2"   <-> 0b111,
 sep() ^ "m1"    <-> 0b000,
 sep() ^ "m2"    <-> 0b001,
 sep() ^ "m4"    <-> 0b010,
 sep() ^ "m8"    <-> 0b011,
 forwards ""      => 0b000, // m1 by default
}

mapping y_ta_flag : string <-> bits(1) = {
 sep() ^ "ta" <-> 0b1,
 sep() ^ "tu" <-> 0b0,
}

mapping y_ma_flag : string <-> bits(1) = {
 sep() ^ "ma" <-> 0b1,
 sep() ^ "mu" <-> 0b0,
}

// For ysetyli and ysetiyli, ytr = 0b000 is implicit in the assembly and
// cannot be printed.
val y_ytr_mnemonic : bits(3) <-> string
function y_ytr_mnemonic_forwards(_ytr) = ""
function y_ytr_mnemonic_forwards_matches(_ytr) = true

mapping y_ytype_assembly : (bits(3), bits(1), bits(1), bits(3), bits(3)) <-> string = {
 // Mnemonics are preferable but there's no mnemonic for lmul=0b100.
 (ytr, ma, ta, sew, lmul) <-> y_sew_flag(sew) ^ y_maybe_lmul_flag(lmul) ^ y_ta_flag(ta) ^ y_ma_flag(ma) ^ y_ytr_mnemonic(ytr)
  when sew[2] != 0b1 & lmul != 0b100 & ytr == 0b000,
 // However that is still potentially a legal instruction so you can
 // use an integer for the whole ytype in that case.
 (ytr, ma, ta, sew, lmul) <-> hex_bits_11(ytr @ ma @ ta @ sew @ lmul)
}

private function y_handle_illegal_ytype(rd : regidx) -> ExecutionResult = {
  // Note: ystart should NOT be zeroed out and rd
  //       should NOT be written if trapping.
  match y_illegal_ytype_reserved_behavior {
    IllegalVtype_Illegal => return Illegal_Instruction(),
    IllegalVtype_Fatal   => reserved_behavior("unsupported or reserved vtype"),
    IllegalVtype_SetVill => (),
  };

  ytype.bits = 0b1 @ zeros(xlen - 1); // set ytype.yill
  y_dirty_y_context();
  yl = zeros();
  csr_write_callback("ytype", ytype.bits);
  csr_write_callback("yl", zero_extend(yl));
  y_set_ystart(zeros());

  // "The vset{i}vl{i} instructions set the vtype and vl CSRs based on their arguments,
  //  and write the new value of vl into rd."
  // So `rd` should be written even if the arguments were illegal or reserved.
  X(rd) = zero_extend(yl);
  RETIRE_SUCCESS
}

let y_yl_use_ceil : bool = config extensions.Y.yl_use_ceil

private function y_calculate_new_yl(AVL : xlenbits, YLMAX : range(1, ylen)) -> range(0, ylen) = {
  let AVL = unsigned(AVL);

  // See "Constraints on Setting vl" in the tensor spec.
  if AVL <= YLMAX then {
    AVL
  } else {
    if AVL < 2 * YLMAX then {
      // If YLMAX < AVL < 2 * YLMAX then we can use any value
      // such that ceil(AVL / 2) <= yl <= YLMAX. Here we provide
      // two options: ceil(AVL / 2) or YLMAX.
      if y_yl_use_ceil then {
        (AVL + 1) / 2
      } else {
        YLMAX
      }
    } else {
      YLMAX
    }
  }
}

// Execute ysetyl, ysetyli, or ysetiyli.
private function y_execute_ysetyl_type(
  ma : bits(1),
  ta : bits(1),
  sew : bits(3),
  lmul : bits(3),
  avl : xlenbits,
  requires_fixed_ylmax : bool,
  rd : regidx,
) -> (
  ExecutionResult
) = {
  // Check new SEW and LMUL have legal encodings. There are some reserved values.
  if y_is_invalid_lmul_pow(lmul) | y_is_invalid_sew_pow(sew) then {
    return y_handle_illegal_ytype(rd)
  };

  let LMUL_pow_new = signed(lmul);
  let SEW_pow_new = unsigned(sew) + 3;

  let lmul_sew_ratio = y_get_lmul_pow() - y_get_sew_pow();
  let lmul_sew_ratio_new = LMUL_pow_new - SEW_pow_new;

  // Check the following:
  // - SEW cannot exceed ELEN.
  // - "For a given supported fractional LMUL setting, implementations must
  //   support SEW settings between SEWMIN and LMUL * ELEN, inclusive."
  // - Also some cases require that YLMAX doesn't change (i.e. LMUL/SEW is constant).
  if   SEW_pow_new
   > yelen_exp
   | SEW_pow_new
   > (LMUL_pow_new + yelen_exp)
   | (requires_fixed_ylmax & (lmul_sew_ratio != lmul_sew_ratio_new | not(y_valid_ytype()))) then {
    return y_handle_illegal_ytype(rd)
  };

  let YLMAX = 2 ^ (LMUL_pow_new + ylen_exp - SEW_pow_new);

  y_dirty_y_context();
  yl = to_bits(y_calculate_new_yl(avl, YLMAX));
  X(rd) = zero_extend(yl);

  ytype = [Mk_Ytype(zeros()) with yill = 0b0, yma = ma, yta = ta, ysew = sew, ylmul = lmul];

  // reset ystart to 0
  y_set_ystart(zeros());

  csr_write_callback("ytype", ytype.bits);
  csr_write_callback("yl", zero_extend(yl));
  csr_write_callback("ystart", zero_extend(ystart));

  RETIRE_SUCCESS
}

// ********************************** ysetyli ***********************************
union clause instruction = Y_YSETYLI : (bits(3), bits(1), bits(1), bits(3), bits(3), regidx, regidx)

mapping clause encdec = Y_YSETYLI(ytr, ma, ta, sew, lmul, rs1, rd)
 <-> 0b0 @ ytr @ ma @ ta @ sew @ lmul @ encdec_reg(rs1) @ 0b111 @ encdec_reg(rd) @ 0b0101011
 when currentlyEnabled(Ext_Y)

function clause execute(Y_YSETYLI(ytr, ma, ta, sew, lmul, rs1, rd)) = {
  if ytr != zeros() then {
    return y_handle_illegal_ytype(rd)
  };

  let avl = if rs1 != zreg then {
      X(rs1)
    } else {
      if rd != zreg then {
        ones()
      } else {
        zero_extend(yl)
      }
    };

  let requires_fixed_ylmax = rd == zreg & rs1 == zreg;

  y_execute_ysetyl_type(ma, ta, sew, lmul, avl, requires_fixed_ylmax, rd)
}

mapping clause assembly = Y_YSETYLI(ytr, ma, ta, sew, lmul, rs1, rd)
 <-> "ysetyli" ^ spc() ^ reg_name(rd) ^ sep() ^ reg_name(rs1) ^ sep() ^ y_ytype_assembly(ytr, ma, ta, sew, lmul)

// ********************************** ysetyl ************************************
union clause instruction = Y_YSETYL : (regidx, regidx, regidx)

mapping clause encdec = Y_YSETYL(rs2, rs1, rd)
 <-> 0b1000000 @ encdec_reg(rs2) @ encdec_reg(rs1) @ 0b111 @ encdec_reg(rd) @ 0b0101011
 when currentlyEnabled(Ext_Y)

function clause execute(Y_YSETYL(rs2, rs1, rd)) = {
  let vt = Mk_Ytype(X(rs2));

  if vt[yill] == 0b1 | vt[y_reserved] != zeros() then {
    return y_handle_illegal_ytype(rd)
  };

  let avl = if rs1 != zreg then {
      X(rs1)
    } else {
      if rd != zreg then {
        ones()
      } else {
        zero_extend(yl)
      }
    };

  let requires_fixed_ylmax = rd == zreg & rs1 == zreg;

  y_execute_ysetyl_type(vt[yma], vt[yta], vt[ysew], vt[ylmul], avl, requires_fixed_ylmax, rd)
}

mapping clause assembly = Y_YSETYL(rs2, rs1, rd)
 <-> "ysetyl" ^ spc() ^ reg_name(rd) ^ sep() ^ reg_name(rs1) ^ sep() ^ reg_name(rs2)

// ********************************* ysetiyli ***********************************
union clause instruction = Y_YSETIYLI : (bits(3), bits(1), bits(1), bits(3), bits(3), bits(5), regidx)

mapping clause encdec = Y_YSETIYLI(0b0 @ ytr, ma, ta, sew, lmul, uimm, rd)
 <-> 0b11 @ ytr @ ma @ ta @ sew @ lmul @ uimm @ 0b111 @ encdec_reg(rd) @ 0b0101011
 when currentlyEnabled(Ext_Y)

function clause execute(Y_YSETIYLI(ytr, ma, ta, sew, lmul, uimm, rd)) = {
  if ytr != zeros() then {
    return y_handle_illegal_ytype(rd)
  };

  let avl : xlenbits = zero_extend(uimm);
  y_execute_ysetyl_type(ma, ta, sew, lmul, avl, false, rd)
}

mapping clause assembly = Y_YSETIYLI(ytr, ma, ta, sew, lmul, uimm, rd)
 <-> "ysetiyli" ^ spc() ^ reg_name(rd) ^ sep() ^ hex_bits_5(uimm) ^ sep() ^ y_ytype_assembly(ytr, ma, ta, sew, lmul)
