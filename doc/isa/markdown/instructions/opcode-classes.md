## INSTRUCTION CLASSES

Format of a line in the table:

`<ins name> <class>`

| instruction  | class           |
|--------------|:----------------|
| `lui`        | `alu`           |
| `auipc`      | `alu`           |
| `jal`        | `jump`          |
| `jalr`       | `jump,indirect` |
| `beq`        | `branch`        |
| `bne`        | `branch`        |
| `blt`        | `branch`        |
| `bge`        | `branch`        |
| `bltu`       | `branch`        |
| `bgeu`       | `branch`        |
| `lb`         | `load`          |
| `lh`         | `load`          |
| `lw`         | `load`          |
| `lbu`        | `load`          |
| `lhu`        | `load`          |
| `lwu`        | `load`          |
| `sb`         | `store`         |
| `sh`         | `store`         |
| `sw`         | `store`         |
| `addi`       | `alu`           |
| `slti`       | `alu`           |
| `sltiu`      | `alu`           |
| `xori`       | `alu`           |
| `ori`        | `alu`           |
| `andi`       | `alu`           |
| `slli`       | `alu`           |
| `srli`       | `alu`           |
| `srai`       | `alu`           |
| `add`        | `alu`           |
| `sub`        | `alu`           |
| `sll`        | `alu`           |
| `slt`        | `alu`           |
| `sltu`       | `alu`           |
| `xor`        | `alu`           |
| `srl`        | `alu`           |
| `sra`        | `alu`           |
| `or`         | `alu`           |
| `and`        | `alu`           |
| `fence`      | `fence`         |
| `fence.i`    | `fence`         |
: RV32I - "RV32I Base Integer Instruction Set"

| instruction  | class           |
|--------------|:----------------|
| `ld`         | `load`          |
| `sd`         | `store`         |
| `addiw`      | `alu`           |
| `slliw`      | `alu`           |
| `srliw`      | `alu`           |
| `sraiw`      | `alu`           |
| `addw`       | `alu`           |
| `subw`       | `alu`           |
| `sllw`       | `alu`           |
| `srlw`       | `alu`           |
| `sraw`       | `alu`           |
: RV64I - "RV64I Base Integer Instruction Set (+ RV32I)"

| instruction  | class           |
|--------------|:----------------|
| `mul`        | `alu,multiply`  |
| `mulh`       | `alu,multiply`  |
| `mulhsu`     | `alu,multiply`  |
| `mulhu`      | `alu,multiply`  |
| `div`        | `alu,divide`    |
| `divu`       | `alu,divide`    |
| `rem`        | `alu,divide`    |
| `remu`       | `alu,divide`    |
: RV32M - "RV32M Standard Extension for Integer Multiply and Divide"

| instruction  | class           |
|--------------|:----------------|
| `mulw`       | `alu,multiply`  |
| `divw`       | `alu,multiply`  |
| `divuw`      | `alu,multiply`  |
| `remw`       | `alu,divide`    |
| `remuw`      | `alu,divide`    |
: RV64M - "RV64M Standard Extension for Integer Multiply and Divide (+ RV32M)"

| instruction  | class           |
|--------------|:----------------|
| `lr.w`       | `atomic`        |
| `sc.w`       | `atomic`        |
| `amoswap.w`  | `atomic`        |
| `amoadd.w`   | `atomic`        |
| `amoxor.w`   | `atomic`        |
| `amoor.w`    | `atomic`        |
| `amoand.w`   | `atomic`        |
| `amomin.w`   | `atomic`        |
| `amomax.w`   | `atomic`        |
| `amominu.w`  | `atomic`        |
| `amomaxu.w`  | `atomic`        |
: RV32A - "RV32A Standard Extension for Atomic Instructions"

| instruction  | class           |
|--------------|:----------------|
| `lr.d`       | `atomic`        |
| `sc.d`       | `atomic`        |
| `amoswap.d`  | `atomic`        |
| `amoadd.d`   | `atomic`        |
| `amoxor.d`   | `atomic`        |
| `amoor.d`    | `atomic`        |
| `amoand.d`   | `atomic`        |
| `amomin.d`   | `atomic`        |
| `amomax.d`   | `atomic`        |
| `amominu.d`  | `atomic`        |
| `amomaxu.d`  | `atomic`        |
: RV64A - "RV64A Standard Extension for Atomic Instructions (+ RV32A)"

| instruction  | class           |
|--------------|:----------------|
| `ecall`      | `system`        |
| `ebreak`     | `system`        |
| `uret`       | `system`        |
| `sret`       | `system`        |
| `hret`       | `system`        |
| `mret`       | `system`        |
| `dret`       | `system`        |
| `sfence.vm`  | `system`        |
| `wfi`        | `system`        |
| `rdcycle`    | `csr`           |
| `rdtime`     | `csr`           |
| `rdinstret`  | `csr`           |
| `rdcycleh`   | `csr`           |
| `rdtimeh`    | `csr`           |
| `rdinstreth` | `csr`           |
| `csrrw`      | `csr`           |
| `csrrs`      | `csr`           |
| `csrrc`      | `csr`           |
| `csrrwi`     | `csr`           |
| `csrrsi`     | `csr`           |
| `csrrci`     | `csr`           |
: RV32S - "RV32S Standard Extension for Supervisor-level Instructions"

| instruction  | class           |
|--------------|:----------------|
| `flw`        | `fpu,load`      |
| `fsw`        | `fpu,store`     |
| `fmadd.s`    | `fpu,fma`       |
| `fmsub.s`    | `fpu,fma`       |
| `fnmadd.s`   | `fpu,fma`       |
| `fnmsub.s`   | `fpu,fma`       |
| `fadd.s`     | `fpu`           |
| `fsub.s`     | `fpu`           |
| `fmul.s`     | `fpu`           |
| `fdiv.s`     | `fpu,fdiv`      |
| `fsgnj.s`    | `fpu`           |
| `fsgnjn.s`   | `fpu`           |
| `fsgnjx.s`   | `fpu`           |
| `fmin.s`     | `fpu`           |
| `fmax.s`     | `fpu`           |
| `fsqrt.s`    | `fpu,fsqrt`     |
| `fle.s`      | `fpu`           |
| `flt.s`      | `fpu`           |
| `feq.s`      | `fpu`           |
| `fcvt.w.s`   | `fpu,fcvt`      |
| `fcvt.wu.s`  | `fpu,fcvt`      |
| `fcvt.s.w`   | `fpu,fcvt`      |
| `fcvt.s.wu`  | `fpu,fcvt`      |
| `fmv.x.s`    | `fpu,fmove`     |
| `fclass.s`   | `fpu`           |
| `fmv.s.x`    | `fpu,fmove`     |
: RV32F - "RV32F Standard Extension for Single-Precision Floating-Point"

| instruction  | class           |
|--------------|:----------------|
| `fcvt.l.s`   | `fpu,fcvt`      |
| `fcvt.lu.s`  | `fpu,fcvt`      |
| `fcvt.s.l`   | `fpu,fcvt`      |
| `fcvt.s.lu`  | `fpu,fcvt`      |
: RV64F - "RV64F Standard Extension for Single-Precision Floating-Point (+ RV32F)"

| instruction  | class           |
|--------------|:----------------|
| `fld`        | `fpu,load`      |
| `fsd`        | `fpu,store`     |
| `fmadd.d`    | `fpu,fma`       |
| `fmsub.d`    | `fpu,fma`       |
| `fnmadd.d`   | `fpu,fma`       |
| `fnmsub.d`   | `fpu,fma`       |
| `fadd.d`     | `fpu`           |
| `fsub.d`     | `fpu`           |
| `fmul.d`     | `fpu`           |
| `fdiv.d`     | `fpu,fdiv`      |
| `fsgnj.d`    | `fpu`           |
| `fsgnjn.d`   | `fpu`           |
| `fsgnjx.d`   | `fpu`           |
| `fmin.d`     | `fpu`           |
| `fmax.d`     | `fpu`           |
| `fcvt.s.d`   | `fpu,fcvt`      |
| `fcvt.d.s`   | `fpu,fcvt`      |
| `fsqrt.d`    | `fpu,fsqrt`     |
| `fle.d`      | `fpu`           |
| `flt.d`      | `fpu`           |
| `feq.d`      | `fpu`           |
| `fcvt.w.d`   | `fpu,fcvt`      |
| `fcvt.wu.d`  | `fpu,fcvt`      |
| `fcvt.d.w`   | `fpu,fcvt`      |
| `fcvt.d.wu`  | `fpu,fcvt`      |
| `fclass.d`   | `fpu`           |
: RV32D - "RV32D Standard Extension for Double-Precision Floating-Point"

| instruction  | class           |
|--------------|:----------------|
| `fcvt.l.d`   | `fpu,fcvt`      |
| `fcvt.lu.d`  | `fpu,fcvt`      |
| `fmv.x.d`    | `fpu,fmove`     |
| `fcvt.d.l`   | `fpu,fcvt`      |
| `fcvt.d.lu`  | `fpu,fcvt`      |
| `fmv.d.x`    | `fpu,fmove`     |
: RV64D - "RV64D Standard Extension for Double-Precision Floating-Point (+ RV32D)"

| instruction  | class           |
|--------------|:----------------|
| `frcsr`      | `csr`           |
| `frrm`       | `csr`           |
| `frflags`    | `csr`           |
| `fscsr`      | `csr`           |
| `fsrm`       | `csr`           |
| `fsflags`    | `csr`           |
| `fsrmi`      | `csr`           |
| `fsflagsi`   | `csr`           |
: RV32FD - "RV32F and RV32D Common Floating-Point Instructions"
