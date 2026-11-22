## CONTROL AND STATUS REGISTER FIELDS

| **CSR**  | **Name** | **Bits**   | **Privilege** | **Description**                                                                           |
|:---------|:---------|:-----------|:--------------|:------------------------------------------------------------------------------------------|
| `vstart` | `vstart` | `XLEN-1:0` | `u`           | `Vector start element index. Only bits needed to represent VLMAX minus one are writable.` |

:Vector Start Position

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                       |
|:--------|:---------|:---------|:--------------|:--------------------------------------|
| `vxsat` | `vxsat`  | `0`      | `u`           | `Fixed-point accrued saturation flag` |

:Fixed-Point Accrued Saturation Flag

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**             |
|:--------|:---------|:---------|:--------------|:----------------------------|
| `vxrm`  | `vxrm`   | `1:0`    | `u`           | `Fixed-point rounding mode` |

:Fixed-Point Rounding Mode

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                       |
|:--------|:---------|:---------|:--------------|:--------------------------------------|
| `vcsr`  | `vxsat`  | `0`      | `u`           | `Fixed-point accrued saturation flag` |
| `vcsr`  | `vxrm`   | `2:1`    | `u`           | `Fixed-point rounding mode`           |

:Vector Control and Status

| **CSR** | **Name** | **Bits**   | **Privilege** | **Description**                    |
|:--------|:---------|:-----------|:--------------|:-----------------------------------|
| `vl`    | `vl`     | `XLEN-1:0` | `u`           | `Active vector length in elements` |

:Vector Length

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                             |
|:--------|:---------|:---------|:--------------|:--------------------------------------------|
| `vtype` | `vlmul`  | `2:0`    | `u`           | `Vector register group multiplier encoding` |
| `vtype` | `vsew`   | `5:3`    | `u`           | `Selected element width encoding`           |
| `vtype` | `vta`    | `6`      | `u`           | `Tail agnostic policy`                      |
| `vtype` | `vma`    | `7`      | `u`           | `Mask agnostic policy`                      |
| `vtype` | `vill`   | `XLEN-1` | `u`           | `Illegal vector type`                       |

:Vector Data Type

| **CSR** | **Name** | **Bits**   | **Privilege** | **Description**                   |
|:--------|:---------|:-----------|:--------------|:----------------------------------|
| `vlenb` | `vlenb`  | `XLEN-1:0` | `u`           | `Vector register length in bytes` |

:Vector Register Length in Bytes
