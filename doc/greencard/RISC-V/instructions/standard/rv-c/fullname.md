## INSTRUCTION FULL-NAMES

| **Extension** | **Name**     | **Variable-Fields**                  | **Full-Name**                                           |
|:--------------|:-------------|:-------------------------------------|:--------------------------------------------------------|
| `rv_c`        | `c_add`      | `rd_rs1_n0, c_rs2_n0`                | `Add`                                                   |
| `rv_c`        | `c_addi`     | `rd_rs1_n0, c_nzimm6lo, c_nzimm6hi`  | `Add Immediate`                                         |
| `rv_c`        | `c_addi16sp` | `c_nzimm10hi, c_nzimm10lo`           | `Add Immediate to Stack Pointer`                        |
| `rv_c`        | `c_addi4spn` | `rd_p, c_nzuimm10`                   | `Add Immediate to Stack Pointer, Non-Destructive`       |
| `rv_c`        | `c_and`      | `rd_rs1_p, rs2_p`                    | `And`                                                   |
| `rv_c`        | `c_andi`     | `rd_rs1_p, c_imm6hi, c_imm6lo`       | `And Immediate`                                         |
| `rv_c`        | `c_beqz`     | `rs1_p, c_bimm9lo, c_bimm9hi`        | `Branch if Equal to Zero`                               |
| `rv_c`        | `c_bnez`     | `rs1_p, c_bimm9lo, c_bimm9hi`        | `Branch if Not Equal to Zero`                           |
| `rv_c`        | `c_ebreak`   | `none`                               | `Environment Breakpoint`                                |
| `rv_c`        | `c_j`        | `c_imm12`                            | `Jump`                                                  |
| `rv_c`        | `c_jalr`     | `c_rs1_n0`                           | `Jump and Link Register`                                |
| `rv_c`        | `c_jr`       | `rs1_n0`                             | `Jump Register`                                         |
| `rv_c`        | `c_li`       | `rd_n0, c_imm6lo, c_imm6hi`          | `Load Immediate`                                        |
| `rv_c`        | `c_lui`      | `rd_n2, c_nzimm18hi, c_nzimm18lo`    | `Load Upper Immediate`                                  |
| `rv_c`        | `c_lw`       | `rd_p, rs1_p, c_uimm7lo, c_uimm7hi`  | `Load Word`                                             |
| `rv_c`        | `c_lwsp`     | `rd_n0, c_uimm8sphi, c_uimm8splo`    | `Load Word Relative to Stack Pointer`                   |
| `rv_c`        | `c_mv`       | `rd_n0, c_rs2_n0`                    | `Move`                                                  |
| `rv_c`        | `c_nop`      | `c_nzimm6hi, c_nzimm6lo`             | `No Operation`                                          |
| `rv_c`        | `c_or`       | `rd_rs1_p, rs2_p`                    | `Or`                                                    |
| `rv_c`        | `c_sub`      | `rd_rs1_p, rs2_p`                    | `Subtract`                                              |
| `rv_c`        | `c_sw`       | `rs1_p, rs2_p, c_uimm7lo, c_uimm7hi` | `Store Word`                                            |
| `rv_c`        | `c_swsp`     | `c_rs2, c_uimm8sp_s`                 | `Store Word Relative to Stack Pointer`                  |
| `rv_c`        | `c_xor`      | `rd_rs1_p, rs2_p`                    | `Xor`                                                   |
| `rv_c_d`      | `c_fld`      | `rd_p, rs1_p, c_uimm8lo, c_uimm8hi`  | `Floating-Point Load Double`                            |
| `rv_c_d`      | `c_fldsp`    | `rd, c_uimm9sphi, c_uimm9splo`       | `Floating-Point Load Double Relative to Stack Pointer`  |
| `rv_c_d`      | `c_fsd`      | `rs1_p, rs2_p, c_uimm8lo, c_uimm8hi` | `Floating-Point Store Double`                           |
| `rv_c_d`      | `c_fsdsp`    | `c_rs2, c_uimm9sp_s`                 | `Floating-Point Store Double Relative to Stack Pointer` |

:RVC - Standard Extension for Compressed Instructions

| **Extension** | **Name**  | **Variable-Fields**                  | **Full-Name**                                         |
|:--------------|:----------|:-------------------------------------|:------------------------------------------------------|
| `rv32_c`      | `c_jal`   | `c_imm12`                            | `Jump and Link`                                       |
| `rv32_c_f`    | `c_flw`   | `rd_p, rs1_p, c_uimm7lo, c_uimm7hi`  | `Floating-Point Load Word`                            |
| `rv32_c_f`    | `c_flwsp` | `rd, c_uimm8sphi, c_uimm8splo`       | `Floating-Point Load Word Relative to Stack Pointer`  |
| `rv32_c_f`    | `c_fsw`   | `rs1_p, rs2_p, c_uimm7lo, c_uimm7hi` | `Floating-Point Store Word`                           |
| `rv32_c_f`    | `c_fswsp` | `c_rs2, c_uimm8sp_s`                 | `Floating-Point Store Word Relative to Stack Pointer` |

:RV32C - Standard Extension for Compressed Instructions (32 bit)

| **Extension** | **Name**  | **Variable-Fields**                   | **Full-Name**                            |
|:--------------|:----------|:--------------------------------------|:-----------------------------------------|
| `rv64_c`      | `c_addiw` | `rd_rs1_n0, c_imm6lo, c_imm6hi`       | `Add Immediate Word`                     |
| `rv64_c`      | `c_addw`  | `rd_rs1_p, rs2_p`                     | `Add Word`                               |
| `rv64_c`      | `c_ld`    | `rd_p, rs1_p, c_uimm8lo, c_uimm8hi`   | `Load Double`                            |
| `rv64_c`      | `c_ldsp`  | `rd_n0, c_uimm9sphi, c_uimm9splo`     | `Load Double Relative to Stack Pointer`  |
| `rv64_c`      | `c_sd`    | `rs1_p, rs2_p, c_uimm8hi, c_uimm8lo`  | `Store Double`                           |
| `rv64_c`      | `c_sdsp`  | `c_rs2, c_uimm9sp_s`                  | `Store Double Relative to Stack Pointer` |
| `rv64_c`      | `c_slli`  | `rd_rs1_n0, c_nzuimm6hi, c_nzuimm6lo` | `Shift Left Logical Immediate`           |
| `rv64_c`      | `c_srai`  | `rd_rs1_p, c_nzuimm6lo, c_nzuimm6hi`  | `Shift Right Arithmetic Immediate`       |
| `rv64_c`      | `c_srli`  | `rd_rs1_p, c_nzuimm6lo, c_nzuimm6hi`  | `Shift Right Logical Immediate`          |
| `rv64_c`      | `c_subw`  | `rd_rs1_p, rs2_p`                     | `Subtract Word`                          |

:RV64C - Standard Extension for Compressed Instructions (64 bit)

| **Extension** | **Name** | **Variable-Fields**   | **Full-Name**                          |
|:--------------|:---------|:----------------------|:---------------------------------------|
| `rv128_c`     | `c_lq`   | `crdq, crs1q, cimmq`  | `Load Quad`                            |
| `rv128_c`     | `c_lqsp` | `crd, cimmlqsp`       | `Load Quad Relative to Stack Pointer`  |
| `rv128_c`     | `c_sq`   | `crs1q, crs2q, cimmq` | `Store Quad`                           |
| `rv128_c`     | `c_sqsp` | `crs2, cimmsqsp`      | `Store Quad Relative to Stack Pointer` |

:RV128C - Standard Extension for Compressed Instructions (128 bit)

| **Extension** | **Name**     | **Variable-Fields**     | **Full-Name**                                  |
|:--------------|:-------------|:------------------------|:-----------------------------------------------|
| `rv_zcb`      | `c_lbu`      | `rd_p, rs1_p, c_uimm2`  | `Compressed Load Byte Unsigned`                |
| `rv_zcb`      | `c_lh`       | `rd_p, rs1_p, c_uimm1`  | `Compressed Load Halfword`                     |
| `rv_zcb`      | `c_lhu`      | `rd_p, rs1_p, c_uimm1`  | `Compressed Load Halfword Unsigned`            |
| `rv_zcb`      | `c_mul`      | `rd_rs1_p, rs2_p`       | `Compressed Multiply`                          |
| `rv_zcb`      | `c_not`      | `rd_rs1_p`              | `Compressed Bitwise NOT`                       |
| `rv_zcb`      | `c_sb`       | `rs2_p, rs1_p, c_uimm2` | `Compressed Store Byte`                        |
| `rv_zcb`      | `c_sext_b`   | `rd_rs1_p`              | `Compressed Sign-Extend Byte`                  |
| `rv_zcb`      | `c_sext_h`   | `rd_rs1_p`              | `Compressed Sign-Extend Halfword`              |
| `rv_zcb`      | `c_sh`       | `rs2_p, rs1_p, c_uimm1` | `Compressed Store Halfword`                    |
| `rv_zcb`      | `c_zext_b`   | `rd_rs1_p`              | `Compressed Zero-Extend Byte`                  |
| `rv_zcb`      | `c_zext_h`   | `rd_rs1_p`              | `Compressed Zero-Extend Halfword`              |
| `rv_zcmop`    | `c_mop_N`    | `c_mop_t`               | `Compressed May-Be-Operation`                  |
| `rv_zcmp`     | `cm_mva01s`  | `c_sreg1, c_sreg2`      | `Compressed Move Saved Registers to a0 and a1` |
| `rv_zcmp`     | `cm_mvsa01`  | `c_sreg1, c_sreg2`      | `Compressed Move a0 and a1 to Saved Registers` |
| `rv_zcmp`     | `cm_pop`     | `c_rlist, c_spimm`      | `Compressed Pop Registers`                     |
| `rv_zcmp`     | `cm_popret`  | `c_rlist, c_spimm`      | `Compressed Pop Registers and Return`          |
| `rv_zcmp`     | `cm_popretz` | `c_rlist, c_spimm`      | `Compressed Pop Registers and Return Zero`     |
| `rv_zcmp`     | `cm_push`    | `c_rlist, c_spimm`      | `Compressed Push Registers`                    |
| `rv_zcmt`     | `cm_jalt`    | `c_index`               | `Compressed Table Jump and Link`               |

:RVZC - Standard Extension for Compressed Instructions

| **Extension** | **Name**   | **Variable-Fields** | **Full-Name**                 |
|:--------------|:-----------|:--------------------|:------------------------------|
| `rv64_zcb`    | `c_zext_w` | `rd_rs1_p`          | `Compressed Zero-Extend Word` |

:RV64ZC - Standard Extension for Compressed Instructions (64 bit)
