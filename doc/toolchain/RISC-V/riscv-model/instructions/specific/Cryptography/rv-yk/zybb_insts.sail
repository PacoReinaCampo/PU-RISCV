// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

function xy_crypto_bb_enabled() -> bool = (config extensions.Xy.crypto.bb : bool) & xy_enabled()
function xy_crypto_kb_enabled() -> bool = ((config extensions.Xy.crypto.kb : bool) & xy_enabled()) | xy_crypto_bb_enabled()

union clause instruction = XYK_YANDN_YY : (bits(1), yregidx, yregidx, yregidx)

$[wavedrom "_ _ _ _ OPIYY _ CUSTOM-1"]
mapping clause encdec = XYK_YANDN_YY(ym, ys1, ys2, yd)
  <-> 0b000001 @ ym @ encdec_yreg(ys2) @ encdec_yreg(ys1) @ 0b000 @ encdec_yreg(yd) @ 0b0101011
  when valid_ytype() & xy_crypto_kb_enabled() & (y_get_sew() <= 32 | (y_get_sew() == 64 & xy_64_enabled()))

mapping clause assembly = XYK_YANDN_YY(ym, ys1, ys2, yd)
  <-> "yandn.yy" ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2) ^ sep() ^ yreg_name(ys1) ^ maybe_ymask(ym)

function clause execute XYK_YANDN_YY(ym, ys1, ys2, yd) = {
  let SEW      = y_get_sew();
  let LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(LMUL_pow, SEW);

  if not(y_valid_reg_group(ys1, LMUL_pow)) |
     not(y_valid_reg_group(ys2, LMUL_pow)) |
     not(y_valid_reg_group(yd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let ym_val  : bits('n) = read_ymask(num_elem, ym, zyreg);
  let ys1_val : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, ys1);
  let ys2_val : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let yd_val  : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match y_init_masked_result(num_elem, SEW, LMUL_pow, yd_val, ym_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j][k] == 0b1 then
      result[i][j][k] = ~(ys1_val[i][j][k]) & ys2_val[i][j][k];
  };
  write_yreg(num_elem, SEW, LMUL_pow, yd, result);
  set_ystart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XYK_YANDN_YX : (bits(1), yregidx, regidx, yregidx)

$[wavedrom "_ _ _ _ OPIYX _ CUSTOM-1"]
mapping clause encdec = XYK_YANDN_YX(ym, ys2, rs1, yd)
  <-> 0b000001 @ ym @ encdec_yreg(ys2) @ encdec_reg(rs1) @ 0b100 @ encdec_yreg(yd) @ 0b0101011
  when valid_ytype() & xy_crypto_kb_enabled() & (y_get_sew() <= 32 | (y_get_sew() == 64 & xy_64_enabled()))

mapping clause assembly = XYK_YANDN_YX(ym, ys2, rs1, yd)
  <-> "yandn.yx" ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2) ^ sep() ^ reg_name(rs1) ^ maybe_ymask(ym)

function clause execute XYK_YANDN_YX(ym, ys2, rs1, yd) = {
  let SEW      = y_get_sew();
  let LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(LMUL_pow, SEW);

  if not(y_valid_reg_group(ys2, LMUL_pow)) |
     not(y_valid_reg_group(yd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let ym_val  : bits('n) = read_ymask(num_elem, ym, zyreg);
  let rs1_val : bits('m) = y_get_scalar(rs1, SEW);
  let ys2_val : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let yd_val  : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match y_init_masked_result(num_elem, SEW, LMUL_pow, yd_val, ym_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem- 1)) {
    if mask[i][j][k] == 0b1 then
      result[i][j][k] = ~(rs1_val) & ys2_val[i][j][k];
  };
  write_yreg(num_elem, SEW, LMUL_pow, yd, result);
  set_ystart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XYK_YBREY_Y : (bits(1), yregidx, yregidx)

$[wavedrom "_ _ _ _ OPMYY _ CUSTOM-1"]
mapping clause encdec = XYK_YBREY_Y(ym, ys2, yd)
  <-> 0b010010 @ ym @ encdec_yreg(ys2) @ 0b01010 @ 0b010 @ encdec_yreg(yd) @ 0b0101011
  when valid_ytype() & xy_crypto_bb_enabled() & (y_get_sew() <= 32 | (y_get_sew() == 64 & xy_64_enabled()))

mapping clause assembly = XYK_YBREY_Y(ym, ys2, yd)
  <-> "ybrev.y" ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2) ^ maybe_ymask(ym)

function clause execute XYK_YBREY_Y(ym, ys2, yd) = {
  let SEW      = y_get_sew();
  let LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(LMUL_pow, SEW);

  if not(y_valid_reg_group(ys2, LMUL_pow)) |
     not(y_valid_reg_group(yd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let ym_val  : bits('n) = read_ymask(num_elem, ym, zyreg);
  let ys2_val : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let yd_val  : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match y_init_masked_result(num_elem, SEW, LMUL_pow, yd_val, ym_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j][k] == 0b1 then {
      var output : bits('m) = zeros();
      foreach (j from 0 to (SEW - 1))
        output[SEW - 1 - j] = ys2_val[i][j][k][j];
      result[i][j][k] = output;
    };
  };
  write_yreg(num_elem, SEW, LMUL_pow, yd, result);
  set_ystart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XYK_YBREY8_Y : (bits(1), yregidx, yregidx)

$[wavedrom "_ _ _ _ OPMYY _ CUSTOM-1"]
mapping clause encdec = XYK_YBREY8_Y(ym, ys2, yd)
  <-> 0b010010 @ ym @ encdec_yreg(ys2) @ 0b01000 @ 0b010 @ encdec_yreg(yd) @ 0b0101011
  when valid_ytype() & xy_crypto_kb_enabled() & (y_get_sew() <= 32 | (y_get_sew() == 64 & xy_64_enabled()))

mapping clause assembly = XYK_YBREY8_Y(ym, ys2, yd)
  <-> "ybrev8.y" ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2) ^ maybe_ymask(ym)

function clause execute XYK_YBREY8_Y(ym, ys2, yd) = {
  let SEW      = y_get_sew();
  let LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(LMUL_pow, SEW);

  if not(y_valid_reg_group(ys2, LMUL_pow)) |
     not(y_valid_reg_group(yd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let ym_val  : bits('n) = read_ymask(num_elem, ym, zyreg);
  let ys2_val : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let yd_val  : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match y_init_masked_result(num_elem, SEW, LMUL_pow, yd_val, ym_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j][k] == 0b1 then {
      result[i][j][k] = brev8(ys2_val[i][j][k]);
    };
  };
  write_yreg(num_elem, SEW, LMUL_pow, yd, result);
  set_ystart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XYK_YREY8_Y : (bits(1), yregidx, yregidx)

$[wavedrom "_ _ _ _ OPMYY _ CUSTOM-1"]
mapping clause encdec = XYK_YREY8_Y(ym, ys2, yd)
  <-> 0b010010 @ ym @ encdec_yreg(ys2) @ 0b01001 @ 0b010 @ encdec_yreg(yd) @ 0b0101011
  when valid_ytype() & xy_crypto_kb_enabled() & (y_get_sew() <= 32 | (y_get_sew() == 64 & xy_64_enabled()))

mapping clause assembly = XYK_YREY8_Y(ym, ys2, yd)
  <-> "yrev8.y" ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2) ^ maybe_ymask(ym)

function clause execute XYK_YREY8_Y(ym, ys2, yd) = {
  let SEW      = y_get_sew();
  let LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(LMUL_pow, SEW);

  if not(y_valid_reg_group(ys2, LMUL_pow)) |
     not(y_valid_reg_group(yd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let ym_val  : bits('n) = read_ymask(num_elem, ym, zyreg);
  let ys2_val : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let yd_val  : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match y_init_masked_result(num_elem, SEW, LMUL_pow, yd_val, ym_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j][k] == 0b1 then {
      result[i][j][k] = rev8(ys2_val[i][j][k]);
    };
  };
  write_yreg(num_elem, SEW, LMUL_pow, yd, result);
  set_ystart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XYK_YCLZ_Y : (bits(1), yregidx, yregidx)

$[wavedrom "_ _ _ _ OPMYY _ CUSTOM-1"]
mapping clause encdec = XYK_YCLZ_Y (ym, ys2, yd)
  <-> 0b010010 @ ym @ encdec_yreg(ys2) @ 0b01100 @ 0b010 @ encdec_yreg(yd) @ 0b0101011
  when valid_ytype() & xy_crypto_bb_enabled() & (y_get_sew() <= 32 | (y_get_sew() == 64 & xy_64_enabled()))

mapping clause assembly = XYK_YCLZ_Y (ym, ys2, yd)
  <-> "yclz.y" ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2) ^ maybe_ymask(ym)

function clause execute XYK_YCLZ_Y(ym, ys2, yd) = {
  let SEW      = y_get_sew();
  let LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(LMUL_pow, SEW);

  if not(y_valid_reg_group(ys2, LMUL_pow)) |
     not(y_valid_reg_group(yd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let ym_val  : bits('n) = read_ymask(num_elem, ym, zyreg);
  let ys2_val : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let yd_val  : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match y_init_masked_result(num_elem, SEW, LMUL_pow, yd_val, ym_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j][k] == 0b1 then {
      let clz = count_leading_zeros(ys2_val[i][j][k]);
      result[i][j][k] = to_bits(clz);
    };
  };
  write_yreg(num_elem, SEW, LMUL_pow, yd, result);
  set_ystart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XYK_YCTZ_Y : (bits(1), yregidx, yregidx)

$[wavedrom "_ _ _ _ OPMYY _ CUSTOM-1"]
mapping clause encdec = XYK_YCTZ_Y (ym, ys2, yd)
  <-> 0b010010 @ ym @ encdec_yreg(ys2) @ 0b01101 @ 0b010 @ encdec_yreg(yd) @ 0b0101011
  when valid_ytype() & xy_crypto_bb_enabled() & (y_get_sew() <= 32 | (y_get_sew() == 64 & xy_64_enabled()))

mapping clause assembly = XYK_YCTZ_Y (ym, ys2, yd)
  <-> "yctz.y" ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2) ^ maybe_ymask(ym)

function clause execute XYK_YCTZ_Y(ym, ys2, yd) = {
  let SEW      = y_get_sew();
  let LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(LMUL_pow, SEW);

  if not(y_valid_reg_group(ys2, LMUL_pow)) |
     not(y_valid_reg_group(yd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let ym_val  : bits('n) = read_ymask(num_elem, ym, zyreg);
  let ys2_val : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let yd_val  : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match y_init_masked_result(num_elem, SEW, LMUL_pow, yd_val, ym_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j][k] == 0b1 then {
      let ctz = count_trailing_zeros(ys2_val[i][j][k]);
      result[i][j][k] = to_bits(ctz);
    };
  };
  write_yreg(num_elem, SEW, LMUL_pow, yd, result);
  set_ystart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XYK_YCPOP_Y : (bits(1), yregidx, yregidx)

$[wavedrom "_ _ _ _ OPMYY _ CUSTOM-1"]
mapping clause encdec = XYK_YCPOP_Y (ym, ys2, yd)
  <-> 0b010010 @ ym @ encdec_yreg(ys2) @ 0b01110 @ 0b010 @ encdec_yreg(yd) @ 0b0101011
  when valid_ytype() & xy_crypto_bb_enabled() & (y_get_sew() <= 32 | (y_get_sew() == 64 & xy_64_enabled()))

mapping clause assembly = XYK_YCPOP_Y (ym, ys2, yd)
  <-> "ycpop.y" ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2) ^ maybe_ymask(ym)

function clause execute XYK_YCPOP_Y(ym, ys2, yd) = {
  let SEW      = y_get_sew();
  let LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(LMUL_pow, SEW);

  if not(y_valid_reg_group(ys2, LMUL_pow)) |
     not(y_valid_reg_group(yd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let ym_val  : bits('n) = read_ymask(num_elem, ym, zyreg);
  let ys2_val : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let yd_val  : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match y_init_masked_result(num_elem, SEW, LMUL_pow, yd_val, ym_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j][k] == 0b1 then {
      foreach (j from 0 to (SEW - 1)) {
        if ys2_val[i][j][k][j] == 0b1 then {
          result[i][j][k] = result[i][j][k] + 1;
        };
      }
    };
  };
  write_yreg(num_elem, SEW, LMUL_pow, yd, result);
  set_ystart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XYK_YROL_YY : (bits(1), yregidx, yregidx, yregidx)

$[wavedrom "_ _ _ _ OPIYY _ CUSTOM-1"]
mapping clause encdec = XYK_YROL_YY(ym, ys1, ys2, yd)
  <-> 0b010101 @ ym @ encdec_yreg(ys2) @ encdec_yreg(ys1) @ 0b000 @ encdec_yreg(yd) @ 0b0101011
  when valid_ytype() & xy_crypto_kb_enabled() & (y_get_sew() <= 32 | (y_get_sew() == 64 & xy_64_enabled()))

mapping clause assembly = XYK_YROL_YY(ym, ys1, ys2, yd)
 <-> "yrol.yy" ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2) ^ sep() ^ yreg_name(ys1) ^ maybe_ymask(ym)

function clause execute XYK_YROL_YY(ym, ys1, ys2, yd) = {
  let SEW_pow  = y_get_sew_pow();
  let SEW      = 2 ^ SEW_pow;
  let LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(LMUL_pow, SEW);

  if not(y_valid_reg_group(ys1, LMUL_pow)) |
     not(y_valid_reg_group(ys2, LMUL_pow)) |
     not(y_valid_reg_group(yd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let ym_val  : bits('n) = read_ymask(num_elem, ym, zyreg);
  let ys1_val : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, ys1);
  let ys2_val : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let yd_val  : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match y_init_masked_result(num_elem, SEW, LMUL_pow, yd_val, ym_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j][k] == 0b1 then
      result[i][j][k] = ys2_val[i][j][k] <<< ys1_val[i][j][k][SEW_pow - 1 .. 0];
  };
  write_yreg(num_elem, SEW, LMUL_pow, yd, result);
  set_ystart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XYK_YROL_YX : (bits(1), yregidx, regidx, yregidx)

$[wavedrom "_ _ _ _ OPIYX _ CUSTOM-1"]
mapping clause encdec = XYK_YROL_YX(ym, ys2, rs1, yd)
  <-> 0b010101 @ ym @ encdec_yreg(ys2) @ encdec_reg(rs1) @ 0b100 @ encdec_yreg(yd) @ 0b0101011
  when valid_ytype() & xy_crypto_kb_enabled() & (y_get_sew() <= 32 | (y_get_sew() == 64 & xy_64_enabled()))

mapping clause assembly = XYK_YROL_YX(ym, ys2, rs1, yd)
 <-> "yrol.yx" ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2) ^ sep() ^ reg_name(rs1) ^ maybe_ymask(ym)

function clause execute XYK_YROL_YX(ym, ys2, rs1, yd) = {
  let SEW_pow  = y_get_sew_pow();
  let SEW      = 2 ^ SEW_pow;
  let LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(LMUL_pow, SEW);

  if not(y_valid_reg_group(ys2, LMUL_pow)) |
     not(y_valid_reg_group(yd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let ym_val  : bits('n) = read_ymask(num_elem, ym, zyreg);
  let rs1_val : bits('m) = y_get_scalar(rs1, SEW);
  let ys2_val : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let yd_val  : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match y_init_masked_result(num_elem, SEW, LMUL_pow, yd_val, ym_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j][k] == 0b1 then
      result[i][j][k] = ys2_val[i][j][k] <<< rs1_val[SEW_pow - 1 .. 0];
  };
  write_yreg(num_elem, SEW, LMUL_pow, yd, result);
  set_ystart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XYK_YROR_YY : (bits(1), yregidx, yregidx, yregidx)

$[wavedrom "_ _ _ _ OPIYY _ CUSTOM-1"]
mapping clause encdec = XYK_YROR_YY(ym, ys1, ys2, yd)
  <-> 0b010100 @ ym @ encdec_yreg(ys2) @ encdec_yreg(ys1) @ 0b000 @ encdec_yreg(yd) @ 0b0101011
  when valid_ytype() & xy_crypto_kb_enabled() & (y_get_sew() <= 32 | (y_get_sew() == 64 & xy_64_enabled()))

mapping clause assembly = XYK_YROR_YY(ym, ys1, ys2, yd)
 <-> "yror.yy" ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2) ^ sep() ^ yreg_name(ys1) ^ maybe_ymask(ym)

function clause execute XYK_YROR_YY(ym, ys1, ys2, yd) = {
  let SEW_pow  = y_get_sew_pow();
  let SEW      = 2 ^ SEW_pow;
  let LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(LMUL_pow, SEW);

  if not(y_valid_reg_group(ys1, LMUL_pow)) |
     not(y_valid_reg_group(ys2, LMUL_pow)) |
     not(y_valid_reg_group(yd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let ym_val  : bits('n) = read_ymask(num_elem, ym, zyreg);
  let ys1_val : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, ys1);
  let ys2_val : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let yd_val  : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match y_init_masked_result(num_elem, SEW, LMUL_pow, yd_val, ym_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j][k] == 0b1 then
      result[i][j][k] = ys2_val[i][j][k] >>> ys1_val[i][j][k][SEW_pow - 1 .. 0];
  };
  write_yreg(num_elem, SEW, LMUL_pow, yd, result);
  set_ystart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XYK_YROR_YX : (bits(1), yregidx, regidx, yregidx)

$[wavedrom "_ _ _ _ OPIYX _ CUSTOM-1"]
mapping clause encdec = XYK_YROR_YX(ym, ys2, rs1, yd)
  <-> 0b010100 @ ym @ encdec_yreg(ys2) @ encdec_reg(rs1) @ 0b100 @ encdec_yreg(yd) @ 0b0101011
  when valid_ytype() & xy_crypto_kb_enabled() & (y_get_sew() <= 32 | (y_get_sew() == 64 & xy_64_enabled()))

mapping clause assembly = XYK_YROR_YX(ym, ys2, rs1, yd)
 <-> "yror.yx" ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2) ^ sep() ^ reg_name(rs1)^ maybe_ymask(ym)

function clause execute XYK_YROR_YX(ym, ys2, rs1, yd) = {
  let SEW_pow  = y_get_sew_pow();
  let SEW      = 2 ^ SEW_pow;
  let LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(LMUL_pow, SEW);

  if not(y_valid_reg_group(ys2, LMUL_pow)) |
     not(y_valid_reg_group(yd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let ym_val  : bits('n) = read_ymask(num_elem, ym, zyreg);
  let rs1_val : bits('m) = y_get_scalar(rs1, SEW);
  let ys2_val : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let yd_val  : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match y_init_masked_result(num_elem, SEW, LMUL_pow, yd_val, ym_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j][k] == 0b1 then
      result[i][j][k] = ys2_val[i][j][k] >>> rs1_val[SEW_pow - 1 .. 0];
  };
  write_yreg(num_elem, SEW, LMUL_pow, yd, result);
  set_ystart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XYK_YROR_YI : (bits(1), yregidx, bits(6), yregidx)

$[wavedrom "_ _ _ _ _ OPIYI _ CUSTOM-1"]
mapping clause encdec = XYK_YROR_YI(ym, ys2, uimm, yd)
  <-> 0b01010 @ uimm[5] @ ym @ encdec_yreg(ys2) @ uimm[4..0] @ 0b011 @ encdec_yreg(yd) @ 0b0101011
  when valid_ytype() & xy_crypto_kb_enabled() & (y_get_sew() <= 32 | (y_get_sew() == 64 & xy_64_enabled()))

mapping clause assembly = XYK_YROR_YI(ym, ys2, uimm, yd)
 <-> "yror.yi" ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2) ^ sep() ^ hex_bits_6(uimm) ^ maybe_ymask(ym)

function clause execute XYK_YROR_YI(ym, ys2, uimm, yd) = {
  let SEW_pow  = y_get_sew_pow();
  let SEW      = 2 ^ SEW_pow;
  let LMUL_pow = y_get_lmul_pow();
  let num_elem = y_get_num_elem(LMUL_pow, SEW);

  if not(y_valid_reg_group(ys2, LMUL_pow)) |
     not(y_valid_reg_group(yd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let ym_val   : bits('n) = read_ymask(num_elem, ym, zyreg);
  let uimm_val : bits('m) = zero_extend(uimm);
  let ys2_val  : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let yd_val   : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, yd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match y_init_masked_result(num_elem, SEW, LMUL_pow, yd_val, ym_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j][k] == 0b1 then
      result[i][j][k] = ys2_val[i][j][k] >>> uimm_val[SEW_pow - 1 .. 0];
  };
  write_yreg(num_elem, SEW, LMUL_pow, yd, result);
  set_ystart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XYK_YWIDESLL_YY : (bits(1), yregidx, yregidx, yregidx)

$[wavedrom "_ _ _ _ OPIYY _ CUSTOM-1"]
mapping clause encdec = XYK_YWIDESLL_YY (ym, ys2, ys1, yd)
  <-> 0b110101 @ ym @ encdec_yreg(ys2) @ encdec_yreg(ys1) @ 0b000 @ encdec_yreg(yd) @ 0b0101011
  when valid_ytype() & xy_crypto_bb_enabled() & (y_get_sew() <= 32 | (y_get_sew() == 64 & xy_64_enabled()))

mapping clause assembly = XYK_YWIDESLL_YY (ym, ys2, ys1, yd)
  <-> "ywsll.yy" ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2) ^ sep() ^ yreg_name(ys1) ^ maybe_ymask(ym)

function clause execute XYK_YWIDESLL_YY(ym, ys2, ys1, yd) = {
  let SEW            = y_get_sew();
  let LMUL_pow       = y_get_lmul_pow();
  let num_elem       = y_get_num_elem(LMUL_pow, SEW);
  let SEW_widen      = SEW * 2;
  let LMUL_pow_widen = LMUL_pow + 1;

  if  y_illegal_variable_width(yd, ym, SEW_widen, LMUL_pow_widen) |
      not(y_valid_reg_overlap(ys1, yd, LMUL_pow, LMUL_pow_widen)) |
      not(y_valid_reg_overlap(ys2, yd, LMUL_pow, LMUL_pow_widen))
  then return Illegal_Instruction();

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let 'n = num_elem;
  let 'm = SEW;
  let 'o = SEW_widen;

  let ym_val      : bits('n) = read_ymask(num_elem, ym, zyreg);
  let ys1_val_vec : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, ys1);
  let ys2_val_vec : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let yd_val      : vector('n, bits('o)) = read_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd);

  let SEW_widen_bits = to_bits_unsafe(SEW_widen, 'o);
  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = match y_init_masked_result(num_elem, SEW_widen, LMUL_pow_widen, yd_val, ym_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j][k] == 0b1 then {
      let ys1_val : bits('o) = zero_extend(ys1_val_vec[i][j][k]);
      let ys2_val : bits('o) = zero_extend(ys2_val_vec[i][j][k]);
      result[i][j][k] = ys2_val << (ys1_val & zero_extend(SEW_widen_bits - 1));
    };
  };
  write_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd, result);
  set_ystart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XYK_YWIDESLL_YX : (bits(1), yregidx, regidx, yregidx)

$[wavedrom "_ _ _ _ OPIYX _ CUSTOM-1"]
mapping clause encdec = XYK_YWIDESLL_YX (ym, ys2, rs1, yd)
  <-> 0b110101 @ ym @ encdec_yreg(ys2) @ encdec_reg(rs1) @ 0b100 @ encdec_yreg(yd) @ 0b0101011
  when valid_ytype() & xy_crypto_bb_enabled() & (y_get_sew() <= 32 | (y_get_sew() == 64 & xy_64_enabled()))

mapping clause assembly = XYK_YWIDESLL_YX (ym, ys2, rs1, yd)
  <-> "ywsll.yx" ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2) ^ sep() ^ reg_name(rs1) ^ maybe_ymask(ym)

function clause execute XYK_YWIDESLL_YX(ym, ys2, rs1, yd) = {
  let SEW            = y_get_sew();
  let LMUL_pow       = y_get_lmul_pow();
  let num_elem       = y_get_num_elem(LMUL_pow, SEW);
  let SEW_widen      = SEW * 2;
  let LMUL_pow_widen = LMUL_pow + 1;

  if  y_illegal_variable_width(yd, ym, SEW_widen, LMUL_pow_widen) |
      not(y_valid_reg_overlap(ys2, yd, LMUL_pow, LMUL_pow_widen))
  then return Illegal_Instruction();

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let 'n = num_elem;
  let 'm = SEW;
  let 'o = SEW_widen;

  let ym_val      : bits('n) = read_ymask(num_elem, ym, zyreg);
  let rs1_val     : bits('o) = zero_extend(y_get_scalar(rs1, SEW));
  let ys2_val_vec : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let yd_val      : vector('n, bits('o)) = read_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd);

  let SEW_widen_bits = to_bits_unsafe(SEW_widen, 'o);
  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = match y_init_masked_result(num_elem, SEW_widen, LMUL_pow_widen, yd_val, ym_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j][k] == 0b1 then {
      let ys2_val : bits('o) = zero_extend(ys2_val_vec[i][j][k]);
      result[i][j][k] = ys2_val << (rs1_val & zero_extend(SEW_widen_bits - 1));
    };
  };
  write_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd, result);
  set_ystart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XYK_YWIDESLL_YI : (bits(1), yregidx, bits(5), yregidx)

$[wavedrom "_ _ _ _ OPIYI _ CUSTOM-1"]
mapping clause encdec = XYK_YWIDESLL_YI (ym, ys2, uimm, yd)
  <-> 0b110101 @ ym @ encdec_yreg(ys2) @ uimm @ 0b011 @ encdec_yreg(yd) @ 0b0101011
  when valid_ytype() & xy_crypto_bb_enabled() & (y_get_sew() <= 32 | (y_get_sew() == 64 & xy_64_enabled()))

mapping clause assembly = XYK_YWIDESLL_YI (ym, ys2, uimm, yd)
  <-> "ywsll.yi" ^ spc() ^ yreg_name(yd) ^ sep() ^ yreg_name(ys2) ^ sep() ^ hex_bits_5(uimm) ^ maybe_ymask(ym)

function clause execute XYK_YWIDESLL_YI(ym, ys2, uimm, yd) = {
  let SEW            = y_get_sew();
  let LMUL_pow       = y_get_lmul_pow();
  let num_elem       = y_get_num_elem(LMUL_pow, SEW);
  let SEW_widen      = SEW * 2;
  let LMUL_pow_widen = LMUL_pow + 1;

  if  y_illegal_variable_width(yd, ym, SEW_widen, LMUL_pow_widen) |
      not(y_valid_reg_overlap(ys2, yd, LMUL_pow, LMUL_pow_widen))
  then return Illegal_Instruction();

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let 'n = num_elem;
  let 'm = SEW;
  let 'o = SEW_widen;

  let ym_val      : bits('n) = read_ymask(num_elem, ym, zyreg);
  let uimm_val    : bits('o) = zero_extend(uimm);
  let ys2_val_vec : vector('n, bits('m)) = read_yreg(num_elem, SEW, LMUL_pow, ys2);
  let yd_val      : vector('n, bits('o)) = read_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd);

  let SEW_widen_bits = to_bits_unsafe(SEW_widen, 'o);
  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = match y_init_masked_result(num_elem, SEW_widen, LMUL_pow_widen, yd_val, ym_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j][k] == 0b1 then {
        let ys2_val : bits('o) = zero_extend(ys2_val_vec[i][j][k]);
        result[i][j][k] = ys2_val << (uimm_val & zero_extend(SEW_widen_bits - 1));
    };
  };
  write_yreg(num_elem, SEW_widen, LMUL_pow_widen, yd, result);
  set_ystart(zeros());
  RETIRE_SUCCESS
}
