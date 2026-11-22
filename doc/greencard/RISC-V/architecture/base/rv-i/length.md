## INSTRUCTION LENGTHS

| **Extension** | **Name** | **Length** |
|:--------------|:---------|:-----------|
| `rv_i`        | `add`    | `XLEN`     |
| `rv_i`        | `addi`   | `XLEN`     |
| `rv_i`        | `and`    | `XLEN`     |
| `rv_i`        | `andi`   | `XLEN`     |
| `rv_i`        | `auipc`  | `XLEN`     |
| `rv_i`        | `beq`    | `XLEN`     |
| `rv_i`        | `bge`    | `XLEN`     |
| `rv_i`        | `bgeu`   | `XLEN`     |
| `rv_i`        | `blt`    | `XLEN`     |
| `rv_i`        | `bltu`   | `XLEN`     |
| `rv_i`        | `bne`    | `XLEN`     |
| `rv_i`        | `ebreak` | `XLEN`     |
| `rv_i`        | `ecall`  | `XLEN`     |
| `rv_i`        | `fence`  | `XLEN`     |
| `rv_i`        | `jal`    | `XLEN`     |
| `rv_i`        | `jalr`   | `XLEN`     |
| `rv_i`        | `lb`     | `XLEN`     |
| `rv_i`        | `lbu`    | `XLEN`     |
| `rv_i`        | `lh`     | `XLEN`     |
| `rv_i`        | `lhu`    | `XLEN`     |
| `rv_i`        | `lui`    | `XLEN`     |
| `rv_i`        | `lw`     | `XLEN`     |
| `rv_i`        | `or`     | `XLEN`     |
| `rv_i`        | `ori`    | `XLEN`     |
| `rv_i`        | `sb`     | `XLEN`     |
| `rv_i`        | `sh`     | `XLEN`     |
| `rv_i`        | `sll`    | `XLEN`     |
| `rv_i`        | `slt`    | `XLEN`     |
| `rv_i`        | `slti`   | `XLEN`     |
| `rv_i`        | `sltiu`  | `XLEN`     |
| `rv_i`        | `sltu`   | `XLEN`     |
| `rv_i`        | `sra`    | `XLEN`     |
| `rv_i`        | `srl`    | `XLEN`     |
| `rv_i`        | `sub`    | `XLEN`     |
| `rv_i`        | `sw`     | `XLEN`     |
| `rv_i`        | `xor`    | `XLEN`     |
| `rv_i`        | `xori`   | `XLEN`     |

:RVI - Base Integer Instruction Set

| **Extension** | **Name** | **Length** |
|:--------------|:---------|:-----------|
| `rv64_i`      | `addiw`  | `XLEN`     |
| `rv64_i`      | `addw`   | `XLEN`     |
| `rv64_i`      | `ld`     | `XLEN`     |
| `rv64_i`      | `lwu`    | `XLEN`     |
| `rv64_i`      | `sd`     | `XLEN`     |
| `rv64_i`      | `slli`   | `XLEN`     |
| `rv64_i`      | `slliw`  | `XLEN`     |
| `rv64_i`      | `sllw`   | `XLEN`     |
| `rv64_i`      | `srai`   | `XLEN`     |
| `rv64_i`      | `sraiw`  | `XLEN`     |
| `rv64_i`      | `sraw`   | `XLEN`     |
| `rv64_i`      | `srli`   | `XLEN`     |
| `rv64_i`      | `srliw`  | `XLEN`     |
| `rv64_i`      | `srlw`   | `XLEN`     |
| `rv64_i`      | `subw`   | `XLEN`     |

:RV64I - Base Integer Instruction Set (64 bit)

| **Extension** | **Name** | **Length** |
|:--------------|:---------|:-----------|
| `rv128_i`     | `addid`  | `XLEN`     |
| `rv128_i`     | `addd`   | `XLEN`     |
| `rv128_i`     | `lq`     | `XLEN`     |
| `rv128_i`     | `ldu`    | `XLEN`     |
| `rv128_i`     | `sq`     | `XLEN`     |
| `rv128_i`     | `slli`   | `XLEN`     |
| `rv128_i`     | `sllid`  | `XLEN`     |
| `rv128_i`     | `slld`   | `XLEN`     |
| `rv128_i`     | `srai`   | `XLEN`     |
| `rv128_i`     | `sraid`  | `XLEN`     |
| `rv128_i`     | `srad`   | `XLEN`     |
| `rv128_i`     | `srli`   | `XLEN`     |
| `rv128_i`     | `srlid`  | `XLEN`     |
| `rv128_i`     | `srld`   | `XLEN`     |
| `rv128_i`     | `subd`   | `XLEN`     |

:RV128I - Base Integer Instruction Set (128 bit)

| **Extension** | **Name**      | **Length** |
|:--------------|:--------------|:-----------|
| `rv_zibi`     | `beqi`        | `XLEN`     |
| `rv_zibi`     | `bnei`        | `XLEN`     |
| `rv_zicbo`    | `cbo_clean`   | `XLEN`     |
| `rv_zicbo`    | `cbo_flush`   | `XLEN`     |
| `rv_zicbo`    | `cbo_inval`   | `XLEN`     |
| `rv_zicbo`    | `cbo_zero`    | `XLEN`     |
| `rv_zicfiss`  | `ssamoswap_d` | `XLEN`     |
| `rv_zicfiss`  | `ssamoswap_w` | `XLEN`     |
| `rv_zicond`   | `czero_eqz`   | `XLEN`     |
| `rv_zicond`   | `czero_nez`   | `XLEN`     |
| `rv_zicsr`    | `csrrc`       | `XLEN`     |
| `rv_zicsr`    | `csrrci`      | `XLEN`     |
| `rv_zicsr`    | `csrrs`       | `XLEN`     |
| `rv_zicsr`    | `csrrsi`      | `XLEN`     |
| `rv_zicsr`    | `csrrw`       | `XLEN`     |
| `rv_zicsr`    | `csrrwi`      | `XLEN`     |
| `rv_zifencei` | `fence_i`     | `XLEN`     |
| `rv_zilx`     | `lxh`         | `XLEN`     |
| `rv_zilx`     | `lxhu`        | `XLEN`     |
| `rv_zilx`     | `lxsb`        | `XLEN`     |
| `rv_zilx`     | `lxsbu`       | `XLEN`     |
| `rv_zilx`     | `lxsh`        | `XLEN`     |
| `rv_zilx`     | `lxshu`       | `XLEN`     |
| `rv_zilx`     | `lxsw`        | `XLEN`     |
| `rv_zilx`     | `lxw`         | `XLEN`     |
| `rv_zimop`    | `mop_r_N`     | `XLEN`     |
| `rv_zimop`    | `mop_rr_N`    | `XLEN`     |

:RVZI - Base Integer Instruction Set

| **Extension** | **Name**  | **Length** |
|:--------------|:----------|:-----------|
| `rv64_zilx`   | `lxd`     | `XLEN`     |
| `rv64_zilx`   | `lxsd`    | `XLEN`     |
| `rv64_zilx`   | `lxsuwb`  | `XLEN`     |
| `rv64_zilx`   | `lxsuwbu` | `XLEN`     |
| `rv64_zilx`   | `lxsuwd`  | `XLEN`     |
| `rv64_zilx`   | `lxsuwh`  | `XLEN`     |
| `rv64_zilx`   | `lxsuwhu` | `XLEN`     |
| `rv64_zilx`   | `lxsuww`  | `XLEN`     |
| `rv64_zilx`   | `lxsuwwu` | `XLEN`     |
| `rv64_zilx`   | `lxswu`   | `XLEN`     |
| `rv64_zilx`   | `lxwu`    | `XLEN`     |

:RV64ZI - Base Integer Instruction Set (64 bit)
