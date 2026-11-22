## INSTRUCTION DESCRIPTIONS

| **Extension** | **Name** | **Variable-Fields** | **Description**                                                                                                                                                                                                                      |
|:--------------|:---------|:--------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `rv_n`        | `uret`   | `none`              | `Return from a user-level trap to uepc using the N version 1.1 draft. Restore ustatus.UIE from ustatus.UPIE, set ustatus.UPIE to one, and resume in U-mode. Requires N support. General-purpose registers are restored by software.` |

:RVN - Specific Extension for User-level Interrupts Instructions
