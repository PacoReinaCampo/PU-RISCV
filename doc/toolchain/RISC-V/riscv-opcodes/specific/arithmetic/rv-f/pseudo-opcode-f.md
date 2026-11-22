## PSEUDO-INSTRUCTIONS

| **Extension** | **Name**   | **Variable-Fields** | **Pseudo-Instruction** | **Encoding**                       |
|:--------------|:-----------|:--------------------|:-----------------------|:-----------------------------------|
| `rv_f`        | `fmv_x_w`  | `rd, rs1`           | `fmv_x_s`              | `111000000000-----000-----1010011` |
| `rv_f`        | `fmv_w_x`  | `rd, rs1`           | `fmv_s_x`              | `111100000000-----000-----1010011` |
| `rv_f`        | `fsgnj_s`  | `rd, rs1`           | `fmv_s`                | `0010000----------000-----1010011` |
| `rv_f`        | `fsgnjx_s` | `rd, rs1`           | `fabs_s`               | `0010000----------010-----1010011` |
| `rv_f`        | `fsgnjn_s` | `rd, rs1`           | `fneg_s`               | `0010000----------001-----1010011` |

:RVF - RVF Specific Extension for Single-Precision Floating-Point Instructions

| **Extension** | **Name** | **Variable-Fields** | **Pseudo-Instruction** | **Encoding**                       |
|:--------------|:---------|:--------------------|:-----------------------|:-----------------------------------|
| `rv_zicsr`    | `csrrs`  | `rd`                | `frflags`              | `00000000000100000010-----1110011` |
| `rv_zicsr`    | `csrrw`  | `rd, rs1`           | `fsflags`              | `000000000001-----001-----1110011` |
| `rv_zicsr`    | `csrrwi` | `rd, zimm5`         | `fsflagsi`             | `000000000001-----101-----1110011` |
| `rv_zicsr`    | `csrrs`  | `rd`                | `frrm`                 | `00000000001000000010-----1110011` |
| `rv_zicsr`    | `csrrw`  | `rd, rs1`           | `fsrm`                 | `000000000010-----001-----1110011` |
| `rv_zicsr`    | `csrrwi` | `rd, zimm5`         | `fsrmi`                | `000000000010-----101-----1110011` |
| `rv_zicsr`    | `csrrw`  | `rd, rs1`           | `fscsr`                | `000000000011-----001-----1110011` |
| `rv_zicsr`    | `csrrs`  | `rd`                | `frcsr`                | `00000000001100000010-----1110011` |

:RVZI - RVZI Specific Extension for Single-Precision Floating-Point Instructions
