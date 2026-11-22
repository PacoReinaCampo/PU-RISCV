## INSTRUCTION FULL-NAMES

| **Extension** | **Name** | **Variable-Fields**            | **Full-Name**                        |
|:--------------|:---------|:-------------------------------|:-------------------------------------|
| `rv_o`        | `add`    | `rd, rs1, rs2`                 | `Add`                                |
| `rv_o`        | `addi`   | `rd, rs1, imm12`               | `Add Immediate`                      |
| `rv_o`        | `and`    | `rd, rs1, rs2`                 | `And`                                |
| `rv_o`        | `andi`   | `rd, rs1, imm12`               | `And Immediate`                      |
| `rv_o`        | `auipc`  | `rd, imm20`                    | `Add Upper Immediate to PC`          |
| `rv_o`        | `beq`    | `bimm12hi, rs1, rs2, bimm12lo` | `Branch Equal`                       |
| `rv_o`        | `bge`    | `bimm12hi, rs1, rs2, bimm12lo` | `Branch Greater than Equal`          |
| `rv_o`        | `bgeu`   | `bimm12hi, rs1, rs2, bimm12lo` | `Branch Greater than Equal Unsigned` |
| `rv_o`        | `blt`    | `bimm12hi, rs1, rs2, bimm12lo` | `Branch Less Than`                   |
| `rv_o`        | `bltu`   | `bimm12hi, rs1, rs2, bimm12lo` | `Branch Less Than Unsigned`          |
| `rv_o`        | `bne`    | `bimm12hi, rs1, rs2, bimm12lo` | `Branch Not Equal`                   |
| `rv_o`        | `ebreak` | `none`                         | `Environment Breakpoint`             |
| `rv_o`        | `ecall`  | `none`                         | `Environment Call`                   |
| `rv_o`        | `fence`  | `fm, pred, succ, rs1, rd`      | `Fence`                              |
| `rv_o`        | `jal`    | `rd, jimm20`                   | `Jump and Link`                      |
| `rv_o`        | `jalr`   | `rd, rs1, imm12`               | `Jump and Link Register`             |
| `rv_o`        | `lb`     | `rd, rs1, imm12`               | `Load Byte`                          |
| `rv_o`        | `lbu`    | `rd, rs1, imm12`               | `Load Byte Unsigned`                 |
| `rv_o`        | `lh`     | `rd, rs1, imm12`               | `Load Half`                          |
| `rv_o`        | `lhu`    | `rd, rs1, imm12`               | `Load Half Unsigned`                 |
| `rv_o`        | `lui`    | `rd, imm20`                    | `Load Upper Immediate`               |
| `rv_o`        | `lw`     | `rd, rs1, imm12`               | `Load Word`                          |
| `rv_o`        | `or`     | `rd, rs1, rs2`                 | `Or`                                 |
| `rv_o`        | `ori`    | `rd, rs1, imm12`               | `Or Immediate`                       |
| `rv_o`        | `sb`     | `imm12hi, rs1, rs2, imm12lo`   | `Store Byte`                         |
| `rv_o`        | `sh`     | `imm12hi, rs1, rs2, imm12lo`   | `Store Half`                         |
| `rv_o`        | `sll`    | `rd, rs1, rs2`                 | `Shift Left Logical`                 |
| `rv_o`        | `slt`    | `rd, rs1, rs2`                 | `Set Less Than`                      |
| `rv_o`        | `slti`   | `rd, rs1, imm12`               | `Set Less Than Immediate`            |
| `rv_o`        | `sltiu`  | `rd, rs1, imm12`               | `Set Less Than Immediate Unsigned`   |
| `rv_o`        | `sltu`   | `rd, rs1, rs2`                 | `Set Less Than Unsigned`             |
| `rv_o`        | `sra`    | `rd, rs1, rs2`                 | `Shift Right Arithmetic`             |
| `rv_o`        | `srl`    | `rd, rs1, rs2`                 | `Shift Right Logical`                |
| `rv_o`        | `sub`    | `rd, rs1, rs2`                 | `Subtract`                           |
| `rv_o`        | `sw`     | `imm12hi, rs1, rs2, imm12lo`   | `Store Word`                         |
| `rv_o`        | `xor`    | `rd, rs1, rs2`                 | `Xor`                                |
| `rv_o`        | `xori`   | `rd, rs1, imm12`               | `Xor Immediate`                      |

:RVO - Standard Extension for Extended Instructions

| **Extension** | **Name** | **Variable-Fields**          | **Full-Name**                           |
|:--------------|:---------|:-----------------------------|:----------------------------------------|
| `rv64_o`      | `addiw`  | `rd, rs1, imm12`             | `Add Immediate Word`                    |
| `rv64_o`      | `addw`   | `rd, rs1, rs2`               | `Add Word`                              |
| `rv64_o`      | `ld`     | `rd, rs1, imm12`             | `Load Double`                           |
| `rv64_o`      | `lwu`    | `rd, rs1, imm12`             | `Load Word Unsigned`                    |
| `rv64_o`      | `sd`     | `imm12hi, rs1, rs2, imm12lo` | `Store Double`                          |
| `rv64_o`      | `slli`   | `rd, rs1, shamtd`            | `Shift Left Logical Immediate`          |
| `rv64_o`      | `slliw`  | `rd, rs1, shamtw`            | `Shift Left Logical Immediate Word`     |
| `rv64_o`      | `sllw`   | `rd, rs1, rs2`               | `Shift Left Logical Word`               |
| `rv64_o`      | `srai`   | `rd, rs1, shamtd`            | `Shift Right Arithmetic Immediate`      |
| `rv64_o`      | `sraiw`  | `rd, rs1, shamtw`            | `Shift Right Arithmetic Immediate Word` |
| `rv64_o`      | `sraw`   | `rd, rs1, rs2`               | `Shift Right Arithmetic Word`           |
| `rv64_o`      | `srli`   | `rd, rs1, shamtd`            | `Shift Right Logical Immediate`         |
| `rv64_o`      | `srliw`  | `rd, rs1, shamtw`            | `Shift Right Logical Immediate Word`    |
| `rv64_o`      | `srlw`   | `rd, rs1, rs2`               | `Shift Right Logical Word`              |
| `rv64_o`      | `subw`   | `rd, rs1, rs2`               | `Subtract Word`                         |

:RV64O - Standard Extension for Extended Instructions (64 bit)

| **Extension** | **Name** | **Variable-Fields**          | **Full-Name**                             |
|:--------------|:---------|:-----------------------------|:------------------------------------------|
| `rv128_o`     | `addid`  | `rd, rs1, imm12`             | `Add Immediate Double`                    |
| `rv128_o`     | `addd`   | `rd, rs1, rs2`               | `Add Double`                              |
| `rv128_o`     | `lq`     | `rd, rs1, imm12`             | `Load Quad`                               |
| `rv128_o`     | `ldu`    | `rd, rs1, imm12`             | `Load Double Unsigned`                    |
| `rv128_o`     | `sq`     | `imm12hi, rs1, rs2, imm12lo` | `Store Quad`                              |
| `rv128_o`     | `slli`   | `rd, rs1, shamt7`            | `Shift Left Logical Immediate`            |
| `rv128_o`     | `sllid`  | `rd, rs1, shamt6`            | `Shift Left Logical Immediate Double`     |
| `rv128_o`     | `slld`   | `rd, rs1, rs2`               | `Shift Left Logical Double`               |
| `rv128_o`     | `srai`   | `rd, rs1, shamt7`            | `Shift Right Arithmetic Immediate`        |
| `rv128_o`     | `sraid`  | `rd, rs1, shamt6`            | `Shift Right Arithmetic Immediate Double` |
| `rv128_o`     | `srad`   | `rd, rs1, rs2`               | `Shift Right Arithmetic Double`           |
| `rv128_o`     | `srli`   | `rd, rs1, shamt7`            | `Shift Right Logical Immediate`           |
| `rv128_o`     | `srlid`  | `rd, rs1, shamt6`            | `Shift Right Logical Immediate Double`    |
| `rv128_o`     | `srld`   | `rd, rs1, rs2`               | `Shift Right Logical Double`              |
| `rv128_o`     | `subd`   | `rd, rs1, rs2`               | `Subtract Double`                         |

:RV128O - Standard Extension for Extended Instructions (128 bit)
