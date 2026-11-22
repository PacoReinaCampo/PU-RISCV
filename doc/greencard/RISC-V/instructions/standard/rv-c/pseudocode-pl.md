## INSTRUCTION PSEUDO-CODE (PL)

| **Extension** | **Name**     | **Variable-Fields**                  | **Pseudo-Code**                                                                                                            |
|:--------------|:-------------|:-------------------------------------|:---------------------------------------------------------------------------------------------------------------------------|
| `rv_c`        | `c_add`      | `rd_rs1_n0, c_rs2_n0`                | `x[rd_rs1_n0] = x[rd_rs1_n0] + x[c_rs2_n0];`                                                                               |
| `rv_c`        | `c_addi`     | `rd_rs1_n0, c_nzimm6lo, c_nzimm6hi`  | `x[rd_rs1_n0] = x[rd_rs1_n0] + sx(decode_c_imm6(c_nzimm6hi, c_nzimm6lo));`                                                 |
| `rv_c`        | `c_addi16sp` | `c_nzimm10hi, c_nzimm10lo`           | `sp = sp + decode_c_addi16sp(c_nzimm10hi, c_nzimm10lo);`                                                                   |
| `rv_c`        | `c_addi4spn` | `rd_p, c_nzuimm10`                   | `x[8 + rd_p] = sp + ux(decode_c_addi4spn(c_nzuimm10));`                                                                    |
| `rv_c`        | `c_and`      | `rd_rs1_p, rs2_p`                    | `x[8 + rd_rs1_p] = x[8 + rd_rs1_p] & x[8 + rs2_p];`                                                                        |
| `rv_c`        | `c_andi`     | `rd_rs1_p, c_imm6hi, c_imm6lo`       | `x[8 + rd_rs1_p] = ux(x[8 + rd_rs1_p]) & ux(sx(decode_c_imm6(c_imm6hi, c_imm6lo)));`                                       |
| `rv_c`        | `c_beqz`     | `rs1_p, c_bimm9lo, c_bimm9hi`        | `if (x[8 + rs1_p] == 0) pc_offset = sx(decode_c_branch(c_bimm9hi, c_bimm9lo));`                                            |
| `rv_c`        | `c_bnez`     | `rs1_p, c_bimm9lo, c_bimm9hi`        | `if (x[8 + rs1_p] != 0) pc_offset = sx(decode_c_branch(c_bimm9hi, c_bimm9lo));`                                            |
| `rv_c`        | `c_ebreak`   | `none`                               | `breakpoint_or_debug(CAUSE_BREAKPOINT);`                                                                                   |
| `rv_c`        | `c_j`        | `c_imm12`                            | `pc_offset = sx(decode_c_jump(c_imm12));`                                                                                  |
| `rv_c`        | `c_jalr`     | `c_rs1_n0`                           | `target = x[c_rs1_n0] & ~1; x[1] = pc + 2; pc_offset = target - pc;`                                                       |
| `rv_c`        | `c_jr`       | `rs1_n0`                             | `target = x[rs1_n0] & ~1; pc_offset = target - pc;`                                                                        |
| `rv_c`        | `c_li`       | `rd_n0, c_imm6lo, c_imm6hi`          | `x[rd_n0] = sx(decode_c_imm6(c_imm6hi, c_imm6lo));`                                                                        |
| `rv_c`        | `c_lui`      | `rd_n2, c_nzimm18hi, c_nzimm18lo`    | `x[rd_n2] = sx(decode_c_lui(c_nzimm18hi, c_nzimm18lo));`                                                                   |
| `rv_c`        | `c_lw`       | `rd_p, rs1_p, c_uimm7lo, c_uimm7hi`  | `u32_t t = load_u32(x[8 + rs1_p] + decode_c_word_offset(c_uimm7hi, c_uimm7lo)); x[8 + rd_p] = sx(s32(t));`                 |
| `rv_c`        | `c_lwsp`     | `rd_n0, c_uimm8sphi, c_uimm8splo`    | `u32_t t = load_u32(sp + decode_c_lwsp(c_uimm8sphi, c_uimm8splo)); x[rd_n0] = sx(s32(t));`                                 |
| `rv_c`        | `c_mv`       | `rd_n0, c_rs2_n0`                    | `x[rd_n0] = x[c_rs2_n0];`                                                                                                  |
| `rv_c`        | `c_nop`      | `c_nzimm6hi, c_nzimm6lo`             | `ignore_fields(c_nzimm6hi, c_nzimm6lo); pc_offset = 2;`                                                                    |
| `rv_c`        | `c_or`       | `rd_rs1_p, rs2_p`                    | `x[8 + rd_rs1_p] = x[8 + rd_rs1_p] \| x[8 + rs2_p];`                                                                       |
| `rv_c`        | `c_sub`      | `rd_rs1_p, rs2_p`                    | `x[8 + rd_rs1_p] = x[8 + rd_rs1_p] - x[8 + rs2_p];`                                                                        |
| `rv_c`        | `c_sw`       | `rs1_p, rs2_p, c_uimm7lo, c_uimm7hi` | `store_u32(x[8 + rs1_p] + decode_c_word_offset(c_uimm7hi, c_uimm7lo), u32(x[8 + rs2_p]));`                                 |
| `rv_c`        | `c_swsp`     | `c_rs2, c_uimm8sp_s`                 | `store_u32(sp + decode_c_swsp(c_uimm8sp_s), u32(x[c_rs2]));`                                                               |
| `rv_c`        | `c_xor`      | `rd_rs1_p, rs2_p`                    | `x[8 + rd_rs1_p] = x[8 + rd_rs1_p] ^ x[8 + rs2_p];`                                                                        |
| `rv_c_d`      | `c_fld`      | `rd_p, rs1_p, c_uimm8lo, c_uimm8hi`  | `u64_t t = load_u64(x[8 + rs1_p] + decode_c_doubleword_offset(c_uimm8hi, c_uimm8lo)); f[8 + rd_p] = nan_box(t, 64, FLEN);` |
| `rv_c_d`      | `c_fldsp`    | `rd, c_uimm9sphi, c_uimm9splo`       | `u64_t t = load_u64(sp + decode_c_ldsp(c_uimm9sphi, c_uimm9splo)); f[rd] = nan_box(t, 64, FLEN);`                          |
| `rv_c_d`      | `c_fsd`      | `rs1_p, rs2_p, c_uimm8lo, c_uimm8hi` | `store_u64(x[8 + rs1_p] + decode_c_doubleword_offset(c_uimm8hi, c_uimm8lo), u64(f[8 + rs2_p]));`                           |
| `rv_c_d`      | `c_fsdsp`    | `c_rs2, c_uimm9sp_s`                 | `store_u64(sp + decode_c_sdsp(c_uimm9sp_s), u64(f[c_rs2]));`                                                               |

:RVC - Standard Extension for Compressed Instructions

| **Extension** | **Name**  | **Variable-Fields**                  | **Pseudo-Code**                                                                                                      |
|:--------------|:----------|:-------------------------------------|:---------------------------------------------------------------------------------------------------------------------|
| `rv32_c`      | `c_jal`   | `c_imm12`                            | `x[1] = pc + 2; pc_offset = sx(decode_c_jump(c_imm12));`                                                             |
| `rv32_c_f`    | `c_flw`   | `rd_p, rs1_p, c_uimm7lo, c_uimm7hi`  | `u32_t t = load_u32(x[8 + rs1_p] + decode_c_word_offset(c_uimm7hi, c_uimm7lo)); f[8 + rd_p] = nan_box(t, 32, FLEN);` |
| `rv32_c_f`    | `c_flwsp` | `rd, c_uimm8sphi, c_uimm8splo`       | `u32_t t = load_u32(sp + decode_c_lwsp(c_uimm8sphi, c_uimm8splo)); f[rd] = nan_box(t, 32, FLEN);`                    |
| `rv32_c_f`    | `c_fsw`   | `rs1_p, rs2_p, c_uimm7lo, c_uimm7hi` | `store_u32(x[8 + rs1_p] + decode_c_word_offset(c_uimm7hi, c_uimm7lo), u32(f[8 + rs2_p]));`                           |
| `rv32_c_f`    | `c_fswsp` | `c_rs2, c_uimm8sp_s`                 | `store_u32(sp + decode_c_swsp(c_uimm8sp_s), u32(f[c_rs2]));`                                                         |

:RV32C - Standard Extension for Compressed Instructions (32 bit)

| **Extension** | **Name**  | **Variable-Fields**                   | **Pseudo-Code**                                                                                                  |
|:--------------|:----------|:--------------------------------------|:-----------------------------------------------------------------------------------------------------------------|
| `rv64_c`      | `c_addiw` | `rd_rs1_n0, c_imm6lo, c_imm6hi`       | `x[rd_rs1_n0] = sx(s32(u32(x[rd_rs1_n0]) + u32(sx(decode_c_imm6(c_imm6hi, c_imm6lo)))));`                        |
| `rv64_c`      | `c_addw`  | `rd_rs1_p, rs2_p`                     | `x[8 + rd_rs1_p] = sx(s32(u32(x[8 + rd_rs1_p]) + u32(x[8 + rs2_p])));`                                           |
| `rv64_c`      | `c_ld`    | `rd_p, rs1_p, c_uimm8lo, c_uimm8hi`   | `u64_t t = load_u64(x[8 + rs1_p] + decode_c_doubleword_offset(c_uimm8hi, c_uimm8lo)); x[8 + rd_p] = sx(s64(t));` |
| `rv64_c`      | `c_ldsp`  | `rd_n0, c_uimm9sphi, c_uimm9splo`     | `u64_t t = load_u64(sp + decode_c_ldsp(c_uimm9sphi, c_uimm9splo)); x[rd_n0] = sx(s64(t));`                       |
| `rv64_c`      | `c_sd`    | `rs1_p, rs2_p, c_uimm8hi, c_uimm8lo`  | `store_u64(x[8 + rs1_p] + decode_c_doubleword_offset(c_uimm8hi, c_uimm8lo), u64(x[8 + rs2_p]));`                 |
| `rv64_c`      | `c_sdsp`  | `c_rs2, c_uimm9sp_s`                  | `store_u64(sp + decode_c_sdsp(c_uimm9sp_s), u64(x[c_rs2]));`                                                     |
| `rv64_c`      | `c_slli`  | `rd_rs1_n0, c_nzuimm6hi, c_nzuimm6lo` | `x[rd_rs1_n0] = ux(x[rd_rs1_n0]) << decode_c_shift(c_nzuimm6hi, c_nzuimm6lo);`                                   |
| `rv64_c`      | `c_srai`  | `rd_rs1_p, c_nzuimm6lo, c_nzuimm6hi`  | `x[8 + rd_rs1_p] = sx(x[8 + rd_rs1_p]) >> decode_c_shift(c_nzuimm6hi, c_nzuimm6lo);`                             |
| `rv64_c`      | `c_srli`  | `rd_rs1_p, c_nzuimm6lo, c_nzuimm6hi`  | `x[8 + rd_rs1_p] = ux(x[8 + rd_rs1_p]) >> decode_c_shift(c_nzuimm6hi, c_nzuimm6lo);`                             |
| `rv64_c`      | `c_subw`  | `rd_rs1_p, rs2_p`                     | `x[8 + rd_rs1_p] = sx(s32(u32(x[8 + rd_rs1_p]) - u32(x[8 + rs2_p])));`                                           |

:RV64C - Standard Extension for Compressed Instructions (64 bit)

| **Extension** | **Name** | **Variable-Fields**   | **Pseudo-Code**                                  |
|:--------------|:---------|:----------------------|:-------------------------------------------------|
| `rv128_c`     | `c_lq`   | `crdq, crs1q, cimmq`  | `u128_t t = load_u128(crs1q + cimmq); crdq = t;` |
| `rv128_c`     | `c_lqsp` | `crd, cimmlqsp`       | `u128_t t = load_u128(sp + cimmlqsp); crd = t;`  |
| `rv128_c`     | `c_sq`   | `crs1q, crs2q, cimmq` | `store_u128(crs1q + cimmq, u128(crs2q));`        |
| `rv128_c`     | `c_sqsp` | `crs2, cimmsqsp`      | `store_u128(sp + cimmsqsp, u128(crs2));`         |

:RV128C - Standard Extension for Compressed Instructions (128 bit)

| **Extension** | **Name**     | **Variable-Fields**     | **Pseudo-Code**                                                                                                                          |
|:--------------|:-------------|:------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------|
| `rv_zcb`      | `c_lbu`      | `rd_p, rs1_p, c_uimm2`  | `rd_p = load_u8(rs1_p + decode_offset(c_uimm2));`                                                                                        |
| `rv_zcb`      | `c_lh`       | `rd_p, rs1_p, c_uimm1`  | `rd_p = load_s16(rs1_p + decode_offset(c_uimm1));`                                                                                       |
| `rv_zcb`      | `c_lhu`      | `rd_p, rs1_p, c_uimm1`  | `rd_p = load_u16(rs1_p + decode_offset(c_uimm1));`                                                                                       |
| `rv_zcb`      | `c_mul`      | `rd_rs1_p, rs2_p`       | `rd_rs1_p = rd_rs1_p * rs2_p;`                                                                                                           |
| `rv_zcb`      | `c_not`      | `rd_rs1_p`              | `rd_rs1_p = ~rd_rs1_p;`                                                                                                                  |
| `rv_zcb`      | `c_sb`       | `rs2_p, rs1_p, c_uimm2` | `store_u8(rs1_p + decode_offset(c_uimm2), u8(rs2_p));`                                                                                   |
| `rv_zcb`      | `c_sext_b`   | `rd_rs1_p`              | `rd_rs1_p = sx(s8(rd_rs1_p));`                                                                                                           |
| `rv_zcb`      | `c_sext_h`   | `rd_rs1_p`              | `rd_rs1_p = sx(s16(rd_rs1_p));`                                                                                                          |
| `rv_zcb`      | `c_sh`       | `rs2_p, rs1_p, c_uimm1` | `store_u16(rs1_p + decode_offset(c_uimm1), u16(rs2_p));`                                                                                 |
| `rv_zcb`      | `c_zext_b`   | `rd_rs1_p`              | `rd_rs1_p = zx(u8(rd_rs1_p));`                                                                                                           |
| `rv_zcb`      | `c_zext_h`   | `rd_rs1_p`              | `rd_rs1_p = zx(u16(rd_rs1_p));`                                                                                                          |
| `rv_zcmop`    | `c_mop_N`    | `c_mop_t`               | `ignore_fields(c_mop_t); nop();`                                                                                                         |
| `rv_zcmp`     | `cm_mva01s`  | `c_sreg1, c_sreg2`      | `parallel_move(a0, a1, sreg(c_sreg1), sreg(c_sreg2));`                                                                                   |
| `rv_zcmp`     | `cm_mvsa01`  | `c_sreg1, c_sreg2`      | `parallel_move(sreg(c_sreg1), sreg(c_sreg2), a0, a1);`                                                                                   |
| `rv_zcmp`     | `cm_pop`     | `c_rlist, c_spimm`      | `load_stack_regs(sp, c_rlist, c_spimm); sp = sp + stack_adjust(c_rlist, c_spimm);`                                                       |
| `rv_zcmp`     | `cm_popret`  | `c_rlist, c_spimm`      | `load_stack_regs(sp, c_rlist, c_spimm); sp = sp + stack_adjust(c_rlist, c_spimm); pc_offset = (ra & ~1) - pc;`                           |
| `rv_zcmp`     | `cm_popretz` | `c_rlist, c_spimm`      | `load_stack_regs(sp, c_rlist, c_spimm); sp = sp + stack_adjust(c_rlist, c_spimm); a0 = 0; pc_offset = (ra & ~1) - pc;`                   |
| `rv_zcmp`     | `cm_push`    | `c_rlist, c_spimm`      | `store_stack_regs(sp, c_rlist); sp = sp - stack_adjust(c_rlist, c_spimm);`                                                               |
| `rv_zcmt`     | `cm_jalt`    | `c_index`               | `ux_t target = instruction_fetch_XLEN(jvt_base + c_index * (XLEN / 8)); if (c_index >= 32) ra = pc + 2; pc_offset = (target & ~1) - pc;` |

:RVZC - Standard Extension for Compressed Instructions

| **Extension** | **Name**   | **Variable-Fields** | **Pseudo-Code**                 |
|:--------------|:-----------|:--------------------|:--------------------------------|
| `rv64_zcb`    | `c_zext_w` | `rd_rs1_p`          | `rd_rs1_p = zx(u32(rd_rs1_p));` |

:RV64ZC - Standard Extension for Compressed Instructions (64 bit)
