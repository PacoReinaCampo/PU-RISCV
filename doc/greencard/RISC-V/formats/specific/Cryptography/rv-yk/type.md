## INSTRUCTION TYPES

| **Extension** | **Name**     | **Variable-Fields**             | **Encoding**                       | **Match**    | **Mask**     | **Type**  |
|:--------------|:-------------|:--------------------------------|:-----------------------------------|:-------------|:-------------|:----------|
| `rv_zykg`     | `yghsh_yy`   | `ys2, ys1, yd`                  | `1011001----------010-----1111111` | `0xb200207f` | `0xfe00707f` | `UNKNOWN` |
| `rv_zykg`     | `ygmul_yy`   | `ys2, yd`                       | `1010001-----10001010-----1111111` | `0xa208a07f` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zykned`   | `yaesdf_ys`  | `ys2, yd`                       | `1010011-----00001010-----1111111` | `0xa600a07f` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zykned`   | `yaesdf_yy`  | `ys2, yd`                       | `1010001-----00001010-----1111111` | `0xa200a07f` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zykned`   | `yaesdm_ys`  | `ys2, yd`                       | `1010011-----00000010-----1111111` | `0xa600207f` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zykned`   | `yaesdm_yy`  | `ys2, yd`                       | `1010001-----00000010-----1111111` | `0xa200207f` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zykned`   | `yaesef_ys`  | `ys2, yd`                       | `1010011-----00011010-----1111111` | `0xa601a07f` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zykned`   | `yaesef_yy`  | `ys2, yd`                       | `1010001-----00011010-----1111111` | `0xa201a07f` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zykned`   | `yaesem_ys`  | `ys2, yd`                       | `1010011-----00010010-----1111111` | `0xa601207f` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zykned`   | `yaesem_yy`  | `ys2, yd`                       | `1010001-----00010010-----1111111` | `0xa201207f` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zykned`   | `yaeskf1_yi` | `ys2, zimm5, yd`                | `1000101----------010-----1111111` | `0x8a00207f` | `0xfe00707f` | `UNKNOWN` |
| `rv_zykned`   | `yaeskf2_yi` | `ys2, zimm5, yd`                | `1010101----------010-----1111111` | `0xaa00207f` | `0xfe00707f` | `UNKNOWN` |
| `rv_zykned`   | `yaesz_ys`   | `ys2, yd`                       | `1010011-----00111010-----1111111` | `0xa603a07f` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zyknha`   | `ysha2ch_yy` | `ys2, ys1, yd`                  | `1011101----------010-----1111111` | `0xba00207f` | `0xfe00707f` | `UNKNOWN` |
| `rv_zyknha`   | `ysha2cl_yy` | `ys2, ys1, yd`                  | `1011111----------010-----1111111` | `0xbe00207f` | `0xfe00707f` | `UNKNOWN` |
| `rv_zyknha`   | `ysha2ms_yy` | `ys2, ys1, yd`                  | `1011011----------010-----1111111` | `0xb600207f` | `0xfe00707f` | `UNKNOWN` |
| `rv_zyknhb`   | `ysha2ch_yy` | `ys2, ys1, yd`                  | `1011101----------010-----1111111` | `0xba00207f` | `0xfe00707f` | `UNKNOWN` |
| `rv_zyknhb`   | `ysha2cl_yy` | `ys2, ys1, yd`                  | `1011111----------010-----1111111` | `0xbe00207f` | `0xfe00707f` | `UNKNOWN` |
| `rv_zyknhb`   | `ysha2ms_yy` | `ys2, ys1, yd`                  | `1011011----------010-----1111111` | `0xb600207f` | `0xfe00707f` | `UNKNOWN` |
| `rv_zykn`     | `yaesdf_ys`  | `ys2, yd`                       | `1010011-----00001010-----1111111` | `0xa600a07f` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zykn`     | `yaesdf_yy`  | `ys2, yd`                       | `1010001-----00001010-----1111111` | `0xa200a07f` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zykn`     | `yaesdm_ys`  | `ys2, yd`                       | `1010011-----00000010-----1111111` | `0xa600207f` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zykn`     | `yaesdm_yy`  | `ys2, yd`                       | `1010001-----00000010-----1111111` | `0xa200207f` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zykn`     | `yaesef_ys`  | `ys2, yd`                       | `1010011-----00011010-----1111111` | `0xa601a07f` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zykn`     | `yaesef_yy`  | `ys2, yd`                       | `1010001-----00011010-----1111111` | `0xa201a07f` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zykn`     | `yaesem_ys`  | `ys2, yd`                       | `1010011-----00010010-----1111111` | `0xa601207f` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zykn`     | `yaesem_yy`  | `ys2, yd`                       | `1010001-----00010010-----1111111` | `0xa201207f` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zykn`     | `yaeskf1_yi` | `ys2, zimm5, yd`                | `1000101----------010-----1111111` | `0x8a00207f` | `0xfe00707f` | `UNKNOWN` |
| `rv_zykn`     | `yaeskf2_yi` | `ys2, zimm5, yd`                | `1010101----------010-----1111111` | `0xaa00207f` | `0xfe00707f` | `UNKNOWN` |
| `rv_zykn`     | `yaesz_ys`   | `ys2, yd`                       | `1010011-----00111010-----1111111` | `0xa603a07f` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zykn`     | `yandn_yy`   | `ym, ys2, ys1, yd`              | `000001-----------000-----0101011` | `0x0400002b` | `0xfc00707f` | `OPIVV`   |
| `rv_zykn`     | `yandn_yx`   | `ym, ys2, rs1, yd`              | `000001-----------100-----0101011` | `0x0400402b` | `0xfc00707f` | `OPIVX`   |
| `rv_zykn`     | `ybrev8_y`   | `ym, ys2, yd`                   | `010010------01000010-----0101011` | `0x4804202b` | `0xfc0ff07f` | `OPMVV`   |
| `rv_zykn`     | `yrev8_y`    | `ym, ys2, yd`                   | `010010------01001010-----0101011` | `0x4804a02b` | `0xfc0ff07f` | `OPMVV`   |
| `rv_zykn`     | `yrol_yy`    | `ym, ys2, ys1, yd`              | `010101-----------000-----0101011` | `0x5400002b` | `0xfc00707f` | `OPIVV`   |
| `rv_zykn`     | `yrol_yx`    | `ym, ys2, rs1, yd`              | `010101-----------100-----0101011` | `0x5400402b` | `0xfc00707f` | `OPIVX`   |
| `rv_zykn`     | `yror_yi`    | `zimm6hi, ym, ys2, zimm6lo, yd` | `01010------------011-----0101011` | `0x5000302b` | `0xf800707f` | `OPIVI`   |
| `rv_zykn`     | `yror_yy`    | `ym, ys2, ys1, yd`              | `010100-----------000-----0101011` | `0x5000002b` | `0xfc00707f` | `OPIVV`   |
| `rv_zykn`     | `yror_yx`    | `ym, ys2, rs1, yd`              | `010100-----------100-----0101011` | `0x5000402b` | `0xfc00707f` | `OPIVX`   |
| `rv_zykn`     | `ysha2ch_yy` | `ys2, ys1, yd`                  | `1011101----------010-----1111111` | `0xba00207f` | `0xfe00707f` | `UNKNOWN` |
| `rv_zykn`     | `ysha2cl_yy` | `ys2, ys1, yd`                  | `1011111----------010-----1111111` | `0xbe00207f` | `0xfe00707f` | `UNKNOWN` |
| `rv_zykn`     | `ysha2ms_yy` | `ys2, ys1, yd`                  | `1011011----------010-----1111111` | `0xb600207f` | `0xfe00707f` | `UNKNOWN` |
| `rv_zyksed`   | `ysm4k_yi`   | `ys2, zimm5, yd`                | `1000011----------010-----1111111` | `0x8600207f` | `0xfe00707f` | `UNKNOWN` |
| `rv_zyksed`   | `ysm4r_ys`   | `ys2, yd`                       | `1010011-----10000010-----1111111` | `0xa608207f` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zyksed`   | `ysm4r_yy`   | `ys2, yd`                       | `1010001-----10000010-----1111111` | `0xa208207f` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zyksh`    | `ysm3c_yi`   | `ys2, zimm5, yd`                | `1010111----------010-----1111111` | `0xae00207f` | `0xfe00707f` | `UNKNOWN` |
| `rv_zyksh`    | `ysm3me_yy`  | `ys2, ys1, yd`                  | `1000001----------010-----1111111` | `0x8200207f` | `0xfe00707f` | `UNKNOWN` |
| `rv_zyks`     | `yandn_yy`   | `ym, ys2, ys1, yd`              | `000001-----------000-----0101011` | `0x0400002b` | `0xfc00707f` | `OPIVV`   |
| `rv_zyks`     | `yandn_yx`   | `ym, ys2, rs1, yd`              | `000001-----------100-----0101011` | `0x0400402b` | `0xfc00707f` | `OPIVX`   |
| `rv_zyks`     | `ybrev8_y`   | `ym, ys2, yd`                   | `010010------01000010-----0101011` | `0x4804202b` | `0xfc0ff07f` | `OPMVV`   |
| `rv_zyks`     | `yrev8_y`    | `ym, ys2, yd`                   | `010010------01001010-----0101011` | `0x4804a02b` | `0xfc0ff07f` | `OPMVV`   |
| `rv_zyks`     | `yrol_yy`    | `ym, ys2, ys1, yd`              | `010101-----------000-----0101011` | `0x5400002b` | `0xfc00707f` | `OPIVV`   |
| `rv_zyks`     | `yrol_yx`    | `ym, ys2, rs1, yd`              | `010101-----------100-----0101011` | `0x5400402b` | `0xfc00707f` | `OPIVX`   |
| `rv_zyks`     | `yror_yi`    | `zimm6hi, ym, ys2, zimm6lo, yd` | `01010------------011-----0101011` | `0x5000302b` | `0xf800707f` | `OPIVI`   |
| `rv_zyks`     | `yror_yy`    | `ym, ys2, ys1, yd`              | `010100-----------000-----0101011` | `0x5000002b` | `0xfc00707f` | `OPIVV`   |
| `rv_zyks`     | `yror_yx`    | `ym, ys2, rs1, yd`              | `010100-----------100-----0101011` | `0x5000402b` | `0xfc00707f` | `OPIVX`   |
| `rv_zyks`     | `ysm3c_yi`   | `ys2, zimm5, yd`                | `1010111----------010-----1111111` | `0xae00207f` | `0xfe00707f` | `UNKNOWN` |
| `rv_zyks`     | `ysm3me_yy`  | `ys2, ys1, yd`                  | `1000001----------010-----1111111` | `0x8200207f` | `0xfe00707f` | `UNKNOWN` |
| `rv_zyks`     | `ysm4k_yi`   | `ys2, zimm5, yd`                | `1000011----------010-----1111111` | `0x8600207f` | `0xfe00707f` | `UNKNOWN` |
| `rv_zyks`     | `ysm4r_ys`   | `ys2, yd`                       | `1010011-----10000010-----1111111` | `0xa608207f` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zyks`     | `ysm4r_yy`   | `ys2, yd`                       | `1010001-----10000010-----1111111` | `0xa208207f` | `0xfe0ff07f` | `UNKNOWN` |

:RVZYK - Specific Extension for Tensor Cryptography Instructions
