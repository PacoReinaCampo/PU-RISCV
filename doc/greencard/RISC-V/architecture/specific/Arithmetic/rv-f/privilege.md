## INSTRUCTION PRIVILEGE

| **Extension** | **Name**     | **Privilege** |
|:--------------|:-------------|:--------------|
| `rv_f`        | `fadd_s`     | `U`           |
| `rv_f`        | `fclass_s`   | `U`           |
| `rv_f`        | `fcvt_s_w`   | `U`           |
| `rv_f`        | `fcvt_s_wu`  | `U`           |
| `rv_f`        | `fcvt_w_s`   | `U`           |
| `rv_f`        | `fcvt_wu_s`  | `U`           |
| `rv_f`        | `fdiv_s`     | `U`           |
| `rv_f`        | `feq_s`      | `U`           |
| `rv_f`        | `fle_s`      | `U`           |
| `rv_f`        | `flt_s`      | `U`           |
| `rv_f`        | `flw`        | `U`           |
| `rv_f`        | `fmadd_s`    | `U`           |
| `rv_f`        | `fmax_s`     | `U`           |
| `rv_f`        | `fmin_s`     | `U`           |
| `rv_f`        | `fmsub_s`    | `U`           |
| `rv_f`        | `fmul_s`     | `U`           |
| `rv_f`        | `fmv_w_x`    | `U`           |
| `rv_f`        | `fmv_x_w`    | `U`           |
| `rv_f`        | `fnmadd_s`   | `U`           |
| `rv_f`        | `fnmsub_s`   | `U`           |
| `rv_f`        | `fsgnjn_s`   | `U`           |
| `rv_f`        | `fsgnj_s`    | `U`           |
| `rv_f`        | `fsgnjx_s`   | `U`           |
| `rv_f`        | `fsqrt_s`    | `U`           |
| `rv_f`        | `fsub_s`     | `U`           |
| `rv_f`        | `fsw`        | `U`           |
| `rv_f_zfa`    | `fleq_s`     | `U`           |
| `rv_f_zfa`    | `fli_s`      | `U`           |
| `rv_f_zfa`    | `fltq_s`     | `U`           |
| `rv_f_zfa`    | `fmaxm_s`    | `U`           |
| `rv_f_zfa`    | `fminm_s`    | `U`           |
| `rv_f_zfa`    | `froundnx_s` | `U`           |
| `rv_f_zfa`    | `fround_s`   | `U`           |

:RVF - Specific Extension for Single-Precision Floating-Point Instructions

| **Extension** | **Name**    | **Privilege** |
|:--------------|:------------|:--------------|
| `rv64_f`      | `fcvt_l_s`  | `U`           |
| `rv64_f`      | `fcvt_lu_s` | `U`           |
| `rv64_f`      | `fcvt_s_l`  | `U`           |
| `rv64_f`      | `fcvt_s_lu` | `U`           |

:RV64F - Specific Extension for Single-Precision Floating-Point Instructions (64 bit)

| **Extension** | **Name**      | **Privilege** |
|:--------------|:--------------|:--------------|
| `rv_zfbfmin`  | `fcvt_bf16_s` | `U`           |
| `rv_zfbfmin`  | `fcvt_s_bf16` | `U`           |

:RV64ZF - Specific Extension for Single-Precision Floating-Point Instructions

| **Extension** | **Name**     | **Privilege** |
|:--------------|:-------------|:--------------|
| `rv_zfh`      | `fadd_h`     | `U`           |
| `rv_zfh`      | `fclass_h`   | `U`           |
| `rv_zfh`      | `fcvt_h_w`   | `U`           |
| `rv_zfh`      | `fcvt_h_wu`  | `U`           |
| `rv_zfh`      | `fcvt_w_h`   | `U`           |
| `rv_zfh`      | `fcvt_wu_h`  | `U`           |
| `rv_zfh`      | `fdiv_h`     | `U`           |
| `rv_zfh`      | `feq_h`      | `U`           |
| `rv_zfh`      | `fle_h`      | `U`           |
| `rv_zfh`      | `flt_h`      | `U`           |
| `rv_zfh`      | `fmadd_h`    | `U`           |
| `rv_zfh`      | `fmax_h`     | `U`           |
| `rv_zfh`      | `fmin_h`     | `U`           |
| `rv_zfh`      | `fmsub_h`    | `U`           |
| `rv_zfh`      | `fmul_h`     | `U`           |
| `rv_zfh`      | `fnmadd_h`   | `U`           |
| `rv_zfh`      | `fnmsub_h`   | `U`           |
| `rv_zfh`      | `fsgnj_h`    | `U`           |
| `rv_zfh`      | `fsgnjn_h`   | `U`           |
| `rv_zfh`      | `fsgnjx_h`   | `U`           |
| `rv_zfh`      | `fsqrt_h`    | `U`           |
| `rv_zfh`      | `fsub_h`     | `U`           |
| `rv_zfhmin`   | `fcvt_h_s`   | `U`           |
| `rv_zfhmin`   | `fcvt_s_h`   | `U`           |
| `rv_zfhmin`   | `flh`        | `U`           |
| `rv_zfhmin`   | `fmv_h_x`    | `U`           |
| `rv_zfhmin`   | `fmv_x_h`    | `U`           |
| `rv_zfhmin`   | `fsh`        | `U`           |
| `rv_zfh_zfa`  | `fleq_h`     | `U`           |
| `rv_zfh_zfa`  | `fli_h`      | `U`           |
| `rv_zfh_zfa`  | `fltq_h`     | `U`           |
| `rv_zfh_zfa`  | `fmaxm_h`    | `U`           |
| `rv_zfh_zfa`  | `fminm_h`    | `U`           |
| `rv_zfh_zfa`  | `fround_h`   | `U`           |
| `rv_zfh_zfa`  | `froundnx_h` | `U`           |

:RVZFH - Specific Extension for Half-Precision Floating-Point Instructions

| **Extension** | **Name**    | **Privilege** |
|:--------------|:------------|:--------------|
| `rv64_zfh`    | `fcvt_h_l`  | `U`           |
| `rv64_zfh`    | `fcvt_h_lu` | `U`           |
| `rv64_zfh`    | `fcvt_l_h`  | `U`           |
| `rv64_zfh`    | `fcvt_lu_h` | `U`           |

:RV64ZFH - Specific Extension for Half-Precision Floating-Point Instructions (64 bit)
