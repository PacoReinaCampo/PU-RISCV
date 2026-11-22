## CONTROL AND STATUS REGISTER DESCRIPTIONS

| **Number** | **Privilege** | **Name** | **Description**                       |
|:-----------|:--------------|:---------|:--------------------------------------|
| `0x008`    | `urw`         | `wstart` | `Matrix start position`               |
| `0x009`    | `urw`         | `wxsat`  | `Fixed-point accrued saturation flag` |
| `0x00A`    | `urw`         | `wxrm`   | `Fixed-point rounding mode`           |
| `0x00F`    | `urw`         | `wcsr`   | `Matrix control and status register`  |
| `0xC20`    | `uro`         | `wl`     | `Matrix length`                       |
| `0xC21`    | `uro`         | `wtype`  | `Matrix data type register`           |
| `0xC22`    | `uro`         | `wlenb`  | `Matrix register length in bytes`     |

:Unprivileged Matrix CSRs
