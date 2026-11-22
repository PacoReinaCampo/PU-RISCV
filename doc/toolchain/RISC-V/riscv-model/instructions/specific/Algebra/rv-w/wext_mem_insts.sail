// =======================================================================================
// This Sail RISC-W architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

// ******************************************************************************
// This file implements part of the matrix extension.
// Chapter 7: Matrix Loads and Stores
// ******************************************************************************

mapping w_wlewidth_bitsnumberstr : w_wlewidth <-> string = {
 W_WLE8      <-> "8",
 W_WLE16     <-> "16",
 W_WLE32     <-> "32",
 W_WLE64     <-> "64"
}

mapping w_encdec_wlewidth : w_wlewidth <-> bits(3) = {
 W_WLE8      <-> 0b000,
 W_WLE16     <-> 0b101,
 W_WLE32     <-> 0b110,
 W_WLE64     <-> 0b111
}

mapping w_wlewidth_pow : w_wlewidth <-> {3, 4, 5, 6} = {
 W_WLE8      <-> 3,
 W_WLE16     <-> 4,
 W_WLE32     <-> 5,
 W_WLE64     <-> 6
}

mapping w_encdec_indexed_mop : w_indexed_mop <-> bits(2) = {
 W_INDEXED_UNORDERED <-> 0b01,
 W_INDEXED_ORDERED   <-> 0b11,
}

mapping w_indexed_mop_mnemonic : w_indexed_mop <-> string = {
 W_INDEXED_UNORDERED <-> "u",
 W_INDEXED_ORDERED   <-> "o",
}

// ******************* Matrix Load Unit-Stride Normal & Segment (mop=0b00, lumop=0b00000) *********************
union clause instruction = W_WLSEGTYPE : (w_nfields, bits(1), regidx, w_wlewidth, wregidx)

mapping clause encdec = W_WLSEGTYPE(nf, wm, rs1, width, wd)
 <-> w_encdec_nfields(nf) @ 0b0 @ 0b00 @ wm @ 0b00000 @ encdec_reg(rs1) @ w_encdec_wlewidth(width) @ w_encdec_wreg(wd) @ 0b0000111
 when ((currentlyEnabled(Ext_W) & algebra_memory_bank == AlgebraMemory_W) & w_wlewidth_pow(width) <= 5)
  | (((currentlyEnabled(Ext_W) & algebra_memory_bank == AlgebraMemory_W) & welen >= 64) & w_wlewidth_pow(width) <= 6)

function clause execute(W_WLSEGTYPE(nf, wm, rs1, width, wd)) = {
  let EEW_pow = w_wlewidth_pow(width);
  let load_width_bytes = 2 ^ (EEW_pow - 3);
  let EEW = 2 ^ EEW_pow;
  let W_SEW_pow = w_get_sew_pow();
  let W_LMUL_pow = w_get_lmul_pow();
  let EMUL_pow = EEW_pow - W_SEW_pow + W_LMUL_pow;

  assert(-3 <= EMUL_pow & EMUL_pow <= 3);

  let num_elem = w_get_num_elem(EMUL_pow, EEW); // # of element of each register group
  assert(num_elem > 0);

  if   w_illegal_wstart(W_WSTART_LOAD_STORE, num_elem, EMUL_pow)
   | w_illegal_load(wd, wm, nf, EEW, EMUL_pow)
   | not(w_valid_reg_group(wd, EMUL_pow)) then {
    return Illegal_Instruction()
  };

  let EMUL_reg = 2 ^ max(EMUL_pow, 0);
  let wm_val = w_read_wmask(num_elem, wm, w_zwreg);
  let wd_seg = w_read_wreg_seg(num_elem, load_width_bytes * 8, EMUL_pow, nf, wd);

  let (m as 'm) = nf * load_width_bytes * 8;
  let (n as 'n) = num_elem;
  let (result, mask) : (vector('n, bits('m)), bits('n)) = w_init_masked_result(
    num_elem,
    sizeof('m),
    EMUL_pow,
    wd_seg,
    wm_val,
  );

  {
    let mask_view = w_shape(mask, w_columns);
    let result_view = w_shape(result, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        // active segments
        w_set_wstart(to_bits(p));
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
            Ok(elem) => w_write_element(
              load_width_bytes * 8,
              i,
              j,
              w_wregidx_offset(wd, to_bits_unsafe(5, field * EMUL_reg)),
              elem,
            ),
            Err(e)   => return e,
          }
        }
      } else {
        // prestart, masked or tail segments
        foreach (field from 0 to (nf - 1)) {
          let skipped_elem = (result_view[i][j] >> (field * load_width_bytes * 8))[
              load_width_bytes * 8 - 1 .. 0
            ];
          w_write_element(
            load_width_bytes * 8,
            i,
            j,
            w_wregidx_offset(wd, to_bits_unsafe(5, field * EMUL_reg)),
            skipped_elem,
          )
        }
      }
    }
  };

  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_WLSEGTYPE(nf, wm, rs1, width, wd)
 <-> "wl" ^ w_nfields_string(nf) ^ "e" ^ w_wlewidth_bitsnumberstr(width) ^ ".w" ^ spc() ^ w_wreg_name(wd) ^ sep() ^ "(" ^ reg_name(rs1) ^ ")" ^ w_maybe_wmask(wm)

// *********** Matrix Load Unit-Stride Normal & Segment Fault-Only-First (mop=0b00, lumop=0b10000) ************
union clause instruction = W_WLSEGFFTYPE : (w_nfields, bits(1), regidx, w_wlewidth, wregidx)

mapping clause encdec = W_WLSEGFFTYPE(nf, wm, rs1, width, wd)
 <-> w_encdec_nfields(nf) @ 0b0 @ 0b00 @ wm @ 0b10000 @ encdec_reg(rs1) @ w_encdec_wlewidth(width) @ w_encdec_wreg(wd) @ 0b0000111
 when ((currentlyEnabled(Ext_W) & algebra_memory_bank == AlgebraMemory_W) & w_wlewidth_pow(width) <= 5)
  | (((currentlyEnabled(Ext_W) & algebra_memory_bank == AlgebraMemory_W) & welen >= 64) & w_wlewidth_pow(width) <= 6)

function clause execute(W_WLSEGFFTYPE(nf, wm, rs1, width, wd)) = {
  let EEW_pow = w_wlewidth_pow(width);
  let load_width_bytes = 2 ^ (EEW_pow - 3);
  let EEW = 2 ^ EEW_pow;
  let W_SEW_pow = w_get_sew_pow();
  let W_LMUL_pow = w_get_lmul_pow();
  let EMUL_pow = EEW_pow - W_SEW_pow + W_LMUL_pow;

  assert(-3 <= EMUL_pow & EMUL_pow <= 3);

  let num_elem = w_get_num_elem(EMUL_pow, EEW);
  assert(num_elem > 0);

  if   w_illegal_wstart(W_WSTART_LOAD_STORE, num_elem, EMUL_pow)
   | w_illegal_load(wd, wm, nf, EEW, EMUL_pow)
   | not(w_valid_reg_group(wd, EMUL_pow)) then {
    return Illegal_Instruction()
  };

  let EMUL_reg = 2 ^ max(EMUL_pow, 0);
  let wm_val = w_read_wmask(num_elem, wm, w_zwreg);
  let wd_seg = w_read_wreg_seg(num_elem, load_width_bytes * 8, EMUL_pow, nf, wd);
  let tail_ag = w_get_wtype_wta();

  let (m as 'm) = nf * load_width_bytes * 8;
  let (n as 'n) = num_elem;
  let (result, mask) : (vector('n, bits('m)), bits('n)) = w_init_masked_result(
    num_elem,
    nf * load_width_bytes * 8,
    EMUL_pow,
    wd_seg,
    wm_val,
  );

  var trimmed : bool = false;
  {
    let mask_view = w_shape(mask, w_columns);
    let result_view = w_shape(result, w_columns);
    let wd_seg_view = w_shape(wd_seg, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(wd_seg_view));
      assert(j < w_columns);

      if not(trimmed) then {
        if mask_view[i][j] == 0b1 then {
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
              Ok(elem) => w_write_element(
                load_width_bytes * 8,
                i,
                j,
                w_wregidx_offset(wd, to_bits_unsafe(5, field * EMUL_reg)),
                elem,
              ),
              // NOTE: A debug trigger on an element after the first is taken instead
              // of trimming wl, as recommended by a non-normative note in the spec
              // (otherwise the event might be lost). This may need a config option
              // in the future. If wl is trimmed instead, the trigger's match_info
              // must be cleared too, otherwise the next step still sees it.
              Err(PendingTrigger(pti)) => {
                w_set_wstart(to_bits(p));
                return PendingTrigger(pti)
              },
              Err(e) => if p == 0 then {
                return e
              } else {
                wl = to_bits(p);
                csr_write_callback("wl", zero_extend(wl));
                trimmed = true
              },
            }
          }
        } else {
          // prestart, masked or tail segments
          foreach (field from 0 to (nf - 1)) {
            let skipped_elem = (result_view[i][j] >> (field * load_width_bytes * 8))[
                load_width_bytes * 8 - 1 .. 0
              ];
            w_write_element(
              load_width_bytes * 8,
              i,
              j,
              w_wregidx_offset(wd, to_bits_unsafe(5, field * EMUL_reg)),
              skipped_elem,
            )
          }
        }
      } else {
        // if wl is trimmed, elements past the new wl are treated as tail elements
        if tail_ag == W_AGNOSTIC then {
          foreach (field from 0 to (nf - 1)) {
            let skipped_elem = (wd_seg_view[i][j] >> (field * load_width_bytes * 8))[
                load_width_bytes * 8 - 1 .. 0
              ];
            w_write_element(
              load_width_bytes * 8,
              i,
              j,
              w_wregidx_offset(wd, to_bits_unsafe(5, field * EMUL_reg)),
              skipped_elem,
            )
          }
          // TODO: configuration support for agnostic behavior
        }
      }
    }
  };

  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_WLSEGFFTYPE(nf, wm, rs1, width, wd)
 <-> "wl" ^ w_nfields_string(nf) ^ "e" ^ w_wlewidth_bitsnumberstr(width) ^ "ff.w" ^ spc() ^ w_wreg_name(wd) ^ sep() ^ "(" ^ reg_name(rs1) ^ ")" ^ w_maybe_wmask(wm)

// ******************* Matrix Store Unit-Stride Normal & Segment (mop=0b00, sumop=0b00000) ********************
union clause instruction = W_WSSEGTYPE : (w_nfields, bits(1), regidx, w_wlewidth, wregidx)

mapping clause encdec = W_WSSEGTYPE(nf, wm, rs1, width, ws3)
 <-> w_encdec_nfields(nf) @ 0b0 @ 0b00 @ wm @ 0b00000 @ encdec_reg(rs1) @ w_encdec_wlewidth(width) @ w_encdec_wreg(ws3) @ 0b0100111
 when ((currentlyEnabled(Ext_W) & algebra_memory_bank == AlgebraMemory_W) & w_wlewidth_pow(width) <= 5)
  | (((currentlyEnabled(Ext_W) & algebra_memory_bank == AlgebraMemory_W) & welen >= 64) & w_wlewidth_pow(width) <= 6)

function clause execute(W_WSSEGTYPE(nf, wm, rs1, width, ws3)) = {
  let EEW_pow = w_wlewidth_pow(width);
  let load_width_bytes = 2 ^ (EEW_pow - 3);
  let EEW = 2 ^ EEW_pow;
  let W_SEW_pow = w_get_sew_pow();
  let W_LMUL_pow = w_get_lmul_pow();
  let EMUL_pow = EEW_pow - W_SEW_pow + W_LMUL_pow;

  assert(-3 <= EMUL_pow & EMUL_pow <= 3);

  let num_elem = w_get_num_elem(EMUL_pow, EEW);
  assert(num_elem > 0);

  if   w_illegal_wstart(W_WSTART_LOAD_STORE, num_elem, EMUL_pow)
   | w_illegal_store(ws3, nf, EEW, EMUL_pow)
   | not(w_valid_reg_group(ws3, EMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws3, EEW)) then {
    return Illegal_Instruction()
  };

  let EMUL_reg = 2 ^ max(EMUL_pow, 0);
  let wm_val = w_read_wmask(num_elem, wm, w_zwreg);
  let ws3_seg = w_read_wreg_seg(num_elem, load_width_bytes * 8, EMUL_pow, nf, ws3);

  let (n as 'n) = num_elem;
  let mask : bits('n) = w_init_masked_source(num_elem, EMUL_pow, wm_val);

  {
    let mask_view = w_shape(mask, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        // active segments
        w_set_wstart(to_bits(p));
        foreach (field from 0 to (nf - 1)) {
          let elem_offset = (p * nf + field) * load_width_bytes;
          let vs = w_wregidx_offset(ws3, to_bits_unsafe(5, field * EMUL_reg));
          let data = w_read_element(load_width_bytes * 8, i, j, vs);
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

  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_WSSEGTYPE(nf, wm, rs1, width, ws3)
 <-> "ws" ^ w_nfields_string(nf) ^ "e" ^ w_wlewidth_bitsnumberstr(width) ^ ".w" ^ spc() ^ w_wreg_name(ws3) ^ sep() ^ "(" ^ reg_name(rs1) ^ ")" ^ w_maybe_wmask(wm)

// ***************************** Matrix Load Constant-Stride Normal & Segment (mop=0b10) ******************************
union clause instruction = W_WLSSEGTYPE : (w_nfields, bits(1), regidx, regidx, w_wlewidth, wregidx)

mapping clause encdec = W_WLSSEGTYPE(nf, wm, rs2, rs1, width, wd)
 <-> w_encdec_nfields(nf) @ 0b0 @ 0b10 @ wm @ encdec_reg(rs2) @ encdec_reg(rs1) @ w_encdec_wlewidth(width) @ w_encdec_wreg(wd) @ 0b0000111
 when ((currentlyEnabled(Ext_W) & algebra_memory_bank == AlgebraMemory_W) & w_wlewidth_pow(width) <= 5)
  | (((currentlyEnabled(Ext_W) & algebra_memory_bank == AlgebraMemory_W) & welen >= 64) & w_wlewidth_pow(width) <= 6)

function clause execute(W_WLSSEGTYPE(nf, wm, rs2, rs1, width, wd)) = {
  let EEW_pow = w_wlewidth_pow(width);
  let load_width_bytes = 2 ^ (EEW_pow - 3);
  let EEW = 2 ^ EEW_pow;
  let W_SEW_pow = w_get_sew_pow();
  let W_LMUL_pow = w_get_lmul_pow();
  let EMUL_pow = EEW_pow - W_SEW_pow + W_LMUL_pow;

  assert(-3 <= EMUL_pow & EMUL_pow <= 3);

  let num_elem = w_get_num_elem(EMUL_pow, EEW);
  assert(num_elem > 0);

  if   w_illegal_wstart(W_WSTART_LOAD_STORE, num_elem, EMUL_pow)
   | w_illegal_load(wd, wm, nf, EEW, EMUL_pow)
   | not(w_valid_reg_group(wd, EMUL_pow)) then {
    return Illegal_Instruction()
  };

  let EMUL_reg = 2 ^ max(EMUL_pow, 0);
  let wm_val = w_read_wmask(num_elem, wm, w_zwreg);
  let wd_seg = w_read_wreg_seg(num_elem, load_width_bytes * 8, EMUL_pow, nf, wd);
  let rs2_val = unsigned(w_get_scalar(rs2, xlen));

  let (m as 'm) = nf * load_width_bytes * 8;
  let (n as 'n) = num_elem;
  let (result, mask) : (vector('n, bits('m)), bits('n)) = w_init_masked_result(
    num_elem,
    nf * load_width_bytes * 8,
    EMUL_pow,
    wd_seg,
    wm_val,
  );

  {
    let mask_view = w_shape(mask, w_columns);
    let result_view = w_shape(result, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        // active segments
        w_set_wstart(to_bits(p));
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
            Ok(elem) => w_write_element(
              load_width_bytes * 8,
              i,
              j,
              w_wregidx_offset(wd, to_bits_unsafe(5, field * EMUL_reg)),
              elem,
            ),
            Err(e)   => return e,
          }
        }
      } else {
        // prestart, masked or tail segments
        foreach (field from 0 to (nf - 1)) {
          let skipped_elem = (result_view[i][j] >> (field * load_width_bytes * 8))[
              load_width_bytes * 8 - 1 .. 0
            ];
          w_write_element(
            load_width_bytes * 8,
            i,
            j,
            w_wregidx_offset(wd, to_bits_unsafe(5, field * EMUL_reg)),
            skipped_elem,
          )
        }
      }
    }
  };

  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_WLSSEGTYPE(nf, wm, rs2, rs1, width, wd)
 <-> "wls" ^ w_nfields_string(nf) ^ "e" ^ w_wlewidth_bitsnumberstr(width) ^ ".w" ^ spc() ^ w_wreg_name(wd) ^ sep() ^ "(" ^ reg_name(rs1) ^ ")" ^ sep() ^ reg_name(rs2) ^ w_maybe_wmask(wm)

// **************************** Matrix Store Constant-Stride Normal & Segment (mop=0b10) ******************************
union clause instruction = W_WSSSEGTYPE : (w_nfields, bits(1), regidx, regidx, w_wlewidth, wregidx)

mapping clause encdec = W_WSSSEGTYPE(nf, wm, rs2, rs1, width, ws3)
 <-> w_encdec_nfields(nf) @ 0b0 @ 0b10 @ wm @ encdec_reg(rs2) @ encdec_reg(rs1) @ w_encdec_wlewidth(width) @ w_encdec_wreg(ws3) @ 0b0100111
 when ((currentlyEnabled(Ext_W) & algebra_memory_bank == AlgebraMemory_W) & w_wlewidth_pow(width) <= 5)
  | (((currentlyEnabled(Ext_W) & algebra_memory_bank == AlgebraMemory_W) & welen >= 64) & w_wlewidth_pow(width) <= 6)

function clause execute(W_WSSSEGTYPE(nf, wm, rs2, rs1, width, ws3)) = {
  let EEW_pow = w_wlewidth_pow(width);
  let EEW = 2 ^ EEW_pow;
  let load_width_bytes = 2 ^ (EEW_pow - 3);
  let W_SEW_pow = w_get_sew_pow();
  let W_LMUL_pow = w_get_lmul_pow();
  let EMUL_pow = EEW_pow - W_SEW_pow + W_LMUL_pow;

  assert(-3 <= EMUL_pow & EMUL_pow <= 3);

  let num_elem = w_get_num_elem(EMUL_pow, EEW);
  assert(num_elem > 0);

  if   w_illegal_wstart(W_WSTART_LOAD_STORE, num_elem, EMUL_pow)
   | w_illegal_store(ws3, nf, EEW, EMUL_pow)
   | not(w_valid_reg_group(ws3, EMUL_pow))
   | not(w_valid_wm_src_overlap(wm, ws3, EEW)) then {
    return Illegal_Instruction()
  };

  let EMUL_reg = 2 ^ max(EMUL_pow, 0);
  let wm_val = w_read_wmask(num_elem, wm, w_zwreg);
  let ws3_seg = w_read_wreg_seg(num_elem, load_width_bytes * 8, EMUL_pow, nf, ws3);
  let rs2_val = unsigned(w_get_scalar(rs2, xlen));

  let (n as 'n) = num_elem;
  let mask : bits('n) = w_init_masked_source(num_elem, EMUL_pow, wm_val);

  {
    let mask_view = w_shape(mask, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        // active segments
        w_set_wstart(to_bits(p));
        foreach (field from 0 to (nf - 1)) {
          let elem_offset = p * rs2_val + field * load_width_bytes;
          let vs = w_wregidx_offset(ws3, to_bits_unsafe(5, field * EMUL_reg));
          let data = w_read_element(load_width_bytes * 8, i, j, vs);
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

  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_WSSSEGTYPE(nf, wm, rs2, rs1, width, ws3)
 <-> "wss" ^ w_nfields_string(nf) ^ "e" ^ w_wlewidth_bitsnumberstr(width) ^ ".w" ^ spc() ^ w_wreg_name(ws3) ^ sep() ^ "(" ^ reg_name(rs1) ^ ")" ^ sep() ^ reg_name(rs2) ^ w_maybe_wmask(wm)

// ************************ Matrix Load Indexed (Ordered and Unordered) Normal & Segment (mop=0b01 or mop=0b11) *******
// Note: Zve64* extensions do not support EEW=64 for index values when XLEN=32.
union clause instruction = W_WLXSEGTYPE : (w_nfields, bits(1), wregidx, regidx, w_wlewidth, wregidx, w_indexed_mop)

mapping clause encdec = W_WLXSEGTYPE(nf, wm, ws2, rs1, width, wd, mop)
 <-> w_encdec_nfields(nf) @ 0b0 @ w_encdec_indexed_mop(mop) @ wm @ w_encdec_wreg(ws2) @ encdec_reg(rs1) @ w_encdec_wlewidth(width) @ w_encdec_wreg(wd) @ 0b0000111
 when (currentlyEnabled(Ext_W) & algebra_memory_bank == AlgebraMemory_W) & w_wlewidth_pow(width) <= w_max_index_eew_exp

// `mop` selects between the ordered and unordered variants of these instructions.  This function currently
// only implements the ordered variant, hence `mop` is ignored.
function clause execute(W_WLXSEGTYPE(nf, wm, ws2, rs1, width, wd, _mop)) = {
  let EEW_index_pow = w_wlewidth_pow(width);
  let EEW_index = 2 ^ EEW_index_pow;
  let EEW_index_bytes = 2 ^ (EEW_index_pow - 3);
  let EEW_data_pow = w_get_sew_pow();
  let EEW_data_bytes = w_get_sew_bytes();
  let EMUL_data_pow = w_get_lmul_pow();
  let EMUL_index_pow = EEW_index_pow - EEW_data_pow + EMUL_data_pow;
  let num_elem = w_get_num_elem(EMUL_data_pow, EEW_data_bytes * 8);
  assert(num_elem > 0);

  let index_dst_overlap : bool = if nf == 1 then {
      not(w_valid_reg_overlap(ws2, wd, EMUL_index_pow, EMUL_data_pow))
      // non-segment indexed load
    } else {
      not(w_valid_disjoint_reg_groups_segmented(ws2, wd, EMUL_index_pow, EMUL_data_pow, nf))
    }; // segment indexed load

  if   w_illegal_wstart(W_WSTART_LOAD_STORE, num_elem, EMUL_data_pow)
   | w_illegal_indexed_load(wd, wm, nf, 2 ^ EEW_index_pow, EMUL_index_pow, EMUL_data_pow)
   | index_dst_overlap
   | not(w_valid_wm_src_overlap(wm, ws2, EEW_index)) then {
    return Illegal_Instruction()
  };

  let EMUL_data_reg = if EMUL_data_pow <= 0 then {
      1
    } else {
      2 ^ EMUL_data_pow
    };
  let wm_val = w_read_wmask(num_elem, wm, w_zwreg);
  let wd_seg = w_read_wreg_seg(num_elem, EEW_data_bytes * 8, EMUL_data_pow, nf, wd);
  let ws2_val = w_read_wreg(num_elem, EEW_index_bytes * 8, EMUL_index_pow, ws2);

  let (m as 'm) = nf * EEW_data_bytes * 8;
  let (n as 'n) = num_elem;
  let (result, mask) : (vector('n, bits('m)), bits('n)) = w_init_masked_result(
    num_elem,
    nf * EEW_data_bytes * 8,
    EMUL_data_pow,
    wd_seg,
    wm_val,
  );

  // As mentioned above, currently mop = 1 (unordered) or 3 (ordered) do the same operations.
  {
    let mask_view = w_shape(mask, w_columns);
    let result_view = w_shape(result, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(result_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        // active segments
        w_set_wstart(to_bits(p));
        foreach (field from 0 to (nf - 1)) {
          let elem_offset : int = unsigned(ws2_val_view[i][j]) + field * EEW_data_bytes;
          match vmem_read(
            rs1,
            to_bits_unsafe(xlen, elem_offset),
            EEW_data_bytes,
            Load(Vector),
            false,
            false,
            false,
          ) {
            Ok(elem) => w_write_element(
              EEW_data_bytes * 8,
              i,
              j,
              w_wregidx_offset(wd, to_bits_unsafe(5, field * EMUL_data_reg)),
              elem,
            ),
            Err(e)   => return e,
          }
        }
      } else {
        // prestart, masked or tail segments
        foreach (field from 0 to (nf - 1)) {
          let skipped_elem = (result_view[i][j] >> (field * EEW_data_bytes * 8))[EEW_data_bytes * 8 - 1 .. 0];
          w_write_element(
            EEW_data_bytes * 8,
            i,
            j,
            w_wregidx_offset(wd, to_bits_unsafe(5, field * EMUL_data_reg)),
            skipped_elem,
          )
        }
      }
    }
  };

  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_WLXSEGTYPE(nf, wm, ws2, rs1, width, wd, mop)
 <-> "wl" ^ w_indexed_mop_mnemonic(mop) ^ "x" ^ w_nfields_string(nf) ^ "ei" ^ w_wlewidth_bitsnumberstr(width) ^ ".w" ^ spc() ^ w_wreg_name(wd) ^ sep() ^ "(" ^ reg_name(rs1) ^ ")" ^ sep() ^ w_wreg_name(ws2) ^ w_maybe_wmask(wm)

// *********************** Matrix Store Indexed (Ordered and Unordered) Normal & Segment (mop=0b01 or mop=0b11) *******
// Note: Zve64* extensions do not support EEW=64 for index values when XLEN=32.
union clause instruction = W_WSXSEGTYPE : (w_nfields, bits(1), wregidx, regidx, w_wlewidth, wregidx, w_indexed_mop)

mapping clause encdec = W_WSXSEGTYPE(nf, wm, ws2, rs1, width, ws3, mop)
 <-> w_encdec_nfields(nf) @ 0b0 @ w_encdec_indexed_mop(mop) @ wm @ w_encdec_wreg(ws2) @ encdec_reg(rs1) @ w_encdec_wlewidth(width) @ w_encdec_wreg(ws3) @ 0b0100111
 when ((currentlyEnabled(Ext_W) & algebra_memory_bank == AlgebraMemory_W) & w_wlewidth_pow(width) <= w_max_index_eew_exp)

// `mop` selects between the ordered and unordered variants of these instructions.  This function currently
// only implements the ordered variant, hence `mop` is ignored.
function clause execute(W_WSXSEGTYPE(nf, wm, ws2, rs1, width, ws3, _mop)) = {
  let EEW_index_pow = w_wlewidth_pow(width);
  let EEW_index = 2 ^ EEW_index_pow;
  let EEW_index_bytes = 2 ^ (EEW_index_pow - 3);
  let EEW_data_pow = w_get_sew_pow();
  let EEW_data = 2 ^ EEW_data_pow;
  let EEW_data_bytes = w_get_sew_bytes();
  let EMUL_data_pow = w_get_lmul_pow();
  let EMUL_index_pow = EEW_index_pow - EEW_data_pow + EMUL_data_pow;
  let num_elem = w_get_num_elem(EMUL_data_pow, EEW_data_bytes * 8); // number of data and indices are the same

  assert(num_elem > 0);

  if   w_illegal_wstart(W_WSTART_LOAD_STORE, num_elem, EMUL_data_pow)
   | w_illegal_indexed_store(ws3, nf, 2 ^ EEW_index_pow, EMUL_index_pow, EMUL_data_pow)
   | not(w_valid_src_overlap_segmented(ws2, EEW_index, EMUL_index_pow, ws3, EEW_data, EMUL_data_pow, nf))
   | not(w_valid_wm_src_overlap(wm, ws2, EEW_index))
   | not(w_valid_wm_src_overlap(wm, ws3, EEW_data)) then {
    return Illegal_Instruction()
  };

  let EMUL_data_reg = if EMUL_data_pow <= 0 then {
      1
    } else {
      2 ^ EMUL_data_pow
    };
  let wm_val = w_read_wmask(num_elem, wm, w_zwreg);
  let ws3_seg = w_read_wreg_seg(num_elem, EEW_data_bytes * 8, EMUL_data_pow, nf, ws3);
  let ws2_val = w_read_wreg(num_elem, EEW_index_bytes * 8, EMUL_index_pow, ws2);

  let (n as 'n) = num_elem;
  let mask : bits('n) = w_init_masked_source(num_elem, EMUL_data_pow, wm_val);

  // As mentioned above, currently mop = 1 (unordered) or 3 (ordered) do the same operations.
  {
    let mask_view = w_shape(mask, w_columns);
    let ws2_val_view = w_shape(ws2_val, w_columns);
    foreach (p from 0 to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(mask_view));
      assert(i < length(ws2_val_view));
      assert(j < w_columns);

      if mask_view[i][j] == 0b1 then {
        // active segments
        w_set_wstart(to_bits(p));
        foreach (field from 0 to (nf - 1)) {
          let elem_offset : int = unsigned(ws2_val_view[i][j]) + field * EEW_data_bytes;
          let vs = w_wregidx_offset(ws3, to_bits_unsafe(5, field * EMUL_data_reg));
          let data = w_read_element(EEW_data_bytes * 8, i, j, vs);
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

  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_WSXSEGTYPE(nf, wm, ws2, rs1, width, ws3, mop)
 <-> "ws" ^ w_indexed_mop_mnemonic(mop) ^ "x" ^ w_nfields_string(nf) ^ "ei" ^ w_wlewidth_bitsnumberstr(width) ^ ".w" ^ spc() ^ w_wreg_name(ws3) ^ sep() ^ "(" ^ reg_name(rs1) ^ ")" ^ sep() ^ w_wreg_name(ws2) ^ w_maybe_wmask(wm)

// **************** Matrix Load Unit-Stride Whole Register (wm=0b1, mop=0b00, lumop=0b01000) ******************
union clause instruction = W_WLRETYPE : (w_nfields_pow2, regidx, w_wlewidth, wregidx)

mapping clause encdec = W_WLRETYPE(nf, rs1, width, wd)
 <-> w_encdec_nfields_pow2(nf) @ 0b0 @ 0b00 @ 0b1 @ 0b01000 @ encdec_reg(rs1) @ w_encdec_wlewidth(width) @ w_encdec_wreg(wd) @ 0b0000111
 when ((currentlyEnabled(Ext_W) & algebra_memory_bank == AlgebraMemory_W) & w_wlewidth_pow(width) <= 5)
  | (((currentlyEnabled(Ext_W) & algebra_memory_bank == AlgebraMemory_W) & welen >= 64) & w_wlewidth_pow(width) <= 6)

function clause execute(W_WLRETYPE(nf, rs1, width, wd)) = {
  let EEW_pow = w_wlewidth_pow(width);
  let load_width_bytes = 2 ^ (EEW_pow - 3);
  let EEW = 2 ^ EEW_pow;
  let elem_per_reg = wlen / EEW;
  assert(elem_per_reg >= 0);

  if w_illegal_wstart(W_WSTART_LOAD_STORE, nf * elem_per_reg, 0) | not(w_valid_whole_register(wd, nf)) then {
    return Illegal_Instruction()
  };

  let start_element = w_get_start_element();

  // NOTE: Non-trapping path, wstart >= evl writes no elements. Currently
  // unreachable because illegal_wstart above always traps on out-of-bounds
  // wstart, but kept so this stays correct if that trap is ever made optional.
  if start_element >= nf * elem_per_reg then {
    return RETIRE_SUCCESS
  };
  let elem_to_align : int = start_element % elem_per_reg;
  var cur_field : int = start_element / elem_per_reg;
  var cur_elem : int = start_element;

  if elem_to_align > 0 then {
    {
      foreach (p from elem_to_align to (elem_per_reg - 1)) {
        let i = p / w_columns;
        let j = p % w_columns;
        assert(j < w_columns);

        w_set_wstart(to_bits_unsafe(16, cur_elem));
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
          Ok(elem) => w_write_element(
            load_width_bytes * 8,
            i,
            j,
            w_wregidx_offset(wd, to_bits_unsafe(5, cur_field)),
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
        let i = p / w_columns;
        let j = p % w_columns;
        assert(j < w_columns);

        w_set_wstart(to_bits_unsafe(16, cur_elem));
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
          Ok(elem) => w_write_element(
            load_width_bytes * 8,
            i,
            j,
            w_wregidx_offset(wd, to_bits_unsafe(5, field)),
            elem,
          ),
          Err(e)   => return e,
        };
        cur_elem = cur_elem + 1
      }
    }
  };

  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_WLRETYPE(nf, rs1, width, wd)
 <-> "wl" ^ w_nfields_pow2_string(nf) ^ "re" ^ w_wlewidth_bitsnumberstr(width) ^ ".w" ^ spc() ^ w_wreg_name(wd) ^ sep() ^ "(" ^ reg_name(rs1) ^ ")"

// **************** Matrix Store Unit-Stride Whole Register (wm=0b1, mop=0b00, sumop=0b01000) *****************
union clause instruction = W_WSRETYPE : (w_nfields_pow2, regidx, wregidx)

mapping clause encdec = W_WSRETYPE(nf, rs1, ws3)
 <-> w_encdec_nfields_pow2(nf) @ 0b0 @ 0b00 @ 0b1 @ 0b01000 @ encdec_reg(rs1) @ 0b000 @ w_encdec_wreg(ws3) @ 0b0100111
 when (currentlyEnabled(Ext_W) & algebra_memory_bank == AlgebraMemory_W)

function clause execute(W_WSRETYPE(nf, rs1, ws3)) = {
  let load_width_bytes = 1;
  let EEW = 8;
  let elem_per_reg = wlen / EEW;
  assert(elem_per_reg >= 0);

  if w_illegal_wstart(W_WSTART_LOAD_STORE, nf * elem_per_reg, 0) | not(w_valid_whole_register(ws3, nf)) then {
    return Illegal_Instruction()
  };

  let start_element = w_get_start_element();

  // NOTE: Non-trapping path, wstart >= evl writes no elements. Currently
  // unreachable because illegal_wstart above always traps on out-of-bounds
  // wstart, but kept so this stays correct if that trap is ever made optional.
  if start_element >= nf * elem_per_reg then {
    return RETIRE_SUCCESS
  };
  let elem_to_align : int = start_element % elem_per_reg;
  var cur_field : int = start_element / elem_per_reg;
  var cur_elem : int = start_element;

  if elem_to_align > 0 then {
    {
      foreach (p from elem_to_align to (elem_per_reg - 1)) {
        let i = p / w_columns;
        let j = p % w_columns;
        assert(j < w_columns);

        w_set_wstart(to_bits_unsafe(16, cur_elem));
        let elem_offset : int = cur_elem * load_width_bytes;
        let vs = w_wregidx_offset(ws3, to_bits_unsafe(5, cur_field));
        let data = w_read_element(load_width_bytes * 8, i, j, vs);
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
    let ws3_val = w_read_wreg(
      elem_per_reg,
      load_width_bytes * 8,
      0,
      w_wregidx_offset(ws3, to_bits_unsafe(5, field)),
    );
    {
      let ws3_val_view = w_shape(ws3_val, w_columns);
      foreach (p from 0 to (elem_per_reg - 1)) {
        let i = p / w_columns;
        let j = p % w_columns;
        assert(i < length(ws3_val_view));
        assert(j < w_columns);

        w_set_wstart(to_bits_unsafe(16, cur_elem));
        let elem_offset = cur_elem * load_width_bytes;
        match vmem_write(
          rs1,
          to_bits_unsafe(xlen, elem_offset),
          load_width_bytes,
          ws3_val_view[i][j],
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

  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping clause assembly = W_WSRETYPE(nf, rs1, ws3)
 <-> "ws" ^ w_nfields_pow2_string(nf) ^ "r.w" ^ spc() ^ w_wreg_name(ws3) ^ sep() ^ "(" ^ reg_name(rs1) ^ ")"

// ************* Matrix Mask Load/Store Unit-Stride (nf=0b000, mop=0b00, lumop or sumop=0b01011) **************
union clause instruction = W_WMTYPE : (regidx, wregidx, w_wmlsop)

mapping w_encdec_lsop : w_wmlsop <-> bits(7) = {
 W_WLM      <-> 0b0000111,
 W_WSM      <-> 0b0100111
}

mapping clause encdec = W_WMTYPE(rs1, wd_or_ws3, op)
 <-> 0b000 @ 0b0 @ 0b00 @ 0b1 @ 0b01011 @ encdec_reg(rs1) @ 0b000 @ w_encdec_wreg(wd_or_ws3) @ w_encdec_lsop(op)
 when (currentlyEnabled(Ext_W) & algebra_memory_bank == AlgebraMemory_W)

function clause execute(W_WMTYPE(rs1, wd_or_ws3, op)) = {
  let EEW = 8;
  let EMUL_pow = 0;
  let wl_val = unsigned(wl);
  let evl : int = if wl_val % 8 == 0 then {
      wl_val / 8
    } else {
      wl_val / 8 + 1
    }; // the effective matrix length is evl=ceil(wl/8)
  let num_elem = w_get_num_elem(EMUL_pow, EEW);

  if w_illegal_wstart(W_WSTART_LOAD_STORE, num_elem, EMUL_pow) | w_illegal_wd_unmasked() then {
    return Illegal_Instruction()
  };

  assert(evl >= 0);
  let start_element = w_get_start_element();
  let (n as 'n) = num_elem;
  let wd_or_ws3_val : vector('n, bits(8)) = w_read_wreg(num_elem, 8, 0, wd_or_ws3);

  {
    let wd_or_ws3_val_view = w_shape(wd_or_ws3_val, w_columns);
    foreach (p from start_element to (num_elem - 1)) {
      let i = p / w_columns;
      let j = p % w_columns;
      assert(i < length(wd_or_ws3_val_view));
      assert(j < w_columns);

      if p < evl then {
        // active elements
        w_set_wstart(to_bits(p));
        if op == W_WLM then {
          // load
          match vmem_read(rs1, to_bits_unsafe(xlen, p), 1, Load(Vector), false, false, false) {
            Ok(elem) => w_write_element(8, i, j, wd_or_ws3, elem),
            Err(e)   => return e,
          }
        } else {
          if op == W_WSM then {
            // store
            match vmem_write(
              rs1,
              to_bits_unsafe(xlen, p),
              1,
              wd_or_ws3_val_view[i][j],
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
        if op == W_WLM then {
          w_write_element(8, i, j, wd_or_ws3, wd_or_ws3_val_view[i][j])
          // TODO: configuration support for agnostic behavior
        }
      }
    }
  };

  w_set_wstart(zeros());
  RETIRE_SUCCESS
}

mapping w_vmtype_mnemonic : w_wmlsop <-> string = {
 W_WLM      <-> "wlm.w",
 W_WSM      <-> "wsm.w"
}

mapping clause assembly = W_WMTYPE(rs1, wd_or_ws3, op)
 <-> w_vmtype_mnemonic(op) ^ spc() ^ w_wreg_name(wd_or_ws3) ^ sep() ^ "(" ^ reg_name(rs1) ^ ")"
