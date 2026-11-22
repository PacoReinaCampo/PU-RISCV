## PSEUDO-INSTRUCTIONS

| **Extension** | **Name**        | **Variable-Fields** | **Pseudo-Instruction** | **Encoding**                       |
|:--------------|:----------------|:--------------------|:-----------------------|:-----------------------------------|
| `rv_y`        | `ycpop_m`       | `ym, ys2, rd`       | `ypopc_m`              | `010000------10000010-----0101011` |
| `rv_y`        | `yfredusum_ys`  | `ym, ys2, ys1, yd`  | `yfredsum_ys`          | `000001-----------001-----0101011` |
| `rv_y`        | `yfwredusum_ys` | `ym, ys2, ys1, yd`  | `yfwredsum_ys`         | `110001-----------001-----0101011` |
| `rv_y`        | `yl1re8_y`      | `rs1, yd`           | `yl1r_y`               | `000000101000-----000-----0000111` |
| `rv_y`        | `yl2re8_y`      | `rs1, yd`           | `yl2r_y`               | `001000101000-----000-----0000111` |
| `rv_y`        | `yl4re8_y`      | `rs1, yd`           | `yl4r_y`               | `011000101000-----000-----0000111` |
| `rv_y`        | `yl8re8_y`      | `rs1, yd`           | `yl8r_y`               | `111000101000-----000-----0000111` |
| `rv_y`        | `ylm_y`         | `rs1, yd`           | `yle1_y`               | `000000101011-----000-----0000111` |
| `rv_y`        | `ymandn_mm`     | `ys2, ys1, yd`      | `ymandnot_mm`          | `0110001----------010-----0101011` |
| `rv_y`        | `ymorn_mm`      | `ys2, ys1, yd`      | `ymornot_mm`           | `0111001----------010-----0101011` |
| `rv_y`        | `ysm_y`         | `rs1, ys3`          | `yse1_y`               | `000000101011-----000-----0100111` |

:RVY - Specific Extension for Tensor Operations

| **Extension** | **Name**  | **Variable-Fields** | **Pseudo-Instruction** | **Encoding**                       |
|:--------------|:----------|:--------------------|:-----------------------|:-----------------------------------|
| `rv_zyabd`    | `yabd_yx` | `ym, ys2, yd`       | `yabs_y`               | `010101------00000110-----0101011` |

:RVZY - Specific Extension for Tensor Operations
