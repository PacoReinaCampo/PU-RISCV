## INSTRUCTION CLASSES

| **Extension** | **Name**     | **Variable-Fields**          | **Class**    |
|:--------------|:-------------|:-----------------------------|:-------------|
| `rv_q`        | `fadd_q`     | `rd, rs1, rs2, rm`           | `fpu`        |
| `rv_q`        | `fclass_q`   | `rd, rs1`                    | `fpu`        |
| `rv_q`        | `fcvt_d_q`   | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_q`        | `fcvt_q_d`   | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_q`        | `fcvt_q_s`   | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_q`        | `fcvt_q_w`   | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_q`        | `fcvt_q_wu`  | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_q`        | `fcvt_s_q`   | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_q`        | `fcvt_w_q`   | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_q`        | `fcvt_wu_q`  | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_q`        | `fdiv_q`     | `rd, rs1, rs2, rm`           | `fpu, fdiv`  |
| `rv_q`        | `feq_q`      | `rd, rs1, rs2`               | `fpu`        |
| `rv_q`        | `fle_q`      | `rd, rs1, rs2`               | `fpu`        |
| `rv_q`        | `flq`        | `rd, rs1, imm12`             | `fpu, load`  |
| `rv_q`        | `flt_q`      | `rd, rs1, rs2`               | `fpu`        |
| `rv_q`        | `fmadd_q`    | `rd, rs1, rs2, rs3, rm`      | `fpu, fma`   |
| `rv_q`        | `fmax_q`     | `rd, rs1, rs2`               | `fpu`        |
| `rv_q`        | `fmin_q`     | `rd, rs1, rs2`               | `fpu`        |
| `rv_q`        | `fmsub_q`    | `rd, rs1, rs2, rs3, rm`      | `fpu, fma`   |
| `rv_q`        | `fmul_q`     | `rd, rs1, rs2, rm`           | `fpu`        |
| `rv_q`        | `fnmadd_q`   | `rd, rs1, rs2, rs3, rm`      | `fpu, fma`   |
| `rv_q`        | `fnmsub_q`   | `rd, rs1, rs2, rs3, rm`      | `fpu, fma`   |
| `rv_q`        | `fsgnjn_q`   | `rd, rs1, rs2`               | `fpu`        |
| `rv_q`        | `fsgnj_q`    | `rd, rs1, rs2`               | `fpu`        |
| `rv_q`        | `fsgnjx_q`   | `rd, rs1, rs2`               | `fpu`        |
| `rv_q`        | `fsq`        | `imm12hi, rs1, rs2, imm12lo` | `fpu, store` |
| `rv_q`        | `fsqrt_q`    | `rd, rs1, rm`                | `fpu, fsqrt` |
| `rv_q`        | `fsub_q`     | `rd, rs1, rs2, rm`           | `fpu`        |
| `rv_q_zfa`    | `fleq_q`     | `rd, rs1, rs2`               | `fpu`        |
| `rv_q_zfa`    | `fli_q`      | `rd, rs1`                    | `fpu, fmove` |
| `rv_q_zfa`    | `fltq_q`     | `rd, rs1, rs2`               | `fpu`        |
| `rv_q_zfa`    | `fmaxm_q`    | `rd, rs1, rs2`               | `fpu`        |
| `rv_q_zfa`    | `fminm_q`    | `rd, rs1, rs2`               | `fpu`        |
| `rv_q_zfa`    | `froundnx_q` | `rd, rs1, rm`                | `fpu`        |
| `rv_q_zfa`    | `fround_q`   | `rd, rs1, rm`                | `fpu`        |
| `rv_q_zfhmin` | `fcvt_h_q`   | `rd, rs1, rm`                | `fpu, fcvt`  |
| `rv_q_zfhmin` | `fcvt_q_h`   | `rd, rs1, rm`                | `fpu, fcvt`  |

:RVQ - Specific Extension for Quadruple-Precision Floating-Point Instructions

| **Extension** | **Name**    | **Variable-Fields** | **Class**    |
|:--------------|:------------|:--------------------|:-------------|
| `rv64_q`      | `fcvt_l_q`  | `rd, rs1, rm`       | `fpu, fcvt`  |
| `rv64_q`      | `fcvt_lu_q` | `rd, rs1, rm`       | `fpu, fcvt`  |
| `rv64_q`      | `fcvt_q_l`  | `rd, rs1, rm`       | `fpu, fcvt`  |
| `rv64_q`      | `fcvt_q_lu` | `rd, rs1, rm`       | `fpu, fcvt`  |
| `rv64_q_zfa`  | `fmvh_x_q`  | `rd, rs1`           | `fpu, fmove` |
| `rv64_q_zfa`  | `fmvp_q_x`  | `rd, rs1, rs2`      | `fpu, fmove` |

:RV64Q - Specific Extension for Quadruple-Precision Floating-Point Instructions (64 bit)
