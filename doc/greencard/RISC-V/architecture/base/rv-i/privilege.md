## INSTRUCTION PRIVILEGE

| **Extension** | **Name** | **Privilege** |
|:--------------|:---------|:--------------|
| `rv_i`        | `add`    | `U`           |
| `rv_i`        | `addi`   | `U`           |
| `rv_i`        | `and`    | `U`           |
| `rv_i`        | `andi`   | `U`           |
| `rv_i`        | `auipc`  | `U`           |
| `rv_i`        | `beq`    | `U`           |
| `rv_i`        | `bge`    | `U`           |
| `rv_i`        | `bgeu`   | `U`           |
| `rv_i`        | `blt`    | `U`           |
| `rv_i`        | `bltu`   | `U`           |
| `rv_i`        | `bne`    | `U`           |
| `rv_i`        | `ebreak` | `U`           |
| `rv_i`        | `ecall`  | `U`           |
| `rv_i`        | `fence`  | `U`           |
| `rv_i`        | `jal`    | `U`           |
| `rv_i`        | `jalr`   | `U`           |
| `rv_i`        | `lb`     | `U`           |
| `rv_i`        | `lbu`    | `U`           |
| `rv_i`        | `lh`     | `U`           |
| `rv_i`        | `lhu`    | `U`           |
| `rv_i`        | `lui`    | `U`           |
| `rv_i`        | `lw`     | `U`           |
| `rv_i`        | `or`     | `U`           |
| `rv_i`        | `ori`    | `U`           |
| `rv_i`        | `sb`     | `U`           |
| `rv_i`        | `sh`     | `U`           |
| `rv_i`        | `sll`    | `U`           |
| `rv_i`        | `slt`    | `U`           |
| `rv_i`        | `slti`   | `U`           |
| `rv_i`        | `sltiu`  | `U`           |
| `rv_i`        | `sltu`   | `U`           |
| `rv_i`        | `sra`    | `U`           |
| `rv_i`        | `srl`    | `U`           |
| `rv_i`        | `sub`    | `U`           |
| `rv_i`        | `sw`     | `U`           |
| `rv_i`        | `xor`    | `U`           |
| `rv_i`        | `xori`   | `U`           |

:RVI - Base Integer Instruction Set

| **Extension** | **Name** | **Privilege** |
|:--------------|:---------|:--------------|
| `rv64_i`      | `addiw`  | `U`           |
| `rv64_i`      | `addw`   | `U`           |
| `rv64_i`      | `ld`     | `U`           |
| `rv64_i`      | `lwu`    | `U`           |
| `rv64_i`      | `sd`     | `U`           |
| `rv64_i`      | `slli`   | `U`           |
| `rv64_i`      | `slliw`  | `U`           |
| `rv64_i`      | `sllw`   | `U`           |
| `rv64_i`      | `srai`   | `U`           |
| `rv64_i`      | `sraiw`  | `U`           |
| `rv64_i`      | `sraw`   | `U`           |
| `rv64_i`      | `srli`   | `U`           |
| `rv64_i`      | `srliw`  | `U`           |
| `rv64_i`      | `srlw`   | `U`           |
| `rv64_i`      | `subw`   | `U`           |

:RV64I - Base Integer Instruction Set (64 bit)

| **Extension** | **Name** | **Privilege** |
|:--------------|:---------|:--------------|
| `rv128_i`     | `addid`  | `U`           |
| `rv128_i`     | `addd`   | `U`           |
| `rv128_i`     | `lq`     | `U`           |
| `rv128_i`     | `ldu`    | `U`           |
| `rv128_i`     | `sq`     | `U`           |
| `rv128_i`     | `slli`   | `U`           |
| `rv128_i`     | `sllid`  | `U`           |
| `rv128_i`     | `slld`   | `U`           |
| `rv128_i`     | `srai`   | `U`           |
| `rv128_i`     | `sraid`  | `U`           |
| `rv128_i`     | `srad`   | `U`           |
| `rv128_i`     | `srli`   | `U`           |
| `rv128_i`     | `srlid`  | `U`           |
| `rv128_i`     | `srld`   | `U`           |
| `rv128_i`     | `subd`   | `U`           |

:RV128I - Base Integer Instruction Set (128 bit)

| **Extension** | **Name**      | **Privilege** |
|:--------------|:--------------|:--------------|
| `rv_zibi`     | `beqi`        | `U`           |
| `rv_zibi`     | `bnei`        | `U`           |
| `rv_zicbo`    | `cbo_clean`   | `U`           |
| `rv_zicbo`    | `cbo_flush`   | `U`           |
| `rv_zicbo`    | `cbo_inval`   | `U`           |
| `rv_zicbo`    | `cbo_zero`    | `U`           |
| `rv_zicfiss`  | `ssamoswap_d` | `U`           |
| `rv_zicfiss`  | `ssamoswap_w` | `U`           |
| `rv_zicond`   | `czero_eqz`   | `U`           |
| `rv_zicond`   | `czero_nez`   | `U`           |
| `rv_zicsr`    | `csrrc`       | `U`           |
| `rv_zicsr`    | `csrrci`      | `U`           |
| `rv_zicsr`    | `csrrs`       | `U`           |
| `rv_zicsr`    | `csrrsi`      | `U`           |
| `rv_zicsr`    | `csrrw`       | `U`           |
| `rv_zicsr`    | `csrrwi`      | `U`           |
| `rv_zifencei` | `fence_i`     | `U`           |
| `rv_zilx`     | `lxh`         | `U`           |
| `rv_zilx`     | `lxhu`        | `U`           |
| `rv_zilx`     | `lxsb`        | `U`           |
| `rv_zilx`     | `lxsbu`       | `U`           |
| `rv_zilx`     | `lxsh`        | `U`           |
| `rv_zilx`     | `lxshu`       | `U`           |
| `rv_zilx`     | `lxsw`        | `U`           |
| `rv_zilx`     | `lxw`         | `U`           |
| `rv_zimop`    | `mop_r_N`     | `U`           |
| `rv_zimop`    | `mop_rr_N`    | `U`           |

:RVZI - Base Integer Instruction Set

| **Extension** | **Name**  | **Privilege** |
|:--------------|:----------|:--------------|
| `rv64_zilx`   | `lxd`     | `U`           |
| `rv64_zilx`   | `lxsd`    | `U`           |
| `rv64_zilx`   | `lxsuwb`  | `U`           |
| `rv64_zilx`   | `lxsuwbu` | `U`           |
| `rv64_zilx`   | `lxsuwd`  | `U`           |
| `rv64_zilx`   | `lxsuwh`  | `U`           |
| `rv64_zilx`   | `lxsuwhu` | `U`           |
| `rv64_zilx`   | `lxsuww`  | `U`           |
| `rv64_zilx`   | `lxsuwwu` | `U`           |
| `rv64_zilx`   | `lxswu`   | `U`           |
| `rv64_zilx`   | `lxwu`    | `U`           |

:RV64ZI - Base Integer Instruction Set (64 bit)
