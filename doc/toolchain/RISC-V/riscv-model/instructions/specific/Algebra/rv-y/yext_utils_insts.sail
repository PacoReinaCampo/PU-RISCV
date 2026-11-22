// =======================================================================================
// This Sail RISC-Y architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

// ******************************************************************************
// This file implements functions used by tensor instructions.
// ******************************************************************************

// Tensor mask mapping
mapping y_maybe_ymask : string <-> bits(1) = {
 ""              <-> 0b1, // unmasked by default
 sep() ^ "y0.t"  <-> 0b0
}

let y_ystart_arith_zero_required : bool = config extensions.Y.ystart.zero_required.arith
let y_ystart_scalar_move_zero_required : bool = config extensions.Y.ystart.zero_required.scalar_move

// Returns true if the instruction should raise an illegal instruction
// exception due to a non-zero ystart, depending on the instruction class.
//
// YSTART_ARITH       - Standard arithmetic instructions. The model never
//                  produces a non-zero ystart for these instructions, so
//                  the spec permits trapping on a non-zero ystart. This
//                  is configurable via `extensions.Y.ystart.zero_required.arith`.
//
// YSTART_LOAD_STORE  - Memory instructions (loads, stores, segment, indexed,
//                  fault-only-first, whole-register, and mask load/store).
//                  Any in-bounds ystart is allowed since ystart is required
//                  for trap resumption; only an out-of-bounds ystart (greater
//                  than the largest element index) traps. Not configurable.
//
// YSTART_SCALAR_MOVE - Scalar move instructions (vmv.x.s, vmv.s.x, vfmv.f.s,
//                  vfmv.s.f). Both trapping and not trapping on a non-zero
//                  ystart are permitted, see https://github.com/riscv/riscv-isa-manual/issues/2564
//                  Configurable via `extensions.Y.ystart.zero_required.scalar_move`
//
// YSTART_MANDATORY   - Instructions where the spec explicitly requires an
//                  illegal instruction exception when ystart is non-zero:
//                  all reductions, vcompress, vcpop.m, vfirst.m,
//                  vmsbf/sif/sof.m, and viota.m. Always traps, not
//                  configurable.
//
// num_elem is what get_num_elem returned, and EMUL_pow is the EMUL used
// to compute it. A ystart past the largest element index (YLMAX - 1) is
// reserved. We need EMUL_pow to work out YLMAX when LMUL is fractional.
function y_illegal_ystart(cls : y_ystart_class, num_elem : nat, EMUL_pow : int) -> bool = {
  let vs = unsigned(ystart);

  // For fractional LMUL, get_num_elem returns a whole register of elements,
  // which is bigger than YLMAX, so divide to get YLMAX. When EMUL_pow >= 0,
  // num_elem already equals YLMAX and we use it as-is.
  let YLMAX = if EMUL_pow >= 0 then {
      num_elem
    } else {
      num_elem / (2 ^ (0 - EMUL_pow))
    };

  // An out-of-bounds ystart (>= YLMAX) is reserved. The spec recommends but
  // does not require trapping, whether it traps is configurable.
  let out_of_bounds : bool = match y_ystart_reserved_behavior {
    Vstart_Illegal => vs >= YLMAX,
    Vstart_Ignore  => false,
  };
  match cls {
    // Out-of-bounds ystart traps per config, in-bounds non-zero traps per config.
    Y_YSTART_ARITH       => out_of_bounds | (y_ystart_arith_zero_required & vs != 0),
    Y_YSTART_LOAD_STORE  => out_of_bounds,
    Y_YSTART_SCALAR_MOVE => out_of_bounds | (y_ystart_scalar_move_zero_required & vs != 0),
    Y_YSTART_MANDATORY   => vs != 0,
  }
}

// Check for valid EEW and EMUL values in:
//
// 1. tensor widening/narrowing instructions
// 2. tensor load/store instructions
function y_valid_eew_emul(EEW : nat, EMUL_pow : int) -> bool = {
  EEW >= 8 & EEW <= yelen & EMUL_pow >= -3 & EMUL_pow <= 3
}

// Check for valid ytype setting
//
// 1. If the yill bit is set, then any attempt to execute a tensor instruction that depends upon ytype will raise an illegal instruction exception.
// 2. yset{i}yl{i} and whole-register loads, stores, and moves do not depend upon ytype.
function y_valid_ytype() -> bool = {
  ytype[yill] == 0b0
}

// Check for valid destination register when tensor masking is enabled:
// The destination tensor register group for a masked tensor instruction
// cannot overlap the source mask register (v0),
// unless the destination tensor register is being written with a mask value (e.g., compares)
// or the scalar result of a reduction.
function y_valid_rd_mask(rd : yregidx, ym : bits(1)) -> bool = {
  ym != 0b0 | rd != y_zyreg
}

// Check that a tensor register number for a tensor register group is
// a multiple of its EMUL. Fractional EMULs are rounded up to 1.
function y_valid_reg_group(r : yregidx, EMUL_pow : int) -> bool =
  (unsigned(y_yregidx_bits(r)) % (2 ^ max(EMUL_pow, 0))) == 0

// For whole register loads/stores: "The nf field encodes how many
// vector registers to load and store using the NFIELDS encoding. The
// encoded number of registers must be a power of 2 and the vector
// register numbers must be aligned as with a vector register group,
// otherwise the instruction encoding is reserved."
function y_valid_whole_register(r : yregidx, nf : y_nfields_pow2) -> bool = {
  unsigned(y_yregidx_bits(r)) % nf == 0
}

// Check for valid register overlap in tensor widening/narrowing instructions:
// In a widening instruction, the overlap is valid only in the highest-numbered part
// of the destination register group, and the source EMUL is at least 1.
// In a narrowing instruction, the overlap is valid only in the lowest-numbered part
// of the source register group.
// This also checks that the source and destination register groups are valid.
function y_valid_reg_overlap(rs : yregidx, rd : yregidx, EMUL_pow_rs : int, EMUL_pow_rd : int) -> bool = {
  let rs_group = 2 ^ max(EMUL_pow_rs, 0);
  let rd_group = 2 ^ max(EMUL_pow_rd, 0);
  let rs_int = unsigned(y_yregidx_bits(rs));
  let rd_int = unsigned(y_yregidx_bits(rd));

  if rs_int % rs_group != 0 | rd_int % rd_group != 0 then {
    return false
  };

  if EMUL_pow_rs < EMUL_pow_rd then {
     (rs_int + rs_group <= rd_int)
    | (rs_int >= rd_int + rd_group)
    | ((rs_int + rs_group == rd_int + rd_group) & (EMUL_pow_rs >= 0))
  } else {
    if EMUL_pow_rs > EMUL_pow_rd then {
      (rd_int <= rs_int) | (rd_int >= rs_int + rs_group)
    } else {
      true
    }
  }
}

function y_valid_disjoint_reg_groups(rs : yregidx, rd : yregidx, EMUL_pow_rs : int, EMUL_pow_rd : int) -> bool = {
  let rs_group = 2 ^ max(EMUL_pow_rs, 0);
  let rd_group = 2 ^ max(EMUL_pow_rd, 0);
  let rs_int = unsigned(y_yregidx_bits(rs));
  let rd_int = unsigned(y_yregidx_bits(rd));

  if rs_int % rs_group != 0 | rd_int % rd_group != 0 then {
    return false
  };

  rs_int + rs_group <= rd_int | rd_int + rd_group <= rs_int
}

// Check for valid overlaps in segmented instructions that have an additional number of data fields
function y_valid_disjoint_reg_groups_segmented(
  rs : yregidx,
  rd : yregidx,
  EMUL_pow_rs : int,
  EMUL_pow_rd : int,
  data_fields : y_nfields,
) -> (
  bool
) = {
  let rs_group = 2 ^ max(EMUL_pow_rs, 0);
  let rd_group = 2 ^ max(EMUL_pow_rd, 0);
  let rs_int = unsigned(y_yregidx_bits(rs));
  let rd_int = unsigned(y_yregidx_bits(rd));

  if rs_int % rs_group != 0 | rd_int % rd_group != 0 then {
    return false
  };

  rs_int + rs_group <= rd_int | rd_int + rd_group * data_fields <= rs_int
}

// Check for valid overlaps between source register groups: overlaps
// are not allowed if the EEWs are different for the two groups; a
// mask register is considered to have EEW of 1. This also checks if
// the register groups are valid.
function y_valid_src_overlap(
  rs1 : yregidx,
  EEW_rs1 : nat,
  EMUL_pow_rs1 : int,
  rs2 : yregidx,
  EEW_rs2 : nat,
  EMUL_pow_rs2 : int,
) -> (
  bool
) = {
  let rs1_group = 2 ^ max(EMUL_pow_rs1, 0);
  let rs2_group = 2 ^ max(EMUL_pow_rs2, 0);
  let rs1_int = unsigned(y_yregidx_bits(rs1));
  let rs2_int = unsigned(y_yregidx_bits(rs2));

  if rs1_int % rs1_group != 0 | rs2_int % rs2_group != 0 then {
    return false
  };

  if EEW_rs1 == EEW_rs2 then {
    return true
  };

  rs1_int + rs1_group <= rs2_int | rs2_int + rs2_group <= rs1_int
}

// Check for Source-EEW overlap against every field of a `data_fields` segment.
// Same-EEW overlap is allowed; any other overlap is reserved.
function y_valid_src_overlap_segmented(
  rs1 : yregidx,
  EEW_rs1 : nat,
  EMUL_pow_rs1 : int,
  rs2 : yregidx,
  EEW_rs2 : nat,
  EMUL_pow_rs2 : int,
  data_fields : y_nfields,
) -> (
  bool
) =
  if EEW_rs1 == EEW_rs2 then {
    y_valid_reg_group(rs1, EMUL_pow_rs1) & y_valid_reg_group(rs2, EMUL_pow_rs2)
  } else {
    y_valid_disjoint_reg_groups_segmented(rs1, rs2, EMUL_pow_rs1, EMUL_pow_rs2, data_fields)
  }

// Check for valid overlaps between a source register group and the v0
// mask register; this is a specialization of `valid_src_overlap` for
// the mask register.
// TODO: `EEW_rs` is always != 1, but this is unfortunately not
// guaranteed by the `nat` type.  Once the type of `EEW_rs` is made
// `sew_bitsize` or similar, the assert could be removed.
function y_valid_ym_src_overlap(ym : bits(1), rs : yregidx, EEW_rs : nat) -> bool = {
  assert(EEW_rs != 1);
  ym != 0b0 | rs != y_zyreg
}

// Check for valid register grouping in tensor segment load/store instructions:
// The EMUL of load yd or store ys3 times the number of fields per segment
// must not be larger than 8. (EMUL * NFIELDS <= 8)
function y_valid_segment_group_size(nf : y_nfields, EMUL_pow : int) -> bool = {
  if EMUL_pow < 0 then {
    nf / (2 ^ (0 - EMUL_pow)) <= 8
  } else {
    nf * 2 ^ EMUL_pow <= 8
  }
}

// A segment load/store uses NFIELDS register groups of ceil(EMUL) registers
// each, starting at reg. If those would run past v31 the encoding is
// reserved, so check the last register stays in range.
function y_valid_segment_group_without_overflow(reg : yregidx, nf : y_nfields, EMUL_pow : int) -> bool = {
  let EMUL_reg = 2 ^ max(EMUL_pow, 0);
  unsigned(y_yregidx_bits(reg)) + nf * EMUL_reg <= 32
}

/// "VSMUL.VX and VSMUL.VV are not included in EEW=64 in Zve64*."
function y_valid_wide_yytype(yytype : y_yyfunct6) -> bool =
  match yytype {
    Y_YY_YSMUL => hartSupports(Ext_Y) & (misa[Y] == 0b1) & (ylen >= 128),
    _ => true,
  }
function y_valid_wide_yxtype(yxtype : y_yxfunct6) -> bool =
  match yxtype {
    Y_YX_YSMUL => hartSupports(Ext_Y) & (misa[Y] == 0b1) & (ylen >= 128),
    _ => true,
  }

/// The vmulh integer multiply variants that return the high word of the product (vmulh.yy, vmulh.yx, vmulhu.yy, vmulhu.yx,
/// vmulhsu.yy, vmulhsu.yx) are not included for EEW=64 in Zve64*.
function y_valid_wide_myytype(myytype : y_myyfunct6) -> bool =
  match myytype {
    Y_MYY_YMULH => hartSupports(Ext_Y) & (misa[Y] == 0b1) & (ylen >= 128),
    Y_MYY_YMULHU => hartSupports(Ext_Y) & (misa[Y] == 0b1) & (ylen >= 128),
    Y_MYY_YMULHSU => hartSupports(Ext_Y) & (misa[Y] == 0b1) & (ylen >= 128),
    _ => true,
  }
function y_valid_wide_myxtype(myxtype : y_myxfunct6) -> bool =
  match myxtype {
    Y_MYX_YMULH => hartSupports(Ext_Y) & (misa[Y] == 0b1) & (ylen >= 128),
    Y_MYX_YMULHU => hartSupports(Ext_Y) & (misa[Y] == 0b1) & (ylen >= 128),
    Y_MYX_YMULHSU => hartSupports(Ext_Y) & (misa[Y] == 0b1) & (ylen >= 128),
    _ => true,
  }

// Check tensor floating-point conversions.
function y_valid_widening_fp_conversion(cvt : y_vfwunary0) -> bool =
  match cvt {
    Y_FWIDE_Y_CVT_F_F => ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfhmin)) & y_get_sew() == 16) |
      ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 32),
    Y_FWIDE_Y_CVT_F_XU =>   ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh)) & y_get_sew() == 8)
               | ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_F)) & y_get_sew() == 16)
               | ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 32),
    Y_FWIDE_Y_CVT_F_X =>   ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh)) & y_get_sew() == 8)
              | ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_F)) & y_get_sew() == 16)
              | ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 32),
    _ => ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh)) & y_get_sew() == 16) |
      ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_F)) & y_get_sew() == 32),
  }

function y_valid_narrowing_fp_conversion(cvt : y_vfnunary0) -> bool =
  match cvt {
    Y_FNV_CVT_F_F => ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfhmin)) & y_get_sew() == 16) |
      ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 32),
    Y_FNV_CVT_ROD_F_F => ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh)) & y_get_sew() == 16) |
      ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 32),
    Y_FNV_CVT_F_XU => ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh)) & y_get_sew() == 16) |
      ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_F)) & y_get_sew() == 32),
    Y_FNV_CVT_F_X => ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh)) & y_get_sew() == 16) |
      ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_F)) & y_get_sew() == 32),
    _ =>   ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_Zfh)) & y_get_sew() == 8)
      | ((currentlyEnabled(Ext_Y) & currentlyEnabled(Ext_F)) & y_get_sew() == 16)
      | ((currentlyEnabled(Ext_Y) & yelen >= 64 & currentlyEnabled(Ext_D)) & y_get_sew() == 32),
  }

// ******************************************************************************
// The following functions summarize patterns of illegal instruction check.
// ******************************************************************************

// a. Normal check including ytype.yill field and yd/v0 overlap if ym = 0
function y_illegal_normal(yd : yregidx, ym : bits(1)) -> bool = {
  not(y_valid_ytype()) | not(y_valid_rd_mask(yd, ym))
}

// b. Masked check for instructions encoded with ym = 0
function y_illegal_yd_masked(yd : yregidx) -> bool = {
  not(y_valid_ytype()) | yd == y_zyreg
}

// c. Unmasked check for:
//   1. instructions encoded with ym = 1
//   2. instructions with scalar rd: vcpop.m, vfirst.m
//   3. yd as mask register (eew = 1):
//      ymadc.yym/yxm/yim, vmsbc.yym/yxm, mask logical, integer compare, vlm.y, vsm.y
function y_illegal_yd_unmasked() -> bool = {
  not(y_valid_ytype())
}

// d. Variable width check for:
//   1. integer/fixed-point widening/narrowing instructions
//   2. tensor integer extension: vzext, vsext
//   3. tensor crypto extension: zvbb
function y_illegal_variable_width(yd : yregidx, ym : bits(1), SEW_new : nat, LMUL_pow_new : int) -> bool = {
  not(y_valid_ytype()) | not(y_valid_rd_mask(yd, ym)) | not(y_valid_eew_emul(SEW_new, LMUL_pow_new))
}

// e. Normal check for reduction instructions:
//  The destination tensor register can overlap the source operands, including the mask register.
function y_illegal_reduction() -> bool = {
  not(y_valid_ytype())
}

// f. Variable width check for widening reduction instructions
function y_illegal_widening_reduction(EEW : nat) -> bool = {
  y_illegal_reduction() | not(EEW >= 8 & EEW <= yelen)
}

// g. Non-indexed load instruction check
function y_illegal_load(yd : yregidx, ym : bits(1), nf : y_nfields, EEW : nat, EMUL_pow : int) -> bool = {
   not(y_valid_ytype())
  | not(y_valid_rd_mask(yd, ym))
  | not(y_valid_eew_emul(EEW, EMUL_pow))
  | not(y_valid_segment_group_size(nf, EMUL_pow))
  | not(y_valid_segment_group_without_overflow(yd, nf, EMUL_pow))
}

// h. Non-indexed store instruction check (with ys3 rather than yd)
function y_illegal_store(ys3 : yregidx, nf : y_nfields, EEW : nat, EMUL_pow : int) -> bool = {
   not(y_valid_ytype())
  | not(y_valid_eew_emul(EEW, EMUL_pow))
  | not(y_valid_segment_group_size(nf, EMUL_pow))
  | not(y_valid_segment_group_without_overflow(ys3, nf, EMUL_pow))
}

// i. Indexed load instruction check
function y_illegal_indexed_load(
  yd : yregidx,
  ym : bits(1),
  nf : y_nfields,
  EEW_index : nat,
  EMUL_pow_index : int,
  EMUL_pow_data : int,
) -> (
  bool
) = {
   not(y_valid_ytype())
  | not(y_valid_rd_mask(yd, ym))
  | not(y_valid_eew_emul(EEW_index, EMUL_pow_index))
  | not(y_valid_segment_group_size(nf, EMUL_pow_data))
  | not(y_valid_segment_group_without_overflow(yd, nf, EMUL_pow_data))
}

// j. Indexed store instruction check (with ys3 rather than yd)
function y_illegal_indexed_store(
  ys3 : yregidx,
  nf : y_nfields,
  EEW_index : nat,
  EMUL_pow_index : int,
  EMUL_pow_data : int,
) -> (
  bool
) = {
   not(y_valid_ytype())
  | not(y_valid_eew_emul(EEW_index, EMUL_pow_index))
  | not(y_valid_segment_group_size(nf, EMUL_pow_data))
  | not(y_valid_segment_group_without_overflow(ys3, nf, EMUL_pow_data))
}

// Scalar register shaping
val y_get_scalar : forall 'm, 'm >= 8. (regidx, int('m)) -> bits('m)
function y_get_scalar(rs1, SEW) = {
  if SEW <= xlen then {
    // Least significant SEW bits
    X(rs1)[SEW - 1 .. 0]
  } else {
    // Sign extend to SEW
    sign_extend(SEW, X(rs1))
  }
}

// Extracts 4 consecutive tensor elements starting from index 4*i and returns a bittensor
val y_get_yelem_quad : forall 'n 'm 'p, 'n > 0 & 'm > 0 & 'p >= 0 & 4 * 'p + 3 < 'n. (vector('n, bits('m)), int('p)) -> bits(
    4 * 'm,
  )
function y_get_yelem_quad(y, i) = y[4 * i + 3] @ y[4 * i + 2] @ y[4 * i + 1] @ y[4 * i]

// Divide the input bittensor into 4 equal slices and store them in yd starting at position 4*i
val y_write_yelem_quad : forall 'n, 'n > 0. (yregidx, y_sew_bitsize, bits('n), nat) -> unit
function y_write_yelem_quad(yd, SEW, input, i) = {
  foreach (j from 0 to 3) {
    // TODO: Change the type signature to enforce this assertion.
    assert((j + 1) * SEW <= sizeof('n));
    y_write_single_element(SEW, 4 * i + j, yd, input[(j + 1) * SEW - 1 .. j * SEW])
  }
}

// Extracts 8 consecutive tensor elements starting from index 8*i and returns a
// tensor. The parameter n is implicit to help proof the proof assistant
// backends infer its value.
val y_get_yelem_oct_vec : forall 'n 'm 'p, 'n > 0 & 8 <= 'm <= 64 & 'p >= 0 & 8 * 'p + 7 < 'n. (
    implicit('n),
    vector('n, bits('m)),
    int('p),
  ) -> vector(8, bits('m))
function y_get_yelem_oct_vec(_n, y, i) =
  [y[8 * i + 7], y[8 * i + 6], y[8 * i + 5], y[8 * i + 4], y[8 * i + 3], y[8 * i + 2], y[8 * i + 1], y[8 * i]]

// Writes each of the 8 elements from the input tensor to the tensor register yd, starting at position 8 * i
val y_write_yelem_oct_vec : forall 'n, y_is_sew_bitsize('n). (yregidx, int('n), vector(8, bits('n)), nat) -> unit
function y_write_yelem_oct_vec(yd, SEW, input, i) = {
  foreach (j from 0 to 7)
    y_write_single_element(SEW, 8 * i + j, yd, input[j])
}

// Extracts 4 consecutive tensor elements starting from index 4*i and returns a tensor
val y_get_yelem_quad_vec : forall 'n 'm 'p, 'n > 0 & 8 <= 'm <= 64 & 'p >= 0 & 4 * 'p + 3 < 'n. (
    vector('n, bits('m)),
    int('p),
  ) -> vector(4, bits('m))
function y_get_yelem_quad_vec(y, i) = [y[4 * i + 3], y[4 * i + 2], y[4 * i + 1], y[4 * i]]

// Writes each of the 4 elements from the input tensor to the tensor register yd, starting at position 4 * i
val y_write_yelem_quad_vec : forall 'p 'n, y_is_sew_bitsize('n) & 'p >= 0. (
    yregidx,
    int('n),
    vector(4, bits('n)),
    int('p),
  ) -> unit
function y_write_yelem_quad_vec(yd, SEW, input, i) = {
  foreach (j from 0 to 3)
    y_write_single_element(SEW, 4 * i + j, yd, input[j])
}

// Get the starting element index from the ystart csr. The validity of
// ystart is checked by illegal_ystart at the start of each instruction,
// so this just returns the value.
function y_get_start_element() -> yelemidx = unsigned(ystart)

// Get the ending element index from csr yl
function y_get_end_element() -> int = unsigned(yl) - 1

// Mask handling; creates a pre-masked result tensor for ystart, yl, yta/yma, and ym
// ym should be baked into ym_val from doing read_ymask
// tail masking when lmul < 1 is handled in write_yreg
// Returns two tensors:
//   tensor1 is the result tensor with values applied to masked elements
//   tensor2 is a "mask" tensor that is true for an element if the corresponding element
//     in the result tensor should be updated by the calling instruction
val y_init_masked_result : forall 'n 'm 'p, 'n >= 0. (int('n), int('m), int('p), vector('n, bits('m)), bits('n)) -> (
    vector('n, bits('m)),
    bits('n),
  )
function y_init_masked_result(num_elem, _EEW, Y_LMUL_pow, yd_val, ym_val) = {
  let start_element = y_get_start_element();
  let end_element = y_get_end_element();
  let tail_ag : y_agtype = y_get_ytype_yta();
  let mask_ag : y_agtype = y_get_ytype_yma();
  var mask : bits('n) = undefined;
  var result : vector('n, bits('m)) = undefined;

  // Determine the actual number of elements when lmul < 1
  let real_num_elem = if Y_LMUL_pow >= 0 then {
      num_elem
    } else {
      num_elem / (2 ^ (0 - Y_LMUL_pow))
    };
  assert(num_elem >= real_num_elem);

  foreach (i from 0 to (num_elem - 1)) {
    if i < start_element then {
      // Prestart elements defined by ystart
      result[i] = yd_val[i];
      mask[i] = 0b0
    } else {
      if i > end_element then {
        // Tail elements defined by yl
        result[i] = match tail_ag {
          Y_UNDISTURBED => yd_val[i],
          Y_AGNOSTIC    => if algebra_agnostic_ones then ones() else yd_val[i], // TODO: configuration support
        };
        mask[i] = 0b0
      } else {
        if i >= real_num_elem then {
          // Tail elements defined by lmul < 1
          result[i] = match tail_ag {
            Y_UNDISTURBED => yd_val[i],
            Y_AGNOSTIC    => if algebra_agnostic_ones then ones() else yd_val[i], // TODO: configuration support
          };
          mask[i] = 0b0
        } else {
          if ym_val[i] == 0b0 then {
            // Inactive body elements defined by ym
            result[i] = match mask_ag {
              Y_UNDISTURBED => yd_val[i],
              Y_AGNOSTIC    => if algebra_agnostic_ones then ones() else yd_val[i], // TODO: configuration support
            };
            mask[i] = 0b0
          } else {
            // Active body elements
            mask[i] = 0b1
          }
        }
      }
    }
  };

  (result, mask)
}

// For instructions like tensor reduction and tensor store,
// masks on prestart, inactive and tail elements only affect the validation of source register elements
// (ys3 for store and ys2 for reduction). There's no destination register to be masked.
// In these cases, this function can be called to simply get the mask tensor for vs (without the prepared yd result tensor).
val y_init_masked_source : forall 'n 'p, 'n > 0. (int('n), int('p), bits('n)) -> bits('n)
function y_init_masked_source(num_elem, Y_LMUL_pow, ym_val) = {
  let start_element = y_get_start_element();
  let end_element = y_get_end_element();
  var mask : bits('n) = undefined;

  // Determine the actual number of elements when lmul < 1
  let real_num_elem = if Y_LMUL_pow >= 0 then {
      num_elem
    } else {
      num_elem / (2 ^ (0 - Y_LMUL_pow))
    };
  assert(num_elem >= real_num_elem);

  foreach (i from 0 to (num_elem - 1)) {
    if i < start_element then {
      // Prestart elements defined by ystart
      mask[i] = 0b0
    } else {
      if i > end_element then {
        // Tail elements defined by yl
        mask[i] = 0b0
      } else {
        if i >= real_num_elem then {
          // Tail elements defined by lmul < 1
          mask[i] = 0b0
        } else {
          if ym_val[i] == 0b0 then {
            // Inactive body elements defined by ym
            mask[i] = 0b0
          } else {
            // Active body elements
            mask[i] = 0b1
          }
        }
      }
    }
  };

  mask
}

// Mask handling for carry functions that use masks as input/output
// Only prestart and tail elements are masked in a mask value
val y_init_masked_result_carry : forall 'n, 'n >= 0. (int('n), y_sew_bitsize, int, bits('n)) -> (bits('n), bits('n))
function y_init_masked_result_carry(num_elem, _EEW, Y_LMUL_pow, yd_val) = {
  let start_element = y_get_start_element();
  let end_element = y_get_end_element();
  var mask : bits('n) = undefined;
  var result : bits('n) = undefined;

  // Determine the actual number of elements when lmul < 1
  let real_num_elem = if Y_LMUL_pow >= 0 then {
      num_elem
    } else {
      num_elem / (2 ^ (0 - Y_LMUL_pow))
    };
  assert(num_elem >= real_num_elem);

  foreach (i from 0 to (num_elem - 1)) {
    if i < start_element then {
      // Prestart elements defined by ystart
      result[i] = yd_val[i];
      mask[i] = 0b0
    } else {
      if i > end_element then {
        // Tail elements defined by yl
        // Mask tail is always agnostic
        result[i] = yd_val[i]; // TODO: configuration support
        mask[i] = 0b0
      } else {
        if i >= real_num_elem then {
          // Tail elements defined by lmul < 1
          // Mask tail is always agnostic
          result[i] = yd_val[i]; // TODO: configuration support
          mask[i] = 0b0
        } else {
          // Active body elements
          mask[i] = 0b1
        }
      }
    }
  };

  (result, mask)
}

// Mask handling for cmp functions that use masks as output
val y_init_masked_result_cmp : forall 'n, 'n >= 0. (int('n), y_sew_bitsize, int, bits('n), bits('n)) -> (
    bits('n),
    bits('n),
  )
function y_init_masked_result_cmp(num_elem, _EEW, Y_LMUL_pow, yd_val, ym_val) = {
  let start_element = y_get_start_element();
  let end_element = y_get_end_element();
  let mask_ag : y_agtype = y_get_ytype_yma();
  var mask : bits('n) = undefined;
  var result : bits('n) = undefined;

  // Determine the actual number of elements when lmul < 1
  let real_num_elem = if Y_LMUL_pow >= 0 then {
      num_elem
    } else {
      num_elem / (2 ^ (0 - Y_LMUL_pow))
    };
  assert(num_elem >= real_num_elem);

  foreach (i from 0 to (num_elem - 1)) {
    if i < start_element then {
      // Prestart elements defined by ystart
      result[i] = yd_val[i];
      mask[i] = 0b0
    } else {
      if i > end_element then {
        // Tail elements defined by yl
        // Mask tail is always agnostic
        result[i] = yd_val[i]; // TODO: configuration support
        mask[i] = 0b0
      } else {
        if i >= real_num_elem then {
          // Tail elements defined by lmul < 1
          // Mask tail is always agnostic
          result[i] = yd_val[i]; // TODO: configuration support
          mask[i] = 0b0
        } else {
          if ym_val[i] == 0b0 then {
            // Inactive body elements defined by ym
            result[i] = match mask_ag {
              Y_UNDISTURBED => yd_val[i],
              Y_AGNOSTIC    => if algebra_agnostic_ones then ones() else yd_val[i], // TODO: configuration support
            };
            mask[i] = 0b0
          } else {
            // Active body elements
            mask[i] = 0b1
          }
        }
      }
    }
  };

  (result, mask)
}

// For tensor load/store segment instructions:
// Read multiple register groups and concatenate them in parallel
// The whole segments with the same element index are combined together
val y_read_yreg_seg : forall 'n 'm 'p 'q, 'n >= 0 & y_is_sew_bitsize('m) & y_nfields_range('q). (
    int('n),
    int('m),
    int('p),
    int('q),
    yregidx,
  ) -> vector('n, bits('q * 'm))
function y_read_yreg_seg(num_elem, SEW, Y_LMUL_pow, nf, yrid) = {
  let LMUL_reg : int = if Y_LMUL_pow <= 0 then {
      1
    } else {
      2 ^ Y_LMUL_pow
    };
  var yreg_list : vector('q, vector('n, bits('m))) = vector_init(vector_init(zeros()));
  var result : vector('n, bits('q * 'm)) = vector_init(zeros());
  foreach (j from 0 to (nf - 1)) {
    yreg_list[j] = y_read_yreg(num_elem, SEW, Y_LMUL_pow, y_yregidx_offset(yrid, to_bits_unsafe(5, j * LMUL_reg)))
  };
  foreach (i from 0 to (num_elem - 1)) {
    result[i] = zeros(sizeof('q) * sizeof('m));
    foreach (j from 0 to (nf - 1)) {
      result[i] = result[i] | (zero_extend(yreg_list[j][i]) << (j * sizeof('m)))
    }
  };
  result
}

// Shift amounts
val y_get_shift_amount : forall 'n, 0 <= 'n. (bits('n), y_sew_bitsize) -> nat
function y_get_shift_amount(bit_val, SEW) = {
  let lowlog2bits : range(3, 6) = match SEW {
    8  => 3,
    16 => 4,
    32 => 5,
    64 => 6,
  };
  assert(0 < lowlog2bits & lowlog2bits < sizeof('n));
  unsigned(bit_val[lowlog2bits - 1 .. 0])
}

// Fixed point rounding increment
val y_get_fixed_rounding_incr : forall ('m 'n : Int), 'm > 0 & 'n >= 0. (bits('m), int('n)) -> bits(1)
function y_get_fixed_rounding_incr(vec_elem, shift_amount) = {
  algebra_rounding_incr(vec_elem, shift_amount, ycsr[yxrm])
}

// Fixed point unsigned saturation
val y_unsigned_saturation : forall ('m 'n : Int), 'n >= 'm > 1. (int('m), bits('n)) -> bits('m)
function y_unsigned_saturation(len, elem) = {
  if unsigned(elem) > unsigned(ones(sizeof('m))) then {
    y_write_yxsat(0b1);
    ones(sizeof('m))
  } else {
    y_write_yxsat(ycsr[yxsat]);
    elem[sizeof('m) - 1 .. 0]
  }
}

// Fixed point signed saturation
val y_signed_saturation : forall ('m 'n : Int), 'n >= 'm > 1. (int('m), bits('n)) -> bits('m)
function y_signed_saturation(len, elem) = {
  if signed(elem) > signed(0b0 @ ones(sizeof('m) - 1)) then {
    y_write_yxsat(0b1);
    0b0 @ ones(sizeof('m) - 1)
  } else {
    if signed(elem) < signed(0b1 @ zeros(sizeof('m) - 1)) then {
      y_write_yxsat(0b1);
      0b1 @ zeros(sizeof('m) - 1)
    } else {
      y_write_yxsat(ycsr[yxsat]);
      elem[sizeof('m) - 1 .. 0]
    }
  }
}

// The parameter m is implicit to help proof the proof assistant backends infer its value.
val y_yrev8 : forall 'n 'm, 'n >= 0 & 'm >= 0. (implicit('m), vector('n, bits('m * 8))) -> vector('n, bits('m * 8))
function y_yrev8(_m, input) = {
  var output : vector('n, bits('m * 8)) = input;
  foreach (i from 0 to (sizeof('n) - 1)) {
    output[i] = rev8(input[i])
  };
  output
}
