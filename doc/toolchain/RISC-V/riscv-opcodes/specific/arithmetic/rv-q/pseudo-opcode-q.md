## PSEUDO-INSTRUCTIONS

| **Extension** | **Name**   | **Variable-Fields** | **Pseudo-Instruction** | **Encoding**                       |
|:--------------|:-----------|:--------------------|:-----------------------|:-----------------------------------|
| `rv_q`        | `fsgnj_q`  | `rd, rs1`           | `fmv_q`                | `0010011----------000-----1010011` |
| `rv_q`        | `fsgnjx_q` | `rd, rs1`           | `fabs_q`               | `0010011----------010-----1010011` |
| `rv_q`        | `fsgnjn_q` | `rd, rs1`           | `fneg_q`               | `0010011----------001-----1010011` |

:RVQ - RVQ Specific Extension for Quadruple-Precision Floating-Point Instructions
