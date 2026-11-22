## INSTRUCTION PSEUDO-CODE (PL)

| **Extension** | **Name** | **Variable-Fields**            | **Pseudo-Code**                                                                            |
|:--------------|:---------|:-------------------------------|:-------------------------------------------------------------------------------------------|
| `rv_o`        | `add`    | `rd, rs1, rs2`                 | `rd = sx(rs1) + sx(rs2)`                                                                   |
| `rv_o`        | `addi`   | `rd, rs1, imm12`               | `rd = sx(rs1) + sx(imm12)`                                                                 |
| `rv_o`        | `and`    | `rd, rs1, rs2`                 | `rd = ux(rs1) & ux(rs2)`                                                                   |
| `rv_o`        | `andi`   | `rd, rs1, imm12`               | `rd = ux(rs1) & ux(imm12)`                                                                 |
| `rv_o`        | `auipc`  | `rd, imm20`                    | `rd = pc + oimm20`                                                                         |
| `rv_o`        | `beq`    | `bimm12hi, rs1, rs2, bimm12lo` | `if (sx(rs1) == sx(rs2)) pc_offset = sbimm12`                                              |
| `rv_o`        | `bge`    | `bimm12hi, rs1, rs2, bimm12lo` | `if (sx(rs1) >= sx(rs2)) pc_offset = sbimm12`                                              |
| `rv_o`        | `bgeu`   | `bimm12hi, rs1, rs2, bimm12lo` | `if (ux(rs1) >= ux(rs2)) pc_offset = sbimm12`                                              |
| `rv_o`        | `blt`    | `bimm12hi, rs1, rs2, bimm12lo` | `if (sx(rs1) < sx(rs2)) pc_offset = sbimm12`                                               |
| `rv_o`        | `bltu`   | `bimm12hi, rs1, rs2, bimm12lo` | `if (ux(rs1) < ux(rs2)) pc_offset = sbimm12`                                               |
| `rv_o`        | `bne`    | `bimm12hi, rs1, rs2, bimm12lo` | `if (sx(rs1) != sx(rs2)) pc_offset = sbimm12`                                              |
| `rv_o`        | `ebreak` | `none`                         | `raise_breakpoint_or_enter_debug()`                                                        |
| `rv_o`        | `ecall`  | `none`                         | `trap(environment_call, privilege)`                                                        |
| `rv_o`        | `fence`  | `fm, pred, succ, rs1, rd`      | `order_memory_and_io(inst[31:28], inst[27:24], inst[23:20])`                               |
| `rv_o`        | `jal`    | `rd, jimm20`                   | `rd = pc + length(inst); pc_offset = jimm20`                                               |
| `rv_o`        | `jalr`   | `rd, rs1, imm12`               | `ux new_offset = (rs1 + oimm12 - pc) & ~1; rd = pc + length(inst); pc_offset = new_offset` |
| `rv_o`        | `lb`     | `rd, rs1, imm12`               | `s8 t; mmu.load<s8>(rs1 + oimm12, t); rd = t; rd = sx(*(s8*)ptr(rs1 + oimm12))`            |
| `rv_o`        | `lbu`    | `rd, rs1, imm12`               | `u8 t; mmu.load<u8>(rs1 + oimm12, t); rd = t; rd = ux(*(u8*)ptr(rs1 + oimm12))`            |
| `rv_o`        | `lh`     | `rd, rs1, imm12`               | `s16 t; mmu.load<s16>(rs1 + oimm12, t); rd = t; rd = sx(*(s16*)ptr(rs1 + oimm12))`         |
| `rv_o`        | `lhu`    | `rd, rs1, imm12`               | `u16 t; mmu.load<u16>(rs1 + oimm12, t); rd = t; rd = ux(*(u16*)ptr(rs1 + oimm12))`         |
| `rv_o`        | `lui`    | `rd, imm20`                    | `rd = imm20`                                                                               |
| `rv_o`        | `lw`     | `rd, rs1, imm12`               | `s32 t; mmu.load<s32>(rs1 + oimm12, t); rd = t; rd = sx(*(s32*)ptr(rs1 + oimm12))`         |
| `rv_o`        | `or`     | `rd, rs1, rs2`                 | `rd = ux(rs1) \| ux(rs2)`                                                                  |
| `rv_o`        | `ori`    | `rd, rs1, imm12`               | `rd = ux(rs1) \| ux(imm12)`                                                                |
| `rv_o`        | `sb`     | `imm12hi, rs1, rs2, imm12lo`   | `mmu.store<s8>(rs1 + simm12, s8(rs2)); *((u8*)ptr(rs1 + simm12)) = rs2`                    |
| `rv_o`        | `sh`     | `imm12hi, rs1, rs2, imm12lo`   | `mmu.store<s16>(rs1 + simm12, s16(rs2)); *((u16*)ptr(rs1 + simm12)) = rs2`                 |
| `rv_o`        | `sll`    | `rd, rs1, rs2`                 | `rd = ux(rs1) << (rs2 & 0b1111111); 7-bit mask for RV128O`                                 |
| `rv_o`        | `slt`    | `rd, rs1, rs2`                 | `rd = sx(rs1) < sx(rs2)`                                                                   |
| `rv_o`        | `slti`   | `rd, rs1, imm12`               | `rd = sx(rs1) < sx(imm12)`                                                                 |
| `rv_o`        | `sltiu`  | `rd, rs1, imm12`               | `rd = ux(rs1) < ux(imm12)`                                                                 |
| `rv_o`        | `sltu`   | `rd, rs1, rs2`                 | `rd = ux(rs1) < ux(rs2)`                                                                   |
| `rv_o`        | `sra`    | `rd, rs1, rs2`                 | `rd = sx(rs1) >> (rs2 & 0b1111111); 7-bit mask for RV128O`                                 |
| `rv_o`        | `srl`    | `rd, rs1, rs2`                 | `rd = ux(rs1) >> (rs2 & 0b1111111); 7-bit mask for RV128O`                                 |
| `rv_o`        | `sub`    | `rd, rs1, rs2`                 | `rd = sx(rs1) - sx(rs2)`                                                                   |
| `rv_o`        | `sw`     | `imm12hi, rs1, rs2, imm12lo`   | `mmu.store<s32>(rs1 + simm12, s32(rs2)); *((u32*)ptr(rs1 + simm12)) = rs2`                 |
| `rv_o`        | `xor`    | `rd, rs1, rs2`                 | `rd = ux(rs1) ^ ux(rs2)`                                                                   |
| `rv_o`        | `xori`   | `rd, rs1, imm12`               | `rd = ux(rs1) ^ ux(imm12)`                                                                 |

:RVO - Standard Extension for Extended Instructions

| **Extension** | **Name** | **Variable-Fields**          | **Pseudo-Code**                                                                    |
|:--------------|:---------|:-----------------------------|:-----------------------------------------------------------------------------------|
| `rv64_o`      | `addiw`  | `rd, rs1, imm12`             | `rd = s32(s32(rs1) + imm12); clang requires -fwrapv`                               |
| `rv64_o`      | `addw`   | `rd, rs1, rs2`               | `rd = s32(s32(rs1) + s32(rs2)); clang requires -fwrapv`                            |
| `rv64_o`      | `ld`     | `rd, rs1, imm12`             | `s64 t; mmu.load<s64>(rs1 + oimm12, t); rd = t; rd = sx(*(s64*)ptr(rs1 + oimm12))` |
| `rv64_o`      | `lwu`    | `rd, rs1, imm12`             | `u32 t; mmu.load<u32>(rs1 + oimm12, t); rd = t; rd = ux(*(u32*)ptr(rs1 + oimm12))` |
| `rv64_o`      | `sd`     | `imm12hi, rs1, rs2, imm12lo` | `mmu.store<s64>(rs1 + simm12, s64(rs2)); *(u64*)ptr(rs1 + simm12) = rs2`           |
| `rv64_o`      | `slli`   | `rd, rs1, shamtd`            | `rd = ux(rs1) << shamt6`                                                           |
| `rv64_o`      | `slliw`  | `rd, rs1, shamtw`            | `rd = s32(u32(rs1) << shamt5)`                                                     |
| `rv64_o`      | `sllw`   | `rd, rs1, rs2`               | `rd = s32(u32(rs1) << (rs2 & 0b11111))`                                            |
| `rv64_o`      | `srai`   | `rd, rs1, shamtd`            | `rd = sx(rs1) >> shamt6`                                                           |
| `rv64_o`      | `sraiw`  | `rd, rs1, shamtw`            | `rd = s32(rs1) >> shamt5`                                                          |
| `rv64_o`      | `sraw`   | `rd, rs1, rs2`               | `rd = s32(s32(rs1) >> (rs2 & 0b11111))`                                            |
| `rv64_o`      | `srli`   | `rd, rs1, shamtd`            | `rd = ux(rs1) >> shamt6`                                                           |
| `rv64_o`      | `srliw`  | `rd, rs1, shamtw`            | `rd = s32(u32(rs1) >> shamt5)`                                                     |
| `rv64_o`      | `srlw`   | `rd, rs1, rs2`               | `rd = s32(u32(rs1) >> (rs2 & 0b11111))`                                            |
| `rv64_o`      | `subw`   | `rd, rs1, rs2`               | `rd = s32(s32(rs1) - s32(rs2)); clang requires -fwrapv`                            |

:RV64O - Standard Extension for Extended Instructions (64 bit)

| **Extension** | **Name** | **Variable-Fields**          | **Pseudo-Code**                                                  |
|:--------------|:---------|:-----------------------------|:-----------------------------------------------------------------|
| `rv128_o`     | `addid`  | `rd, rs1, imm12`             | `rd = sx(s64(u64(rs1) + u64(sx(imm12))))`                        |
| `rv128_o`     | `addd`   | `rd, rs1, rs2`               | `rd = sx(s64(u64(rs1) + u64(rs2)))`                              |
| `rv128_o`     | `lq`     | `rd, rs1, imm12`             | `u128 t; mmu.load<u128>(rs1 + imm12, t); rd = t`                 |
| `rv128_o`     | `ldu`    | `rd, rs1, imm12`             | `u64 t; mmu.load<u64>(rs1 + imm12, t); rd = ux(t)`               |
| `rv128_o`     | `sq`     | `imm12hi, rs1, rs2, imm12lo` | `mmu.store<u128>(rs1 + sx(concat(imm12hi, imm12lo)), u128(rs2))` |
| `rv128_o`     | `slli`   | `rd, rs1, shamt7`            | `rd = ux(rs1) << shamt7`                                         |
| `rv128_o`     | `sllid`  | `rd, rs1, shamt6`            | `rd = sx(s64(u64(rs1) << shamt6))`                               |
| `rv128_o`     | `slld`   | `rd, rs1, rs2`               | `rd = sx(s64(u64(rs1) << (rs2 & 0b111111)))`                     |
| `rv128_o`     | `srai`   | `rd, rs1, shamt7`            | `rd = sx(rs1) >> shamt7`                                         |
| `rv128_o`     | `sraid`  | `rd, rs1, shamt6`            | `rd = sx(s64(s64(rs1) >> shamt6))`                               |
| `rv128_o`     | `srad`   | `rd, rs1, rs2`               | `rd = sx(s64(s64(rs1) >> (rs2 & 0b111111)))`                     |
| `rv128_o`     | `srli`   | `rd, rs1, shamt7`            | `rd = ux(rs1) >> shamt7`                                         |
| `rv128_o`     | `srlid`  | `rd, rs1, shamt6`            | `rd = sx(s64(u64(rs1) >> shamt6))`                               |
| `rv128_o`     | `srld`   | `rd, rs1, rs2`               | `rd = sx(s64(u64(rs1) >> (rs2 & 0b111111)))`                     |
| `rv128_o`     | `subd`   | `rd, rs1, rs2`               | `rd = sx(s64(u64(rs1) - u64(rs2)))`                              |

:RV128O - Standard Extension for Extended Instructions (128 bit)
