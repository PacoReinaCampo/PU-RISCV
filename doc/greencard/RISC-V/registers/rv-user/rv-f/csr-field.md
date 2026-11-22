## CONTROL AND STATUS REGISTER FIELDS

| **CSR**  | **Name** | **Bits** | **Privilege** | **Description**     |
|:---------|:---------|:---------|:--------------|:--------------------|
| `fflags` | `nx`     | `0`      | `u`           | `Inexact`           |
| `fflags` | `uf`     | `1`      | `u`           | `Underflow`         |
| `fflags` | `of`     | `2`      | `u`           | `Overflow`          |
| `fflags` | `dz`     | `3`      | `u`           | `Divide by zero`    |
| `fflags` | `nv`     | `4`      | `u`           | `Invalid operation` |

:Floating-Point Accrued Exceptions

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**         |
|:--------|:---------|:---------|:--------------|:------------------------|
| `frm`   | `frm`    | `2:0`    | `u`           | `Dynamic rounding mode` |

:Floating-Point Dynamic Rounding Mode

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**         |
|:--------|:---------|:---------|:--------------|:------------------------|
| `fcsr`  | `nx`     | `0`      | `u`           | `Inexact`               |
| `fcsr`  | `uf`     | `1`      | `u`           | `Underflow`             |
| `fcsr`  | `of`     | `2`      | `u`           | `Overflow`              |
| `fcsr`  | `dz`     | `3`      | `u`           | `Divide by zero`        |
| `fcsr`  | `nv`     | `4`      | `u`           | `Invalid operation`     |
| `fcsr`  | `frm`    | `7:5`    | `u`           | `Dynamic rounding mode` |

:Floating-Point Control and Status
