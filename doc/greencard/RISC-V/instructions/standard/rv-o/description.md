## INSTRUCTION DESCRIPTIONS

| **Extension** | **Name** | **Variable-Fields**            | **Description**                                                                                                          |
|:--------------|:---------|:-------------------------------|:-------------------------------------------------------------------------------------------------------------------------|
| `rv_o`        | `add`    | `rd, rs1, rs2`                 | `Add rs2 to rs1 and place the result into rd`                                                                            |
| `rv_o`        | `addi`   | `rd, rs1, imm12`               | `Add sign-extended 12-bit immediate imm12 to register rs1 and place the result in rd`                                    |
| `rv_o`        | `and`    | `rd, rs1, rs2`                 | `Set rd to the bitwise and of rs1 and rs2`                                                                               |
| `rv_o`        | `andi`   | `rd, rs1, imm12`               | `Set rd to the bitwise and of rs1 with the sign-extended 12-bit immediate imm12`                                         |
| `rv_o`        | `auipc`  | `rd, imm20`                    | `Form a signed offset from oimm20 with the low 12 bits set to zero, add it to the PC, and place the result into rd`      |
| `rv_o`        | `beq`    | `bimm12hi, rs1, rs2, bimm12lo` | `Branch to the PC plus the signed offset sbimm12 if rs1 == rs2`                                                          |
| `rv_o`        | `bge`    | `bimm12hi, rs1, rs2, bimm12lo` | `Branch to the PC plus the signed offset sbimm12 if rs1 >= rs2 (signed)`                                                 |
| `rv_o`        | `bgeu`   | `bimm12hi, rs1, rs2, bimm12lo` | `Branch to the PC plus the signed offset sbimm12 if rs1 >= rs2 (unsigned)`                                               |
| `rv_o`        | `blt`    | `bimm12hi, rs1, rs2, bimm12lo` | `Branch to the PC plus the signed offset sbimm12 if rs1 < rs2 (signed)`                                                  |
| `rv_o`        | `bltu`   | `bimm12hi, rs1, rs2, bimm12lo` | `Branch to the PC plus the signed offset sbimm12 if rs1 < rs2 (unsigned)`                                                |
| `rv_o`        | `bne`    | `bimm12hi, rs1, rs2, bimm12lo` | `Branch to the PC plus the signed offset sbimm12 if rs1 != rs2`                                                          |
| `rv_o`        | `ebreak` | `none`                         | `Raise a breakpoint exception or enter Debug Mode when enabled`                                                          |
| `rv_o`        | `ecall`  | `none`                         | `Raise an environment call exception for the current privilege mode`                                                     |
| `rv_o`        | `fence`  | `fm, pred, succ, rs1, rd`      | `Order device I/O and memory accesses viewed by other threads and devices`                                               |
| `rv_o`        | `jal`    | `rd, jimm20`                   | `Jump to the PC plus the signed offset jimm20 and save PC+4 into rd`                                                     |
| `rv_o`        | `jalr`   | `rd, rs1, imm12`               | `Jump to rs1 plus the signed 12-bit offset oimm12 with the low bit cleared and save PC+4 into rd`                        |
| `rv_o`        | `lb`     | `rd, rs1, imm12`               | `Load 8-bit value from addr in rs1 plus the signed 12-bit offset oimm12 and place sign-extended result into rd`          |
| `rv_o`        | `lbu`    | `rd, rs1, imm12`               | `Load 8-bit value from addr in rs1 plus the signed 12-bit offset oimm12 and place zero-extended result into rd`          |
| `rv_o`        | `lh`     | `rd, rs1, imm12`               | `Load 16-bit value from addr in rs1 plus the signed 12-bit offset oimm12 and place sign-extended result into rd`         |
| `rv_o`        | `lhu`    | `rd, rs1, imm12`               | `Load 16-bit value from addr in rs1 plus the signed 12-bit offset oimm12 and place zero-extended result into rd`         |
| `rv_o`        | `lui`    | `rd, imm20`                    | `Place imm20 in the upper 20 bits of a 32-bit value, clear its low 12 bits, and sign-extend the result into rd`          |
| `rv_o`        | `lw`     | `rd, rs1, imm12`               | `Load 32-bit value from addr in rs1 plus the signed 12-bit offset oimm12 and place sign-extended result into rd`         |
| `rv_o`        | `or`     | `rd, rs1, rs2`                 | `Set rd to the bitwise or of rs1 and rs2`                                                                                |
| `rv_o`        | `ori`    | `rd, rs1, imm12`               | `Set rd to the bitwise or of rs1 with the sign-extended 12-bit immediate imm12`                                          |
| `rv_o`        | `sb`     | `imm12hi, rs1, rs2, imm12lo`   | `Store 8-bit value from the low bits of rs2 to addr in rs1 plus the signed 12-bit offset simm12`                         |
| `rv_o`        | `sh`     | `imm12hi, rs1, rs2, imm12lo`   | `Store 16-bit value from the low bits of rs2 to addr in rs1 plus the signed 12-bit offset simm12`                        |
| `rv_o`        | `sll`    | `rd, rs1, rs2`                 | `Shift rs1 left by the by the lower 5 or 6 (RV32/64) bits in rs2 and place the result into rd`                           |
| `rv_o`        | `slt`    | `rd, rs1, rs2`                 | `Set rd to 1 if rs1 is less than rs2, otherwise set rd to 0 (signed)`                                                    |
| `rv_o`        | `slti`   | `rd, rs1, imm12`               | `Set rd to 1 if rs1 is less than the sign-extended 12-bit immediate imm12, otherwise set rd to 0 (signed)`               |
| `rv_o`        | `sltiu`  | `rd, rs1, imm12`               | `Set rd to 1 if rs1 is less than the sign-extended 12-bit immediate imm12, otherwise set rd to 0 (unsigned)`             |
| `rv_o`        | `sltu`   | `rd, rs1, rs2`                 | `Set rd to 1 if rs1 is less than rs2, otherwise set rd to 0 (unsigned)`                                                  |
| `rv_o`        | `sra`    | `rd, rs1, rs2`                 | `Shift rs1 right by the by the lower 5 or 6 (RV32/64) bits in rs2 and place the result into rd while retaining the sign` |
| `rv_o`        | `srl`    | `rd, rs1, rs2`                 | `Shift rs1 right by the by the lower 5 or 6 (RV32/64) bits in rs2 and place the result into rd`                          |
| `rv_o`        | `sub`    | `rd, rs1, rs2`                 | `Subtract rs2 from rs1 and place the result into rd`                                                                     |
| `rv_o`        | `sw`     | `imm12hi, rs1, rs2, imm12lo`   | `Store 32-bit value from the low bits of rs2 to addr in rs1 plus the signed 12-bit offset simm12`                        |
| `rv_o`        | `xor`    | `rd, rs1, rs2`                 | `Set rd to the bitwise xor of rs1 and rs2`                                                                               |
| `rv_o`        | `xori`   | `rd, rs1, imm12`               | `Set rd to the bitwise xor of rs1 with the sign-extended 12-bit immediate imm12`                                         |

:RVO - Standard Extension for Extended Instructions

| **Extension** | **Name** | **Variable-Fields**          | **Description**                                                                                                                  |
|:--------------|:---------|:-----------------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `rv64_o`      | `addiw`  | `rd, rs1, imm12`             | `Add the sign-extended 12-bit immediate imm12 to rs1 and sign-extend the low 32 bits of the result into rd`                      |
| `rv64_o`      | `addw`   | `rd, rs1, rs2`               | `Add 32-bit value in rs2 to rs1 and place the 32-bit result into rd`                                                             |
| `rv64_o`      | `ld`     | `rd, rs1, imm12`             | `Load 64-bit value from addr in rs1 plus signed 12-bit offset oimm12 and place sign-extended result into rd`                     |
| `rv64_o`      | `lwu`    | `rd, rs1, imm12`             | `Load 32-bit value from addr in rs1 plus the signed 12-bit offset oimm12 and place zero-extended result into rd`                 |
| `rv64_o`      | `sd`     | `imm12hi, rs1, rs2, imm12lo` | `Store 64-bit value from the low bits of rs2 to addr in rs1 plus the signed 12-bit offset simm12`                                |
| `rv64_o`      | `slli`   | `rd, rs1, shamtd`            | `Shift rs1 left by the 6-bit immediate shamt6 and place the result into rd`                                                      |
| `rv64_o`      | `slliw`  | `rd, rs1, shamtw`            | `Shift the low 32 bits of rs1 left by shamt5 and sign-extend the 32-bit result into rd`                                          |
| `rv64_o`      | `sllw`   | `rd, rs1, rs2`               | `Shift 32-bit value in rs1 left by the by the lower 5 bits in rs2 and place the 32-bit result into rd`                           |
| `rv64_o`      | `srai`   | `rd, rs1, shamtd`            | `Shift rs1 right by the 6-bit immediate shamt6 with sign fill and place the result into rd`                                      |
| `rv64_o`      | `sraiw`  | `rd, rs1, shamtw`            | `Shift the low 32 bits of rs1 right by shamt5 with sign fill and sign-extend the 32-bit result into rd`                          |
| `rv64_o`      | `sraw`   | `rd, rs1, rs2`               | `Shift 32-bit value in rs1 right by the by the lower 5 bits in rs2 and place the 32-bit result into rd while retaining the sign` |
| `rv64_o`      | `srli`   | `rd, rs1, shamtd`            | `Shift rs1 right by the 6-bit immediate shamt6 with zero fill and place the result into rd`                                      |
| `rv64_o`      | `srliw`  | `rd, rs1, shamtw`            | `Shift the low 32 bits of rs1 right by shamt5 with zero fill and sign-extend the 32-bit result into rd`                          |
| `rv64_o`      | `srlw`   | `rd, rs1, rs2`               | `Shift 32-bit value in rs1 right by the by the lower 5 bits in rs2 and place the 32-bit result into rd`                          |
| `rv64_o`      | `subw`   | `rd, rs1, rs2`               | `Subtract 32-bit value in rs2 from rs1 and place the 32-bit result into rd`                                                      |

:RV64O - Standard Extension for Extended Instructions (64 bit)

| **Extension** | **Name** | **Variable-Fields**          | **Description**                                                                                                             |
|:--------------|:---------|:-----------------------------|:----------------------------------------------------------------------------------------------------------------------------|
| `rv128_o`     | `addid`  | `rd, rs1, imm12`             | `Add the signed 12-bit immediate imm12 to the low 64 bits of rs1 and sign-extend the low 64 bits of the result into rd`     |
| `rv128_o`     | `addd`   | `rd, rs1, rs2`               | `Add the low 64 bits of rs1 and rs2 and sign-extend the low 64 bits of the result into rd`                                  |
| `rv128_o`     | `lq`     | `rd, rs1, imm12`             | `Load a 128-bit value from the address in rs1 plus the signed 12-bit offset imm12 and place the result into rd`             |
| `rv128_o`     | `ldu`    | `rd, rs1, imm12`             | `Load a 64-bit value from the address in rs1 plus the signed 12-bit offset imm12 and zero-extend the result into rd`        |
| `rv128_o`     | `sq`     | `imm12hi, rs1, rs2, imm12lo` | `Store the 128-bit value in rs2 to the address in rs1 plus the signed 12-bit offset the signed immediate`                   |
| `rv128_o`     | `slli`   | `rd, rs1, shamt7`            | `Shift rs1 left by the 7-bit immediate shamt7 and place the result into rd`                                                 |
| `rv128_o`     | `sllid`  | `rd, rs1, shamt6`            | `Shift the low 64 bits of rs1 left by the 6-bit immediate shamt6 and sign-extend the 64-bit result into rd`                 |
| `rv128_o`     | `slld`   | `rd, rs1, rs2`               | `Shift the low 64 bits of rs1 left by the low 6 bits of rs2 and sign-extend the 64-bit result into rd`                      |
| `rv128_o`     | `srai`   | `rd, rs1, shamt7`            | `Shift rs1 right by the 7-bit immediate shamt7 with sign fill and place the result into rd`                                 |
| `rv128_o`     | `sraid`  | `rd, rs1, shamt6`            | `Shift the low 64 bits of rs1 right by the 6-bit immediate shamt6 with sign fill and sign-extend the 64-bit result into rd` |
| `rv128_o`     | `srad`   | `rd, rs1, rs2`               | `Shift the low 64 bits of rs1 right by the low 6 bits of rs2 with sign fill and sign-extend the 64-bit result into rd`      |
| `rv128_o`     | `srli`   | `rd, rs1, shamt7`            | `Shift rs1 right by the 7-bit immediate shamt7 with zero fill and place the result into rd`                                 |
| `rv128_o`     | `srlid`  | `rd, rs1, shamt6`            | `Shift the low 64 bits of rs1 right by the 6-bit immediate shamt6 with zero fill and sign-extend the 64-bit result into rd` |
| `rv128_o`     | `srld`   | `rd, rs1, rs2`               | `Shift the low 64 bits of rs1 right by the low 6 bits of rs2 with zero fill and sign-extend the 64-bit result into rd`      |
| `rv128_o`     | `subd`   | `rd, rs1, rs2`               | `Subtract the low 64 bits of rs2 from the low 64 bits of rs1 and sign-extend the low 64 bits of the result into rd`         |

:RV128O - Standard Extension for Extended Instructions (128 bit)
