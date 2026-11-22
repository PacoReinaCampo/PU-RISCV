## INSTRUCTION CLASSES

| **Extension** | **Name** | **Variable-Fields**            | **Class**        |
|:--------------|:---------|:-------------------------------|:-----------------|
| `rv_e`        | `add`    | `rd, rs1, rs2`                 | `alu`            |
| `rv_e`        | `addi`   | `rd, rs1, imm12`               | `alu`            |
| `rv_e`        | `and`    | `rd, rs1, rs2`                 | `alu`            |
| `rv_e`        | `andi`   | `rd, rs1, imm12`               | `alu`            |
| `rv_e`        | `auipc`  | `rd, imm20`                    | `alu`            |
| `rv_e`        | `beq`    | `bimm12hi, rs1, rs2, bimm12lo` | `branch`         |
| `rv_e`        | `bge`    | `bimm12hi, rs1, rs2, bimm12lo` | `branch`         |
| `rv_e`        | `bgeu`   | `bimm12hi, rs1, rs2, bimm12lo` | `branch`         |
| `rv_e`        | `blt`    | `bimm12hi, rs1, rs2, bimm12lo` | `branch`         |
| `rv_e`        | `bltu`   | `bimm12hi, rs1, rs2, bimm12lo` | `branch`         |
| `rv_e`        | `bne`    | `bimm12hi, rs1, rs2, bimm12lo` | `branch`         |
| `rv_e`        | `ebreak` | `none`                         | `system`         |
| `rv_e`        | `ecall`  | `none`                         | `system`         |
| `rv_e`        | `fence`  | `fm, pred, succ, rs1, rd`      | `fence`          |
| `rv_e`        | `jal`    | `rd, jimm20`                   | `jump`           |
| `rv_e`        | `jalr`   | `rd, rs1, imm12`               | `jump, indirect` |
| `rv_e`        | `lb`     | `rd, rs1, imm12`               | `load`           |
| `rv_e`        | `lbu`    | `rd, rs1, imm12`               | `load`           |
| `rv_e`        | `lh`     | `rd, rs1, imm12`               | `load`           |
| `rv_e`        | `lhu`    | `rd, rs1, imm12`               | `load`           |
| `rv_e`        | `lui`    | `rd, imm20`                    | `alu`            |
| `rv_e`        | `lw`     | `rd, rs1, imm12`               | `load`           |
| `rv_e`        | `or`     | `rd, rs1, rs2`                 | `alu`            |
| `rv_e`        | `ori`    | `rd, rs1, imm12`               | `alu`            |
| `rv_e`        | `sb`     | `imm12hi, rs1, rs2, imm12lo`   | `store`          |
| `rv_e`        | `sh`     | `imm12hi, rs1, rs2, imm12lo`   | `store`          |
| `rv_e`        | `sll`    | `rd, rs1, rs2`                 | `alu`            |
| `rv_e`        | `slt`    | `rd, rs1, rs2`                 | `alu`            |
| `rv_e`        | `slti`   | `rd, rs1, imm12`               | `alu`            |
| `rv_e`        | `sltiu`  | `rd, rs1, imm12`               | `alu`            |
| `rv_e`        | `sltu`   | `rd, rs1, rs2`                 | `alu`            |
| `rv_e`        | `sra`    | `rd, rs1, rs2`                 | `alu`            |
| `rv_e`        | `srl`    | `rd, rs1, rs2`                 | `alu`            |
| `rv_e`        | `sub`    | `rd, rs1, rs2`                 | `alu`            |
| `rv_e`        | `sw`     | `imm12hi, rs1, rs2, imm12lo`   | `store`          |
| `rv_e`        | `xor`    | `rd, rs1, rs2`                 | `alu`            |
| `rv_e`        | `xori`   | `rd, rs1, imm12`               | `alu`            |

:RVE - Base Embedded Instruction Set

| **Extension** | **Name** | **Variable-Fields**          | **Class** |
|:--------------|:---------|:-----------------------------|:----------|
| `rv64_e`      | `addiw`  | `rd, rs1, imm12`             | `alu`     |
| `rv64_e`      | `addw`   | `rd, rs1, rs2`               | `alu`     |
| `rv64_e`      | `ld`     | `rd, rs1, imm12`             | `load`    |
| `rv64_e`      | `lwu`    | `rd, rs1, imm12`             | `load`    |
| `rv64_e`      | `sd`     | `imm12hi, rs1, rs2, imm12lo` | `store`   |
| `rv64_e`      | `slli`   | `rd, rs1, shamtd`            | `alu`     |
| `rv64_e`      | `slliw`  | `rd, rs1, shamtw`            | `alu`     |
| `rv64_e`      | `sllw`   | `rd, rs1, rs2`               | `alu`     |
| `rv64_e`      | `srai`   | `rd, rs1, shamtd`            | `alu`     |
| `rv64_e`      | `sraiw`  | `rd, rs1, shamtw`            | `alu`     |
| `rv64_e`      | `sraw`   | `rd, rs1, rs2`               | `alu`     |
| `rv64_e`      | `srli`   | `rd, rs1, shamtd`            | `alu`     |
| `rv64_e`      | `srliw`  | `rd, rs1, shamtw`            | `alu`     |
| `rv64_e`      | `srlw`   | `rd, rs1, rs2`               | `alu`     |
| `rv64_e`      | `subw`   | `rd, rs1, rs2`               | `alu`     |

:RV64E - Base Embedded Instruction Set (64 bit)

| **Extension** | **Name** | **Variable-Fields**          | **Class** |
|:--------------|:---------|:-----------------------------|:----------|
| `rv128_e`     | `addid`  | `rd, rs1, imm12`             | `alu`     |
| `rv128_e`     | `addd`   | `rd, rs1, rs2`               | `alu`     |
| `rv128_e`     | `lq`     | `rd, rs1, imm12`             | `load`    |
| `rv128_e`     | `ldu`    | `rd, rs1, imm12`             | `load`    |
| `rv128_e`     | `sq`     | `imm12hi, rs1, rs2, imm12lo` | `store`   |
| `rv128_e`     | `slli`   | `rd, rs1, shamt7`            | `alu`     |
| `rv128_e`     | `sllid`  | `rd, rs1, shamt6`            | `alu`     |
| `rv128_e`     | `slld`   | `rd, rs1, rs2`               | `alu`     |
| `rv128_e`     | `srai`   | `rd, rs1, shamt7`            | `alu`     |
| `rv128_e`     | `sraid`  | `rd, rs1, shamt6`            | `alu`     |
| `rv128_e`     | `srad`   | `rd, rs1, rs2`               | `alu`     |
| `rv128_e`     | `srli`   | `rd, rs1, shamt7`            | `alu`     |
| `rv128_e`     | `srlid`  | `rd, rs1, shamt6`            | `alu`     |
| `rv128_e`     | `srld`   | `rd, rs1, rs2`               | `alu`     |
| `rv128_e`     | `subd`   | `rd, rs1, rs2`               | `alu`     |

:RV128E - Base Embedded Instruction Set (128 bit)

| **Extension** | **Name**      | **Variable-Fields**                                 | **Class**             |
|:--------------|:--------------|:----------------------------------------------------|:----------------------|
| `rv_zebi`     | `beqi`        | `imm12hi, imm5, rs1, imm12lo`                       | `branch`              |
| `rv_zebi`     | `bnei`        | `imm12hi, imm5, rs1, imm12lo`                       | `branch`              |
| `rv_zecbo`    | `cbo_clean`   | `rs1`                                               | `cache`               |
| `rv_zecbo`    | `cbo_flush`   | `rs1`                                               | `cache`               |
| `rv_zecbo`    | `cbo_inval`   | `rs1`                                               | `cache`               |
| `rv_zecbo`    | `cbo_zero`    | `rs1`                                               | `cache`               |
| `rv_zecfiss`  | `ssamoswap_d` | `rd, rs1, rs2, aq, rl`                              | `atomic, load, store` |
| `rv_zecfiss`  | `ssamoswap_w` | `rd, rs1, rs2, aq, rl`                              | `atomic, load, store` |
| `rv_zecond`   | `czero_eqz`   | `rd, rs1, rs2`                                      | `alu`                 |
| `rv_zecond`   | `czero_nez`   | `rd, rs1, rs2`                                      | `alu`                 |
| `rv_zecsr`    | `csrrc`       | `rd, rs1, csr`                                      | `system, csr`         |
| `rv_zecsr`    | `csrrci`      | `rd, csr, zimm5`                                    | `system, csr`         |
| `rv_zecsr`    | `csrrs`       | `rd, rs1, csr`                                      | `system, csr`         |
| `rv_zecsr`    | `csrrsi`      | `rd, csr, zimm5`                                    | `system, csr`         |
| `rv_zecsr`    | `csrrw`       | `rd, rs1, csr`                                      | `system, csr`         |
| `rv_zecsr`    | `csrrwi`      | `rd, csr, zimm5`                                    | `system, csr`         |
| `rv_zefencei` | `fence_i`     | `imm12, rs1, rd`                                    | `fence`               |
| `rv_zemop`    | `mop_r_N`     | `mop_r_t_30, mop_r_t_27_26, mop_r_t_21_20, rd, rs1` | `alu`                 |
| `rv_zemop`    | `mop_rr_N`    | `mop_rr_t_30, mop_rr_t_27_26, rd, rs1, rs2`         | `alu`                 |

:RVZE - Base Embedded Instruction Set
