# LOGICAL Instructions

| **Name**  | **Format**  | **Type**  | **Extension** | **Format-Extension** |
|:----------|:------------|:----------|:--------------|:---------------------|
| `GORC`    | `R_FORMAT`  | `LOGICAL` | `RV32B`       | `none`               |
| `GORCI`   | `I_FORMAT`  | `LOGICAL` | `RV32B`       | `UIMM`               |
| `CMIX`    | `R4_FORMAT` | `LOGICAL` | `RV32B`       | `none`               |
| `CMOV`    | `R4_FORMAT` | `LOGICAL` | `RV32B`       | `none`               |
| `PACK`    | `R_FORMAT`  | `LOGICAL` | `RV32B`       | `none`               |
| `PACKU`   | `R_FORMAT`  | `LOGICAL` | `RV32B`       | `none`               |
| `PACKH`   | `R_FORMAT`  | `LOGICAL` | `RV32B`       | `none`               |
| `XPERM_N` | `R_FORMAT`  | `LOGICAL` | `RV32B`       | `none`               |
| `XPERM_B` | `R_FORMAT`  | `LOGICAL` | `RV32B`       | `none`               |
| `XPERM_H` | `R_FORMAT`  | `LOGICAL` | `RV32B`       | `none`               |

# SHIFT Instructions

| **Name** | **Format**  | **Type** | **Extension** | **Format-Extension** |
|:---------|:------------|:---------|:--------------|:---------------------|
| `SLO`    | `R_FORMAT`  | `SHIFT`  | `RV32B`       | `none`               |
| `SRO`    | `R_FORMAT`  | `SHIFT`  | `RV32B`       | `none`               |
| `SLOI`   | `I_FORMAT`  | `SHIFT`  | `RV32B`       | `UIMM`               |
| `SROI`   | `I_FORMAT`  | `SHIFT`  | `RV32B`       | `UIMM`               |
| `GREV`   | `R_FORMAT`  | `SHIFT`  | `RV32B`       | `none`               |
| `GREVI`  | `I_FORMAT`  | `SHIFT`  | `RV32B`       | `UIMM`               |
| `FSL`    | `R4_FORMAT` | `SHIFT`  | `RV32B`       | `none`               |
| `FSR`    | `R4_FORMAT` | `SHIFT`  | `RV32B`       | `none`               |
| `FSRI`   | `I_FORMAT`  | `SHIFT`  | `RV32B`       | `UIMM`               |

# ARITHMETIC Instructions

| **Name**      | **Format** | **Type**     | **Extension** | **Format-Extension** |
|:--------------|:-----------|:-------------|:--------------|:---------------------|
| `CRC32_B`     | `R_FORMAT` | `ARITHMETIC` | `RV32B`       | `none`               |
| `CRC32_H`     | `R_FORMAT` | `ARITHMETIC` | `RV32B`       | `none`               |
| `CRC32_W`     | `R_FORMAT` | `ARITHMETIC` | `RV32B`       | `none`               |
| `CRC32C_B`    | `R_FORMAT` | `ARITHMETIC` | `RV32B`       | `none`               |
| `CRC32C_H`    | `R_FORMAT` | `ARITHMETIC` | `RV32B`       | `none`               |
| `CRC32C_W`    | `R_FORMAT` | `ARITHMETIC` | `RV32B`       | `none`               |
| `SHFL`        | `R_FORMAT` | `ARITHMETIC` | `RV32B`       | `none`               |
| `UNSHFL`      | `R_FORMAT` | `ARITHMETIC` | `RV32B`       | `none`               |
| `SHFLI`       | `I_FORMAT` | `ARITHMETIC` | `RV32B`       | `UIMM`               |
| `UNSHFLI`     | `I_FORMAT` | `ARITHMETIC` | `RV32B`       | `UIMM`               |
| `BCOMPRESS`   | `R_FORMAT` | `ARITHMETIC` | `RV32B`       | `none`               |
| `BDECOMPRESS` | `R_FORMAT` | `ARITHMETIC` | `RV32B`       | `none`               |
| `BFP`         | `R_FORMAT` | `ARITHMETIC` | `RV32B`       | `none`               |

# ARITHMETIC Instructions

| **Name**       | **Format** | **Type**     | **Extension** |
|:---------------|:-----------|:-------------|:--------------|
| `BMATOR`       | `R_FORMAT` | `ARITHMETIC` | `RV64B`       |
| `BMATXOR`      | `R_FORMAT` | `ARITHMETIC` | `RV64B`       |
| `BMATFLIP`     | `R_FORMAT` | `ARITHMETIC` | `RV64B`       |
| `CRC32_D`      | `R_FORMAT` | `ARITHMETIC` | `RV64B`       |
| `CRC32C_D`     | `R_FORMAT` | `ARITHMETIC` | `RV64B`       |
| `SHFLW`        | `R_FORMAT` | `ARITHMETIC` | `RV64B`       |
| `UNSHFLW`      | `R_FORMAT` | `ARITHMETIC` | `RV64B`       |
| `BCOMPRESSW`   | `R_FORMAT` | `ARITHMETIC` | `RV64B`       |
| `BDECOMPRESSW` | `R_FORMAT` | `ARITHMETIC` | `RV64B`       |
| `BFPW`         | `R_FORMAT` | `ARITHMETIC` | `RV64B`       |

# SHIFT Instructions

| **Name** | **Format**  | **Type** | **Extension** | **Format-Extension** |
|:---------|:------------|:---------|:--------------|:---------------------|
| `SLOW`   | `R_FORMAT`  | `SHIFT`  | `RV64B`       | `none`               |
| `SROW`   | `R_FORMAT`  | `SHIFT`  | `RV64B`       | `none`               |
| `SLOIW`  | `I_FORMAT`  | `SHIFT`  | `RV64B`       | `UIMM`               |
| `SROIW`  | `I_FORMAT`  | `SHIFT`  | `RV64B`       | `UIMM`               |
| `GREVW`  | `R_FORMAT`  | `SHIFT`  | `RV64B`       | `none`               |
| `GREVIW` | `I_FORMAT`  | `SHIFT`  | `RV64B`       | `UIMM`               |
| `FSLW`   | `R4_FORMAT` | `SHIFT`  | `RV64B`       | `none`               |
| `FSRW`   | `R4_FORMAT` | `SHIFT`  | `RV64B`       | `none`               |
| `FSRIW`  | `I_FORMAT`  | `SHIFT`  | `RV64B`       | `UIMM`               |

# LOGICAL Instructions

| **Name**  | **Format** | **Type**  | **Extension** | **Format-Extension** |
|:----------|:-----------|:----------|:--------------|:---------------------|
| `GORCW`   | `R_FORMAT` | `LOGICAL` | `RV64B`       | `none`               |
| `GORCIW`  | `I_FORMAT` | `LOGICAL` | `RV64B`       | `UIMM`               |
| `PACKW`   | `R_FORMAT` | `LOGICAL` | `RV64B`       | `none`               |
| `PACKUW`  | `R_FORMAT` | `LOGICAL` | `RV64B`       | `none`               |
| `XPERM_W` | `R_FORMAT` | `LOGICAL` | `RV64B`       | `none`               |
