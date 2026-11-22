## INSTRUCTION FULL-NAMES

| **Extension** | **Name** | **Variable-Fields**            | **Full-Name**                        |
|:--------------|:---------|:-------------------------------|:-------------------------------------|
| `rv_e`        | `add`    | `rd, rs1, rs2`                 | `Add`                                |
| `rv_e`        | `addi`   | `rd, rs1, imm12`               | `Add Immediate`                      |
| `rv_e`        | `and`    | `rd, rs1, rs2`                 | `And`                                |
| `rv_e`        | `andi`   | `rd, rs1, imm12`               | `And Immediate`                      |
| `rv_e`        | `auipc`  | `rd, imm20`                    | `Add Upper Immediate to PC`          |
| `rv_e`        | `beq`    | `bimm12hi, rs1, rs2, bimm12lo` | `Branch Equal`                       |
| `rv_e`        | `bge`    | `bimm12hi, rs1, rs2, bimm12lo` | `Branch Greater than Equal`          |
| `rv_e`        | `bgeu`   | `bimm12hi, rs1, rs2, bimm12lo` | `Branch Greater than Equal Unsigned` |
| `rv_e`        | `blt`    | `bimm12hi, rs1, rs2, bimm12lo` | `Branch Less Than`                   |
| `rv_e`        | `bltu`   | `bimm12hi, rs1, rs2, bimm12lo` | `Branch Less Than Unsigned`          |
| `rv_e`        | `bne`    | `bimm12hi, rs1, rs2, bimm12lo` | `Branch Not Equal`                   |
| `rv_e`        | `ebreak` | `none`                         | `Environment Breakpoint`             |
| `rv_e`        | `ecall`  | `none`                         | `Environment Call`                   |
| `rv_e`        | `fence`  | `fm, pred, succ, rs1, rd`      | `Fence`                              |
| `rv_e`        | `jal`    | `rd, jimm20`                   | `Jump and Link`                      |
| `rv_e`        | `jalr`   | `rd, rs1, imm12`               | `Jump and Link Register`             |
| `rv_e`        | `lb`     | `rd, rs1, imm12`               | `Load Byte`                          |
| `rv_e`        | `lbu`    | `rd, rs1, imm12`               | `Load Byte Unsigned`                 |
| `rv_e`        | `lh`     | `rd, rs1, imm12`               | `Load Half`                          |
| `rv_e`        | `lhu`    | `rd, rs1, imm12`               | `Load Half Unsigned`                 |
| `rv_e`        | `lui`    | `rd, imm20`                    | `Load Upper Immediate`               |
| `rv_e`        | `lw`     | `rd, rs1, imm12`               | `Load Word`                          |
| `rv_e`        | `or`     | `rd, rs1, rs2`                 | `Or`                                 |
| `rv_e`        | `ori`    | `rd, rs1, imm12`               | `Or Immediate`                       |
| `rv_e`        | `sb`     | `imm12hi, rs1, rs2, imm12lo`   | `Store Byte`                         |
| `rv_e`        | `sh`     | `imm12hi, rs1, rs2, imm12lo`   | `Store Half`                         |
| `rv_e`        | `sll`    | `rd, rs1, rs2`                 | `Shift Left Logical`                 |
| `rv_e`        | `slt`    | `rd, rs1, rs2`                 | `Set Less Than`                      |
| `rv_e`        | `slti`   | `rd, rs1, imm12`               | `Set Less Than Immediate`            |
| `rv_e`        | `sltiu`  | `rd, rs1, imm12`               | `Set Less Than Immediate Unsigned`   |
| `rv_e`        | `sltu`   | `rd, rs1, rs2`                 | `Set Less Than Unsigned`             |
| `rv_e`        | `sra`    | `rd, rs1, rs2`                 | `Shift Right Arithmetic`             |
| `rv_e`        | `srl`    | `rd, rs1, rs2`                 | `Shift Right Logical`                |
| `rv_e`        | `sub`    | `rd, rs1, rs2`                 | `Subtract`                           |
| `rv_e`        | `sw`     | `imm12hi, rs1, rs2, imm12lo`   | `Store Word`                         |
| `rv_e`        | `xor`    | `rd, rs1, rs2`                 | `Xor`                                |
| `rv_e`        | `xori`   | `rd, rs1, imm12`               | `Xor Immediate`                      |

:RVE - Base Embedded Instruction Set

| **Extension** | **Name** | **Variable-Fields**          | **Full-Name**                           |
|:--------------|:---------|:-----------------------------|:----------------------------------------|
| `rv64_e`      | `addiw`  | `rd, rs1, imm12`             | `Add Immediate Word`                    |
| `rv64_e`      | `addw`   | `rd, rs1, rs2`               | `Add Word`                              |
| `rv64_e`      | `ld`     | `rd, rs1, imm12`             | `Load Double`                           |
| `rv64_e`      | `lwu`    | `rd, rs1, imm12`             | `Load Word Unsigned`                    |
| `rv64_e`      | `sd`     | `imm12hi, rs1, rs2, imm12lo` | `Store Double`                          |
| `rv64_e`      | `slli`   | `rd, rs1, shamtd`            | `Shift Left Logical Immediate`          |
| `rv64_e`      | `slliw`  | `rd, rs1, shamtw`            | `Shift Left Logical Immediate Word`     |
| `rv64_e`      | `sllw`   | `rd, rs1, rs2`               | `Shift Left Logical Word`               |
| `rv64_e`      | `srai`   | `rd, rs1, shamtd`            | `Shift Right Arithmetic Immediate`      |
| `rv64_e`      | `sraiw`  | `rd, rs1, shamtw`            | `Shift Right Arithmetic Immediate Word` |
| `rv64_e`      | `sraw`   | `rd, rs1, rs2`               | `Shift Right Arithmetic Word`           |
| `rv64_e`      | `srli`   | `rd, rs1, shamtd`            | `Shift Right Logical Immediate`         |
| `rv64_e`      | `srliw`  | `rd, rs1, shamtw`            | `Shift Right Logical Immediate Word`    |
| `rv64_e`      | `srlw`   | `rd, rs1, rs2`               | `Shift Right Logical Word`              |
| `rv64_e`      | `subw`   | `rd, rs1, rs2`               | `Subtract Word`                         |

:RV64E - Base Embedded Instruction Set (64 bit)

| **Extension** | **Name** | **Variable-Fields**          | **Full-Name**                             |
|:--------------|:---------|:-----------------------------|:------------------------------------------|
| `rv128_e`     | `addid`  | `rd, rs1, imm12`             | `Add Immediate Double`                    |
| `rv128_e`     | `addd`   | `rd, rs1, rs2`               | `Add Double`                              |
| `rv128_e`     | `lq`     | `rd, rs1, imm12`             | `Load Quad`                               |
| `rv128_e`     | `ldu`    | `rd, rs1, imm12`             | `Load Double Unsigned`                    |
| `rv128_e`     | `sq`     | `imm12hi, rs1, rs2, imm12lo` | `Store Quad`                              |
| `rv128_e`     | `slli`   | `rd, rs1, shamt7`            | `Shift Left Logical Immediate`            |
| `rv128_e`     | `sllid`  | `rd, rs1, shamt6`            | `Shift Left Logical Immediate Double`     |
| `rv128_e`     | `slld`   | `rd, rs1, rs2`               | `Shift Left Logical Double`               |
| `rv128_e`     | `srai`   | `rd, rs1, shamt7`            | `Shift Right Arithmetic Immediate`        |
| `rv128_e`     | `sraid`  | `rd, rs1, shamt6`            | `Shift Right Arithmetic Immediate Double` |
| `rv128_e`     | `srad`   | `rd, rs1, rs2`               | `Shift Right Arithmetic Double`           |
| `rv128_e`     | `srli`   | `rd, rs1, shamt7`            | `Shift Right Logical Immediate`           |
| `rv128_e`     | `srlid`  | `rd, rs1, shamt6`            | `Shift Right Logical Immediate Double`    |
| `rv128_e`     | `srld`   | `rd, rs1, rs2`               | `Shift Right Logical Double`              |
| `rv128_e`     | `subd`   | `rd, rs1, rs2`               | `Subtract Double`                         |

:RV128E - Base Embedded Instruction Set (128 bit)

| **Extension** | **Name**      | **Variable-Fields**                                 | **Full-Name**                           |
|:--------------|:--------------|:----------------------------------------------------|:----------------------------------------|
| `rv_zebi`     | `beqi`        | `imm12hi, imm5, rs1, imm12lo`                       | `Branch if Equal to Immediate`          |
| `rv_zebi`     | `bnei`        | `imm12hi, imm5, rs1, imm12lo`                       | `Branch if Not Equal to Immediate`      |
| `rv_zecbo`    | `cbo_clean`   | `rs1`                                               | `Cache Block Clean`                     |
| `rv_zecbo`    | `cbo_flush`   | `rs1`                                               | `Cache Block Flush`                     |
| `rv_zecbo`    | `cbo_inval`   | `rs1`                                               | `Cache Block Invalidate`                |
| `rv_zecbo`    | `cbo_zero`    | `rs1`                                               | `Cache Block Zero`                      |
| `rv_zecfiss`  | `ssamoswap_d` | `rd, rs1, rs2, aq, rl`                              | `Shadow Stack Atomic Swap Doubleword`   |
| `rv_zecfiss`  | `ssamoswap_w` | `rd, rs1, rs2, aq, rl`                              | `Shadow Stack Atomic Swap Word`         |
| `rv_zecond`   | `czero_eqz`   | `rd, rs1, rs2`                                      | `Conditional Zero if Equal to Zero`     |
| `rv_zecond`   | `czero_nez`   | `rd, rs1, rs2`                                      | `Conditional Zero if Not Equal to Zero` |
| `rv_zecsr`    | `csrrc`       | `rd, rs1, csr`                                      | `CSR Read and Clear Bits`               |
| `rv_zecsr`    | `csrrci`      | `rd, csr, zimm5`                                    | `CSR Read and Clear Bits Immediate`     |
| `rv_zecsr`    | `csrrs`       | `rd, rs1, csr`                                      | `CSR Read and Set Bits`                 |
| `rv_zecsr`    | `csrrsi`      | `rd, csr, zimm5`                                    | `CSR Read and Set Bits Immediate`       |
| `rv_zecsr`    | `csrrw`       | `rd, rs1, csr`                                      | `CSR Read/Write`                        |
| `rv_zecsr`    | `csrrwi`      | `rd, csr, zimm5`                                    | `CSR Read/Write Immediate`              |
| `rv_zefencei` | `fence_i`     | `imm12, rs1, rd`                                    | `Fence Instruction`                     |
| `rv_zemop`    | `mop_r_N`     | `mop_r_t_30, mop_r_t_27_26, mop_r_t_21_20, rd, rs1` | `May-Be-Operation One Source`           |
| `rv_zemop`    | `mop_rr_N`    | `mop_rr_t_30, mop_rr_t_27_26, rd, rs1, rs2`         | `May-Be-Operation Two Sources`          |

:RVZE - Base Embedded Instruction Set
