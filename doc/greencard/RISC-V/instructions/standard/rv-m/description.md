## INSTRUCTION DESCRIPTIONS

| **Extension** | **Name** | **Variable-Fields** | **Description**                                                                     |
|:--------------|:---------|:--------------------|:------------------------------------------------------------------------------------|
| `rv_m`        | `div`    | `rd, rs1, rs2`      | `Divide rs1 (dividend) by rs2 (divisor) and place the quotient in rd (signed)`      |
| `rv_m`        | `divu`   | `rd, rs1, rs2`      | `Divide rs1 (dividend) by rs2 (divisor) and place the quotient in rd (unsigned)`    |
| `rv_m`        | `mul`    | `rd, rs1, rs2`      | `Multiply rs1 by rs2 and place the result in rd`                                    |
| `rv_m`        | `mulh`   | `rd, rs1, rs2`      | `Multiply signed rs1 by signed rs2 and place the high bits of the result in rd`     |
| `rv_m`        | `mulhsu` | `rd, rs1, rs2`      | `Multiply signed rs1 by unsigned rs2 and place the high bits of the result in rd`   |
| `rv_m`        | `mulhu`  | `rd, rs1, rs2`      | `Multiply unsigned rs1 by unsigned rs2 and place the high bits of the result in rd` |
| `rv_m`        | `rem`    | `rd, rs1, rs2`      | `Divide rs1 (dividend) by rs2 (divisor) and place the remainder in rd (signed)`     |
| `rv_m`        | `remu`   | `rd, rs1, rs2`      | `Divide rs1 (dividend) by rs2 (divisor) and place the remainder in rd (unsigned)`   |

:RVM - Standard Extension for Integer Multiply and Divide

| **Extension** | **Name** | **Variable-Fields** | **Description**                                                                                                     |
|:--------------|:---------|:--------------------|:--------------------------------------------------------------------------------------------------------------------|
| `rv64_m`      | `divuw`  | `rd, rs1, rs2`      | `Divide lower 32-bits of rs1 (dividend) by lower 32-bits of rs2 (divisor) and place the quotient in rd (unsigned)`  |
| `rv64_m`      | `divw`   | `rd, rs1, rs2`      | `Divide lower 32-bits of rs1 (dividend) by lower 32-bits of rs2 (divisor) and place the quotient in rd (signed)`    |
| `rv64_m`      | `mulw`   | `rd, rs1, rs2`      | `Multiply with lower 32-bits of rs1 by the lower 32-bits of rs2 and place the result in rd`                         |
| `rv64_m`      | `remuw`  | `rd, rs1, rs2`      | `Divide lower 32-bits of rs1 (dividend) by lower 32-bits of rs2 (divisor) and place the remainder in rd (unsigned)` |
| `rv64_m`      | `remw`   | `rd, rs1, rs2`      | `Divide lower 32-bits of rs1 (dividend) by lower 32-bits of rs2 (divisor) and place the remainder in rd (signed)`   |

:RV64M - Standard Extension for Integer Multiply and Divide (64 bit)

| **Extension** | **Name** | **Variable-Fields** | **Description**                                                                                                     |
|:--------------|:---------|:--------------------|:--------------------------------------------------------------------------------------------------------------------|
| `rv128_m`     | `divud`  | `rd, rs1, rs2`      | `Divide lower 64-bits of rs1 (dividend) by lower 64-bits of rs2 (divisor) and place the quotient in rd (unsigned)`  |
| `rv128_m`     | `divd`   | `rd, rs1, rs2`      | `Divide lower 64-bits of rs1 (dividend) by lower 64-bits of rs2 (divisor) and place the quotient in rd (signed)`    |
| `rv128_m`     | `muld`   | `rd, rs1, rs2`      | `Multiply with lower 64-bits of rs1 by the lower 64-bits of rs2 and place the result in rd`                         |
| `rv128_m`     | `remud`  | `rd, rs1, rs2`      | `Divide lower 64-bits of rs1 (dividend) by lower 64-bits of rs2 (divisor) and place the remainder in rd (unsigned)` |
| `rv128_m`     | `remd`   | `rd, rs1, rs2`      | `Divide lower 64-bits of rs1 (dividend) by lower 64-bits of rs2 (divisor) and place the remainder in rd (signed)`   |

:RV128M - Standard Extension for Integer Multiply and Divide (128 bit)
