## INSTRUCTION FULL-NAMES

| **Extension** | **Name**     | **Variable-Fields**          | **Full-Name**                                 |
|:--------------|:-------------|:-----------------------------|:----------------------------------------------|
| `rv_q`        | `fadd_q`     | `rd, rs1, rs2, rm`           | `FP Add (QP)`                                 |
| `rv_q`        | `fclass_q`   | `rd, rs1`                    | `FP Classify (QP)`                            |
| `rv_q`        | `fcvt_d_q`   | `rd, rs1, rm`                | `FP Convert QP to DP`                         |
| `rv_q`        | `fcvt_q_d`   | `rd, rs1, rm`                | `FP Convert DP to QP`                         |
| `rv_q`        | `fcvt_q_s`   | `rd, rs1, rm`                | `FP Convert SP to QP`                         |
| `rv_q`        | `fcvt_q_w`   | `rd, rs1, rm`                | `FP Convert Word to Float (QP)`               |
| `rv_q`        | `fcvt_q_wu`  | `rd, rs1, rm`                | `FP Convert Word Unsigned to Float (QP)`      |
| `rv_q`        | `fcvt_s_q`   | `rd, rs1, rm`                | `FP Convert QP to SP`                         |
| `rv_q`        | `fcvt_w_q`   | `rd, rs1, rm`                | `FP Convert Float to Word (QP)`               |
| `rv_q`        | `fcvt_wu_q`  | `rd, rs1, rm`                | `FP Convert Float to Word Unsigned (QP)`      |
| `rv_q`        | `fdiv_q`     | `rd, rs1, rs2, rm`           | `FP Divide (QP)`                              |
| `rv_q`        | `feq_q`      | `rd, rs1, rs2`               | `FP Equal (QP)`                               |
| `rv_q`        | `fle_q`      | `rd, rs1, rs2`               | `FP Less Than Equal (QP)`                     |
| `rv_q`        | `flq`        | `rd, rs1, imm12`             | `FP Load (QP)`                                |
| `rv_q`        | `flt_q`      | `rd, rs1, rs2`               | `FP Less Than (QP)`                           |
| `rv_q`        | `fmadd_q`    | `rd, rs1, rs2, rs3, rm`      | `FP Fused Multiply Add (QP)`                  |
| `rv_q`        | `fmax_q`     | `rd, rs1, rs2`               | `FP Maximum (QP)`                             |
| `rv_q`        | `fmin_q`     | `rd, rs1, rs2`               | `FP Minimum (QP)`                             |
| `rv_q`        | `fmsub_q`    | `rd, rs1, rs2, rs3, rm`      | `FP Fused Multiply Subtract (QP)`             |
| `rv_q`        | `fmul_q`     | `rd, rs1, rs2, rm`           | `FP Multiply (QP)`                            |
| `rv_q`        | `fnmadd_q`   | `rd, rs1, rs2, rs3, rm`      | `FP Negate fused Multiply Add (QP)`           |
| `rv_q`        | `fnmsub_q`   | `rd, rs1, rs2, rs3, rm`      | `FP Negate fused Multiply Subtract (QP)`      |
| `rv_q`        | `fsgnjn_q`   | `rd, rs1, rs2`               | `FP to Sign-injection Negate (QP)`            |
| `rv_q`        | `fsgnj_q`    | `rd, rs1, rs2`               | `FP to Sign-injection (QP)`                   |
| `rv_q`        | `fsgnjx_q`   | `rd, rs1, rs2`               | `FP to Sign-injection Xor (QP)`               |
| `rv_q`        | `fsq`        | `imm12hi, rs1, rs2, imm12lo` | `FP Store (QP)`                               |
| `rv_q`        | `fsqrt_q`    | `rd, rs1, rm`                | `Floating Square Root (QP)`                   |
| `rv_q`        | `fsub_q`     | `rd, rs1, rs2, rm`           | `FP Subtract (QP)`                            |
| `rv_q_zfa`    | `fleq_q`     | `rd, rs1, rs2`               | `FP Quiet Compare Less Than Or Equal To (QP)` |
| `rv_q_zfa`    | `fli_q`      | `rd, rs1`                    | `FP Load Immediate (QP)`                      |
| `rv_q_zfa`    | `fltq_q`     | `rd, rs1, rs2`               | `FP Quiet Compare Less Than (QP)`             |
| `rv_q_zfa`    | `fmaxm_q`    | `rd, rs1, rs2`               | `FP Maximum with NaN Propagation (QP)`        |
| `rv_q_zfa`    | `fminm_q`    | `rd, rs1, rs2`               | `FP Minimum with NaN Propagation (QP)`        |
| `rv_q_zfa`    | `froundnx_q` | `rd, rs1, rm`                | `FP Round to Integer with Inexact (QP)`       |
| `rv_q_zfa`    | `fround_q`   | `rd, rs1, rm`                | `FP Round to Integer (QP)`                    |
| `rv_q_zfhmin` | `fcvt_h_q`   | `rd, rs1, rm`                | `FP Convert Quad to Half`                     |
| `rv_q_zfhmin` | `fcvt_q_h`   | `rd, rs1, rm`                | `FP Convert Half to Quad`                     |

:RVQ - Specific Extension for Quadruple-Precision Floating-Point Instructions

| **Extension** | **Name**    | **Variable-Fields** | **Full-Name**                                   |
|:--------------|:------------|:--------------------|:------------------------------------------------|
| `rv64_q`      | `fcvt_l_q`  | `rd, rs1, rm`       | `FP Convert Float to Double Word (QP)`          |
| `rv64_q`      | `fcvt_lu_q` | `rd, rs1, rm`       | `FP Convert Float to Double Word Unsigned (QP)` |
| `rv64_q`      | `fcvt_q_l`  | `rd, rs1, rm`       | `FP Convert Double Word to Float (QP)`          |
| `rv64_q`      | `fcvt_q_lu` | `rd, rs1, rm`       | `FP Convert Double Word Unsigned Float (QP)`    |
| `rv64_q_zfa`  | `fmvh_x_q`  | `rd, rs1`           | `FP Move High Half to Integer Register (QP)`    |
| `rv64_q_zfa`  | `fmvp_q_x`  | `rd, rs1, rs2`      | `FP Move from Two Integer Registers (QP)`       |

:RV64Q - Specific Extension for Quadruple-Precision Floating-Point Instructions (64 bit)
