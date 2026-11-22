## INSTRUCTION PSEUDO-CODE (HDL)

| **Extension** | **Name** | **Variable-Fields** | **Pseudo-Code**                     |
|:--------------|:---------|:--------------------|:------------------------------------|
| `rv_m`        | `div`    | `rd, rs1, rs2`      | `rd = sx(rs1) / sx(rs2);`           |
| `rv_m`        | `divu`   | `rd, rs1, rs2`      | `rd = ux(rs1) / ux(rs2);`           |
| `rv_m`        | `mul`    | `rd, rs1, rs2`      | `rd = ux(rs1) * ux(rs2);`           |
| `rv_m`        | `mulh`   | `rd, rs1, rs2`      | `rd = (sx(rs1) * sx(rs2)) >> XLEN;` |
| `rv_m`        | `mulhsu` | `rd, rs1, rs2`      | `rd = (sx(rs1) * ux(rs2)) >> XLEN;` |
| `rv_m`        | `mulhu`  | `rd, rs1, rs2`      | `rd = (ux(rs1) * ux(rs2)) >> XLEN;` |
| `rv_m`        | `rem`    | `rd, rs1, rs2`      | `rd = sx(rs1) % sx(rs2);`           |
| `rv_m`        | `remu`   | `rd, rs1, rs2`      | `rd = ux(rs1) % ux(rs2);`           |

:RVM - Standard Extension for Integer Multiply and Divide

| **Extension** | **Name** | **Variable-Fields** | **Pseudo-Code**             |
|:--------------|:---------|:--------------------|:----------------------------|
| `rv64_m`      | `divuw`  | `rd, rs1, rs2`      | `rd = u32(rs1) / u32(rs2);` |
| `rv64_m`      | `divw`   | `rd, rs1, rs2`      | `rd = s32(rs1) / s32(rs2);` |
| `rv64_m`      | `mulw`   | `rd, rs1, rs2`      | `rd = u32(rs1) * u32(rs2);` |
| `rv64_m`      | `remuw`  | `rd, rs1, rs2`      | `rd = u32(rs1) % u32(rs2);` |
| `rv64_m`      | `remw`   | `rd, rs1, rs2`      | `rd = s32(rs1) % s32(rs2);` |

:RV64M - Standard Extension for Integer Multiply and Divide (64 bit)

| **Extension** | **Name** | **Variable-Fields** | **Pseudo-Code**             |
|:--------------|:---------|:--------------------|:----------------------------|
| `rv128_m`     | `divud`  | `rd, rs1, rs2`      | `rd = u64(rs1) / u64(rs2);` |
| `rv128_m`     | `divd`   | `rd, rs1, rs2`      | `rd = s64(rs1) / s64(rs2);` |
| `rv128_m`     | `muld`   | `rd, rs1, rs2`      | `rd = u64(rs1) * u64(rs2);` |
| `rv128_m`     | `remud`  | `rd, rs1, rs2`      | `rd = u64(rs1) % u64(rs2);` |
| `rv128_m`     | `remd`   | `rd, rs1, rs2`      | `rd = s64(rs1) % s64(rs2);` |

:RV128M - Standard Extension for Integer Multiply and Divide (128 bit)
