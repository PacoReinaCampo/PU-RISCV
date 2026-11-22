// =======================================================================================
// This Sail RISC-W architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

// ******************************************************************************
// This file implements functions used by matrix instructions.
// ******************************************************************************

// Matrix mask mapping
mapping w_maybe_wmask : string <-> bits(1) = {
 ""              <-> 0b1, // unmasked by default
 sep() ^ "w0.t"  <-> 0b0
}

let w_wstart_arith_zero_required : bool = config extensions.W.wstart.zero_required.arith
let w_wstart_scalar_move_zero_required : bool = config extensions.W.wstart.zero_required.scalar_move

// Returns true if the instruction should raise an illegal instruction
// exception due to a non-zero wstart, depending on the instruction class.
//
// WSTART_ARITH       - Standard arithmetic instructions. The model never
//                  produces a non-zero wstart for these instructions, so
//                  the spec permits trapping on a non-zero wstart. This
//                  is configurable via `extensions.W.wstart.zero_required.arith`.
//
// WSTART_LOAD_STORE  - Memory instructions (loads, stores, segment, indexed,
//                  fault-only-first, whole-register, and mask load/store).
//                  Any in-bounds wstart is allowed since wstart is required
//                  for trap resumption; only an out-of-bounds wstart (greater
//                  than the largest element index) traps. Not configurable.
//
// WSTART_SCALAR_MOVE - Scalar move instructions (vmv.x.s, vmv.s.x, vfmv.f.s,
//                  vfmv.s.f). Both trapping and not trapping on a non-zero
//                  wstart are permitted, see https://github.com/riscv/riscv-isa-manual/issues/2564
//                  Configurable via `extensions.W.wstart.zero_required.scalar_move`
//
// WSTART_MANDATORY   - Instructions where the spec explicitly requires an
//                  illegal instruction exception when wstart is non-zero:
//                  all reductions, vcompress, vcpop.m, vfirst.m,
//                  vmsbf/sif/sof.m, and viota.m. Always traps, not
//                  configurable.
//
// num_elem is what get_num_elem returned, and EMUL_pow is the EMUL used
// to compute it. A wstart past the largest element index (WLMAX - 1) is
// reserved. We need EMUL_pow to work out WLMAX when LMUL is fractional.
function w_illegal_wstart(cls : w_wstart_class, num_elem : nat, EMUL_pow : int) -> bool = {
  let vs = unsigned(wstart);

  // For fractional LMUL, get_num_elem returns a whole register of elements,
  // which is bigger than WLMAX, so divide to get WLMAX. When EMUL_pow >= 0,
  // num_elem already equals WLMAX and we use it as-is.
  let WLMAX = if EMUL_pow >= 0 then {
      num_elem
    } else {
      num_elem / (2 ^ (0 - EMUL_pow))
    };

  // An out-of-bounds wstart (>= WLMAX) is reserved. The spec recommends but
  // does not require trapping, whether it traps is configurable.
  let out_of_bounds : bool = match w_wstart_reserved_behavior {
    Vstart_Illegal => vs >= WLMAX,
    Vstart_Ignore  => false,
  };
  match cls {
    // Out-of-bounds wstart traps per config, in-bounds non-zero traps per config.
    W_WSTART_ARITH       => out_of_bounds | (w_wstart_arith_zero_required & vs != 0),
    W_WSTART_LOAD_STORE  => out_of_bounds,
    W_WSTART_SCALAR_MOVE => out_of_bounds | (w_wstart_scalar_move_zero_required & vs != 0),
    W_WSTART_MANDATORY   => vs != 0,
  }
}

// Check for valid EEW and EMUL values in:
//
// 1. matrix widening/narrowing instructions
// 2. matrix load/store instructions
function w_valid_eew_emul(EEW : nat, EMUL_pow : int) -> bool = {
  EEW >= 8 & EEW <= welen & EMUL_pow >= -3 & EMUL_pow <= 3
}

// Check for valid wtype setting
//
// 1. If the will bit is set, then any attempt to execute a matrix instruction that depends upon wtype will raise an illegal instruction exception.
// 2. wset{i}wl{i} and whole-register loads, stores, and moves do not depend upon wtype.
function w_valid_wtype() -> bool = {
  wtype[will] == 0b0
}

// Check for valid destination register when matrix masking is enabled:
// The destination matrix register group for a masked matrix instruction
// cannot overlap the source mask register (v0),
// unless the destination matrix register is being written with a mask value (e.g., compares)
// or the scalar result of a reduction.
function w_valid_rd_mask(rd : wregidx, wm : bits(1)) -> bool = {
  wm != 0b0 | rd != w_zwreg
}

// Check that a matrix register number for a matrix register group is
// a multiple of its EMUL. Fractional EMULs are rounded up to 1.
function w_valid_reg_group(r : wregidx, EMUL_pow : int) -> bool =
  (unsigned(w_wregidx_bits(r)) % (2 ^ max(EMUL_pow, 0))) == 0

// For whole register loads/stores: "The nf field encodes how many
// vector registers to load and store using the NFIELDS encoding. The
// encoded number of registers must be a power of 2 and the vector
// register numbers must be aligned as with a vector register group,
// otherwise the instruction encoding is reserved."
function w_valid_whole_register(r : wregidx, nf : w_nfields_pow2) -> bool = {
  unsigned(w_wregidx_bits(r)) % nf == 0
}

// Check for valid register overlap in matrix widening/narrowing instructions:
// In a widening instruction, the overlap is valid only in the highest-numbered part
// of the destination register group, and the source EMUL is at least 1.
// In a narrowing instruction, the overlap is valid only in the lowest-numbered part
// of the source register group.
// This also checks that the source and destination register groups are valid.
function w_valid_reg_overlap(rs : wregidx, rd : wregidx, EMUL_pow_rs : int, EMUL_pow_rd : int) -> bool = {
  let rs_group = 2 ^ max(EMUL_pow_rs, 0);
  let rd_group = 2 ^ max(EMUL_pow_rd, 0);
  let rs_int = unsigned(w_wregidx_bits(rs));
  let rd_int = unsigned(w_wregidx_bits(rd));

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

function w_valid_disjoint_reg_groups(rs : wregidx, rd : wregidx, EMUL_pow_rs : int, EMUL_pow_rd : int) -> bool = {
  let rs_group = 2 ^ max(EMUL_pow_rs, 0);
  let rd_group = 2 ^ max(EMUL_pow_rd, 0);
  let rs_int = unsigned(w_wregidx_bits(rs));
  let rd_int = unsigned(w_wregidx_bits(rd));

  if rs_int % rs_group != 0 | rd_int % rd_group != 0 then {
    return false
  };

  rs_int + rs_group <= rd_int | rd_int + rd_group <= rs_int
}

// Check for valid overlaps in segmented instructions that have an additional number of data fields
function w_valid_disjoint_reg_groups_segmented(
  rs : wregidx,
  rd : wregidx,
  EMUL_pow_rs : int,
  EMUL_pow_rd : int,
  data_fields : w_nfields,
) -> (
  bool
) = {
  let rs_group = 2 ^ max(EMUL_pow_rs, 0);
  let rd_group = 2 ^ max(EMUL_pow_rd, 0);
  let rs_int = unsigned(w_wregidx_bits(rs));
  let rd_int = unsigned(w_wregidx_bits(rd));

  if rs_int % rs_group != 0 | rd_int % rd_group != 0 then {
    return false
  };

  rs_int + rs_group <= rd_int | rd_int + rd_group * data_fields <= rs_int
}

// Check for valid overlaps between source register groups: overlaps
// are not allowed if the EEWs are different for the two groups; a
// mask register is considered to have EEW of 1. This also checks if
// the register groups are valid.
function w_valid_src_overlap(
  rs1 : wregidx,
  EEW_rs1 : nat,
  EMUL_pow_rs1 : int,
  rs2 : wregidx,
  EEW_rs2 : nat,
  EMUL_pow_rs2 : int,
) -> (
  bool
) = {
  let rs1_group = 2 ^ max(EMUL_pow_rs1, 0);
  let rs2_group = 2 ^ max(EMUL_pow_rs2, 0);
  let rs1_int = unsigned(w_wregidx_bits(rs1));
  let rs2_int = unsigned(w_wregidx_bits(rs2));

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
function w_valid_src_overlap_segmented(
  rs1 : wregidx,
  EEW_rs1 : nat,
  EMUL_pow_rs1 : int,
  rs2 : wregidx,
  EEW_rs2 : nat,
  EMUL_pow_rs2 : int,
  data_fields : w_nfields,
) -> (
  bool
) =
  if EEW_rs1 == EEW_rs2 then {
    w_valid_reg_group(rs1, EMUL_pow_rs1) & w_valid_reg_group(rs2, EMUL_pow_rs2)
  } else {
    w_valid_disjoint_reg_groups_segmented(rs1, rs2, EMUL_pow_rs1, EMUL_pow_rs2, data_fields)
  }

// Check for valid overlaps between a source register group and the v0
// mask register; this is a specialization of `valid_src_overlap` for
// the mask register.
// TODO: `EEW_rs` is always != 1, but this is unfortunately not
// guaranteed by the `nat` type.  Once the type of `EEW_rs` is made
// `sew_bitsize` or similar, the assert could be removed.
function w_valid_wm_src_overlap(wm : bits(1), rs : wregidx, EEW_rs : nat) -> bool = {
  assert(EEW_rs != 1);
  wm != 0b0 | rs != w_zwreg
}

// Check for valid register grouping in matrix segment load/store instructions:
// The EMUL of load wd or store ws3 times the number of fields per segment
// must not be larger than 8. (EMUL * NFIELDS <= 8)
function w_valid_segment_group_size(nf : w_nfields, EMUL_pow : int) -> bool = {
  if EMUL_pow < 0 then {
    nf / (2 ^ (0 - EMUL_pow)) <= 8
  } else {
    nf * 2 ^ EMUL_pow <= 8
  }
}

// A segment load/store uses NFIELDS register groups of ceil(EMUL) registers
// each, starting at reg. If those would run past v31 the encoding is
// reserved, so check the last register stays in range.
function w_valid_segment_group_without_overflow(reg : wregidx, nf : w_nfields, EMUL_pow : int) -> bool = {
  let EMUL_reg = 2 ^ max(EMUL_pow, 0);
  unsigned(w_wregidx_bits(reg)) + nf * EMUL_reg <= 32
}

/// "VSMUL.VX and VSMUL.VV are not included in EEW=64 in Zve64*."
function w_valid_wide_wwtype(wwtype : w_wwfunct6) -> bool =
  match wwtype {
    W_WW_WSMUL => hartSupports(Ext_W) & (misa[W] == 0b1) & (wlen >= 128),
    _ => true,
  }
function w_valid_wide_wxtype(wxtype : w_wxfunct6) -> bool =
  match wxtype {
    W_WX_WSMUL => hartSupports(Ext_W) & (misa[W] == 0b1) & (wlen >= 128),
    _ => true,
  }

/// The vmulh integer multiply variants that return the high word of the product (vmulh.ww, vmulh.wx, vmulhu.ww, vmulhu.wx,
/// vmulhsu.ww, vmulhsu.wx) are not included for EEW=64 in Zve64*.
function w_valid_wide_mwwtype(mwwtype : w_mwwfunct6) -> bool =
  match mwwtype {
    W_MWW_WMULH => hartSupports(Ext_W) & (misa[W] == 0b1) & (wlen >= 128),
    W_MWW_WMULHU => hartSupports(Ext_W) & (misa[W] == 0b1) & (wlen >= 128),
    W_MWW_WMULHSU => hartSupports(Ext_W) & (misa[W] == 0b1) & (wlen >= 128),
    _ => true,
  }
function w_valid_wide_mwxtype(mwxtype : w_mwxfunct6) -> bool =
  match mwxtype {
    W_MWX_WMULH => hartSupports(Ext_W) & (misa[W] == 0b1) & (wlen >= 128),
    W_MWX_WMULHU => hartSupports(Ext_W) & (misa[W] == 0b1) & (wlen >= 128),
    W_MWX_WMULHSU => hartSupports(Ext_W) & (misa[W] == 0b1) & (wlen >= 128),
    _ => true,
  }

// Check matrix floating-point conversions.
function w_valid_widening_fp_conversion(cvt : w_vfwunary0) -> bool =
  match cvt {
    W_FWIDE_W_CVT_F_F => ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfhmin)) & w_get_sew() == 16) |
      ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 32),
    W_FWIDE_W_CVT_F_XU =>   ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh)) & w_get_sew() == 8)
               | ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_F)) & w_get_sew() == 16)
               | ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 32),
    W_FWIDE_W_CVT_F_X =>   ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh)) & w_get_sew() == 8)
              | ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_F)) & w_get_sew() == 16)
              | ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 32),
    _ => ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh)) & w_get_sew() == 16) |
      ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_F)) & w_get_sew() == 32),
  }

function w_valid_narrowing_fp_conversion(cvt : w_vfnunary0) -> bool =
  match cvt {
    W_FNV_CVT_F_F => ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfhmin)) & w_get_sew() == 16) |
      ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 32),
    W_FNV_CVT_ROD_F_F => ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh)) & w_get_sew() == 16) |
      ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 32),
    W_FNV_CVT_F_XU => ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh)) & w_get_sew() == 16) |
      ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_F)) & w_get_sew() == 32),
    W_FNV_CVT_F_X => ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh)) & w_get_sew() == 16) |
      ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_F)) & w_get_sew() == 32),
    _ =>   ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_Zfh)) & w_get_sew() == 8)
      | ((currentlyEnabled(Ext_W) & currentlyEnabled(Ext_F)) & w_get_sew() == 16)
      | ((currentlyEnabled(Ext_W) & welen >= 64 & currentlyEnabled(Ext_D)) & w_get_sew() == 32),
  }

// ******************************************************************************
// The following functions summarize patterns of illegal instruction check.
// ******************************************************************************

// a. Normal check including wtype.will field and wd/v0 overlap if wm = 0
function w_illegal_normal(wd : wregidx, wm : bits(1)) -> bool = {
  not(w_valid_wtype()) | not(w_valid_rd_mask(wd, wm))
}

// b. Masked check for instructions encoded with wm = 0
function w_illegal_wd_masked(wd : wregidx) -> bool = {
  not(w_valid_wtype()) | wd == w_zwreg
}

// c. Unmasked check for:
//   1. instructions encoded with wm = 1
//   2. instructions with scalar rd: vcpop.m, vfirst.m
//   3. wd as mask register (eew = 1):
//      wmadc.wwm/wxm/wim, vmsbc.wwm/wxm, mask logical, integer compare, vlm.w, vsm.w
function w_illegal_wd_unmasked() -> bool = {
  not(w_valid_wtype())
}

// d. Variable width check for:
//   1. integer/fixed-point widening/narrowing instructions
//   2. matrix integer extension: vzext, vsext
//   3. matrix crypto extension: zvbb
function w_illegal_variable_width(wd : wregidx, wm : bits(1), SEW_new : nat, LMUL_pow_new : int) -> bool = {
  not(w_valid_wtype()) | not(w_valid_rd_mask(wd, wm)) | not(w_valid_eew_emul(SEW_new, LMUL_pow_new))
}

// e. Normal check for reduction instructions:
//  The destination matrix register can overlap the source operands, including the mask register.
function w_illegal_reduction() -> bool = {
  not(w_valid_wtype())
}

// f. Variable width check for widening reduction instructions
function w_illegal_widening_reduction(EEW : nat) -> bool = {
  w_illegal_reduction() | not(EEW >= 8 & EEW <= welen)
}

// g. Non-indexed load instruction check
function w_illegal_load(wd : wregidx, wm : bits(1), nf : w_nfields, EEW : nat, EMUL_pow : int) -> bool = {
   not(w_valid_wtype())
  | not(w_valid_rd_mask(wd, wm))
  | not(w_valid_eew_emul(EEW, EMUL_pow))
  | not(w_valid_segment_group_size(nf, EMUL_pow))
  | not(w_valid_segment_group_without_overflow(wd, nf, EMUL_pow))
}

// h. Non-indexed store instruction check (with ws3 rather than wd)
function w_illegal_store(ws3 : wregidx, nf : w_nfields, EEW : nat, EMUL_pow : int) -> bool = {
   not(w_valid_wtype())
  | not(w_valid_eew_emul(EEW, EMUL_pow))
  | not(w_valid_segment_group_size(nf, EMUL_pow))
  | not(w_valid_segment_group_without_overflow(ws3, nf, EMUL_pow))
}

// i. Indexed load instruction check
function w_illegal_indexed_load(
  wd : wregidx,
  wm : bits(1),
  nf : w_nfields,
  EEW_index : nat,
  EMUL_pow_index : int,
  EMUL_pow_data : int,
) -> (
  bool
) = {
   not(w_valid_wtype())
  | not(w_valid_rd_mask(wd, wm))
  | not(w_valid_eew_emul(EEW_index, EMUL_pow_index))
  | not(w_valid_segment_group_size(nf, EMUL_pow_data))
  | not(w_valid_segment_group_without_overflow(wd, nf, EMUL_pow_data))
}

// j. Indexed store instruction check (with ws3 rather than wd)
function w_illegal_indexed_store(
  ws3 : wregidx,
  nf : w_nfields,
  EEW_index : nat,
  EMUL_pow_index : int,
  EMUL_pow_data : int,
) -> (
  bool
) = {
   not(w_valid_wtype())
  | not(w_valid_eew_emul(EEW_index, EMUL_pow_index))
  | not(w_valid_segment_group_size(nf, EMUL_pow_data))
  | not(w_valid_segment_group_without_overflow(ws3, nf, EMUL_pow_data))
}

// Scalar register shaping
val w_get_scalar : forall 'm, 'm >= 8. (regidx, int('m)) -> bits('m)
function w_get_scalar(rs1, SEW) = {
  if SEW <= xlen then {
    // Least significant SEW bits
    X(rs1)[SEW - 1 .. 0]
  } else {
    // Sign extend to SEW
    sign_extend(SEW, X(rs1))
  }
}

// Extracts 4 consecutive matrix elements starting from index 4*i and returns a bitmatrix
val w_get_welem_quad : forall 'n 'm 'p, 'n > 0 & 'm > 0 & 'p >= 0 & 4 * 'p + 3 < 'n. (vector('n, bits('m)), int('p)) -> bits(
    4 * 'm,
  )
function w_get_welem_quad(w, i) = w[4 * i + 3] @ w[4 * i + 2] @ w[4 * i + 1] @ w[4 * i]

// Divide the input bitmatrix into 4 equal slices and store them in wd starting at position 4*i
val w_write_welem_quad : forall 'n, 'n > 0. (wregidx, w_sew_bitsize, bits('n), nat) -> unit
function w_write_welem_quad(wd, SEW, input, i) = {
  foreach (j from 0 to 3) {
    // TODO: Change the type signature to enforce this assertion.
    assert((j + 1) * SEW <= sizeof('n));
    w_write_single_element(SEW, 4 * i + j, wd, input[(j + 1) * SEW - 1 .. j * SEW])
  }
}

// Extracts 8 consecutive matrix elements starting from index 8*i and returns a
// matrix. The parameter n is implicit to help proof the proof assistant
// backends infer its value.
val w_get_welem_oct_vec : forall 'n 'm 'p, 'n > 0 & 8 <= 'm <= 64 & 'p >= 0 & 8 * 'p + 7 < 'n. (
    implicit('n),
    vector('n, bits('m)),
    int('p),
  ) -> vector(8, bits('m))
function w_get_welem_oct_vec(_n, w, i) =
  [w[8 * i + 7], w[8 * i + 6], w[8 * i + 5], w[8 * i + 4], w[8 * i + 3], w[8 * i + 2], w[8 * i + 1], w[8 * i]]

// Writes each of the 8 elements from the input matrix to the matrix register wd, starting at position 8 * i
val w_write_welem_oct_vec : forall 'n, w_is_sew_bitsize('n). (wregidx, int('n), vector(8, bits('n)), nat) -> unit
function w_write_welem_oct_vec(wd, SEW, input, i) = {
  foreach (j from 0 to 7)
    w_write_single_element(SEW, 8 * i + j, wd, input[j])
}

// Extracts 4 consecutive matrix elements starting from index 4*i and returns a matrix
val w_get_welem_quad_vec : forall 'n 'm 'p, 'n > 0 & 8 <= 'm <= 64 & 'p >= 0 & 4 * 'p + 3 < 'n. (
    vector('n, bits('m)),
    int('p),
  ) -> vector(4, bits('m))
function w_get_welem_quad_vec(w, i) = [w[4 * i + 3], w[4 * i + 2], w[4 * i + 1], w[4 * i]]

// Writes each of the 4 elements from the input matrix to the matrix register wd, starting at position 4 * i
val w_write_welem_quad_vec : forall 'p 'n, w_is_sew_bitsize('n) & 'p >= 0. (
    wregidx,
    int('n),
    vector(4, bits('n)),
    int('p),
  ) -> unit
function w_write_welem_quad_vec(wd, SEW, input, i) = {
  foreach (j from 0 to 3)
    w_write_single_element(SEW, 4 * i + j, wd, input[j])
}

// Get the starting element index from the wstart csr. The validity of
// wstart is checked by illegal_wstart at the start of each instruction,
// so this just returns the value.
function w_get_start_element() -> welemidx = unsigned(wstart)

// Get the ending element index from csr wl
function w_get_end_element() -> int = unsigned(wl) - 1

// Mask handling; creates a pre-masked result matrix for wstart, wl, wta/wma, and wm
// wm should be baked into wm_val from doing read_wmask
// tail masking when lmul < 1 is handled in write_wreg
// Returns two matrixs:
//   matrix1 is the result matrix with values applied to masked elements
//   matrix2 is a "mask" matrix that is true for an element if the corresponding element
//     in the result matrix should be updated by the calling instruction
val w_init_masked_result : forall 'n 'm 'p, 'n >= 0. (int('n), int('m), int('p), vector('n, bits('m)), bits('n)) -> (
    vector('n, bits('m)),
    bits('n),
  )
function w_init_masked_result(num_elem, _EEW, W_LMUL_pow, wd_val, wm_val) = {
  let start_element = w_get_start_element();
  let end_element = w_get_end_element();
  let tail_ag : w_agtype = w_get_wtype_wta();
  let mask_ag : w_agtype = w_get_wtype_wma();
  var mask : bits('n) = undefined;
  var result : vector('n, bits('m)) = undefined;

  // Determine the actual number of elements when lmul < 1
  let real_num_elem = if W_LMUL_pow >= 0 then {
      num_elem
    } else {
      num_elem / (2 ^ (0 - W_LMUL_pow))
    };
  assert(num_elem >= real_num_elem);

  foreach (i from 0 to (num_elem - 1)) {
    if i < start_element then {
      // Prestart elements defined by wstart
      result[i] = wd_val[i];
      mask[i] = 0b0
    } else {
      if i > end_element then {
        // Tail elements defined by wl
        result[i] = match tail_ag {
          W_UNDISTURBED => wd_val[i],
          W_AGNOSTIC    => if algebra_agnostic_ones then ones() else wd_val[i], // TODO: configuration support
        };
        mask[i] = 0b0
      } else {
        if i >= real_num_elem then {
          // Tail elements defined by lmul < 1
          result[i] = match tail_ag {
            W_UNDISTURBED => wd_val[i],
            W_AGNOSTIC    => if algebra_agnostic_ones then ones() else wd_val[i], // TODO: configuration support
          };
          mask[i] = 0b0
        } else {
          if wm_val[i] == 0b0 then {
            // Inactive body elements defined by wm
            result[i] = match mask_ag {
              W_UNDISTURBED => wd_val[i],
              W_AGNOSTIC    => if algebra_agnostic_ones then ones() else wd_val[i], // TODO: configuration support
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

// For instructions like matrix reduction and matrix store,
// masks on prestart, inactive and tail elements only affect the validation of source register elements
// (ws3 for store and ws2 for reduction). There's no destination register to be masked.
// In these cases, this function can be called to simply get the mask matrix for vs (without the prepared wd result matrix).
val w_init_masked_source : forall 'n 'p, 'n > 0. (int('n), int('p), bits('n)) -> bits('n)
function w_init_masked_source(num_elem, W_LMUL_pow, wm_val) = {
  let start_element = w_get_start_element();
  let end_element = w_get_end_element();
  var mask : bits('n) = undefined;

  // Determine the actual number of elements when lmul < 1
  let real_num_elem = if W_LMUL_pow >= 0 then {
      num_elem
    } else {
      num_elem / (2 ^ (0 - W_LMUL_pow))
    };
  assert(num_elem >= real_num_elem);

  foreach (i from 0 to (num_elem - 1)) {
    if i < start_element then {
      // Prestart elements defined by wstart
      mask[i] = 0b0
    } else {
      if i > end_element then {
        // Tail elements defined by wl
        mask[i] = 0b0
      } else {
        if i >= real_num_elem then {
          // Tail elements defined by lmul < 1
          mask[i] = 0b0
        } else {
          if wm_val[i] == 0b0 then {
            // Inactive body elements defined by wm
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
val w_init_masked_result_carry : forall 'n, 'n >= 0. (int('n), w_sew_bitsize, int, bits('n)) -> (bits('n), bits('n))
function w_init_masked_result_carry(num_elem, _EEW, W_LMUL_pow, wd_val) = {
  let start_element = w_get_start_element();
  let end_element = w_get_end_element();
  var mask : bits('n) = undefined;
  var result : bits('n) = undefined;

  // Determine the actual number of elements when lmul < 1
  let real_num_elem = if W_LMUL_pow >= 0 then {
      num_elem
    } else {
      num_elem / (2 ^ (0 - W_LMUL_pow))
    };
  assert(num_elem >= real_num_elem);

  foreach (i from 0 to (num_elem - 1)) {
    if i < start_element then {
      // Prestart elements defined by wstart
      result[i] = wd_val[i];
      mask[i] = 0b0
    } else {
      if i > end_element then {
        // Tail elements defined by wl
        // Mask tail is always agnostic
        result[i] = wd_val[i]; // TODO: configuration support
        mask[i] = 0b0
      } else {
        if i >= real_num_elem then {
          // Tail elements defined by lmul < 1
          // Mask tail is always agnostic
          result[i] = wd_val[i]; // TODO: configuration support
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
val w_init_masked_result_cmp : forall 'n, 'n >= 0. (int('n), w_sew_bitsize, int, bits('n), bits('n)) -> (
    bits('n),
    bits('n),
  )
function w_init_masked_result_cmp(num_elem, _EEW, W_LMUL_pow, wd_val, wm_val) = {
  let start_element = w_get_start_element();
  let end_element = w_get_end_element();
  let mask_ag : w_agtype = w_get_wtype_wma();
  var mask : bits('n) = undefined;
  var result : bits('n) = undefined;

  // Determine the actual number of elements when lmul < 1
  let real_num_elem = if W_LMUL_pow >= 0 then {
      num_elem
    } else {
      num_elem / (2 ^ (0 - W_LMUL_pow))
    };
  assert(num_elem >= real_num_elem);

  foreach (i from 0 to (num_elem - 1)) {
    if i < start_element then {
      // Prestart elements defined by wstart
      result[i] = wd_val[i];
      mask[i] = 0b0
    } else {
      if i > end_element then {
        // Tail elements defined by wl
        // Mask tail is always agnostic
        result[i] = wd_val[i]; // TODO: configuration support
        mask[i] = 0b0
      } else {
        if i >= real_num_elem then {
          // Tail elements defined by lmul < 1
          // Mask tail is always agnostic
          result[i] = wd_val[i]; // TODO: configuration support
          mask[i] = 0b0
        } else {
          if wm_val[i] == 0b0 then {
            // Inactive body elements defined by wm
            result[i] = match mask_ag {
              W_UNDISTURBED => wd_val[i],
              W_AGNOSTIC    => if algebra_agnostic_ones then ones() else wd_val[i], // TODO: configuration support
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

// For matrix load/store segment instructions:
// Read multiple register groups and concatenate them in parallel
// The whole segments with the same element index are combined together
val w_read_wreg_seg : forall 'n 'm 'p 'q, 'n >= 0 & w_is_sew_bitsize('m) & w_nfields_range('q). (
    int('n),
    int('m),
    int('p),
    int('q),
    wregidx,
  ) -> vector('n, bits('q * 'm))
function w_read_wreg_seg(num_elem, SEW, W_LMUL_pow, nf, wrid) = {
  let LMUL_reg : int = if W_LMUL_pow <= 0 then {
      1
    } else {
      2 ^ W_LMUL_pow
    };
  var wreg_list : vector('q, vector('n, bits('m))) = vector_init(vector_init(zeros()));
  var result : vector('n, bits('q * 'm)) = vector_init(zeros());
  foreach (j from 0 to (nf - 1)) {
    wreg_list[j] = w_read_wreg(num_elem, SEW, W_LMUL_pow, w_wregidx_offset(wrid, to_bits_unsafe(5, j * LMUL_reg)))
  };
  foreach (i from 0 to (num_elem - 1)) {
    result[i] = zeros(sizeof('q) * sizeof('m));
    foreach (j from 0 to (nf - 1)) {
      result[i] = result[i] | (zero_extend(wreg_list[j][i]) << (j * sizeof('m)))
    }
  };
  result
}

// Shift amounts
val w_get_shift_amount : forall 'n, 0 <= 'n. (bits('n), w_sew_bitsize) -> nat
function w_get_shift_amount(bit_val, SEW) = {
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
val w_get_fixed_rounding_incr : forall ('m 'n : Int), 'm > 0 & 'n >= 0. (bits('m), int('n)) -> bits(1)
function w_get_fixed_rounding_incr(vec_elem, shift_amount) = {
  algebra_rounding_incr(vec_elem, shift_amount, wcsr[wxrm])
}

// Fixed point unsigned saturation
val w_unsigned_saturation : forall ('m 'n : Int), 'n >= 'm > 1. (int('m), bits('n)) -> bits('m)
function w_unsigned_saturation(len, elem) = {
  if unsigned(elem) > unsigned(ones(sizeof('m))) then {
    w_write_wxsat(0b1);
    ones(sizeof('m))
  } else {
    w_write_wxsat(wcsr[wxsat]);
    elem[sizeof('m) - 1 .. 0]
  }
}

// Fixed point signed saturation
val w_signed_saturation : forall ('m 'n : Int), 'n >= 'm > 1. (int('m), bits('n)) -> bits('m)
function w_signed_saturation(len, elem) = {
  if signed(elem) > signed(0b0 @ ones(sizeof('m) - 1)) then {
    w_write_wxsat(0b1);
    0b0 @ ones(sizeof('m) - 1)
  } else {
    if signed(elem) < signed(0b1 @ zeros(sizeof('m) - 1)) then {
      w_write_wxsat(0b1);
      0b1 @ zeros(sizeof('m) - 1)
    } else {
      w_write_wxsat(wcsr[wxsat]);
      elem[sizeof('m) - 1 .. 0]
    }
  }
}

// The parameter m is implicit to help proof the proof assistant backends infer its value.
val w_wrev8 : forall 'n 'm, 'n >= 0 & 'm >= 0. (implicit('m), vector('n, bits('m * 8))) -> vector('n, bits('m * 8))
function w_wrev8(_m, input) = {
  var output : vector('n, bits('m * 8)) = input;
  foreach (i from 0 to (sizeof('n) - 1)) {
    output[i] = rev8(input[i])
  };
  output
}
