## CONTROL AND STATUS REGISTER FIELDS

| **CSR**  | **Name** | **Bits**   | **Privilege** | **Description**                                                                           |
|:---------|:---------|:-----------|:--------------|:------------------------------------------------------------------------------------------|
| `ystart` | `ystart` | `XLEN-1:0` | `u`           | `Tensor start element index. Only bits needed to represent VLMAX minus one are writable.` |

:Tensor Start Position

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                       |
|:--------|:---------|:---------|:--------------|:--------------------------------------|
| `yxsat` | `yxsat`  | `0`      | `u`           | `Fixed-point accrued saturation flag` |

:Fixed-Point Accrued Saturation Flag

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**             |
|:--------|:---------|:---------|:--------------|:----------------------------|
| `yxrm`  | `yxrm`   | `1:0`    | `u`           | `Fixed-point rounding mode` |

:Fixed-Point Rounding Mode

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                       |
|:--------|:---------|:---------|:--------------|:--------------------------------------|
| `ycsr`  | `yxsat`  | `0`      | `u`           | `Fixed-point accrued saturation flag` |
| `ycsr`  | `yxrm`   | `2:1`    | `u`           | `Fixed-point rounding mode`           |

:Tensor Control and Status

| **CSR** | **Name** | **Bits**   | **Privilege** | **Description**                    |
|:--------|:---------|:-----------|:--------------|:-----------------------------------|
| `yl`    | `yl`     | `XLEN-1:0` | `u`           | `Active vector length in elements` |

:Tensor Length

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                             |
|:--------|:---------|:---------|:--------------|:--------------------------------------------|
| `ytype` | `ylmul`  | `2:0`    | `u`           | `Tensor register group multiplier encoding` |
| `ytype` | `ysew`   | `5:3`    | `u`           | `Selected element width encoding`           |
| `ytype` | `yta`    | `6`      | `u`           | `Tail agnostic policy`                      |
| `ytype` | `yma`    | `7`      | `u`           | `Mask agnostic policy`                      |
| `ytype` | `yill`   | `XLEN-1` | `u`           | `Illegal vector type`                       |

:Tensor Data Type

| **CSR** | **Name** | **Bits**   | **Privilege** | **Description**                   |
|:--------|:---------|:-----------|:--------------|:----------------------------------|
| `ylenb` | `ylenb`  | `XLEN-1:0` | `u`           | `Tensor register length in bytes` |

:Tensor Register Length in Bytes
