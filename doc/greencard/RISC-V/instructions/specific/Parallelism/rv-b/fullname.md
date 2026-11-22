## INSTRUCTION FULL-NAMES

| **Extension** | **Name**  | **Variable-Fields** | **Full-Name**                                        |
|:--------------|:----------|:--------------------|:-----------------------------------------------------|
| `rv_zba`      | `sh1add`  | `rd, rs1, rs2`      | `Shift left by 1 and add`                            |
| `rv_zba`      | `sh2add`  | `rd, rs1, rs2`      | `Shift left by 2 and add`                            |
| `rv_zba`      | `sh3add`  | `rd, rs1, rs2`      | `Shift left by 3 and add`                            |
| `rv_zbb`      | `andn`    | `rd, rs1, rs2`      | `AND with inverted operand`                          |
| `rv_zbb`      | `clz`     | `rd, rs1`           | `Count leading zero bits`                            |
| `rv_zbb`      | `cpop`    | `rd, rs1`           | `Count set bits`                                     |
| `rv_zbb`      | `ctz`     | `rd, rs1`           | `Count trailing zeros`                               |
| `rv_zbb`      | `max`     | `rd, rs1, rs2`      | `Maximum`                                            |
| `rv_zbb`      | `maxu`    | `rd, rs1, rs2`      | `Unsigned maximum`                                   |
| `rv_zbb`      | `min`     | `rd, rs1, rs2`      | `Minimum`                                            |
| `rv_zbb`      | `minu`    | `rd, rs1, rs2`      | `Unsigned minimum`                                   |
| `rv_zbb`      | `orc_b`   | `rd, rs1`           | `Bitwise OR-Combine, byte granule`                   |
| `rv_zbb`      | `orn`     | `rd, rs1, rs2`      | `OR with inverted operand`                           |
| `rv_zbb`      | `rol`     | `rd, rs1, rs2`      | `Rotate Left (Register)`                             |
| `rv_zbb`      | `ror`     | `rd, rs1, rs2`      | `Rotate Right`                                       |
| `rv_zbb`      | `sext_b`  | `rd, rs1`           | `Sign-extend byte`                                   |
| `rv_zbb`      | `sext_h`  | `rd, rs1`           | `Sign-extend halfword`                               |
| `rv_zbb`      | `xnor`    | `rd, rs1, rs2`      | `Exclusive NOR`                                      |
| `rv_zbc`      | `clmul`   | `rd, rs1, rs2`      | `Carry-less multiply (low-part)`                     |
| `rv_zbc`      | `clmulh`  | `rd, rs1, rs2`      | `Carry-less multiply (high-part)`                    |
| `rv_zbc`      | `clmulr`  | `rd, rs1, rs2`      | `Carry-less multiply (reversed)`                     |
| `rv_zbkb`     | `andn`    | `rd, rs1, rs2`      | `AND with inverted operand`                          |
| `rv_zbkb`     | `brev8`   | `rd, rs1`           | `Reverse the bits in each byte of a source register` |
| `rv_zbkb`     | `orn`     | `rd, rs1, rs2`      | `OR with inverted operand`                           |
| `rv_zbkb`     | `pack`    | `rd, rs1, rs2`      | `Pack the low halves of rs1 and rs2 into rd`         |
| `rv_zbkb`     | `packh`   | `rd, rs1, rs2`      | `Pack the low bytes of rs1 and rs2 into rd`          |
| `rv_zbkb`     | `rol`     | `rd, rs1, rs2`      | `Rotate Left (Register)`                             |
| `rv_zbkb`     | `ror`     | `rd, rs1, rs2`      | `Rotate Right`                                       |
| `rv_zbkb`     | `xnor`    | `rd, rs1, rs2`      | `Exclusive NOR`                                      |
| `rv_zbkc`     | `clmul`   | `rd, rs1, rs2`      | `Carry-less multiply (low-part)`                     |
| `rv_zbkc`     | `clmulh`  | `rd, rs1, rs2`      | `Carry-less multiply (high-part)`                    |
| `rv_zbkx`     | `xperm4`  | `rd, rs1, rs2`      | `4-Bit Crossbar Permutation`                         |
| `rv_zbkx`     | `xperm8`  | `rd, rs1, rs2`      | `8-Bit Crossbar Permutation`                         |
| `rv_zbp`      | `xperm16` | `rd, rs1, rs2`      | `16-Bit Crossbar Permutation`                        |
| `rv_zbs`      | `bclr`    | `rd, rs1, rs2`      | `Single-Bit Clear (Register)`                        |
| `rv_zbs`      | `bext`    | `rd, rs1, rs2`      | `Single-Bit Extract (Register)`                      |
| `rv_zbs`      | `binv`    | `rd, rs1, rs2`      | `Single-Bit Invert (Register)`                       |
| `rv_zbs`      | `bset`    | `rd, rs1, rs2`      | `Single-Bit Set (Register)`                          |

:RVZB - Specific Extension for Bit Instructions

| **Extension** | **Name**    | **Variable-Fields** | **Full-Name**                                                                                                               |
|:--------------|:------------|:--------------------|:----------------------------------------------------------------------------------------------------------------------------|
| `rv32_zbkb`   | `rev8_rv32` | `rd, rs1`           | `Byte-reverse register`                                                                                                     |
| `rv32_zbkb`   | `unzip`     | `rd, rs1`           | `Place odd and even bits of the source register into upper and lower halves of the destination register, respectively`      |
| `rv32_zbkb`   | `zip`       | `rd, rs1`           | `Interleave upper and lower halves of the source register into odd and even bits of the destination register, respectively` |

:RV32ZB - Specific Extension for Bit Instructions (32 bit)

| **Extension** | **Name**    | **Variable-Fields** | **Full-Name**                                         |
|:--------------|:------------|:--------------------|:------------------------------------------------------|
| `rv64_zba`    | `add_uw`    | `rd, rs1, rs2`      | `Add unsigned word`                                   |
| `rv64_zba`    | `sh1add_uw` | `rd, rs1, rs2`      | `Shift unsigned word left by 1 and add`               |
| `rv64_zba`    | `sh2add_uw` | `rd, rs1, rs2`      | `Shift unsigned word left by 2 and add`               |
| `rv64_zba`    | `sh3add_uw` | `rd, rs1, rs2`      | `Shift unsigned word left by 3 and add`               |
| `rv64_zba`    | `slli_uw`   | `rd, rs1, shamtd`   | `Shift-left unsigned word (Immediate)`                |
| `rv64_zbb`    | `clzw`      | `rd, rs1`           | `Count leading zero bits in word`                     |
| `rv64_zbb`    | `cpopw`     | `rd, rs1`           | `Count set bits in word`                              |
| `rv64_zbb`    | `ctzw`      | `rd, rs1`           | `Count trailing zero bits in word`                    |
| `rv64_zbb`    | `rev8`      | `rd, rs1`           | `Byte-reverse register`                               |
| `rv64_zbb`    | `rolw`      | `rd, rs1, rs2`      | `Rotate Left Word (Register)`                         |
| `rv64_zbb`    | `rori`      | `rd, rs1, shamtd`   | `Rotate Right (Immediate)`                            |
| `rv64_zbb`    | `roriw`     | `rd, rs1, shamtw`   | `Rotate Right Word by Immediate`                      |
| `rv64_zbb`    | `rorw`      | `rd, rs1, rs2`      | `Rotate Right Word (Register)`                        |
| `rv64_zbkb`   | `packw`     | `rd, rs1, rs2`      | `Pack the low 16-bits of rs1 and rs2 into rd on RV64` |
| `rv64_zbkb`   | `rolw`      | `rd, rs1, rs2`      | `Rotate Left Word (Register)`                         |
| `rv64_zbkb`   | `rori`      | `rd, rs1, shamtd`   | `Rotate Right (Immediate)`                            |
| `rv64_zbkb`   | `roriw`     | `rd, rs1, shamtw`   | `Rotate Right Word by Immediate`                      |
| `rv64_zbkb`   | `rorw`      | `rd, rs1, rs2`      | `Rotate Right Word (Register)`                        |
| `rv64_zbp`    | `xperm32`   | `rd, rs1, rs2`      | `32-Bit Crossbar Permutation`                         |
| `rv64_zbs`    | `bclri`     | `rd, rs1, shamtd`   | `Single-Bit Clear (Immediate)`                        |
| `rv64_zbs`    | `bexti`     | `rd, rs1, shamtd`   | `Single-Bit Extract (Immediate)`                      |
| `rv64_zbs`    | `binvi`     | `rd, rs1, shamtd`   | `Single-Bit Invert (Immediate)`                       |
| `rv64_zbs`    | `bseti`     | `rd, rs1, shamtd`   | `Single-Bit Set (Immediate)`                          |

:RV64ZB - Specific Extension for Bit Instructions (64 bit)
