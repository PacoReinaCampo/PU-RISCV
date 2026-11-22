## INSTRUCTION PSEUDO-CODE (PL)

| **Extension** | **Name** | **Variable-Fields**            | **Pseudo-Code**                                                                                                                                                                                |
|:--------------|:---------|:-------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `rv_i`        | `add`    | `rd, rs1, rs2`                 | `rd = ux(rs1) + ux(rs2);`                                                                                                                                                                      |
| `rv_i`        | `addi`   | `rd, rs1, imm12`               | `rd = ux(rs1) + sx(imm12);`                                                                                                                                                                    |
| `rv_i`        | `and`    | `rd, rs1, rs2`                 | `rd = ux(rs1) & ux(rs2);`                                                                                                                                                                      |
| `rv_i`        | `andi`   | `rd, rs1, imm12`               | `rd = ux(rs1) & sx(imm12);`                                                                                                                                                                    |
| `rv_i`        | `auipc`  | `rd, imm20`                    | `rd = pc + sx(u32(imm20) << 12, 32, XLEN);`                                                                                                                                                    |
| `rv_i`        | `beq`    | `bimm12hi, rs1, rs2, bimm12lo` | `if (rs1 == rs2) pc_offset = decode_bimm(bimm12hi, bimm12lo);`                                                                                                                                 |
| `rv_i`        | `bge`    | `bimm12hi, rs1, rs2, bimm12lo` | `if (sx(rs1) >= sx(rs2)) pc_offset = decode_bimm(bimm12hi, bimm12lo);`                                                                                                                         |
| `rv_i`        | `bgeu`   | `bimm12hi, rs1, rs2, bimm12lo` | `if (ux(rs1) >= ux(rs2)) pc_offset = decode_bimm(bimm12hi, bimm12lo);`                                                                                                                         |
| `rv_i`        | `blt`    | `bimm12hi, rs1, rs2, bimm12lo` | `if (sx(rs1) < sx(rs2)) pc_offset = decode_bimm(bimm12hi, bimm12lo);`                                                                                                                          |
| `rv_i`        | `bltu`   | `bimm12hi, rs1, rs2, bimm12lo` | `if (ux(rs1) < ux(rs2)) pc_offset = decode_bimm(bimm12hi, bimm12lo);`                                                                                                                          |
| `rv_i`        | `bne`    | `bimm12hi, rs1, rs2, bimm12lo` | `if (rs1 != rs2) pc_offset = decode_bimm(bimm12hi, bimm12lo);`                                                                                                                                 |
| `rv_i`        | `ebreak` | `none`                         | `breakpoint_or_debug(CAUSE_BREAKPOINT);`                                                                                                                                                       |
| `rv_i`        | `ecall`  | `none`                         | `if (privilege == PRV_M) trap(CAUSE_MACHINE_ECALL); else if (privilege == PRV_U) trap(CAUSE_USER_ECALL); else if (V) trap(CAUSE_VIRTUAL_SUPERVISOR_ECALL); else trap(CAUSE_SUPERVISOR_ECALL);` |
| `rv_i`        | `fence`  | `fm, pred, succ, rs1, rd`      | `ignore_fields(rs1, rd); order_memory_and_io(fm, pred, succ);`                                                                                                                                 |
| `rv_i`        | `jal`    | `rd, jimm20`                   | `rd = pc + 4; pc_offset = decode_jimm(jimm20);`                                                                                                                                                |
| `rv_i`        | `jalr`   | `rd, rs1, imm12`               | `target = (rs1 + sx(imm12)) & ~1; rd = pc + 4; pc_offset = target - pc;`                                                                                                                       |
| `rv_i`        | `lb`     | `rd, rs1, imm12`               | `rd = sx(load_mem(rs1 + sx(imm12), 8), 8, XLEN);`                                                                                                                                              |
| `rv_i`        | `lbu`    | `rd, rs1, imm12`               | `rd = zx(load_mem(rs1 + sx(imm12), 8), 8, XLEN);`                                                                                                                                              |
| `rv_i`        | `lh`     | `rd, rs1, imm12`               | `rd = sx(load_mem(rs1 + sx(imm12), 16), 16, XLEN);`                                                                                                                                            |
| `rv_i`        | `lhu`    | `rd, rs1, imm12`               | `rd = zx(load_mem(rs1 + sx(imm12), 16), 16, XLEN);`                                                                                                                                            |
| `rv_i`        | `lui`    | `rd, imm20`                    | `rd = sx(u32(imm20) << 12, 32, XLEN);`                                                                                                                                                         |
| `rv_i`        | `lw`     | `rd, rs1, imm12`               | `rd = sx(load_mem(rs1 + sx(imm12), 32), 32, XLEN);`                                                                                                                                            |
| `rv_i`        | `or`     | `rd, rs1, rs2`                 | `rd = ux(rs1) \| ux(rs2);`                                                                                                                                                                     |
| `rv_i`        | `ori`    | `rd, rs1, imm12`               | `rd = ux(rs1) \| sx(imm12);`                                                                                                                                                                   |
| `rv_i`        | `sb`     | `imm12hi, rs1, rs2, imm12lo`   | `store_mem(rs1 + decode_simm(imm12hi, imm12lo), rs2, 8);`                                                                                                                                      |
| `rv_i`        | `sh`     | `imm12hi, rs1, rs2, imm12lo`   | `store_mem(rs1 + decode_simm(imm12hi, imm12lo), rs2, 16);`                                                                                                                                     |
| `rv_i`        | `sll`    | `rd, rs1, rs2`                 | `rd = ux(rs1) << (rs2 & (XLEN - 1));`                                                                                                                                                          |
| `rv_i`        | `slt`    | `rd, rs1, rs2`                 | `rd = sx(rs1) < sx(rs2);`                                                                                                                                                                      |
| `rv_i`        | `slti`   | `rd, rs1, imm12`               | `rd = sx(rs1) < sx(imm12);`                                                                                                                                                                    |
| `rv_i`        | `sltiu`  | `rd, rs1, imm12`               | `rd = ux(rs1) < ux(sx(imm12));`                                                                                                                                                                |
| `rv_i`        | `sltu`   | `rd, rs1, rs2`                 | `rd = ux(rs1) < ux(rs2);`                                                                                                                                                                      |
| `rv_i`        | `sra`    | `rd, rs1, rs2`                 | `rd = sx(rs1) >> (rs2 & (XLEN - 1));`                                                                                                                                                          |
| `rv_i`        | `srl`    | `rd, rs1, rs2`                 | `rd = ux(rs1) >> (rs2 & (XLEN - 1));`                                                                                                                                                          |
| `rv_i`        | `sub`    | `rd, rs1, rs2`                 | `rd = ux(rs1) - ux(rs2);`                                                                                                                                                                      |
| `rv_i`        | `sw`     | `imm12hi, rs1, rs2, imm12lo`   | `store_mem(rs1 + decode_simm(imm12hi, imm12lo), rs2, 32);`                                                                                                                                     |
| `rv_i`        | `xor`    | `rd, rs1, rs2`                 | `rd = ux(rs1) ^ ux(rs2);`                                                                                                                                                                      |
| `rv_i`        | `xori`   | `rd, rs1, imm12`               | `rd = ux(rs1) ^ sx(imm12);`                                                                                                                                                                    |

:RVI - Base Integer Instruction Set

| **Extension** | **Name** | **Variable-Fields**          | **Pseudo-Code**                                               |
|:--------------|:---------|:-----------------------------|:--------------------------------------------------------------|
| `rv64_i`      | `addiw`  | `rd, rs1, imm12`             | `rd = sx(u32(rs1) + u32(sx(imm12)), 32, XLEN);`               |
| `rv64_i`      | `addw`   | `rd, rs1, rs2`               | `rd = sx(u32(rs1) + u32(rs2), 32, XLEN);`                     |
| `rv64_i`      | `ld`     | `rd, rs1, imm12`             | `rd = sx(load_mem(rs1 + sx(imm12), 64), 64, XLEN);`           |
| `rv64_i`      | `lwu`    | `rd, rs1, imm12`             | `rd = zx(load_mem(rs1 + sx(imm12), 32), 32, XLEN);`           |
| `rv64_i`      | `sd`     | `imm12hi, rs1, rs2, imm12lo` | `store_mem(rs1 + decode_simm(imm12hi, imm12lo), rs2, 64);`    |
| `rv64_i`      | `slli`   | `rd, rs1, shamtd`            | `rd = ux(rs1) << shamtd;`                                     |
| `rv64_i`      | `slliw`  | `rd, rs1, shamtw`            | `rd = sx(trunc(u32(rs1) << shamtw, 32), 32, XLEN);`           |
| `rv64_i`      | `sllw`   | `rd, rs1, rs2`               | `rd = sx(trunc(u32(rs1) << (rs2 & (32 - 1)), 32), 32, XLEN);` |
| `rv64_i`      | `srai`   | `rd, rs1, shamtd`            | `rd = sx(rs1) >> shamtd;`                                     |
| `rv64_i`      | `sraiw`  | `rd, rs1, shamtw`            | `rd = sx(trunc(s32(rs1) >> shamtw, 32), 32, XLEN);`           |
| `rv64_i`      | `sraw`   | `rd, rs1, rs2`               | `rd = sx(trunc(s32(rs1) >> (rs2 & (32 - 1)), 32), 32, XLEN);` |
| `rv64_i`      | `srli`   | `rd, rs1, shamtd`            | `rd = ux(rs1) >> shamtd;`                                     |
| `rv64_i`      | `srliw`  | `rd, rs1, shamtw`            | `rd = sx(trunc(u32(rs1) >> shamtw, 32), 32, XLEN);`           |
| `rv64_i`      | `srlw`   | `rd, rs1, rs2`               | `rd = sx(trunc(u32(rs1) >> (rs2 & (32 - 1)), 32), 32, XLEN);` |
| `rv64_i`      | `subw`   | `rd, rs1, rs2`               | `rd = sx(u32(rs1) - u32(rs2), 32, XLEN);`                     |

:RV64I - Base Integer Instruction Set (64 bit)

| **Extension** | **Name** | **Variable-Fields**          | **Pseudo-Code**                                               |
|:--------------|:---------|:-----------------------------|:--------------------------------------------------------------|
| `rv128_i`     | `addid`  | `rd, rs1, imm12`             | `rd = sx(s64(u64(rs1) + u64(sx(imm12))));`                    |
| `rv128_i`     | `addd`   | `rd, rs1, rs2`               | `rd = sx(s64(u64(rs1) + u64(rs2)));`                          |
| `rv128_i`     | `lq`     | `rd, rs1, imm12`             | `rd = sx(load_mem(rs1 + sx(imm12), 128), 128, XLEN);`         |
| `rv128_i`     | `ldu`    | `rd, rs1, imm12`             | `rd = zx(load_mem(rs1 + sx(imm12), 64), 64, XLEN);`           |
| `rv128_i`     | `sq`     | `imm12hi, rs1, rs2, imm12lo` | `store_mem(rs1 + decode_simm(imm12hi, imm12lo), rs2, 128);`   |
| `rv128_i`     | `slli`   | `rd, rs1, shamt7`            | `rd = ux(rs1) << shamt7;`                                     |
| `rv128_i`     | `sllid`  | `rd, rs1, shamt6`            | `rd = sx(trunc(u64(rs1) << shamt6, 64), 64, XLEN);`           |
| `rv128_i`     | `slld`   | `rd, rs1, rs2`               | `rd = sx(trunc(u64(rs1) << (rs2 & (64 - 1)), 64), 64, XLEN);` |
| `rv128_i`     | `srai`   | `rd, rs1, shamt7`            | `rd = sx(rs1) >> shamt7;`                                     |
| `rv128_i`     | `sraid`  | `rd, rs1, shamt6`            | `rd = sx(trunc(s64(rs1) >> shamt6, 64), 64, XLEN);`           |
| `rv128_i`     | `srad`   | `rd, rs1, rs2`               | `rd = sx(trunc(s64(rs1) >> (rs2 & (64 - 1)), 64), 64, XLEN);` |
| `rv128_i`     | `srli`   | `rd, rs1, shamt7`            | `rd = ux(rs1) >> shamt7;`                                     |
| `rv128_i`     | `srlid`  | `rd, rs1, shamt6`            | `rd = sx(trunc(u64(rs1) >> shamt6, 64), 64, XLEN);`           |
| `rv128_i`     | `srld`   | `rd, rs1, rs2`               | `rd = sx(trunc(u64(rs1) >> (rs2 & (64 - 1)), 64), 64, XLEN);` |
| `rv128_i`     | `subd`   | `rd, rs1, rs2`               | `rd = sx(s64(u64(rs1) - u64(rs2)));`                          |

:RV128I - Base Integer Instruction Set (128 bit)

| **Extension** | **Name**      | **Variable-Fields**                                 | **Pseudo-Code**                                                                                                          |
|:--------------|:--------------|:----------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------|
| `rv_zibi`     | `beqi`        | `imm12hi, imm5, rs1, imm12lo`                       | `if (rs1 == (imm5 == 0 ? -1 : zx(imm5))) pc_offset = decode_bimm(imm12hi, imm12lo);`                                     |
| `rv_zibi`     | `bnei`        | `imm12hi, imm5, rs1, imm12lo`                       | `if (rs1 != (imm5 == 0 ? -1 : zx(imm5))) pc_offset = decode_bimm(imm12hi, imm12lo);`                                     |
| `rv_zicbo`    | `cbo_clean`   | `rs1`                                               | `cbo_clean(rs1);`                                                                                                        |
| `rv_zicbo`    | `cbo_flush`   | `rs1`                                               | `cbo_flush(rs1);`                                                                                                        |
| `rv_zicbo`    | `cbo_inval`   | `rs1`                                               | `cbo_inval(rs1);`                                                                                                        |
| `rv_zicbo`    | `cbo_zero`    | `rs1`                                               | `cbo_zero(rs1);`                                                                                                         |
| `rv_zicfiss`  | `ssamoswap_d` | `rd, rs1, rs2, aq, rl`                              | `rd = ssamoswap_s64(rs1, s64(rs2), aq, rl);`                                                                             |
| `rv_zicfiss`  | `ssamoswap_w` | `rd, rs1, rs2, aq, rl`                              | `rd = ssamoswap_s32(rs1, s32(rs2), aq, rl);`                                                                             |
| `rv_zicond`   | `czero_eqz`   | `rd, rs1, rs2`                                      | `rd = (rs2 == 0) ? 0 : rs1;`                                                                                             |
| `rv_zicond`   | `czero_nez`   | `rd, rs1, rs2`                                      | `rd = (rs2 != 0) ? 0 : rs1;`                                                                                             |
| `rv_zicsr`    | `csrrc`       | `rd, rs1, csr`                                      | `src = x[rs1]; old = csr_read(csr); if (rs1 != 0) csr_write(csr, old & ~src); if (rd != 0) x[rd] = old;`                 |
| `rv_zicsr`    | `csrrci`      | `rd, csr, zimm5`                                    | `src = zx(zimm5); old = csr_read(csr); if (zimm5 != 0) csr_write(csr, old & ~src); if (rd != 0) x[rd] = old;`            |
| `rv_zicsr`    | `csrrs`       | `rd, rs1, csr`                                      | `src = x[rs1]; old = csr_read(csr); if (rs1 != 0) csr_write(csr, old \| src); if (rd != 0) x[rd] = old;`                 |
| `rv_zicsr`    | `csrrsi`      | `rd, csr, zimm5`                                    | `src = zx(zimm5); old = csr_read(csr); if (zimm5 != 0) csr_write(csr, old \| src); if (rd != 0) x[rd] = old;`            |
| `rv_zicsr`    | `csrrw`       | `rd, rs1, csr`                                      | `src = x[rs1]; if (rd != 0) x[rd] = csr_read(csr); csr_write(csr, src);`                                                 |
| `rv_zicsr`    | `csrrwi`      | `rd, csr, zimm5`                                    | `src = zx(zimm5); if (rd != 0) x[rd] = csr_read(csr); csr_write(csr, src);`                                              |
| `rv_zifencei` | `fence_i`     | `imm12, rs1, rd`                                    | `ignore_fields(imm12, rs1, rd); synchronize_local_instruction_fetch();`                                                  |
| `rv_zilx`     | `lxh`         | `rd, rs1, rs2`                                      | `addr = trunc(x[rs2] + (x[rs1]), XLEN); value = load_mem(addr, 16); if (rd != 0) x[rd] = sign_extend(value, XLEN);`      |
| `rv_zilx`     | `lxhu`        | `rd, rs1, rs2`                                      | `addr = trunc(x[rs2] + (x[rs1]), XLEN); value = load_mem(addr, 16); if (rd != 0) x[rd] = zero_extend(value, XLEN);`      |
| `rv_zilx`     | `lxsb`        | `rd, rs1, rs2`                                      | `addr = trunc(x[rs2] + (x[rs1]), XLEN); value = load_mem(addr, 8); if (rd != 0) x[rd] = sign_extend(value, XLEN);`       |
| `rv_zilx`     | `lxsbu`       | `rd, rs1, rs2`                                      | `addr = trunc(x[rs2] + (x[rs1]), XLEN); value = load_mem(addr, 8); if (rd != 0) x[rd] = zero_extend(value, XLEN);`       |
| `rv_zilx`     | `lxsh`        | `rd, rs1, rs2`                                      | `addr = trunc(x[rs2] + (x[rs1] << 1), XLEN); value = load_mem(addr, 16); if (rd != 0) x[rd] = sign_extend(value, XLEN);` |
| `rv_zilx`     | `lxshu`       | `rd, rs1, rs2`                                      | `addr = trunc(x[rs2] + (x[rs1] << 1), XLEN); value = load_mem(addr, 16); if (rd != 0) x[rd] = zero_extend(value, XLEN);` |
| `rv_zilx`     | `lxsw`        | `rd, rs1, rs2`                                      | `addr = trunc(x[rs2] + (x[rs1] << 2), XLEN); value = load_mem(addr, 32); if (rd != 0) x[rd] = sign_extend(value, XLEN);` |
| `rv_zilx`     | `lxw`         | `rd, rs1, rs2`                                      | `addr = trunc(x[rs2] + (x[rs1]), XLEN); value = load_mem(addr, 32); if (rd != 0) x[rd] = sign_extend(value, XLEN);`      |
| `rv_zimop`    | `mop_r_N`     | `mop_r_t_30, mop_r_t_27_26, mop_r_t_21_20, rd, rs1` | `ignore_fields(mop_r_t_30, mop_r_t_27_26, mop_r_t_21_20, rs1); rd = 0;`                                                  |
| `rv_zimop`    | `mop_rr_N`    | `mop_rr_t_30, mop_rr_t_27_26, rd, rs1, rs2`         | `ignore_fields(mop_rr_t_30, mop_rr_t_27_26, rs1, rs2); rd = 0;`                                                          |

:RVZI - Base Integer Instruction Set

| **Extension** | **Name**  | **Variable-Fields** | **Pseudo-Code**                                                                                                                                          |
|:--------------|:----------|:--------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------|
| `rv64_zilx`   | `lxd`     | `rd, rs1, rs2`      | `addr = trunc(x[rs2] + (x[rs1]), XLEN); value = load_mem(addr, 64); if (rd != 0) x[rd] = sign_extend(value, XLEN);`                                      |
| `rv64_zilx`   | `lxsd`    | `rd, rs1, rs2`      | `addr = trunc(x[rs2] + (x[rs1] << 3), XLEN); value = load_mem(addr, 64); if (rd != 0) x[rd] = sign_extend(value, XLEN);`                                 |
| `rv64_zilx`   | `lxsuwb`  | `rd, rs1, rs2`      | `addr = trunc(x[rs2] + (zero_extend(bits(x[rs1], 31, 0), XLEN)), XLEN); value = load_mem(addr, 8); if (rd != 0) x[rd] = sign_extend(value, XLEN);`       |
| `rv64_zilx`   | `lxsuwbu` | `rd, rs1, rs2`      | `addr = trunc(x[rs2] + (zero_extend(bits(x[rs1], 31, 0), XLEN)), XLEN); value = load_mem(addr, 8); if (rd != 0) x[rd] = zero_extend(value, XLEN);`       |
| `rv64_zilx`   | `lxsuwd`  | `rd, rs1, rs2`      | `addr = trunc(x[rs2] + (zero_extend(bits(x[rs1], 31, 0), XLEN) << 3), XLEN); value = load_mem(addr, 64); if (rd != 0) x[rd] = sign_extend(value, XLEN);` |
| `rv64_zilx`   | `lxsuwh`  | `rd, rs1, rs2`      | `addr = trunc(x[rs2] + (zero_extend(bits(x[rs1], 31, 0), XLEN) << 1), XLEN); value = load_mem(addr, 16); if (rd != 0) x[rd] = sign_extend(value, XLEN);` |
| `rv64_zilx`   | `lxsuwhu` | `rd, rs1, rs2`      | `addr = trunc(x[rs2] + (zero_extend(bits(x[rs1], 31, 0), XLEN) << 1), XLEN); value = load_mem(addr, 16); if (rd != 0) x[rd] = zero_extend(value, XLEN);` |
| `rv64_zilx`   | `lxsuww`  | `rd, rs1, rs2`      | `addr = trunc(x[rs2] + (zero_extend(bits(x[rs1], 31, 0), XLEN) << 2), XLEN); value = load_mem(addr, 32); if (rd != 0) x[rd] = sign_extend(value, XLEN);` |
| `rv64_zilx`   | `lxsuwwu` | `rd, rs1, rs2`      | `addr = trunc(x[rs2] + (zero_extend(bits(x[rs1], 31, 0), XLEN) << 2), XLEN); value = load_mem(addr, 32); if (rd != 0) x[rd] = zero_extend(value, XLEN);` |
| `rv64_zilx`   | `lxswu`   | `rd, rs1, rs2`      | `addr = trunc(x[rs2] + (x[rs1] << 2), XLEN); value = load_mem(addr, 32); if (rd != 0) x[rd] = zero_extend(value, XLEN);`                                 |
| `rv64_zilx`   | `lxwu`    | `rd, rs1, rs2`      | `addr = trunc(x[rs2] + (x[rs1]), XLEN); value = load_mem(addr, 32); if (rd != 0) x[rd] = zero_extend(value, XLEN);`                                      |

:RV64ZI - Base Integer Instruction Set (64 bit)
