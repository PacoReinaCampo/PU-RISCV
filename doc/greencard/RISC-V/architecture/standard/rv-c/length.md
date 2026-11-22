## INSTRUCTION LENGTHS

| **Extension** | **Name**     | **Length** |
|:--------------|:-------------|:-----------|
| `rv_c`        | `c_add`      | `XLEN`     |
| `rv_c`        | `c_addi`     | `XLEN`     |
| `rv_c`        | `c_addi16sp` | `XLEN`     |
| `rv_c`        | `c_addi4spn` | `XLEN`     |
| `rv_c`        | `c_and`      | `XLEN`     |
| `rv_c`        | `c_andi`     | `XLEN`     |
| `rv_c`        | `c_beqz`     | `XLEN`     |
| `rv_c`        | `c_bnez`     | `XLEN`     |
| `rv_c`        | `c_ebreak`   | `XLEN`     |
| `rv_c`        | `c_j`        | `XLEN`     |
| `rv_c`        | `c_jalr`     | `XLEN`     |
| `rv_c`        | `c_jr`       | `XLEN`     |
| `rv_c`        | `c_li`       | `XLEN`     |
| `rv_c`        | `c_lui`      | `XLEN`     |
| `rv_c`        | `c_lw`       | `XLEN`     |
| `rv_c`        | `c_lwsp`     | `XLEN`     |
| `rv_c`        | `c_mv`       | `XLEN`     |
| `rv_c`        | `c_nop`      | `XLEN`     |
| `rv_c`        | `c_or`       | `XLEN`     |
| `rv_c`        | `c_sub`      | `XLEN`     |
| `rv_c`        | `c_sw`       | `XLEN`     |
| `rv_c`        | `c_swsp`     | `XLEN`     |
| `rv_c`        | `c_xor`      | `XLEN`     |
| `rv_c_d`      | `c_fld`      | `FLEN`     |
| `rv_c_d`      | `c_fldsp`    | `FLEN`     |
| `rv_c_d`      | `c_fsd`      | `FLEN`     |
| `rv_c_d`      | `c_fsdsp`    | `FLEN`     |

:RVC - Standard Extension for Compressed Instructions

| **Extension** | **Name**  | **Length** |
|:--------------|:----------|:-----------|
| `rv32_c`      | `c_jal`   | `XLEN`     |
| `rv32_c_f`    | `c_flw`   | `FLEN`     |
| `rv32_c_f`    | `c_flwsp` | `FLEN`     |
| `rv32_c_f`    | `c_fsw`   | `FLEN`     |
| `rv32_c_f`    | `c_fswsp` | `FLEN`     |

:RV32C - Standard Extension for Compressed Instructions (32 bit)

| **Extension** | **Name**  | **Length** |
|:--------------|:----------|:-----------|
| `rv64_c`      | `c_addiw` | `XLEN`     |
| `rv64_c`      | `c_addw`  | `XLEN`     |
| `rv64_c`      | `c_ld`    | `XLEN`     |
| `rv64_c`      | `c_ldsp`  | `XLEN`     |
| `rv64_c`      | `c_sd`    | `XLEN`     |
| `rv64_c`      | `c_sdsp`  | `XLEN`     |
| `rv64_c`      | `c_slli`  | `XLEN`     |
| `rv64_c`      | `c_srai`  | `XLEN`     |
| `rv64_c`      | `c_srli`  | `XLEN`     |
| `rv64_c`      | `c_subw`  | `XLEN`     |

:RV64C - Standard Extension for Compressed Instructions (64 bit)

| **Extension** | **Name** | **Length** |
|:--------------|:---------|:-----------|
| `rv128_c`     | `c_lq`   | `XLEN`     |
| `rv128_c`     | `c_lqsp` | `XLEN`     |
| `rv128_c`     | `c_sq`   | `XLEN`     |
| `rv128_c`     | `c_sqsp` | `XLEN`     |

:RV128C - Standard Extension for Compressed Instructions (128 bit)

| **Extension** | **Name**     | **Length** |
|:--------------|:-------------|:-----------|
| `rv_zcb`      | `c_lbu`      | `XLEN`     |
| `rv_zcb`      | `c_lh`       | `XLEN`     |
| `rv_zcb`      | `c_lhu`      | `XLEN`     |
| `rv_zcb`      | `c_mul`      | `XLEN`     |
| `rv_zcb`      | `c_not`      | `XLEN`     |
| `rv_zcb`      | `c_sb`       | `XLEN`     |
| `rv_zcb`      | `c_sext_b`   | `XLEN`     |
| `rv_zcb`      | `c_sext_h`   | `XLEN`     |
| `rv_zcb`      | `c_sh`       | `XLEN`     |
| `rv_zcb`      | `c_zext_b`   | `XLEN`     |
| `rv_zcb`      | `c_zext_h`   | `XLEN`     |
| `rv_zcmop`    | `c_mop_N`    | `XLEN`     |
| `rv_zcmp`     | `cm_mva01s`  | `XLEN`     |
| `rv_zcmp`     | `cm_mvsa01`  | `XLEN`     |
| `rv_zcmp`     | `cm_pop`     | `XLEN`     |
| `rv_zcmp`     | `cm_popret`  | `XLEN`     |
| `rv_zcmp`     | `cm_popretz` | `XLEN`     |
| `rv_zcmp`     | `cm_push`    | `XLEN`     |
| `rv_zcmt`     | `cm_jalt`    | `XLEN`     |

:RVZC - Standard Extension for Compressed Instructions

| **Extension** | **Name**   | **Length** |
|:--------------|:-----------|:-----------|
| `rv64_zcb`    | `c_zext_w` | `XLEN`     |

:RV64ZC - Standard Extension for Compressed Instructions (64 bit)
