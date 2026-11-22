// =======================================================================================
// This Sail RISC-W architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

newtype wregidx = Wregidx : bits(5)
newtype wregno = Wregno : range(0, 31)

function w_wregidx_to_wregno(Wregidx(b) : wregidx) -> wregno = Wregno(unsigned(b))
function w_wregno_to_wregidx(Wregno(b) : wregno) -> wregidx = Wregidx(to_bits(5, b))

function w_wregidx_offset(Wregidx(r) : wregidx, o : bits(5)) -> wregidx = Wregidx(r + o)
function w_wregidx_offset_range(Wregidx(r) : wregidx, o : range(0, 31)) -> wregidx = Wregidx(r + o)

overload operator + = { w_wregidx_offset, w_wregidx_offset_range }

function w_wregidx_bits(Wregidx(b) : wregidx) -> bits(5) = b

mapping w_encdec_wreg : wregidx <-> bits(5) = { Wregidx(r) <-> r }

val w_wreg_write_callback : (wregidx, wlenbits) -> unit
function w_wreg_write_callback(rid, value) = {
  if algebra_trace_writes then
    print_endline("ALGEBRA W " ^ dec_str(unsigned(w_wregidx_bits(rid))) ^ " " ^ hex_str(unsigned(value)))
}

let w_zwreg : wregidx = Wregidx(0b00000) // w0, default mask register

// matrix registers
register wr0 : wlenbits
register wr1 : wlenbits
register wr2 : wlenbits
register wr3 : wlenbits
register wr4 : wlenbits
register wr5 : wlenbits
register wr6 : wlenbits
register wr7 : wlenbits
register wr8 : wlenbits
register wr9 : wlenbits
register wr10 : wlenbits
register wr11 : wlenbits
register wr12 : wlenbits
register wr13 : wlenbits
register wr14 : wlenbits
register wr15 : wlenbits
register wr16 : wlenbits
register wr17 : wlenbits
register wr18 : wlenbits
register wr19 : wlenbits
register wr20 : wlenbits
register wr21 : wlenbits
register wr22 : wlenbits
register wr23 : wlenbits
register wr24 : wlenbits
register wr25 : wlenbits
register wr26 : wlenbits
register wr27 : wlenbits
register wr28 : wlenbits
register wr29 : wlenbits
register wr30 : wlenbits
register wr31 : wlenbits

mapping w_wreg_name_raw : bits(5) <-> string = {
  0b00000 <-> "w0",
  0b00001 <-> "w1",
  0b00010 <-> "w2",
  0b00011 <-> "w3",
  0b00100 <-> "w4",
  0b00101 <-> "w5",
  0b00110 <-> "w6",
  0b00111 <-> "w7",
  0b01000 <-> "w8",
  0b01001 <-> "w9",
  0b01010 <-> "w10",
  0b01011 <-> "w11",
  0b01100 <-> "w12",
  0b01101 <-> "w13",
  0b01110 <-> "w14",
  0b01111 <-> "w15",
  0b10000 <-> "w16",
  0b10001 <-> "w17",
  0b10010 <-> "w18",
  0b10011 <-> "w19",
  0b10100 <-> "w20",
  0b10101 <-> "w21",
  0b10110 <-> "w22",
  0b10111 <-> "w23",
  0b11000 <-> "w24",
  0b11001 <-> "w25",
  0b11010 <-> "w26",
  0b11011 <-> "w27",
  0b11100 <-> "w28",
  0b11101 <-> "w29",
  0b11110 <-> "w30",
  0b11111 <-> "w31"
}

mapping w_wreg_name : wregidx <-> string = { Wregidx(i) <-> w_wreg_name_raw(i) }

function w_rW(Wregno(r) : wregno) -> wlenbits = {
  match r {
    0 => wr0,
    1 => wr1,
    2 => wr2,
    3 => wr3,
    4 => wr4,
    5 => wr5,
    6 => wr6,
    7 => wr7,
    8 => wr8,
    9 => wr9,
    10 => wr10,
    11 => wr11,
    12 => wr12,
    13 => wr13,
    14 => wr14,
    15 => wr15,
    16 => wr16,
    17 => wr17,
    18 => wr18,
    19 => wr19,
    20 => wr20,
    21 => wr21,
    22 => wr22,
    23 => wr23,
    24 => wr24,
    25 => wr25,
    26 => wr26,
    27 => wr27,
    28 => wr28,
    29 => wr29,
    30 => wr30,
    31 => wr31,
  }
}

// W/Y state is independent of mstatus.VS and the W register bank.
// Internal emulator bookkeeping, not a new architectural CSR or mstatus bit.
register w_context_dirty : bool
function w_clear_context_dirty() -> unit = { w_context_dirty = false }
function w_dirty_w_context() -> unit = { w_context_dirty = true }

function w_wW(Wregno(r) : wregno, w : wlenbits) -> unit = {
  match r {
    0 => wr0 = w,
    1 => wr1 = w,
    2 => wr2 = w,
    3 => wr3 = w,
    4 => wr4 = w,
    5 => wr5 = w,
    6 => wr6 = w,
    7 => wr7 = w,
    8 => wr8 = w,
    9 => wr9 = w,
    10 => wr10 = w,
    11 => wr11 = w,
    12 => wr12 = w,
    13 => wr13 = w,
    14 => wr14 = w,
    15 => wr15 = w,
    16 => wr16 = w,
    17 => wr17 = w,
    18 => wr18 = w,
    19 => wr19 = w,
    20 => wr20 = w,
    21 => wr21 = w,
    22 => wr22 = w,
    23 => wr23 = w,
    24 => wr24 = w,
    25 => wr25 = w,
    26 => wr26 = w,
    27 => wr27 = w,
    28 => wr28 = w,
    29 => wr29 = w,
    30 => wr30 = w,
    31 => wr31 = w,
  };

  w_dirty_w_context();

  w_wreg_write_callback(w_wregno_to_wregidx(Wregno(r)), w)
}

function w_rW_bits(i : wregidx) -> wlenbits = w_rW(w_wregidx_to_wregno(i))

function w_wW_bits(i : wregidx, data : wlenbits) -> unit = {
  w_wW(w_wregidx_to_wregno(i)) = data
}

overload W = {w_rW_bits, w_wW_bits, w_rW, w_wW}

function w_init_wregs() -> unit = {
  let zero_wreg : wlenbits = zeros();
  wr0 = zero_wreg;
  wr1 = zero_wreg;
  wr2 = zero_wreg;
  wr3 = zero_wreg;
  wr4 = zero_wreg;
  wr5 = zero_wreg;
  wr6 = zero_wreg;
  wr7 = zero_wreg;
  wr8 = zero_wreg;
  wr9 = zero_wreg;
  wr10 = zero_wreg;
  wr11 = zero_wreg;
  wr12 = zero_wreg;
  wr13 = zero_wreg;
  wr14 = zero_wreg;
  wr15 = zero_wreg;
  wr16 = zero_wreg;
  wr17 = zero_wreg;
  wr18 = zero_wreg;
  wr19 = zero_wreg;
  wr20 = zero_wreg;
  wr21 = zero_wreg;
  wr22 = zero_wreg;
  wr23 = zero_wreg;
  wr24 = zero_wreg;
  wr25 = zero_wreg;
  wr26 = zero_wreg;
  wr27 = zero_wreg;
  wr28 = zero_wreg;
  wr29 = zero_wreg;
  wr30 = zero_wreg;
  wr31 = zero_wreg
}

// matrix csrs

// Although `wstart` is XLEN-bit wide, it is defined to have only
// enough writable bits to hold the largest element index (one less
// than the maximum WLMAX).The maximum matrix length is obtained with
// the largest LMUL setting (8) and the smallest SEW setting (8), so
// WLMAX_max = 8*WLEN/8 = WLEN. For example, for WLEN=256, wstart
// would have 8 bits to represent indices from 0 through 255.
register wstart : bits(wlen_exp)

// The number of bits implemented in wl depends on the
// implementation’s maximum matrix length of the smallest supported
// type. `wl` specifies a number of elements, which can be one greater
// than the last index.
register wl : bits(wlen_exp + 1)

let WLENB : xlenbits = to_bits(wlen / 8)

bitfield Wtype  : xlenbits = {
 will      : xlen - 1,
 w_reserved  : xlen - 2 .. 8,
 wma       : 7,
 wta       : 6,
 wsew      : 5 .. 3,
 wlmul     : 2 .. 0
}
register wtype : Wtype

type W_SEW_pow = range(3, 6)
type W_LMUL_pow = range(-3, 3)

function w_is_invalid_sew_pow(w : bits(3)) -> bool =
  w >_u 0b011

function w_is_invalid_lmul_pow(w : bits(3)) -> bool =
  w == 0b100

// The dynamic selected element width (SEW).
// This returns the power of 2 exponent in *bits* (hence the + 3).
function w_get_sew_pow() -> W_SEW_pow = {
  let sew_pow = unsigned(wtype[wsew]);
  assert(sew_pow < 4, "Reserved SEW stored in vtype register. This should be impossible.");
  sew_pow + 3
}

// Valid SEW sizes in bits.
type w_sew_bitsize = {8, 16, 32, 64}
type w_is_sew_bitsize('n) -> Bool = 'n in {8, 16, 32, 64}

// this returns the actual value of SEW
function w_get_sew() -> w_sew_bitsize =
  2 ^ w_get_sew_pow()

// this returns the value of SEW in bytes
function w_get_sew_bytes() -> {1, 2, 4, 8} =
  w_get_sew() / 8

// The matrix register group multiplier (LMUL).
// This returns the power of 2 exponent.
function w_get_lmul_pow() -> W_LMUL_pow = {
  let lmul_pow = signed(wtype[wlmul]);
  assert(lmul_pow > -4, "Reserved LMUL stored in vtype register. This should be impossible.");
  lmul_pow
}

enum w_agtype = { W_UNDISTURBED, W_AGNOSTIC }

function w_decode_agtype(ag : bits(1)) -> w_agtype = {
  match ag {
    0b0 => W_UNDISTURBED,
    0b1 => W_AGNOSTIC,
  }
}

function w_get_wtype_wma() -> w_agtype = w_decode_agtype(wtype[wma])

function w_get_wtype_wta() -> w_agtype = w_decode_agtype(wtype[wta])

bitfield Wcsr : bits(3) = {
 wxrm  : 2 .. 1,
 wxsat : 0
}
register wcsr : Wcsr

mapping clause csr_name_map = 0x800  <-> "wstart"
mapping clause csr_name_map = 0x801  <-> "wxsat"
mapping clause csr_name_map = 0x802  <-> "wxrm"
mapping clause csr_name_map = 0x803  <-> "wcsr"
mapping clause csr_name_map = 0xCC0  <-> "wl"
mapping clause csr_name_map = 0xCC1  <-> "wtype"
mapping clause csr_name_map = 0xCC2  <-> "wlenb"

function clause is_CSR_accessible(0x800, _, _) = currentlyEnabled(Ext_W) // wstart
function clause is_CSR_accessible(0x801, _, _) = currentlyEnabled(Ext_W) // wxsat
function clause is_CSR_accessible(0x802, _, _) = currentlyEnabled(Ext_W) // wxrm
function clause is_CSR_accessible(0x803, _, _) = currentlyEnabled(Ext_W) // wcsr
function clause is_CSR_accessible(0xCC0, _, _) = currentlyEnabled(Ext_W) // wl
function clause is_CSR_accessible(0xCC1, _, _) = currentlyEnabled(Ext_W) // wtype
function clause is_CSR_accessible(0xCC2, _, _) = currentlyEnabled(Ext_W) // wlenb

function clause is_CSR_exception_virtual(0x800, _, _) = false // wstart
function clause is_CSR_exception_virtual(0x801, _, _) = false // wxsat
function clause is_CSR_exception_virtual(0x802, _, _) = false // wxrm
function clause is_CSR_exception_virtual(0x803, _, _) = false // wcsr
function clause is_CSR_exception_virtual(0xCC0, _, _) = false // wl
function clause is_CSR_exception_virtual(0xCC1, _, _) = false // wtype
function clause is_CSR_exception_virtual(0xCC2, _, _) = false // wlenb

function clause read_CSR(0x800) = zero_extend(wstart)
function clause read_CSR(0x801) = zero_extend(wcsr[wxsat])
function clause read_CSR(0x802) = zero_extend(wcsr[wxrm])
function clause read_CSR(0x803) = zero_extend(wcsr.bits)
function clause read_CSR(0xCC0) = zero_extend(wl)
function clause read_CSR(0xCC1) = wtype.bits
function clause read_CSR(0xCC2) = WLENB

// Note: The spec recommends trapping if wstart is out of bounds but the
// current implementation does not yet do that.

function w_set_wstart(value : bits(16)) -> unit = {
  w_dirty_w_context();
  wstart = value[wlen_exp - 1 .. 0];
  csr_write_callback("wstart", zero_extend(wstart))
}

private function w_write_wcsr(wxrm_val : bits(2), wxsat_val : bits(1)) -> unit = {
  wcsr[wxrm] = wxrm_val; // Note: frm can be an illegal value, 101, 110, 111
  wcsr[wxsat] = wxsat_val;
  w_dirty_w_context()
}

function w_write_wxsat(wxsat_val : bits(1)) -> unit = {
  if wcsr[wxsat] != wxsat_val then {
    wcsr[wxsat] = wxsat_val;
    w_dirty_w_context()
  };
  csr_write_callback("wxsat", zero_extend(wcsr[wxsat]));
  csr_write_callback("wcsr", zero_extend(wcsr.bits))
}

function clause write_CSR(0x800, value) = {
  w_set_wstart(value[15 .. 0]);
  Ok(zero_extend(wstart))
}
function clause write_CSR(0x801, value) = {
  w_write_wcsr(wcsr[wxrm], value[0 .. 0]);
  Ok(zero_extend(wcsr[wxsat]))
}
function clause write_CSR(0x802, value) = {
  w_write_wcsr(value[1 .. 0], wcsr[wxsat]);
  Ok(zero_extend(wcsr[wxrm]))
}
function clause write_CSR(0x803, value) = {
  w_write_wcsr(value[2 .. 1], value[0 .. 0]);
  Ok(zero_extend(wcsr.bits))
}

// Reset only this extension's control state.
function w_reset() -> unit = {
  w_context_dirty = false;
  wstart = zeros();
  wl = zeros();
  wcsr.bits = zeros();
  wtype.bits = 0b1 @ zeros(xlen - 1)
}

// Emulator-level save/restore API; no new architectural CSR or instruction.
struct w_context_snapshot = {
  data : vector(32, wlenbits),
  start : bits(wlen_exp),
  active : bits(wlen_exp + 1),
  datatype : xlenbits,
  control : bits(3),
  dirty : bool
}
function w_save_context() -> w_context_snapshot = {
  var data : vector(32, wlenbits) = vector_init(zeros());
  foreach (p from 0 to 31) { data[p] = W(Wregno(p)) };
  struct { data = data, start = wstart, active = wl,
    datatype = wtype.bits, control = wcsr.bits, dirty = w_context_dirty }
}
function w_restore_context(saved : w_context_snapshot) -> unit = {
  foreach (p from 0 to 31) { W(Wregno(p)) = saved.data[p] };
  wstart = saved.start;
  wl = saved.active;
  wtype.bits = saved.datatype;
  wcsr.bits = saved.control;
  w_context_dirty = saved.dirty;
  csr_write_callback("wstart", zero_extend(wstart));
  csr_write_callback("wl", zero_extend(wl));
  csr_write_callback("wtype", wtype.bits);
  csr_write_callback("wcsr", zero_extend(wcsr.bits))
}
