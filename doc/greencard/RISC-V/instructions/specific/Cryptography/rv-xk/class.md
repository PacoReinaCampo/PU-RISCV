## INSTRUCTION CLASSES

| **Extension** | **Name**     | **Variable-Fields** | **Class**      |
|:--------------|:-------------|:--------------------|:---------------|
| `rv_zk`       | `andn`       | `rd, rs1, rs2`      | `cryptography` |
| `rv_zk`       | `clmul`      | `rd, rs1, rs2`      | `cryptography` |
| `rv_zk`       | `clmulh`     | `rd, rs1, rs2`      | `cryptography` |
| `rv_zkn`      | `andn`       | `rd, rs1, rs2`      | `cryptography` |
| `rv_zkn`      | `clmul`      | `rd, rs1, rs2`      | `cryptography` |
| `rv_zkn`      | `clmulh`     | `rd, rs1, rs2`      | `cryptography` |
| `rv_zknh`     | `sha256sig0` | `rd, rs1`           | `cryptography` |
| `rv_zknh`     | `sha256sig1` | `rd, rs1`           | `cryptography` |
| `rv_zknh`     | `sha256sum0` | `rd, rs1`           | `cryptography` |
| `rv_zknh`     | `sha256sum1` | `rd, rs1`           | `cryptography` |
| `rv_zkn`      | `orn`        | `rd, rs1, rs2`      | `cryptography` |
| `rv_zkn`      | `pack`       | `rd, rs1, rs2`      | `cryptography` |
| `rv_zkn`      | `packh`      | `rd, rs1, rs2`      | `cryptography` |
| `rv_zkn`      | `rol`        | `rd, rs1, rs2`      | `cryptography` |
| `rv_zkn`      | `ror`        | `rd, rs1, rs2`      | `cryptography` |
| `rv_zkn`      | `sha256sig0` | `rd, rs1`           | `cryptography` |
| `rv_zkn`      | `sha256sig1` | `rd, rs1`           | `cryptography` |
| `rv_zkn`      | `sha256sum0` | `rd, rs1`           | `cryptography` |
| `rv_zkn`      | `sha256sum1` | `rd, rs1`           | `cryptography` |
| `rv_zkn`      | `xnor`       | `rd, rs1, rs2`      | `cryptography` |
| `rv_zkn`      | `xperm4`     | `rd, rs1, rs2`      | `cryptography` |
| `rv_zkn`      | `xperm8`     | `rd, rs1, rs2`      | `cryptography` |
| `rv_zk`       | `orn`        | `rd, rs1, rs2`      | `cryptography` |
| `rv_zk`       | `pack`       | `rd, rs1, rs2`      | `cryptography` |
| `rv_zk`       | `packh`      | `rd, rs1, rs2`      | `cryptography` |
| `rv_zk`       | `rol`        | `rd, rs1, rs2`      | `cryptography` |
| `rv_zk`       | `ror`        | `rd, rs1, rs2`      | `cryptography` |
| `rv_zks`      | `andn`       | `rd, rs1, rs2`      | `cryptography` |
| `rv_zks`      | `clmul`      | `rd, rs1, rs2`      | `cryptography` |
| `rv_zks`      | `clmulh`     | `rd, rs1, rs2`      | `cryptography` |
| `rv_zksed`    | `sm4ed`      | `rd, rs1, rs2, bs`  | `cryptography` |
| `rv_zksed`    | `sm4ks`      | `rd, rs1, rs2, bs`  | `cryptography` |
| `rv_zk`       | `sha256sig0` | `rd, rs1`           | `cryptography` |
| `rv_zk`       | `sha256sig1` | `rd, rs1`           | `cryptography` |
| `rv_zk`       | `sha256sum0` | `rd, rs1`           | `cryptography` |
| `rv_zk`       | `sha256sum1` | `rd, rs1`           | `cryptography` |
| `rv_zksh`     | `sm3p0`      | `rd, rs1`           | `cryptography` |
| `rv_zksh`     | `sm3p1`      | `rd, rs1`           | `cryptography` |
| `rv_zks`      | `orn`        | `rd, rs1, rs2`      | `cryptography` |
| `rv_zks`      | `pack`       | `rd, rs1, rs2`      | `cryptography` |
| `rv_zks`      | `packh`      | `rd, rs1, rs2`      | `cryptography` |
| `rv_zks`      | `rol`        | `rd, rs1, rs2`      | `cryptography` |
| `rv_zks`      | `ror`        | `rd, rs1, rs2`      | `cryptography` |
| `rv_zks`      | `sm3p0`      | `rd, rs1`           | `cryptography` |
| `rv_zks`      | `sm3p1`      | `rd, rs1`           | `cryptography` |
| `rv_zks`      | `sm4ed`      | `rd, rs1, rs2, bs`  | `cryptography` |
| `rv_zks`      | `sm4ks`      | `rd, rs1, rs2, bs`  | `cryptography` |
| `rv_zks`      | `xnor`       | `rd, rs1, rs2`      | `cryptography` |
| `rv_zks`      | `xperm4`     | `rd, rs1, rs2`      | `cryptography` |
| `rv_zks`      | `xperm8`     | `rd, rs1, rs2`      | `cryptography` |
| `rv_zk`       | `xnor`       | `rd, rs1, rs2`      | `cryptography` |
| `rv_zk`       | `xperm4`     | `rd, rs1, rs2`      | `cryptography` |
| `rv_zk`       | `xperm8`     | `rd, rs1, rs2`      | `cryptography` |

:RVZXK - Specific Extension for Scalar Cryptography Instructions

| **Extension** | **Name**      | **Variable-Fields** | **Class**      |
|:--------------|:--------------|:--------------------|:---------------|
| `rv32_zk`     | `aes32dsi`    | `rd, rs1, rs2, bs`  | `cryptography` |
| `rv32_zk`     | `aes32dsmi`   | `rd, rs1, rs2, bs`  | `cryptography` |
| `rv32_zk`     | `aes32esi`    | `rd, rs1, rs2, bs`  | `cryptography` |
| `rv32_zk`     | `aes32esmi`   | `rd, rs1, rs2, bs`  | `cryptography` |
| `rv32_zkn`    | `aes32dsi`    | `rd, rs1, rs2, bs`  | `cryptography` |
| `rv32_zkn`    | `aes32dsmi`   | `rd, rs1, rs2, bs`  | `cryptography` |
| `rv32_zkn`    | `aes32esi`    | `rd, rs1, rs2, bs`  | `cryptography` |
| `rv32_zkn`    | `aes32esmi`   | `rd, rs1, rs2, bs`  | `cryptography` |
| `rv32_zknd`   | `aes32dsi`    | `rd, rs1, rs2, bs`  | `cryptography` |
| `rv32_zknd`   | `aes32dsmi`   | `rd, rs1, rs2, bs`  | `cryptography` |
| `rv32_zkne`   | `aes32esi`    | `rd, rs1, rs2, bs`  | `cryptography` |
| `rv32_zkne`   | `aes32esmi`   | `rd, rs1, rs2, bs`  | `cryptography` |
| `rv32_zknh`   | `sha512sig0h` | `rd, rs1, rs2`      | `cryptography` |
| `rv32_zknh`   | `sha512sig0l` | `rd, rs1, rs2`      | `cryptography` |
| `rv32_zknh`   | `sha512sig1h` | `rd, rs1, rs2`      | `cryptography` |
| `rv32_zknh`   | `sha512sig1l` | `rd, rs1, rs2`      | `cryptography` |
| `rv32_zknh`   | `sha512sum0r` | `rd, rs1, rs2`      | `cryptography` |
| `rv32_zknh`   | `sha512sum1r` | `rd, rs1, rs2`      | `cryptography` |
| `rv32_zkn`    | `sha512sig0h` | `rd, rs1, rs2`      | `cryptography` |
| `rv32_zkn`    | `sha512sig0l` | `rd, rs1, rs2`      | `cryptography` |
| `rv32_zkn`    | `sha512sig1h` | `rd, rs1, rs2`      | `cryptography` |
| `rv32_zkn`    | `sha512sig1l` | `rd, rs1, rs2`      | `cryptography` |
| `rv32_zkn`    | `sha512sum0r` | `rd, rs1, rs2`      | `cryptography` |
| `rv32_zkn`    | `sha512sum1r` | `rd, rs1, rs2`      | `cryptography` |
| `rv32_zk`     | `sha512sig0h` | `rd, rs1, rs2`      | `cryptography` |
| `rv32_zk`     | `sha512sig0l` | `rd, rs1, rs2`      | `cryptography` |
| `rv32_zk`     | `sha512sig1h` | `rd, rs1, rs2`      | `cryptography` |
| `rv32_zk`     | `sha512sig1l` | `rd, rs1, rs2`      | `cryptography` |
| `rv32_zk`     | `sha512sum0r` | `rd, rs1, rs2`      | `cryptography` |
| `rv32_zk`     | `sha512sum1r` | `rd, rs1, rs2`      | `cryptography` |

:RV32ZXK - Specific Extension for Scalar Cryptography Instructions (32 bit)

| **Extension** | **Name**     | **Variable-Fields** | **Class**      |
|:--------------|:-------------|:--------------------|:---------------|
| `rv64_zk`     | `aes64ds`    | `rd, rs1, rs2`      | `cryptography` |
| `rv64_zk`     | `aes64dsm`   | `rd, rs1, rs2`      | `cryptography` |
| `rv64_zk`     | `aes64es`    | `rd, rs1, rs2`      | `cryptography` |
| `rv64_zk`     | `aes64esm`   | `rd, rs1, rs2`      | `cryptography` |
| `rv64_zk`     | `aes64im`    | `rd, rs1`           | `cryptography` |
| `rv64_zk`     | `aes64ks1i`  | `rd, rs1, rnum`     | `cryptography` |
| `rv64_zk`     | `aes64ks2`   | `rd, rs1, rs2`      | `cryptography` |
| `rv64_zkn`    | `aes64ds`    | `rd, rs1, rs2`      | `cryptography` |
| `rv64_zkn`    | `aes64dsm`   | `rd, rs1, rs2`      | `cryptography` |
| `rv64_zkn`    | `aes64es`    | `rd, rs1, rs2`      | `cryptography` |
| `rv64_zkn`    | `aes64esm`   | `rd, rs1, rs2`      | `cryptography` |
| `rv64_zkn`    | `aes64im`    | `rd, rs1`           | `cryptography` |
| `rv64_zkn`    | `aes64ks1i`  | `rd, rs1, rnum`     | `cryptography` |
| `rv64_zkn`    | `aes64ks2`   | `rd, rs1, rs2`      | `cryptography` |
| `rv64_zknd`   | `aes64ds`    | `rd, rs1, rs2`      | `cryptography` |
| `rv64_zknd`   | `aes64dsm`   | `rd, rs1, rs2`      | `cryptography` |
| `rv64_zknd`   | `aes64im`    | `rd, rs1`           | `cryptography` |
| `rv64_zknd`   | `aes64ks1i`  | `rd, rs1, rnum`     | `cryptography` |
| `rv64_zknd`   | `aes64ks2`   | `rd, rs1, rs2`      | `cryptography` |
| `rv64_zkne`   | `aes64es`    | `rd, rs1, rs2`      | `cryptography` |
| `rv64_zkne`   | `aes64esm`   | `rd, rs1, rs2`      | `cryptography` |
| `rv64_zkne`   | `aes64ks1i`  | `rd, rs1, rnum`     | `cryptography` |
| `rv64_zkne`   | `aes64ks2`   | `rd, rs1, rs2`      | `cryptography` |
| `rv64_zknh`   | `sha512sig0` | `rd, rs1`           | `cryptography` |
| `rv64_zknh`   | `sha512sig1` | `rd, rs1`           | `cryptography` |
| `rv64_zknh`   | `sha512sum0` | `rd, rs1`           | `cryptography` |
| `rv64_zknh`   | `sha512sum1` | `rd, rs1`           | `cryptography` |
| `rv64_zkn`    | `packw`      | `rd, rs1, rs2`      | `cryptography` |
| `rv64_zkn`    | `rolw`       | `rd, rs1, rs2`      | `cryptography` |
| `rv64_zkn`    | `rori`       | `rd, rs1, shamtd`   | `cryptography` |
| `rv64_zkn`    | `roriw`      | `rd, rs1, shamtw`   | `cryptography` |
| `rv64_zkn`    | `rorw`       | `rd, rs1, rs2`      | `cryptography` |
| `rv64_zkn`    | `sha512sig0` | `rd, rs1`           | `cryptography` |
| `rv64_zkn`    | `sha512sig1` | `rd, rs1`           | `cryptography` |
| `rv64_zkn`    | `sha512sum0` | `rd, rs1`           | `cryptography` |
| `rv64_zkn`    | `sha512sum1` | `rd, rs1`           | `cryptography` |
| `rv64_zk`     | `packw`      | `rd, rs1, rs2`      | `cryptography` |
| `rv64_zk`     | `rolw`       | `rd, rs1, rs2`      | `cryptography` |
| `rv64_zk`     | `rori`       | `rd, rs1, shamtd`   | `cryptography` |
| `rv64_zk`     | `roriw`      | `rd, rs1, shamtw`   | `cryptography` |
| `rv64_zk`     | `rorw`       | `rd, rs1, rs2`      | `cryptography` |
| `rv64_zk`     | `sha512sig0` | `rd, rs1`           | `cryptography` |
| `rv64_zk`     | `sha512sig1` | `rd, rs1`           | `cryptography` |
| `rv64_zk`     | `sha512sum0` | `rd, rs1`           | `cryptography` |
| `rv64_zk`     | `sha512sum1` | `rd, rs1`           | `cryptography` |
| `rv64_zks`    | `packw`      | `rd, rs1, rs2`      | `cryptography` |
| `rv64_zks`    | `rolw`       | `rd, rs1, rs2`      | `cryptography` |
| `rv64_zks`    | `rori`       | `rd, rs1, shamtd`   | `cryptography` |
| `rv64_zks`    | `roriw`      | `rd, rs1, shamtw`   | `cryptography` |
| `rv64_zks`    | `rorw`       | `rd, rs1, rs2`      | `cryptography` |

:RV64ZXK - Specific Extension for Scalar Cryptography Instructions (64 bit)
