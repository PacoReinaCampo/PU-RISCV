## INSTRUCTION CLASSES

| **Extension** | **Name** | **Variable-Fields**            | **Class**        |
|:--------------|:---------|:-------------------------------|:-----------------|
| `rv_o`        | `add`    | `rd, rs1, rs2`                 | `alu`            |
| `rv_o`        | `addi`   | `rd, rs1, imm12`               | `alu`            |
| `rv_o`        | `and`    | `rd, rs1, rs2`                 | `alu`            |
| `rv_o`        | `andi`   | `rd, rs1, imm12`               | `alu`            |
| `rv_o`        | `auipc`  | `rd, imm20`                    | `alu`            |
| `rv_o`        | `beq`    | `bimm12hi, rs1, rs2, bimm12lo` | `branch`         |
| `rv_o`        | `bge`    | `bimm12hi, rs1, rs2, bimm12lo` | `branch`         |
| `rv_o`        | `bgeu`   | `bimm12hi, rs1, rs2, bimm12lo` | `branch`         |
| `rv_o`        | `blt`    | `bimm12hi, rs1, rs2, bimm12lo` | `branch`         |
| `rv_o`        | `bltu`   | `bimm12hi, rs1, rs2, bimm12lo` | `branch`         |
| `rv_o`        | `bne`    | `bimm12hi, rs1, rs2, bimm12lo` | `branch`         |
| `rv_o`        | `ebreak` | `none`                         | `system`         |
| `rv_o`        | `ecall`  | `none`                         | `system`         |
| `rv_o`        | `fence`  | `fm, pred, succ, rs1, rd`      | `fence`          |
| `rv_o`        | `jal`    | `rd, jimm20`                   | `jump`           |
| `rv_o`        | `jalr`   | `rd, rs1, imm12`               | `jump, indirect` |
| `rv_o`        | `lb`     | `rd, rs1, imm12`               | `load`           |
| `rv_o`        | `lbu`    | `rd, rs1, imm12`               | `load`           |
| `rv_o`        | `lh`     | `rd, rs1, imm12`               | `load`           |
| `rv_o`        | `lhu`    | `rd, rs1, imm12`               | `load`           |
| `rv_o`        | `lui`    | `rd, imm20`                    | `alu`            |
| `rv_o`        | `lw`     | `rd, rs1, imm12`               | `load`           |
| `rv_o`        | `or`     | `rd, rs1, rs2`                 | `alu`            |
| `rv_o`        | `ori`    | `rd, rs1, imm12`               | `alu`            |
| `rv_o`        | `sb`     | `imm12hi, rs1, rs2, imm12lo`   | `store`          |
| `rv_o`        | `sh`     | `imm12hi, rs1, rs2, imm12lo`   | `store`          |
| `rv_o`        | `sll`    | `rd, rs1, rs2`                 | `alu`            |
| `rv_o`        | `slt`    | `rd, rs1, rs2`                 | `alu`            |
| `rv_o`        | `slti`   | `rd, rs1, imm12`               | `alu`            |
| `rv_o`        | `sltiu`  | `rd, rs1, imm12`               | `alu`            |
| `rv_o`        | `sltu`   | `rd, rs1, rs2`                 | `alu`            |
| `rv_o`        | `sra`    | `rd, rs1, rs2`                 | `alu`            |
| `rv_o`        | `srl`    | `rd, rs1, rs2`                 | `alu`            |
| `rv_o`        | `sub`    | `rd, rs1, rs2`                 | `alu`            |
| `rv_o`        | `sw`     | `imm12hi, rs1, rs2, imm12lo`   | `store`          |
| `rv_o`        | `xor`    | `rd, rs1, rs2`                 | `alu`            |
| `rv_o`        | `xori`   | `rd, rs1, imm12`               | `alu`            |

:RVO - Standard Extension for Extended Instructions

| **Extension** | **Name** | **Variable-Fields**          | **Class** |
|:--------------|:---------|:-----------------------------|:----------|
| `rv64_o`      | `addiw`  | `rd, rs1, imm12`             | `alu`     |
| `rv64_o`      | `addw`   | `rd, rs1, rs2`               | `alu`     |
| `rv64_o`      | `ld`     | `rd, rs1, imm12`             | `load`    |
| `rv64_o`      | `lwu`    | `rd, rs1, imm12`             | `load`    |
| `rv64_o`      | `sd`     | `imm12hi, rs1, rs2, imm12lo` | `store`   |
| `rv64_o`      | `slli`   | `rd, rs1, shamtd`            | `alu`     |
| `rv64_o`      | `slliw`  | `rd, rs1, shamtw`            | `alu`     |
| `rv64_o`      | `sllw`   | `rd, rs1, rs2`               | `alu`     |
| `rv64_o`      | `srai`   | `rd, rs1, shamtd`            | `alu`     |
| `rv64_o`      | `sraiw`  | `rd, rs1, shamtw`            | `alu`     |
| `rv64_o`      | `sraw`   | `rd, rs1, rs2`               | `alu`     |
| `rv64_o`      | `srli`   | `rd, rs1, shamtd`            | `alu`     |
| `rv64_o`      | `srliw`  | `rd, rs1, shamtw`            | `alu`     |
| `rv64_o`      | `srlw`   | `rd, rs1, rs2`               | `alu`     |
| `rv64_o`      | `subw`   | `rd, rs1, rs2`               | `alu`     |

:RV64O - Standard Extension for Extended Instructions (64 bit)

| **Extension** | **Name** | **Variable-Fields**          | **Class** |
|:--------------|:---------|:-----------------------------|:----------|
| `rv128_o`     | `addid`  | `rd, rs1, imm12`             | `alu`     |
| `rv128_o`     | `addd`   | `rd, rs1, rs2`               | `alu`     |
| `rv128_o`     | `lq`     | `rd, rs1, imm12`             | `load`    |
| `rv128_o`     | `ldu`    | `rd, rs1, imm12`             | `load`    |
| `rv128_o`     | `sq`     | `imm12hi, rs1, rs2, imm12lo` | `store`   |
| `rv128_o`     | `slli`   | `rd, rs1, shamt7`            | `alu`     |
| `rv128_o`     | `sllid`  | `rd, rs1, shamt6`            | `alu`     |
| `rv128_o`     | `slld`   | `rd, rs1, rs2`               | `alu`     |
| `rv128_o`     | `srai`   | `rd, rs1, shamt7`            | `alu`     |
| `rv128_o`     | `sraid`  | `rd, rs1, shamt6`            | `alu`     |
| `rv128_o`     | `srad`   | `rd, rs1, rs2`               | `alu`     |
| `rv128_o`     | `srli`   | `rd, rs1, shamt7`            | `alu`     |
| `rv128_o`     | `srlid`  | `rd, rs1, shamt6`            | `alu`     |
| `rv128_o`     | `srld`   | `rd, rs1, rs2`               | `alu`     |
| `rv128_o`     | `subd`   | `rd, rs1, rs2`               | `alu`     |

:RV128O - Standard Extension for Extended Instructions (128 bit)
