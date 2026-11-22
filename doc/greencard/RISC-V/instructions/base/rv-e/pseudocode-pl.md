## INSTRUCTION PSEUDO-CODE (PL)

| **Extension** | **Name** | **Variable-Fields**            | **Pseudo-Code**                                                                            |
|:--------------|:---------|:-------------------------------|:-------------------------------------------------------------------------------------------|
| `rv_e`        | `add`    | `rd, rs1, rs2`                 | `rd = sx(rs1) + sx(rs2)`                                                                   |
| `rv_e`        | `addi`   | `rd, rs1, imm12`               | `rd = sx(rs1) + sx(imm12)`                                                                 |
| `rv_e`        | `and`    | `rd, rs1, rs2`                 | `rd = ux(rs1) & ux(rs2)`                                                                   |
| `rv_e`        | `andi`   | `rd, rs1, imm12`               | `rd = ux(rs1) & ux(imm12)`                                                                 |
| `rv_e`        | `auipc`  | `rd, imm20`                    | `rd = pc + oimm20`                                                                         |
| `rv_e`        | `beq`    | `bimm12hi, rs1, rs2, bimm12lo` | `if (sx(rs1) == sx(rs2)) pc_offset = sbimm12`                                              |
| `rv_e`        | `bge`    | `bimm12hi, rs1, rs2, bimm12lo` | `if (sx(rs1) >= sx(rs2)) pc_offset = sbimm12`                                              |
| `rv_e`        | `bgeu`   | `bimm12hi, rs1, rs2, bimm12lo` | `if (ux(rs1) >= ux(rs2)) pc_offset = sbimm12`                                              |
| `rv_e`        | `blt`    | `bimm12hi, rs1, rs2, bimm12lo` | `if (sx(rs1) < sx(rs2)) pc_offset = sbimm12`                                               |
| `rv_e`        | `bltu`   | `bimm12hi, rs1, rs2, bimm12lo` | `if (ux(rs1) < ux(rs2)) pc_offset = sbimm12`                                               |
| `rv_e`        | `bne`    | `bimm12hi, rs1, rs2, bimm12lo` | `if (sx(rs1) != sx(rs2)) pc_offset = sbimm12`                                              |
| `rv_e`        | `ebreak` | `none`                         | `raise_breakpoint_or_enter_debug()`                                                        |
| `rv_e`        | `ecall`  | `none`                         | `trap(environment_call, privilege)`                                                        |
| `rv_e`        | `fence`  | `fm, pred, succ, rs1, rd`      | `order_memory_and_io(inst[31:28], inst[27:24], inst[23:20])`                               |
| `rv_e`        | `jal`    | `rd, jimm20`                   | `rd = pc + length(inst); pc_offset = jimm20`                                               |
| `rv_e`        | `jalr`   | `rd, rs1, imm12`               | `ux new_offset = (rs1 + oimm12 - pc) & ~1; rd = pc + length(inst); pc_offset = new_offset` |
| `rv_e`        | `lb`     | `rd, rs1, imm12`               | `s8 t; mmu.load<s8>(rs1 + oimm12, t); rd = t; rd = sx(*(s8*)ptr(rs1 + oimm12))`            |
| `rv_e`        | `lbu`    | `rd, rs1, imm12`               | `u8 t; mmu.load<u8>(rs1 + oimm12, t); rd = t; rd = ux(*(u8*)ptr(rs1 + oimm12))`            |
| `rv_e`        | `lh`     | `rd, rs1, imm12`               | `s16 t; mmu.load<s16>(rs1 + oimm12, t); rd = t; rd = sx(*(s16*)ptr(rs1 + oimm12))`         |
| `rv_e`        | `lhu`    | `rd, rs1, imm12`               | `u16 t; mmu.load<u16>(rs1 + oimm12, t); rd = t; rd = ux(*(u16*)ptr(rs1 + oimm12))`         |
| `rv_e`        | `lui`    | `rd, imm20`                    | `rd = imm20`                                                                               |
| `rv_e`        | `lw`     | `rd, rs1, imm12`               | `s32 t; mmu.load<s32>(rs1 + oimm12, t); rd = t; rd = sx(*(s32*)ptr(rs1 + oimm12))`         |
| `rv_e`        | `or`     | `rd, rs1, rs2`                 | `rd = ux(rs1) \| ux(rs2)`                                                                  |
| `rv_e`        | `ori`    | `rd, rs1, imm12`               | `rd = ux(rs1) \| ux(imm12)`                                                                |
| `rv_e`        | `sb`     | `imm12hi, rs1, rs2, imm12lo`   | `mmu.store<s8>(rs1 + simm12, s8(rs2)); *((u8*)ptr(rs1 + simm12)) = rs2`                    |
| `rv_e`        | `sh`     | `imm12hi, rs1, rs2, imm12lo`   | `mmu.store<s16>(rs1 + simm12, s16(rs2)); *((u16*)ptr(rs1 + simm12)) = rs2`                 |
| `rv_e`        | `sll`    | `rd, rs1, rs2`                 | `rd = ux(rs1) << (rs2 & 0b1111111); 7-bit mask for RV128E`                                 |
| `rv_e`        | `slt`    | `rd, rs1, rs2`                 | `rd = sx(rs1) < sx(rs2)`                                                                   |
| `rv_e`        | `slti`   | `rd, rs1, imm12`               | `rd = sx(rs1) < sx(imm12)`                                                                 |
| `rv_e`        | `sltiu`  | `rd, rs1, imm12`               | `rd = ux(rs1) < ux(imm12)`                                                                 |
| `rv_e`        | `sltu`   | `rd, rs1, rs2`                 | `rd = ux(rs1) < ux(rs2)`                                                                   |
| `rv_e`        | `sra`    | `rd, rs1, rs2`                 | `rd = sx(rs1) >> (rs2 & 0b1111111); 7-bit mask for RV128E`                                 |
| `rv_e`        | `srl`    | `rd, rs1, rs2`                 | `rd = ux(rs1) >> (rs2 & 0b1111111); 7-bit mask for RV128E`                                 |
| `rv_e`        | `sub`    | `rd, rs1, rs2`                 | `rd = sx(rs1) - sx(rs2)`                                                                   |
| `rv_e`        | `sw`     | `imm12hi, rs1, rs2, imm12lo`   | `mmu.store<s32>(rs1 + simm12, s32(rs2)); *((u32*)ptr(rs1 + simm12)) = rs2`                 |
| `rv_e`        | `xor`    | `rd, rs1, rs2`                 | `rd = ux(rs1) ^ ux(rs2)`                                                                   |
| `rv_e`        | `xori`   | `rd, rs1, imm12`               | `rd = ux(rs1) ^ ux(imm12)`                                                                 |

:RVE - Base Embedded Instruction Set

| **Extension** | **Name** | **Variable-Fields**          | **Pseudo-Code**                                                                    |
|:--------------|:---------|:-----------------------------|:-----------------------------------------------------------------------------------|
| `rv64_e`      | `addiw`  | `rd, rs1, imm12`             | `rd = s32(s32(rs1) + imm12); clang requires -fwrapv`                               |
| `rv64_e`      | `addw`   | `rd, rs1, rs2`               | `rd = s32(s32(rs1) + s32(rs2)); clang requires -fwrapv`                            |
| `rv64_e`      | `ld`     | `rd, rs1, imm12`             | `s64 t; mmu.load<s64>(rs1 + oimm12, t); rd = t; rd = sx(*(s64*)ptr(rs1 + oimm12))` |
| `rv64_e`      | `lwu`    | `rd, rs1, imm12`             | `u32 t; mmu.load<u32>(rs1 + oimm12, t); rd = t; rd = ux(*(u32*)ptr(rs1 + oimm12))` |
| `rv64_e`      | `sd`     | `imm12hi, rs1, rs2, imm12lo` | `mmu.store<s64>(rs1 + simm12, s64(rs2)); *(u64*)ptr(rs1 + simm12) = rs2`           |
| `rv64_e`      | `slli`   | `rd, rs1, shamtd`            | `rd = ux(rs1) << shamt6`                                                           |
| `rv64_e`      | `slliw`  | `rd, rs1, shamtw`            | `rd = s32(u32(rs1) << shamt5)`                                                     |
| `rv64_e`      | `sllw`   | `rd, rs1, rs2`               | `rd = s32(u32(rs1) << (rs2 & 0b11111))`                                            |
| `rv64_e`      | `srai`   | `rd, rs1, shamtd`            | `rd = sx(rs1) >> shamt6`                                                           |
| `rv64_e`      | `sraiw`  | `rd, rs1, shamtw`            | `rd = s32(rs1) >> shamt5`                                                          |
| `rv64_e`      | `sraw`   | `rd, rs1, rs2`               | `rd = s32(s32(rs1) >> (rs2 & 0b11111))`                                            |
| `rv64_e`      | `srli`   | `rd, rs1, shamtd`            | `rd = ux(rs1) >> shamt6`                                                           |
| `rv64_e`      | `srliw`  | `rd, rs1, shamtw`            | `rd = s32(u32(rs1) >> shamt5)`                                                     |
| `rv64_e`      | `srlw`   | `rd, rs1, rs2`               | `rd = s32(u32(rs1) >> (rs2 & 0b11111))`                                            |
| `rv64_e`      | `subw`   | `rd, rs1, rs2`               | `rd = s32(s32(rs1) - s32(rs2)); clang requires -fwrapv`                            |

:RV64E - Base Embedded Instruction Set (64 bit)

| **Extension** | **Name** | **Variable-Fields**          | **Pseudo-Code**                                                  |
|:--------------|:---------|:-----------------------------|:-----------------------------------------------------------------|
| `rv128_e`     | `addid`  | `rd, rs1, imm12`             | `rd = sx(s64(u64(rs1) + u64(sx(imm12))))`                        |
| `rv128_e`     | `addd`   | `rd, rs1, rs2`               | `rd = sx(s64(u64(rs1) + u64(rs2)))`                              |
| `rv128_e`     | `lq`     | `rd, rs1, imm12`             | `u128 t; mmu.load<u128>(rs1 + imm12, t); rd = t`                 |
| `rv128_e`     | `ldu`    | `rd, rs1, imm12`             | `u64 t; mmu.load<u64>(rs1 + imm12, t); rd = ux(t)`               |
| `rv128_e`     | `sq`     | `imm12hi, rs1, rs2, imm12lo` | `mmu.store<u128>(rs1 + sx(concat(imm12hi, imm12lo)), u128(rs2))` |
| `rv128_e`     | `slli`   | `rd, rs1, shamt7`            | `rd = ux(rs1) << shamt7`                                         |
| `rv128_e`     | `sllid`  | `rd, rs1, shamt6`            | `rd = sx(s64(u64(rs1) << shamt6))`                               |
| `rv128_e`     | `slld`   | `rd, rs1, rs2`               | `rd = sx(s64(u64(rs1) << (rs2 & 0b111111)))`                     |
| `rv128_e`     | `srai`   | `rd, rs1, shamt7`            | `rd = sx(rs1) >> shamt7`                                         |
| `rv128_e`     | `sraid`  | `rd, rs1, shamt6`            | `rd = sx(s64(s64(rs1) >> shamt6))`                               |
| `rv128_e`     | `srad`   | `rd, rs1, rs2`               | `rd = sx(s64(s64(rs1) >> (rs2 & 0b111111)))`                     |
| `rv128_e`     | `srli`   | `rd, rs1, shamt7`            | `rd = ux(rs1) >> shamt7`                                         |
| `rv128_e`     | `srlid`  | `rd, rs1, shamt6`            | `rd = sx(s64(u64(rs1) >> shamt6))`                               |
| `rv128_e`     | `srld`   | `rd, rs1, rs2`               | `rd = sx(s64(u64(rs1) >> (rs2 & 0b111111)))`                     |
| `rv128_e`     | `subd`   | `rd, rs1, rs2`               | `rd = sx(s64(u64(rs1) - u64(rs2)))`                              |

:RV128E - Base Embedded Instruction Set (128 bit)

| **Extension** | **Name**      | **Variable-Fields**                                 | **Pseudo-Code**                                                                                            |
|:--------------|:--------------|:----------------------------------------------------|:-----------------------------------------------------------------------------------------------------------|
| `rv_zebi`     | `beqi`        | `imm12hi, imm5, rs1, imm12lo`                       | `if (rs1 == (imm5 == 0 ? -1 : zx(imm5))) pc_offset = decode_bimm(imm12hi, imm12lo)`                        |
| `rv_zebi`     | `bnei`        | `imm12hi, imm5, rs1, imm12lo`                       | `if (rs1 != (imm5 == 0 ? -1 : zx(imm5))) pc_offset = decode_bimm(imm12hi, imm12lo)`                        |
| `rv_zecbo`    | `cbo_clean`   | `rs1`                                               | `mmu.cbo_clean(rs1)`                                                                                       |
| `rv_zecbo`    | `cbo_flush`   | `rs1`                                               | `mmu.cbo_flush(rs1)`                                                                                       |
| `rv_zecbo`    | `cbo_inval`   | `rs1`                                               | `mmu.cbo_inval(rs1)`                                                                                       |
| `rv_zecbo`    | `cbo_zero`    | `rs1`                                               | `mmu.cbo_zero(rs1)`                                                                                        |
| `rv_zecfiss`  | `ssamoswap_d` | `rd, rs1, rs2, aq, rl`                              | `rd = mmu.ssamoswap<s64>(rs1, s64(rs2), aq, rl)`                                                           |
| `rv_zecfiss`  | `ssamoswap_w` | `rd, rs1, rs2, aq, rl`                              | `rd = mmu.ssamoswap<s32>(rs1, s32(rs2), aq, rl)`                                                           |
| `rv_zecond`   | `czero_eqz`   | `rd, rs1, rs2`                                      | `rd = (rs2 == 0) ? 0 : rs1`                                                                                |
| `rv_zecond`   | `czero_nez`   | `rd, rs1, rs2`                                      | `rd = (rs2 != 0) ? 0 : rs1`                                                                                |
| `rv_zecsr`    | `csrrc`       | `rd, rs1, csr`                                      | `ux src = rs1; ux old = csr.read(); if (rs1 != 0) csr.write(bit_and(old, bit_not(src))); rd = old`         |
| `rv_zecsr`    | `csrrci`      | `rd, csr, zimm5`                                    | `ux src = zx(zimm5); ux old = csr.read(); if (zimm5 != 0) csr.write(bit_and(old, bit_not(src))); rd = old` |
| `rv_zecsr`    | `csrrs`       | `rd, rs1, csr`                                      | `ux src = rs1; ux old = csr.read(); if (rs1 != 0) csr.write(bit_or(old, src)); rd = old`                   |
| `rv_zecsr`    | `csrrsi`      | `rd, csr, zimm5`                                    | `ux src = zx(zimm5); ux old = csr.read(); if (zimm5 != 0) csr.write(bit_or(old, src)); rd = old`           |
| `rv_zecsr`    | `csrrw`       | `rd, rs1, csr`                                      | `ux src = rs1; ux old = rd != x0 ? csr.read() : 0; csr.write(src); rd = old`                               |
| `rv_zecsr`    | `csrrwi`      | `rd, csr, zimm5`                                    | `ux src = zx(zimm5); ux old = rd != x0 ? csr.read() : 0; csr.write(src); rd = old`                         |
| `rv_zefencei` | `fence_i`     | `imm12, rs1, rd`                                    | `synchronize_local_instruction_fetch()`                                                                    |
| `rv_zemop`    | `mop_r_N`     | `mop_r_t_30, mop_r_t_27_26, mop_r_t_21_20, rd, rs1` | `rd = 0`                                                                                                   |
| `rv_zemop`    | `mop_rr_N`    | `mop_rr_t_30, mop_rr_t_27_26, rd, rs1, rs2`         | `rd = 0`                                                                                                   |

:RVZE - Base Embedded Instruction Set
