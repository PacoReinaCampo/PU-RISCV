## INSTRUCTION CLASSES

| **Extension** | **Name** | **Variable-Fields**            | **Class**        |
|:--------------|:---------|:-------------------------------|:-----------------|
| `rv_i`        | `add`    | `rd, rs1, rs2`                 | `alu`            |
| `rv_i`        | `addi`   | `rd, rs1, imm12`               | `alu`            |
| `rv_i`        | `and`    | `rd, rs1, rs2`                 | `alu`            |
| `rv_i`        | `andi`   | `rd, rs1, imm12`               | `alu`            |
| `rv_i`        | `auipc`  | `rd, imm20`                    | `alu`            |
| `rv_i`        | `beq`    | `bimm12hi, rs1, rs2, bimm12lo` | `branch`         |
| `rv_i`        | `bge`    | `bimm12hi, rs1, rs2, bimm12lo` | `branch`         |
| `rv_i`        | `bgeu`   | `bimm12hi, rs1, rs2, bimm12lo` | `branch`         |
| `rv_i`        | `blt`    | `bimm12hi, rs1, rs2, bimm12lo` | `branch`         |
| `rv_i`        | `bltu`   | `bimm12hi, rs1, rs2, bimm12lo` | `branch`         |
| `rv_i`        | `bne`    | `bimm12hi, rs1, rs2, bimm12lo` | `branch`         |
| `rv_i`        | `ebreak` | `none`                         | `system`         |
| `rv_i`        | `ecall`  | `none`                         | `system`         |
| `rv_i`        | `fence`  | `fm, pred, succ, rs1, rd`      | `fence`          |
| `rv_i`        | `jal`    | `rd, jimm20`                   | `jump`           |
| `rv_i`        | `jalr`   | `rd, rs1, imm12`               | `jump, indirect` |
| `rv_i`        | `lb`     | `rd, rs1, imm12`               | `load`           |
| `rv_i`        | `lbu`    | `rd, rs1, imm12`               | `load`           |
| `rv_i`        | `lh`     | `rd, rs1, imm12`               | `load`           |
| `rv_i`        | `lhu`    | `rd, rs1, imm12`               | `load`           |
| `rv_i`        | `lui`    | `rd, imm20`                    | `alu`            |
| `rv_i`        | `lw`     | `rd, rs1, imm12`               | `load`           |
| `rv_i`        | `or`     | `rd, rs1, rs2`                 | `alu`            |
| `rv_i`        | `ori`    | `rd, rs1, imm12`               | `alu`            |
| `rv_i`        | `sb`     | `imm12hi, rs1, rs2, imm12lo`   | `store`          |
| `rv_i`        | `sh`     | `imm12hi, rs1, rs2, imm12lo`   | `store`          |
| `rv_i`        | `sll`    | `rd, rs1, rs2`                 | `alu`            |
| `rv_i`        | `slt`    | `rd, rs1, rs2`                 | `alu`            |
| `rv_i`        | `slti`   | `rd, rs1, imm12`               | `alu`            |
| `rv_i`        | `sltiu`  | `rd, rs1, imm12`               | `alu`            |
| `rv_i`        | `sltu`   | `rd, rs1, rs2`                 | `alu`            |
| `rv_i`        | `sra`    | `rd, rs1, rs2`                 | `alu`            |
| `rv_i`        | `srl`    | `rd, rs1, rs2`                 | `alu`            |
| `rv_i`        | `sub`    | `rd, rs1, rs2`                 | `alu`            |
| `rv_i`        | `sw`     | `imm12hi, rs1, rs2, imm12lo`   | `store`          |
| `rv_i`        | `xor`    | `rd, rs1, rs2`                 | `alu`            |
| `rv_i`        | `xori`   | `rd, rs1, imm12`               | `alu`            |

:RVI - Base Integer Instruction Set

| **Extension** | **Name** | **Variable-Fields**          | **Class** |
|:--------------|:---------|:-----------------------------|:----------|
| `rv64_i`      | `addiw`  | `rd, rs1, imm12`             | `alu`     |
| `rv64_i`      | `addw`   | `rd, rs1, rs2`               | `alu`     |
| `rv64_i`      | `ld`     | `rd, rs1, imm12`             | `load`    |
| `rv64_i`      | `lwu`    | `rd, rs1, imm12`             | `load`    |
| `rv64_i`      | `sd`     | `imm12hi, rs1, rs2, imm12lo` | `store`   |
| `rv64_i`      | `slli`   | `rd, rs1, shamtd`            | `alu`     |
| `rv64_i`      | `slliw`  | `rd, rs1, shamtw`            | `alu`     |
| `rv64_i`      | `sllw`   | `rd, rs1, rs2`               | `alu`     |
| `rv64_i`      | `srai`   | `rd, rs1, shamtd`            | `alu`     |
| `rv64_i`      | `sraiw`  | `rd, rs1, shamtw`            | `alu`     |
| `rv64_i`      | `sraw`   | `rd, rs1, rs2`               | `alu`     |
| `rv64_i`      | `srli`   | `rd, rs1, shamtd`            | `alu`     |
| `rv64_i`      | `srliw`  | `rd, rs1, shamtw`            | `alu`     |
| `rv64_i`      | `srlw`   | `rd, rs1, rs2`               | `alu`     |
| `rv64_i`      | `subw`   | `rd, rs1, rs2`               | `alu`     |

:RV64I - Base Integer Instruction Set (64 bit)

| **Extension** | **Name** | **Variable-Fields**          | **Class** |
|:--------------|:---------|:-----------------------------|:----------|
| `rv128_i`     | `addid`  | `rd, rs1, imm12`             | `alu`     |
| `rv128_i`     | `addd`   | `rd, rs1, rs2`               | `alu`     |
| `rv128_i`     | `lq`     | `rd, rs1, imm12`             | `load`    |
| `rv128_i`     | `ldu`    | `rd, rs1, imm12`             | `load`    |
| `rv128_i`     | `sq`     | `imm12hi, rs1, rs2, imm12lo` | `store`   |
| `rv128_i`     | `slli`   | `rd, rs1, shamt7`            | `alu`     |
| `rv128_i`     | `sllid`  | `rd, rs1, shamt6`            | `alu`     |
| `rv128_i`     | `slld`   | `rd, rs1, rs2`               | `alu`     |
| `rv128_i`     | `srai`   | `rd, rs1, shamt7`            | `alu`     |
| `rv128_i`     | `sraid`  | `rd, rs1, shamt6`            | `alu`     |
| `rv128_i`     | `srad`   | `rd, rs1, rs2`               | `alu`     |
| `rv128_i`     | `srli`   | `rd, rs1, shamt7`            | `alu`     |
| `rv128_i`     | `srlid`  | `rd, rs1, shamt6`            | `alu`     |
| `rv128_i`     | `srld`   | `rd, rs1, rs2`               | `alu`     |
| `rv128_i`     | `subd`   | `rd, rs1, rs2`               | `alu`     |

:RV128I - Base Integer Instruction Set (128 bit)

| **Extension** | **Name**      | **Variable-Fields**                                 | **Class**               |
|:--------------|:--------------|:----------------------------------------------------|:------------------------|
| `rv_zibi`     | `beqi`        | `imm12hi, imm5, rs1, imm12lo`                       | `branch`                |
| `rv_zibi`     | `bnei`        | `imm12hi, imm5, rs1, imm12lo`                       | `branch`                |
| `rv_zicbo`    | `cbo_clean`   | `rs1`                                               | `cache`                 |
| `rv_zicbo`    | `cbo_flush`   | `rs1`                                               | `cache`                 |
| `rv_zicbo`    | `cbo_inval`   | `rs1`                                               | `cache`                 |
| `rv_zicbo`    | `cbo_zero`    | `rs1`                                               | `cache`                 |
| `rv_zicfiss`  | `ssamoswap_d` | `rd, rs1, rs2, aq, rl`                              | `atomic, load, store`   |
| `rv_zicfiss`  | `ssamoswap_w` | `rd, rs1, rs2, aq, rl`                              | `atomic, load, store`   |
| `rv_zicond`   | `czero_eqz`   | `rd, rs1, rs2`                                      | `alu`                   |
| `rv_zicond`   | `czero_nez`   | `rd, rs1, rs2`                                      | `alu`                   |
| `rv_zicsr`    | `csrrc`       | `rd, rs1, csr`                                      | `system, csr`           |
| `rv_zicsr`    | `csrrci`      | `rd, csr, zimm5`                                    | `system, csr`           |
| `rv_zicsr`    | `csrrs`       | `rd, rs1, csr`                                      | `system, csr`           |
| `rv_zicsr`    | `csrrsi`      | `rd, csr, zimm5`                                    | `system, csr`           |
| `rv_zicsr`    | `csrrw`       | `rd, rs1, csr`                                      | `system, csr`           |
| `rv_zicsr`    | `csrrwi`      | `rd, csr, zimm5`                                    | `system, csr`           |
| `rv_zifencei` | `fence_i`     | `imm12, rs1, rd`                                    | `fence`                 |
| `rv_zilx`     | `lxh`         | `rd, rs1, rs2`                                      | `memory, load, indexed` |
| `rv_zilx`     | `lxhu`        | `rd, rs1, rs2`                                      | `memory, load, indexed` |
| `rv_zilx`     | `lxsb`        | `rd, rs1, rs2`                                      | `memory, load, indexed` |
| `rv_zilx`     | `lxsbu`       | `rd, rs1, rs2`                                      | `memory, load, indexed` |
| `rv_zilx`     | `lxsh`        | `rd, rs1, rs2`                                      | `memory, load, indexed` |
| `rv_zilx`     | `lxshu`       | `rd, rs1, rs2`                                      | `memory, load, indexed` |
| `rv_zilx`     | `lxsw`        | `rd, rs1, rs2`                                      | `memory, load, indexed` |
| `rv_zilx`     | `lxw`         | `rd, rs1, rs2`                                      | `memory, load, indexed` |
| `rv_zimop`    | `mop_r_N`     | `mop_r_t_30, mop_r_t_27_26, mop_r_t_21_20, rd, rs1` | `alu`                   |
| `rv_zimop`    | `mop_rr_N`    | `mop_rr_t_30, mop_rr_t_27_26, rd, rs1, rs2`         | `alu`                   |

:RVZI - Base Integer Instruction Set

| **Extension** | **Name**  | **Variable-Fields** | **Class**               |
|:--------------|:----------|:--------------------|:------------------------|
| `rv64_zilx`   | `lxd`     | `rd, rs1, rs2`      | `memory, load, indexed` |
| `rv64_zilx`   | `lxsd`    | `rd, rs1, rs2`      | `memory, load, indexed` |
| `rv64_zilx`   | `lxsuwb`  | `rd, rs1, rs2`      | `memory, load, indexed` |
| `rv64_zilx`   | `lxsuwbu` | `rd, rs1, rs2`      | `memory, load, indexed` |
| `rv64_zilx`   | `lxsuwd`  | `rd, rs1, rs2`      | `memory, load, indexed` |
| `rv64_zilx`   | `lxsuwh`  | `rd, rs1, rs2`      | `memory, load, indexed` |
| `rv64_zilx`   | `lxsuwhu` | `rd, rs1, rs2`      | `memory, load, indexed` |
| `rv64_zilx`   | `lxsuww`  | `rd, rs1, rs2`      | `memory, load, indexed` |
| `rv64_zilx`   | `lxsuwwu` | `rd, rs1, rs2`      | `memory, load, indexed` |
| `rv64_zilx`   | `lxswu`   | `rd, rs1, rs2`      | `memory, load, indexed` |
| `rv64_zilx`   | `lxwu`    | `rd, rs1, rs2`      | `memory, load, indexed` |

:RV64ZI - Base Integer Instruction Set (64 bit)
