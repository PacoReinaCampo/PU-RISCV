## Instruction Pseudo Code (Alternative)

Format of a line in the table:

`<instruction name> "<instruction pseudo code>"`

| ins name     | instruction pseudo code                                             |
|--------------|:--------------------------------------------------------------------|
| `lui`        | `rd = imm`                                                          |
| `auipc`      | `rd = pc + imm`                                                     |
| `jal`        | `rd = pc + length(inst) ; pc = pc + imm`                            |
| `jalr`       | `rd = pc + length(inst) ; pc = (rs1 + imm) & -2`                    |
| `beq`        | `if rs1 = rs2 then pc = pc + imm`                                   |
| `bne`        | `if rs1 != rs2 then pc = pc + imm`                                  |
| `blt`        | `if rs1 < rs2 then pc = pc + imm`                                   |
| `bge`        | `if rs1 >= rs2 then pc = pc + imm`                                  |
| `bltu`       | `if rs1 < rs2 then pc = pc + imm`                                   |
| `bgeu`       | `if rs1 >= rs2 then pc = pc + imm`                                  |
| `lb`         | `rd = s8[rs1 + imm]`                                                |
| `lh`         | `rd = s16[rs1 + imm]`                                               |
| `lw`         | `rd = s32[rs1 + imm]`                                               |
| `lbu`        | `rd = u8[rs1 + imm]`                                                |
| `lhu`        | `rd = u16[rs1 + imm]`                                               |
| `lwu`        | `rd = u32[rs1 + imm]`                                               |
| `sb`         | `u8[rs1 + imm] = rs2`                                               |
| `sh`         | `u16[rs1 + imm] = rs2`                                              |
| `sw`         | `u32[rs1 + imm] = rs2`                                              |
| `addi`       | `rd = rs1 + sx(imm)`                                                |
| `slti`       | `rd = sx(rs1) < sx(imm)`                                            |
| `sltiu`      | `rd = ux(rs1) < ux(imm)`                                            |
| `xori`       | `rd = ux(rs1) ^ ux(imm)`                                            |
| `ori`        | `rd = ux(rs1) | ux(imm)`                                            |
| `andi`       | `rd = ux(rs1) & ux(imm)`                                            |
| `slli`       | `rd = ux(rs1) << ux(imm)`                                           |
| `srli`       | `rd = ux(rs1) >> ux(imm)`                                           |
| `srai`       | `rd = sx(rs1) >> ux(imm)`                                           |
| `add`        | `rd = sx(rs1) + sx(rs2)`                                            |
| `sub`        | `rd = sx(rs1) - sx(rs2)` `rs1 + ~rs2 + 1`                           |
| `sll`        | `rd = ux(rs1) << rs2`                                               |
| `slt`        | `rd = sx(rs1) < sx(rs2)`                                            |
| `sltu`       | `rd = ux(rs1) < ux(rs2)`                                            |
| `xor`        | `rd = ux(rs1) ^ ux(rs2)`                                            |
| `srl`        | `rd = ux(rs1) >> rs2`                                               |
| `sra`        | `rd = sx(rs1) >> rs2`                                               |
| `or`         | `rd = ux(rs1) | ux(rs2)`                                            |
| `and`        | `rd = ux(rs1) & ux(rs2)`                                            |
| `fence`      |                                                                     |
| `fence.i`    |                                                                     |
: RV32I - "RV32I Base Integer Instruction Set"

| ins name     | instruction pseudo code                                             |
|--------------|:--------------------------------------------------------------------|
| `ld`         | `rd = u64[rs1 + imm]`                                               |
| `sd`         | `u64[rs1 + imm] = rs2`                                              |
| `addiw`      | `rd = s32(rs1) + imm`                                               |
| `slliw`      | `rd = s32(u32(rs1) << imm)`                                         |
| `srliw`      | `rd = s32(u32(rs1) >> imm)`                                         |
| `sraiw`      | `rd = s32(rs1) >> imm`                                              |
| `addw`       | `rd = s32(rs1) + s32(rs2)`                                          |
| `subw`       | `rd = s32(rs1) - s32(rs2)`                                          |
| `sllw`       | `rd = s32(u32(rs1) << rs2)`                                         |
| `srlw`       | `rd = s32(u32(rs1) >> rs2)`                                         |
| `sraw`       | `rd = s32(rs1) >> rs2`                                              |
: RV64I - "RV64I Base Integer Instruction Set (+ RV32I)"

| ins name     | instruction pseudo code                                             |
|--------------|:--------------------------------------------------------------------|
| `mul`        | `rd = ux(rs1) * ux(rs2)`                                            |
| `mulh`       | `rd = (sx(rs1) * sx(rs2)) >> xlen`                                  |
| `mulhsu`     | `rd = (sx(rs1) * ux(rs2)) >> xlen`                                  |
| `mulhu`      | `rd = (ux(rs1) * ux(rs2)) >> xlen`                                  |
| `div`        | `rd = sx(rs1) / sx(rs2)`                                            |
| `divu`       | `rd = ux(rs1) / ux(rs2)`                                            |
| `rem`        | `rd = sx(rs1) mod sx(rs2)`                                          |
| `remu`       | `rd = ux(rs1) mod ux(rs2)`                                          |
: RV32M - "RV32M Standard Extension for Integer Multiply and Divide"

| ins name     | instruction pseudo code                                             |
|--------------|:--------------------------------------------------------------------|
| `mulw`       | `rd = u32(rs1) * u32(rs2)`                                          |
| `divw`       | `rd = s32(rs1) / s32(rs2)`                                          |
| `divuw`      | `rd = u32(rs1) / u32(rs2)`                                          |
| `remw`       | `rd = s32(rs1) mod s32(rs2)`                                        |
| `remuw`      | `rd = u32(rs1) mod u32(rs2)`                                        |
: RV64M - "RV64M Standard Extension for Integer Multiply and Divide (+ RV32M)"

| ins name     | instruction pseudo code                                             |
|--------------|:--------------------------------------------------------------------|
| `lr.w`       | `lr = rs1 , rd = sx(s32[rs1])`                                      |
| `sc.w`       | `if lr = rs1 then u32[rs1] = u32(rs2); rd = 0 else rd = 1`          |
| `amoswap.w`  | `rd = s32[rs1] , u32[rs1] = s32(rs2)`                               |
| `amoadd.w`   | `rd = s32[rs1] , u32[rs1] = s32(rs2) + s32[rs1]`                    |
| `amoxor.w`   | `rd = s32[rs1] , u32[rs1] = s32(rs2) ^ s32[rs1]`                    |
| `amoor.w`    | `rd = s32[rs1] , u32[rs1] = s32(rs2) | s32[rs1]`                    |
| `amoand.w`   | `rd = s32[rs1] , u32[rs1] = s32(rs2) & s32[rs1]`                    |
| `amomin.w`   | `rd = s32[rs1] , u32[rs1] = s32_min(s32(rs2), s32[rs1])`            |
| `amomax.w`   | `rd = s32[rs1] , u32[rs1] = s32_max(s32(rs2), s32[rs1])`            |
| `amominu.w`  | `rd = s32[rs1] , u32[rs1] = u32_min(u32(rs2), u32[rs1])`            |
| `amomaxu.w`  | `rd = s32[rs1] , u32[rs1] = u32_max(u32(rs2), u32[rs1])`            |
: RV32A - "RV32A Standard Extension for Atomic Instructions"

| ins name     | instruction pseudo code                                             |
|--------------|:--------------------------------------------------------------------|
| `lr.d`       | `lr = rs1 , rd = sx(s64[rs1])`                                      |
| `sc.d`       | `if lr = rs1 then u64[rs1] = u64(rs2); rd = 0 else rd = 1`          |
| `amoswap.d`  | `rd = s64[rs1] , u64[rs1] = s64(rs2)`                               |
| `amoadd.d`   | `rd = s64[rs1] , u64[rs1] = s64(rs2) + s64[rs1]`                    |
| `amoxor.d`   | `rd = s64[rs1] , u64[rs1] = s64(rs2) ^ s64[rs1]`                    |
| `amoor.d`    | `rd = s64[rs1] , u64[rs1] = s64(rs2) | s64[rs1]`                    |
| `amoand.d`   | `rd = s64[rs1] , u64[rs1] = s64(rs2) & s64[rs1]`                    |
| `amomin.d`   | `rd = s64[rs1] , u64[rs1] = s64_min(s64(rs2), s64[rs1])`            |
| `amomax.d`   | `rd = s64[rs1] , u64[rs1] = s64_max(s64(rs2), s64[rs1])`            |
| `amominu.d`  | `rd = s64[rs1] , u64[rs1] = u64_min(u64(rs2), u64[rs1])`            |
| `amomaxu.d`  | `rd = s64[rs1] , u64[rs1] = u64_max(u64(rs2), u64[rs1])`            |
: RV64A - "RV64A Standard Extension for Atomic Instructions (+ RV32A)"

| ins name     | instruction pseudo code                                             |
|--------------|:--------------------------------------------------------------------|
| `ecall`      |                                                                     |
| `ebreak`     |                                                                     |
| `uret`       |                                                                     |
| `sret`       |                                                                     |
| `hret`       |                                                                     |
| `mret`       |                                                                     |
| `dret`       |                                                                     |
| `sfence.vm`  |                                                                     |
| `wfi`        |                                                                     |
| `rdcycle`    |                                                                     |
| `rdtime`     |                                                                     |
| `rdinstret`  |                                                                     |
| `rdcycleh`   |                                                                     |
| `rdtimeh`    |                                                                     |
| `rdinstreth` |                                                                     |
| `csrrw`      |                                                                     |
| `csrrs`      |                                                                     |
| `csrrc`      |                                                                     |
| `csrrwi`     |                                                                     |
| `csrrsi`     |                                                                     |
| `csrrci`     |                                                                     |
: RV32S - "RV32S Standard Extension for Supervisor-level Instructions"

| ins name     | instruction pseudo code                                             |
|--------------|:--------------------------------------------------------------------|
| `flw`        | `frd = f32[rs1 + imm]`                                              |
| `fsw`        | `f32[rs1 + imm] = f32(frs2)`                                        |
| `fmadd.s`    | `frm = rm ; frd = f32(frs1) * f32(frs2) + f32(frs3)`                |
| `fmsub.s`    | `frm = rm ; frd = f32(frs1) * f32(frs2) - f32(frs3)`                |
| `fnmadd.s`   | `frm = rm ; frd = f32(frs1) * -f32(frs2) - f32(frs3)`               |
| `fnmsub.s`   | `frm = rm ; frd = f32(frs1) * -f32(frs2) + f32(frs3)`               |
| `fadd.s`     | `frm = rm ; frd = f32(frs1) + f32(frs2)`                            |
| `fsub.s`     | `frm = rm ; frd = f32(frs1) - f32(frs2)`                            |
| `fmul.s`     | `frm = rm ; frd = f32(frs1) * f32(frs2)`                            |
| `fdiv.s`     | `frm = rm ; frd = f32(frs1) / f32(frs2)`                            |
| `fsgnj.s`    | `frd = f32_copysign(f32(frs1), f32(frs2))`                          |
| `fsgnjn.s`   | `frd = f32_copysign(f32(frs1), -f32(frs2))`                         |
| `fsgnjx.s`   | `frd = f32_xorsign(f32(frs1), f32(frs2))`                           |
| `fmin.s`     | `frd = f32_min(f32(frs1), f32(frs2))`                               |
| `fmax.s`     | `frd = f32_max(f32(frs1), f32(frs2))`                               |
| `fsqrt.s`    | `frm = rm ; frd = f32_sqrt(f32(frs1))`                              |
| `fle.s`      | `if f32(frs1) <= f32(frs2) then rd = 1 else rd = 0`                 |
| `flt.s`      | `if f32(frs1) < f32(frs2) then rd = 1 else rd = 0`                  |
| `feq.s`      | `if f32(frs1) = f32(frs2) then rd = 1 else rd = 0`                  |
| `fcvt.w.s`   | `frm = rm ; rd = s32(f32(frs1))`                                    |
| `fcvt.wu.s`  | `frm = rm ; if f32(frs1) > 0 then rd = u32(f32(frs1) else rd = 0`   |
| `fcvt.s.w`   | `frm = rm ; frd = f32(s32(rs1))`                                    |
| `fcvt.s.wu`  | `frm = rm ; frd = f32(u32(rs1))`                                    |
| `fmv.x.s`    | `rd = s32(frs1)`                                                    |
| `fclass.s`   | `rd = f32_classify(f32(frs1))`                                      |
| `fmv.s.x`    | `frd = s32(rs1)`                                                    |
: RV32F - "RV32F Standard Extension for Single-Precision Floating-Point"

| ins name     | instruction pseudo code                                             |
|--------------|:--------------------------------------------------------------------|
| `fcvt.l.s`   | `frm = rm ; rd = s64(f32(frs1))`                                    |
| `fcvt.lu.s`  | `frm = rm ; rd = u64(f32(frs1))`                                    |
| `fcvt.s.l`   | `frm = rm ; frd = f32(s64(rs1))`                                    |
| `fcvt.s.lu`  | `frm = rm ; frd = f32(u64(rs1))`                                    |
: RV64F - "RV64F Standard Extension for Single-Precision Floating-Point (+ RV32F)"

| ins name     | instruction pseudo code                                             |
|--------------|:--------------------------------------------------------------------|
| `fld`        | `frd = f64[rs1 + imm]`                                              |
| `fsd`        | `f64[rs1 + imm] = f64(frs2)`                                        |
| `fmadd.d`    | `frm = rm ; frd = f64(frs1) * f64(frs2) + f64(frs3)`                |
| `fmsub.d`    | `frm = rm ; frd = f64(frs1) * f64(frs2) - f64(frs3)`                |
| `fnmadd.d`   | `frm = rm ; frd = f64(frs1) * -f64(frs2) - f64(frs3)`               |
| `fnmsub.d`   | `frm = rm ; frd = f64(frs1) * -f64(frs2) + f64(frs3)`               |
| `fadd.d`     | `frm = rm ; frd = f64(frs1) + f64(frs2)`                            |
| `fsub.d`     | `frm = rm ; frd = f64(frs1) - f64(frs2)`                            |
| `fmul.d`     | `frm = rm ; frd = f64(frs1) * f64(frs2)`                            |
| `fdiv.d`     | `frm = rm ; frd = f64(frs1) / f64(frs2)`                            |
| `fsgnj.d`    | `frd = f64_copysign(f64(frs1), f64(frs2))`                          |
| `fsgnjn.d`   | `frd = f64_copysign(f64(frs1), -f64(frs2))`                         |
| `fsgnjx.d`   | `frd = f64_xorsign(f64(frs1), f64(frs2))`                           |
| `fmin.d`     | `frd = f64_min(f64(frs1), f64(frs2))`                               |
| `fmax.d`     | `frd = f64_max(f64(frs1), f64(frs2))`                               |
| `fcvt.s.d`   | `frm = rm ; frd = f32(f64(frs1))`                                   |
| `fcvt.d.s`   | `frm = rm ; frd = f64(f32(frs1))`                                   |
| `fsqrt.d`    | `frm = rm ; frd = f64_sqrt(f64(frs1))`                              |
| `fle.d`      | `if f64(frs1) <= f64(frs2) then rd = 1 else rd = 0`                 |
| `flt.d`      | `if f64(frs1) < f64(frs2) then rd = 1 else rd = 0`                  |
| `feq.d`      | `if f64(frs1) = f64(frs2) then rd = 1 else rd = 0`                  |
| `fcvt.w.d`   | `frm = rm ; rd = s32(f64(frs1))`                                    |
| `fcvt.wu.d`  | `frm = rm ; if f64(frs1) > 0 then rd = u32(f64(frs1) else rd = 0`   |
| `fcvt.d.w`   | `frm = rm ; frd = f64(s32(rs1))`                                    |
| `fcvt.d.wu`  | `frm = rm ; frd = f64(u32(rs1))`                                    |
| `fclass.d`   | `rd = rd = f64_classify(f64(frs1))`                                 |
: RV32D - "RV32D Standard Extension for Double-Precision Floating-Point"

| ins name     | instruction pseudo code                                             |
|--------------|:--------------------------------------------------------------------|
| `fcvt.l.d`   | `frm = rm ; rd = s64(f64(frs1))`                                    |
| `fcvt.lu.d`  | `frm = rm ; if f64(frs1) > 0 then rd = u64(f64(frs1) else rd = 0`   |
| `fmv.x.d`    | `rd = s64(frs1)`                                                    |
| `fcvt.d.l`   | `frm = rm ; frd = f64(u64(rs1))`                                    |
| `fcvt.d.lu`  | `frm = rm ; frd = f64(s64(rs1))`                                    |
| `fmv.d.x`    | `frd = u64(rs1)`                                                    |
: RV64D - "RV64D Standard Extension for Double-Precision Floating-Point (+ RV32D)"

| ins name     | instruction pseudo code                                             |
|--------------|:--------------------------------------------------------------------|
| `flq`        | `frd = f128[rs1 + imm]`                                             |
| `fsq`        | `f128[rs1 + imm] = f128(frs2)`                                      |
| `fmadd.q`    | `frm = rm ; frd = f128(frs1) * f128(frs2) + f128(frs3)`             |
| `fmsub.q`    | `frm = rm ; frd = f128(frs1) * f128(frs2) - f128(frs3)`             |
| `fnmadd.q`   | `frm = rm ; frd = f128(frs1) * -f128(frs2) - f128(frs3)`            |
| `fnmsub.q`   | `frm = rm ; frd = f128(frs1) * -f128(frs2) + f128(frs3)`            |
| `fadd.q`     | `frm = rm ; frd = f128(frs1) + f128(frs2)`                          |
| `fsub.q`     | `frm = rm ; frd = f128(frs1) - f128(frs2)`                          |
| `fmul.q`     | `frm = rm ; frd = f128(frs1) * f128(frs2)`                          |
| `fdiv.q`     | `frm = rm ; frd = f128(frs1) / f128(frs2)`                          |
| `fsgnj.q`    | `frd = f128_copysign(f128(frs1), f128(frs2))`                       |
| `fsgnjn.q`   | `frd = f128_copysign(f128(frs1), -f128(frs2))`                      |
| `fsgnjx.q`   | `frd = f128_xorsign(f128(frs1), f128(frs2))`                        |
| `fmin.q`     | `frd = f128_min(f128(frs1), f128(frs2))`                            |
| `fmax.q`     | `frd = f128_max(f128(frs1), f128(frs2))`                            |
| `fcvt.s.q`   | `frm = rm ; frd = f32(f128(frs1))`                                  |
| `fcvt.q.s`   | `frm = rm ; frd = f128(f32(frs1))`                                  |
| `fcvt.d.q`   | `frm = rm ; frd = f64(f128(frs1))`                                  |
| `fcvt.q.d`   | `frm = rm ; frd = f128(f64(frs1))`                                  |
| `fsqrt.q`    | `frm = rm ; frd = f128_sqrt(f128(frs1))`                            |
| `fle.q`      | `if f128(frs1) <= f128(frs2) then rd = 1 else rd = 0`               |
| `flt.q`      | `if f128(frs1) < f128(frs2) then rd = 1 else rd = 0`                |
| `feq.q`      | `if f128(frs1) = f128(frs2) then rd = 1 else rd = 0`                |
| `fcvt.w.q`   | `frm = rm ; rd = s32(f128(frs1))`                                   |
| `fcvt.wu.q`  | `frm = rm ; if f128(frs1) > 0 then rd = u32(f128(frs1) else rd = 0` |
| `fcvt.q.w`   | `frm = rm ; frd = f128(s32(rs1))`                                   |
| `fcvt.q.wu`  | `frm = rm ; frd = f128(u32(rs1))`                                   |
| `fclass.q`   | `rd = rd = f128_classify(f128(frs1))`                               |
: RV32Q - "RV32Q Standard Extension for Quadruple-Precision Floating-Point"

| ins name     | instruction pseudo code                                             |
|--------------|:--------------------------------------------------------------------|
| `fcvt.l.q`   | `frm = rm ; rd = s64(f128(frs1))`                                   |
| `fcvt.lu.q`  | `frm = rm ; if f128(frs1) > 0 then rd = u64(f128(frs1) else rd = 0` |
| `fcvt.q.l`   | `frm = rm ; frd = f128(u64(rs1))`                                   |
| `fcvt.q.lu`  | `frm = rm ; frd = f128(s64(rs1))`                                   |
: RV64Q - "RV64Q Standard Extension for Quadruple-Precision Floating-Point (+ RV32Q)"

| ins name     | instruction pseudo code                                             |
|--------------|:--------------------------------------------------------------------|
| `fmv.x.q`    | `rd = s64(frs1)`                                                    |
| `fmv.q.x`    | `frd = u64(rs1)`                                                    |
: RV128Q - "RV128Q Standard Extension for Quadruple-Precision Floating-Point (+ RV64Q)"

| ins name     | instruction pseudo code                                             |
|--------------|:--------------------------------------------------------------------|
| `frcsr`      |                                                                     |
| `frrm`       |                                                                     |
| `frflags`    |                                                                     |
| `fscsr`      |                                                                     |
| `fsrm`       |                                                                     |
| `fsflags`    |                                                                     |
| `fsrmi`      |                                                                     |
| `fsflagsi`   |                                                                     |
: RV32FD - "RV32F and RV32D Common Floating-Point Instructions"
