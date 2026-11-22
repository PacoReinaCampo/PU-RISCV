## INSTRUCTION FULL-NAMES

| **Extension** | **Name**      | **Variable-Fields**          | **Full-Name**                                 |
|:--------------|:--------------|:-----------------------------|:----------------------------------------------|
| `rv_d`        | `fadd_d`      | `rd, rs1, rs2, rm`           | `FP Add (DP)`                                 |
| `rv_d`        | `fclass_d`    | `rd, rs1`                    | `FP Classify (DP)`                            |
| `rv_d`        | `fcvt_d_s`    | `rd, rs1, rm`                | `FP Convert SP to DP`                         |
| `rv_d`        | `fcvt_d_w`    | `rd, rs1, rm`                | `FP Convert Word to Float (DP)`               |
| `rv_d`        | `fcvt_d_wu`   | `rd, rs1, rm`                | `FP Convert Word Unsigned to Float (DP)`      |
| `rv_d`        | `fcvt_s_d`    | `rd, rs1, rm`                | `FP Convert DP to SP`                         |
| `rv_d`        | `fcvt_w_d`    | `rd, rs1, rm`                | `FP Convert Float to Word (DP)`               |
| `rv_d`        | `fcvt_wu_d`   | `rd, rs1, rm`                | `FP Convert Float to Word Unsigned (DP)`      |
| `rv_d`        | `fdiv_d`      | `rd, rs1, rs2, rm`           | `FP Divide (DP)`                              |
| `rv_d`        | `feq_d`       | `rd, rs1, rs2`               | `FP Equal (DP)`                               |
| `rv_d`        | `fld`         | `rd, rs1, imm12`             | `FP Load (DP)`                                |
| `rv_d`        | `fle_d`       | `rd, rs1, rs2`               | `FP Less Than Equal (DP)`                     |
| `rv_d`        | `flt_d`       | `rd, rs1, rs2`               | `FP Less Than (DP)`                           |
| `rv_d`        | `fmadd_d`     | `rd, rs1, rs2, rs3, rm`      | `FP Fused Multiply Add (DP)`                  |
| `rv_d`        | `fmax_d`      | `rd, rs1, rs2`               | `FP Maximum (DP)`                             |
| `rv_d`        | `fmin_d`      | `rd, rs1, rs2`               | `FP Minimum (DP)`                             |
| `rv_d`        | `fmsub_d`     | `rd, rs1, rs2, rs3, rm`      | `FP Fused Multiply Subtract (DP)`             |
| `rv_d`        | `fmul_d`      | `rd, rs1, rs2, rm`           | `FP Multiply (DP)`                            |
| `rv_d`        | `fnmadd_d`    | `rd, rs1, rs2, rs3, rm`      | `FP Negate fused Multiply Add (DP)`           |
| `rv_d`        | `fnmsub_d`    | `rd, rs1, rs2, rs3, rm`      | `FP Negate fused Multiply Subtract (DP)`      |
| `rv_d`        | `fsd`         | `imm12hi, rs1, rs2, imm12lo` | `FP Store (DP)`                               |
| `rv_d`        | `fsgnj_d`     | `rd, rs1, rs2`               | `FP to Sign-injection (DP)`                   |
| `rv_d`        | `fsgnjn_d`    | `rd, rs1, rs2`               | `FP to Sign-injection Negate (DP)`            |
| `rv_d`        | `fsgnjx_d`    | `rd, rs1, rs2`               | `FP to Sign-injection Xor (DP)`               |
| `rv_d`        | `fsqrt_d`     | `rd, rs1, rm`                | `Floating Square Root (DP)`                   |
| `rv_d`        | `fsub_d`      | `rd, rs1, rs2, rm`           | `FP Subtract (DP)`                            |
| `rv_d_zfa`    | `fcvtmod_w_d` | `rd, rs1`                    | `FP Convert Double to Word Modulo (DP)`       |
| `rv_d_zfa`    | `fleq_d`      | `rd, rs1, rs2`               | `FP Quiet Compare Less Than Or Equal To (DP)` |
| `rv_d_zfa`    | `fli_d`       | `rd, rs1`                    | `FP Load Immediate (DP)`                      |
| `rv_d_zfa`    | `fltq_d`      | `rd, rs1, rs2`               | `FP Quiet Compare Less Than (DP)`             |
| `rv_d_zfa`    | `fmaxm_d`     | `rd, rs1, rs2`               | `FP Maximum with NaN Propagation (DP)`        |
| `rv_d_zfa`    | `fminm_d`     | `rd, rs1, rs2`               | `FP Minimum with NaN Propagation (DP)`        |
| `rv_d_zfa`    | `fround_d`    | `rd, rs1, rm`                | `FP Round to Integer (DP)`                    |
| `rv_d_zfa`    | `froundnx_d`  | `rd, rs1, rm`                | `FP Round to Integer with Inexact (DP)`       |
| `rv_d_zfhmin` | `fcvt_d_h`    | `rd, rs1, rm`                | `FP Convert Half to Double`                   |
| `rv_d_zfhmin` | `fcvt_h_d`    | `rd, rs1, rm`                | `FP Convert Double to Half`                   |

:RVD - Specific Extension for Double-Precision Floating-Point Instructions

| **Extension** | **Name**   | **Variable-Fields** | **Full-Name**                                |
|:--------------|:-----------|:--------------------|:---------------------------------------------|
| `rv32_d_zfa`  | `fmvh_x_d` | `rd, rs1`           | `FP Move High Half to Integer Register (DP)` |
| `rv32_d_zfa`  | `fmvp_d_x` | `rd, rs1, rs2`      | `FP Move from Two Integer Registers (DP)`    |

:RV32D - Specific Extension for Double-Precision Floating-Point Instructions (32 bit)

| **Extension** | **Name**    | **Variable-Fields** | **Full-Name**                                   |
|:--------------|:------------|:--------------------|:------------------------------------------------|
| `rv64_d`      | `fcvt_d_l`  | `rd, rs1, rm`       | `FP Convert Double Word to Float (DP)`          |
| `rv64_d`      | `fcvt_d_lu` | `rd, rs1, rm`       | `FP Convert Double Word Unsigned Float (DP)`    |
| `rv64_d`      | `fcvt_l_d`  | `rd, rs1, rm`       | `FP Convert Float to Double Word (DP)`          |
| `rv64_d`      | `fcvt_lu_d` | `rd, rs1, rm`       | `FP Convert Float to Double Word Unsigned (DP)` |
| `rv64_d`      | `fmv_d_x`   | `rd, rs1`           | `FP Move from Integer Register (DP)`            |
| `rv64_d`      | `fmv_x_d`   | `rd, rs1`           | `FP Move to Integer Register (DP)`              |

:RV64D - Specific Extension for Double-Precision Floating-Point Instructions (64 bit)
