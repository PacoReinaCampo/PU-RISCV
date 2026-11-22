// =======================================================================================
// This Sail RISC-Y architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

function clause currentlyEnabled(Ext_Y) = hartSupports(Ext_Y) & misa[Y] == 0b1

let y_max_index_eew_exp : nat = config extensions.Y.max_index_eew_exp

// Get the total number of elements in a register group (not considering `yl`).
// For fractional groups (negative LMUL_pow) we return the number of elements
// in a single register. The fractional aspect is handled by `init_masked_result()`.
//
// The minimum number of elements is 1.
// The maximum is YLMAX = LMUL*YLEN/SEW. YLMAX can never be more than ylen
// because the minimum SEW is 8 and the maximum LMUL is 8. This is also
// true because all elements must be able to fit into a single register
// at 1-bit per element for masks.
function y_get_num_elem(Y_LMUL_pow : Y_LMUL_pow, SEW : y_sew_bitsize) -> range(1, ylen) = {
  assert(ylen >= SEW);
  (2 ^ max(0, Y_LMUL_pow)) * ylen / SEW
}

// Read a single element of a tensor register group (starting at yrid).
val y_read_single_element : forall 'sew, y_is_sew_bitsize('sew). (int('sew), nat, yregidx) -> bits('sew)
function y_read_single_element(EEW, index, yrid) = {
  assert(EEW <= ylen);
  static_assert(ylen % EEW == 0);

  // Number of EEW-bit elements per tensor register.
  let elem_per_reg = ylen / EEW;

  // Register in group. Max LMUL is 8, so this should be in [0, 8).
  let reg_in_group = index / elem_per_reg;
  assert(reg_in_group < 8);

  // Get the actual register in the group that we need to write, and the index into it.
  let yrid = yrid + reg_in_group;
  let index = index % elem_per_reg;

  // Bit offset in register.
  let offset = index * EEW;

  Y(yrid)[offset + EEW - 1 .. offset]
}

// The general yreg reading operation with num_elem as max(YLMAX,YLEN/SEW)).
val y_read_yreg : forall 'n 'sew 'p, 'n >= 0 & y_is_sew_bitsize('sew). (int('n), int('sew), int('p), yregidx) -> vector(
    'n,
    bits('sew),
  )
function y_read_yreg(num_elem, SEW, Y_LMUL_pow, yrid) = {
  let yrid_val = unsigned(y_yregidx_bits(yrid));
  let LMUL_pow_reg = if Y_LMUL_pow < 0 then { 0 } else { Y_LMUL_pow };
  let LMUL = 2 ^ LMUL_pow_reg;
  let yrid_end = yrid_val + LMUL;
  assert(
    yrid_end <= 32,
     "Invalid register group: group "
    ^ dec_str(yrid_val)
    ^ " ends at "
    ^ dec_str(yrid_end)
    ^ " and overflows the largest register number (32)."
  );
  assert(
    yrid_val % LMUL == 0,
    "Invalid register group: group " ^ dec_str(yrid_val) ^ " is not a multiple of its EMUL " ^ dec_str(LMUL) ^ "."
  );

  var result : vector('n, bits('sew)) = vector_init(zeros());

  foreach (i from 0 to (num_elem - 1)) {
    result[i] = y_read_single_element(SEW, i, yrid)
  };

  result
}

// Write a single element of a tensor register group (starting at yrid),
// leaving all other elements unchanged.
val y_write_single_element : forall 'sew, y_is_sew_bitsize('sew). (int('sew), nat, yregidx, bits('sew)) -> unit
function y_write_single_element(EEW, index, yrid, value) = {
  assert(EEW <= ylen);
  static_assert(ylen % EEW == 0);

  // Number of EEW-bit elements per tensor register.
  let elem_per_reg = ylen / EEW;

  // Register in group. Max LMUL is 8, so this should be in [0, 8).
  let reg_in_group = index / elem_per_reg;
  assert(reg_in_group < 8);

  // Get the actual register in the group that we need to write, and the index into it.
  let yrid = yrid + reg_in_group;
  let index = index % elem_per_reg;

  // Bit offset in register.
  let offset = index * EEW;

  Y(yrid) = [Y(yrid) with (offset + EEW - 1) .. offset = value]
}

// Write a complete tensor register group.
//
// num_elem: Number of elements in the entire group (ignoring
//           fractional lmul and yl).
// SEW:      Element size in bits.
// LMUL_pow: LMUL exponent; size of the register group.
//           Negative values indicate fractions of a single register, but
//           we still require the full register's worth of elements.
// yrid:     Index of the first register in the group.
// data:     Data of each element.
//
val y_write_yreg : forall 'n 'sew, 'n >= 0 & y_is_sew_bitsize('sew). (
    int('n),
    int('sew),
    Y_LMUL_pow,
    yregidx,
    vector('n, bits('sew)),
  ) -> unit
function y_write_yreg(num_elem, SEW, Y_LMUL_pow, yrid, vec) = {
  // Number of registers in the group (treating fractional lmul as 0).
  let group_size = 2 ^ max(Y_LMUL_pow, 0);

  assert(SEW <= ylen);
  static_assert(ylen % SEW == 0);

  // Number of SEW-bit elements per tensor register.
  let elem_per_reg = ylen / SEW;

  // Normally num_elem == group_size * elem_per_reg, however
  // in the specific case of fractional lmul with widening instructions
  // get_num_elem() returns ylen / SEW, but SEW is doubled before
  // feeding into this instruction, so elem_per_reg is half the
  // pre-widening value. Since `group_size` will be unchanged
  // (because max(LMUL_pow, 0) is still 0), we will end up
  // with num_elem == group_size * (elem_per_reg * 2).
  //
  // In that case the second half of the `vec` array will be ignored.
  assert(num_elem == group_size * elem_per_reg | num_elem == 2 * group_size * elem_per_reg);

  foreach (reg_in_group from 0 to (group_size - 1)) {
    var reg_value : ylenbits = zeros();
    foreach (i_elem from 0 to (elem_per_reg - 1)) {
      reg_value[(i_elem * SEW) + SEW - 1 .. i_elem * SEW] = vec[reg_in_group * elem_per_reg + i_elem]
    };
    Y(yrid + reg_in_group) = reg_value
  }
}

// Mask register reading operation with num_elem as max(YLMAX,ylen/SEW)).
val y_read_ymask : forall 'n, 0 < 'n <= ylen. (int('n), bits(1), yregidx) -> bits('n)
function y_read_ymask(num_elem, ym, yrid) =
  if ym == 0b1 then {
    ones()
  } else {
    ones(sizeof('n) - num_elem) @ Y(yrid)[num_elem - 1 .. 0]
  }

// This is a special version of read_ymask for carry/borrow instructions, where ym=1 means no carry.
val y_read_ymask_carry : forall 'n, 0 < 'n <= ylen. (int('n), bits(1), yregidx) -> bits('n)
function y_read_ymask_carry(num_elem, ym, yrid) =
  if ym == 0b1 then {
    zeros()
  } else {
    zeros(sizeof('n) - num_elem) @ Y(yrid)[num_elem - 1 .. 0]
  }

// Mask register writing operation with num_elem as max(YLMAX,ylen/SEW))
val y_write_ymask : forall 'n, 'n > 0. (int('n), yregidx, bits('n)) -> unit
function y_write_ymask(num_elem, yrid, y) = {
  // TODO: This should be part of the type signature.
  assert(0 < num_elem & num_elem <= ylen);

  // Mask tail is always agnostic. Currently we always
  // leave it undisturbed.
  // TODO: Configuration support for ones/undisturbed.
  Y(yrid) = [Y(yrid) with (num_elem - 1) .. 0 = y]
}

let y_columns : range(1, 65536) = config extensions.Y.columns
let y_depth : range(1, 65536) = config extensions.Y.depth

// Row-major coordinate view: p = (i * COLS + j) * DEPTH + k.
function y_flat_index(i : nat, j : nat, k : nat) -> nat = {
  assert(j < y_columns & k < y_depth);
  (i * y_columns + j) * y_depth + k
}

val y_read_element : forall 'sew, y_is_sew_bitsize('sew). (int('sew), nat, nat, nat, yregidx) -> bits('sew)
function y_read_element(EEW, i, j, k, rid) =
  y_read_single_element(EEW, y_flat_index(i, j, k), rid)

val y_write_element : forall 'sew, y_is_sew_bitsize('sew). (int('sew), nat, nat, nat, yregidx, bits('sew)) -> unit
function y_write_element(EEW, i, j, k, rid, value) =
  y_write_single_element(EEW, y_flat_index(i, j, k), rid, value)

// Explicit coordinate views. Padding belongs to no architectural element.
val y_shape_vector : forall ('a : Type) 'n 'c 'd, 'n > 0 & 'c > 0 & 'd > 0. (vector('n, 'a), int('c), int('d)) -> vector(
    div('n + 'c * 'd - 1, 'c * 'd),
    vector('c, vector('d, 'a)),
  )
function y_shape_vector(input, cols, depth) = {
  var output : vector(div('n + 'c * 'd - 1, 'c * 'd), vector('c, vector('d, 'a))) = vector_init(
    vector_init(vector_init(input[0])),
  );
  foreach (p from 0 to (sizeof('n) - 1)) {
    let i = p / (cols * depth);
    let j = (p / depth) % cols;
    let k = p % depth;
    assert(i < (sizeof('n) + cols * depth - 1) / (cols * depth) & j < cols & k < depth);
    output[i][j][k] = input[p]
  };
  output
}

// Native bit rows avoid generic vector(bit) specialisation in the C++ backend.
val y_shape_bits : forall 'n 'c 'd, 'n > 0 & 'c > 0 & 'd > 0. (bits('n), int('c), int('d)) -> vector(
    div('n + 'c * 'd - 1, 'c * 'd),
    vector('c, bits('d)),
  )
function y_shape_bits(input, cols, depth) = {
  var output : vector(div('n + 'c * 'd - 1, 'c * 'd), vector('c, bits('d))) = vector_init(vector_init(zeros()));
  foreach (p from 0 to (sizeof('n) - 1)) {
    let i = p / (cols * depth);
    let j = (p / depth) % cols;
    let k = p % depth;
    assert(i < (sizeof('n) + cols * depth - 1) / (cols * depth) & j < cols & k < depth);
    output[i][j][k] = input[p]
  };
  output
}
overload y_shape = { y_shape_vector, y_shape_bits }
val y_unshape_vector : forall ('a : Type) 'n 'c 'd, 'n > 0 & 'c > 0 & 'd > 0. (
    int('n),
    vector(div('n + 'c * 'd - 1, 'c * 'd), vector('c, vector('d, 'a))),
    int('c),
    int('d),
  ) -> vector('n, 'a)
function y_unshape_vector(n, input, cols, depth) = {
  var output : vector('n, 'a) = vector_init(input[0][0][0]);
  foreach (p from 0 to (n - 1)) {
    let i = p / (cols * depth);
    let j = (p / depth) % cols;
    let k = p % depth;
    assert(i < (sizeof('n) + cols * depth - 1) / (cols * depth) & j < cols & k < depth);
    output[p] = input[i][j][k]
  };
  output
}
val y_unshape_bits : forall 'n 'c 'd, 'n > 0 & 'c > 0 & 'd > 0. (
    int('n),
    vector(div('n + 'c * 'd - 1, 'c * 'd), vector('c, bits('d))),
    int('c),
    int('d),
  ) -> bits('n)
function y_unshape_bits(n, input, cols, depth) = {
  var output : bits('n) = zeros();
  foreach (p from 0 to (n - 1)) {
    let i = p / (cols * depth);
    let j = (p / depth) % cols;
    let k = p % depth;
    assert(i < (sizeof('n) + cols * depth - 1) / (cols * depth) & j < cols & k < depth);
    output[p] = input[i][j][k]
  };
  output
}
