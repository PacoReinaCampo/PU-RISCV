## INSTRUCTION PRIVILEGE

| **Extension** | **Name**     | **Privilege** |
|:--------------|:-------------|:--------------|
| `rv_c`        | `c_add`      | `U`           |
| `rv_c`        | `c_addi`     | `U`           |
| `rv_c`        | `c_addi16sp` | `U`           |
| `rv_c`        | `c_addi4spn` | `U`           |
| `rv_c`        | `c_and`      | `U`           |
| `rv_c`        | `c_andi`     | `U`           |
| `rv_c`        | `c_beqz`     | `U`           |
| `rv_c`        | `c_bnez`     | `U`           |
| `rv_c`        | `c_ebreak`   | `U`           |
| `rv_c`        | `c_j`        | `U`           |
| `rv_c`        | `c_jalr`     | `U`           |
| `rv_c`        | `c_jr`       | `U`           |
| `rv_c`        | `c_li`       | `U`           |
| `rv_c`        | `c_lui`      | `U`           |
| `rv_c`        | `c_lw`       | `U`           |
| `rv_c`        | `c_lwsp`     | `U`           |
| `rv_c`        | `c_mv`       | `U`           |
| `rv_c`        | `c_nop`      | `U`           |
| `rv_c`        | `c_or`       | `U`           |
| `rv_c`        | `c_sub`      | `U`           |
| `rv_c`        | `c_sw`       | `U`           |
| `rv_c`        | `c_swsp`     | `U`           |
| `rv_c`        | `c_xor`      | `U`           |
| `rv_c_d`      | `c_fld`      | `U`           |
| `rv_c_d`      | `c_fldsp`    | `U`           |
| `rv_c_d`      | `c_fsd`      | `U`           |
| `rv_c_d`      | `c_fsdsp`    | `U`           |

:RVC - Standard Extension for Compressed Instructions

| **Extension** | **Name**  | **Privilege** |
|:--------------|:----------|:--------------|
| `rv32_c`      | `c_jal`   | `U`           |
| `rv32_c_f`    | `c_flw`   | `U`           |
| `rv32_c_f`    | `c_flwsp` | `U`           |
| `rv32_c_f`    | `c_fsw`   | `U`           |
| `rv32_c_f`    | `c_fswsp` | `U`           |

:RV32C - Standard Extension for Compressed Instructions (32 bit)

| **Extension** | **Name**  | **Privilege** |
|:--------------|:----------|:--------------|
| `rv64_c`      | `c_addiw` | `U`           |
| `rv64_c`      | `c_addw`  | `U`           |
| `rv64_c`      | `c_ld`    | `U`           |
| `rv64_c`      | `c_ldsp`  | `U`           |
| `rv64_c`      | `c_sd`    | `U`           |
| `rv64_c`      | `c_sdsp`  | `U`           |
| `rv64_c`      | `c_slli`  | `U`           |
| `rv64_c`      | `c_srai`  | `U`           |
| `rv64_c`      | `c_srli`  | `U`           |
| `rv64_c`      | `c_subw`  | `U`           |

:RV64C - Standard Extension for Compressed Instructions (64 bit)

| **Extension** | **Name** | **Privilege** |
|:--------------|:---------|:--------------|
| `rv128_c`     | `c_lq`   | `U`           |
| `rv128_c`     | `c_lqsp` | `U`           |
| `rv128_c`     | `c_sq`   | `U`           |
| `rv128_c`     | `c_sqsp` | `U`           |

:RV128C - Standard Extension for Compressed Instructions (128 bit)

| **Extension** | **Name**     | **Privilege** |
|:--------------|:-------------|:--------------|
| `rv_zcb`      | `c_lbu`      | `U`           |
| `rv_zcb`      | `c_lh`       | `U`           |
| `rv_zcb`      | `c_lhu`      | `U`           |
| `rv_zcb`      | `c_mul`      | `U`           |
| `rv_zcb`      | `c_not`      | `U`           |
| `rv_zcb`      | `c_sb`       | `U`           |
| `rv_zcb`      | `c_sext_b`   | `U`           |
| `rv_zcb`      | `c_sext_h`   | `U`           |
| `rv_zcb`      | `c_sh`       | `U`           |
| `rv_zcb`      | `c_zext_b`   | `U`           |
| `rv_zcb`      | `c_zext_h`   | `U`           |
| `rv_zcmop`    | `c_mop_N`    | `U`           |
| `rv_zcmp`     | `cm_mva01s`  | `U`           |
| `rv_zcmp`     | `cm_mvsa01`  | `U`           |
| `rv_zcmp`     | `cm_pop`     | `U`           |
| `rv_zcmp`     | `cm_popret`  | `U`           |
| `rv_zcmp`     | `cm_popretz` | `U`           |
| `rv_zcmp`     | `cm_push`    | `U`           |
| `rv_zcmt`     | `cm_jalt`    | `U`           |

:RVZC - Standard Extension for Compressed Instructions

| **Extension** | **Name**   | **Privilege** |
|:--------------|:-----------|:--------------|
| `rv64_zcb`    | `c_zext_w` | `U`           |

:RV64ZC - Standard Extension for Compressed Instructions (64 bit)
