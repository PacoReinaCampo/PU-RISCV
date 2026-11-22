## INSTRUCTION CLASSES

| **Extension** | **Name**      | **Variable-Fields**          | **Class**    |
|:--------------|:--------------|:-----------------------------|:-------------|
| `rv_d`        | `fadd_d`      | `rd, rs1, rs2, rm`           | `fpu`        |
| `rv_d`        | `fclass_d`    | `rd, rs1`                    | `fpu`        |
| `rv_d`        | `fcvt_d_s`    | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_d`        | `fcvt_d_w`    | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_d`        | `fcvt_d_wu`   | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_d`        | `fcvt_s_d`    | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_d`        | `fcvt_w_d`    | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_d`        | `fcvt_wu_d`   | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_d`        | `fdiv_d`      | `rd, rs1, rs2, rm`           | `fpu, fdiv`  |
| `rv_d`        | `feq_d`       | `rd, rs1, rs2`               | `fpu`        |
| `rv_d`        | `fld`         | `rd, rs1, imm12`             | `fpu, load`  |
| `rv_d`        | `fle_d`       | `rd, rs1, rs2`               | `fpu`        |
| `rv_d`        | `flt_d`       | `rd, rs1, rs2`               | `fpu`        |
| `rv_d`        | `fmadd_d`     | `rd, rs1, rs2, rs3, rm`      | `fpu, fma`   |
| `rv_d`        | `fmax_d`      | `rd, rs1, rs2`               | `fpu`        |
| `rv_d`        | `fmin_d`      | `rd, rs1, rs2`               | `fpu`        |
| `rv_d`        | `fmsub_d`     | `rd, rs1, rs2, rs3, rm`      | `fpu, fma`   |
| `rv_d`        | `fmul_d`      | `rd, rs1, rs2, rm`           | `fpu`        |
| `rv_d`        | `fnmadd_d`    | `rd, rs1, rs2, rs3, rm`      | `fpu, fma`   |
| `rv_d`        | `fnmsub_d`    | `rd, rs1, rs2, rs3, rm`      | `fpu, fma`   |
| `rv_d`        | `fsd`         | `imm12hi, rs1, rs2, imm12lo` | `fpu, store` |
| `rv_d`        | `fsgnj_d`     | `rd, rs1, rs2`               | `fpu`        |
| `rv_d`        | `fsgnjn_d`    | `rd, rs1, rs2`               | `fpu`        |
| `rv_d`        | `fsgnjx_d`    | `rd, rs1, rs2`               | `fpu`        |
| `rv_d`        | `fsqrt_d`     | `rd, rs1, rm`                | `fpu, fsqrt` |
| `rv_d`        | `fsub_d`      | `rd, rs1, rs2, rm`           | `fpu`        |
| `rv_d_zfa`    | `fcvtmod_w_d` | `rd, rs1`                    | `fpu, fcvt`  |
| `rv_d_zfa`    | `fleq_d`      | `rd, rs1, rs2`               | `fpu`        |
| `rv_d_zfa`    | `fli_d`       | `rd, rs1`                    | `fpu, fmove` |
| `rv_d_zfa`    | `fltq_d`      | `rd, rs1, rs2`               | `fpu`        |
| `rv_d_zfa`    | `fmaxm_d`     | `rd, rs1, rs2`               | `fpu`        |
| `rv_d_zfa`    | `fminm_d`     | `rd, rs1, rs2`               | `fpu`        |
| `rv_d_zfa`    | `fround_d`    | `rd, rs1, rm`                | `fpu`        |
| `rv_d_zfa`    | `froundnx_d`  | `rd, rs1, rm`                | `fpu`        |
| `rv_d_zfhmin` | `fcvt_d_h`    | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_d_zfhmin` | `fcvt_h_d`    | `rd, rs1, rm`                | `fpu, fcvt`  |

:RVD - Specific Extension for Double-Precision Floating-Point Instructions

| **Extension** | **Name**   | **Variable-Fields** | **Class**    |
|:--------------|:-----------|:--------------------|:-------------|
| `rv32_d_zfa`  | `fmvh_x_d` | `rd, rs1`           | `fpu, fmove` |
| `rv32_d_zfa`  | `fmvp_d_x` | `rd, rs1, rs2`      | `fpu, fmove` |

:RV32D - Specific Extension for Double-Precision Floating-Point Instructions (32 bit)

| **Extension** | **Name**    | **Variable-Fields** | **Class**    |
|:--------------|:------------|:--------------------|:-------------|
| `rv64_d`      | `fcvt_d_l`  | `rd, rs1, rm`       | `fpu, fcvt`  |
| `rv64_d`      | `fcvt_d_lu` | `rd, rs1, rm`       | `fpu, fcvt`  |
| `rv64_d`      | `fcvt_l_d`  | `rd, rs1, rm`       | `fpu, fcvt`  |
| `rv64_d`      | `fcvt_lu_d` | `rd, rs1, rm`       | `fpu, fcvt`  |
| `rv64_d`      | `fmv_d_x`   | `rd, rs1`           | `fpu, fmove` |
| `rv64_d`      | `fmv_x_d`   | `rd, rs1`           | `fpu, fmove` |

:RV64D - Specific Extension for Double-Precision Floating-Point Instructions (64 bit)
