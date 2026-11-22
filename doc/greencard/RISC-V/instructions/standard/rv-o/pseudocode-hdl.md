## INSTRUCTION PSEUDO-CODE (HDL)

| **Extension** | **Name** | **Variable-Fields**            | **Pseudo-Code**                                              |
|:--------------|:---------|:-------------------------------|:-------------------------------------------------------------|
| `rv_o`        | `add`    | `rd, rs1, rs2`                 | `rd = sx(rs1) + sx(rs2)`                                     |
| `rv_o`        | `addi`   | `rd, rs1, imm12`               | `rd = rs1 + sx(imm12)`                                       |
| `rv_o`        | `and`    | `rd, rs1, rs2`                 | `rd = ux(rs1) & ux(rs2)`                                     |
| `rv_o`        | `andi`   | `rd, rs1, imm12`               | `rd = ux(rs1) & ux(imm12)`                                   |
| `rv_o`        | `auipc`  | `rd, imm20`                    | `rd = pc + oimm20`                                           |
| `rv_o`        | `beq`    | `bimm12hi, rs1, rs2, bimm12lo` | `if rs1 = rs2 then pc = pc + sbimm12`                        |
| `rv_o`        | `bge`    | `bimm12hi, rs1, rs2, bimm12lo` | `if rs1 >= rs2 then pc = pc + sbimm12`                       |
| `rv_o`        | `bgeu`   | `bimm12hi, rs1, rs2, bimm12lo` | `if rs1 >= rs2 then pc = pc + sbimm12`                       |
| `rv_o`        | `blt`    | `bimm12hi, rs1, rs2, bimm12lo` | `if rs1 < rs2 then pc = pc + sbimm12`                        |
| `rv_o`        | `bltu`   | `bimm12hi, rs1, rs2, bimm12lo` | `if rs1 < rs2 then pc = pc + sbimm12`                        |
| `rv_o`        | `bne`    | `bimm12hi, rs1, rs2, bimm12lo` | `if rs1 != rs2 then pc = pc + sbimm12`                       |
| `rv_o`        | `ebreak` | `none`                         | `breakpoint()`                                               |
| `rv_o`        | `ecall`  | `none`                         | `trap(environment_call, privilege)`                          |
| `rv_o`        | `fence`  | `fm, pred, succ, rs1, rd`      | `order_memory_and_io(inst[31:28], inst[27:24], inst[23:20])` |
| `rv_o`        | `jal`    | `rd, jimm20`                   | `rd = pc + length(inst); pc = pc + jimm20`                   |
| `rv_o`        | `jalr`   | `rd, rs1, imm12`               | `rd = pc + length(inst); pc = (rs1 + oimm12) & -2`           |
| `rv_o`        | `lb`     | `rd, rs1, imm12`               | `rd = s8[rs1 + oimm12]`                                      |
| `rv_o`        | `lbu`    | `rd, rs1, imm12`               | `rd = u8[rs1 + oimm12]`                                      |
| `rv_o`        | `lh`     | `rd, rs1, imm12`               | `rd = s16[rs1 + oimm12]`                                     |
| `rv_o`        | `lhu`    | `rd, rs1, imm12`               | `rd = u16[rs1 + oimm12]`                                     |
| `rv_o`        | `lui`    | `rd, imm20`                    | `rd = imm20`                                                 |
| `rv_o`        | `lw`     | `rd, rs1, imm12`               | `rd = s32[rs1 + oimm12]`                                     |
| `rv_o`        | `or`     | `rd, rs1, rs2`                 | `rd = ux(rs1) \| ux(rs2)`                                    |
| `rv_o`        | `ori`    | `rd, rs1, imm12`               | `rd = ux(rs1) \| ux(imm12)`                                  |
| `rv_o`        | `sb`     | `imm12hi, rs1, rs2, imm12lo`   | `u8[rs1 + simm12] = rs2`                                     |
| `rv_o`        | `sh`     | `imm12hi, rs1, rs2, imm12lo`   | `u16[rs1 + simm12] = rs2`                                    |
| `rv_o`        | `sll`    | `rd, rs1, rs2`                 | `rd = ux(rs1) << rs2`                                        |
| `rv_o`        | `slt`    | `rd, rs1, rs2`                 | `rd = sx(rs1) < sx(rs2)`                                     |
| `rv_o`        | `slti`   | `rd, rs1, imm12`               | `rd = sx(rs1) < sx(imm12)`                                   |
| `rv_o`        | `sltiu`  | `rd, rs1, imm12`               | `rd = ux(rs1) < ux(imm12)`                                   |
| `rv_o`        | `sltu`   | `rd, rs1, rs2`                 | `rd = ux(rs1) < ux(rs2)`                                     |
| `rv_o`        | `sra`    | `rd, rs1, rs2`                 | `rd = sx(rs1) >> rs2`                                        |
| `rv_o`        | `srl`    | `rd, rs1, rs2`                 | `rd = ux(rs1) >> rs2`                                        |
| `rv_o`        | `sub`    | `rd, rs1, rs2`                 | `rd = sx(rs1) - sx(rs2); rs1 + ~rs2 + 1`                     |
| `rv_o`        | `sw`     | `imm12hi, rs1, rs2, imm12lo`   | `u32[rs1 + simm12] = rs2`                                    |
| `rv_o`        | `xor`    | `rd, rs1, rs2`                 | `rd = ux(rs1) ^ ux(rs2)`                                     |
| `rv_o`        | `xori`   | `rd, rs1, imm12`               | `rd = ux(rs1) ^ ux(imm12)`                                   |

:RVO - Standard Extension for Extended Instructions

| **Extension** | **Name** | **Variable-Fields**          | **Pseudo-Code**                |
|:--------------|:---------|:-----------------------------|:-------------------------------|
| `rv64_o`      | `addiw`  | `rd, rs1, imm12`             | `rd = s32(rs1) + imm12`        |
| `rv64_o`      | `addw`   | `rd, rs1, rs2`               | `rd = s32(rs1) + s32(rs2)`     |
| `rv64_o`      | `ld`     | `rd, rs1, imm12`             | `rd = u64[rs1 + oimm12]`       |
| `rv64_o`      | `lwu`    | `rd, rs1, imm12`             | `rd = u32[rs1 + oimm12]`       |
| `rv64_o`      | `sd`     | `imm12hi, rs1, rs2, imm12lo` | `u64[rs1 + simm12] = rs2`      |
| `rv64_o`      | `slli`   | `rd, rs1, shamtd`            | `rd = ux(rs1) << ux(shamt6)`   |
| `rv64_o`      | `slliw`  | `rd, rs1, shamtw`            | `rd = s32(u32(rs1) << shamt5)` |
| `rv64_o`      | `sllw`   | `rd, rs1, rs2`               | `rd = s32(u32(rs1) << rs2)`    |
| `rv64_o`      | `srai`   | `rd, rs1, shamtd`            | `rd = sx(rs1) >> ux(shamt6)`   |
| `rv64_o`      | `sraiw`  | `rd, rs1, shamtw`            | `rd = s32(rs1) >> shamt5`      |
| `rv64_o`      | `sraw`   | `rd, rs1, rs2`               | `rd = s32(rs1) >> rs2`         |
| `rv64_o`      | `srli`   | `rd, rs1, shamtd`            | `rd = ux(rs1) >> ux(shamt6)`   |
| `rv64_o`      | `srliw`  | `rd, rs1, shamtw`            | `rd = s32(u32(rs1) >> shamt5)` |
| `rv64_o`      | `srlw`   | `rd, rs1, rs2`               | `rd = s32(u32(rs1) >> rs2)`    |
| `rv64_o`      | `subw`   | `rd, rs1, rs2`               | `rd = s32(rs1) - s32(rs2)`     |

:RV64O - Standard Extension for Extended Instructions (64 bit)

| **Extension** | **Name** | **Variable-Fields**          | **Pseudo-Code**                                  |
|:--------------|:---------|:-----------------------------|:-------------------------------------------------|
| `rv128_o`     | `addid`  | `rd, rs1, imm12`             | `rd = sx(s64(u64(rs1) + u64(sx(imm12))))`        |
| `rv128_o`     | `addd`   | `rd, rs1, rs2`               | `rd = sx(s64(u64(rs1) + u64(rs2)))`              |
| `rv128_o`     | `lq`     | `rd, rs1, imm12`             | `rd = u128[rs1 + imm12]`                         |
| `rv128_o`     | `ldu`    | `rd, rs1, imm12`             | `rd = ux(u64[rs1 + imm12])`                      |
| `rv128_o`     | `sq`     | `imm12hi, rs1, rs2, imm12lo` | `u128[rs1 + sx(concat(imm12hi, imm12lo))] = rs2` |
| `rv128_o`     | `slli`   | `rd, rs1, shamt7`            | `rd = ux(rs1) << ux(shamt7)`                     |
| `rv128_o`     | `sllid`  | `rd, rs1, shamt6`            | `rd = sx(s64(u64(rs1) << ux(shamt6)))`           |
| `rv128_o`     | `slld`   | `rd, rs1, rs2`               | `rd = sx(s64(u64(rs1) << (rs2 & 0b111111)))`     |
| `rv128_o`     | `srai`   | `rd, rs1, shamt7`            | `rd = sx(rs1) >> ux(shamt7)`                     |
| `rv128_o`     | `sraid`  | `rd, rs1, shamt6`            | `rd = sx(s64(s64(rs1) >> ux(shamt6)))`           |
| `rv128_o`     | `srad`   | `rd, rs1, rs2`               | `rd = sx(s64(s64(rs1) >> (rs2 & 0b111111)))`     |
| `rv128_o`     | `srli`   | `rd, rs1, shamt7`            | `rd = ux(rs1) >> ux(shamt7)`                     |
| `rv128_o`     | `srlid`  | `rd, rs1, shamt6`            | `rd = sx(s64(u64(rs1) >> ux(shamt6)))`           |
| `rv128_o`     | `srld`   | `rd, rs1, rs2`               | `rd = sx(s64(u64(rs1) >> (rs2 & 0b111111)))`     |
| `rv128_o`     | `subd`   | `rd, rs1, rs2`               | `rd = sx(s64(u64(rs1) - u64(rs2)))`              |

:RV128O - Standard Extension for Extended Instructions (128 bit)
