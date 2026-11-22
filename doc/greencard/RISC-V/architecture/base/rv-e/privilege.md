## INSTRUCTION PRIVILEGE

| **Extension** | **Name** | **Privilege** |
|:--------------|:---------|:--------------|
| `rv_e`        | `add`    | `U`           |
| `rv_e`        | `addi`   | `U`           |
| `rv_e`        | `and`    | `U`           |
| `rv_e`        | `andi`   | `U`           |
| `rv_e`        | `auipc`  | `U`           |
| `rv_e`        | `beq`    | `U`           |
| `rv_e`        | `bge`    | `U`           |
| `rv_e`        | `bgeu`   | `U`           |
| `rv_e`        | `blt`    | `U`           |
| `rv_e`        | `bltu`   | `U`           |
| `rv_e`        | `bne`    | `U`           |
| `rv_e`        | `ebreak` | `U`           |
| `rv_e`        | `ecall`  | `U`           |
| `rv_e`        | `fence`  | `U`           |
| `rv_e`        | `jal`    | `U`           |
| `rv_e`        | `jalr`   | `U`           |
| `rv_e`        | `lb`     | `U`           |
| `rv_e`        | `lbu`    | `U`           |
| `rv_e`        | `lh`     | `U`           |
| `rv_e`        | `lhu`    | `U`           |
| `rv_e`        | `lui`    | `U`           |
| `rv_e`        | `lw`     | `U`           |
| `rv_e`        | `or`     | `U`           |
| `rv_e`        | `ori`    | `U`           |
| `rv_e`        | `sb`     | `U`           |
| `rv_e`        | `sh`     | `U`           |
| `rv_e`        | `sll`    | `U`           |
| `rv_e`        | `slt`    | `U`           |
| `rv_e`        | `slti`   | `U`           |
| `rv_e`        | `sltiu`  | `U`           |
| `rv_e`        | `sltu`   | `U`           |
| `rv_e`        | `sra`    | `U`           |
| `rv_e`        | `srl`    | `U`           |
| `rv_e`        | `sub`    | `U`           |
| `rv_e`        | `sw`     | `U`           |
| `rv_e`        | `xor`    | `U`           |
| `rv_e`        | `xori`   | `U`           |

:RVE - Base Embedded Instruction Set

| **Extension** | **Name** | **Privilege** |
|:--------------|:---------|:--------------|
| `rv64_e`      | `addiw`  | `U`           |
| `rv64_e`      | `addw`   | `U`           |
| `rv64_e`      | `ld`     | `U`           |
| `rv64_e`      | `lwu`    | `U`           |
| `rv64_e`      | `sd`     | `U`           |
| `rv64_e`      | `slli`   | `U`           |
| `rv64_e`      | `slliw`  | `U`           |
| `rv64_e`      | `sllw`   | `U`           |
| `rv64_e`      | `srai`   | `U`           |
| `rv64_e`      | `sraiw`  | `U`           |
| `rv64_e`      | `sraw`   | `U`           |
| `rv64_e`      | `srli`   | `U`           |
| `rv64_e`      | `srliw`  | `U`           |
| `rv64_e`      | `srlw`   | `U`           |
| `rv64_e`      | `subw`   | `U`           |

:RV64E - Base Embedded Instruction Set (64 bit)

| **Extension** | **Name** | **Privilege** |
|:--------------|:---------|:--------------|
| `rv128_e`     | `addid`  | `U`           |
| `rv128_e`     | `addd`   | `U`           |
| `rv128_e`     | `lq`     | `U`           |
| `rv128_e`     | `ldu`    | `U`           |
| `rv128_e`     | `sq`     | `U`           |
| `rv128_e`     | `slli`   | `U`           |
| `rv128_e`     | `sllid`  | `U`           |
| `rv128_e`     | `slld`   | `U`           |
| `rv128_e`     | `srai`   | `U`           |
| `rv128_e`     | `sraid`  | `U`           |
| `rv128_e`     | `srad`   | `U`           |
| `rv128_e`     | `srli`   | `U`           |
| `rv128_e`     | `srlid`  | `U`           |
| `rv128_e`     | `srld`   | `U`           |
| `rv128_e`     | `subd`   | `U`           |

:RV128E - Base Embedded Instruction Set (128 bit)

| **Extension** | **Name**      | **Privilege** |
|:--------------|:--------------|:--------------|
| `rv_zebi`     | `beqi`        | `U`           |
| `rv_zebi`     | `bnei`        | `U`           |
| `rv_zecbo`    | `cbo_clean`   | `U`           |
| `rv_zecbo`    | `cbo_flush`   | `U`           |
| `rv_zecbo`    | `cbo_inval`   | `U`           |
| `rv_zecbo`    | `cbo_zero`    | `U`           |
| `rv_zecfiss`  | `ssamoswap_d` | `U`           |
| `rv_zecfiss`  | `ssamoswap_w` | `U`           |
| `rv_zecond`   | `czero_eqz`   | `U`           |
| `rv_zecond`   | `czero_nez`   | `U`           |
| `rv_zecsr`    | `csrrc`       | `U`           |
| `rv_zecsr`    | `csrrci`      | `U`           |
| `rv_zecsr`    | `csrrs`       | `U`           |
| `rv_zecsr`    | `csrrsi`      | `U`           |
| `rv_zecsr`    | `csrrw`       | `U`           |
| `rv_zecsr`    | `csrrwi`      | `U`           |
| `rv_zefencei` | `fence_i`     | `U`           |
| `rv_zemop`    | `mop_r_N`     | `U`           |
| `rv_zemop`    | `mop_rr_N`    | `U`           |

:RVZE - Base Embedded Instruction Set
