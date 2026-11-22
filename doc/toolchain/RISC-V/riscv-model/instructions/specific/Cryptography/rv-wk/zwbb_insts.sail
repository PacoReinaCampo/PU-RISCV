// =======================================================================================
// This Sail RISC-V architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

function xw_crypto_bb_enabled() -> bool = (config extensions.Xw.crypto.bb : bool) & xw_enabled()
function xw_crypto_kb_enabled() -> bool = ((config extensions.Xw.crypto.kb : bool) & xw_enabled()) | xw_crypto_bb_enabled()

union clause instruction = XWK_WANDN_WW : (bits(1), wregidx, wregidx, wregidx)

$[wavedrom "_ _ _ _ OPIWW _ CUSTOM-0"]
mapping clause encdec = XWK_WANDN_WW(wm, ws1, ws2, wd)
  <-> 0b000001 @ wm @ encdec_wreg(ws2) @ encdec_wreg(ws1) @ 0b000 @ encdec_wreg(wd) @ 0b0001011
  when valid_wtype() & xw_crypto_kb_enabled() & (w_get_sew() <= 32 | (w_get_sew() == 64 & xw_64_enabled()))

mapping clause assembly = XWK_WANDN_WW(wm, ws1, ws2, wd)
  <-> "wandn.ww" ^ spc() ^ wreg_name(wd) ^ sep() ^ wreg_name(ws2) ^ sep() ^ wreg_name(ws1) ^ maybe_wmask(wm)

function clause execute XWK_WANDN_WW(wm, ws1, ws2, wd) = {
  let SEW      = w_get_sew();
  let LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(LMUL_pow, SEW);

  if not(w_valid_reg_group(ws1, LMUL_pow)) |
     not(w_valid_reg_group(ws2, LMUL_pow)) |
     not(w_valid_reg_group(wd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let wm_val  : bits('n) = read_wmask(num_elem, wm, zwreg);
  let ws1_val : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, ws1);
  let ws2_val : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, ws2);
  let wd_val  : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match w_init_masked_result(num_elem, SEW, LMUL_pow, wd_val, wm_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j] == 0b1 then
      result[i][j] = ~(ws1_val[i][j]) & ws2_val[i][j];
  };
  write_wreg(num_elem, SEW, LMUL_pow, wd, result);
  set_wstart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XWK_WANDN_WX : (bits(1), wregidx, regidx, wregidx)

$[wavedrom "_ _ _ _ OPIWX _ CUSTOM-0"]
mapping clause encdec = XWK_WANDN_WX(wm, ws2, rs1, wd)
  <-> 0b000001 @ wm @ encdec_wreg(ws2) @ encdec_reg(rs1) @ 0b100 @ encdec_wreg(wd) @ 0b0001011
  when valid_wtype() & xw_crypto_kb_enabled() & (w_get_sew() <= 32 | (w_get_sew() == 64 & xw_64_enabled()))

mapping clause assembly = XWK_WANDN_WX(wm, ws2, rs1, wd)
  <-> "wandn.wx" ^ spc() ^ wreg_name(wd) ^ sep() ^ wreg_name(ws2) ^ sep() ^ reg_name(rs1) ^ maybe_wmask(wm)

function clause execute XWK_WANDN_WX(wm, ws2, rs1, wd) = {
  let SEW      = w_get_sew();
  let LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(LMUL_pow, SEW);

  if not(w_valid_reg_group(ws2, LMUL_pow)) |
     not(w_valid_reg_group(wd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let wm_val  : bits('n) = read_wmask(num_elem, wm, zwreg);
  let rs1_val : bits('m) = w_get_scalar(rs1, SEW);
  let ws2_val : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, ws2);
  let wd_val  : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match w_init_masked_result(num_elem, SEW, LMUL_pow, wd_val, wm_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem- 1)) {
    if mask[i][j] == 0b1 then
      result[i][j] = ~(rs1_val) & ws2_val[i][j];
  };
  write_wreg(num_elem, SEW, LMUL_pow, wd, result);
  set_wstart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XWK_WBREW_W : (bits(1), wregidx, wregidx)

$[wavedrom "_ _ _ _ OPMWW _ CUSTOM-0"]
mapping clause encdec = XWK_WBREW_W(wm, ws2, wd)
  <-> 0b010010 @ wm @ encdec_wreg(ws2) @ 0b01010 @ 0b010 @ encdec_wreg(wd) @ 0b0001011
  when valid_wtype() & xw_crypto_bb_enabled() & (w_get_sew() <= 32 | (w_get_sew() == 64 & xw_64_enabled()))

mapping clause assembly = XWK_WBREW_W(wm, ws2, wd)
  <-> "wbrev.w" ^ spc() ^ wreg_name(wd) ^ sep() ^ wreg_name(ws2) ^ maybe_wmask(wm)

function clause execute XWK_WBREW_W(wm, ws2, wd) = {
  let SEW      = w_get_sew();
  let LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(LMUL_pow, SEW);

  if not(w_valid_reg_group(ws2, LMUL_pow)) |
     not(w_valid_reg_group(wd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let wm_val  : bits('n) = read_wmask(num_elem, wm, zwreg);
  let ws2_val : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, ws2);
  let wd_val  : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match w_init_masked_result(num_elem, SEW, LMUL_pow, wd_val, wm_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j] == 0b1 then {
      var output : bits('m) = zeros();
      foreach (j from 0 to (SEW - 1))
        output[SEW - 1 - j] = ws2_val[i][j][j];
      result[i][j] = output;
    };
  };
  write_wreg(num_elem, SEW, LMUL_pow, wd, result);
  set_wstart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XWK_WBREW8_W : (bits(1), wregidx, wregidx)

$[wavedrom "_ _ _ _ OPMWW _ CUSTOM-0"]
mapping clause encdec = XWK_WBREW8_W(wm, ws2, wd)
  <-> 0b010010 @ wm @ encdec_wreg(ws2) @ 0b01000 @ 0b010 @ encdec_wreg(wd) @ 0b0001011
  when valid_wtype() & xw_crypto_kb_enabled() & (w_get_sew() <= 32 | (w_get_sew() == 64 & xw_64_enabled()))

mapping clause assembly = XWK_WBREW8_W(wm, ws2, wd)
  <-> "wbrev8.w" ^ spc() ^ wreg_name(wd) ^ sep() ^ wreg_name(ws2) ^ maybe_wmask(wm)

function clause execute XWK_WBREW8_W(wm, ws2, wd) = {
  let SEW      = w_get_sew();
  let LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(LMUL_pow, SEW);

  if not(w_valid_reg_group(ws2, LMUL_pow)) |
     not(w_valid_reg_group(wd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let wm_val  : bits('n) = read_wmask(num_elem, wm, zwreg);
  let ws2_val : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, ws2);
  let wd_val  : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match w_init_masked_result(num_elem, SEW, LMUL_pow, wd_val, wm_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j] == 0b1 then {
      result[i][j] = brev8(ws2_val[i][j]);
    };
  };
  write_wreg(num_elem, SEW, LMUL_pow, wd, result);
  set_wstart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XWK_WREW8_W : (bits(1), wregidx, wregidx)

$[wavedrom "_ _ _ _ OPMWW _ CUSTOM-0"]
mapping clause encdec = XWK_WREW8_W(wm, ws2, wd)
  <-> 0b010010 @ wm @ encdec_wreg(ws2) @ 0b01001 @ 0b010 @ encdec_wreg(wd) @ 0b0001011
  when valid_wtype() & xw_crypto_kb_enabled() & (w_get_sew() <= 32 | (w_get_sew() == 64 & xw_64_enabled()))

mapping clause assembly = XWK_WREW8_W(wm, ws2, wd)
  <-> "wrev8.w" ^ spc() ^ wreg_name(wd) ^ sep() ^ wreg_name(ws2) ^ maybe_wmask(wm)

function clause execute XWK_WREW8_W(wm, ws2, wd) = {
  let SEW      = w_get_sew();
  let LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(LMUL_pow, SEW);

  if not(w_valid_reg_group(ws2, LMUL_pow)) |
     not(w_valid_reg_group(wd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let wm_val  : bits('n) = read_wmask(num_elem, wm, zwreg);
  let ws2_val : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, ws2);
  let wd_val  : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match w_init_masked_result(num_elem, SEW, LMUL_pow, wd_val, wm_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j] == 0b1 then {
      result[i][j] = rev8(ws2_val[i][j]);
    };
  };
  write_wreg(num_elem, SEW, LMUL_pow, wd, result);
  set_wstart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XWK_WCLZ_W : (bits(1), wregidx, wregidx)

$[wavedrom "_ _ _ _ OPMWW _ CUSTOM-0"]
mapping clause encdec = XWK_WCLZ_W (wm, ws2, wd)
  <-> 0b010010 @ wm @ encdec_wreg(ws2) @ 0b01100 @ 0b010 @ encdec_wreg(wd) @ 0b0001011
  when valid_wtype() & xw_crypto_bb_enabled() & (w_get_sew() <= 32 | (w_get_sew() == 64 & xw_64_enabled()))

mapping clause assembly = XWK_WCLZ_W (wm, ws2, wd)
  <-> "wclz.w" ^ spc() ^ wreg_name(wd) ^ sep() ^ wreg_name(ws2) ^ maybe_wmask(wm)

function clause execute XWK_WCLZ_W(wm, ws2, wd) = {
  let SEW      = w_get_sew();
  let LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(LMUL_pow, SEW);

  if not(w_valid_reg_group(ws2, LMUL_pow)) |
     not(w_valid_reg_group(wd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let wm_val  : bits('n) = read_wmask(num_elem, wm, zwreg);
  let ws2_val : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, ws2);
  let wd_val  : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match w_init_masked_result(num_elem, SEW, LMUL_pow, wd_val, wm_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j] == 0b1 then {
      let clz = count_leading_zeros(ws2_val[i][j]);
      result[i][j] = to_bits(clz);
    };
  };
  write_wreg(num_elem, SEW, LMUL_pow, wd, result);
  set_wstart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XWK_WCTZ_W : (bits(1), wregidx, wregidx)

$[wavedrom "_ _ _ _ OPMWW _ CUSTOM-0"]
mapping clause encdec = XWK_WCTZ_W (wm, ws2, wd)
  <-> 0b010010 @ wm @ encdec_wreg(ws2) @ 0b01101 @ 0b010 @ encdec_wreg(wd) @ 0b0001011
  when valid_wtype() & xw_crypto_bb_enabled() & (w_get_sew() <= 32 | (w_get_sew() == 64 & xw_64_enabled()))

mapping clause assembly = XWK_WCTZ_W (wm, ws2, wd)
  <-> "wctz.w" ^ spc() ^ wreg_name(wd) ^ sep() ^ wreg_name(ws2) ^ maybe_wmask(wm)

function clause execute XWK_WCTZ_W(wm, ws2, wd) = {
  let SEW      = w_get_sew();
  let LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(LMUL_pow, SEW);

  if not(w_valid_reg_group(ws2, LMUL_pow)) |
     not(w_valid_reg_group(wd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let wm_val  : bits('n) = read_wmask(num_elem, wm, zwreg);
  let ws2_val : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, ws2);
  let wd_val  : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match w_init_masked_result(num_elem, SEW, LMUL_pow, wd_val, wm_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j] == 0b1 then {
      let ctz = count_trailing_zeros(ws2_val[i][j]);
      result[i][j] = to_bits(ctz);
    };
  };
  write_wreg(num_elem, SEW, LMUL_pow, wd, result);
  set_wstart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XWK_WCPOP_W : (bits(1), wregidx, wregidx)

$[wavedrom "_ _ _ _ OPMWW _ CUSTOM-0"]
mapping clause encdec = XWK_WCPOP_W (wm, ws2, wd)
  <-> 0b010010 @ wm @ encdec_wreg(ws2) @ 0b01110 @ 0b010 @ encdec_wreg(wd) @ 0b0001011
  when valid_wtype() & xw_crypto_bb_enabled() & (w_get_sew() <= 32 | (w_get_sew() == 64 & xw_64_enabled()))

mapping clause assembly = XWK_WCPOP_W (wm, ws2, wd)
  <-> "wcpop.w" ^ spc() ^ wreg_name(wd) ^ sep() ^ wreg_name(ws2) ^ maybe_wmask(wm)

function clause execute XWK_WCPOP_W(wm, ws2, wd) = {
  let SEW      = w_get_sew();
  let LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(LMUL_pow, SEW);

  if not(w_valid_reg_group(ws2, LMUL_pow)) |
     not(w_valid_reg_group(wd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let wm_val  : bits('n) = read_wmask(num_elem, wm, zwreg);
  let ws2_val : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, ws2);
  let wd_val  : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match w_init_masked_result(num_elem, SEW, LMUL_pow, wd_val, wm_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j] == 0b1 then {
      foreach (j from 0 to (SEW - 1)) {
        if ws2_val[i][j][j] == 0b1 then {
          result[i][j] = result[i][j] + 1;
        };
      }
    };
  };
  write_wreg(num_elem, SEW, LMUL_pow, wd, result);
  set_wstart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XWK_WROL_WW : (bits(1), wregidx, wregidx, wregidx)

$[wavedrom "_ _ _ _ OPIWW _ CUSTOM-0"]
mapping clause encdec = XWK_WROL_WW(wm, ws1, ws2, wd)
  <-> 0b010101 @ wm @ encdec_wreg(ws2) @ encdec_wreg(ws1) @ 0b000 @ encdec_wreg(wd) @ 0b0001011
  when valid_wtype() & xw_crypto_kb_enabled() & (w_get_sew() <= 32 | (w_get_sew() == 64 & xw_64_enabled()))

mapping clause assembly = XWK_WROL_WW(wm, ws1, ws2, wd)
 <-> "wrol.ww" ^ spc() ^ wreg_name(wd) ^ sep() ^ wreg_name(ws2) ^ sep() ^ wreg_name(ws1) ^ maybe_wmask(wm)

function clause execute XWK_WROL_WW(wm, ws1, ws2, wd) = {
  let SEW_pow  = w_get_sew_pow();
  let SEW      = 2 ^ SEW_pow;
  let LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(LMUL_pow, SEW);

  if not(w_valid_reg_group(ws1, LMUL_pow)) |
     not(w_valid_reg_group(ws2, LMUL_pow)) |
     not(w_valid_reg_group(wd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let wm_val  : bits('n) = read_wmask(num_elem, wm, zwreg);
  let ws1_val : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, ws1);
  let ws2_val : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, ws2);
  let wd_val  : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match w_init_masked_result(num_elem, SEW, LMUL_pow, wd_val, wm_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j] == 0b1 then
      result[i][j] = ws2_val[i][j] <<< ws1_val[i][j][SEW_pow - 1 .. 0];
  };
  write_wreg(num_elem, SEW, LMUL_pow, wd, result);
  set_wstart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XWK_WROL_WX : (bits(1), wregidx, regidx, wregidx)

$[wavedrom "_ _ _ _ OPIWX _ CUSTOM-0"]
mapping clause encdec = XWK_WROL_WX(wm, ws2, rs1, wd)
  <-> 0b010101 @ wm @ encdec_wreg(ws2) @ encdec_reg(rs1) @ 0b100 @ encdec_wreg(wd) @ 0b0001011
  when valid_wtype() & xw_crypto_kb_enabled() & (w_get_sew() <= 32 | (w_get_sew() == 64 & xw_64_enabled()))

mapping clause assembly = XWK_WROL_WX(wm, ws2, rs1, wd)
 <-> "wrol.wx" ^ spc() ^ wreg_name(wd) ^ sep() ^ wreg_name(ws2) ^ sep() ^ reg_name(rs1) ^ maybe_wmask(wm)

function clause execute XWK_WROL_WX(wm, ws2, rs1, wd) = {
  let SEW_pow  = w_get_sew_pow();
  let SEW      = 2 ^ SEW_pow;
  let LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(LMUL_pow, SEW);

  if not(w_valid_reg_group(ws2, LMUL_pow)) |
     not(w_valid_reg_group(wd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let wm_val  : bits('n) = read_wmask(num_elem, wm, zwreg);
  let rs1_val : bits('m) = w_get_scalar(rs1, SEW);
  let ws2_val : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, ws2);
  let wd_val  : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match w_init_masked_result(num_elem, SEW, LMUL_pow, wd_val, wm_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j] == 0b1 then
      result[i][j] = ws2_val[i][j] <<< rs1_val[SEW_pow - 1 .. 0];
  };
  write_wreg(num_elem, SEW, LMUL_pow, wd, result);
  set_wstart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XWK_WROR_WW : (bits(1), wregidx, wregidx, wregidx)

$[wavedrom "_ _ _ _ OPIWW _ CUSTOM-0"]
mapping clause encdec = XWK_WROR_WW(wm, ws1, ws2, wd)
  <-> 0b010100 @ wm @ encdec_wreg(ws2) @ encdec_wreg(ws1) @ 0b000 @ encdec_wreg(wd) @ 0b0001011
  when valid_wtype() & xw_crypto_kb_enabled() & (w_get_sew() <= 32 | (w_get_sew() == 64 & xw_64_enabled()))

mapping clause assembly = XWK_WROR_WW(wm, ws1, ws2, wd)
 <-> "wror.ww" ^ spc() ^ wreg_name(wd) ^ sep() ^ wreg_name(ws2) ^ sep() ^ wreg_name(ws1) ^ maybe_wmask(wm)

function clause execute XWK_WROR_WW(wm, ws1, ws2, wd) = {
  let SEW_pow  = w_get_sew_pow();
  let SEW      = 2 ^ SEW_pow;
  let LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(LMUL_pow, SEW);

  if not(w_valid_reg_group(ws1, LMUL_pow)) |
     not(w_valid_reg_group(ws2, LMUL_pow)) |
     not(w_valid_reg_group(wd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let wm_val  : bits('n) = read_wmask(num_elem, wm, zwreg);
  let ws1_val : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, ws1);
  let ws2_val : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, ws2);
  let wd_val  : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match w_init_masked_result(num_elem, SEW, LMUL_pow, wd_val, wm_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j] == 0b1 then
      result[i][j] = ws2_val[i][j] >>> ws1_val[i][j][SEW_pow - 1 .. 0];
  };
  write_wreg(num_elem, SEW, LMUL_pow, wd, result);
  set_wstart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XWK_WROR_WX : (bits(1), wregidx, regidx, wregidx)

$[wavedrom "_ _ _ _ OPIWX _ CUSTOM-0"]
mapping clause encdec = XWK_WROR_WX(wm, ws2, rs1, wd)
  <-> 0b010100 @ wm @ encdec_wreg(ws2) @ encdec_reg(rs1) @ 0b100 @ encdec_wreg(wd) @ 0b0001011
  when valid_wtype() & xw_crypto_kb_enabled() & (w_get_sew() <= 32 | (w_get_sew() == 64 & xw_64_enabled()))

mapping clause assembly = XWK_WROR_WX(wm, ws2, rs1, wd)
 <-> "wror.wx" ^ spc() ^ wreg_name(wd) ^ sep() ^ wreg_name(ws2) ^ sep() ^ reg_name(rs1)^ maybe_wmask(wm)

function clause execute XWK_WROR_WX(wm, ws2, rs1, wd) = {
  let SEW_pow  = w_get_sew_pow();
  let SEW      = 2 ^ SEW_pow;
  let LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(LMUL_pow, SEW);

  if not(w_valid_reg_group(ws2, LMUL_pow)) |
     not(w_valid_reg_group(wd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let wm_val  : bits('n) = read_wmask(num_elem, wm, zwreg);
  let rs1_val : bits('m) = w_get_scalar(rs1, SEW);
  let ws2_val : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, ws2);
  let wd_val  : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match w_init_masked_result(num_elem, SEW, LMUL_pow, wd_val, wm_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j] == 0b1 then
      result[i][j] = ws2_val[i][j] >>> rs1_val[SEW_pow - 1 .. 0];
  };
  write_wreg(num_elem, SEW, LMUL_pow, wd, result);
  set_wstart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XWK_WROR_WI : (bits(1), wregidx, bits(6), wregidx)

$[wavedrom "_ _ _ _ _ OPIWI _ CUSTOM-0"]
mapping clause encdec = XWK_WROR_WI(wm, ws2, uimm, wd)
  <-> 0b01010 @ uimm[5] @ wm @ encdec_wreg(ws2) @ uimm[4..0] @ 0b011 @ encdec_wreg(wd) @ 0b0001011
  when valid_wtype() & xw_crypto_kb_enabled() & (w_get_sew() <= 32 | (w_get_sew() == 64 & xw_64_enabled()))

mapping clause assembly = XWK_WROR_WI(wm, ws2, uimm, wd)
 <-> "wror.wi" ^ spc() ^ wreg_name(wd) ^ sep() ^ wreg_name(ws2) ^ sep() ^ hex_bits_6(uimm) ^ maybe_wmask(wm)

function clause execute XWK_WROR_WI(wm, ws2, uimm, wd) = {
  let SEW_pow  = w_get_sew_pow();
  let SEW      = 2 ^ SEW_pow;
  let LMUL_pow = w_get_lmul_pow();
  let num_elem = w_get_num_elem(LMUL_pow, SEW);

  if not(w_valid_reg_group(ws2, LMUL_pow)) |
     not(w_valid_reg_group(wd, LMUL_pow))
  then return Illegal_Instruction();

  let 'n = num_elem;
  let 'm = SEW;

  let wm_val   : bits('n) = read_wmask(num_elem, wm, zwreg);
  let uimm_val : bits('m) = zero_extend(uimm);
  let ws2_val  : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, ws2);
  let wd_val   : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, wd);

  let (initial_result, mask) : (vector('n, bits('m)), bits('n)) = match w_init_masked_result(num_elem, SEW, LMUL_pow, wd_val, wm_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j] == 0b1 then
      result[i][j] = ws2_val[i][j] >>> uimm_val[SEW_pow - 1 .. 0];
  };
  write_wreg(num_elem, SEW, LMUL_pow, wd, result);
  set_wstart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XWK_WWIDESLL_WW : (bits(1), wregidx, wregidx, wregidx)

$[wavedrom "_ _ _ _ OPIWW _ CUSTOM-0"]
mapping clause encdec = XWK_WWIDESLL_WW (wm, ws2, ws1, wd)
  <-> 0b110101 @ wm @ encdec_wreg(ws2) @ encdec_wreg(ws1) @ 0b000 @ encdec_wreg(wd) @ 0b0001011
  when valid_wtype() & xw_crypto_bb_enabled() & (w_get_sew() <= 32 | (w_get_sew() == 64 & xw_64_enabled()))

mapping clause assembly = XWK_WWIDESLL_WW (wm, ws2, ws1, wd)
  <-> "wwsll.ww" ^ spc() ^ wreg_name(wd) ^ sep() ^ wreg_name(ws2) ^ sep() ^ wreg_name(ws1) ^ maybe_wmask(wm)

function clause execute XWK_WWIDESLL_WW(wm, ws2, ws1, wd) = {
  let SEW            = w_get_sew();
  let LMUL_pow       = w_get_lmul_pow();
  let num_elem       = w_get_num_elem(LMUL_pow, SEW);
  let SEW_widen      = SEW * 2;
  let LMUL_pow_widen = LMUL_pow + 1;

  if  w_illegal_variable_width(wd, wm, SEW_widen, LMUL_pow_widen) |
      not(w_valid_reg_overlap(ws1, wd, LMUL_pow, LMUL_pow_widen)) |
      not(w_valid_reg_overlap(ws2, wd, LMUL_pow, LMUL_pow_widen))
  then return Illegal_Instruction();

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let 'n = num_elem;
  let 'm = SEW;
  let 'o = SEW_widen;

  let wm_val      : bits('n) = read_wmask(num_elem, wm, zwreg);
  let ws1_val_vec : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, ws1);
  let ws2_val_vec : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, ws2);
  let wd_val      : vector('n, bits('o)) = read_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd);

  let SEW_widen_bits = to_bits_unsafe(SEW_widen, 'o);
  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = match w_init_masked_result(num_elem, SEW_widen, LMUL_pow_widen, wd_val, wm_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j] == 0b1 then {
      let ws1_val : bits('o) = zero_extend(ws1_val_vec[i][j]);
      let ws2_val : bits('o) = zero_extend(ws2_val_vec[i][j]);
      result[i][j] = ws2_val << (ws1_val & zero_extend(SEW_widen_bits - 1));
    };
  };
  write_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd, result);
  set_wstart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XWK_WWIDESLL_WX : (bits(1), wregidx, regidx, wregidx)

$[wavedrom "_ _ _ _ OPIWX _ CUSTOM-0"]
mapping clause encdec = XWK_WWIDESLL_WX (wm, ws2, rs1, wd)
  <-> 0b110101 @ wm @ encdec_wreg(ws2) @ encdec_reg(rs1) @ 0b100 @ encdec_wreg(wd) @ 0b0001011
  when valid_wtype() & xw_crypto_bb_enabled() & (w_get_sew() <= 32 | (w_get_sew() == 64 & xw_64_enabled()))

mapping clause assembly = XWK_WWIDESLL_WX (wm, ws2, rs1, wd)
  <-> "wwsll.wx" ^ spc() ^ wreg_name(wd) ^ sep() ^ wreg_name(ws2) ^ sep() ^ reg_name(rs1) ^ maybe_wmask(wm)

function clause execute XWK_WWIDESLL_WX(wm, ws2, rs1, wd) = {
  let SEW            = w_get_sew();
  let LMUL_pow       = w_get_lmul_pow();
  let num_elem       = w_get_num_elem(LMUL_pow, SEW);
  let SEW_widen      = SEW * 2;
  let LMUL_pow_widen = LMUL_pow + 1;

  if  w_illegal_variable_width(wd, wm, SEW_widen, LMUL_pow_widen) |
      not(w_valid_reg_overlap(ws2, wd, LMUL_pow, LMUL_pow_widen))
  then return Illegal_Instruction();

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let 'n = num_elem;
  let 'm = SEW;
  let 'o = SEW_widen;

  let wm_val      : bits('n) = read_wmask(num_elem, wm, zwreg);
  let rs1_val     : bits('o) = zero_extend(w_get_scalar(rs1, SEW));
  let ws2_val_vec : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, ws2);
  let wd_val      : vector('n, bits('o)) = read_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd);

  let SEW_widen_bits = to_bits_unsafe(SEW_widen, 'o);
  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = match w_init_masked_result(num_elem, SEW_widen, LMUL_pow_widen, wd_val, wm_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j] == 0b1 then {
      let ws2_val : bits('o) = zero_extend(ws2_val_vec[i][j]);
      result[i][j] = ws2_val << (rs1_val & zero_extend(SEW_widen_bits - 1));
    };
  };
  write_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd, result);
  set_wstart(zeros());
  RETIRE_SUCCESS
}

union clause instruction = XWK_WWIDESLL_WI : (bits(1), wregidx, bits(5), wregidx)

$[wavedrom "_ _ _ _ OPIWI _ CUSTOM-0"]
mapping clause encdec = XWK_WWIDESLL_WI (wm, ws2, uimm, wd)
  <-> 0b110101 @ wm @ encdec_wreg(ws2) @ uimm @ 0b011 @ encdec_wreg(wd) @ 0b0001011
  when valid_wtype() & xw_crypto_bb_enabled() & (w_get_sew() <= 32 | (w_get_sew() == 64 & xw_64_enabled()))

mapping clause assembly = XWK_WWIDESLL_WI (wm, ws2, uimm, wd)
  <-> "wwsll.wi" ^ spc() ^ wreg_name(wd) ^ sep() ^ wreg_name(ws2) ^ sep() ^ hex_bits_5(uimm) ^ maybe_wmask(wm)

function clause execute XWK_WWIDESLL_WI(wm, ws2, uimm, wd) = {
  let SEW            = w_get_sew();
  let LMUL_pow       = w_get_lmul_pow();
  let num_elem       = w_get_num_elem(LMUL_pow, SEW);
  let SEW_widen      = SEW * 2;
  let LMUL_pow_widen = LMUL_pow + 1;

  if  w_illegal_variable_width(wd, wm, SEW_widen, LMUL_pow_widen) |
      not(w_valid_reg_overlap(ws2, wd, LMUL_pow, LMUL_pow_widen))
  then return Illegal_Instruction();

  assert(SEW_widen <= 64);
  assert(LMUL_pow_widen <= 3);

  let 'n = num_elem;
  let 'm = SEW;
  let 'o = SEW_widen;

  let wm_val      : bits('n) = read_wmask(num_elem, wm, zwreg);
  let uimm_val    : bits('o) = zero_extend(uimm);
  let ws2_val_vec : vector('n, bits('m)) = read_wreg(num_elem, SEW, LMUL_pow, ws2);
  let wd_val      : vector('n, bits('o)) = read_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd);

  let SEW_widen_bits = to_bits_unsafe(SEW_widen, 'o);
  let (initial_result, mask) : (vector('n, bits('o)), bits('n)) = match w_init_masked_result(num_elem, SEW_widen, LMUL_pow_widen, wd_val, wm_val) {
    Ok(v)   => v,
    Err(()) => return Illegal_Instruction()
  };
  var result = initial_result;

  foreach (i from 0 to (num_elem - 1)) {
    if mask[i][j] == 0b1 then {
        let ws2_val : bits('o) = zero_extend(ws2_val_vec[i][j]);
        result[i][j] = ws2_val << (uimm_val & zero_extend(SEW_widen_bits - 1));
    };
  };
  write_wreg(num_elem, SEW_widen, LMUL_pow_widen, wd, result);
  set_wstart(zeros());
  RETIRE_SUCCESS
}
