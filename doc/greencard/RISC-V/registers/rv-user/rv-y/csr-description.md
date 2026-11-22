## CONTROL AND STATUS REGISTER DESCRIPTIONS

| **Number** | **Privilege** | **Name** | **Description**                       |
|:-----------|:--------------|:---------|:--------------------------------------|
| `0x008`    | `urw`         | `ystart` | `Tensor start position`               |
| `0x009`    | `urw`         | `yxsat`  | `Fixed-point accrued saturation flag` |
| `0x00A`    | `urw`         | `yxrm`   | `Fixed-point rounding mode`           |
| `0x00F`    | `urw`         | `ycsr`   | `Tensor control and status register`  |
| `0xC20`    | `uro`         | `yl`     | `Tensor length`                       |
| `0xC21`    | `uro`         | `ytype`  | `Tensor data type register`           |
| `0xC22`    | `uro`         | `ylenb`  | `Tensor register length in bytes`     |

:Unprivileged Tensor CSRs
