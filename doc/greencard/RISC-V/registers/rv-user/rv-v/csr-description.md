## CONTROL AND STATUS REGISTER DESCRIPTIONS

| **Number** | **Privilege** | **Name** | **Description**                       |
|:-----------|:--------------|:---------|:--------------------------------------|
| `0x008`    | `urw`         | `vstart` | `Vector start position`               |
| `0x009`    | `urw`         | `vxsat`  | `Fixed-point accrued saturation flag` |
| `0x00A`    | `urw`         | `vxrm`   | `Fixed-point rounding mode`           |
| `0x00F`    | `urw`         | `vcsr`   | `Vector control and status register`  |
| `0xC20`    | `uro`         | `vl`     | `Vector length`                       |
| `0xC21`    | `uro`         | `vtype`  | `Vector data type register`           |
| `0xC22`    | `uro`         | `vlenb`  | `Vector register length in bytes`     |

:Unprivileged Vector CSRs