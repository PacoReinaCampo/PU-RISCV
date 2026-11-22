## INSTRUCTION CLASSES

| **Extension** | **Name**  | **Variable-Fields** | **Class** |
|:--------------|:----------|:--------------------|:----------|
| `rv_zba`      | `sh1add`  | `rd, rs1, rs2`      | `bit`     |
| `rv_zba`      | `sh2add`  | `rd, rs1, rs2`      | `bit`     |
| `rv_zba`      | `sh3add`  | `rd, rs1, rs2`      | `bit`     |
| `rv_zbb`      | `andn`    | `rd, rs1, rs2`      | `bit`     |
| `rv_zbb`      | `clz`     | `rd, rs1`           | `bit`     |
| `rv_zbb`      | `cpop`    | `rd, rs1`           | `bit`     |
| `rv_zbb`      | `ctz`     | `rd, rs1`           | `bit`     |
| `rv_zbb`      | `max`     | `rd, rs1, rs2`      | `bit`     |
| `rv_zbb`      | `maxu`    | `rd, rs1, rs2`      | `bit`     |
| `rv_zbb`      | `min`     | `rd, rs1, rs2`      | `bit`     |
| `rv_zbb`      | `minu`    | `rd, rs1, rs2`      | `bit`     |
| `rv_zbb`      | `orc_b`   | `rd, rs1`           | `bit`     |
| `rv_zbb`      | `orn`     | `rd, rs1, rs2`      | `bit`     |
| `rv_zbb`      | `rol`     | `rd, rs1, rs2`      | `bit`     |
| `rv_zbb`      | `ror`     | `rd, rs1, rs2`      | `bit`     |
| `rv_zbb`      | `sext_b`  | `rd, rs1`           | `bit`     |
| `rv_zbb`      | `sext_h`  | `rd, rs1`           | `bit`     |
| `rv_zbb`      | `xnor`    | `rd, rs1, rs2`      | `bit`     |
| `rv_zbc`      | `clmul`   | `rd, rs1, rs2`      | `bit`     |
| `rv_zbc`      | `clmulh`  | `rd, rs1, rs2`      | `bit`     |
| `rv_zbc`      | `clmulr`  | `rd, rs1, rs2`      | `bit`     |
| `rv_zbkb`     | `andn`    | `rd, rs1, rs2`      | `bit`     |
| `rv_zbkb`     | `brev8`   | `rd, rs1`           | `bit`     |
| `rv_zbkb`     | `orn`     | `rd, rs1, rs2`      | `bit`     |
| `rv_zbkb`     | `pack`    | `rd, rs1, rs2`      | `bit`     |
| `rv_zbkb`     | `packh`   | `rd, rs1, rs2`      | `bit`     |
| `rv_zbkb`     | `rol`     | `rd, rs1, rs2`      | `bit`     |
| `rv_zbkb`     | `ror`     | `rd, rs1, rs2`      | `bit`     |
| `rv_zbkb`     | `xnor`    | `rd, rs1, rs2`      | `bit`     |
| `rv_zbkc`     | `clmul`   | `rd, rs1, rs2`      | `bit`     |
| `rv_zbkc`     | `clmulh`  | `rd, rs1, rs2`      | `bit`     |
| `rv_zbkx`     | `xperm4`  | `rd, rs1, rs2`      | `bit`     |
| `rv_zbkx`     | `xperm8`  | `rd, rs1, rs2`      | `bit`     |
| `rv_zbp`      | `xperm16` | `rd, rs1, rs2`      | `bit`     |
| `rv_zbs`      | `bclr`    | `rd, rs1, rs2`      | `bit`     |
| `rv_zbs`      | `bext`    | `rd, rs1, rs2`      | `bit`     |
| `rv_zbs`      | `binv`    | `rd, rs1, rs2`      | `bit`     |
| `rv_zbs`      | `bset`    | `rd, rs1, rs2`      | `bit`     |

:RVZB - Specific Extension for Bit Instructions

| **Extension** | **Name**    | **Variable-Fields** | **Class** |
|:--------------|:------------|:--------------------|:----------|
| `rv32_zbkb`   | `rev8_rv32` | `rd, rs1`           | `bit`     |
| `rv32_zbkb`   | `unzip`     | `rd, rs1`           | `bit`     |
| `rv32_zbkb`   | `zip`       | `rd, rs1`           | `bit`     |

:RV32ZB - Specific Extension for Bit Instructions (32 bit)

| **Extension** | **Name**    | **Variable-Fields** | **Class** |
|:--------------|:------------|:--------------------|:----------|
| `rv64_zba`    | `add_uw`    | `rd, rs1, rs2`      | `bit`     |
| `rv64_zba`    | `sh1add_uw` | `rd, rs1, rs2`      | `bit`     |
| `rv64_zba`    | `sh2add_uw` | `rd, rs1, rs2`      | `bit`     |
| `rv64_zba`    | `sh3add_uw` | `rd, rs1, rs2`      | `bit`     |
| `rv64_zba`    | `slli_uw`   | `rd, rs1, shamtd`   | `bit`     |
| `rv64_zbb`    | `clzw`      | `rd, rs1`           | `bit`     |
| `rv64_zbb`    | `cpopw`     | `rd, rs1`           | `bit`     |
| `rv64_zbb`    | `ctzw`      | `rd, rs1`           | `bit`     |
| `rv64_zbb`    | `rev8`      | `rd, rs1`           | `bit`     |
| `rv64_zbb`    | `rolw`      | `rd, rs1, rs2`      | `bit`     |
| `rv64_zbb`    | `rori`      | `rd, rs1, shamtd`   | `bit`     |
| `rv64_zbb`    | `roriw`     | `rd, rs1, shamtw`   | `bit`     |
| `rv64_zbb`    | `rorw`      | `rd, rs1, rs2`      | `bit`     |
| `rv64_zbkb`   | `packw`     | `rd, rs1, rs2`      | `bit`     |
| `rv64_zbkb`   | `rolw`      | `rd, rs1, rs2`      | `bit`     |
| `rv64_zbkb`   | `rori`      | `rd, rs1, shamtd`   | `bit`     |
| `rv64_zbkb`   | `roriw`     | `rd, rs1, shamtw`   | `bit`     |
| `rv64_zbkb`   | `rorw`      | `rd, rs1, rs2`      | `bit`     |
| `rv64_zbp`    | `xperm32`   | `rd, rs1, rs2`      | `bit`     |
| `rv64_zbs`    | `bclri`     | `rd, rs1, shamtd`   | `bit`     |
| `rv64_zbs`    | `bexti`     | `rd, rs1, shamtd`   | `bit`     |
| `rv64_zbs`    | `binvi`     | `rd, rs1, shamtd`   | `bit`     |
| `rv64_zbs`    | `bseti`     | `rd, rs1, shamtd`   | `bit`     |

:RV64ZB - Specific Extension for Bit Instructions (64 bit)
