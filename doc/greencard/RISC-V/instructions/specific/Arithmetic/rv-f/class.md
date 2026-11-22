## INSTRUCTION CLASSES

| **Extension** | **Name**     | **Variable-Fields**          | **Class**    |
|:--------------|:-------------|:-----------------------------|:-------------|
| `rv_f`        | `fadd_s`     | `rd, rs1, rs2, rm`           | `fpu`        |
| `rv_f`        | `fclass_s`   | `rd, rs1`                    | `fpu`        |
| `rv_f`        | `fcvt_s_w`   | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_f`        | `fcvt_s_wu`  | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_f`        | `fcvt_w_s`   | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_f`        | `fcvt_wu_s`  | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_f`        | `fdiv_s`     | `rd, rs1, rs2, rm`           | `fpu, fdiv`  |
| `rv_f`        | `feq_s`      | `rd, rs1, rs2`               | `fpu`        |
| `rv_f`        | `fle_s`      | `rd, rs1, rs2`               | `fpu`        |
| `rv_f`        | `flt_s`      | `rd, rs1, rs2`               | `fpu`        |
| `rv_f`        | `flw`        | `rd, rs1, imm12`             | `fpu, load`  |
| `rv_f`        | `fmadd_s`    | `rd, rs1, rs2, rs3, rm`      | `fpu, fma`   |
| `rv_f`        | `fmax_s`     | `rd, rs1, rs2`               | `fpu`        |
| `rv_f`        | `fmin_s`     | `rd, rs1, rs2`               | `fpu`        |
| `rv_f`        | `fmsub_s`    | `rd, rs1, rs2, rs3, rm`      | `fpu, fma`   |
| `rv_f`        | `fmul_s`     | `rd, rs1, rs2, rm`           | `fpu`        |
| `rv_f`        | `fmv_w_x`    | `rd, rs1`                    | `fpu, fmove` |
| `rv_f`        | `fmv_x_w`    | `rd, rs1`                    | `fpu, fmove` |
| `rv_f`        | `fnmadd_s`   | `rd, rs1, rs2, rs3, rm`      | `fpu, fma`   |
| `rv_f`        | `fnmsub_s`   | `rd, rs1, rs2, rs3, rm`      | `fpu, fma`   |
| `rv_f`        | `fsgnjn_s`   | `rd, rs1, rs2`               | `fpu`        |
| `rv_f`        | `fsgnj_s`    | `rd, rs1, rs2`               | `fpu`        |
| `rv_f`        | `fsgnjx_s`   | `rd, rs1, rs2`               | `fpu`        |
| `rv_f`        | `fsqrt_s`    | `rd, rs1, rm`                | `fpu, fsqrt` |
| `rv_f`        | `fsub_s`     | `rd, rs1, rs2, rm`           | `fpu`        |
| `rv_f`        | `fsw`        | `imm12hi, rs1, rs2, imm12lo` | `fpu, store` |
| `rv_f_zfa`    | `fleq_s`     | `rd, rs1, rs2`               | `fpu`        |
| `rv_f_zfa`    | `fli_s`      | `rd, rs1`                    | `fpu, fmove` |
| `rv_f_zfa`    | `fltq_s`     | `rd, rs1, rs2`               | `fpu`        |
| `rv_f_zfa`    | `fmaxm_s`    | `rd, rs1, rs2`               | `fpu`        |
| `rv_f_zfa`    | `fminm_s`    | `rd, rs1, rs2`               | `fpu`        |
| `rv_f_zfa`    | `froundnx_s` | `rd, rs1, rm`                | `fpu`        |
| `rv_f_zfa`    | `fround_s`   | `rd, rs1, rm`                | `fpu`        |

:RVF - Specific Extension for Single-Precision Floating-Point Instructions

| **Extension** | **Name**    | **Variable-Fields** | **Class**   |
|:--------------|:------------|:--------------------|:------------|
| `rv64_f`      | `fcvt_l_s`  | `rd, rs1, rm`       | `fpu, fcvt` |
| `rv64_f`      | `fcvt_lu_s` | `rd, rs1, rm`       | `fpu, fcvt` |
| `rv64_f`      | `fcvt_s_l`  | `rd, rs1, rm`       | `fpu, fcvt` |
| `rv64_f`      | `fcvt_s_lu` | `rd, rs1, rm`       | `fpu, fcvt` |

:RV64F - Specific Extension for Single-Precision Floating-Point Instructions (64 bit)

| **Extension** | **Name**      | **Variable-Fields** | **Class**   |
|:--------------|:--------------|:--------------------|:------------|
| `rv_zfbfmin`  | `fcvt_bf16_s` | `rd, rs1, rm`       | `fpu, fcvt` |
| `rv_zfbfmin`  | `fcvt_s_bf16` | `rd, rs1, rm`       | `fpu, fcvt` |

:RV64ZF - Specific Extension for Single-Precision Floating-Point Instructions

| **Extension** | **Name**     | **Variable-Fields**          | **Class**    |
|:--------------|:-------------|:-----------------------------|:-------------|
| `rv_zfh`      | `fadd_h`     | `rd, rs1, rs2, rm`           | `fpu`        |
| `rv_zfh`      | `fclass_h`   | `rd, rs1`                    | `fpu`        |
| `rv_zfh`      | `fcvt_h_w`   | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_zfh`      | `fcvt_h_wu`  | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_zfh`      | `fcvt_w_h`   | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_zfh`      | `fcvt_wu_h`  | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_zfh`      | `fdiv_h`     | `rd, rs1, rs2, rm`           | `fpu, fdiv`  |
| `rv_zfh`      | `feq_h`      | `rd, rs1, rs2`               | `fpu`        |
| `rv_zfh`      | `fle_h`      | `rd, rs1, rs2`               | `fpu`        |
| `rv_zfh`      | `flt_h`      | `rd, rs1, rs2`               | `fpu`        |
| `rv_zfh`      | `fmadd_h`    | `rd, rs1, rs2, rs3, rm`      | `fpu, fma`   |
| `rv_zfh`      | `fmax_h`     | `rd, rs1, rs2`               | `fpu`        |
| `rv_zfh`      | `fmin_h`     | `rd, rs1, rs2`               | `fpu`        |
| `rv_zfh`      | `fmsub_h`    | `rd, rs1, rs2, rs3, rm`      | `fpu, fma`   |
| `rv_zfh`      | `fmul_h`     | `rd, rs1, rs2, rm`           | `fpu`        |
| `rv_zfh`      | `fnmadd_h`   | `rd, rs1, rs2, rs3, rm`      | `fpu, fma`   |
| `rv_zfh`      | `fnmsub_h`   | `rd, rs1, rs2, rs3, rm`      | `fpu, fma`   |
| `rv_zfh`      | `fsgnj_h`    | `rd, rs1, rs2`               | `fpu`        |
| `rv_zfh`      | `fsgnjn_h`   | `rd, rs1, rs2`               | `fpu`        |
| `rv_zfh`      | `fsgnjx_h`   | `rd, rs1, rs2`               | `fpu`        |
| `rv_zfh`      | `fsqrt_h`    | `rd, rs1, rm`                | `fpu, fsqrt` |
| `rv_zfh`      | `fsub_h`     | `rd, rs1, rs2, rm`           | `fpu`        |
| `rv_zfhmin`   | `fcvt_h_s`   | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_zfhmin`   | `fcvt_s_h`   | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_zfhmin`   | `flh`        | `rd, rs1, imm12`             | `fpu, load`  |
| `rv_zfhmin`   | `fmv_h_x`    | `rd, rs1`                    | `fpu, fmove` |
| `rv_zfhmin`   | `fmv_x_h`    | `rd, rs1`                    | `fpu, fmove` |
| `rv_zfhmin`   | `fsh`        | `imm12hi, rs1, rs2, imm12lo` | `fpu, store` |
| `rv_zfh_zfa`  | `fleq_h`     | `rd, rs1, rs2`               | `fpu`        |
| `rv_zfh_zfa`  | `fli_h`      | `rd, rs1`                    | `fpu, fmove` |
| `rv_zfh_zfa`  | `fltq_h`     | `rd, rs1, rs2`               | `fpu`        |
| `rv_zfh_zfa`  | `fmaxm_h`    | `rd, rs1, rs2`               | `fpu`        |
| `rv_zfh_zfa`  | `fminm_h`    | `rd, rs1, rs2`               | `fpu`        |
| `rv_zfh_zfa`  | `fround_h`   | `rd, rs1, rm`                | `fpu`        |
| `rv_zfh_zfa`  | `froundnx_h` | `rd, rs1, rm`                | `fpu`        |

:RVZFH - Specific Extension for Half-Precision Floating-Point Instructions

| **Extension** | **Name**    | **Variable-Fields** | **Class**   |
|:--------------|:------------|:--------------------|:------------|
| `rv64_zfh`    | `fcvt_h_l`  | `rd, rs1, rm`       | `fpu, fcvt` |
| `rv64_zfh`    | `fcvt_h_lu` | `rd, rs1, rm`       | `fpu, fcvt` |
| `rv64_zfh`    | `fcvt_l_h`  | `rd, rs1, rm`       | `fpu, fcvt` |
| `rv64_zfh`    | `fcvt_lu_h` | `rd, rs1, rm`       | `fpu, fcvt` |

:RV64ZFH - Specific Extension for Half-Precision Floating-Point Instructions (64 bit)
