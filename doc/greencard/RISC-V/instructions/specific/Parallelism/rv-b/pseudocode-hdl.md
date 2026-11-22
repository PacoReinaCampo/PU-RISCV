## INSTRUCTION PSEUDO-CODE (HDL)

| **Extension** | **Name**  | **Variable-Fields** | **Pseudo-Code**                                                                                                                                       |
|:--------------|:----------|:--------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------|
| `rv_zba`      | `sh1add`  | `rd, rs1, rs2`      | `rd = rs2 + (rs1 << 1);`                                                                                                                              |
| `rv_zba`      | `sh2add`  | `rd, rs1, rs2`      | `rd = rs2 + (rs1 << 2);`                                                                                                                              |
| `rv_zba`      | `sh3add`  | `rd, rs1, rs2`      | `rd = rs2 + (rs1 << 3);`                                                                                                                              |
| `rv_zbb`      | `andn`    | `rd, rs1, rs2`      | `rd = rs1 & ~rs2;`                                                                                                                                    |
| `rv_zbb`      | `clz`     | `rd, rs1`           | `rd = count_leading_zeros(rs1);`                                                                                                                      |
| `rv_zbb`      | `cpop`    | `rd, rs1`           | `rd = count_ones(rs1);`                                                                                                                               |
| `rv_zbb`      | `ctz`     | `rd, rs1`           | `rd = count_trailing_zeros(rs1);`                                                                                                                     |
| `rv_zbb`      | `max`     | `rd, rs1, rs2`      | `rd = (sx(rs1) > sx(rs2)) ? rs1 : rs2;`                                                                                                               |
| `rv_zbb`      | `maxu`    | `rd, rs1, rs2`      | `rd = (ux(rs1) > ux(rs2)) ? rs1 : rs2;`                                                                                                               |
| `rv_zbb`      | `min`     | `rd, rs1, rs2`      | `rd = (sx(rs1) < sx(rs2)) ? rs1 : rs2;`                                                                                                               |
| `rv_zbb`      | `minu`    | `rd, rs1, rs2`      | `rd = (ux(rs1) < ux(rs2)) ? rs1 : rs2;`                                                                                                               |
| `rv_zbb`      | `orc_b`   | `rd, rs1`           | `for (i = 0; i < XLEN/8; i = i + 1) begin result[8*i +: 8] = rs1[8*i +: 8] != 0 ? 8'hff : 0; end rd = result;`                                        |
| `rv_zbb`      | `orn`     | `rd, rs1, rs2`      | `rd = rs1 \| ~rs2;`                                                                                                                                   |
| `rv_zbb`      | `rol`     | `rd, rs1, rs2`      | `rd = rotate_left(rs1, rs2 & (XLEN - 1), XLEN);`                                                                                                      |
| `rv_zbb`      | `ror`     | `rd, rs1, rs2`      | `rd = rotate_right(rs1, rs2 & (XLEN - 1), XLEN);`                                                                                                     |
| `rv_zbb`      | `sext_b`  | `rd, rs1`           | `rd = EXTS(rs1[7:0]);`                                                                                                                                |
| `rv_zbb`      | `sext_h`  | `rd, rs1`           | `rd = EXTS(rs1[15:0]);`                                                                                                                               |
| `rv_zbb`      | `xnor`    | `rd, rs1, rs2`      | `rd = ~(rs1 ^ rs2);`                                                                                                                                  |
| `rv_zbc`      | `clmul`   | `rd, rs1, rs2`      | `result = 0; for (i = 0; i < XLEN; i = i + 1) begin if (rs2[i]) result = result ^ (rs1 << i); end rd = result;`                                       |
| `rv_zbc`      | `clmulh`  | `rd, rs1, rs2`      | `result = 0; for (i = 1; i < XLEN; i = i + 1) begin if (rs2[i]) result = result ^ (rs1 >> (XLEN - i)); end rd = result;`                              |
| `rv_zbc`      | `clmulr`  | `rd, rs1, rs2`      | `result = 0; for (i = 0; i < XLEN; i = i + 1) begin if (rs2[i]) result = result ^ (rs1 >> (XLEN - 1 - i)); end rd = result;`                          |
| `rv_zbkb`     | `andn`    | `rd, rs1, rs2`      | `rd = rs1 & ~rs2;`                                                                                                                                    |
| `rv_zbkb`     | `brev8`   | `rd, rs1`           | `for (i = 0; i < XLEN/8; i = i + 1) begin for (j = 0; j <= 7; j = j + 1) begin result[8*i+j] = rs1[8*i+7-j]; end end rd = result;`                    |
| `rv_zbkb`     | `orn`     | `rd, rs1, rs2`      | `rd = rs1 \| ~rs2;`                                                                                                                                   |
| `rv_zbkb`     | `pack`    | `rd, rs1, rs2`      | `lo_half = rs1[XLEN/2-1:0]; hi_half = rs2[XLEN/2-1:0]; rd = EXTZ({hi_half, lo_half});`                                                                |
| `rv_zbkb`     | `packh`   | `rd, rs1, rs2`      | `lo_half = rs1[7:0]; hi_half = rs2[7:0]; rd = EXTZ({hi_half, lo_half});`                                                                              |
| `rv_zbkb`     | `rol`     | `rd, rs1, rs2`      | `rd = rotate_left(rs1, rs2 & (XLEN - 1), XLEN);`                                                                                                      |
| `rv_zbkb`     | `ror`     | `rd, rs1, rs2`      | `rd = rotate_right(rs1, rs2 & (XLEN - 1), XLEN);`                                                                                                     |
| `rv_zbkb`     | `xnor`    | `rd, rs1, rs2`      | `rd = ~(rs1 ^ rs2);`                                                                                                                                  |
| `rv_zbkc`     | `clmul`   | `rd, rs1, rs2`      | `result = 0; for (i = 0; i < XLEN; i = i + 1) begin if (rs2[i]) result = result ^ (rs1 << i); end rd = result;`                                       |
| `rv_zbkc`     | `clmulh`  | `rd, rs1, rs2`      | `result = 0; for (i = 1; i < XLEN; i = i + 1) begin if (rs2[i]) result = result ^ (rs1 >> (XLEN - i)); end rd = result;`                              |
| `rv_zbkx`     | `xperm4`  | `rd, rs1, rs2`      | `for (i = 0; i <= XLEN - 4; i = i + 4) begin index = rs2[i +: 4]; result[i +: 4] = index < XLEN / 4 ? rs1[4*index +: 4] : 0; end rd = result;`        |
| `rv_zbkx`     | `xperm8`  | `rd, rs1, rs2`      | `for (i = 0; i <= XLEN - 8; i = i + 8) begin index = rs2[i +: 8]; result[i +: 8] = index < XLEN / 8 ? rs1[8*index +: 8] : 0; end rd = result;`        |
| `rv_zbp`      | `xperm16` | `rd, rs1, rs2`      | `for (i = 0; i <= XLEN - 16; i = i + 16) begin index = rs2[i +: 16]; result[i +: 16] = index < XLEN / 16 ? rs1[16*index +: 16] : 0; end rd = result;` |
| `rv_zbs`      | `bclr`    | `rd, rs1, rs2`      | `rd = rs1 & ~(1 << (rs2 & (XLEN - 1)));`                                                                                                              |
| `rv_zbs`      | `bext`    | `rd, rs1, rs2`      | `rd = (rs1 >> (rs2 & (XLEN - 1))) & 1;`                                                                                                               |
| `rv_zbs`      | `binv`    | `rd, rs1, rs2`      | `rd = rs1 ^ (1 << (rs2 & (XLEN - 1)));`                                                                                                               |
| `rv_zbs`      | `bset`    | `rd, rs1, rs2`      | `rd = rs1 \| (1 << (rs2 & (XLEN - 1)));`                                                                                                              |

:RVZB - Specific Extension for Bit Instructions

| **Extension** | **Name**    | **Variable-Fields** | **Pseudo-Code**                                                                                                  |
|:--------------|:------------|:--------------------|:-----------------------------------------------------------------------------------------------------------------|
| `rv32_zbkb`   | `rev8_rv32` | `rd, rs1`           | `for (i = 0; i < XLEN/8; i = i + 1) begin result[8*i +: 8] = rs1[XLEN-8*i-8 +: 8]; end rd = result;`             |
| `rv32_zbkb`   | `unzip`     | `rd, rs1`           | `for (i = 0; i < XLEN/2; i = i + 1) begin result[i] = rs1[2*i]; result[i+XLEN/2] = rs1[2*i+1]; end rd = result;` |
| `rv32_zbkb`   | `zip`       | `rd, rs1`           | `for (i = 0; i < XLEN/2; i = i + 1) begin result[2*i] = rs1[i]; result[2*i+1] = rs1[i+XLEN/2]; end rd = result;` |

:RV32ZB - Specific Extension for Bit Instructions (32 bit)

| **Extension** | **Name**    | **Variable-Fields** | **Pseudo-Code**                                                                                                                                       |
|:--------------|:------------|:--------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------|
| `rv64_zba`    | `add_uw`    | `rd, rs1, rs2`      | `base = rs2; index = EXTZ(rs1[31:0]); rd = base + index;`                                                                                             |
| `rv64_zba`    | `sh1add_uw` | `rd, rs1, rs2`      | `base = rs2; index = EXTZ(rs1[31:0]); rd = base + (index << 1);`                                                                                      |
| `rv64_zba`    | `sh2add_uw` | `rd, rs1, rs2`      | `base = rs2; index = EXTZ(rs1[31:0]); rd = base + (index << 2);`                                                                                      |
| `rv64_zba`    | `sh3add_uw` | `rd, rs1, rs2`      | `base = rs2; index = EXTZ(rs1[31:0]); rd = base + (index << 3);`                                                                                      |
| `rv64_zba`    | `slli_uw`   | `rd, rs1, shamtd`   | `rd = (EXTZ(rs1[31:0]) << shamtd);`                                                                                                                   |
| `rv64_zbb`    | `clzw`      | `rd, rs1`           | `rd = count_leading_zeros(rs1[31:0]);`                                                                                                                |
| `rv64_zbb`    | `cpopw`     | `rd, rs1`           | `rd = count_ones(rs1[31:0]);`                                                                                                                         |
| `rv64_zbb`    | `ctzw`      | `rd, rs1`           | `rd = count_trailing_zeros(rs1[31:0]);`                                                                                                               |
| `rv64_zbb`    | `rev8`      | `rd, rs1`           | `for (i = 0; i < XLEN/8; i = i + 1) begin result[8*i +: 8] = rs1[XLEN-8*i-8 +: 8]; end rd = result;`                                                  |
| `rv64_zbb`    | `rolw`      | `rd, rs1, rs2`      | `rd = sx(s32(rotate_left(rs1[31:0], rs2 & (32 - 1), 32)));`                                                                                           |
| `rv64_zbb`    | `rori`      | `rd, rs1, shamtd`   | `rd = rotate_right(rs1, shamtd & (XLEN - 1), XLEN);`                                                                                                  |
| `rv64_zbb`    | `roriw`     | `rd, rs1, shamtw`   | `rd = sx(s32(rotate_right(rs1[31:0], shamtw & (32 - 1), 32)));`                                                                                       |
| `rv64_zbb`    | `rorw`      | `rd, rs1, rs2`      | `rd = sx(s32(rotate_right(rs1[31:0], rs2 & (32 - 1), 32)));`                                                                                          |
| `rv64_zbkb`   | `packw`     | `rd, rs1, rs2`      | `lo_half = rs1[15:0]; hi_half = rs2[15:0]; rd = EXTS({hi_half, lo_half});`                                                                            |
| `rv64_zbkb`   | `rolw`      | `rd, rs1, rs2`      | `rd = sx(s32(rotate_left(rs1[31:0], rs2 & (32 - 1), 32)));`                                                                                           |
| `rv64_zbkb`   | `rori`      | `rd, rs1, shamtd`   | `rd = rotate_right(rs1, shamtd & (XLEN - 1), XLEN);`                                                                                                  |
| `rv64_zbkb`   | `roriw`     | `rd, rs1, shamtw`   | `rd = sx(s32(rotate_right(rs1[31:0], shamtw & (32 - 1), 32)));`                                                                                       |
| `rv64_zbkb`   | `rorw`      | `rd, rs1, rs2`      | `rd = sx(s32(rotate_right(rs1[31:0], rs2 & (32 - 1), 32)));`                                                                                          |
| `rv64_zbp`    | `xperm32`   | `rd, rs1, rs2`      | `for (i = 0; i <= XLEN - 32; i = i + 32) begin index = rs2[i +: 32]; result[i +: 32] = index < XLEN / 32 ? rs1[32*index +: 32] : 0; end rd = result;` |
| `rv64_zbs`    | `bclri`     | `rd, rs1, shamtd`   | `rd = rs1 & ~(1 << (shamtd & (XLEN - 1)));`                                                                                                           |
| `rv64_zbs`    | `bexti`     | `rd, rs1, shamtd`   | `rd = (rs1 >> (shamtd & (XLEN - 1))) & 1;`                                                                                                            |
| `rv64_zbs`    | `binvi`     | `rd, rs1, shamtd`   | `rd = rs1 ^ (1 << (shamtd & (XLEN - 1)));`                                                                                                            |
| `rv64_zbs`    | `bseti`     | `rd, rs1, shamtd`   | `rd = rs1 \| (1 << (shamtd & (XLEN - 1)));`                                                                                                           |

:RV64ZB - Specific Extension for Bit Instructions (64 bit)
