## INSTRUCTION LENGTHS

| **Extension** | **Name** | **Length** |
|:--------------|:---------|:-----------|
| `rv_e`        | `add`    | `XLEN`     |
| `rv_e`        | `addi`   | `XLEN`     |
| `rv_e`        | `and`    | `XLEN`     |
| `rv_e`        | `andi`   | `XLEN`     |
| `rv_e`        | `auipc`  | `XLEN`     |
| `rv_e`        | `beq`    | `XLEN`     |
| `rv_e`        | `bge`    | `XLEN`     |
| `rv_e`        | `bgeu`   | `XLEN`     |
| `rv_e`        | `blt`    | `XLEN`     |
| `rv_e`        | `bltu`   | `XLEN`     |
| `rv_e`        | `bne`    | `XLEN`     |
| `rv_e`        | `ebreak` | `XLEN`     |
| `rv_e`        | `ecall`  | `XLEN`     |
| `rv_e`        | `fence`  | `XLEN`     |
| `rv_e`        | `jal`    | `XLEN`     |
| `rv_e`        | `jalr`   | `XLEN`     |
| `rv_e`        | `lb`     | `XLEN`     |
| `rv_e`        | `lbu`    | `XLEN`     |
| `rv_e`        | `lh`     | `XLEN`     |
| `rv_e`        | `lhu`    | `XLEN`     |
| `rv_e`        | `lui`    | `XLEN`     |
| `rv_e`        | `lw`     | `XLEN`     |
| `rv_e`        | `or`     | `XLEN`     |
| `rv_e`        | `ori`    | `XLEN`     |
| `rv_e`        | `sb`     | `XLEN`     |
| `rv_e`        | `sh`     | `XLEN`     |
| `rv_e`        | `sll`    | `XLEN`     |
| `rv_e`        | `slt`    | `XLEN`     |
| `rv_e`        | `slti`   | `XLEN`     |
| `rv_e`        | `sltiu`  | `XLEN`     |
| `rv_e`        | `sltu`   | `XLEN`     |
| `rv_e`        | `sra`    | `XLEN`     |
| `rv_e`        | `srl`    | `XLEN`     |
| `rv_e`        | `sub`    | `XLEN`     |
| `rv_e`        | `sw`     | `XLEN`     |
| `rv_e`        | `xor`    | `XLEN`     |
| `rv_e`        | `xori`   | `XLEN`     |

:RVE - Base Embedded Instruction Set

| **Extension** | **Name** | **Length** |
|:--------------|:---------|:-----------|
| `rv64_e`      | `addiw`  | `XLEN`     |
| `rv64_e`      | `addw`   | `XLEN`     |
| `rv64_e`      | `ld`     | `XLEN`     |
| `rv64_e`      | `lwu`    | `XLEN`     |
| `rv64_e`      | `sd`     | `XLEN`     |
| `rv64_e`      | `slli`   | `XLEN`     |
| `rv64_e`      | `slliw`  | `XLEN`     |
| `rv64_e`      | `sllw`   | `XLEN`     |
| `rv64_e`      | `srai`   | `XLEN`     |
| `rv64_e`      | `sraiw`  | `XLEN`     |
| `rv64_e`      | `sraw`   | `XLEN`     |
| `rv64_e`      | `srli`   | `XLEN`     |
| `rv64_e`      | `srliw`  | `XLEN`     |
| `rv64_e`      | `srlw`   | `XLEN`     |
| `rv64_e`      | `subw`   | `XLEN`     |

:RV64E - Base Embedded Instruction Set (64 bit)

| **Extension** | **Name** | **Length** |
|:--------------|:---------|:-----------|
| `rv128_e`     | `addid`  | `XLEN`     |
| `rv128_e`     | `addd`   | `XLEN`     |
| `rv128_e`     | `lq`     | `XLEN`     |
| `rv128_e`     | `ldu`    | `XLEN`     |
| `rv128_e`     | `sq`     | `XLEN`     |
| `rv128_e`     | `slli`   | `XLEN`     |
| `rv128_e`     | `sllid`  | `XLEN`     |
| `rv128_e`     | `slld`   | `XLEN`     |
| `rv128_e`     | `srai`   | `XLEN`     |
| `rv128_e`     | `sraid`  | `XLEN`     |
| `rv128_e`     | `srad`   | `XLEN`     |
| `rv128_e`     | `srli`   | `XLEN`     |
| `rv128_e`     | `srlid`  | `XLEN`     |
| `rv128_e`     | `srld`   | `XLEN`     |
| `rv128_e`     | `subd`   | `XLEN`     |

:RV128E - Base Embedded Instruction Set (128 bit)

| **Extension** | **Name**      | **Length** |
|:--------------|:--------------|:-----------|
| `rv_zebi`     | `beqi`        | `XLEN`     |
| `rv_zebi`     | `bnei`        | `XLEN`     |
| `rv_zecbo`    | `cbo_clean`   | `XLEN`     |
| `rv_zecbo`    | `cbo_flush`   | `XLEN`     |
| `rv_zecbo`    | `cbo_inval`   | `XLEN`     |
| `rv_zecbo`    | `cbo_zero`    | `XLEN`     |
| `rv_zecfiss`  | `ssamoswap_d` | `XLEN`     |
| `rv_zecfiss`  | `ssamoswap_w` | `XLEN`     |
| `rv_zecond`   | `czero_eqz`   | `XLEN`     |
| `rv_zecond`   | `czero_nez`   | `XLEN`     |
| `rv_zecsr`    | `csrrc`       | `XLEN`     |
| `rv_zecsr`    | `csrrci`      | `XLEN`     |
| `rv_zecsr`    | `csrrs`       | `XLEN`     |
| `rv_zecsr`    | `csrrsi`      | `XLEN`     |
| `rv_zecsr`    | `csrrw`       | `XLEN`     |
| `rv_zecsr`    | `csrrwi`      | `XLEN`     |
| `rv_zefencei` | `fence_i`     | `XLEN`     |
| `rv_zemop`    | `mop_r_N`     | `XLEN`     |
| `rv_zemop`    | `mop_rr_N`    | `XLEN`     |

:RVZE - Base Embedded Instruction Set
