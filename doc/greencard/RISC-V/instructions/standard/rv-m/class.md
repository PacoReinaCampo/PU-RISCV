## INSTRUCTION CLASSES

| **Extension** | **Name** | **Variable-Fields** | **Class**       |
|:--------------|:---------|:--------------------|:----------------|
| `rv_m`        | `div`    | `rd, rs1, rs2`      | `alu, divide`   |
| `rv_m`        | `divu`   | `rd, rs1, rs2`      | `alu, divide`   |
| `rv_m`        | `mul`    | `rd, rs1, rs2`      | `alu, multiply` |
| `rv_m`        | `mulh`   | `rd, rs1, rs2`      | `alu, multiply` |
| `rv_m`        | `mulhsu` | `rd, rs1, rs2`      | `alu, multiply` |
| `rv_m`        | `mulhu`  | `rd, rs1, rs2`      | `alu, multiply` |
| `rv_m`        | `rem`    | `rd, rs1, rs2`      | `alu, divide`   |
| `rv_m`        | `remu`   | `rd, rs1, rs2`      | `alu, divide`   |

:RVM - Standard Extension for Integer Multiply and Divide

| **Extension** | **Name** | **Variable-Fields** | **Class**       |
|:--------------|:---------|:--------------------|:----------------|
| `rv64_m`      | `divuw`  | `rd, rs1, rs2`      | `alu, multiply` |
| `rv64_m`      | `divw`   | `rd, rs1, rs2`      | `alu, multiply` |
| `rv64_m`      | `mulw`   | `rd, rs1, rs2`      | `alu, multiply` |
| `rv64_m`      | `remuw`  | `rd, rs1, rs2`      | `alu, divide`   |
| `rv64_m`      | `remw`   | `rd, rs1, rs2`      | `alu, divide`   |

:RV64M - Standard Extension for Integer Multiply and Divide (64 bit)

| **Extension** | **Name** | **Variable-Fields** | **Class**       |
|:--------------|:---------|:--------------------|:----------------|
| `rv128_m`     | `divud`  | `rd, rs1, rs2`      | `alu, multiply` |
| `rv128_m`     | `divd`   | `rd, rs1, rs2`      | `alu, multiply` |
| `rv128_m`     | `muld`   | `rd, rs1, rs2`      | `alu, multiply` |
| `rv128_m`     | `remud`  | `rd, rs1, rs2`      | `alu, divide`   |
| `rv128_m`     | `remd`   | `rd, rs1, rs2`      | `alu, divide`   |

:RV128M - Standard Extension for Integer Multiply and Divide (128 bit)
