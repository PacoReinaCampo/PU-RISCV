## INSTRUCTION CLASSES

| **Extension** | **Name**     | **Variable-Fields**                  | **Class**    |
|:--------------|:-------------|:-------------------------------------|:-------------|
| `rv_c`        | `c_add`      | `rd_rs1_n0, c_rs2_n0`                | `compressed` |
| `rv_c`        | `c_addi`     | `rd_rs1_n0, c_nzimm6lo, c_nzimm6hi`  | `compressed` |
| `rv_c`        | `c_addi16sp` | `c_nzimm10hi, c_nzimm10lo`           | `compressed` |
| `rv_c`        | `c_addi4spn` | `rd_p, c_nzuimm10`                   | `compressed` |
| `rv_c`        | `c_and`      | `rd_rs1_p, rs2_p`                    | `compressed` |
| `rv_c`        | `c_andi`     | `rd_rs1_p, c_imm6hi, c_imm6lo`       | `compressed` |
| `rv_c`        | `c_beqz`     | `rs1_p, c_bimm9lo, c_bimm9hi`        | `compressed` |
| `rv_c`        | `c_bnez`     | `rs1_p, c_bimm9lo, c_bimm9hi`        | `compressed` |
| `rv_c`        | `c_ebreak`   | `none`                               | `compressed` |
| `rv_c`        | `c_j`        | `c_imm12`                            | `compressed` |
| `rv_c`        | `c_jalr`     | `c_rs1_n0`                           | `compressed` |
| `rv_c`        | `c_jr`       | `rs1_n0`                             | `compressed` |
| `rv_c`        | `c_li`       | `rd_n0, c_imm6lo, c_imm6hi`          | `compressed` |
| `rv_c`        | `c_lui`      | `rd_n2, c_nzimm18hi, c_nzimm18lo`    | `compressed` |
| `rv_c`        | `c_lw`       | `rd_p, rs1_p, c_uimm7lo, c_uimm7hi`  | `compressed` |
| `rv_c`        | `c_lwsp`     | `rd_n0, c_uimm8sphi, c_uimm8splo`    | `compressed` |
| `rv_c`        | `c_mv`       | `rd_n0, c_rs2_n0`                    | `compressed` |
| `rv_c`        | `c_nop`      | `c_nzimm6hi, c_nzimm6lo`             | `compressed` |
| `rv_c`        | `c_or`       | `rd_rs1_p, rs2_p`                    | `compressed` |
| `rv_c`        | `c_sub`      | `rd_rs1_p, rs2_p`                    | `compressed` |
| `rv_c`        | `c_sw`       | `rs1_p, rs2_p, c_uimm7lo, c_uimm7hi` | `compressed` |
| `rv_c`        | `c_swsp`     | `c_rs2, c_uimm8sp_s`                 | `compressed` |
| `rv_c`        | `c_xor`      | `rd_rs1_p, rs2_p`                    | `compressed` |
| `rv_c_d`      | `c_fld`      | `rd_p, rs1_p, c_uimm8lo, c_uimm8hi`  | `compressed` |
| `rv_c_d`      | `c_fldsp`    | `rd, c_uimm9sphi, c_uimm9splo`       | `compressed` |
| `rv_c_d`      | `c_fsd`      | `rs1_p, rs2_p, c_uimm8lo, c_uimm8hi` | `compressed` |
| `rv_c_d`      | `c_fsdsp`    | `c_rs2, c_uimm9sp_s`                 | `compressed` |

:RVC - Standard Extension for Compressed Instructions

| **Extension** | **Name**  | **Variable-Fields**                  | **Class**    |
|:--------------|:----------|:-------------------------------------|:-------------|
| `rv32_c`      | `c_jal`   | `c_imm12`                            | `compressed` |
| `rv32_c_f`    | `c_flw`   | `rd_p, rs1_p, c_uimm7lo, c_uimm7hi`  | `compressed` |
| `rv32_c_f`    | `c_flwsp` | `rd, c_uimm8sphi, c_uimm8splo`       | `compressed` |
| `rv32_c_f`    | `c_fsw`   | `rs1_p, rs2_p, c_uimm7lo, c_uimm7hi` | `compressed` |
| `rv32_c_f`    | `c_fswsp` | `c_rs2, c_uimm8sp_s`                 | `compressed` |

:RV32C - Standard Extension for Compressed Instructions (32 bit)

| **Extension** | **Name**  | **Variable-Fields**                   | **Class**    |
|:--------------|:----------|:--------------------------------------|:-------------|
| `rv64_c`      | `c_addiw` | `rd_rs1_n0, c_imm6lo, c_imm6hi`       | `compressed` |
| `rv64_c`      | `c_addw`  | `rd_rs1_p, rs2_p`                     | `compressed` |
| `rv64_c`      | `c_ld`    | `rd_p, rs1_p, c_uimm8lo, c_uimm8hi`   | `compressed` |
| `rv64_c`      | `c_ldsp`  | `rd_n0, c_uimm9sphi, c_uimm9splo`     | `compressed` |
| `rv64_c`      | `c_sd`    | `rs1_p, rs2_p, c_uimm8hi, c_uimm8lo`  | `compressed` |
| `rv64_c`      | `c_sdsp`  | `c_rs2, c_uimm9sp_s`                  | `compressed` |
| `rv64_c`      | `c_slli`  | `rd_rs1_n0, c_nzuimm6hi, c_nzuimm6lo` | `compressed` |
| `rv64_c`      | `c_srai`  | `rd_rs1_p, c_nzuimm6lo, c_nzuimm6hi`  | `compressed` |
| `rv64_c`      | `c_srli`  | `rd_rs1_p, c_nzuimm6lo, c_nzuimm6hi`  | `compressed` |
| `rv64_c`      | `c_subw`  | `rd_rs1_p, rs2_p`                     | `compressed` |

:RV64C - Standard Extension for Compressed Instructions (64 bit)

| **Extension** | **Name** | **Variable-Fields**   | **Class**    |
|:--------------|:---------|:----------------------|:-------------|
| `rv128_c`     | `c_lq`   | `crdq, crs1q, cimmq`  | `compressed` |
| `rv128_c`     | `c_lqsp` | `crd, cimmlqsp`       | `compressed` |
| `rv128_c`     | `c_sq`   | `crs1q, crs2q, cimmq` | `compressed` |
| `rv128_c`     | `c_sqsp` | `crs2, cimmsqsp`      | `compressed` |

:RV128C - Standard Extension for Compressed Instructions (128 bit)

| **Extension** | **Name**     | **Variable-Fields**     | **Class**        |
|:--------------|:-------------|:------------------------|:-----------------|
| `rv_zcb`      | `c_lbu`      | `rd_p, rs1_p, c_uimm2`  | `load`           |
| `rv_zcb`      | `c_lh`       | `rd_p, rs1_p, c_uimm1`  | `load`           |
| `rv_zcb`      | `c_lhu`      | `rd_p, rs1_p, c_uimm1`  | `load`           |
| `rv_zcb`      | `c_mul`      | `rd_rs1_p, rs2_p`       | `alu, multiply`  |
| `rv_zcb`      | `c_not`      | `rd_rs1_p`              | `alu`            |
| `rv_zcb`      | `c_sb`       | `rs2_p, rs1_p, c_uimm2` | `store`          |
| `rv_zcb`      | `c_sext_b`   | `rd_rs1_p`              | `alu`            |
| `rv_zcb`      | `c_sext_h`   | `rd_rs1_p`              | `alu`            |
| `rv_zcb`      | `c_sh`       | `rs2_p, rs1_p, c_uimm1` | `store`          |
| `rv_zcb`      | `c_zext_b`   | `rd_rs1_p`              | `alu`            |
| `rv_zcb`      | `c_zext_h`   | `rd_rs1_p`              | `alu`            |
| `rv_zcmop`    | `c_mop_N`    | `c_mop_t`               | `alu`            |
| `rv_zcmp`     | `cm_mva01s`  | `c_sreg1, c_sreg2`      | `alu`            |
| `rv_zcmp`     | `cm_mvsa01`  | `c_sreg1, c_sreg2`      | `alu`            |
| `rv_zcmp`     | `cm_pop`     | `c_rlist, c_spimm`      | `load`           |
| `rv_zcmp`     | `cm_popret`  | `c_rlist, c_spimm`      | `load, jump`     |
| `rv_zcmp`     | `cm_popretz` | `c_rlist, c_spimm`      | `load, jump`     |
| `rv_zcmp`     | `cm_push`    | `c_rlist, c_spimm`      | `store`          |
| `rv_zcmt`     | `cm_jalt`    | `c_index`               | `jump, indirect` |

:RVZC - Standard Extension for Compressed Instructions

| **Extension** | **Name**   | **Variable-Fields** | **Class** |
|:--------------|:-----------|:--------------------|:----------|
| `rv64_zcb`    | `c_zext_w` | `rd_rs1_p`          | `alu`     |

:RV64ZC - Standard Extension for Compressed Instructions (64 bit)
