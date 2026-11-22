## INSTRUCTION FULL-NAMES

| **Extension** | **Name**    | **Variable-Fields**    | **Full-Name**                  |
|:--------------|:------------|:-----------------------|:-------------------------------|
| `rv_a`        | `amoadd_w`  | `rd, rs1, rs2, aq, rl` | `Atomic Add Word`              |
| `rv_a`        | `amoand_w`  | `rd, rs1, rs2, aq, rl` | `Atomic And Word`              |
| `rv_a`        | `amomaxu_w` | `rd, rs1, rs2, aq, rl` | `Atomic Maximum Unsigned Word` |
| `rv_a`        | `amomax_w`  | `rd, rs1, rs2, aq, rl` | `Atomic Maximum Word`          |
| `rv_a`        | `amominu_w` | `rd, rs1, rs2, aq, rl` | `Atomic Minimum Unsigned Word` |
| `rv_a`        | `amomin_w`  | `rd, rs1, rs2, aq, rl` | `Atomic Minimum Word`          |
| `rv_a`        | `amoor_w`   | `rd, rs1, rs2, aq, rl` | `Atomic Or Word`               |
| `rv_a`        | `amoswap_w` | `rd, rs1, rs2, aq, rl` | `Atomic Swap Word`             |
| `rv_a`        | `amoxor_w`  | `rd, rs1, rs2, aq, rl` | `Atomic Xor Word`              |
| `rv_a`        | `lr_w`      | `rd, rs1, aq, rl`      | `Load Reserved Word`           |
| `rv_a`        | `sc_w`      | `rd, rs1, rs2, aq, rl` | `Store Conditional Word`       |

:RVA - Standard Extension for Atomic Instructions

| **Extension** | **Name**    | **Variable-Fields**    | **Full-Name**                         |
|:--------------|:------------|:-----------------------|:--------------------------------------|
| `rv64_a`      | `amoadd_d`  | `rd, rs1, rs2, aq, rl` | `Atomic Add Double Word`              |
| `rv64_a`      | `amoand_d`  | `rd, rs1, rs2, aq, rl` | `Atomic And Double Word`              |
| `rv64_a`      | `amomax_d`  | `rd, rs1, rs2, aq, rl` | `Atomic Maximum Double Word`          |
| `rv64_a`      | `amomaxu_d` | `rd, rs1, rs2, aq, rl` | `Atomic Maximum Unsigned Double Word` |
| `rv64_a`      | `amomin_d`  | `rd, rs1, rs2, aq, rl` | `Atomic Minimum Double Word`          |
| `rv64_a`      | `amominu_d` | `rd, rs1, rs2, aq, rl` | `Atomic Minimum Unsigned Double Word` |
| `rv64_a`      | `amoor_d`   | `rd, rs1, rs2, aq, rl` | `Atomic Or Double Word`               |
| `rv64_a`      | `amoswap_d` | `rd, rs1, rs2, aq, rl` | `Atomic Swap Double Word`             |
| `rv64_a`      | `amoxor_d`  | `rd, rs1, rs2, aq, rl` | `Atomic Xor Double Word`              |
| `rv64_a`      | `lr_d`      | `rd, rs1, aq, rl`      | `Load Reserved Double Word`           |
| `rv64_a`      | `sc_d`      | `rd, rs1, rs2, aq, rl` | `Store Conditional Double Word`       |

:RV64A - Standard Extension for Atomic Instructions (64 bit)

| **Extension** | **Name**    | **Variable-Fields**    | **Full-Name**                       |
|:--------------|:------------|:-----------------------|:------------------------------------|
| `rv128_a`     | `amoadd_q`  | `rd, rs1, rs2, aq, rl` | `Atomic Add Quad Word`              |
| `rv128_a`     | `amoand_q`  | `rd, rs1, rs2, aq, rl` | `Atomic And Quad Word`              |
| `rv128_a`     | `amomax_q`  | `rd, rs1, rs2, aq, rl` | `Atomic Maximum Quad Word`          |
| `rv128_a`     | `amomaxu_q` | `rd, rs1, rs2, aq, rl` | `Atomic Maximum Unsigned Quad Word` |
| `rv128_a`     | `amomin_q`  | `rd, rs1, rs2, aq, rl` | `Atomic Minimum Quad Word`          |
| `rv128_a`     | `amominu_q` | `rd, rs1, rs2, aq, rl` | `Atomic Minimum Unsigned Quad Word` |
| `rv128_a`     | `amoor_q`   | `rd, rs1, rs2, aq, rl` | `Atomic Or Quad Word`               |
| `rv128_a`     | `amoswap_q` | `rd, rs1, rs2, aq, rl` | `Atomic Swap Quad Word`             |
| `rv128_a`     | `amoxor_q`  | `rd, rs1, rs2, aq, rl` | `Atomic Xor Quad Word`              |
| `rv128_a`     | `lr_q`      | `rd, rs1, aq, rl`      | `Load Reserved Quad Word`           |
| `rv128_a`     | `sc_q`      | `rd, rs1, rs2, aq, rl` | `Store Conditional Quad Word`       |

:RV128A - Standard Extension for Atomic Instructions (128 bit)

| **Extension**    | **Name**    | **Variable-Fields**    | **Full-Name**                                |
|:-----------------|:------------|:-----------------------|:---------------------------------------------|
| `rv_zabha`       | `amoadd_b`  | `rd, rs1, rs2, aq, rl` | `Atomic Add Byte`                            |
| `rv_zabha`       | `amoadd_h`  | `rd, rs1, rs2, aq, rl` | `Atomic Add Halfword`                        |
| `rv_zabha`       | `amoand_b`  | `rd, rs1, rs2, aq, rl` | `Atomic AND Byte`                            |
| `rv_zabha`       | `amoand_h`  | `rd, rs1, rs2, aq, rl` | `Atomic AND Halfword`                        |
| `rv_zabha`       | `amomax_b`  | `rd, rs1, rs2, aq, rl` | `Atomic Maximum Byte`                        |
| `rv_zabha`       | `amomax_h`  | `rd, rs1, rs2, aq, rl` | `Atomic Maximum Halfword`                    |
| `rv_zabha`       | `amomaxu_b` | `rd, rs1, rs2, aq, rl` | `Atomic Unsigned Maximum Byte`               |
| `rv_zabha`       | `amomaxu_h` | `rd, rs1, rs2, aq, rl` | `Atomic Unsigned Maximum Halfword`           |
| `rv_zabha`       | `amomin_b`  | `rd, rs1, rs2, aq, rl` | `Atomic Minimum Byte`                        |
| `rv_zabha`       | `amomin_h`  | `rd, rs1, rs2, aq, rl` | `Atomic Minimum Halfword`                    |
| `rv_zabha`       | `amominu_b` | `rd, rs1, rs2, aq, rl` | `Atomic Unsigned Minimum Byte`               |
| `rv_zabha`       | `amominu_h` | `rd, rs1, rs2, aq, rl` | `Atomic Unsigned Minimum Halfword`           |
| `rv_zabha`       | `amoor_b`   | `rd, rs1, rs2, aq, rl` | `Atomic OR Byte`                             |
| `rv_zabha`       | `amoor_h`   | `rd, rs1, rs2, aq, rl` | `Atomic OR Halfword`                         |
| `rv_zabha`       | `amoswap_b` | `rd, rs1, rs2, aq, rl` | `Atomic Swap Byte`                           |
| `rv_zabha`       | `amoswap_h` | `rd, rs1, rs2, aq, rl` | `Atomic Swap Halfword`                       |
| `rv_zabha`       | `amoxor_b`  | `rd, rs1, rs2, aq, rl` | `Atomic XOR Byte`                            |
| `rv_zabha`       | `amoxor_h`  | `rd, rs1, rs2, aq, rl` | `Atomic XOR Halfword`                        |
| `rv_zabha_zacas` | `amocas_b`  | `rd, rs1, rs2, aq, rl` | `Atomic Compare and Swap Byte`               |
| `rv_zabha_zacas` | `amocas_h`  | `rd, rs1, rs2, aq, rl` | `Atomic Compare and Swap Halfword`           |
| `rv_zabhlrsc`    | `lr_b`      | `rd, rs1, aq, rl`      | `Load Reserved Byte`                         |
| `rv_zabhlrsc`    | `lr_h`      | `rd, rs1, aq, rl`      | `Load Reserved Halfword`                     |
| `rv_zabhlrsc`    | `sc_b`      | `rd, rs1, rs2, aq, rl` | `Store Conditional Byte`                     |
| `rv_zabhlrsc`    | `sc_h`      | `rd, rs1, rs2, aq, rl` | `Store Conditional Halfword`                 |
| `rv_zacas`       | `amocas_d`  | `rd, rs1, rs2, aq, rl` | `Atomic Compare and Swap Doubleword`         |
| `rv_zacas`       | `amocas_w`  | `rd, rs1, rs2, aq, rl` | `Atomic Compare and Swap Word`               |
| `rv_zalasr`      | `lb_aq`     | `rd, rs1, rl`          | `Load-Acquire Byte`                          |
| `rv_zalasr`      | `ld_aq`     | `rd, rs1, rl`          | `Load-Acquire Doubleword`                    |
| `rv_zalasr`      | `lh_aq`     | `rd, rs1, rl`          | `Load-Acquire Halfword`                      |
| `rv_zalasr`      | `lw_aq`     | `rd, rs1, rl`          | `Load-Acquire Word`                          |
| `rv_zalasr`      | `sb_rl`     | `rs1, rs2, aq`         | `Store-Release Byte`                         |
| `rv_zalasr`      | `sd_rl`     | `rs1, rs2, aq`         | `Store-Release Doubleword`                   |
| `rv_zalasr`      | `sh_rl`     | `rs1, rs2, aq`         | `Store-Release Halfword`                     |
| `rv_zalasr`      | `sw_rl`     | `rs1, rs2, aq`         | `Store-Release Word`                         |
| `rv_zawrs`       | `wrs_nto`   | `none`                 | `Wait on Reservation Set with No Timeout`    |
| `rv_zawrs`       | `wrs_sto`   | `none`                 | `Wait on Reservation Set with Short Timeout` |

:RVZA - Standard Extension for Atomic Instructions

| **Extension** | **Name**   | **Variable-Fields**    | **Full-Name**                      |
|:--------------|:-----------|:-----------------------|:-----------------------------------|
| `rv64_zacas`  | `amocas_q` | `rd, rs1, rs2, aq, rl` | `Atomic Compare and Swap Quadword` |

:RV64ZA - Standard Extension for Atomic Instructions (64 bit)
