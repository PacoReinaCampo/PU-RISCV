## INSTRUCTION CLASSES

| **Extension** | **Name**    | **Variable-Fields**    | **Class** |
|:--------------|:------------|:-----------------------|:----------|
| `rv_a`        | `amoadd_w`  | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv_a`        | `amoand_w`  | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv_a`        | `amomaxu_w` | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv_a`        | `amomax_w`  | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv_a`        | `amominu_w` | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv_a`        | `amomin_w`  | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv_a`        | `amoor_w`   | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv_a`        | `amoswap_w` | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv_a`        | `amoxor_w`  | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv_a`        | `lr_w`      | `rd, rs1, aq, rl`      | `atomic`  |
| `rv_a`        | `sc_w`      | `rd, rs1, rs2, aq, rl` | `atomic`  |

:RVA - Standard Extension for Atomic Instructions

| **Extension** | **Name**    | **Variable-Fields**    | **Class** |
|:--------------|:------------|:-----------------------|:----------|
| `rv64_a`      | `amoadd_d`  | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv64_a`      | `amoand_d`  | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv64_a`      | `amomax_d`  | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv64_a`      | `amomaxu_d` | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv64_a`      | `amomin_d`  | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv64_a`      | `amominu_d` | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv64_a`      | `amoor_d`   | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv64_a`      | `amoswap_d` | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv64_a`      | `amoxor_d`  | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv64_a`      | `lr_d`      | `rd, rs1, aq, rl`      | `atomic`  |
| `rv64_a`      | `sc_d`      | `rd, rs1, rs2, aq, rl` | `atomic`  |

:RV64A - Standard Extension for Atomic Instructions (64 bit)

| **Extension** | **Name**    | **Variable-Fields**    | **Class** |
|:--------------|:------------|:-----------------------|:----------|
| `rv128_a`     | `amoadd_q`  | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv128_a`     | `amoand_q`  | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv128_a`     | `amomax_q`  | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv128_a`     | `amomaxu_q` | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv128_a`     | `amomin_q`  | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv128_a`     | `amominu_q` | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv128_a`     | `amoor_q`   | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv128_a`     | `amoswap_q` | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv128_a`     | `amoxor_q`  | `rd, rs1, rs2, aq, rl` | `atomic`  |
| `rv128_a`     | `lr_q`      | `rd, rs1, aq, rl`      | `atomic`  |
| `rv128_a`     | `sc_q`      | `rd, rs1, rs2, aq, rl` | `atomic`  |

:RV128A - Standard Extension for Atomic Instructions (128 bit)

| **Extension**    | **Name**    | **Variable-Fields**    | **Class**                   |
|:-----------------|:------------|:-----------------------|:----------------------------|
| `rv_zabha`       | `amoadd_b`  | `rd, rs1, rs2, aq, rl` | `atomic, load, store`       |
| `rv_zabha`       | `amoadd_h`  | `rd, rs1, rs2, aq, rl` | `atomic, load, store`       |
| `rv_zabha`       | `amoand_b`  | `rd, rs1, rs2, aq, rl` | `atomic, load, store`       |
| `rv_zabha`       | `amoand_h`  | `rd, rs1, rs2, aq, rl` | `atomic, load, store`       |
| `rv_zabha`       | `amomax_b`  | `rd, rs1, rs2, aq, rl` | `atomic, load, store`       |
| `rv_zabha`       | `amomax_h`  | `rd, rs1, rs2, aq, rl` | `atomic, load, store`       |
| `rv_zabha`       | `amomaxu_b` | `rd, rs1, rs2, aq, rl` | `atomic, load, store`       |
| `rv_zabha`       | `amomaxu_h` | `rd, rs1, rs2, aq, rl` | `atomic, load, store`       |
| `rv_zabha`       | `amomin_b`  | `rd, rs1, rs2, aq, rl` | `atomic, load, store`       |
| `rv_zabha`       | `amomin_h`  | `rd, rs1, rs2, aq, rl` | `atomic, load, store`       |
| `rv_zabha`       | `amominu_b` | `rd, rs1, rs2, aq, rl` | `atomic, load, store`       |
| `rv_zabha`       | `amominu_h` | `rd, rs1, rs2, aq, rl` | `atomic, load, store`       |
| `rv_zabha`       | `amoor_b`   | `rd, rs1, rs2, aq, rl` | `atomic, load, store`       |
| `rv_zabha`       | `amoor_h`   | `rd, rs1, rs2, aq, rl` | `atomic, load, store`       |
| `rv_zabha`       | `amoswap_b` | `rd, rs1, rs2, aq, rl` | `atomic, load, store`       |
| `rv_zabha`       | `amoswap_h` | `rd, rs1, rs2, aq, rl` | `atomic, load, store`       |
| `rv_zabha`       | `amoxor_b`  | `rd, rs1, rs2, aq, rl` | `atomic, load, store`       |
| `rv_zabha`       | `amoxor_h`  | `rd, rs1, rs2, aq, rl` | `atomic, load, store`       |
| `rv_zabha_zacas` | `amocas_b`  | `rd, rs1, rs2, aq, rl` | `atomic, load, store`       |
| `rv_zabha_zacas` | `amocas_h`  | `rd, rs1, rs2, aq, rl` | `atomic, load, store`       |
| `rv_zabhlrsc`    | `lr_b`      | `rd, rs1, aq, rl`      | `atomic, load-reserved`     |
| `rv_zabhlrsc`    | `lr_h`      | `rd, rs1, aq, rl`      | `atomic, load-reserved`     |
| `rv_zabhlrsc`    | `sc_b`      | `rd, rs1, rs2, aq, rl` | `atomic, store-conditional` |
| `rv_zabhlrsc`    | `sc_h`      | `rd, rs1, rs2, aq, rl` | `atomic, store-conditional` |
| `rv_zacas`       | `amocas_d`  | `rd, rs1, rs2, aq, rl` | `atomic, load, store`       |
| `rv_zacas`       | `amocas_w`  | `rd, rs1, rs2, aq, rl` | `atomic, load, store`       |
| `rv_zalasr`      | `lb_aq`     | `rd, rs1, rl`          | `atomic, load`              |
| `rv_zalasr`      | `ld_aq`     | `rd, rs1, rl`          | `atomic, load`              |
| `rv_zalasr`      | `lh_aq`     | `rd, rs1, rl`          | `atomic, load`              |
| `rv_zalasr`      | `lw_aq`     | `rd, rs1, rl`          | `atomic, load`              |
| `rv_zalasr`      | `sb_rl`     | `rs1, rs2, aq`         | `atomic, store`             |
| `rv_zalasr`      | `sd_rl`     | `rs1, rs2, aq`         | `atomic, store`             |
| `rv_zalasr`      | `sh_rl`     | `rs1, rs2, aq`         | `atomic, store`             |
| `rv_zalasr`      | `sw_rl`     | `rs1, rs2, aq`         | `atomic, store`             |
| `rv_zawrs`       | `wrs_nto`   | `none`                 | `system, atomic`            |
| `rv_zawrs`       | `wrs_sto`   | `none`                 | `system, atomic`            |

:RVZA - Standard Extension for Atomic Instructions

| **Extension** | **Name**   | **Variable-Fields**    | **Class**             |
|:--------------|:-----------|:-----------------------|:----------------------|
| `rv64_zacas`  | `amocas_q` | `rd, rs1, rs2, aq, rl` | `atomic, load, store` |

:RV64ZA - Standard Extension for Atomic Instructions (64 bit)
