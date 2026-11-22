## INSTRUCTION TYPES

| **Extension** | **Name**     | **Variable-Fields**             | **Encoding**                       | **Match**    | **Mask**     | **Type**  |
|:--------------|:-------------|:--------------------------------|:-----------------------------------|:-------------|:-------------|:----------|
| `rv_zvkg`     | `vghsh_vv`   | `vs2, vs1, vd`                  | `1011001----------010-----1110111` | `0xb2002077` | `0xfe00707f` | `UNKNOWN` |
| `rv_zvkg`     | `vgmul_vv`   | `vs2, vd`                       | `1010001-----10001010-----1110111` | `0xa208a077` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zvkned`   | `vaesdf_vs`  | `vs2, vd`                       | `1010011-----00001010-----1110111` | `0xa600a077` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zvkned`   | `vaesdf_vv`  | `vs2, vd`                       | `1010001-----00001010-----1110111` | `0xa200a077` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zvkned`   | `vaesdm_vs`  | `vs2, vd`                       | `1010011-----00000010-----1110111` | `0xa6002077` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zvkned`   | `vaesdm_vv`  | `vs2, vd`                       | `1010001-----00000010-----1110111` | `0xa2002077` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zvkned`   | `vaesef_vs`  | `vs2, vd`                       | `1010011-----00011010-----1110111` | `0xa601a077` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zvkned`   | `vaesef_vv`  | `vs2, vd`                       | `1010001-----00011010-----1110111` | `0xa201a077` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zvkned`   | `vaesem_vs`  | `vs2, vd`                       | `1010011-----00010010-----1110111` | `0xa6012077` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zvkned`   | `vaesem_vv`  | `vs2, vd`                       | `1010001-----00010010-----1110111` | `0xa2012077` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zvkned`   | `vaeskf1_vi` | `vs2, zimm5, vd`                | `1000101----------010-----1110111` | `0x8a002077` | `0xfe00707f` | `UNKNOWN` |
| `rv_zvkned`   | `vaeskf2_vi` | `vs2, zimm5, vd`                | `1010101----------010-----1110111` | `0xaa002077` | `0xfe00707f` | `UNKNOWN` |
| `rv_zvkned`   | `vaesz_vs`   | `vs2, vd`                       | `1010011-----00111010-----1110111` | `0xa603a077` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zvknha`   | `vsha2ch_vv` | `vs2, vs1, vd`                  | `1011101----------010-----1110111` | `0xba002077` | `0xfe00707f` | `UNKNOWN` |
| `rv_zvknha`   | `vsha2cl_vv` | `vs2, vs1, vd`                  | `1011111----------010-----1110111` | `0xbe002077` | `0xfe00707f` | `UNKNOWN` |
| `rv_zvknha`   | `vsha2ms_vv` | `vs2, vs1, vd`                  | `1011011----------010-----1110111` | `0xb6002077` | `0xfe00707f` | `UNKNOWN` |
| `rv_zvknhb`   | `vsha2ch_vv` | `vs2, vs1, vd`                  | `1011101----------010-----1110111` | `0xba002077` | `0xfe00707f` | `UNKNOWN` |
| `rv_zvknhb`   | `vsha2cl_vv` | `vs2, vs1, vd`                  | `1011111----------010-----1110111` | `0xbe002077` | `0xfe00707f` | `UNKNOWN` |
| `rv_zvknhb`   | `vsha2ms_vv` | `vs2, vs1, vd`                  | `1011011----------010-----1110111` | `0xb6002077` | `0xfe00707f` | `UNKNOWN` |
| `rv_zvkn`     | `vaesdf_vs`  | `vs2, vd`                       | `1010011-----00001010-----1110111` | `0xa600a077` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zvkn`     | `vaesdf_vv`  | `vs2, vd`                       | `1010001-----00001010-----1110111` | `0xa200a077` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zvkn`     | `vaesdm_vs`  | `vs2, vd`                       | `1010011-----00000010-----1110111` | `0xa6002077` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zvkn`     | `vaesdm_vv`  | `vs2, vd`                       | `1010001-----00000010-----1110111` | `0xa2002077` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zvkn`     | `vaesef_vs`  | `vs2, vd`                       | `1010011-----00011010-----1110111` | `0xa601a077` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zvkn`     | `vaesef_vv`  | `vs2, vd`                       | `1010001-----00011010-----1110111` | `0xa201a077` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zvkn`     | `vaesem_vs`  | `vs2, vd`                       | `1010011-----00010010-----1110111` | `0xa6012077` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zvkn`     | `vaesem_vv`  | `vs2, vd`                       | `1010001-----00010010-----1110111` | `0xa2012077` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zvkn`     | `vaeskf1_vi` | `vs2, zimm5, vd`                | `1000101----------010-----1110111` | `0x8a002077` | `0xfe00707f` | `UNKNOWN` |
| `rv_zvkn`     | `vaeskf2_vi` | `vs2, zimm5, vd`                | `1010101----------010-----1110111` | `0xaa002077` | `0xfe00707f` | `UNKNOWN` |
| `rv_zvkn`     | `vaesz_vs`   | `vs2, vd`                       | `1010011-----00111010-----1110111` | `0xa603a077` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zvkn`     | `vandn_vv`   | `vm, vs2, vs1, vd`              | `000001-----------000-----1010111` | `0x04000057` | `0xfc00707f` | `OPIVV`   |
| `rv_zvkn`     | `vandn_vx`   | `vm, vs2, rs1, vd`              | `000001-----------100-----1010111` | `0x04004057` | `0xfc00707f` | `OPIVX`   |
| `rv_zvkn`     | `vbrev8_v`   | `vm, vs2, vd`                   | `010010------01000010-----1010111` | `0x48042057` | `0xfc0ff07f` | `OPMVV`   |
| `rv_zvkn`     | `vrev8_v`    | `vm, vs2, vd`                   | `010010------01001010-----1010111` | `0x4804a057` | `0xfc0ff07f` | `OPMVV`   |
| `rv_zvkn`     | `vrol_vv`    | `vm, vs2, vs1, vd`              | `010101-----------000-----1010111` | `0x54000057` | `0xfc00707f` | `OPIVV`   |
| `rv_zvkn`     | `vrol_vx`    | `vm, vs2, rs1, vd`              | `010101-----------100-----1010111` | `0x54004057` | `0xfc00707f` | `OPIVX`   |
| `rv_zvkn`     | `vror_vi`    | `zimm6hi, vm, vs2, zimm6lo, vd` | `01010------------011-----1010111` | `0x50003057` | `0xf800707f` | `OPIVI`   |
| `rv_zvkn`     | `vror_vv`    | `vm, vs2, vs1, vd`              | `010100-----------000-----1010111` | `0x50000057` | `0xfc00707f` | `OPIVV`   |
| `rv_zvkn`     | `vror_vx`    | `vm, vs2, rs1, vd`              | `010100-----------100-----1010111` | `0x50004057` | `0xfc00707f` | `OPIVX`   |
| `rv_zvkn`     | `vsha2ch_vv` | `vs2, vs1, vd`                  | `1011101----------010-----1110111` | `0xba002077` | `0xfe00707f` | `UNKNOWN` |
| `rv_zvkn`     | `vsha2cl_vv` | `vs2, vs1, vd`                  | `1011111----------010-----1110111` | `0xbe002077` | `0xfe00707f` | `UNKNOWN` |
| `rv_zvkn`     | `vsha2ms_vv` | `vs2, vs1, vd`                  | `1011011----------010-----1110111` | `0xb6002077` | `0xfe00707f` | `UNKNOWN` |
| `rv_zvksed`   | `vsm4k_vi`   | `vs2, zimm5, vd`                | `1000011----------010-----1110111` | `0x86002077` | `0xfe00707f` | `UNKNOWN` |
| `rv_zvksed`   | `vsm4r_vs`   | `vs2, vd`                       | `1010011-----10000010-----1110111` | `0xa6082077` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zvksed`   | `vsm4r_vv`   | `vs2, vd`                       | `1010001-----10000010-----1110111` | `0xa2082077` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zvksh`    | `vsm3c_vi`   | `vs2, zimm5, vd`                | `1010111----------010-----1110111` | `0xae002077` | `0xfe00707f` | `UNKNOWN` |
| `rv_zvksh`    | `vsm3me_vv`  | `vs2, vs1, vd`                  | `1000001----------010-----1110111` | `0x82002077` | `0xfe00707f` | `UNKNOWN` |
| `rv_zvks`     | `vandn_vv`   | `vm, vs2, vs1, vd`              | `000001-----------000-----1010111` | `0x04000057` | `0xfc00707f` | `OPIVV`   |
| `rv_zvks`     | `vandn_vx`   | `vm, vs2, rs1, vd`              | `000001-----------100-----1010111` | `0x04004057` | `0xfc00707f` | `OPIVX`   |
| `rv_zvks`     | `vbrev8_v`   | `vm, vs2, vd`                   | `010010------01000010-----1010111` | `0x48042057` | `0xfc0ff07f` | `OPMVV`   |
| `rv_zvks`     | `vrev8_v`    | `vm, vs2, vd`                   | `010010------01001010-----1010111` | `0x4804a057` | `0xfc0ff07f` | `OPMVV`   |
| `rv_zvks`     | `vrol_vv`    | `vm, vs2, vs1, vd`              | `010101-----------000-----1010111` | `0x54000057` | `0xfc00707f` | `OPIVV`   |
| `rv_zvks`     | `vrol_vx`    | `vm, vs2, rs1, vd`              | `010101-----------100-----1010111` | `0x54004057` | `0xfc00707f` | `OPIVX`   |
| `rv_zvks`     | `vror_vi`    | `zimm6hi, vm, vs2, zimm6lo, vd` | `01010------------011-----1010111` | `0x50003057` | `0xf800707f` | `OPIVI`   |
| `rv_zvks`     | `vror_vv`    | `vm, vs2, vs1, vd`              | `010100-----------000-----1010111` | `0x50000057` | `0xfc00707f` | `OPIVV`   |
| `rv_zvks`     | `vror_vx`    | `vm, vs2, rs1, vd`              | `010100-----------100-----1010111` | `0x50004057` | `0xfc00707f` | `OPIVX`   |
| `rv_zvks`     | `vsm3c_vi`   | `vs2, zimm5, vd`                | `1010111----------010-----1110111` | `0xae002077` | `0xfe00707f` | `UNKNOWN` |
| `rv_zvks`     | `vsm3me_vv`  | `vs2, vs1, vd`                  | `1000001----------010-----1110111` | `0x82002077` | `0xfe00707f` | `UNKNOWN` |
| `rv_zvks`     | `vsm4k_vi`   | `vs2, zimm5, vd`                | `1000011----------010-----1110111` | `0x86002077` | `0xfe00707f` | `UNKNOWN` |
| `rv_zvks`     | `vsm4r_vs`   | `vs2, vd`                       | `1010011-----10000010-----1110111` | `0xa6082077` | `0xfe0ff07f` | `UNKNOWN` |
| `rv_zvks`     | `vsm4r_vv`   | `vs2, vd`                       | `1010001-----10000010-----1110111` | `0xa2082077` | `0xfe0ff07f` | `UNKNOWN` |

:RVZVK - Specific Extension for Vector Cryptography Instructions
