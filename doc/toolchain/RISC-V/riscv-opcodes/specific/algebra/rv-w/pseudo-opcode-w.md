## PSEUDO-INSTRUCTIONS

| **Extension** | **Name**        | **Variable-Fields** | **Pseudo-Instruction** | **Encoding**                       |
|:--------------|:----------------|:--------------------|:-----------------------|:-----------------------------------|
| `rv_w`        | `wcpop_m`       | `wm, ws2, rd`       | `wpopc_m`              | `010000------10000010-----0001011` |
| `rv_w`        | `wfredusum_ws`  | `wm, ws2, ws1, wd`  | `wfredsum_ws`          | `000001-----------001-----0001011` |
| `rv_w`        | `wfwredusum_ws` | `wm, ws2, ws1, wd`  | `wfwredsum_ws`         | `110001-----------001-----0001011` |
| `rv_w`        | `wl1re8_w`      | `rs1, wd`           | `wl1r_w`               | `000000101000-----000-----0000111` |
| `rv_w`        | `wl2re8_w`      | `rs1, wd`           | `wl2r_w`               | `001000101000-----000-----0000111` |
| `rv_w`        | `wl4re8_w`      | `rs1, wd`           | `wl4r_w`               | `011000101000-----000-----0000111` |
| `rv_w`        | `wl8re8_w`      | `rs1, wd`           | `wl8r_w`               | `111000101000-----000-----0000111` |
| `rv_w`        | `wlm_w`         | `rs1, wd`           | `wle1_w`               | `000000101011-----000-----0000111` |
| `rv_w`        | `wmandn_mm`     | `ws2, ws1, wd`      | `wmandnot_mm`          | `0110001----------010-----0001011` |
| `rv_w`        | `wmorn_mm`      | `ws2, ws1, wd`      | `wmornot_mm`           | `0111001----------010-----0001011` |
| `rv_w`        | `wsm_w`         | `rs1, ws3`          | `wse1_w`               | `000000101011-----000-----0100111` |

:RVV - Specific Extension for Vector Operations

| **Extension** | **Name**  | **Variable-Fields** | **Pseudo-Instruction** | **Encoding**                       |
|:--------------|:----------|:--------------------|:-----------------------|:-----------------------------------|
| `rv_zwabd`    | `wabd_wx` | `wm, ws2, wd`       | `wabs_w`               | `010101------00000110-----0001011` |

:RVZW - Specific Extension for Matrix Operations
