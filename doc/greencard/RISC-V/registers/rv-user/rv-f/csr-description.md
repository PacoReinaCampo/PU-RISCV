## CONTROL AND STATUS REGISTER DESCRIPTIONS

| **Number** | **Privilege** | **Name** | **Description**                                             |
|:-----------|:--------------|:---------|:------------------------------------------------------------|
| `0x001`    | `urw`         | `fflags` | `Floating-Point Accrued Exceptions`                         |
| `0x002`    | `urw`         | `frm`    | `Floating-Point Dynamic Rounding Mode`                      |
| `0x003`    | `urw`         | `fcsr`   | `Floating-Point Control and Status Register (frm + fflags)` |

:User Floating-Point CSRs