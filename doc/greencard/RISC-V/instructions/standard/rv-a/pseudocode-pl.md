## INSTRUCTION PSEUDO-CODE (PL)

| **Extension** | **Name**    | **Variable-Fields**    | **Pseudo-Code**                                         |
|:--------------|:------------|:-----------------------|:--------------------------------------------------------|
| `rv_a`        | `amoadd_w`  | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_add(rs1, rs2, 32, aq, rl), 32, XLEN);`  |
| `rv_a`        | `amoand_w`  | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_and(rs1, rs2, 32, aq, rl), 32, XLEN);`  |
| `rv_a`        | `amomaxu_w` | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_maxu(rs1, rs2, 32, aq, rl), 32, XLEN);` |
| `rv_a`        | `amomax_w`  | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_max(rs1, rs2, 32, aq, rl), 32, XLEN);`  |
| `rv_a`        | `amominu_w` | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_minu(rs1, rs2, 32, aq, rl), 32, XLEN);` |
| `rv_a`        | `amomin_w`  | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_min(rs1, rs2, 32, aq, rl), 32, XLEN);`  |
| `rv_a`        | `amoor_w`   | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_or(rs1, rs2, 32, aq, rl), 32, XLEN);`   |
| `rv_a`        | `amoswap_w` | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_swap(rs1, rs2, 32, aq, rl), 32, XLEN);` |
| `rv_a`        | `amoxor_w`  | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_xor(rs1, rs2, 32, aq, rl), 32, XLEN);`  |
| `rv_a`        | `lr_w`      | `rd, rs1, aq, rl`      | `rd = sx(load_reserved(rs1, 32, aq, rl), 32, XLEN);`    |
| `rv_a`        | `sc_w`      | `rd, rs1, rs2, aq, rl` | `rd = store_conditional(rs1, rs2, 32, aq, rl);`         |

:RVA - Standard Extension for Atomic Instructions

| **Extension** | **Name**    | **Variable-Fields**    | **Pseudo-Code**                                         |
|:--------------|:------------|:-----------------------|:--------------------------------------------------------|
| `rv64_a`      | `amoadd_d`  | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_add(rs1, rs2, 64, aq, rl), 64, XLEN);`  |
| `rv64_a`      | `amoand_d`  | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_and(rs1, rs2, 64, aq, rl), 64, XLEN);`  |
| `rv64_a`      | `amomax_d`  | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_max(rs1, rs2, 64, aq, rl), 64, XLEN);`  |
| `rv64_a`      | `amomaxu_d` | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_maxu(rs1, rs2, 64, aq, rl), 64, XLEN);` |
| `rv64_a`      | `amomin_d`  | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_min(rs1, rs2, 64, aq, rl), 64, XLEN);`  |
| `rv64_a`      | `amominu_d` | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_minu(rs1, rs2, 64, aq, rl), 64, XLEN);` |
| `rv64_a`      | `amoor_d`   | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_or(rs1, rs2, 64, aq, rl), 64, XLEN);`   |
| `rv64_a`      | `amoswap_d` | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_swap(rs1, rs2, 64, aq, rl), 64, XLEN);` |
| `rv64_a`      | `amoxor_d`  | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_xor(rs1, rs2, 64, aq, rl), 64, XLEN);`  |
| `rv64_a`      | `lr_d`      | `rd, rs1, aq, rl`      | `rd = sx(load_reserved(rs1, 64, aq, rl), 64, XLEN);`    |
| `rv64_a`      | `sc_d`      | `rd, rs1, rs2, aq, rl` | `rd = store_conditional(rs1, rs2, 64, aq, rl);`         |

:RV64A - Standard Extension for Atomic Instructions (64 bit)

| **Extension** | **Name**    | **Variable-Fields**    | **Pseudo-Code**                                           |
|:--------------|:------------|:-----------------------|:----------------------------------------------------------|
| `rv128_a`     | `amoadd_q`  | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_add(rs1, rs2, 128, aq, rl), 128, XLEN);`  |
| `rv128_a`     | `amoand_q`  | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_and(rs1, rs2, 128, aq, rl), 128, XLEN);`  |
| `rv128_a`     | `amomax_q`  | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_max(rs1, rs2, 128, aq, rl), 128, XLEN);`  |
| `rv128_a`     | `amomaxu_q` | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_maxu(rs1, rs2, 128, aq, rl), 128, XLEN);` |
| `rv128_a`     | `amomin_q`  | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_min(rs1, rs2, 128, aq, rl), 128, XLEN);`  |
| `rv128_a`     | `amominu_q` | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_minu(rs1, rs2, 128, aq, rl), 128, XLEN);` |
| `rv128_a`     | `amoor_q`   | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_or(rs1, rs2, 128, aq, rl), 128, XLEN);`   |
| `rv128_a`     | `amoswap_q` | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_swap(rs1, rs2, 128, aq, rl), 128, XLEN);` |
| `rv128_a`     | `amoxor_q`  | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_xor(rs1, rs2, 128, aq, rl), 128, XLEN);`  |
| `rv128_a`     | `lr_q`      | `rd, rs1, aq, rl`      | `rd = sx(load_reserved(rs1, 128, aq, rl), 128, XLEN);`    |
| `rv128_a`     | `sc_q`      | `rd, rs1, rs2, aq, rl` | `rd = store_conditional(rs1, rs2, 128, aq, rl);`          |

:RV128A - Standard Extension for Atomic Instructions (128 bit)

| **Extension**    | **Name**    | **Variable-Fields**    | **Pseudo-Code**                                                                                                                   |
|:-----------------|:------------|:-----------------------|:----------------------------------------------------------------------------------------------------------------------------------|
| `rv_zabha`       | `amoadd_b`  | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_add(rs1, rs2, 8, aq, rl), 8, XLEN);`                                                                              |
| `rv_zabha`       | `amoadd_h`  | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_add(rs1, rs2, 16, aq, rl), 16, XLEN);`                                                                            |
| `rv_zabha`       | `amoand_b`  | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_and(rs1, rs2, 8, aq, rl), 8, XLEN);`                                                                              |
| `rv_zabha`       | `amoand_h`  | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_and(rs1, rs2, 16, aq, rl), 16, XLEN);`                                                                            |
| `rv_zabha`       | `amomax_b`  | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_max(rs1, rs2, 8, aq, rl), 8, XLEN);`                                                                              |
| `rv_zabha`       | `amomax_h`  | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_max(rs1, rs2, 16, aq, rl), 16, XLEN);`                                                                            |
| `rv_zabha`       | `amomaxu_b` | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_maxu(rs1, rs2, 8, aq, rl), 8, XLEN);`                                                                             |
| `rv_zabha`       | `amomaxu_h` | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_maxu(rs1, rs2, 16, aq, rl), 16, XLEN);`                                                                           |
| `rv_zabha`       | `amomin_b`  | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_min(rs1, rs2, 8, aq, rl), 8, XLEN);`                                                                              |
| `rv_zabha`       | `amomin_h`  | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_min(rs1, rs2, 16, aq, rl), 16, XLEN);`                                                                            |
| `rv_zabha`       | `amominu_b` | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_minu(rs1, rs2, 8, aq, rl), 8, XLEN);`                                                                             |
| `rv_zabha`       | `amominu_h` | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_minu(rs1, rs2, 16, aq, rl), 16, XLEN);`                                                                           |
| `rv_zabha`       | `amoor_b`   | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_or(rs1, rs2, 8, aq, rl), 8, XLEN);`                                                                               |
| `rv_zabha`       | `amoor_h`   | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_or(rs1, rs2, 16, aq, rl), 16, XLEN);`                                                                             |
| `rv_zabha`       | `amoswap_b` | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_swap(rs1, rs2, 8, aq, rl), 8, XLEN);`                                                                             |
| `rv_zabha`       | `amoswap_h` | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_swap(rs1, rs2, 16, aq, rl), 16, XLEN);`                                                                           |
| `rv_zabha`       | `amoxor_b`  | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_xor(rs1, rs2, 8, aq, rl), 8, XLEN);`                                                                              |
| `rv_zabha`       | `amoxor_h`  | `rd, rs1, rs2, aq, rl` | `rd = sx(atomic_xor(rs1, rs2, 16, aq, rl), 16, XLEN);`                                                                            |
| `rv_zabha_zacas` | `amocas_b`  | `rd, rs1, rs2, aq, rl` | `rd = sx(cas_u8(rs1, bits(rd, 7, 0), bits(rs2, 7, 0), aq, rl));`                                                                  |
| `rv_zabha_zacas` | `amocas_h`  | `rd, rs1, rs2, aq, rl` | `rd = sx(cas_u16(rs1, bits(rd, 15, 0), bits(rs2, 15, 0), aq, rl));`                                                               |
| `rv_zabhlrsc`    | `lr_b`      | `rd, rs1, aq, rl`      | `rd = sx(load_reserved(rs1, 8, aq, rl), 8, XLEN);`                                                                                |
| `rv_zabhlrsc`    | `lr_h`      | `rd, rs1, aq, rl`      | `rd = sx(load_reserved(rs1, 16, aq, rl), 16, XLEN);`                                                                              |
| `rv_zabhlrsc`    | `sc_b`      | `rd, rs1, rs2, aq, rl` | `rd = store_conditional(rs1, rs2, 8, aq, rl);`                                                                                    |
| `rv_zabhlrsc`    | `sc_h`      | `rd, rs1, rs2, aq, rl` | `rd = store_conditional(rs1, rs2, 16, aq, rl);`                                                                                   |
| `rv_zacas`       | `amocas_d`  | `rd, rs1, rs2, aq, rl` | `cas_old = cas_u64(rs1, cas_operand(rd, 64, XLEN), cas_operand(rs2, 64, XLEN), aq, rl); write_cas_result(rd, 64, XLEN, cas_old);` |
| `rv_zacas`       | `amocas_w`  | `rd, rs1, rs2, aq, rl` | `rd = sx(cas_u32(rs1, bits(rd, 31, 0), bits(rs2, 31, 0), aq, rl));`                                                               |
| `rv_zalasr`      | `lb_aq`     | `rd, rs1, rl`          | `rd = load_acquire_s8(rs1, rl);`                                                                                                  |
| `rv_zalasr`      | `ld_aq`     | `rd, rs1, rl`          | `rd = load_acquire_s64(rs1, rl);`                                                                                                 |
| `rv_zalasr`      | `lh_aq`     | `rd, rs1, rl`          | `rd = load_acquire_s16(rs1, rl);`                                                                                                 |
| `rv_zalasr`      | `lw_aq`     | `rd, rs1, rl`          | `rd = load_acquire_s32(rs1, rl);`                                                                                                 |
| `rv_zalasr`      | `sb_rl`     | `rs1, rs2, aq`         | `store_release_u8(rs1, u8(rs2), aq);`                                                                                             |
| `rv_zalasr`      | `sd_rl`     | `rs1, rs2, aq`         | `store_release_u64(rs1, u64(rs2), aq);`                                                                                           |
| `rv_zalasr`      | `sh_rl`     | `rs1, rs2, aq`         | `store_release_u16(rs1, u16(rs2), aq);`                                                                                           |
| `rv_zalasr`      | `sw_rl`     | `rs1, rs2, aq`         | `store_release_u32(rs1, u32(rs2), aq);`                                                                                           |
| `rv_zawrs`       | `wrs_nto`   | `none`                 | `wait_on_reservation(none);`                                                                                                      |
| `rv_zawrs`       | `wrs_sto`   | `none`                 | `wait_on_reservation(short_timeout);`                                                                                             |

:RVZA - Standard Extension for Atomic Instructions

| **Extension** | **Name**   | **Variable-Fields**    | **Pseudo-Code**                                                                |
|:--------------|:-----------|:-----------------------|:-------------------------------------------------------------------------------|
| `rv64_zacas`  | `amocas_q` | `rd, rs1, rs2, aq, rl` | `write_register_pair(rd, cas_u128(rs1, reg_pair(rd), reg_pair(rs2), aq, rl));` |

:RV64ZA - Standard Extension for Atomic Instructions (64 bit)
