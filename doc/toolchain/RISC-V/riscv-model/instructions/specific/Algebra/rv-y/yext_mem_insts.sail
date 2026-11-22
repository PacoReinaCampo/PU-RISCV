// =======================================================================================
// This Sail RISC-Y architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

// ******************************************************************************
// This file implements part of the tensor extension.
// Chapter 7: Tensor Loads and Stores
// ******************************************************************************

mapping y_ylewidth_bitsnumberstr : y_ylewidth <-> string = {
 Y_YLE8      <-> "8",
 Y_YLE16     <-> "16",
 Y_YLE32     <-> "32",
 Y_YLE64     <-> "64"
}

mapping y_encdec_ylewidth : y_ylewidth <-> bits(3) = {
 Y_YLE8      <-> 0b000,
 Y_YLE16     <-> 0b101,
 Y_YLE32     <-> 0b110,
 Y_YLE64     <-> 0b111
}

mapping y_ylewidth_pow : y_ylewidth <-> {3, 4, 5, 6} = {
 Y_YLE8      <-> 3,
 Y_YLE16     <-> 4,
 Y_YLE32     <-> 5,
 Y_YLE64     <-> 6
}

mapping y_encdec_indexed_mop : y_indexed_mop <-> bits(2) = {
 Y_INDEXED_UNORDERED <-> 0b01,
 Y_INDEXED_ORDERED   <-> 0b11,
}

mapping y_indexed_mop_mnemonic : y_indexed_mop <-> string = {
 Y_INDEXED_UNORDERED <-> "u",
 Y_INDEXED_ORDERED   <-> "o",
}

// ******************* Tensor Load Unit-Stride Normal & Segment (mop=0b00, lumop=0b00000) *********************
union clause instruction = Y_YLSEGTYPE : (y_nfields, bits(1), regidx, y_ylewidth, yregidx)

mapping clause encdec = Y_YLSEGTYPE(nf, ym, rs1, width, yd)
 <-> y_encdec_nfields(nf) @ 0b0 @ 0b00 @ ym @ 0b00000 @ encdec_reg(rs1) @ y_encdec_ylewidth(width) @ y_encdec_yreg(yd) @ 0b0000111
 when ((currentlyEnabled(Ext_Y) & algebra_memory_bank == AlgebraMemory_Y) & y_ylewidth_pow(width) <= 5)
  | (((currentlyEnabled(Ext_Y) & algebra_memory_bank == AlgebraMemory_Y) & yelen >= 64) & y_ylewidth_pow(width) <= 6)

function clause execute(Y_YLSEGTYPE(nf, ym, rs1, width, yd)) = {
  let EEW_pow = y_ylewidth_pow(width);
  let load_width_bytes = 2 ^ (EEW_pow - 3);
  let EEW = 2 ^ EEW_pow;
  let Y_SEW_pow = y_get_sew_pow();
  let Y_LMUL_pow = y_get_lmul_pow();
  let EMUL_pow = EEW_pow - Y_SEW_pow + Y_LMUL_pow;

  assert(-3 <= EMUL_pow & EMUL_pow <= 3);

  let num_elem = y_get_num_elem(EMUL_pow, EEW); // # of element of each register group
  assert(num_elem > 0);

  if   y_illegal_ystart(Y_YSTART_LOAD_STORE, num_elem, EMUL_pow)
   | y_illegal_load(yd, ym, nf, EEW, EMUL_pow)
   | not(y_valid_reg_group(yd, EMUL_pow)) then {
    return Illegal_Instruction()
  };

  let EMUL_reg = 2 ^ max(EMUL_pow, 0);
  let ym_val = y_read_ymask(num_elem, ym, y_zyreg);
  let yd_seg = y_read_yreg_seg(num_elem, load_width_bytes * 8, EMUL_pow, nf, yd);

  let (m as 'm) = nf * load_width_bytes * 8;
  let (n as 'n) = num_elem;
  let (result, mask) : (vector('n, bits('m)), bits('n)) = y_init_masked_result(
    num_elem,
    sizeof('m),
    EMUL_pow,
    yd_seg,
    ym_val,
  );

  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    let result_view = y_shape(result, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        // active segments
        y_set_ystart(to_bits(p));
        foreach (field from 0 to (nf - 1)) {
          let elem_offset = (p * nf + field) * load_width_bytes;
          match vmem_read(
            rs1,
            to_bits_unsafe(xlen, elem_offset),
            load_width_bytes,
            Load(Vector),
            false,
            false,
            false,
          ) {
            Ok(elem) => y_write_element(
              load_width_bytes * 8,
              i,
              j,
              k,
              y_yregidx_offset(yd, to_bits_unsafe(5, field * EMUL_reg)),
              elem,
            ),
            Err(e)   => return e,
          }
        }
      } else {
        // prestart, masked or tail segments
        foreach (field from 0 to (nf - 1)) {
          let skipped_elem = (result_view[i][j][k] >> (field * load_width_bytes * 8))[
              load_width_bytes * 8 - 1 .. 0
            ];
          y_write_element(
            load_width_bytes * 8,
            i,
            j,
            k,
            y_yregidx_offset(yd, to_bits_unsafe(5, field * EMUL_reg)),
            skipped_elem,
          )
        }
      }
    }
  };

  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = Y_YLSEGTYPE(nf, ym, rs1, width, yd)
 <-> "yl" ^ y_nfields_string(nf) ^ "e" ^ y_ylewidth_bitsnumberstr(width) ^ ".y" ^ spc() ^ y_yreg_name(yd) ^ sep() ^ "(" ^ reg_name(rs1) ^ ")" ^ y_maybe_ymask(ym)

// *********** Tensor Load Unit-Stride Normal & Segment Fault-Only-First (mop=0b00, lumop=0b10000) ************
union clause instruction = Y_YLSEGFFTYPE : (y_nfields, bits(1), regidx, y_ylewidth, yregidx)

mapping clause encdec = Y_YLSEGFFTYPE(nf, ym, rs1, width, yd)
 <-> y_encdec_nfields(nf) @ 0b0 @ 0b00 @ ym @ 0b10000 @ encdec_reg(rs1) @ y_encdec_ylewidth(width) @ y_encdec_yreg(yd) @ 0b0000111
 when ((currentlyEnabled(Ext_Y) & algebra_memory_bank == AlgebraMemory_Y) & y_ylewidth_pow(width) <= 5)
  | (((currentlyEnabled(Ext_Y) & algebra_memory_bank == AlgebraMemory_Y) & yelen >= 64) & y_ylewidth_pow(width) <= 6)

function clause execute(Y_YLSEGFFTYPE(nf, ym, rs1, width, yd)) = {
  let EEW_pow = y_ylewidth_pow(width);
  let load_width_bytes = 2 ^ (EEW_pow - 3);
  let EEW = 2 ^ EEW_pow;
  let Y_SEW_pow = y_get_sew_pow();
  let Y_LMUL_pow = y_get_lmul_pow();
  let EMUL_pow = EEW_pow - Y_SEW_pow + Y_LMUL_pow;

  assert(-3 <= EMUL_pow & EMUL_pow <= 3);

  let num_elem = y_get_num_elem(EMUL_pow, EEW);
  assert(num_elem > 0);

  if   y_illegal_ystart(Y_YSTART_LOAD_STORE, num_elem, EMUL_pow)
   | y_illegal_load(yd, ym, nf, EEW, EMUL_pow)
   | not(y_valid_reg_group(yd, EMUL_pow)) then {
    return Illegal_Instruction()
  };

  let EMUL_reg = 2 ^ max(EMUL_pow, 0);
  let ym_val = y_read_ymask(num_elem, ym, y_zyreg);
  let yd_seg = y_read_yreg_seg(num_elem, load_width_bytes * 8, EMUL_pow, nf, yd);
  let tail_ag = y_get_ytype_yta();

  let (m as 'm) = nf * load_width_bytes * 8;
  let (n as 'n) = num_elem;
  let (result, mask) : (vector('n, bits('m)), bits('n)) = y_init_masked_result(
    num_elem,
    nf * load_width_bytes * 8,
    EMUL_pow,
    yd_seg,
    ym_val,
  );

  var trimmed : bool = false;
  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    let result_view = y_shape(result, y_columns, y_depth);
    let yd_seg_view = y_shape(yd_seg, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(yd_seg_view));
      assert(j < y_columns & k < y_depth);

      if not(trimmed) then {
        if mask_view[i][j][k] == 0b1 then {
          // active segments
          foreach (field from 0 to (nf - 1)) {
            let elem_offset = (p * nf + field) * load_width_bytes;
            match vmem_read(
              rs1,
              to_bits_unsafe(xlen, elem_offset),
              load_width_bytes,
              Load(Vector),
              false,
              false,
              false,
            ) {
              Ok(elem) => y_write_element(
                load_width_bytes * 8,
                i,
                j,
                k,
                y_yregidx_offset(yd, to_bits_unsafe(5, field * EMUL_reg)),
                elem,
              ),
              // NOTE: A debug trigger on an element after the first is taken instead
              // of trimming yl, as recommended by a non-normative note in the spec
              // (otherwise the event might be lost). This may need a config option
              // in the future. If yl is trimmed instead, the trigger's match_info
              // must be cleared too, otherwise the next step still sees it.
              Err(PendingTrigger(pti)) => {
                y_set_ystart(to_bits(p));
                return PendingTrigger(pti)
              },
              Err(e) => if p == 0 then {
                return e
              } else {
                yl = to_bits(p);
                csr_write_callback("yl", zero_extend(yl));
                trimmed = true
              },
            }
          }
        } else {
          // prestart, masked or tail segments
          foreach (field from 0 to (nf - 1)) {
            let skipped_elem = (result_view[i][j][k] >> (field * load_width_bytes * 8))[
                load_width_bytes * 8 - 1 .. 0
              ];
            y_write_element(
              load_width_bytes * 8,
              i,
              j,
              k,
              y_yregidx_offset(yd, to_bits_unsafe(5, field * EMUL_reg)),
              skipped_elem,
            )
          }
        }
      } else {
        // if yl is trimmed, elements past the new yl are treated as tail elements
        if tail_ag == Y_AGNOSTIC then {
          foreach (field from 0 to (nf - 1)) {
            let skipped_elem = (yd_seg_view[i][j][k] >> (field * load_width_bytes * 8))[
                load_width_bytes * 8 - 1 .. 0
              ];
            y_write_element(
              load_width_bytes * 8,
              i,
              j,
              k,
              y_yregidx_offset(yd, to_bits_unsafe(5, field * EMUL_reg)),
              skipped_elem,
            )
          }
          // TODO: configuration support for agnostic behavior
        }
      }
    }
  };

  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = Y_YLSEGFFTYPE(nf, ym, rs1, width, yd)
 <-> "yl" ^ y_nfields_string(nf) ^ "e" ^ y_ylewidth_bitsnumberstr(width) ^ "ff.y" ^ spc() ^ y_yreg_name(yd) ^ sep() ^ "(" ^ reg_name(rs1) ^ ")" ^ y_maybe_ymask(ym)

// ******************* Tensor Store Unit-Stride Normal & Segment (mop=0b00, sumop=0b00000) ********************
union clause instruction = Y_YSSEGTYPE : (y_nfields, bits(1), regidx, y_ylewidth, yregidx)

mapping clause encdec = Y_YSSEGTYPE(nf, ym, rs1, width, ys3)
 <-> y_encdec_nfields(nf) @ 0b0 @ 0b00 @ ym @ 0b00000 @ encdec_reg(rs1) @ y_encdec_ylewidth(width) @ y_encdec_yreg(ys3) @ 0b0100111
 when ((currentlyEnabled(Ext_Y) & algebra_memory_bank == AlgebraMemory_Y) & y_ylewidth_pow(width) <= 5)
  | (((currentlyEnabled(Ext_Y) & algebra_memory_bank == AlgebraMemory_Y) & yelen >= 64) & y_ylewidth_pow(width) <= 6)

function clause execute(Y_YSSEGTYPE(nf, ym, rs1, width, ys3)) = {
  let EEW_pow = y_ylewidth_pow(width);
  let load_width_bytes = 2 ^ (EEW_pow - 3);
  let EEW = 2 ^ EEW_pow;
  let Y_SEW_pow = y_get_sew_pow();
  let Y_LMUL_pow = y_get_lmul_pow();
  let EMUL_pow = EEW_pow - Y_SEW_pow + Y_LMUL_pow;

  assert(-3 <= EMUL_pow & EMUL_pow <= 3);

  let num_elem = y_get_num_elem(EMUL_pow, EEW);
  assert(num_elem > 0);

  if   y_illegal_ystart(Y_YSTART_LOAD_STORE, num_elem, EMUL_pow)
   | y_illegal_store(ys3, nf, EEW, EMUL_pow)
   | not(y_valid_reg_group(ys3, EMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys3, EEW)) then {
    return Illegal_Instruction()
  };

  let EMUL_reg = 2 ^ max(EMUL_pow, 0);
  let ym_val = y_read_ymask(num_elem, ym, y_zyreg);
  let ys3_seg = y_read_yreg_seg(num_elem, load_width_bytes * 8, EMUL_pow, nf, ys3);

  let (n as 'n) = num_elem;
  let mask : bits('n) = y_init_masked_source(num_elem, EMUL_pow, ym_val);

  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        // active segments
        y_set_ystart(to_bits(p));
        foreach (field from 0 to (nf - 1)) {
          let elem_offset = (p * nf + field) * load_width_bytes;
          let vs = y_yregidx_offset(ys3, to_bits_unsafe(5, field * EMUL_reg));
          let data = y_read_element(load_width_bytes * 8, i, j, k, vs);
          match vmem_write(
            rs1,
            to_bits_unsafe(xlen, elem_offset),
            load_width_bytes,
            data,
            Store(Vector),
            false,
            false,
            false,
          ) {
            Ok(true)  => (),
            Ok(false) => internal_error(__FILE__, __LINE__, "store got false from vmem_write"),
            Err(e)    => return e,
          }
        }
      }
    }
  };

  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = Y_YSSEGTYPE(nf, ym, rs1, width, ys3)
 <-> "ys" ^ y_nfields_string(nf) ^ "e" ^ y_ylewidth_bitsnumberstr(width) ^ ".y" ^ spc() ^ y_yreg_name(ys3) ^ sep() ^ "(" ^ reg_name(rs1) ^ ")" ^ y_maybe_ymask(ym)

// ***************************** Tensor Load Constant-Stride Normal & Segment (mop=0b10) ******************************
union clause instruction = Y_YLSSEGTYPE : (y_nfields, bits(1), regidx, regidx, y_ylewidth, yregidx)

mapping clause encdec = Y_YLSSEGTYPE(nf, ym, rs2, rs1, width, yd)
 <-> y_encdec_nfields(nf) @ 0b0 @ 0b10 @ ym @ encdec_reg(rs2) @ encdec_reg(rs1) @ y_encdec_ylewidth(width) @ y_encdec_yreg(yd) @ 0b0000111
 when ((currentlyEnabled(Ext_Y) & algebra_memory_bank == AlgebraMemory_Y) & y_ylewidth_pow(width) <= 5)
  | (((currentlyEnabled(Ext_Y) & algebra_memory_bank == AlgebraMemory_Y) & yelen >= 64) & y_ylewidth_pow(width) <= 6)

function clause execute(Y_YLSSEGTYPE(nf, ym, rs2, rs1, width, yd)) = {
  let EEW_pow = y_ylewidth_pow(width);
  let load_width_bytes = 2 ^ (EEW_pow - 3);
  let EEW = 2 ^ EEW_pow;
  let Y_SEW_pow = y_get_sew_pow();
  let Y_LMUL_pow = y_get_lmul_pow();
  let EMUL_pow = EEW_pow - Y_SEW_pow + Y_LMUL_pow;

  assert(-3 <= EMUL_pow & EMUL_pow <= 3);

  let num_elem = y_get_num_elem(EMUL_pow, EEW);
  assert(num_elem > 0);

  if   y_illegal_ystart(Y_YSTART_LOAD_STORE, num_elem, EMUL_pow)
   | y_illegal_load(yd, ym, nf, EEW, EMUL_pow)
   | not(y_valid_reg_group(yd, EMUL_pow)) then {
    return Illegal_Instruction()
  };

  let EMUL_reg = 2 ^ max(EMUL_pow, 0);
  let ym_val = y_read_ymask(num_elem, ym, y_zyreg);
  let yd_seg = y_read_yreg_seg(num_elem, load_width_bytes * 8, EMUL_pow, nf, yd);
  let rs2_val = unsigned(y_get_scalar(rs2, xlen));

  let (m as 'm) = nf * load_width_bytes * 8;
  let (n as 'n) = num_elem;
  let (result, mask) : (vector('n, bits('m)), bits('n)) = y_init_masked_result(
    num_elem,
    nf * load_width_bytes * 8,
    EMUL_pow,
    yd_seg,
    ym_val,
  );

  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    let result_view = y_shape(result, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        // active segments
        y_set_ystart(to_bits(p));
        foreach (field from 0 to (nf - 1)) {
          let elem_offset = p * rs2_val + field * load_width_bytes;
          match vmem_read(
            rs1,
            to_bits_unsafe(xlen, elem_offset),
            load_width_bytes,
            Load(Vector),
            false,
            false,
            false,
          ) {
            Ok(elem) => y_write_element(
              load_width_bytes * 8,
              i,
              j,
              k,
              y_yregidx_offset(yd, to_bits_unsafe(5, field * EMUL_reg)),
              elem,
            ),
            Err(e)   => return e,
          }
        }
      } else {
        // prestart, masked or tail segments
        foreach (field from 0 to (nf - 1)) {
          let skipped_elem = (result_view[i][j][k] >> (field * load_width_bytes * 8))[
              load_width_bytes * 8 - 1 .. 0
            ];
          y_write_element(
            load_width_bytes * 8,
            i,
            j,
            k,
            y_yregidx_offset(yd, to_bits_unsafe(5, field * EMUL_reg)),
            skipped_elem,
          )
        }
      }
    }
  };

  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = Y_YLSSEGTYPE(nf, ym, rs2, rs1, width, yd)
 <-> "yls" ^ y_nfields_string(nf) ^ "e" ^ y_ylewidth_bitsnumberstr(width) ^ ".y" ^ spc() ^ y_yreg_name(yd) ^ sep() ^ "(" ^ reg_name(rs1) ^ ")" ^ sep() ^ reg_name(rs2) ^ y_maybe_ymask(ym)

// **************************** Tensor Store Constant-Stride Normal & Segment (mop=0b10) ******************************
union clause instruction = Y_YSSSEGTYPE : (y_nfields, bits(1), regidx, regidx, y_ylewidth, yregidx)

mapping clause encdec = Y_YSSSEGTYPE(nf, ym, rs2, rs1, width, ys3)
 <-> y_encdec_nfields(nf) @ 0b0 @ 0b10 @ ym @ encdec_reg(rs2) @ encdec_reg(rs1) @ y_encdec_ylewidth(width) @ y_encdec_yreg(ys3) @ 0b0100111
 when ((currentlyEnabled(Ext_Y) & algebra_memory_bank == AlgebraMemory_Y) & y_ylewidth_pow(width) <= 5)
  | (((currentlyEnabled(Ext_Y) & algebra_memory_bank == AlgebraMemory_Y) & yelen >= 64) & y_ylewidth_pow(width) <= 6)

function clause execute(Y_YSSSEGTYPE(nf, ym, rs2, rs1, width, ys3)) = {
  let EEW_pow = y_ylewidth_pow(width);
  let EEW = 2 ^ EEW_pow;
  let load_width_bytes = 2 ^ (EEW_pow - 3);
  let Y_SEW_pow = y_get_sew_pow();
  let Y_LMUL_pow = y_get_lmul_pow();
  let EMUL_pow = EEW_pow - Y_SEW_pow + Y_LMUL_pow;

  assert(-3 <= EMUL_pow & EMUL_pow <= 3);

  let num_elem = y_get_num_elem(EMUL_pow, EEW);
  assert(num_elem > 0);

  if   y_illegal_ystart(Y_YSTART_LOAD_STORE, num_elem, EMUL_pow)
   | y_illegal_store(ys3, nf, EEW, EMUL_pow)
   | not(y_valid_reg_group(ys3, EMUL_pow))
   | not(y_valid_ym_src_overlap(ym, ys3, EEW)) then {
    return Illegal_Instruction()
  };

  let EMUL_reg = 2 ^ max(EMUL_pow, 0);
  let ym_val = y_read_ymask(num_elem, ym, y_zyreg);
  let ys3_seg = y_read_yreg_seg(num_elem, load_width_bytes * 8, EMUL_pow, nf, ys3);
  let rs2_val = unsigned(y_get_scalar(rs2, xlen));

  let (n as 'n) = num_elem;
  let mask : bits('n) = y_init_masked_source(num_elem, EMUL_pow, ym_val);

  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        // active segments
        y_set_ystart(to_bits(p));
        foreach (field from 0 to (nf - 1)) {
          let elem_offset = p * rs2_val + field * load_width_bytes;
          let vs = y_yregidx_offset(ys3, to_bits_unsafe(5, field * EMUL_reg));
          let data = y_read_element(load_width_bytes * 8, i, j, k, vs);
          match vmem_write(
            rs1,
            to_bits_unsafe(xlen, elem_offset),
            load_width_bytes,
            data,
            Store(Vector),
            false,
            false,
            false,
          ) {
            Ok(true)  => (),
            Ok(false) => internal_error(__FILE__, __LINE__, "store got false from vmem_write"),
            Err(e)    => return e,
          }
        }
      }
    }
  };

  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = Y_YSSSEGTYPE(nf, ym, rs2, rs1, width, ys3)
 <-> "yss" ^ y_nfields_string(nf) ^ "e" ^ y_ylewidth_bitsnumberstr(width) ^ ".y" ^ spc() ^ y_yreg_name(ys3) ^ sep() ^ "(" ^ reg_name(rs1) ^ ")" ^ sep() ^ reg_name(rs2) ^ y_maybe_ymask(ym)

// ************************ Tensor Load Indexed (Ordered and Unordered) Normal & Segment (mop=0b01 or mop=0b11) *******
// Note: Zve64* extensions do not support EEW=64 for index values when XLEN=32.
union clause instruction = Y_YLXSEGTYPE : (y_nfields, bits(1), yregidx, regidx, y_ylewidth, yregidx, y_indexed_mop)

mapping clause encdec = Y_YLXSEGTYPE(nf, ym, ys2, rs1, width, yd, mop)
 <-> y_encdec_nfields(nf) @ 0b0 @ y_encdec_indexed_mop(mop) @ ym @ y_encdec_yreg(ys2) @ encdec_reg(rs1) @ y_encdec_ylewidth(width) @ y_encdec_yreg(yd) @ 0b0000111
 when (currentlyEnabled(Ext_Y) & algebra_memory_bank == AlgebraMemory_Y) & y_ylewidth_pow(width) <= y_max_index_eew_exp

// `mop` selects between the ordered and unordered variants of these instructions.  This function currently
// only implements the ordered variant, hence `mop` is ignored.
function clause execute(Y_YLXSEGTYPE(nf, ym, ys2, rs1, width, yd, _mop)) = {
  let EEW_index_pow = y_ylewidth_pow(width);
  let EEW_index = 2 ^ EEW_index_pow;
  let EEW_index_bytes = 2 ^ (EEW_index_pow - 3);
  let EEW_data_pow = y_get_sew_pow();
  let EEW_data_bytes = y_get_sew_bytes();
  let EMUL_data_pow = y_get_lmul_pow();
  let EMUL_index_pow = EEW_index_pow - EEW_data_pow + EMUL_data_pow;
  let num_elem = y_get_num_elem(EMUL_data_pow, EEW_data_bytes * 8);
  assert(num_elem > 0);

  let index_dst_overlap : bool = if nf == 1 then {
      not(y_valid_reg_overlap(ys2, yd, EMUL_index_pow, EMUL_data_pow))
      // non-segment indexed load
    } else {
      not(y_valid_disjoint_reg_groups_segmented(ys2, yd, EMUL_index_pow, EMUL_data_pow, nf))
    }; // segment indexed load

  if   y_illegal_ystart(Y_YSTART_LOAD_STORE, num_elem, EMUL_data_pow)
   | y_illegal_indexed_load(yd, ym, nf, 2 ^ EEW_index_pow, EMUL_index_pow, EMUL_data_pow)
   | index_dst_overlap
   | not(y_valid_ym_src_overlap(ym, ys2, EEW_index)) then {
    return Illegal_Instruction()
  };

  let EMUL_data_reg = if EMUL_data_pow <= 0 then {
      1
    } else {
      2 ^ EMUL_data_pow
    };
  let ym_val = y_read_ymask(num_elem, ym, y_zyreg);
  let yd_seg = y_read_yreg_seg(num_elem, EEW_data_bytes * 8, EMUL_data_pow, nf, yd);
  let ys2_val = y_read_yreg(num_elem, EEW_index_bytes * 8, EMUL_index_pow, ys2);

  let (m as 'm) = nf * EEW_data_bytes * 8;
  let (n as 'n) = num_elem;
  let (result, mask) : (vector('n, bits('m)), bits('n)) = y_init_masked_result(
    num_elem,
    nf * EEW_data_bytes * 8,
    EMUL_data_pow,
    yd_seg,
    ym_val,
  );

  // As mentioned above, currently mop = 1 (unordered) or 3 (ordered) do the same operations.
  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    let result_view = y_shape(result, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        // active segments
        y_set_ystart(to_bits(p));
        foreach (field from 0 to (nf - 1)) {
          let elem_offset : int = unsigned(ys2_val_view[i][j][k]) + field * EEW_data_bytes;
          match vmem_read(
            rs1,
            to_bits_unsafe(xlen, elem_offset),
            EEW_data_bytes,
            Load(Vector),
            false,
            false,
            false,
          ) {
            Ok(elem) => y_write_element(
              EEW_data_bytes * 8,
              i,
              j,
              k,
              y_yregidx_offset(yd, to_bits_unsafe(5, field * EMUL_data_reg)),
              elem,
            ),
            Err(e)   => return e,
          }
        }
      } else {
        // prestart, masked or tail segments
        foreach (field from 0 to (nf - 1)) {
          let skipped_elem = (result_view[i][j][k] >> (field * EEW_data_bytes * 8))[
              EEW_data_bytes * 8 - 1 .. 0
            ];
          y_write_element(
            EEW_data_bytes * 8,
            i,
            j,
            k,
            y_yregidx_offset(yd, to_bits_unsafe(5, field * EMUL_data_reg)),
            skipped_elem,
          )
        }
      }
    }
  };

  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = Y_YLXSEGTYPE(nf, ym, ys2, rs1, width, yd, mop)
 <-> "yl" ^ y_indexed_mop_mnemonic(mop) ^ "x" ^ y_nfields_string(nf) ^ "ei" ^ y_ylewidth_bitsnumberstr(width) ^ ".y" ^ spc() ^ y_yreg_name(yd) ^ sep() ^ "(" ^ reg_name(rs1) ^ ")" ^ sep() ^ y_yreg_name(ys2) ^ y_maybe_ymask(ym)

// *********************** Tensor Store Indexed (Ordered and Unordered) Normal & Segment (mop=0b01 or mop=0b11) *******
// Note: Zve64* extensions do not support EEW=64 for index values when XLEN=32.
union clause instruction = Y_YSXSEGTYPE : (y_nfields, bits(1), yregidx, regidx, y_ylewidth, yregidx, y_indexed_mop)

mapping clause encdec = Y_YSXSEGTYPE(nf, ym, ys2, rs1, width, ys3, mop)
 <-> y_encdec_nfields(nf) @ 0b0 @ y_encdec_indexed_mop(mop) @ ym @ y_encdec_yreg(ys2) @ encdec_reg(rs1) @ y_encdec_ylewidth(width) @ y_encdec_yreg(ys3) @ 0b0100111
 when ((currentlyEnabled(Ext_Y) & algebra_memory_bank == AlgebraMemory_Y) & y_ylewidth_pow(width) <= y_max_index_eew_exp)

// `mop` selects between the ordered and unordered variants of these instructions.  This function currently
// only implements the ordered variant, hence `mop` is ignored.
function clause execute(Y_YSXSEGTYPE(nf, ym, ys2, rs1, width, ys3, _mop)) = {
  let EEW_index_pow = y_ylewidth_pow(width);
  let EEW_index = 2 ^ EEW_index_pow;
  let EEW_index_bytes = 2 ^ (EEW_index_pow - 3);
  let EEW_data_pow = y_get_sew_pow();
  let EEW_data = 2 ^ EEW_data_pow;
  let EEW_data_bytes = y_get_sew_bytes();
  let EMUL_data_pow = y_get_lmul_pow();
  let EMUL_index_pow = EEW_index_pow - EEW_data_pow + EMUL_data_pow;
  let num_elem = y_get_num_elem(EMUL_data_pow, EEW_data_bytes * 8); // number of data and indices are the same

  assert(num_elem > 0);

  if   y_illegal_ystart(Y_YSTART_LOAD_STORE, num_elem, EMUL_data_pow)
   | y_illegal_indexed_store(ys3, nf, 2 ^ EEW_index_pow, EMUL_index_pow, EMUL_data_pow)
   | not(y_valid_src_overlap_segmented(ys2, EEW_index, EMUL_index_pow, ys3, EEW_data, EMUL_data_pow, nf))
   | not(y_valid_ym_src_overlap(ym, ys2, EEW_index))
   | not(y_valid_ym_src_overlap(ym, ys3, EEW_data)) then {
    return Illegal_Instruction()
  };

  let EMUL_data_reg = if EMUL_data_pow <= 0 then {
      1
    } else {
      2 ^ EMUL_data_pow
    };
  let ym_val = y_read_ymask(num_elem, ym, y_zyreg);
  let ys3_seg = y_read_yreg_seg(num_elem, EEW_data_bytes * 8, EMUL_data_pow, nf, ys3);
  let ys2_val = y_read_yreg(num_elem, EEW_index_bytes * 8, EMUL_index_pow, ys2);

  let (n as 'n) = num_elem;
  let mask : bits('n) = y_init_masked_source(num_elem, EMUL_data_pow, ym_val);

  // As mentioned above, currently mop = 1 (unordered) or 3 (ordered) do the same operations.
  {
    let mask_view = y_shape(mask, y_columns, y_depth);
    let ys2_val_view = y_shape(ys2_val, y_columns, y_depth);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(mask_view));
      assert(i < length(ys2_val_view));
      assert(j < y_columns & k < y_depth);

      if mask_view[i][j][k] == 0b1 then {
        // active segments
        y_set_ystart(to_bits(p));
        foreach (field from 0 to (nf - 1)) {
          let elem_offset : int = unsigned(ys2_val_view[i][j][k]) + field * EEW_data_bytes;
          let vs = y_yregidx_offset(ys3, to_bits_unsafe(5, field * EMUL_data_reg));
          let data = y_read_element(EEW_data_bytes * 8, i, j, k, vs);
          match vmem_write(
            rs1,
            to_bits_unsafe(xlen, elem_offset),
            EEW_data_bytes,
            data,
            Store(Vector),
            false,
            false,
            false,
          ) {
            Ok(true)  => (),
            Ok(false) => internal_error(__FILE__, __LINE__, "store got false from vmem_write"),
            Err(e)    => return e,
          }
        }
      }
    }
  };

  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = Y_YSXSEGTYPE(nf, ym, ys2, rs1, width, ys3, mop)
 <-> "ys" ^ y_indexed_mop_mnemonic(mop) ^ "x" ^ y_nfields_string(nf) ^ "ei" ^ y_ylewidth_bitsnumberstr(width) ^ ".y" ^ spc() ^ y_yreg_name(ys3) ^ sep() ^ "(" ^ reg_name(rs1) ^ ")" ^ sep() ^ y_yreg_name(ys2) ^ y_maybe_ymask(ym)

// **************** Tensor Load Unit-Stride Whole Register (ym=0b1, mop=0b00, lumop=0b01000) ******************
union clause instruction = Y_YLRETYPE : (y_nfields_pow2, regidx, y_ylewidth, yregidx)

mapping clause encdec = Y_YLRETYPE(nf, rs1, width, yd)
 <-> y_encdec_nfields_pow2(nf) @ 0b0 @ 0b00 @ 0b1 @ 0b01000 @ encdec_reg(rs1) @ y_encdec_ylewidth(width) @ y_encdec_yreg(yd) @ 0b0000111
 when ((currentlyEnabled(Ext_Y) & algebra_memory_bank == AlgebraMemory_Y) & y_ylewidth_pow(width) <= 5)
  | (((currentlyEnabled(Ext_Y) & algebra_memory_bank == AlgebraMemory_Y) & yelen >= 64) & y_ylewidth_pow(width) <= 6)

function clause execute(Y_YLRETYPE(nf, rs1, width, yd)) = {
  let EEW_pow = y_ylewidth_pow(width);
  let load_width_bytes = 2 ^ (EEW_pow - 3);
  let EEW = 2 ^ EEW_pow;
  let elem_per_reg = ylen / EEW;
  assert(elem_per_reg >= 0);

  if y_illegal_ystart(Y_YSTART_LOAD_STORE, nf * elem_per_reg, 0) | not(y_valid_whole_register(yd, nf)) then {
    return Illegal_Instruction()
  };

  let start_element = y_get_start_element();

  // NOTE: Non-trapping path, ystart >= evl writes no elements. Currently
  // unreachable because illegal_ystart above always traps on out-of-bounds
  // ystart, but kept so this stays correct if that trap is ever made optional.
  if start_element >= nf * elem_per_reg then {
    return RETIRE_SUCCESS
  };
  let elem_to_align : int = start_element % elem_per_reg;
  var cur_field : int = start_element / elem_per_reg;
  var cur_elem : int = start_element;

  if elem_to_align > 0 then {
    {
      foreach (p from elem_to_align to (elem_per_reg - 1)) {
        let i = p / (y_columns * y_depth);
        let j = (p / y_depth) % y_columns;
        let k = p % y_depth;
        assert(j < y_columns & k < y_depth);

        y_set_ystart(to_bits_unsafe(16, cur_elem));
        let elem_offset = cur_elem * load_width_bytes;
        match vmem_read(
          rs1,
          to_bits_unsafe(xlen, elem_offset),
          load_width_bytes,
          Load(Vector),
          false,
          false,
          false,
        ) {
          Ok(elem) => y_write_element(
            load_width_bytes * 8,
            i,
            j,
            k,
            y_yregidx_offset(yd, to_bits_unsafe(5, cur_field)),
            elem,
          ),
          Err(e)   => return e,
        };
        cur_elem = cur_elem + 1
      }
    };
    cur_field = cur_field + 1
  };

  foreach (field from cur_field to (nf - 1)) {
    {
      foreach (p from 0 to (elem_per_reg - 1)) {
        let i = p / (y_columns * y_depth);
        let j = (p / y_depth) % y_columns;
        let k = p % y_depth;
        assert(j < y_columns & k < y_depth);

        y_set_ystart(to_bits_unsafe(16, cur_elem));
        let elem_offset = cur_elem * load_width_bytes;
        match vmem_read(
          rs1,
          to_bits_unsafe(xlen, elem_offset),
          load_width_bytes,
          Load(Vector),
          false,
          false,
          false,
        ) {
          Ok(elem) => y_write_element(
            load_width_bytes * 8,
            i,
            j,
            k,
            y_yregidx_offset(yd, to_bits_unsafe(5, field)),
            elem,
          ),
          Err(e)   => return e,
        };
        cur_elem = cur_elem + 1
      }
    }
  };

  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = Y_YLRETYPE(nf, rs1, width, yd)
 <-> "yl" ^ y_nfields_pow2_string(nf) ^ "re" ^ y_ylewidth_bitsnumberstr(width) ^ ".y" ^ spc() ^ y_yreg_name(yd) ^ sep() ^ "(" ^ reg_name(rs1) ^ ")"

// **************** Tensor Store Unit-Stride Whole Register (ym=0b1, mop=0b00, sumop=0b01000) *****************
union clause instruction = Y_YSRETYPE : (y_nfields_pow2, regidx, yregidx)

mapping clause encdec = Y_YSRETYPE(nf, rs1, ys3)
 <-> y_encdec_nfields_pow2(nf) @ 0b0 @ 0b00 @ 0b1 @ 0b01000 @ encdec_reg(rs1) @ 0b000 @ y_encdec_yreg(ys3) @ 0b0100111
 when (currentlyEnabled(Ext_Y) & algebra_memory_bank == AlgebraMemory_Y)

function clause execute(Y_YSRETYPE(nf, rs1, ys3)) = {
  let load_width_bytes = 1;
  let EEW = 8;
  let elem_per_reg = ylen / EEW;
  assert(elem_per_reg >= 0);

  if y_illegal_ystart(Y_YSTART_LOAD_STORE, nf * elem_per_reg, 0) | not(y_valid_whole_register(ys3, nf)) then {
    return Illegal_Instruction()
  };

  let start_element = y_get_start_element();

  // NOTE: Non-trapping path, ystart >= evl writes no elements. Currently
  // unreachable because illegal_ystart above always traps on out-of-bounds
  // ystart, but kept so this stays correct if that trap is ever made optional.
  if start_element >= nf * elem_per_reg then {
    return RETIRE_SUCCESS
  };
  let elem_to_align : int = start_element % elem_per_reg;
  var cur_field : int = start_element / elem_per_reg;
  var cur_elem : int = start_element;

  if elem_to_align > 0 then {
    {
      foreach (p from elem_to_align to (elem_per_reg - 1)) {
        let i = p / (y_columns * y_depth);
        let j = (p / y_depth) % y_columns;
        let k = p % y_depth;
        assert(j < y_columns & k < y_depth);

        y_set_ystart(to_bits_unsafe(16, cur_elem));
        let elem_offset : int = cur_elem * load_width_bytes;
        let vs = y_yregidx_offset(ys3, to_bits_unsafe(5, cur_field));
        let data = y_read_element(load_width_bytes * 8, i, j, k, vs);
        match vmem_write(
          rs1,
          to_bits_unsafe(xlen, elem_offset),
          load_width_bytes,
          data,
          Store(Vector),
          false,
          false,
          false,
        ) {
          Ok(true)  => (),
          Ok(false) => internal_error(__FILE__, __LINE__, "store got false from vmem_write"),
          Err(e)    => return e,
        };
        cur_elem = cur_elem + 1
      }
    };
    cur_field = cur_field + 1
  };

  foreach (field from cur_field to (nf - 1)) {
    let ys3_val = y_read_yreg(
      elem_per_reg,
      load_width_bytes * 8,
      0,
      y_yregidx_offset(ys3, to_bits_unsafe(5, field)),
    );
    {
      let ys3_val_view = y_shape(ys3_val, y_columns, y_depth);
      foreach (p from 0 to (elem_per_reg - 1)) {
        let i = p / (y_columns * y_depth);
        let j = (p / y_depth) % y_columns;
        let k = p % y_depth;
        assert(i < length(ys3_val_view));
        assert(j < y_columns & k < y_depth);

        y_set_ystart(to_bits_unsafe(16, cur_elem));
        let elem_offset = cur_elem * load_width_bytes;
        match vmem_write(
          rs1,
          to_bits_unsafe(xlen, elem_offset),
          load_width_bytes,
          ys3_val_view[i][j][k],
          Store(Vector),
          false,
          false,
          false,
        ) {
          Ok(true)  => (),
          Ok(false) => internal_error(__FILE__, __LINE__, "store got false from vmem_write"),
          Err(e)    => return e,
        };
        cur_elem = cur_elem + 1
      }
    }
  };

  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = Y_YSRETYPE(nf, rs1, ys3)
 <-> "ys" ^ y_nfields_pow2_string(nf) ^ "r.y" ^ spc() ^ y_yreg_name(ys3) ^ sep() ^ "(" ^ reg_name(rs1) ^ ")"

// ************* Tensor Mask Load/Store Unit-Stride (nf=0b000, mop=0b00, lumop or sumop=0b01011) **************
union clause instruction = Y_YMTYPE : (regidx, yregidx, y_ymlsop)

mapping y_encdec_lsop : y_ymlsop <-> bits(7) = {
 Y_YLM      <-> 0b0000111,
 Y_YSM      <-> 0b0100111
}

mapping clause encdec = Y_YMTYPE(rs1, yd_or_ys3, op)
 <-> 0b000 @ 0b0 @ 0b00 @ 0b1 @ 0b01011 @ encdec_reg(rs1) @ 0b000 @ y_encdec_yreg(yd_or_ys3) @ y_encdec_lsop(op)
 when (currentlyEnabled(Ext_Y) & algebra_memory_bank == AlgebraMemory_Y)

function clause execute(Y_YMTYPE(rs1, yd_or_ys3, op)) = {
  let EEW = 8;
  let EMUL_pow = 0;
  let yl_val = unsigned(yl);
  let evl : int = if yl_val % 8 == 0 then {
      yl_val / 8
    } else {
      yl_val / 8 + 1
    }; // the effective tensor length is evl=ceil(yl/8)
  let num_elem = y_get_num_elem(EMUL_pow, EEW);

  if y_illegal_ystart(Y_YSTART_LOAD_STORE, num_elem, EMUL_pow) | y_illegal_yd_unmasked() then {
    return Illegal_Instruction()
  };

  assert(evl >= 0);
  let start_element = y_get_start_element();
  let (n as 'n) = num_elem;
  let yd_or_ys3_val : vector('n, bits(8)) = y_read_yreg(num_elem, 8, 0, yd_or_ys3);

  {
    let yd_or_ys3_val_view = y_shape(yd_or_ys3_val, y_columns, y_depth);
    foreach (p from start_element to (num_elem - 1)) {
      let i = p / (y_columns * y_depth);
      let j = (p / y_depth) % y_columns;
      let k = p % y_depth;
      assert(i < length(yd_or_ys3_val_view));
      assert(j < y_columns & k < y_depth);

      if p < evl then {
        // active elements
        y_set_ystart(to_bits(p));
        if op == Y_YLM then {
          // load
          match vmem_read(rs1, to_bits_unsafe(xlen, p), 1, Load(Vector), false, false, false) {
            Ok(elem) => y_write_element(8, i, j, k, yd_or_ys3, elem),
            Err(e)   => return e,
          }
        } else {
          if op == Y_YSM then {
            // store
            match vmem_write(
              rs1,
              to_bits_unsafe(xlen, p),
              1,
              yd_or_ys3_val_view[i][j][k],
              Store(Vector),
              false,
              false,
              false,
            ) {
              Ok(true)  => (),
              Ok(false) => internal_error(__FILE__, __LINE__, "store got false from vmem_write"),
              Err(e)    => return e,
            }
          }
        }
      } else {
        // tail elements for mask load, always with agnostic policy
        if op == Y_YLM then {
          y_write_element(8, i, j, k, yd_or_ys3, yd_or_ys3_val_view[i][j][k])
          // TODO: configuration support for agnostic behavior
        }
      }
    }
  };

  y_set_ystart(zeros());
  RETIRE_SUCCESS
}

mapping y_vmtype_mnemonic : y_ymlsop <-> string = {
 Y_YLM      <-> "ylm.y",
 Y_YSM      <-> "ysm.y"
}

mapping clause assembly = Y_YMTYPE(rs1, yd_or_ys3, op)
 <-> y_vmtype_mnemonic(op) ^ spc() ^ y_yreg_name(yd_or_ys3) ^ sep() ^ "(" ^ reg_name(rs1) ^ ")"
