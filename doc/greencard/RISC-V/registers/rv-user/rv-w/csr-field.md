## CONTROL AND STATUS REGISTER FIELDS

| **CSR**  | **Name** | **Bits**   | **Privilege** | **Description**                                                                           |
|:---------|:---------|:-----------|:--------------|:------------------------------------------------------------------------------------------|
| `wstart` | `wstart` | `XLEN-1:0` | `u`           | `Matrix start element index. Only bits needed to represent VLMAX minus one are writable.` |

:Matrix Start Position

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                       |
|:--------|:---------|:---------|:--------------|:--------------------------------------|
| `wxsat` | `wxsat`  | `0`      | `u`           | `Fixed-point accrued saturation flag` |

:Fixed-Point Accrued Saturation Flag

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**             |
|:--------|:---------|:---------|:--------------|:----------------------------|
| `wxrm`  | `wxrm`   | `1:0`    | `u`           | `Fixed-point rounding mode` |

:Fixed-Point Rounding Mode

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                       |
|:--------|:---------|:---------|:--------------|:--------------------------------------|
| `wcsr`  | `wxsat`  | `0`      | `u`           | `Fixed-point accrued saturation flag` |
| `wcsr`  | `wxrm`   | `2:1`    | `u`           | `Fixed-point rounding mode`           |

:Matrix Control and Status

| **CSR** | **Name** | **Bits**   | **Privilege** | **Description**                    |
|:--------|:---------|:-----------|:--------------|:-----------------------------------|
| `wl`    | `wl`     | `XLEN-1:0` | `u`           | `Active vector length in elements` |

:Matrix Length

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                             |
|:--------|:---------|:---------|:--------------|:--------------------------------------------|
| `wtype` | `wlmul`  | `2:0`    | `u`           | `Matrix register group multiplier encoding` |
| `wtype` | `wsew`   | `5:3`    | `u`           | `Selected element width encoding`           |
| `wtype` | `wta`    | `6`      | `u`           | `Tail agnostic policy`                      |
| `wtype` | `wma`    | `7`      | `u`           | `Mask agnostic policy`                      |
| `wtype` | `will`   | `XLEN-1` | `u`           | `Illegal vector type`                       |

:Matrix Data Type

| **CSR** | **Name** | **Bits**   | **Privilege** | **Description**                   |
|:--------|:---------|:-----------|:--------------|:----------------------------------|
| `wlenb` | `wlenb`  | `XLEN-1:0` | `u`           | `Matrix register length in bytes` |

:Matrix Register Length in Bytes
