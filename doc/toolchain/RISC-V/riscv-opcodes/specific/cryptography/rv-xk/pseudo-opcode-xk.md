## PSEUDO-INSTRUCTIONS

| **Extension** | **Name** | **Variable-Fields** | **Pseudo-Instruction** | **Encoding**                       |
|:--------------|:---------|:--------------------|:-----------------------|:-----------------------------------|
| `rv_zbkb`     | `brev8`  | `rd, rs1`           | `brev8`                | `011010000111-----101-----0010011` |

:RVZXK - RVZXK Specific Extension for Scalar Cryptography Instructions

| **Extension** | **Name**    | **Variable-Fields** | **Pseudo-Instruction** | **Encoding**                       |
|:--------------|:------------|:--------------------|:-----------------------|:-----------------------------------|
| `rv32_zbkb`   | `zip`       | `rd, rs1`           | `zip`                  | `000010001111-----001-----0010011` |
| `rv32_zbkb`   | `unzip`     | `rd, rs1`           | `unzip`                | `000010001111-----101-----0010011` |
| `rv32_zbkb`   | `rev8_rv32` | `rd, rs1`           | `rev8_rv32`            | `011010011000-----101-----0010011` |

:RV32ZXK - RV32ZXK Specific Extension for Scalar Cryptography Instructions

| **Extension** | **Name** | **Variable-Fields** | **Pseudo-Instruction** | **Encoding**                       |
|:--------------|:---------|:--------------------|:-----------------------|:-----------------------------------|
| `rv64_zbb`    | `rev8`   | `rd, rs1`           | `rev8`                 | `011010111000-----101-----0010011` |
| `rv64_zbb`    | `rori`   | `rd, rs1, shamtw`   | `rori_rv32`            | `0110000----------101-----0010011` |

:RV64ZXK - RV64ZXK Specific Extension for Scalar Cryptography Instructions (+ RV32ZXK)
