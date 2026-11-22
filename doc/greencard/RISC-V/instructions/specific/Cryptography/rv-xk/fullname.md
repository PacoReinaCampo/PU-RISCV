## INSTRUCTION FULL-NAMES

| **Extension** | **Name**     | **Variable-Fields** | **Full-Name**                                |
|:--------------|:-------------|:--------------------|:---------------------------------------------|
| `rv_zk`       | `andn`       | `rd, rs1, rs2`      | `AND with inverted operand`                  |
| `rv_zk`       | `clmul`      | `rd, rs1, rs2`      | `Carry-less multiply (low-part)`             |
| `rv_zk`       | `clmulh`     | `rd, rs1, rs2`      | `Carry-less multiply (high-part)`            |
| `rv_zkn`      | `andn`       | `rd, rs1, rs2`      | `AND with inverted operand`                  |
| `rv_zkn`      | `clmul`      | `rd, rs1, rs2`      | `Carry-less multiply (low-part)`             |
| `rv_zkn`      | `clmulh`     | `rd, rs1, rs2`      | `Carry-less multiply (high-part)`            |
| `rv_zknh`     | `sha256sig0` | `rd, rs1`           | `SHA-256 Small Sigma 0`                      |
| `rv_zknh`     | `sha256sig1` | `rd, rs1`           | `SHA-256 Small Sigma 1`                      |
| `rv_zknh`     | `sha256sum0` | `rd, rs1`           | `SHA-256 Big Sigma 0`                        |
| `rv_zknh`     | `sha256sum1` | `rd, rs1`           | `SHA-256 Big Sigma 1`                        |
| `rv_zkn`      | `orn`        | `rd, rs1, rs2`      | `OR with inverted operand`                   |
| `rv_zkn`      | `pack`       | `rd, rs1, rs2`      | `Pack the low halves of rs1 and rs2 into rd` |
| `rv_zkn`      | `packh`      | `rd, rs1, rs2`      | `Pack the low bytes of rs1 and rs2 into rd`  |
| `rv_zkn`      | `rol`        | `rd, rs1, rs2`      | `Rotate Left (Register)`                     |
| `rv_zkn`      | `ror`        | `rd, rs1, rs2`      | `Rotate Right`                               |
| `rv_zkn`      | `sha256sig0` | `rd, rs1`           | `SHA-256 Small Sigma 0`                      |
| `rv_zkn`      | `sha256sig1` | `rd, rs1`           | `SHA-256 Small Sigma 1`                      |
| `rv_zkn`      | `sha256sum0` | `rd, rs1`           | `SHA-256 Big Sigma 0`                        |
| `rv_zkn`      | `sha256sum1` | `rd, rs1`           | `SHA-256 Big Sigma 1`                        |
| `rv_zkn`      | `xnor`       | `rd, rs1, rs2`      | `Exclusive NOR`                              |
| `rv_zkn`      | `xperm4`     | `rd, rs1, rs2`      | `4-Bit Crossbar Permutation`                 |
| `rv_zkn`      | `xperm8`     | `rd, rs1, rs2`      | `8-Bit Crossbar Permutation`                 |
| `rv_zk`       | `orn`        | `rd, rs1, rs2`      | `OR with inverted operand`                   |
| `rv_zk`       | `pack`       | `rd, rs1, rs2`      | `Pack the low halves of rs1 and rs2 into rd` |
| `rv_zk`       | `packh`      | `rd, rs1, rs2`      | `Pack the low bytes of rs1 and rs2 into rd`  |
| `rv_zk`       | `rol`        | `rd, rs1, rs2`      | `Rotate Left (Register)`                     |
| `rv_zk`       | `ror`        | `rd, rs1, rs2`      | `Rotate Right`                               |
| `rv_zks`      | `andn`       | `rd, rs1, rs2`      | `AND with inverted operand`                  |
| `rv_zks`      | `clmul`      | `rd, rs1, rs2`      | `Carry-less multiply (low-part)`             |
| `rv_zks`      | `clmulh`     | `rd, rs1, rs2`      | `Carry-less multiply (high-part)`            |
| `rv_zksed`    | `sm4ed`      | `rd, rs1, rs2, bs`  | `SM4 Encryption and Decryption Step`         |
| `rv_zksed`    | `sm4ks`      | `rd, rs1, rs2, bs`  | `SM4 Key Schedule Step`                      |
| `rv_zk`       | `sha256sig0` | `rd, rs1`           | `SHA-256 Small Sigma 0`                      |
| `rv_zk`       | `sha256sig1` | `rd, rs1`           | `SHA-256 Small Sigma 1`                      |
| `rv_zk`       | `sha256sum0` | `rd, rs1`           | `SHA-256 Big Sigma 0`                        |
| `rv_zk`       | `sha256sum1` | `rd, rs1`           | `SHA-256 Big Sigma 1`                        |
| `rv_zksh`     | `sm3p0`      | `rd, rs1`           | `SM3 P0 Permutation`                         |
| `rv_zksh`     | `sm3p1`      | `rd, rs1`           | `SM3 P1 Permutation`                         |
| `rv_zks`      | `orn`        | `rd, rs1, rs2`      | `OR with inverted operand`                   |
| `rv_zks`      | `pack`       | `rd, rs1, rs2`      | `Pack the low halves of rs1 and rs2 into rd` |
| `rv_zks`      | `packh`      | `rd, rs1, rs2`      | `Pack the low bytes of rs1 and rs2 into rd`  |
| `rv_zks`      | `rol`        | `rd, rs1, rs2`      | `Rotate Left (Register)`                     |
| `rv_zks`      | `ror`        | `rd, rs1, rs2`      | `Rotate Right`                               |
| `rv_zks`      | `sm3p0`      | `rd, rs1`           | `SM3 P0 Permutation`                         |
| `rv_zks`      | `sm3p1`      | `rd, rs1`           | `SM3 P1 Permutation`                         |
| `rv_zks`      | `sm4ed`      | `rd, rs1, rs2, bs`  | `SM4 Encryption and Decryption Step`         |
| `rv_zks`      | `sm4ks`      | `rd, rs1, rs2, bs`  | `SM4 Key Schedule Step`                      |
| `rv_zks`      | `xnor`       | `rd, rs1, rs2`      | `Exclusive NOR`                              |
| `rv_zks`      | `xperm4`     | `rd, rs1, rs2`      | `4-Bit Crossbar Permutation`                 |
| `rv_zks`      | `xperm8`     | `rd, rs1, rs2`      | `8-Bit Crossbar Permutation`                 |
| `rv_zk`       | `xnor`       | `rd, rs1, rs2`      | `Exclusive NOR`                              |
| `rv_zk`       | `xperm4`     | `rd, rs1, rs2`      | `4-Bit Crossbar Permutation`                 |
| `rv_zk`       | `xperm8`     | `rd, rs1, rs2`      | `8-Bit Crossbar Permutation`                 |

:RVZXK - Specific Extension for Scalar Cryptography Instructions

| **Extension** | **Name**      | **Variable-Fields** | **Full-Name**                       |
|:--------------|:--------------|:--------------------|:------------------------------------|
| `rv32_zk`     | `aes32dsi`    | `rd, rs1, rs2, bs`  | `AES-32 Final Round Decryption`     |
| `rv32_zk`     | `aes32dsmi`   | `rd, rs1, rs2, bs`  | `AES-32 Middle Round Decryption`    |
| `rv32_zk`     | `aes32esi`    | `rd, rs1, rs2, bs`  | `AES-32 Final Round Encryption`     |
| `rv32_zk`     | `aes32esmi`   | `rd, rs1, rs2, bs`  | `AES-32 Middle Round Encryption`    |
| `rv32_zkn`    | `aes32dsi`    | `rd, rs1, rs2, bs`  | `AES-32 Final Round Decryption`     |
| `rv32_zkn`    | `aes32dsmi`   | `rd, rs1, rs2, bs`  | `AES-32 Middle Round Decryption`    |
| `rv32_zkn`    | `aes32esi`    | `rd, rs1, rs2, bs`  | `AES-32 Final Round Encryption`     |
| `rv32_zkn`    | `aes32esmi`   | `rd, rs1, rs2, bs`  | `AES-32 Middle Round Encryption`    |
| `rv32_zknd`   | `aes32dsi`    | `rd, rs1, rs2, bs`  | `AES-32 Final Round Decryption`     |
| `rv32_zknd`   | `aes32dsmi`   | `rd, rs1, rs2, bs`  | `AES-32 Middle Round Decryption`    |
| `rv32_zkne`   | `aes32esi`    | `rd, rs1, rs2, bs`  | `AES-32 Final Round Encryption`     |
| `rv32_zkne`   | `aes32esmi`   | `rd, rs1, rs2, bs`  | `AES-32 Middle Round Encryption`    |
| `rv32_zknh`   | `sha512sig0h` | `rd, rs1, rs2`      | `SHA-512 Small Sigma 0 (High Half)` |
| `rv32_zknh`   | `sha512sig0l` | `rd, rs1, rs2`      | `SHA-512 Small Sigma 0 (Low Half)`  |
| `rv32_zknh`   | `sha512sig1h` | `rd, rs1, rs2`      | `SHA-512 Small Sigma 1 (High Half)` |
| `rv32_zknh`   | `sha512sig1l` | `rd, rs1, rs2`      | `SHA-512 Small Sigma 1 (Low Half)`  |
| `rv32_zknh`   | `sha512sum0r` | `rd, rs1, rs2`      | `SHA-512 Big Sigma 0 (RV32 Half)`   |
| `rv32_zknh`   | `sha512sum1r` | `rd, rs1, rs2`      | `SHA-512 Big Sigma 1 (RV32 Half)`   |
| `rv32_zkn`    | `sha512sig0h` | `rd, rs1, rs2`      | `SHA-512 Small Sigma 0 (High Half)` |
| `rv32_zkn`    | `sha512sig0l` | `rd, rs1, rs2`      | `SHA-512 Small Sigma 0 (Low Half)`  |
| `rv32_zkn`    | `sha512sig1h` | `rd, rs1, rs2`      | `SHA-512 Small Sigma 1 (High Half)` |
| `rv32_zkn`    | `sha512sig1l` | `rd, rs1, rs2`      | `SHA-512 Small Sigma 1 (Low Half)`  |
| `rv32_zkn`    | `sha512sum0r` | `rd, rs1, rs2`      | `SHA-512 Big Sigma 0 (RV32 Half)`   |
| `rv32_zkn`    | `sha512sum1r` | `rd, rs1, rs2`      | `SHA-512 Big Sigma 1 (RV32 Half)`   |
| `rv32_zk`     | `sha512sig0h` | `rd, rs1, rs2`      | `SHA-512 Small Sigma 0 (High Half)` |
| `rv32_zk`     | `sha512sig0l` | `rd, rs1, rs2`      | `SHA-512 Small Sigma 0 (Low Half)`  |
| `rv32_zk`     | `sha512sig1h` | `rd, rs1, rs2`      | `SHA-512 Small Sigma 1 (High Half)` |
| `rv32_zk`     | `sha512sig1l` | `rd, rs1, rs2`      | `SHA-512 Small Sigma 1 (Low Half)`  |
| `rv32_zk`     | `sha512sum0r` | `rd, rs1, rs2`      | `SHA-512 Big Sigma 0 (RV32 Half)`   |
| `rv32_zk`     | `sha512sum1r` | `rd, rs1, rs2`      | `SHA-512 Big Sigma 1 (RV32 Half)`   |

:RV32ZXK - Specific Extension for Scalar Cryptography Instructions (32 bit)

| **Extension** | **Name**     | **Variable-Fields** | **Full-Name**                                         |
|:--------------|:-------------|:--------------------|:------------------------------------------------------|
| `rv64_zk`     | `aes64ds`    | `rd, rs1, rs2`      | `AES-64 Final Round Decryption`                       |
| `rv64_zk`     | `aes64dsm`   | `rd, rs1, rs2`      | `AES-64 Middle Round Decryption`                      |
| `rv64_zk`     | `aes64es`    | `rd, rs1, rs2`      | `AES-64 Final Round Encryption`                       |
| `rv64_zk`     | `aes64esm`   | `rd, rs1, rs2`      | `AES-64 Middle Round Encryption`                      |
| `rv64_zk`     | `aes64im`    | `rd, rs1`           | `AES-64 Inverse MixColumns`                           |
| `rv64_zk`     | `aes64ks1i`  | `rd, rs1, rnum`     | `AES-64 Key Schedule Step 1`                          |
| `rv64_zk`     | `aes64ks2`   | `rd, rs1, rs2`      | `AES-64 Key Schedule Step 2`                          |
| `rv64_zkn`    | `aes64ds`    | `rd, rs1, rs2`      | `AES-64 Final Round Decryption`                       |
| `rv64_zkn`    | `aes64dsm`   | `rd, rs1, rs2`      | `AES-64 Middle Round Decryption`                      |
| `rv64_zkn`    | `aes64es`    | `rd, rs1, rs2`      | `AES-64 Final Round Encryption`                       |
| `rv64_zkn`    | `aes64esm`   | `rd, rs1, rs2`      | `AES-64 Middle Round Encryption`                      |
| `rv64_zkn`    | `aes64im`    | `rd, rs1`           | `AES-64 Inverse MixColumns`                           |
| `rv64_zkn`    | `aes64ks1i`  | `rd, rs1, rnum`     | `AES-64 Key Schedule Step 1`                          |
| `rv64_zkn`    | `aes64ks2`   | `rd, rs1, rs2`      | `AES-64 Key Schedule Step 2`                          |
| `rv64_zknd`   | `aes64ds`    | `rd, rs1, rs2`      | `AES-64 Final Round Decryption`                       |
| `rv64_zknd`   | `aes64dsm`   | `rd, rs1, rs2`      | `AES-64 Middle Round Decryption`                      |
| `rv64_zknd`   | `aes64im`    | `rd, rs1`           | `AES-64 Inverse MixColumns`                           |
| `rv64_zknd`   | `aes64ks1i`  | `rd, rs1, rnum`     | `AES-64 Key Schedule Step 1`                          |
| `rv64_zknd`   | `aes64ks2`   | `rd, rs1, rs2`      | `AES-64 Key Schedule Step 2`                          |
| `rv64_zkne`   | `aes64es`    | `rd, rs1, rs2`      | `AES-64 Final Round Encryption`                       |
| `rv64_zkne`   | `aes64esm`   | `rd, rs1, rs2`      | `AES-64 Middle Round Encryption`                      |
| `rv64_zkne`   | `aes64ks1i`  | `rd, rs1, rnum`     | `AES-64 Key Schedule Step 1`                          |
| `rv64_zkne`   | `aes64ks2`   | `rd, rs1, rs2`      | `AES-64 Key Schedule Step 2`                          |
| `rv64_zknh`   | `sha512sig0` | `rd, rs1`           | `SHA-512 Small Sigma 0`                               |
| `rv64_zknh`   | `sha512sig1` | `rd, rs1`           | `SHA-512 Small Sigma 1`                               |
| `rv64_zknh`   | `sha512sum0` | `rd, rs1`           | `SHA-512 Big Sigma 0`                                 |
| `rv64_zknh`   | `sha512sum1` | `rd, rs1`           | `SHA-512 Big Sigma 1`                                 |
| `rv64_zkn`    | `packw`      | `rd, rs1, rs2`      | `Pack the low 16-bits of rs1 and rs2 into rd on RV64` |
| `rv64_zkn`    | `rolw`       | `rd, rs1, rs2`      | `Rotate Left Word (Register)`                         |
| `rv64_zkn`    | `rori`       | `rd, rs1, shamtd`   | `Rotate Right (Immediate)`                            |
| `rv64_zkn`    | `roriw`      | `rd, rs1, shamtw`   | `Rotate Right Word by Immediate`                      |
| `rv64_zkn`    | `rorw`       | `rd, rs1, rs2`      | `Rotate Right Word (Register)`                        |
| `rv64_zkn`    | `sha512sig0` | `rd, rs1`           | `SHA-512 Small Sigma 0`                               |
| `rv64_zkn`    | `sha512sig1` | `rd, rs1`           | `SHA-512 Small Sigma 1`                               |
| `rv64_zkn`    | `sha512sum0` | `rd, rs1`           | `SHA-512 Big Sigma 0`                                 |
| `rv64_zkn`    | `sha512sum1` | `rd, rs1`           | `SHA-512 Big Sigma 1`                                 |
| `rv64_zk`     | `packw`      | `rd, rs1, rs2`      | `Pack the low 16-bits of rs1 and rs2 into rd on RV64` |
| `rv64_zk`     | `rolw`       | `rd, rs1, rs2`      | `Rotate Left Word (Register)`                         |
| `rv64_zk`     | `rori`       | `rd, rs1, shamtd`   | `Rotate Right (Immediate)`                            |
| `rv64_zk`     | `roriw`      | `rd, rs1, shamtw`   | `Rotate Right Word by Immediate`                      |
| `rv64_zk`     | `rorw`       | `rd, rs1, rs2`      | `Rotate Right Word (Register)`                        |
| `rv64_zk`     | `sha512sig0` | `rd, rs1`           | `SHA-512 Small Sigma 0`                               |
| `rv64_zk`     | `sha512sig1` | `rd, rs1`           | `SHA-512 Small Sigma 1`                               |
| `rv64_zk`     | `sha512sum0` | `rd, rs1`           | `SHA-512 Big Sigma 0`                                 |
| `rv64_zk`     | `sha512sum1` | `rd, rs1`           | `SHA-512 Big Sigma 1`                                 |
| `rv64_zks`    | `packw`      | `rd, rs1, rs2`      | `Pack the low 16-bits of rs1 and rs2 into rd on RV64` |
| `rv64_zks`    | `rolw`       | `rd, rs1, rs2`      | `Rotate Left Word (Register)`                         |
| `rv64_zks`    | `rori`       | `rd, rs1, shamtd`   | `Rotate Right (Immediate)`                            |
| `rv64_zks`    | `roriw`      | `rd, rs1, shamtw`   | `Rotate Right Word by Immediate`                      |
| `rv64_zks`    | `rorw`       | `rd, rs1, rs2`      | `Rotate Right Word (Register)`                        |

:RV64ZXK - Specific Extension for Scalar Cryptography Instructions (64 bit)
