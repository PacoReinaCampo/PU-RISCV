// =======================================================================================
// This Sail RISC-Y architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

newtype yregidx = Yregidx : bits(5)
newtype yregno = Yregno : range(0, 31)

function y_yregidx_to_yregno(Yregidx(b) : yregidx) -> yregno = Yregno(unsigned(b))
function y_yregno_to_yregidx(Yregno(b) : yregno) -> yregidx = Yregidx(to_bits(5, b))

function y_yregidx_offset(Yregidx(r) : yregidx, o : bits(5)) -> yregidx = Yregidx(r + o)
function y_yregidx_offset_range(Yregidx(r) : yregidx, o : range(0, 31)) -> yregidx = Yregidx(r + o)

overload operator + = { y_yregidx_offset, y_yregidx_offset_range }

function y_yregidx_bits(Yregidx(b) : yregidx) -> bits(5) = b

mapping y_encdec_yreg : yregidx <-> bits(5) = { Yregidx(r) <-> r }

val y_yreg_write_callback : (yregidx, ylenbits) -> unit
function y_yreg_write_callback(rid, value) = {
  if algebra_trace_writes then
    print_endline("ALGEBRA Y " ^ dec_str(unsigned(y_yregidx_bits(rid))) ^ " " ^ hex_str(unsigned(value)))
}

let y_zyreg : yregidx = Yregidx(0b00000) // y0, default mask register

// tensor registers
register yr0 : ylenbits
register yr1 : ylenbits
register yr2 : ylenbits
register yr3 : ylenbits
register yr4 : ylenbits
register yr5 : ylenbits
register yr6 : ylenbits
register yr7 : ylenbits
register yr8 : ylenbits
register yr9 : ylenbits
register yr10 : ylenbits
register yr11 : ylenbits
register yr12 : ylenbits
register yr13 : ylenbits
register yr14 : ylenbits
register yr15 : ylenbits
register yr16 : ylenbits
register yr17 : ylenbits
register yr18 : ylenbits
register yr19 : ylenbits
register yr20 : ylenbits
register yr21 : ylenbits
register yr22 : ylenbits
register yr23 : ylenbits
register yr24 : ylenbits
register yr25 : ylenbits
register yr26 : ylenbits
register yr27 : ylenbits
register yr28 : ylenbits
register yr29 : ylenbits
register yr30 : ylenbits
register yr31 : ylenbits

mapping y_yreg_name_raw : bits(5) <-> string = {
  0b00000 <-> "y0",
  0b00001 <-> "y1",
  0b00010 <-> "y2",
  0b00011 <-> "y3",
  0b00100 <-> "y4",
  0b00101 <-> "y5",
  0b00110 <-> "y6",
  0b00111 <-> "y7",
  0b01000 <-> "y8",
  0b01001 <-> "y9",
  0b01010 <-> "y10",
  0b01011 <-> "y11",
  0b01100 <-> "y12",
  0b01101 <-> "y13",
  0b01110 <-> "y14",
  0b01111 <-> "y15",
  0b10000 <-> "y16",
  0b10001 <-> "y17",
  0b10010 <-> "y18",
  0b10011 <-> "y19",
  0b10100 <-> "y20",
  0b10101 <-> "y21",
  0b10110 <-> "y22",
  0b10111 <-> "y23",
  0b11000 <-> "y24",
  0b11001 <-> "y25",
  0b11010 <-> "y26",
  0b11011 <-> "y27",
  0b11100 <-> "y28",
  0b11101 <-> "y29",
  0b11110 <-> "y30",
  0b11111 <-> "y31"
}

mapping y_yreg_name : yregidx <-> string = { Yregidx(i) <-> y_yreg_name_raw(i) }

function y_rY(Yregno(r) : yregno) -> ylenbits = {
  match r {
    0 => yr0,
    1 => yr1,
    2 => yr2,
    3 => yr3,
    4 => yr4,
    5 => yr5,
    6 => yr6,
    7 => yr7,
    8 => yr8,
    9 => yr9,
    10 => yr10,
    11 => yr11,
    12 => yr12,
    13 => yr13,
    14 => yr14,
    15 => yr15,
    16 => yr16,
    17 => yr17,
    18 => yr18,
    19 => yr19,
    20 => yr20,
    21 => yr21,
    22 => yr22,
    23 => yr23,
    24 => yr24,
    25 => yr25,
    26 => yr26,
    27 => yr27,
    28 => yr28,
    29 => yr29,
    30 => yr30,
    31 => yr31,
  }
}

// W/Y state is independent of mstatus.VS and the Y register bank.
// Internal emulator bookkeeping, not a new architectural CSR or mstatus bit.
register y_context_dirty : bool
function y_clear_context_dirty() -> unit = { y_context_dirty = false }
function y_dirty_y_context() -> unit = { y_context_dirty = true }

function y_wY(Yregno(r) : yregno, y : ylenbits) -> unit = {
  match r {
    0 => yr0 = y,
    1 => yr1 = y,
    2 => yr2 = y,
    3 => yr3 = y,
    4 => yr4 = y,
    5 => yr5 = y,
    6 => yr6 = y,
    7 => yr7 = y,
    8 => yr8 = y,
    9 => yr9 = y,
    10 => yr10 = y,
    11 => yr11 = y,
    12 => yr12 = y,
    13 => yr13 = y,
    14 => yr14 = y,
    15 => yr15 = y,
    16 => yr16 = y,
    17 => yr17 = y,
    18 => yr18 = y,
    19 => yr19 = y,
    20 => yr20 = y,
    21 => yr21 = y,
    22 => yr22 = y,
    23 => yr23 = y,
    24 => yr24 = y,
    25 => yr25 = y,
    26 => yr26 = y,
    27 => yr27 = y,
    28 => yr28 = y,
    29 => yr29 = y,
    30 => yr30 = y,
    31 => yr31 = y,
  };

  y_dirty_y_context();

  y_yreg_write_callback(y_yregno_to_yregidx(Yregno(r)), y)
}

function y_rY_bits(i : yregidx) -> ylenbits = y_rY(y_yregidx_to_yregno(i))

function y_wY_bits(i : yregidx, data : ylenbits) -> unit = {
  y_wY(y_yregidx_to_yregno(i)) = data
}

overload Y = {y_rY_bits, y_wY_bits, y_rY, y_wY}

function y_init_yregs() -> unit = {
  let zero_yreg : ylenbits = zeros();
  yr0 = zero_yreg;
  yr1 = zero_yreg;
  yr2 = zero_yreg;
  yr3 = zero_yreg;
  yr4 = zero_yreg;
  yr5 = zero_yreg;
  yr6 = zero_yreg;
  yr7 = zero_yreg;
  yr8 = zero_yreg;
  yr9 = zero_yreg;
  yr10 = zero_yreg;
  yr11 = zero_yreg;
  yr12 = zero_yreg;
  yr13 = zero_yreg;
  yr14 = zero_yreg;
  yr15 = zero_yreg;
  yr16 = zero_yreg;
  yr17 = zero_yreg;
  yr18 = zero_yreg;
  yr19 = zero_yreg;
  yr20 = zero_yreg;
  yr21 = zero_yreg;
  yr22 = zero_yreg;
  yr23 = zero_yreg;
  yr24 = zero_yreg;
  yr25 = zero_yreg;
  yr26 = zero_yreg;
  yr27 = zero_yreg;
  yr28 = zero_yreg;
  yr29 = zero_yreg;
  yr30 = zero_yreg;
  yr31 = zero_yreg
}

// tensor csrs

// Although `ystart` is XLEN-bit wide, it is defined to have only
// enough writable bits to hold the largest element index (one less
// than the maximum YLMAX).The maximum tensor length is obtained with
// the largest LMUL setting (8) and the smallest SEW setting (8), so
// YLMAX_max = 8*YLEN/8 = YLEN. For example, for YLEN=256, ystart
// would have 8 bits to represent indices from 0 through 255.
register ystart : bits(ylen_exp)

// The number of bits implemented in yl depends on the
// implementation’s maximum tensor length of the smallest supported
// type. `yl` specifies a number of elements, which can be one greater
// than the last index.
register yl : bits(ylen_exp + 1)

let YLENB : xlenbits = to_bits(ylen / 8)

bitfield Ytype  : xlenbits = {
 yill      : xlen - 1,
 y_reserved  : xlen - 2 .. 8,
 yma       : 7,
 yta       : 6,
 ysew      : 5 .. 3,
 ylmul     : 2 .. 0
}
register ytype : Ytype

type Y_SEW_pow = range(3, 6)
type Y_LMUL_pow = range(-3, 3)

function y_is_invalid_sew_pow(y : bits(3)) -> bool =
  y >_u 0b011

function y_is_invalid_lmul_pow(y : bits(3)) -> bool =
  y == 0b100

// The dynamic selected element width (SEW).
// This returns the power of 2 exponent in *bits* (hence the + 3).
function y_get_sew_pow() -> Y_SEW_pow = {
  let sew_pow = unsigned(ytype[ysew]);
  assert(sew_pow < 4, "Reserved SEW stored in vtype register. This should be impossible.");
  sew_pow + 3
}

// Valid SEW sizes in bits.
type y_sew_bitsize = {8, 16, 32, 64}
type y_is_sew_bitsize('n) -> Bool = 'n in {8, 16, 32, 64}

// this returns the actual value of SEW
function y_get_sew() -> y_sew_bitsize =
  2 ^ y_get_sew_pow()

// this returns the value of SEW in bytes
function y_get_sew_bytes() -> {1, 2, 4, 8} =
  y_get_sew() / 8

// The tensor register group multiplier (LMUL).
// This returns the power of 2 exponent.
function y_get_lmul_pow() -> Y_LMUL_pow = {
  let lmul_pow = signed(ytype[ylmul]);
  assert(lmul_pow > -4, "Reserved LMUL stored in vtype register. This should be impossible.");
  lmul_pow
}

enum y_agtype = { Y_UNDISTURBED, Y_AGNOSTIC }

function y_decode_agtype(ag : bits(1)) -> y_agtype = {
  match ag {
    0b0 => Y_UNDISTURBED,
    0b1 => Y_AGNOSTIC,
  }
}

function y_get_ytype_yma() -> y_agtype = y_decode_agtype(ytype[yma])

function y_get_ytype_yta() -> y_agtype = y_decode_agtype(ytype[yta])

bitfield Ycsr : bits(3) = {
 yxrm  : 2 .. 1,
 yxsat : 0
}
register ycsr : Ycsr

mapping clause csr_name_map = 0x804  <-> "ystart"
mapping clause csr_name_map = 0x805  <-> "yxsat"
mapping clause csr_name_map = 0x806  <-> "yxrm"
mapping clause csr_name_map = 0x807  <-> "ycsr"
mapping clause csr_name_map = 0xCC4  <-> "yl"
mapping clause csr_name_map = 0xCC5  <-> "ytype"
mapping clause csr_name_map = 0xCC6  <-> "ylenb"

function clause is_CSR_accessible(0x804, _, _) = currentlyEnabled(Ext_Y) // ystart
function clause is_CSR_accessible(0x805, _, _) = currentlyEnabled(Ext_Y) // yxsat
function clause is_CSR_accessible(0x806, _, _) = currentlyEnabled(Ext_Y) // yxrm
function clause is_CSR_accessible(0x807, _, _) = currentlyEnabled(Ext_Y) // ycsr
function clause is_CSR_accessible(0xCC4, _, _) = currentlyEnabled(Ext_Y) // yl
function clause is_CSR_accessible(0xCC5, _, _) = currentlyEnabled(Ext_Y) // ytype
function clause is_CSR_accessible(0xCC6, _, _) = currentlyEnabled(Ext_Y) // ylenb

function clause is_CSR_exception_virtual(0x804, _, _) = false // ystart
function clause is_CSR_exception_virtual(0x805, _, _) = false // yxsat
function clause is_CSR_exception_virtual(0x806, _, _) = false // yxrm
function clause is_CSR_exception_virtual(0x807, _, _) = false // ycsr
function clause is_CSR_exception_virtual(0xCC4, _, _) = false // yl
function clause is_CSR_exception_virtual(0xCC5, _, _) = false // ytype
function clause is_CSR_exception_virtual(0xCC6, _, _) = false // ylenb

function clause read_CSR(0x804) = zero_extend(ystart)
function clause read_CSR(0x805) = zero_extend(ycsr[yxsat])
function clause read_CSR(0x806) = zero_extend(ycsr[yxrm])
function clause read_CSR(0x807) = zero_extend(ycsr.bits)
function clause read_CSR(0xCC4) = zero_extend(yl)
function clause read_CSR(0xCC5) = ytype.bits
function clause read_CSR(0xCC6) = YLENB

// Note: The spec recommends trapping if ystart is out of bounds but the
// current implementation does not yet do that.

function y_set_ystart(value : bits(16)) -> unit = {
  y_dirty_y_context();
  ystart = value[ylen_exp - 1 .. 0];
  csr_write_callback("ystart", zero_extend(ystart))
}

private function y_write_ycsr(yxrm_val : bits(2), yxsat_val : bits(1)) -> unit = {
  ycsr[yxrm] = yxrm_val; // Note: frm can be an illegal value, 101, 110, 111
  ycsr[yxsat] = yxsat_val;
  y_dirty_y_context()
}

function y_write_yxsat(yxsat_val : bits(1)) -> unit = {
  if ycsr[yxsat] != yxsat_val then {
    ycsr[yxsat] = yxsat_val;
    y_dirty_y_context()
  };
  csr_write_callback("yxsat", zero_extend(ycsr[yxsat]));
  csr_write_callback("ycsr", zero_extend(ycsr.bits))
}

function clause write_CSR(0x804, value) = {
  y_set_ystart(value[15 .. 0]);
  Ok(zero_extend(ystart))
}
function clause write_CSR(0x805, value) = {
  y_write_ycsr(ycsr[yxrm], value[0 .. 0]);
  Ok(zero_extend(ycsr[yxsat]))
}
function clause write_CSR(0x806, value) = {
  y_write_ycsr(value[1 .. 0], ycsr[yxsat]);
  Ok(zero_extend(ycsr[yxrm]))
}
function clause write_CSR(0x807, value) = {
  y_write_ycsr(value[2 .. 1], value[0 .. 0]);
  Ok(zero_extend(ycsr.bits))
}

// Reset only this extension's control state.
function y_reset() -> unit = {
  y_context_dirty = false;
  ystart = zeros();
  yl = zeros();
  ycsr.bits = zeros();
  ytype.bits = 0b1 @ zeros(xlen - 1)
}

// Emulator-level save/restore API; no new architectural CSR or instruction.
struct y_context_snapshot = {
  data : vector(32, ylenbits),
  start : bits(ylen_exp),
  active : bits(ylen_exp + 1),
  datatype : xlenbits,
  control : bits(3),
  dirty : bool
}
function y_save_context() -> y_context_snapshot = {
  var data : vector(32, ylenbits) = vector_init(zeros());
  foreach (p from 0 to 31) { data[p] = Y(Yregno(p)) };
  struct { data = data, start = ystart, active = yl,
    datatype = ytype.bits, control = ycsr.bits, dirty = y_context_dirty }
}
function y_restore_context(saved : y_context_snapshot) -> unit = {
  foreach (p from 0 to 31) { Y(Yregno(p)) = saved.data[p] };
  ystart = saved.start;
  yl = saved.active;
  ytype.bits = saved.datatype;
  ycsr.bits = saved.control;
  y_context_dirty = saved.dirty;
  csr_write_callback("ystart", zero_extend(ystart));
  csr_write_callback("yl", zero_extend(yl));
  csr_write_callback("ytype", ytype.bits);
  csr_write_callback("ycsr", zero_extend(ycsr.bits))
}
