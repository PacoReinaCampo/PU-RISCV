## PSEUDO-INSTRUCTIONS

| **Extension** | **Name**        | **Variable-Fields** | **Pseudo-Instruction** | **Encoding**                       |
|:--------------|:----------------|:--------------------|:-----------------------|:-----------------------------------|
| `rv_v`        | `vcpop_m`       | `vm, vs2, rd`       | `vpopc_m`              | `010000------10000010-----1010111` |
| `rv_v`        | `vfredusum_vs`  | `vm, vs2, vs1, vd`  | `vfredsum_vs`          | `000001-----------001-----1010111` |
| `rv_v`        | `vfwredusum_vs` | `vm, vs2, vs1, vd`  | `vfwredsum_vs`         | `110001-----------001-----1010111` |
| `rv_v`        | `vl1re8_v`      | `rs1, vd`           | `vl1r_v`               | `000000101000-----000-----0000111` |
| `rv_v`        | `vl2re8_v`      | `rs1, vd`           | `vl2r_v`               | `001000101000-----000-----0000111` |
| `rv_v`        | `vl4re8_v`      | `rs1, vd`           | `vl4r_v`               | `011000101000-----000-----0000111` |
| `rv_v`        | `vl8re8_v`      | `rs1, vd`           | `vl8r_v`               | `111000101000-----000-----0000111` |
| `rv_v`        | `vlm_v`         | `rs1, vd`           | `vle1_v`               | `000000101011-----000-----0000111` |
| `rv_v`        | `vmandn_mm`     | `vs2, vs1, vd`      | `vmandnot_mm`          | `0110001----------010-----1010111` |
| `rv_v`        | `vmorn_mm`      | `vs2, vs1, vd`      | `vmornot_mm`           | `0111001----------010-----1010111` |
| `rv_v`        | `vsm_v`         | `rs1, vs3`          | `vse1_v`               | `000000101011-----000-----0100111` |

:RVV - Specific Extension for Vector Operations

| **Extension** | **Name**  | **Variable-Fields** | **Pseudo-Instruction** | **Encoding**                       |
|:--------------|:----------|:--------------------|:-----------------------|:-----------------------------------|
| `rv_zvabd`    | `vabd_vx` | `vm, vs2, vd`       | `vabs_v`               | `010101------00000110-----1010111` |

:RVZV - Specific Extension for Vector Operations
