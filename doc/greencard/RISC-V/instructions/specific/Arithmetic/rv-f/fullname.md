## INSTRUCTION FULL-NAMES

| **Extension** | **Name**     | **Variable-Fields**          | **Full-Name**                                 |
|:--------------|:-------------|:-----------------------------|:----------------------------------------------|
| `rv_f`        | `fadd_s`     | `rd, rs1, rs2, rm`           | `FP Add (SP)`                                 |
| `rv_f`        | `fclass_s`   | `rd, rs1`                    | `FP Classify (SP)`                            |
| `rv_f`        | `fcvt_s_w`   | `rd, rs1, rm`                | `FP Convert Word to Float (SP)`               |
| `rv_f`        | `fcvt_s_wu`  | `rd, rs1, rm`                | `FP Convert Word Unsigned to Float (SP)`      |
| `rv_f`        | `fcvt_w_s`   | `rd, rs1, rm`                | `FP Convert Float to Word (SP)`               |
| `rv_f`        | `fcvt_wu_s`  | `rd, rs1, rm`                | `FP Convert Float to Word Unsigned (SP)`      |
| `rv_f`        | `fdiv_s`     | `rd, rs1, rs2, rm`           | `FP Divide (SP)`                              |
| `rv_f`        | `feq_s`      | `rd, rs1, rs2`               | `FP Equal (SP)`                               |
| `rv_f`        | `fle_s`      | `rd, rs1, rs2`               | `FP Less Than Equal (SP)`                     |
| `rv_f`        | `flt_s`      | `rd, rs1, rs2`               | `FP Less Than (SP)`                           |
| `rv_f`        | `flw`        | `rd, rs1, imm12`             | `FP Load (SP)`                                |
| `rv_f`        | `fmadd_s`    | `rd, rs1, rs2, rs3, rm`      | `FP Fused Multiply Add (SP)`                  |
| `rv_f`        | `fmax_s`     | `rd, rs1, rs2`               | `FP Maximum (SP)`                             |
| `rv_f`        | `fmin_s`     | `rd, rs1, rs2`               | `FP Minimum (SP)`                             |
| `rv_f`        | `fmsub_s`    | `rd, rs1, rs2, rs3, rm`      | `FP Fused Multiply Subtract (SP)`             |
| `rv_f`        | `fmul_s`     | `rd, rs1, rs2, rm`           | `FP Multiply (SP)`                            |
| `rv_f`        | `fmv_w_x`    | `rd, rs1`                    | `FP Move from Integer Register (SP)`          |
| `rv_f`        | `fmv_x_w`    | `rd, rs1`                    | `FP Move to Integer Register (SP)`            |
| `rv_f`        | `fnmadd_s`   | `rd, rs1, rs2, rs3, rm`      | `FP Negate fused Multiply Add (SP)`           |
| `rv_f`        | `fnmsub_s`   | `rd, rs1, rs2, rs3, rm`      | `FP Negate fused Multiply Subtract (SP)`      |
| `rv_f`        | `fsgnjn_s`   | `rd, rs1, rs2`               | `FP Sign-injection Negate (SP)`               |
| `rv_f`        | `fsgnj_s`    | `rd, rs1, rs2`               | `FP Sign-injection (SP)`                      |
| `rv_f`        | `fsgnjx_s`   | `rd, rs1, rs2`               | `FP Sign-injection Xor (SP)`                  |
| `rv_f`        | `fsqrt_s`    | `rd, rs1, rm`                | `FP Square Root (SP)`                         |
| `rv_f`        | `fsub_s`     | `rd, rs1, rs2, rm`           | `FP Subtract (SP)`                            |
| `rv_f`        | `fsw`        | `imm12hi, rs1, rs2, imm12lo` | `FP Store (SP)`                               |
| `rv_f_zfa`    | `fleq_s`     | `rd, rs1, rs2`               | `FP Quiet Compare Less Than Or Equal To (SP)` |
| `rv_f_zfa`    | `fli_s`      | `rd, rs1`                    | `FP Load Immediate (SP)`                      |
| `rv_f_zfa`    | `fltq_s`     | `rd, rs1, rs2`               | `FP Quiet Compare Less Than (SP)`             |
| `rv_f_zfa`    | `fmaxm_s`    | `rd, rs1, rs2`               | `FP Maximum with NaN Propagation (SP)`        |
| `rv_f_zfa`    | `fminm_s`    | `rd, rs1, rs2`               | `FP Minimum with NaN Propagation (SP)`        |
| `rv_f_zfa`    | `froundnx_s` | `rd, rs1, rm`                | `FP Round to Integer with Inexact (SP)`       |
| `rv_f_zfa`    | `fround_s`   | `rd, rs1, rm`                | `FP Round to Integer (SP)`                    |

:RVF - Specific Extension for Single-Precision Floating-Point Instructions

| **Extension** | **Name**    | **Variable-Fields** | **Full-Name**                                   |
|:--------------|:------------|:--------------------|:------------------------------------------------|
| `rv64_f`      | `fcvt_l_s`  | `rd, rs1, rm`       | `FP Convert Float to Double Word (SP)`          |
| `rv64_f`      | `fcvt_lu_s` | `rd, rs1, rm`       | `FP Convert Float to Double Word Unsigned (SP)` |
| `rv64_f`      | `fcvt_s_l`  | `rd, rs1, rm`       | `FP Convert Double Word to Float (SP)`          |
| `rv64_f`      | `fcvt_s_lu` | `rd, rs1, rm`       | `FP Convert Double Word Unsigned to Float (SP)` |

:RV64F - Specific Extension for Single-Precision Floating-Point Instructions (64 bit)

| **Extension** | **Name**      | **Variable-Fields** | **Full-Name**               |
|:--------------|:--------------|:--------------------|:----------------------------|
| `rv_zfbfmin`  | `fcvt_bf16_s` | `rd, rs1, rm`       | `FP Convert Single to BF16` |
| `rv_zfbfmin`  | `fcvt_s_bf16` | `rd, rs1, rm`       | `FP Convert BF16 to Single` |

:RV64ZF - Specific Extension for Single-Precision Floating-Point Instructions

| **Extension** | **Name**     | **Variable-Fields**          | **Full-Name**                                 |
|:--------------|:-------------|:-----------------------------|:----------------------------------------------|
| `rv_zfh`      | `fadd_h`     | `rd, rs1, rs2, rm`           | `FP Add (HP)`                                 |
| `rv_zfh`      | `fclass_h`   | `rd, rs1`                    | `FP Classify (HP)`                            |
| `rv_zfh`      | `fcvt_h_w`   | `rd, rs1, rm`                | `FP Convert Word to Half`                     |
| `rv_zfh`      | `fcvt_h_wu`  | `rd, rs1, rm`                | `FP Convert Word Unsigned to Half`            |
| `rv_zfh`      | `fcvt_w_h`   | `rd, rs1, rm`                | `FP Convert Half to Word`                     |
| `rv_zfh`      | `fcvt_wu_h`  | `rd, rs1, rm`                | `FP Convert Half to Word Unsigned`            |
| `rv_zfh`      | `fdiv_h`     | `rd, rs1, rs2, rm`           | `FP Divide (HP)`                              |
| `rv_zfh`      | `feq_h`      | `rd, rs1, rs2`               | `FP Quiet Compare Equal To (HP)`              |
| `rv_zfh`      | `fle_h`      | `rd, rs1, rs2`               | `FP Compare Less Than Or Equal To (HP)`       |
| `rv_zfh`      | `flt_h`      | `rd, rs1, rs2`               | `FP Compare Less Than (HP)`                   |
| `rv_zfh`      | `fmadd_h`    | `rd, rs1, rs2, rs3, rm`      | `FP Fused Multiply-Add (HP)`                  |
| `rv_zfh`      | `fmax_h`     | `rd, rs1, rs2`               | `FP Maximum (HP)`                             |
| `rv_zfh`      | `fmin_h`     | `rd, rs1, rs2`               | `FP Minimum (HP)`                             |
| `rv_zfh`      | `fmsub_h`    | `rd, rs1, rs2, rs3, rm`      | `FP Fused Multiply-Subtract (HP)`             |
| `rv_zfh`      | `fmul_h`     | `rd, rs1, rs2, rm`           | `FP Multiply (HP)`                            |
| `rv_zfh`      | `fnmadd_h`   | `rd, rs1, rs2, rs3, rm`      | `FP Fused Negative Multiply-Add (HP)`         |
| `rv_zfh`      | `fnmsub_h`   | `rd, rs1, rs2, rs3, rm`      | `FP Fused Negative Multiply-Subtract (HP)`    |
| `rv_zfh`      | `fsgnj_h`    | `rd, rs1, rs2`               | `FP Sign Inject (HP)`                         |
| `rv_zfh`      | `fsgnjn_h`   | `rd, rs1, rs2`               | `FP Sign Inject Negated (HP)`                 |
| `rv_zfh`      | `fsgnjx_h`   | `rd, rs1, rs2`               | `FP Sign Inject XOR (HP)`                     |
| `rv_zfh`      | `fsqrt_h`    | `rd, rs1, rm`                | `FP Square Root (HP)`                         |
| `rv_zfh`      | `fsub_h`     | `rd, rs1, rs2, rm`           | `FP Subtract (HP)`                            |
| `rv_zfhmin`   | `fcvt_h_s`   | `rd, rs1, rm`                | `FP Convert Single to Half`                   |
| `rv_zfhmin`   | `fcvt_s_h`   | `rd, rs1, rm`                | `FP Convert Half to Single`                   |
| `rv_zfhmin`   | `flh`        | `rd, rs1, imm12`             | `FP Load Halfword (HP)`                       |
| `rv_zfhmin`   | `fmv_h_x`    | `rd, rs1`                    | `FP Move from Integer Register (HP)`          |
| `rv_zfhmin`   | `fmv_x_h`    | `rd, rs1`                    | `FP Move to Integer Register (HP)`            |
| `rv_zfhmin`   | `fsh`        | `imm12hi, rs1, rs2, imm12lo` | `FP Store Halfword (HP)`                      |
| `rv_zfh_zfa`  | `fleq_h`     | `rd, rs1, rs2`               | `FP Quiet Compare Less Than Or Equal To (HP)` |
| `rv_zfh_zfa`  | `fli_h`      | `rd, rs1`                    | `FP Load Immediate (HP)`                      |
| `rv_zfh_zfa`  | `fltq_h`     | `rd, rs1, rs2`               | `FP Quiet Compare Less Than (HP)`             |
| `rv_zfh_zfa`  | `fmaxm_h`    | `rd, rs1, rs2`               | `FP Maximum with NaN Propagation (HP)`        |
| `rv_zfh_zfa`  | `fminm_h`    | `rd, rs1, rs2`               | `FP Minimum with NaN Propagation (HP)`        |
| `rv_zfh_zfa`  | `fround_h`   | `rd, rs1, rm`                | `FP Round to Integer (HP)`                    |
| `rv_zfh_zfa`  | `froundnx_h` | `rd, rs1, rm`                | `FP Round to Integer with Inexact (HP)`       |

:RVZFH - Specific Extension for Half-Precision Floating-Point Instructions

| **Extension** | **Name**    | **Variable-Fields** | **Full-Name**                            |
|:--------------|:------------|:--------------------|:-----------------------------------------|
| `rv64_zfh`    | `fcvt_h_l`  | `rd, rs1, rm`       | `FP Convert Doubleword to Half`          |
| `rv64_zfh`    | `fcvt_h_lu` | `rd, rs1, rm`       | `FP Convert Doubleword Unsigned to Half` |
| `rv64_zfh`    | `fcvt_l_h`  | `rd, rs1, rm`       | `FP Convert Half to Doubleword`          |
| `rv64_zfh`    | `fcvt_lu_h` | `rd, rs1, rm`       | `FP Convert Half to Doubleword Unsigned` |

:RV64ZFH - Specific Extension for Half-Precision Floating-Point Instructions (64 bit)
