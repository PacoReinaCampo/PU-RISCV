## INSTRUCTION DESCRIPTIONS

| **Extension** | **Name**     | **Variable-Fields**                  | **Description**                                                                                                                                            |
|:--------------|:-------------|:-------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| `rv_c`        | `c_add`      | `rd_rs1_n0, c_rs2_n0`                | `Add x[c_rs2_n0] to x[rd_rs1_n0] and write back the result`                                                                                                |
| `rv_c`        | `c_addi`     | `rd_rs1_n0, c_nzimm6lo, c_nzimm6hi`  | `Add the signed displacement encoded by c_nzimm6hi and c_nzimm6lo to x[rd_rs1_n0] and write back the result`                                               |
| `rv_c`        | `c_addi16sp` | `c_nzimm10hi, c_nzimm10lo`           | `Add the signed displacement encoded by c_nzimm10hi and c_nzimm10lo to SP and write back the result.`                                                      |
| `rv_c`        | `c_addi4spn` | `rd_p, c_nzuimm10`                   | `Add the unsigned displacement encoded by c_nzuimm10 to SP and place the result into x[8 + rd_p]`                                                          |
| `rv_c`        | `c_and`      | `rd_rs1_p, rs2_p`                    | `Set x[8 + rd_rs1_p] to the bitwise AND of x[8 + rd_rs1_p] and x[8 + rs2_p]`                                                                               |
| `rv_c`        | `c_andi`     | `rd_rs1_p, c_imm6hi, c_imm6lo`       | `Set x[8 + rd_rs1_p] to its bitwise AND with the sign-extended displacement encoded by c_imm6hi and c_imm6lo, which may be zero`                           |
| `rv_c`        | `c_beqz`     | `rs1_p, c_bimm9lo, c_bimm9hi`        | `Branch to the PC plus the signed displacement encoded by c_bimm9hi and c_bimm9lo if x[8 + rs1_p] is zero`                                                 |
| `rv_c`        | `c_bnez`     | `rs1_p, c_bimm9lo, c_bimm9hi`        | `Branch to the PC plus the signed displacement encoded by c_bimm9hi and c_bimm9lo if x[8 + rs1_p] is nonzero`                                              |
| `rv_c`        | `c_ebreak`   | `none`                               | `Raise CAUSE_BREAKPOINT or enter Debug Mode when enabled.`                                                                                                 |
| `rv_c`        | `c_j`        | `c_imm12`                            | `Jump to the PC plus the signed displacement encoded by c_imm12`                                                                                           |
| `rv_c`        | `c_jalr`     | `c_rs1_n0`                           | `Jump to the address in c_rs1_n0 with bit 0 cleared and write PC + 2 to RA`                                                                                |
| `rv_c`        | `c_jr`       | `rs1_n0`                             | `Jump to the address in rs1_n0 with bit 0 cleared`                                                                                                         |
| `rv_c`        | `c_li`       | `rd_n0, c_imm6lo, c_imm6hi`          | `Load the signed displacement encoded by c_imm6hi and c_imm6lo into x[rd_n0]`                                                                              |
| `rv_c`        | `c_lui`      | `rd_n2, c_nzimm18hi, c_nzimm18lo`    | `Load the signed upper displacement encoded by c_nzimm18hi and c_nzimm18lo into x[rd_n2] with its low 12 bits cleared`                                     |
| `rv_c`        | `c_lw`       | `rd_p, rs1_p, c_uimm7lo, c_uimm7hi`  | `Load a 32-bit value from x[8 + rs1_p] + the value encoded by c_uimm7hi and c_uimm7lo and sign-extend the result into x[8 + rd_p]`                         |
| `rv_c`        | `c_lwsp`     | `rd_n0, c_uimm8sphi, c_uimm8splo`    | `Load a 32-bit value from SP + the value encoded by c_uimm8sphi and c_uimm8splo and sign-extend the result into x[rd_n0]`                                  |
| `rv_c`        | `c_mv`       | `rd_n0, c_rs2_n0`                    | `Copy x[c_rs2_n0] into x[rd_n0]`                                                                                                                           |
| `rv_c`        | `c_nop`      | `c_nzimm6hi, c_nzimm6lo`             | `Advance the PC by 2 bytes. The c_nzimm6hi and c_nzimm6lo fields encode the immediate, with nonzero values designated as HINTs.`                           |
| `rv_c`        | `c_or`       | `rd_rs1_p, rs2_p`                    | `Set x[8 + rd_rs1_p] to the bitwise OR of x[8 + rd_rs1_p] and x[8 + rs2_p]`                                                                                |
| `rv_c`        | `c_sub`      | `rd_rs1_p, rs2_p`                    | `Subtract x[8 + rs2_p] from x[8 + rd_rs1_p] and write back the result`                                                                                     |
| `rv_c`        | `c_sw`       | `rs1_p, rs2_p, c_uimm7lo, c_uimm7hi` | `Store the low 32 bits of x[8 + rs2_p] to x[8 + rs1_p] + the value encoded by c_uimm7hi and c_uimm7lo`                                                     |
| `rv_c`        | `c_swsp`     | `c_rs2, c_uimm8sp_s`                 | `Store the low 32 bits of x[c_rs2] to SP + the value encoded by c_uimm8sp_s`                                                                               |
| `rv_c`        | `c_xor`      | `rd_rs1_p, rs2_p`                    | `Set x[8 + rd_rs1_p] to the bitwise XOR of x[8 + rd_rs1_p] and x[8 + rs2_p]`                                                                               |
| `rv_c_d`      | `c_fld`      | `rd_p, rs1_p, c_uimm8lo, c_uimm8hi`  | `Load a 64-bit floating-point value from x[8 + rs1_p] + the value encoded by c_uimm8hi and c_uimm8lo into f[8 + rd_p], NaN-boxing it when FLEN exceeds 64` |
| `rv_c_d`      | `c_fldsp`    | `rd, c_uimm9sphi, c_uimm9splo`       | `Load a 64-bit floating-point value from SP + the value encoded by c_uimm9sphi and c_uimm9splo into f[rd], NaN-boxing it when FLEN exceeds 64`             |
| `rv_c_d`      | `c_fsd`      | `rs1_p, rs2_p, c_uimm8lo, c_uimm8hi` | `Store the low 64 bits of f[8 + rs2_p] to x[8 + rs1_p] + the value encoded by c_uimm8hi and c_uimm8lo`                                                     |
| `rv_c_d`      | `c_fsdsp`    | `c_rs2, c_uimm9sp_s`                 | `Store the low 64 bits of f[c_rs2] to SP + the value encoded by c_uimm9sp_s`                                                                               |

:RVC - Standard Extension for Compressed Instructions

| **Extension** | **Name**  | **Variable-Fields**                  | **Description**                                                                                                                                            |
|:--------------|:----------|:-------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| `rv32_c`      | `c_jal`   | `c_imm12`                            | `Jump to the PC plus the value encoded by c_imm12 and save PC+2 into RA`                                                                                   |
| `rv32_c_f`    | `c_flw`   | `rd_p, rs1_p, c_uimm7lo, c_uimm7hi`  | `Load a 32-bit floating-point value from x[8 + rs1_p] + the value encoded by c_uimm7hi and c_uimm7lo into f[8 + rd_p], NaN-boxing it when FLEN exceeds 32` |
| `rv32_c_f`    | `c_flwsp` | `rd, c_uimm8sphi, c_uimm8splo`       | `Load a 32-bit floating-point value from SP + the value encoded by c_uimm8sphi and c_uimm8splo into f[rd], NaN-boxing it when FLEN exceeds 32`             |
| `rv32_c_f`    | `c_fsw`   | `rs1_p, rs2_p, c_uimm7lo, c_uimm7hi` | `Store the low 32 bits of f[8 + rs2_p] to x[8 + rs1_p] + the value encoded by c_uimm7hi and c_uimm7lo`                                                     |
| `rv32_c_f`    | `c_fswsp` | `c_rs2, c_uimm8sp_s`                 | `Store the low 32 bits of f[c_rs2] to SP + the value encoded by c_uimm8sp_s`                                                                               |

:RV32C - Standard Extension for Compressed Instructions (32 bit)

| **Extension** | **Name**  | **Variable-Fields**                   | **Description**                                                                                                                                     |
|:--------------|:----------|:--------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------|
| `rv64_c`      | `c_addiw` | `rd_rs1_n0, c_imm6lo, c_imm6hi`       | `Add the signed displacement encoded by c_imm6hi and c_imm6lo to x[rd_rs1_n0] and sign-extend the low 32 bits of the result back into x[rd_rs1_n0]` |
| `rv64_c`      | `c_addw`  | `rd_rs1_p, rs2_p`                     | `Add the low 32 bits of x[8 + rs2_p] to the low 32 bits of x[8 + rd_rs1_p] and sign-extend the 32-bit result back into x[8 + rd_rs1_p]`             |
| `rv64_c`      | `c_ld`    | `rd_p, rs1_p, c_uimm8lo, c_uimm8hi`   | `Load a 64-bit value from x[8 + rs1_p] + the value encoded by c_uimm8hi and c_uimm8lo and sign-extend the result into x[8 + rd_p]`                  |
| `rv64_c`      | `c_ldsp`  | `rd_n0, c_uimm9sphi, c_uimm9splo`     | `Load a 64-bit value from SP + the value encoded by c_uimm9sphi and c_uimm9splo and sign-extend the result into x[rd_n0]`                           |
| `rv64_c`      | `c_sd`    | `rs1_p, rs2_p, c_uimm8hi, c_uimm8lo`  | `Store the low 64 bits of x[8 + rs2_p] to x[8 + rs1_p] + the value encoded by c_uimm8hi and c_uimm8lo`                                              |
| `rv64_c`      | `c_sdsp`  | `c_rs2, c_uimm9sp_s`                  | `Store the low 64 bits of x[c_rs2] to SP + the value encoded by c_uimm9sp_s`                                                                        |
| `rv64_c`      | `c_slli`  | `rd_rs1_n0, c_nzuimm6hi, c_nzuimm6lo` | `Shift x[rd_rs1_n0] left with zero fill by the value encoded by c_nzuimm6hi and c_nzuimm6lo and write back the result`                              |
| `rv64_c`      | `c_srai`  | `rd_rs1_p, c_nzuimm6lo, c_nzuimm6hi`  | `Shift x[8 + rd_rs1_p] right with sign fill by the value encoded by c_nzuimm6hi and c_nzuimm6lo and write back the result`                          |
| `rv64_c`      | `c_srli`  | `rd_rs1_p, c_nzuimm6lo, c_nzuimm6hi`  | `Shift x[8 + rd_rs1_p] right with zero fill by the value encoded by c_nzuimm6hi and c_nzuimm6lo and write back the result`                          |
| `rv64_c`      | `c_subw`  | `rd_rs1_p, rs2_p`                     | `Subtract the low 32 bits of x[8 + rs2_p] from the low 32 bits of x[8 + rd_rs1_p] and sign-extend the 32-bit result back into x[8 + rd_rs1_p]`      |

:RV64C - Standard Extension for Compressed Instructions (64 bit)

| **Extension** | **Name** | **Variable-Fields**   | **Description**                                         |
|:--------------|:---------|:----------------------|:--------------------------------------------------------|
| `rv128_c`     | `c_lq`   | `crdq, crs1q, cimmq`  | `Load the 128-bit value at crs1q plus cimmq into crdq.` |
| `rv128_c`     | `c_lqsp` | `crd, cimmlqsp`       | `Load the 128-bit value at SP plus cimmlqsp into crd.`  |
| `rv128_c`     | `c_sq`   | `crs1q, crs2q, cimmq` | `Store the 128-bit value in crs2q at crs1q plus cimmq.` |
| `rv128_c`     | `c_sqsp` | `crs2, cimmsqsp`      | `Store the 128-bit value in crs2 at SP plus cimmsqsp.`  |

:RV128C - Standard Extension for Compressed Instructions (128 bit)

| **Extension** | **Name**     | **Variable-Fields**     | **Description**                                                                                                                                        |
|:--------------|:-------------|:------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------|
| `rv_zcb`      | `c_lbu`      | `rd_p, rs1_p, c_uimm2`  | `Load 8 bits from rs1_p plus the decoded unsigned byte offset and zero-extend into rd_p. c_uimm2 supplies the encoded immediate.`                      |
| `rv_zcb`      | `c_lh`       | `rd_p, rs1_p, c_uimm1`  | `Load 16 bits from rs1_p plus the decoded unsigned byte offset and sign-extend into rd_p. c_uimm1 supplies the encoded immediate.`                     |
| `rv_zcb`      | `c_lhu`      | `rd_p, rs1_p, c_uimm1`  | `Load 16 bits from rs1_p plus the decoded unsigned byte offset and zero-extend into rd_p. c_uimm1 supplies the encoded immediate.`                     |
| `rv_zcb`      | `c_mul`      | `rd_rs1_p, rs2_p`       | `Multiply rd_rs1_p by rs2_p and retain the low XLEN bits`                                                                                              |
| `rv_zcb`      | `c_not`      | `rd_rs1_p`              | `Invert every bit of rd_rs1_p`                                                                                                                         |
| `rv_zcb`      | `c_sb`       | `rs2_p, rs1_p, c_uimm2` | `Store the low 8 bits of rs2_p at rs1_p plus the decoded unsigned byte offset. c_uimm2 supplies the encoded immediate.`                                |
| `rv_zcb`      | `c_sext_b`   | `rd_rs1_p`              | `Sign-extend the low 8 bits of rd_rs1_p to XLEN`                                                                                                       |
| `rv_zcb`      | `c_sext_h`   | `rd_rs1_p`              | `Sign-extend the low 16 bits of rd_rs1_p to XLEN`                                                                                                      |
| `rv_zcb`      | `c_sh`       | `rs2_p, rs1_p, c_uimm1` | `Store the low 16 bits of rs2_p at rs1_p plus the decoded unsigned byte offset. c_uimm1 supplies the encoded immediate.`                               |
| `rv_zcb`      | `c_zext_b`   | `rd_rs1_p`              | `Zero-extend the low 8 bits of rd_rs1_p to XLEN`                                                                                                       |
| `rv_zcb`      | `c_zext_h`   | `rd_rs1_p`              | `Zero-extend the low 16 bits of rd_rs1_p to XLEN`                                                                                                      |
| `rv_zcmop`    | `c_mop_N`    | `c_mop_t`               | `Select the Zcmop minor encoding with c_mop_t and make no architectural state changes under Zcmop.`                                                    |
| `rv_zcmp`     | `cm_mva01s`  | `c_sreg1, c_sreg2`      | `Copy the two selected saved registers into A0 and A1 atomically. The encoding supplies c_sreg1, c_sreg2.`                                             |
| `rv_zcmp`     | `cm_mvsa01`  | `c_sreg1, c_sreg2`      | `Copy A0 and A1 into the two selected saved registers atomically. The encoding supplies c_sreg1, c_sreg2.`                                             |
| `rv_zcmp`     | `cm_pop`     | `c_rlist, c_spimm`      | `Restore the selected registers and release the stack frame. The encoding supplies c_rlist, c_spimm.`                                                  |
| `rv_zcmp`     | `cm_popret`  | `c_rlist, c_spimm`      | `Restore the selected registers and release the stack frame and return through RA. The encoding supplies c_rlist, c_spimm.`                            |
| `rv_zcmp`     | `cm_popretz` | `c_rlist, c_spimm`      | `Restore the selected registers and release the stack frame and return through RA with A0 set to zero. The encoding supplies c_rlist, c_spimm.`        |
| `rv_zcmp`     | `cm_push`    | `c_rlist, c_spimm`      | `Save the registers selected by c_rlist and allocate the stack frame. c_spimm supplies the encoded immediate.`                                         |
| `rv_zcmt`     | `cm_jalt`    | `c_index`               | `Jump to the indexed JVT entry and save PC+2 in RA for indices 32 through 255. Indices below 32 encode CM.JT. c_index supplies the encoded immediate.` |

:RVZC - Standard Extension for Compressed Instructions

| **Extension** | **Name**   | **Variable-Fields** | **Description**                                   |
|:--------------|:-----------|:--------------------|:--------------------------------------------------|
| `rv64_zcb`    | `c_zext_w` | `rd_rs1_p`          | `Zero-extend the low 32 bits of rd_rs1_p to XLEN` |

:RV64ZC - Standard Extension for Compressed Instructions (64 bit)
