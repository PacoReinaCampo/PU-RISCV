## INSTRUCTION DESCRIPTIONS

| **Extension** | **Name** | **Variable-Fields**            | **Description**                                                                                                          |
|:--------------|:---------|:-------------------------------|:-------------------------------------------------------------------------------------------------------------------------|
| `rv_e`        | `add`    | `rd, rs1, rs2`                 | `Add rs2 to rs1 and place the result into rd`                                                                            |
| `rv_e`        | `addi`   | `rd, rs1, imm12`               | `Add sign-extended 12-bit immediate imm12 to register rs1 and place the result in rd`                                    |
| `rv_e`        | `and`    | `rd, rs1, rs2`                 | `Set rd to the bitwise and of rs1 and rs2`                                                                               |
| `rv_e`        | `andi`   | `rd, rs1, imm12`               | `Set rd to the bitwise and of rs1 with the sign-extended 12-bit immediate imm12`                                         |
| `rv_e`        | `auipc`  | `rd, imm20`                    | `Form a signed offset from oimm20 with the low 12 bits set to zero, add it to the PC, and place the result into rd`      |
| `rv_e`        | `beq`    | `bimm12hi, rs1, rs2, bimm12lo` | `Branch to the PC plus the signed offset sbimm12 if rs1 == rs2`                                                          |
| `rv_e`        | `bge`    | `bimm12hi, rs1, rs2, bimm12lo` | `Branch to the PC plus the signed offset sbimm12 if rs1 >= rs2 (signed)`                                                 |
| `rv_e`        | `bgeu`   | `bimm12hi, rs1, rs2, bimm12lo` | `Branch to the PC plus the signed offset sbimm12 if rs1 >= rs2 (unsigned)`                                               |
| `rv_e`        | `blt`    | `bimm12hi, rs1, rs2, bimm12lo` | `Branch to the PC plus the signed offset sbimm12 if rs1 < rs2 (signed)`                                                  |
| `rv_e`        | `bltu`   | `bimm12hi, rs1, rs2, bimm12lo` | `Branch to the PC plus the signed offset sbimm12 if rs1 < rs2 (unsigned)`                                                |
| `rv_e`        | `bne`    | `bimm12hi, rs1, rs2, bimm12lo` | `Branch to the PC plus the signed offset sbimm12 if rs1 != rs2`                                                          |
| `rv_e`        | `ebreak` | `none`                         | `Raise a breakpoint exception or enter Debug Mode when enabled`                                                          |
| `rv_e`        | `ecall`  | `none`                         | `Raise an environment call exception for the current privilege mode`                                                     |
| `rv_e`        | `fence`  | `fm, pred, succ, rs1, rd`      | `Order device I/O and memory accesses viewed by other threads and devices`                                               |
| `rv_e`        | `jal`    | `rd, jimm20`                   | `Jump to the PC plus the signed offset jimm20 and save PC+4 into rd`                                                     |
| `rv_e`        | `jalr`   | `rd, rs1, imm12`               | `Jump to rs1 plus the signed 12-bit offset oimm12 with the low bit cleared and save PC+4 into rd`                        |
| `rv_e`        | `lb`     | `rd, rs1, imm12`               | `Load 8-bit value from addr in rs1 plus the signed 12-bit offset oimm12 and place sign-extended result into rd`          |
| `rv_e`        | `lbu`    | `rd, rs1, imm12`               | `Load 8-bit value from addr in rs1 plus the signed 12-bit offset oimm12 and place zero-extended result into rd`          |
| `rv_e`        | `lh`     | `rd, rs1, imm12`               | `Load 16-bit value from addr in rs1 plus the signed 12-bit offset oimm12 and place sign-extended result into rd`         |
| `rv_e`        | `lhu`    | `rd, rs1, imm12`               | `Load 16-bit value from addr in rs1 plus the signed 12-bit offset oimm12 and place zero-extended result into rd`         |
| `rv_e`        | `lui`    | `rd, imm20`                    | `Place imm20 in the upper 20 bits of a 32-bit value, clear its low 12 bits, and sign-extend the result into rd`          |
| `rv_e`        | `lw`     | `rd, rs1, imm12`               | `Load 32-bit value from addr in rs1 plus the signed 12-bit offset oimm12 and place sign-extended result into rd`         |
| `rv_e`        | `or`     | `rd, rs1, rs2`                 | `Set rd to the bitwise or of rs1 and rs2`                                                                                |
| `rv_e`        | `ori`    | `rd, rs1, imm12`               | `Set rd to the bitwise or of rs1 with the sign-extended 12-bit immediate imm12`                                          |
| `rv_e`        | `sb`     | `imm12hi, rs1, rs2, imm12lo`   | `Store 8-bit value from the low bits of rs2 to addr in rs1 plus the signed 12-bit offset simm12`                         |
| `rv_e`        | `sh`     | `imm12hi, rs1, rs2, imm12lo`   | `Store 16-bit value from the low bits of rs2 to addr in rs1 plus the signed 12-bit offset simm12`                        |
| `rv_e`        | `sll`    | `rd, rs1, rs2`                 | `Shift rs1 left by the by the lower 5 or 6 (RV32/64) bits in rs2 and place the result into rd`                           |
| `rv_e`        | `slt`    | `rd, rs1, rs2`                 | `Set rd to 1 if rs1 is less than rs2, otherwise set rd to 0 (signed)`                                                    |
| `rv_e`        | `slti`   | `rd, rs1, imm12`               | `Set rd to 1 if rs1 is less than the sign-extended 12-bit immediate imm12, otherwise set rd to 0 (signed)`               |
| `rv_e`        | `sltiu`  | `rd, rs1, imm12`               | `Set rd to 1 if rs1 is less than the sign-extended 12-bit immediate imm12, otherwise set rd to 0 (unsigned)`             |
| `rv_e`        | `sltu`   | `rd, rs1, rs2`                 | `Set rd to 1 if rs1 is less than rs2, otherwise set rd to 0 (unsigned)`                                                  |
| `rv_e`        | `sra`    | `rd, rs1, rs2`                 | `Shift rs1 right by the by the lower 5 or 6 (RV32/64) bits in rs2 and place the result into rd while retaining the sign` |
| `rv_e`        | `srl`    | `rd, rs1, rs2`                 | `Shift rs1 right by the by the lower 5 or 6 (RV32/64) bits in rs2 and place the result into rd`                          |
| `rv_e`        | `sub`    | `rd, rs1, rs2`                 | `Subtract rs2 from rs1 and place the result into rd`                                                                     |
| `rv_e`        | `sw`     | `imm12hi, rs1, rs2, imm12lo`   | `Store 32-bit value from the low bits of rs2 to addr in rs1 plus the signed 12-bit offset simm12`                        |
| `rv_e`        | `xor`    | `rd, rs1, rs2`                 | `Set rd to the bitwise xor of rs1 and rs2`                                                                               |
| `rv_e`        | `xori`   | `rd, rs1, imm12`               | `Set rd to the bitwise xor of rs1 with the sign-extended 12-bit immediate imm12`                                         |

:RVE - Base Embedded Instruction Set

| **Extension** | **Name** | **Variable-Fields**          | **Description**                                                                                                                  |
|:--------------|:---------|:-----------------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `rv64_e`      | `addiw`  | `rd, rs1, imm12`             | `Add the sign-extended 12-bit immediate imm12 to rs1 and sign-extend the low 32 bits of the result into rd`                      |
| `rv64_e`      | `addw`   | `rd, rs1, rs2`               | `Add 32-bit value in rs2 to rs1 and place the 32-bit result into rd`                                                             |
| `rv64_e`      | `ld`     | `rd, rs1, imm12`             | `Load 64-bit value from addr in rs1 plus signed 12-bit offset oimm12 and place sign-extended result into rd`                     |
| `rv64_e`      | `lwu`    | `rd, rs1, imm12`             | `Load 32-bit value from addr in rs1 plus the signed 12-bit offset oimm12 and place zero-extended result into rd`                 |
| `rv64_e`      | `sd`     | `imm12hi, rs1, rs2, imm12lo` | `Store 64-bit value from the low bits of rs2 to addr in rs1 plus the signed 12-bit offset simm12`                                |
| `rv64_e`      | `slli`   | `rd, rs1, shamtd`            | `Shift rs1 left by the 6-bit immediate shamt6 and place the result into rd`                                                      |
| `rv64_e`      | `slliw`  | `rd, rs1, shamtw`            | `Shift the low 32 bits of rs1 left by shamt5 and sign-extend the 32-bit result into rd`                                          |
| `rv64_e`      | `sllw`   | `rd, rs1, rs2`               | `Shift 32-bit value in rs1 left by the by the lower 5 bits in rs2 and place the 32-bit result into rd`                           |
| `rv64_e`      | `srai`   | `rd, rs1, shamtd`            | `Shift rs1 right by the 6-bit immediate shamt6 with sign fill and place the result into rd`                                      |
| `rv64_e`      | `sraiw`  | `rd, rs1, shamtw`            | `Shift the low 32 bits of rs1 right by shamt5 with sign fill and sign-extend the 32-bit result into rd`                          |
| `rv64_e`      | `sraw`   | `rd, rs1, rs2`               | `Shift 32-bit value in rs1 right by the by the lower 5 bits in rs2 and place the 32-bit result into rd while retaining the sign` |
| `rv64_e`      | `srli`   | `rd, rs1, shamtd`            | `Shift rs1 right by the 6-bit immediate shamt6 with zero fill and place the result into rd`                                      |
| `rv64_e`      | `srliw`  | `rd, rs1, shamtw`            | `Shift the low 32 bits of rs1 right by shamt5 with zero fill and sign-extend the 32-bit result into rd`                          |
| `rv64_e`      | `srlw`   | `rd, rs1, rs2`               | `Shift 32-bit value in rs1 right by the by the lower 5 bits in rs2 and place the 32-bit result into rd`                          |
| `rv64_e`      | `subw`   | `rd, rs1, rs2`               | `Subtract 32-bit value in rs2 from rs1 and place the 32-bit result into rd`                                                      |

:RV64E - Base Embedded Instruction Set (64 bit)

| **Extension** | **Name** | **Variable-Fields**          | **Description**                                                                                                             |
|:--------------|:---------|:-----------------------------|:----------------------------------------------------------------------------------------------------------------------------|
| `rv128_e`     | `addid`  | `rd, rs1, imm12`             | `Add the signed 12-bit immediate imm12 to the low 64 bits of rs1 and sign-extend the low 64 bits of the result into rd`     |
| `rv128_e`     | `addd`   | `rd, rs1, rs2`               | `Add the low 64 bits of rs1 and rs2 and sign-extend the low 64 bits of the result into rd`                                  |
| `rv128_e`     | `lq`     | `rd, rs1, imm12`             | `Load a 128-bit value from the address in rs1 plus the signed 12-bit offset imm12 and place the result into rd`             |
| `rv128_e`     | `ldu`    | `rd, rs1, imm12`             | `Load a 64-bit value from the address in rs1 plus the signed 12-bit offset imm12 and zero-extend the result into rd`        |
| `rv128_e`     | `sq`     | `imm12hi, rs1, rs2, imm12lo` | `Store the 128-bit value in rs2 to the address in rs1 plus the signed 12-bit offset the signed immediate`                   |
| `rv128_e`     | `slli`   | `rd, rs1, shamt7`            | `Shift rs1 left by the 7-bit immediate shamt7 and place the result into rd`                                                 |
| `rv128_e`     | `sllid`  | `rd, rs1, shamt6`            | `Shift the low 64 bits of rs1 left by the 6-bit immediate shamt6 and sign-extend the 64-bit result into rd`                 |
| `rv128_e`     | `slld`   | `rd, rs1, rs2`               | `Shift the low 64 bits of rs1 left by the low 6 bits of rs2 and sign-extend the 64-bit result into rd`                      |
| `rv128_e`     | `srai`   | `rd, rs1, shamt7`            | `Shift rs1 right by the 7-bit immediate shamt7 with sign fill and place the result into rd`                                 |
| `rv128_e`     | `sraid`  | `rd, rs1, shamt6`            | `Shift the low 64 bits of rs1 right by the 6-bit immediate shamt6 with sign fill and sign-extend the 64-bit result into rd` |
| `rv128_e`     | `srad`   | `rd, rs1, rs2`               | `Shift the low 64 bits of rs1 right by the low 6 bits of rs2 with sign fill and sign-extend the 64-bit result into rd`      |
| `rv128_e`     | `srli`   | `rd, rs1, shamt7`            | `Shift rs1 right by the 7-bit immediate shamt7 with zero fill and place the result into rd`                                 |
| `rv128_e`     | `srlid`  | `rd, rs1, shamt6`            | `Shift the low 64 bits of rs1 right by the 6-bit immediate shamt6 with zero fill and sign-extend the 64-bit result into rd` |
| `rv128_e`     | `srld`   | `rd, rs1, rs2`               | `Shift the low 64 bits of rs1 right by the low 6 bits of rs2 with zero fill and sign-extend the 64-bit result into rd`      |
| `rv128_e`     | `subd`   | `rd, rs1, rs2`               | `Subtract the low 64 bits of rs2 from the low 64 bits of rs1 and sign-extend the low 64 bits of the result into rd`         |

:RV128E - Base Embedded Instruction Set (128 bit)

| **Extension** | **Name**      | **Variable-Fields**                                 | **Description**                                                                                                                                           |
|:--------------|:--------------|:----------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------|
| `rv_zebi`     | `beqi`        | `imm12hi, imm5, rs1, imm12lo`                       | `Branch by the signed offset when rs1 is equal to the decoded immediate (0 encodes -1)`                                                                   |
| `rv_zebi`     | `bnei`        | `imm12hi, imm5, rs1, imm12lo`                       | `Branch by the signed offset when rs1 is not equal to the decoded immediate (0 encodes -1)`                                                               |
| `rv_zecbo`    | `cbo_clean`   | `rs1`                                               | `Write back modified data in the addressed cache block`                                                                                                   |
| `rv_zecbo`    | `cbo_flush`   | `rs1`                                               | `Write back modified data in the addressed cache block and invalidate its cached copies`                                                                  |
| `rv_zecbo`    | `cbo_inval`   | `rs1`                                               | `Invalidate the addressed cache block subject to privilege controls`                                                                                      |
| `rv_zecbo`    | `cbo_zero`    | `rs1`                                               | `Set every byte in the addressed cache block to zero`                                                                                                     |
| `rv_zecfiss`  | `ssamoswap_d` | `rd, rs1, rs2, aq, rl`                              | `Atomically exchange a shadow stack doubleword at rs1 with the low 64 bits of rs2 and sign-extend the old value into rd`                                  |
| `rv_zecfiss`  | `ssamoswap_w` | `rd, rs1, rs2, aq, rl`                              | `Atomically exchange a shadow stack word at rs1 with the low 32 bits of rs2 and sign-extend the old value into rd`                                        |
| `rv_zecond`   | `czero_eqz`   | `rd, rs1, rs2`                                      | `Place zero in rd if rs2 is equal to zero, otherwise copy rs1 into rd`                                                                                    |
| `rv_zecond`   | `czero_nez`   | `rd, rs1, rs2`                                      | `Place zero in rd if rs2 is not equal to zero, otherwise copy rs1 into rd`                                                                                |
| `rv_zecsr`    | `csrrc`       | `rd, rs1, csr`                                      | `Return the old CSR value in rd and clear the bits selected by the source mask using rs1. Skip the CSR write when rs1 is zero.`                           |
| `rv_zecsr`    | `csrrci`      | `rd, csr, zimm5`                                    | `Return the old CSR value in rd and clear the bits selected by the source mask using the zero-extended immediate. Skip the CSR write when zimm5 is zero.` |
| `rv_zecsr`    | `csrrs`       | `rd, rs1, csr`                                      | `Return the old CSR value in rd and set the bits selected by the source mask using rs1. Skip the CSR write when rs1 is zero.`                             |
| `rv_zecsr`    | `csrrsi`      | `rd, csr, zimm5`                                    | `Return the old CSR value in rd and set the bits selected by the source mask using the zero-extended immediate. Skip the CSR write when zimm5 is zero.`   |
| `rv_zecsr`    | `csrrw`       | `rd, rs1, csr`                                      | `Return the old CSR value in rd and write the source value using rs1. Skip the CSR read when rd is x0.`                                                   |
| `rv_zecsr`    | `csrrwi`      | `rd, csr, zimm5`                                    | `Return the old CSR value in rd and write the source value using the zero-extended immediate. Skip the CSR read when rd is x0.`                           |
| `rv_zefencei` | `fence_i`     | `imm12, rs1, rd`                                    | `Synchronize the instruction and data streams`                                                                                                            |
| `rv_zemop`    | `mop_r_N`     | `mop_r_t_30, mop_r_t_27_26, mop_r_t_21_20, rd, rs1` | `Write zero to rd under Zimop. An extension can redefine this encoding.`                                                                                  |
| `rv_zemop`    | `mop_rr_N`    | `mop_rr_t_30, mop_rr_t_27_26, rd, rs1, rs2`         | `Write zero to rd under Zimop. An extension can redefine this encoding.`                                                                                  |

:RVZE - Base Embedded Instruction Set
