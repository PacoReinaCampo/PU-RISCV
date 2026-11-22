// =======================================================================================
// This Sail RISC-W architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

function clause currentlyEnabled(Ext_W) = hartSupports(Ext_W) & misa[W] == 0b1

let w_max_index_eew_exp : nat = config extensions.W.max_index_eew_exp

// Get the total number of elements in a register group (not considering `wl`).
// For fractional groups (negative LMUL_pow) we return the number of elements
// in a single register. The fractional aspect is handled by `init_masked_result()`.
//
// The minimum number of elements is 1.
// The maximum is WLMAX = LMUL*WLEN/SEW. WLMAX can never be more than wlen
// because the minimum SEW is 8 and the maximum LMUL is 8. This is also
// true because all elements must be able to fit into a single register
// at 1-bit per element for masks.
function w_get_num_elem(W_LMUL_pow : W_LMUL_pow, SEW : w_sew_bitsize) -> range(1, wlen) = {
  assert(wlen >= SEW);
  (2 ^ max(0, W_LMUL_pow)) * wlen / SEW
}

// Read a single element of a matrix register group (starting at wrid).
val w_read_single_element : forall 'sew, w_is_sew_bitsize('sew). (int('sew), nat, wregidx) -> bits('sew)
function w_read_single_element(EEW, index, wrid) = {
  assert(EEW <= wlen);
  static_assert(wlen % EEW == 0);

  // Number of EEW-bit elements per matrix register.
  let elem_per_reg = wlen / EEW;

  // Register in group. Max LMUL is 8, so this should be in [0, 8).
  let reg_in_group = index / elem_per_reg;
  assert(reg_in_group < 8);

  // Get the actual register in the group that we need to write, and the index into it.
  let wrid = wrid + reg_in_group;
  let index = index % elem_per_reg;

  // Bit offset in register.
  let offset = index * EEW;

  W(wrid)[offset + EEW - 1 .. offset]
}

// The general wreg reading operation with num_elem as max(WLMAX,WLEN/SEW)).
val w_read_wreg : forall 'n 'sew 'p, 'n >= 0 & w_is_sew_bitsize('sew). (int('n), int('sew), int('p), wregidx) -> vector(
    'n,
    bits('sew),
  )
function w_read_wreg(num_elem, SEW, W_LMUL_pow, wrid) = {
  let wrid_val = unsigned(w_wregidx_bits(wrid));
  let LMUL_pow_reg = if W_LMUL_pow < 0 then { 0 } else { W_LMUL_pow };
  let LMUL = 2 ^ LMUL_pow_reg;
  let wrid_end = wrid_val + LMUL;
  assert(
    wrid_end <= 32,
     "Invalid register group: group "
    ^ dec_str(wrid_val)
    ^ " ends at "
    ^ dec_str(wrid_end)
    ^ " and overflows the largest register number (32)."
  );
  assert(
    wrid_val % LMUL == 0,
    "Invalid register group: group " ^ dec_str(wrid_val) ^ " is not a multiple of its EMUL " ^ dec_str(LMUL) ^ "."
  );

  var result : vector('n, bits('sew)) = vector_init(zeros());

  foreach (i from 0 to (num_elem - 1)) {
    result[i] = w_read_single_element(SEW, i, wrid)
  };

  result
}

// Write a single element of a matrix register group (starting at wrid),
// leaving all other elements unchanged.
val w_write_single_element : forall 'sew, w_is_sew_bitsize('sew). (int('sew), nat, wregidx, bits('sew)) -> unit
function w_write_single_element(EEW, index, wrid, value) = {
  assert(EEW <= wlen);
  static_assert(wlen % EEW == 0);

  // Number of EEW-bit elements per matrix register.
  let elem_per_reg = wlen / EEW;

  // Register in group. Max LMUL is 8, so this should be in [0, 8).
  let reg_in_group = index / elem_per_reg;
  assert(reg_in_group < 8);

  // Get the actual register in the group that we need to write, and the index into it.
  let wrid = wrid + reg_in_group;
  let index = index % elem_per_reg;

  // Bit offset in register.
  let offset = index * EEW;

  W(wrid) = [W(wrid) with (offset + EEW - 1) .. offset = value]
}

// Write a complete matrix register group.
//
// num_elem: Number of elements in the entire group (ignoring
//           fractional lmul and wl).
// SEW:      Element size in bits.
// LMUL_pow: LMUL exponent; size of the register group.
//           Negative values indicate fractions of a single register, but
//           we still require the full register's worth of elements.
// wrid:     Index of the first register in the group.
// data:     Data of each element.
//
val w_write_wreg : forall 'n 'sew, 'n >= 0 & w_is_sew_bitsize('sew). (
    int('n),
    int('sew),
    W_LMUL_pow,
    wregidx,
    vector('n, bits('sew)),
  ) -> unit
function w_write_wreg(num_elem, SEW, W_LMUL_pow, wrid, vec) = {
  // Number of registers in the group (treating fractional lmul as 0).
  let group_size = 2 ^ max(W_LMUL_pow, 0);

  assert(SEW <= wlen);
  static_assert(wlen % SEW == 0);

  // Number of SEW-bit elements per matrix register.
  let elem_per_reg = wlen / SEW;

  // Normally num_elem == group_size * elem_per_reg, however
  // in the specific case of fractional lmul with widening instructions
  // get_num_elem() returns wlen / SEW, but SEW is doubled before
  // feeding into this instruction, so elem_per_reg is half the
  // pre-widening value. Since `group_size` will be unchanged
  // (because max(LMUL_pow, 0) is still 0), we will end up
  // with num_elem == group_size * (elem_per_reg * 2).
  //
  // In that case the second half of the `vec` array will be ignored.
  assert(num_elem == group_size * elem_per_reg | num_elem == 2 * group_size * elem_per_reg);

  foreach (reg_in_group from 0 to (group_size - 1)) {
    var reg_value : wlenbits = zeros();
    foreach (i_elem from 0 to (elem_per_reg - 1)) {
      reg_value[(i_elem * SEW) + SEW - 1 .. i_elem * SEW] = vec[reg_in_group * elem_per_reg + i_elem]
    };
    W(wrid + reg_in_group) = reg_value
  }
}

// Mask register reading operation with num_elem as max(WLMAX,wlen/SEW)).
val w_read_wmask : forall 'n, 0 < 'n <= wlen. (int('n), bits(1), wregidx) -> bits('n)
function w_read_wmask(num_elem, wm, wrid) =
  if wm == 0b1 then {
    ones()
  } else {
    ones(sizeof('n) - num_elem) @ W(wrid)[num_elem - 1 .. 0]
  }

// This is a special version of read_wmask for carry/borrow instructions, where wm=1 means no carry.
val w_read_wmask_carry : forall 'n, 0 < 'n <= wlen. (int('n), bits(1), wregidx) -> bits('n)
function w_read_wmask_carry(num_elem, wm, wrid) =
  if wm == 0b1 then {
    zeros()
  } else {
    zeros(sizeof('n) - num_elem) @ W(wrid)[num_elem - 1 .. 0]
  }

// Mask register writing operation with num_elem as max(WLMAX,wlen/SEW))
val w_write_wmask : forall 'n, 'n > 0. (int('n), wregidx, bits('n)) -> unit
function w_write_wmask(num_elem, wrid, w) = {
  // TODO: This should be part of the type signature.
  assert(0 < num_elem & num_elem <= wlen);

  // Mask tail is always agnostic. Currently we always
  // leave it undisturbed.
  // TODO: Configuration support for ones/undisturbed.
  W(wrid) = [W(wrid) with (num_elem - 1) .. 0 = w]
}

let w_columns : range(1, 65536) = config extensions.W.columns

// Row-major coordinate view: p = i * COLS + j.
function w_flat_index(i : nat, j : nat) -> nat = {
  assert(j < w_columns);
  i * w_columns + j
}

val w_read_element : forall 'sew, w_is_sew_bitsize('sew). (int('sew), nat, nat, wregidx) -> bits('sew)
function w_read_element(EEW, i, j, rid) =
  w_read_single_element(EEW, w_flat_index(i, j), rid)

val w_write_element : forall 'sew, w_is_sew_bitsize('sew). (int('sew), nat, nat, wregidx, bits('sew)) -> unit
function w_write_element(EEW, i, j, rid, value) =
  w_write_single_element(EEW, w_flat_index(i, j), rid, value)

// Explicit coordinate views. Padding belongs to no architectural element.
val w_shape_vector : forall ('a : Type) 'n 'c, 'n > 0 & 'c > 0. (vector('n, 'a), int('c)) -> vector(
    div('n + 'c - 1, 'c),
    vector('c, 'a),
  )
function w_shape_vector(input, cols) = {
  var output : vector(div('n + 'c - 1, 'c), vector('c, 'a)) = vector_init(vector_init(input[0]));
  foreach (p from 0 to (sizeof('n) - 1)) {
    let i = p / cols;
    let j = p % cols;
    assert(i < (sizeof('n) + cols - 1) / cols & j < cols);
    output[i][j] = input[p]
  };
  output
}

// Native bit rows avoid generic vector(bit) specialisation in the C++ backend.
val w_shape_bits : forall 'n 'c, 'n > 0 & 'c > 0. (bits('n), int('c)) -> vector(div('n + 'c - 1, 'c), bits('c))
function w_shape_bits(input, cols) = {
  var output : vector(div('n + 'c - 1, 'c), bits('c)) = vector_init(zeros());
  foreach (p from 0 to (sizeof('n) - 1)) {
    let i = p / cols;
    let j = p % cols;
    assert(i < (sizeof('n) + cols - 1) / cols & j < cols);
    output[i][j] = input[p]
  };
  output
}
overload w_shape = { w_shape_vector, w_shape_bits }
val w_unshape_vector : forall ('a : Type) 'n 'c, 'n > 0 & 'c > 0. (
    int('n),
    vector(div('n + 'c - 1, 'c), vector('c, 'a)),
    int('c),
  ) -> vector('n, 'a)
function w_unshape_vector(n, input, cols) = {
  var output : vector('n, 'a) = vector_init(input[0][0]);
  foreach (p from 0 to (n - 1)) {
    let i = p / cols;
    let j = p % cols;
    assert(i < (sizeof('n) + cols - 1) / cols & j < cols);
    output[p] = input[i][j]
  };
  output
}
val w_unshape_bits : forall 'n 'c, 'n > 0 & 'c > 0. (int('n), vector(div('n + 'c - 1, 'c), bits('c)), int('c)) -> bits(
    'n,
  )
function w_unshape_bits(n, input, cols) = {
  var output : bits('n) = zeros();
  foreach (p from 0 to (n - 1)) {
    let i = p / cols;
    let j = p % cols;
    assert(i < (sizeof('n) + cols - 1) / cols & j < cols);
    output[p] = input[i][j]
  };
  output
}
