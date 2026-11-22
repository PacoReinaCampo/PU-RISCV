## PSEUDO-INSTRUCTIONS

| **Extension** | **Name**   | **Variable-Fields** | **Pseudo-Instruction** | **Encoding**                       |
|:--------------|:-----------|:--------------------|:-----------------------|:-----------------------------------|
| `rv_d`        | `fsgnj_d`  | `rd, rs1`           | `fmv_d`                | `0010001----------000-----1010011` |
| `rv_d`        | `fsgnjx_d` | `rd, rs1`           | `fabs_d`               | `0010001----------010-----1010011` |
| `rv_d`        | `fsgnjn_d` | `rd, rs1`           | `fneg_d`               | `0010001----------001-----1010011` |

:RVD - RVD Specific Extension for Double-Precision Floating-Point Instructions
