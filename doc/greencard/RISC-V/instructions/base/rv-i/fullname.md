## INSTRUCTION FULL-NAMES

| **Extension** | **Name** | **Variable-Fields**            | **Full-Name**                        |
|:--------------|:---------|:-------------------------------|:-------------------------------------|
| `rv_i`        | `add`    | `rd, rs1, rs2`                 | `Add`                                |
| `rv_i`        | `addi`   | `rd, rs1, imm12`               | `Add Immediate`                      |
| `rv_i`        | `and`    | `rd, rs1, rs2`                 | `And`                                |
| `rv_i`        | `andi`   | `rd, rs1, imm12`               | `And Immediate`                      |
| `rv_i`        | `auipc`  | `rd, imm20`                    | `Add Upper Immediate to PC`          |
| `rv_i`        | `beq`    | `bimm12hi, rs1, rs2, bimm12lo` | `Branch Equal`                       |
| `rv_i`        | `bge`    | `bimm12hi, rs1, rs2, bimm12lo` | `Branch Greater than Equal`          |
| `rv_i`        | `bgeu`   | `bimm12hi, rs1, rs2, bimm12lo` | `Branch Greater than Equal Unsigned` |
| `rv_i`        | `blt`    | `bimm12hi, rs1, rs2, bimm12lo` | `Branch Less Than`                   |
| `rv_i`        | `bltu`   | `bimm12hi, rs1, rs2, bimm12lo` | `Branch Less Than Unsigned`          |
| `rv_i`        | `bne`    | `bimm12hi, rs1, rs2, bimm12lo` | `Branch Not Equal`                   |
| `rv_i`        | `ebreak` | `none`                         | `Environment Breakpoint`             |
| `rv_i`        | `ecall`  | `none`                         | `Environment Call`                   |
| `rv_i`        | `fence`  | `fm, pred, succ, rs1, rd`      | `Fence`                              |
| `rv_i`        | `jal`    | `rd, jimm20`                   | `Jump and Link`                      |
| `rv_i`        | `jalr`   | `rd, rs1, imm12`               | `Jump and Link Register`             |
| `rv_i`        | `lb`     | `rd, rs1, imm12`               | `Load Byte`                          |
| `rv_i`        | `lbu`    | `rd, rs1, imm12`               | `Load Byte Unsigned`                 |
| `rv_i`        | `lh`     | `rd, rs1, imm12`               | `Load Half`                          |
| `rv_i`        | `lhu`    | `rd, rs1, imm12`               | `Load Half Unsigned`                 |
| `rv_i`        | `lui`    | `rd, imm20`                    | `Load Upper Immediate`               |
| `rv_i`        | `lw`     | `rd, rs1, imm12`               | `Load Word`                          |
| `rv_i`        | `or`     | `rd, rs1, rs2`                 | `Or`                                 |
| `rv_i`        | `ori`    | `rd, rs1, imm12`               | `Or Immediate`                       |
| `rv_i`        | `sb`     | `imm12hi, rs1, rs2, imm12lo`   | `Store Byte`                         |
| `rv_i`        | `sh`     | `imm12hi, rs1, rs2, imm12lo`   | `Store Half`                         |
| `rv_i`        | `sll`    | `rd, rs1, rs2`                 | `Shift Left Logical`                 |
| `rv_i`        | `slt`    | `rd, rs1, rs2`                 | `Set Less Than`                      |
| `rv_i`        | `slti`   | `rd, rs1, imm12`               | `Set Less Than Immediate`            |
| `rv_i`        | `sltiu`  | `rd, rs1, imm12`               | `Set Less Than Immediate Unsigned`   |
| `rv_i`        | `sltu`   | `rd, rs1, rs2`                 | `Set Less Than Unsigned`             |
| `rv_i`        | `sra`    | `rd, rs1, rs2`                 | `Shift Right Arithmetic`             |
| `rv_i`        | `srl`    | `rd, rs1, rs2`                 | `Shift Right Logical`                |
| `rv_i`        | `sub`    | `rd, rs1, rs2`                 | `Subtract`                           |
| `rv_i`        | `sw`     | `imm12hi, rs1, rs2, imm12lo`   | `Store Word`                         |
| `rv_i`        | `xor`    | `rd, rs1, rs2`                 | `Xor`                                |
| `rv_i`        | `xori`   | `rd, rs1, imm12`               | `Xor Immediate`                      |

:RVI - Base Integer Instruction Set

| **Extension** | **Name** | **Variable-Fields**          | **Full-Name**                           |
|:--------------|:---------|:-----------------------------|:----------------------------------------|
| `rv64_i`      | `addiw`  | `rd, rs1, imm12`             | `Add Immediate Word`                    |
| `rv64_i`      | `addw`   | `rd, rs1, rs2`               | `Add Word`                              |
| `rv64_i`      | `ld`     | `rd, rs1, imm12`             | `Load Double`                           |
| `rv64_i`      | `lwu`    | `rd, rs1, imm12`             | `Load Word Unsigned`                    |
| `rv64_i`      | `sd`     | `imm12hi, rs1, rs2, imm12lo` | `Store Double`                          |
| `rv64_i`      | `slli`   | `rd, rs1, shamtd`            | `Shift Left Logical Immediate`          |
| `rv64_i`      | `slliw`  | `rd, rs1, shamtw`            | `Shift Left Logical Immediate Word`     |
| `rv64_i`      | `sllw`   | `rd, rs1, rs2`               | `Shift Left Logical Word`               |
| `rv64_i`      | `srai`   | `rd, rs1, shamtd`            | `Shift Right Arithmetic Immediate`      |
| `rv64_i`      | `sraiw`  | `rd, rs1, shamtw`            | `Shift Right Arithmetic Immediate Word` |
| `rv64_i`      | `sraw`   | `rd, rs1, rs2`               | `Shift Right Arithmetic Word`           |
| `rv64_i`      | `srli`   | `rd, rs1, shamtd`            | `Shift Right Logical Immediate`         |
| `rv64_i`      | `srliw`  | `rd, rs1, shamtw`            | `Shift Right Logical Immediate Word`    |
| `rv64_i`      | `srlw`   | `rd, rs1, rs2`               | `Shift Right Logical Word`              |
| `rv64_i`      | `subw`   | `rd, rs1, rs2`               | `Subtract Word`                         |

:RV64I - Base Integer Instruction Set (64 bit)

| **Extension** | **Name** | **Variable-Fields**          | **Full-Name**                             |
|:--------------|:---------|:-----------------------------|:------------------------------------------|
| `rv128_i`     | `addid`  | `rd, rs1, imm12`             | `Add Immediate Double`                    |
| `rv128_i`     | `addd`   | `rd, rs1, rs2`               | `Add Double`                              |
| `rv128_i`     | `lq`     | `rd, rs1, imm12`             | `Load Quad`                               |
| `rv128_i`     | `ldu`    | `rd, rs1, imm12`             | `Load Double Unsigned`                    |
| `rv128_i`     | `sq`     | `imm12hi, rs1, rs2, imm12lo` | `Store Quad`                              |
| `rv128_i`     | `slli`   | `rd, rs1, shamt7`            | `Shift Left Logical Immediate`            |
| `rv128_i`     | `sllid`  | `rd, rs1, shamt6`            | `Shift Left Logical Immediate Double`     |
| `rv128_i`     | `slld`   | `rd, rs1, rs2`               | `Shift Left Logical Double`               |
| `rv128_i`     | `srai`   | `rd, rs1, shamt7`            | `Shift Right Arithmetic Immediate`        |
| `rv128_i`     | `sraid`  | `rd, rs1, shamt6`            | `Shift Right Arithmetic Immediate Double` |
| `rv128_i`     | `srad`   | `rd, rs1, rs2`               | `Shift Right Arithmetic Double`           |
| `rv128_i`     | `srli`   | `rd, rs1, shamt7`            | `Shift Right Logical Immediate`           |
| `rv128_i`     | `srlid`  | `rd, rs1, shamt6`            | `Shift Right Logical Immediate Double`    |
| `rv128_i`     | `srld`   | `rd, rs1, rs2`               | `Shift Right Logical Double`              |
| `rv128_i`     | `subd`   | `rd, rs1, rs2`               | `Subtract Double`                         |

:RV128I - Base Integer Instruction Set (128 bit)

| **Extension** | **Name**      | **Variable-Fields**                                 | **Full-Name**                           |
|:--------------|:--------------|:----------------------------------------------------|:----------------------------------------|
| `rv_zibi`     | `beqi`        | `imm12hi, imm5, rs1, imm12lo`                       | `Branch if Equal to Immediate`          |
| `rv_zibi`     | `bnei`        | `imm12hi, imm5, rs1, imm12lo`                       | `Branch if Not Equal to Immediate`      |
| `rv_zicbo`    | `cbo_clean`   | `rs1`                                               | `Cache Block Clean`                     |
| `rv_zicbo`    | `cbo_flush`   | `rs1`                                               | `Cache Block Flush`                     |
| `rv_zicbo`    | `cbo_inval`   | `rs1`                                               | `Cache Block Invalidate`                |
| `rv_zicbo`    | `cbo_zero`    | `rs1`                                               | `Cache Block Zero`                      |
| `rv_zicfiss`  | `ssamoswap_d` | `rd, rs1, rs2, aq, rl`                              | `Shadow Stack Atomic Swap Doubleword`   |
| `rv_zicfiss`  | `ssamoswap_w` | `rd, rs1, rs2, aq, rl`                              | `Shadow Stack Atomic Swap Word`         |
| `rv_zicond`   | `czero_eqz`   | `rd, rs1, rs2`                                      | `Conditional Zero if Equal to Zero`     |
| `rv_zicond`   | `czero_nez`   | `rd, rs1, rs2`                                      | `Conditional Zero if Not Equal to Zero` |
| `rv_zicsr`    | `csrrc`       | `rd, rs1, csr`                                      | `CSR Read and Clear Bits`               |
| `rv_zicsr`    | `csrrci`      | `rd, csr, zimm5`                                    | `CSR Read and Clear Bits Immediate`     |
| `rv_zicsr`    | `csrrs`       | `rd, rs1, csr`                                      | `CSR Read and Set Bits`                 |
| `rv_zicsr`    | `csrrsi`      | `rd, csr, zimm5`                                    | `CSR Read and Set Bits Immediate`       |
| `rv_zicsr`    | `csrrw`       | `rd, rs1, csr`                                      | `CSR Read/Write`                        |
| `rv_zicsr`    | `csrrwi`      | `rd, csr, zimm5`                                    | `CSR Read/Write Immediate`              |
| `rv_zifencei` | `fence_i`     | `imm12, rs1, rd`                                    | `Fence Instruction`                     |
| `rv_zilx`     | `lxh`         | `rd, rs1, rs2`                                      | `Indexed Load Halfword`                 |
| `rv_zilx`     | `lxhu`        | `rd, rs1, rs2`                                      | `Indexed Load Halfword Unsigned`        |
| `rv_zilx`     | `lxsb`        | `rd, rs1, rs2`                                      | `Scaled Indexed Load Byte`              |
| `rv_zilx`     | `lxsbu`       | `rd, rs1, rs2`                                      | `Scaled Indexed Load Byte Unsigned`     |
| `rv_zilx`     | `lxsh`        | `rd, rs1, rs2`                                      | `Scaled Indexed Load Halfword`          |
| `rv_zilx`     | `lxshu`       | `rd, rs1, rs2`                                      | `Scaled Indexed Load Halfword Unsigned` |
| `rv_zilx`     | `lxsw`        | `rd, rs1, rs2`                                      | `Scaled Indexed Load Word`              |
| `rv_zilx`     | `lxw`         | `rd, rs1, rs2`                                      | `Indexed Load Word`                     |
| `rv_zimop`    | `mop_r_N`     | `mop_r_t_30, mop_r_t_27_26, mop_r_t_21_20, rd, rs1` | `May-Be-Operation One Source`           |
| `rv_zimop`    | `mop_rr_N`    | `mop_rr_t_30, mop_rr_t_27_26, rd, rs1, rs2`         | `May-Be-Operation Two Sources`          |

:RVZI - Base Integer Instruction Set

| **Extension** | **Name**  | **Variable-Fields** | **Full-Name**                                                    |
|:--------------|:----------|:--------------------|:-----------------------------------------------------------------|
| `rv64_zilx`   | `lxd`     | `rd, rs1, rs2`      | `Indexed Load Doubleword`                                        |
| `rv64_zilx`   | `lxsd`    | `rd, rs1, rs2`      | `Scaled Indexed Load Doubleword`                                 |
| `rv64_zilx`   | `lxsuwb`  | `rd, rs1, rs2`      | `Scaled Indexed Load Byte with Unsigned Word Index`              |
| `rv64_zilx`   | `lxsuwbu` | `rd, rs1, rs2`      | `Scaled Indexed Load Byte Unsigned with Unsigned Word Index`     |
| `rv64_zilx`   | `lxsuwd`  | `rd, rs1, rs2`      | `Scaled Indexed Load Doubleword with Unsigned Word Index`        |
| `rv64_zilx`   | `lxsuwh`  | `rd, rs1, rs2`      | `Scaled Indexed Load Halfword with Unsigned Word Index`          |
| `rv64_zilx`   | `lxsuwhu` | `rd, rs1, rs2`      | `Scaled Indexed Load Halfword Unsigned with Unsigned Word Index` |
| `rv64_zilx`   | `lxsuww`  | `rd, rs1, rs2`      | `Scaled Indexed Load Word with Unsigned Word Index`              |
| `rv64_zilx`   | `lxsuwwu` | `rd, rs1, rs2`      | `Scaled Indexed Load Word Unsigned with Unsigned Word Index`     |
| `rv64_zilx`   | `lxswu`   | `rd, rs1, rs2`      | `Scaled Indexed Load Word Unsigned`                              |
| `rv64_zilx`   | `lxwu`    | `rd, rs1, rs2`      | `Indexed Load Word Unsigned`                                     |

:RV64ZI - Base Integer Instruction Set (64 bit)
