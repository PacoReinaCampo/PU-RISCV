## INSTRUCTION FULL-NAMES

| **Extension** | **Name**        | **Variable-Fields**  | **Full-Name**                                                                            |
|:--------------|:----------------|:---------------------|:-----------------------------------------------------------------------------------------|
| `rv_p`        | `abs`           | `rd, rs1`            | `Absolute Value`                                                                         |
| `rv_p`        | `cls`           | `rd, rs1`            | `Count Leading Redundant Sign Bits`                                                      |
| `rv_p`        | `clz`           | `rd, rs1`            | `Count leading zero bits`                                                                |
| `rv_p`        | `max`           | `rd, rs1, rs2`       | `Maximum`                                                                                |
| `rv_p`        | `maxu`          | `rd, rs1, rs2`       | `Unsigned maximum`                                                                       |
| `rv_p`        | `merge`         | `rs2, rs1, rd`       | `Bitwise Merge`                                                                          |
| `rv_p`        | `min`           | `rd, rs1, rs2`       | `Minimum`                                                                                |
| `rv_p`        | `minu`          | `rd, rs1, rs2`       | `Unsigned minimum`                                                                       |
| `rv_p`        | `mvm`           | `rs2, rs1, rd`       | `Masked Move`                                                                            |
| `rv_p`        | `mvmn`          | `rs2, rs1, rd`       | `Inverted Masked Move`                                                                   |
| `rv_p`        | `paadd_b`       | `rs2, rs1, rd`       | `Packed Signed Averaging Add, Byte`                                                      |
| `rv_p`        | `paadd_h`       | `rs2, rs1, rd`       | `Packed Signed Averaging Add, Halfword`                                                  |
| `rv_p`        | `paaddu_b`      | `rs2, rs1, rd`       | `Packed Unsigned Averaging Add, Byte`                                                    |
| `rv_p`        | `paaddu_h`      | `rs2, rs1, rd`       | `Packed Unsigned Averaging Add, Halfword`                                                |
| `rv_p`        | `paas_hx`       | `rs2, rs1, rd`       | `Packed Averaging Cross Add-Subtract, Cross Halfword`                                    |
| `rv_p`        | `pabd_b`        | `rs2, rs1, rd`       | `Packed Signed Absolute Difference, Byte`                                                |
| `rv_p`        | `pabd_h`        | `rs2, rs1, rd`       | `Packed Signed Absolute Difference, Halfword`                                            |
| `rv_p`        | `pabdsumau_b`   | `rs2, rs1, rd`       | `Packed Unsigned Absolute Difference Sum Accumulate, Byte`                               |
| `rv_p`        | `pabdsumu_b`    | `rs2, rs1, rd`       | `Packed Unsigned Absolute Difference Sum, Byte`                                          |
| `rv_p`        | `pabdu_b`       | `rs2, rs1, rd`       | `Packed Unsigned Absolute Difference, Byte`                                              |
| `rv_p`        | `pabdu_h`       | `rs2, rs1, rd`       | `Packed Unsigned Absolute Difference, Halfword`                                          |
| `rv_p`        | `pack`          | `rd, rs1, rs2`       | `Pack Low Halves`                                                                        |
| `rv_p`        | `padd_b`        | `rs2, rs1, rd`       | `Packed Add, Byte`                                                                       |
| `rv_p`        | `padd_bs`       | `rs2, rs1, rd`       | `Packed Add, Byte with Scalar Operand`                                                   |
| `rv_p`        | `padd_h`        | `rs2, rs1, rd`       | `Packed Add, Halfword`                                                                   |
| `rv_p`        | `padd_hs`       | `rs2, rs1, rd`       | `Packed Add, Halfword with Scalar Operand`                                               |
| `rv_p`        | `pasa_hx`       | `rs2, rs1, rd`       | `Packed Averaging Cross Subtract-Add, Cross Halfword`                                    |
| `rv_p`        | `pas_hx`        | `rs2, rs1, rd`       | `Packed Cross Add-Subtract, Cross Halfword`                                              |
| `rv_p`        | `pasub_b`       | `rs2, rs1, rd`       | `Packed Signed Averaging Subtract, Byte`                                                 |
| `rv_p`        | `pasub_h`       | `rs2, rs1, rd`       | `Packed Signed Averaging Subtract, Halfword`                                             |
| `rv_p`        | `pasubu_b`      | `rs2, rs1, rd`       | `Packed Unsigned Averaging Subtract, Byte`                                               |
| `rv_p`        | `pasubu_h`      | `rs2, rs1, rd`       | `Packed Unsigned Averaging Subtract, Halfword`                                           |
| `rv_p`        | `pli_b`         | `p_imm8, rd`         | `Packed Load Immediate, Byte`                                                            |
| `rv_p`        | `pli_h`         | `p_imm10, rd`        | `Packed Load Immediate, Halfword`                                                        |
| `rv_p`        | `plui_h`        | `p_imm10, rd`        | `Packed Load Upper Immediate, Halfword`                                                  |
| `rv_p`        | `pm2adda_h`     | `rs2, rs1, rd`       | `Packed Multiply and Sum 2 Products and Accumulate, Halfword`                            |
| `rv_p`        | `pm2adda_hx`    | `rs2, rs1, rd`       | `Packed Multiply and Sum 2 Products and Accumulate, Cross Halfword`                      |
| `rv_p`        | `pm2addasu_h`   | `rs2, rs1, rd`       | `Packed Multiply and Sum 2 Products and Accumulate Signed by Unsigned, Halfword`         |
| `rv_p`        | `pm2addau_h`    | `rs2, rs1, rd`       | `Packed Multiply and Sum 2 Products and Accumulate Unsigned, Halfword`                   |
| `rv_p`        | `pm2add_h`      | `rs2, rs1, rd`       | `Packed Multiply and Sum 2 Products, Halfword`                                           |
| `rv_p`        | `pm2add_hx`     | `rs2, rs1, rd`       | `Packed Multiply and Sum 2 Products, Cross Halfword`                                     |
| `rv_p`        | `pm2addsu_h`    | `rs2, rs1, rd`       | `Packed Multiply and Sum 2 Products Signed by Unsigned, Halfword`                        |
| `rv_p`        | `pm2addu_h`     | `rs2, rs1, rd`       | `Packed Multiply and Sum 2 Products Unsigned, Halfword`                                  |
| `rv_p`        | `pm2sadd_h`     | `rs2, rs1, rd`       | `Packed Multiply and Saturating Sum 2 Products, Halfword`                                |
| `rv_p`        | `pm2sadd_hx`    | `rs2, rs1, rd`       | `Packed Multiply and Saturating Sum 2 Products, Cross Halfword`                          |
| `rv_p`        | `pm2suba_h`     | `rs2, rs1, rd`       | `Packed Multiply and Subtract 2 Products and Accumulate, Halfword`                       |
| `rv_p`        | `pm2suba_hx`    | `rs2, rs1, rd`       | `Packed Multiply and Subtract 2 Products and Accumulate, Cross Halfword`                 |
| `rv_p`        | `pm2sub_h`      | `rs2, rs1, rd`       | `Packed Multiply and Subtract 2 Products, Halfword`                                      |
| `rv_p`        | `pm2sub_hx`     | `rs2, rs1, rd`       | `Packed Multiply and Subtract 2 Products, Cross Halfword`                                |
| `rv_p`        | `pm4adda_b`     | `rs2, rs1, rd`       | `Packed Multiply and Sum 4 Products and Accumulate, Byte`                                |
| `rv_p`        | `pm4addasu_b`   | `rs2, rs1, rd`       | `Packed Multiply and Sum 4 Products and Accumulate Signed by Unsigned, Byte`             |
| `rv_p`        | `pm4addau_b`    | `rs2, rs1, rd`       | `Packed Multiply and Sum 4 Products and Accumulate Unsigned, Byte`                       |
| `rv_p`        | `pm4add_b`      | `rs2, rs1, rd`       | `Packed Multiply and Sum 4 Products, Byte`                                               |
| `rv_p`        | `pm4addsu_b`    | `rs2, rs1, rd`       | `Packed Multiply and Sum 4 Products Signed by Unsigned, Byte`                            |
| `rv_p`        | `pm4addu_b`     | `rs2, rs1, rd`       | `Packed Multiply and Sum 4 Products Unsigned, Byte`                                      |
| `rv_p`        | `pmax_b`        | `rs2, rs1, rd`       | `Packed Signed Maximum, Byte`                                                            |
| `rv_p`        | `pmax_h`        | `rs2, rs1, rd`       | `Packed Signed Maximum, Halfword`                                                        |
| `rv_p`        | `pmaxu_b`       | `rs2, rs1, rd`       | `Packed Unsigned Maximum, Byte`                                                          |
| `rv_p`        | `pmaxu_h`       | `rs2, rs1, rd`       | `Packed Unsigned Maximum, Halfword`                                                      |
| `rv_p`        | `pmhacc_h`      | `rs2, rs1, rd`       | `Packed Multiply High and Accumulate, Halfword`                                          |
| `rv_p`        | `pmhacc_h_b0`   | `rs2, rs1, rd`       | `Packed Multiply High and Accumulate, Halfword, Low Byte`                                |
| `rv_p`        | `pmhacc_h_b1`   | `rs2, rs1, rd`       | `Packed Multiply High and Accumulate, Halfword, High Byte`                               |
| `rv_p`        | `pmhaccsu_h`    | `rs2, rs1, rd`       | `Packed Multiply High and Accumulate Signed by Unsigned, Halfword`                       |
| `rv_p`        | `pmhaccsu_h_b0` | `rs2, rs1, rd`       | `Packed Multiply High and Accumulate Signed by Unsigned, Halfword, Low Byte`             |
| `rv_p`        | `pmhaccsu_h_b1` | `rs2, rs1, rd`       | `Packed Multiply High and Accumulate Signed by Unsigned, Halfword, High Byte`            |
| `rv_p`        | `pmhaccu_h`     | `rs2, rs1, rd`       | `Packed Multiply High and Accumulate Unsigned, Halfword`                                 |
| `rv_p`        | `pmhracc_h`     | `rs2, rs1, rd`       | `Packed Rounded Multiply High and Accumulate, Halfword`                                  |
| `rv_p`        | `pmhraccsu_h`   | `rs2, rs1, rd`       | `Packed Rounded Multiply High and Accumulate Signed by Unsigned, Halfword`               |
| `rv_p`        | `pmhraccu_h`    | `rs2, rs1, rd`       | `Packed Rounded Multiply High and Accumulate Unsigned, Halfword`                         |
| `rv_p`        | `pmin_b`        | `rs2, rs1, rd`       | `Packed Signed Minimum, Byte`                                                            |
| `rv_p`        | `pmin_h`        | `rs2, rs1, rd`       | `Packed Signed Minimum, Halfword`                                                        |
| `rv_p`        | `pminu_b`       | `rs2, rs1, rd`       | `Packed Unsigned Minimum, Byte`                                                          |
| `rv_p`        | `pminu_h`       | `rs2, rs1, rd`       | `Packed Unsigned Minimum, Halfword`                                                      |
| `rv_p`        | `pmq2adda_h`    | `rs2, rs1, rd`       | `Packed Q-Format Multiply and Sum 2 Products and Accumulate, Halfword`                   |
| `rv_p`        | `pmq2add_h`     | `rs2, rs1, rd`       | `Packed Q-Format Multiply and Sum 2 Products, Halfword`                                  |
| `rv_p`        | `pmqr2adda_h`   | `rs2, rs1, rd`       | `Packed Rounded Q-Format Multiply and Sum 2 Products and Accumulate, Halfword`           |
| `rv_p`        | `pmqr2add_h`    | `rs2, rs1, rd`       | `Packed Rounded Q-Format Multiply and Sum 2 Products, Halfword`                          |
| `rv_p`        | `pmseq_b`       | `rs2, rs1, rd`       | `Packed Set Mask if Equal, Byte`                                                         |
| `rv_p`        | `pmseq_h`       | `rs2, rs1, rd`       | `Packed Set Mask if Equal, Halfword`                                                     |
| `rv_p`        | `pmslt_b`       | `rs2, rs1, rd`       | `Packed Set Mask if Signed Less Than, Byte`                                              |
| `rv_p`        | `pmslt_h`       | `rs2, rs1, rd`       | `Packed Set Mask if Signed Less Than, Halfword`                                          |
| `rv_p`        | `pmsltu_b`      | `rs2, rs1, rd`       | `Packed Set Mask if Unsigned Less Than, Byte`                                            |
| `rv_p`        | `pmsltu_h`      | `rs2, rs1, rd`       | `Packed Set Mask if Unsigned Less Than, Halfword`                                        |
| `rv_p`        | `pmul_h_b00`    | `rs2, rs1, rd`       | `Packed Multiply, Halfword, Low Byte Pair`                                               |
| `rv_p`        | `pmul_h_b01`    | `rs2, rs1, rd`       | `Packed Multiply, Halfword, Low-High Byte Pair`                                          |
| `rv_p`        | `pmul_h_b11`    | `rs2, rs1, rd`       | `Packed Multiply, Halfword, High Byte Pair`                                              |
| `rv_p`        | `pmulh_h`       | `rs2, rs1, rd`       | `Packed Multiply High, Halfword`                                                         |
| `rv_p`        | `pmulh_h_b0`    | `rs2, rs1, rd`       | `Packed Multiply High, Halfword, Low Byte`                                               |
| `rv_p`        | `pmulh_h_b1`    | `rs2, rs1, rd`       | `Packed Multiply High, Halfword, High Byte`                                              |
| `rv_p`        | `pmulhr_h`      | `rs2, rs1, rd`       | `Packed Rounded Multiply High, Halfword`                                                 |
| `rv_p`        | `pmulhrsu_h`    | `rs2, rs1, rd`       | `Packed Rounded Multiply High Signed by Unsigned, Halfword`                              |
| `rv_p`        | `pmulhru_h`     | `rs2, rs1, rd`       | `Packed Rounded Multiply High Unsigned, Halfword`                                        |
| `rv_p`        | `pmulhsu_h`     | `rs2, rs1, rd`       | `Packed Multiply High Signed by Unsigned, Halfword`                                      |
| `rv_p`        | `pmulhsu_h_b0`  | `rs2, rs1, rd`       | `Packed Multiply High Signed by Unsigned, Halfword, Low Byte`                            |
| `rv_p`        | `pmulhsu_h_b1`  | `rs2, rs1, rd`       | `Packed Multiply High Signed by Unsigned, Halfword, High Byte`                           |
| `rv_p`        | `pmulhu_h`      | `rs2, rs1, rd`       | `Packed Multiply High Unsigned, Halfword`                                                |
| `rv_p`        | `pmulq_h`       | `rs2, rs1, rd`       | `Packed Q-Format Multiply, Halfword`                                                     |
| `rv_p`        | `pmulqr_h`      | `rs2, rs1, rd`       | `Packed Rounded Q-Format Multiply, Halfword`                                             |
| `rv_p`        | `pmulsu_h_b00`  | `rs2, rs1, rd`       | `Packed Multiply Signed by Unsigned, Halfword, Low Byte Pair`                            |
| `rv_p`        | `pmulsu_h_b11`  | `rs2, rs1, rd`       | `Packed Multiply Signed by Unsigned, Halfword, High Byte Pair`                           |
| `rv_p`        | `pmulu_h_b00`   | `rs2, rs1, rd`       | `Packed Multiply Unsigned, Halfword, Low Byte Pair`                                      |
| `rv_p`        | `pmulu_h_b01`   | `rs2, rs1, rd`       | `Packed Multiply Unsigned, Halfword, Low-High Byte Pair`                                 |
| `rv_p`        | `pmulu_h_b11`   | `rs2, rs1, rd`       | `Packed Multiply Unsigned, Halfword, High Byte Pair`                                     |
| `rv_p`        | `ppaire_b`      | `rs2, rs1, rd`       | `Pack Even Elements, Byte`                                                               |
| `rv_p`        | `ppaireo_b`     | `rs2, rs1, rd`       | `Pack Even-Odd Elements, Byte`                                                           |
| `rv_p`        | `ppaireo_h`     | `rs2, rs1, rd`       | `Pack Even-Odd Elements, Halfword`                                                       |
| `rv_p`        | `ppairo_b`      | `rs2, rs1, rd`       | `Pack Odd Elements, Byte`                                                                |
| `rv_p`        | `ppairoe_b`     | `rs2, rs1, rd`       | `Pack Odd-Even Elements, Byte`                                                           |
| `rv_p`        | `ppairoe_h`     | `rs2, rs1, rd`       | `Pack Odd-Even Elements, Halfword`                                                       |
| `rv_p`        | `ppairo_h`      | `rs2, rs1, rd`       | `Pack Odd Elements, Halfword`                                                            |
| `rv_p`        | `predsum_bs`    | `rs2, rs1, rd`       | `Packed Signed Reduction Sum, Byte with Scalar Operand`                                  |
| `rv_p`        | `predsum_hs`    | `rs2, rs1, rd`       | `Packed Signed Reduction Sum, Halfword with Scalar Operand`                              |
| `rv_p`        | `predsumu_bs`   | `rs2, rs1, rd`       | `Packed Unsigned Reduction Sum, Byte with Scalar Operand`                                |
| `rv_p`        | `predsumu_hs`   | `rs2, rs1, rd`       | `Packed Unsigned Reduction Sum, Halfword with Scalar Operand`                            |
| `rv_p`        | `psabs_b`       | `rs1, rd`            | `Packed Saturating Absolute Value, Byte`                                                 |
| `rv_p`        | `psabs_h`       | `rs1, rd`            | `Packed Saturating Absolute Value, Halfword`                                             |
| `rv_p`        | `psadd_b`       | `rs2, rs1, rd`       | `Packed Signed Saturating Add, Byte`                                                     |
| `rv_p`        | `psadd_h`       | `rs2, rs1, rd`       | `Packed Signed Saturating Add, Halfword`                                                 |
| `rv_p`        | `psaddu_b`      | `rs2, rs1, rd`       | `Packed Unsigned Saturating Add, Byte`                                                   |
| `rv_p`        | `psaddu_h`      | `rs2, rs1, rd`       | `Packed Unsigned Saturating Add, Halfword`                                               |
| `rv_p`        | `psa_hx`        | `rs2, rs1, rd`       | `Packed Cross Subtract-Add, Cross Halfword`                                              |
| `rv_p`        | `psas_hx`       | `rs2, rs1, rd`       | `Packed Saturating Cross Add-Subtract, Cross Halfword`                                   |
| `rv_p`        | `psati_h`       | `p_w_uimm4, rs1, rd` | `Packed Signed Saturation Immediate, Halfword`                                           |
| `rv_p`        | `psext_h_b`     | `rs1, rd`            | `Packed Sign Extend, Halfword, Byte`                                                     |
| `rv_p`        | `psh1add_h`     | `rs2, rs1, rd`       | `Packed Shift Left by 1 and Add, Halfword`                                               |
| `rv_p`        | `psll_bs`       | `rs2, rs1, rd`       | `Packed Logical Left Shift, Byte with Scalar Operand`                                    |
| `rv_p`        | `psll_hs`       | `rs2, rs1, rd`       | `Packed Logical Left Shift, Halfword with Scalar Operand`                                |
| `rv_p`        | `pslli_b`       | `p_w_uimm3, rs1, rd` | `Packed Logical Left Shift Immediate, Byte`                                              |
| `rv_p`        | `pslli_h`       | `p_w_uimm4, rs1, rd` | `Packed Logical Left Shift Immediate, Halfword`                                          |
| `rv_p`        | `psra_bs`       | `rs2, rs1, rd`       | `Packed Arithmetic Right Shift, Byte with Scalar Operand`                                |
| `rv_p`        | `psra_hs`       | `rs2, rs1, rd`       | `Packed Arithmetic Right Shift, Halfword with Scalar Operand`                            |
| `rv_p`        | `psrai_b`       | `p_w_uimm3, rs1, rd` | `Packed Arithmetic Right Shift Immediate, Byte`                                          |
| `rv_p`        | `psrai_h`       | `p_w_uimm4, rs1, rd` | `Packed Arithmetic Right Shift Immediate, Halfword`                                      |
| `rv_p`        | `psrari_h`      | `p_w_uimm4, rs1, rd` | `Packed Rounded Arithmetic Right Shift Immediate, Halfword`                              |
| `rv_p`        | `psrl_bs`       | `rs2, rs1, rd`       | `Packed Logical Right Shift, Byte with Scalar Operand`                                   |
| `rv_p`        | `psrl_hs`       | `rs2, rs1, rd`       | `Packed Logical Right Shift, Halfword with Scalar Operand`                               |
| `rv_p`        | `psrli_b`       | `p_w_uimm3, rs1, rd` | `Packed Logical Right Shift Immediate, Byte`                                             |
| `rv_p`        | `psrli_h`       | `p_w_uimm4, rs1, rd` | `Packed Logical Right Shift Immediate, Halfword`                                         |
| `rv_p`        | `pssa_hx`       | `rs2, rs1, rd`       | `Packed Saturating Cross Subtract-Add, Cross Halfword`                                   |
| `rv_p`        | `pssh1sadd_h`   | `rs2, rs1, rd`       | `Packed Saturating Shift Left by 1 and Saturating Add, Halfword`                         |
| `rv_p`        | `pssha_hs`      | `rs2, rs1, rd`       | `Packed Saturating Bidirectional Arithmetic Shift, Halfword with Scalar Operand`         |
| `rv_p`        | `psshar_hs`     | `rs2, rs1, rd`       | `Packed Rounded Saturating Bidirectional Arithmetic Shift, Halfword with Scalar Operand` |
| `rv_p`        | `psshl_hs`      | `rs2, rs1, rd`       | `Packed Saturating Bidirectional Logical Shift, Halfword with Scalar Operand`            |
| `rv_p`        | `psshlr_hs`     | `rs2, rs1, rd`       | `Packed Rounded Saturating Bidirectional Logical Shift, Halfword with Scalar Operand`    |
| `rv_p`        | `psslai_h`      | `p_w_uimm4, rs1, rd` | `Packed Saturating Arithmetic Left Shift Immediate, Halfword`                            |
| `rv_p`        | `pssub_b`       | `rs2, rs1, rd`       | `Packed Signed Saturating Subtract, Byte`                                                |
| `rv_p`        | `pssub_h`       | `rs2, rs1, rd`       | `Packed Signed Saturating Subtract, Halfword`                                            |
| `rv_p`        | `pssubu_b`      | `rs2, rs1, rd`       | `Packed Unsigned Saturating Subtract, Byte`                                              |
| `rv_p`        | `pssubu_h`      | `rs2, rs1, rd`       | `Packed Unsigned Saturating Subtract, Halfword`                                          |
| `rv_p`        | `psub_b`        | `rs2, rs1, rd`       | `Packed Subtract, Byte`                                                                  |
| `rv_p`        | `psub_h`        | `rs2, rs1, rd`       | `Packed Subtract, Halfword`                                                              |
| `rv_p`        | `pusati_h`      | `p_w_uimm4, rs1, rd` | `Packed Unsigned Saturation Immediate, Halfword`                                         |
| `rv_p`        | `sext_b`        | `rd, rs1`            | `Sign-extend byte`                                                                       |
| `rv_p`        | `sext_h`        | `rd, rs1`            | `Sign-extend halfword`                                                                   |
| `rv_p`        | `sh1add`        | `rd, rs1, rs2`       | `Shift left by 1 and add`                                                                |
| `rv_p`        | `slx`           | `rs2, rs1, rd`       | `Shift Left and Extract`                                                                 |
| `rv_p`        | `srx`           | `rs2, rs1, rd`       | `Shift Right and Extract`                                                                |

:RVP - Specific Extension for Packed SIMD Instructions

| **Extension** | **Name**       | **Variable-Fields**          | **Full-Name**                                                                                               |
|:--------------|:---------------|:-----------------------------|:------------------------------------------------------------------------------------------------------------|
| `rv32_p`      | `addd`         | `p_rs2_p, p_rs1_p, p_rd_p`   | `Add Doubleword`                                                                                            |
| `rv32_p`      | `mqrwacc`      | `rs2, rs1, p_rd_p`           | `Rounded Q-Format Multiply and Widening Accumulate`                                                         |
| `rv32_p`      | `mqwacc`       | `rs2, rs1, p_rd_p`           | `Q-Format Multiply and Widening Accumulate`                                                                 |
| `rv32_p`      | `nclip`        | `rs2, p_rs1_p, rd`           | `Narrowing Right Shift and Saturation`                                                                      |
| `rv32_p`      | `nclipi`       | `p_w_uimm6, p_rs1_p, rd`     | `Narrowing Right Shift and Saturation Immediate`                                                            |
| `rv32_p`      | `nclipiu`      | `p_w_uimm6, p_rs1_p, rd`     | `Narrowing Right Shift and Saturation Immediate to Unsigned Range`                                          |
| `rv32_p`      | `nclipr`       | `rs2, p_rs1_p, rd`           | `Narrowing Right Shift and Saturation with Rounding`                                                        |
| `rv32_p`      | `nclipri`      | `p_w_uimm6, p_rs1_p, rd`     | `Narrowing Right Shift and Saturation with Rounding Immediate`                                              |
| `rv32_p`      | `nclipriu`     | `p_w_uimm6, p_rs1_p, rd`     | `Narrowing Right Shift and Saturation with Rounding Immediate to Unsigned Range`                            |
| `rv32_p`      | `nclipru`      | `rs2, p_rs1_p, rd`           | `Narrowing Right Shift and Saturation with Rounding to Unsigned Range`                                      |
| `rv32_p`      | `nclipu`       | `rs2, p_rs1_p, rd`           | `Narrowing Right Shift and Saturation to Unsigned Range`                                                    |
| `rv32_p`      | `nsra`         | `rs2, p_rs1_p, rd`           | `Narrowing Arithmetic Right Shift`                                                                          |
| `rv32_p`      | `nsrai`        | `p_w_uimm6, p_rs1_p, rd`     | `Narrowing Arithmetic Right Shift Immediate`                                                                |
| `rv32_p`      | `nsrar`        | `rs2, p_rs1_p, rd`           | `Narrowing Arithmetic Right Shift with Rounding`                                                            |
| `rv32_p`      | `nsrari`       | `p_w_uimm6, p_rs1_p, rd`     | `Narrowing Arithmetic Right Shift with Rounding Immediate`                                                  |
| `rv32_p`      | `nsrl`         | `rs2, p_rs1_p, rd`           | `Narrowing Logical Right Shift`                                                                             |
| `rv32_p`      | `nsrli`        | `p_w_uimm6, p_rs1_p, rd`     | `Narrowing Logical Right Shift Immediate`                                                                   |
| `rv32_p`      | `paadd_db`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Signed Averaging Add, Double-Wide Byte`                                                             |
| `rv32_p`      | `paadd_dh`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Signed Averaging Add, Double-Wide Halfword`                                                         |
| `rv32_p`      | `paadd_dw`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Signed Averaging Add, Double-Wide Word`                                                             |
| `rv32_p`      | `paaddu_db`    | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Unsigned Averaging Add, Double-Wide Byte`                                                           |
| `rv32_p`      | `paaddu_dh`    | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Unsigned Averaging Add, Double-Wide Halfword`                                                       |
| `rv32_p`      | `paaddu_dw`    | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Unsigned Averaging Add, Double-Wide Word`                                                           |
| `rv32_p`      | `paas_dhx`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Averaging Cross Add-Subtract, Double-Wide Cross Halfword`                                           |
| `rv32_p`      | `pabd_db`      | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Signed Absolute Difference, Double-Wide Byte`                                                       |
| `rv32_p`      | `pabd_dh`      | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Signed Absolute Difference, Double-Wide Halfword`                                                   |
| `rv32_p`      | `pabdu_db`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Unsigned Absolute Difference, Double-Wide Byte`                                                     |
| `rv32_p`      | `pabdu_dh`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Unsigned Absolute Difference, Double-Wide Halfword`                                                 |
| `rv32_p`      | `padd_db`      | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Add, Double-Wide Byte`                                                                              |
| `rv32_p`      | `padd_dbs`     | `rs2, p_rs1_p, p_rd_p`       | `Packed Add, Double-Wide Byte with Scalar Operand`                                                          |
| `rv32_p`      | `padd_dh`      | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Add, Double-Wide Halfword`                                                                          |
| `rv32_p`      | `padd_dhs`     | `rs2, p_rs1_p, p_rd_p`       | `Packed Add, Double-Wide Halfword with Scalar Operand`                                                      |
| `rv32_p`      | `padd_dw`      | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Add, Double-Wide Word`                                                                              |
| `rv32_p`      | `padd_dws`     | `rs2, p_rs1_p, p_rd_p`       | `Packed Add, Double-Wide Word with Scalar Operand`                                                          |
| `rv32_p`      | `pasa_dhx`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Averaging Cross Subtract-Add, Double-Wide Cross Halfword`                                           |
| `rv32_p`      | `pas_dhx`      | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Cross Add-Subtract, Double-Wide Cross Halfword`                                                     |
| `rv32_p`      | `pasub_db`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Signed Averaging Subtract, Double-Wide Byte`                                                        |
| `rv32_p`      | `pasub_dh`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Signed Averaging Subtract, Double-Wide Halfword`                                                    |
| `rv32_p`      | `pasub_dw`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Signed Averaging Subtract, Double-Wide Word`                                                        |
| `rv32_p`      | `pasubu_db`    | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Unsigned Averaging Subtract, Double-Wide Byte`                                                      |
| `rv32_p`      | `pasubu_dh`    | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Unsigned Averaging Subtract, Double-Wide Halfword`                                                  |
| `rv32_p`      | `pasubu_dw`    | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Unsigned Averaging Subtract, Double-Wide Word`                                                      |
| `rv32_p`      | `pli_db`       | `p_imm8, p_rd_p`             | `Packed Load Immediate, Double-Wide Byte`                                                                   |
| `rv32_p`      | `pli_dh`       | `p_imm10, p_rd_p`            | `Packed Load Immediate, Double-Wide Halfword`                                                               |
| `rv32_p`      | `plui_dh`      | `p_imm10, p_rd_p`            | `Packed Load Upper Immediate, Double-Wide Halfword`                                                         |
| `rv32_p`      | `pm2wadda_h`   | `rs2, rs1, p_rd_p`           | `Packed Multiply and Widening Sum 2 Products and Accumulate, Halfword`                                      |
| `rv32_p`      | `pm2wadda_hx`  | `rs2, rs1, p_rd_p`           | `Packed Multiply and Widening Sum 2 Products and Accumulate, Cross Halfword`                                |
| `rv32_p`      | `pm2waddasu_h` | `rs2, rs1, p_rd_p`           | `Packed Multiply and Widening Sum 2 Products and Accumulate Signed by Unsigned, Halfword`                   |
| `rv32_p`      | `pm2waddau_h`  | `rs2, rs1, p_rd_p`           | `Packed Multiply and Widening Sum 2 Products and Accumulate Unsigned, Halfword`                             |
| `rv32_p`      | `pm2wadd_h`    | `rs2, rs1, p_rd_p`           | `Packed Multiply and Widening Sum 2 Products, Halfword`                                                     |
| `rv32_p`      | `pm2wadd_hx`   | `rs2, rs1, p_rd_p`           | `Packed Multiply and Widening Sum 2 Products, Cross Halfword`                                               |
| `rv32_p`      | `pm2waddsu_h`  | `rs2, rs1, p_rd_p`           | `Packed Multiply and Widening Sum 2 Products Signed by Unsigned, Halfword`                                  |
| `rv32_p`      | `pm2waddu_h`   | `rs2, rs1, p_rd_p`           | `Packed Multiply and Widening Sum 2 Products Unsigned, Halfword`                                            |
| `rv32_p`      | `pm2wsuba_h`   | `rs2, rs1, p_rd_p`           | `Packed Multiply and Widening Subtract 2 Products and Accumulate, Halfword`                                 |
| `rv32_p`      | `pm2wsuba_hx`  | `rs2, rs1, p_rd_p`           | `Packed Multiply and Widening Subtract 2 Products and Accumulate, Cross Halfword`                           |
| `rv32_p`      | `pm2wsub_h`    | `rs2, rs1, p_rd_p`           | `Packed Multiply and Widening Subtract 2 Products, Halfword`                                                |
| `rv32_p`      | `pm2wsub_hx`   | `rs2, rs1, p_rd_p`           | `Packed Multiply and Widening Subtract 2 Products, Cross Halfword`                                          |
| `rv32_p`      | `pmax_db`      | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Signed Maximum, Double-Wide Byte`                                                                   |
| `rv32_p`      | `pmax_dh`      | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Signed Maximum, Double-Wide Halfword`                                                               |
| `rv32_p`      | `pmax_dw`      | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Signed Maximum, Double-Wide Word`                                                                   |
| `rv32_p`      | `pmaxu_db`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Unsigned Maximum, Double-Wide Byte`                                                                 |
| `rv32_p`      | `pmaxu_dh`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Unsigned Maximum, Double-Wide Halfword`                                                             |
| `rv32_p`      | `pmaxu_dw`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Unsigned Maximum, Double-Wide Word`                                                                 |
| `rv32_p`      | `pmin_db`      | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Signed Minimum, Double-Wide Byte`                                                                   |
| `rv32_p`      | `pmin_dh`      | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Signed Minimum, Double-Wide Halfword`                                                               |
| `rv32_p`      | `pmin_dw`      | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Signed Minimum, Double-Wide Word`                                                                   |
| `rv32_p`      | `pminu_db`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Unsigned Minimum, Double-Wide Byte`                                                                 |
| `rv32_p`      | `pminu_dh`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Unsigned Minimum, Double-Wide Halfword`                                                             |
| `rv32_p`      | `pminu_dw`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Unsigned Minimum, Double-Wide Word`                                                                 |
| `rv32_p`      | `pmqrwacc_h`   | `rs2, rs1, p_rd_p`           | `Packed Rounded Q-Format Multiply and Widening Accumulate, Halfword`                                        |
| `rv32_p`      | `pmqwacc_h`    | `rs2, rs1, p_rd_p`           | `Packed Q-Format Multiply and Widening Accumulate, Halfword`                                                |
| `rv32_p`      | `pmseq_db`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Set Mask if Equal, Double-Wide Byte`                                                                |
| `rv32_p`      | `pmseq_dh`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Set Mask if Equal, Double-Wide Halfword`                                                            |
| `rv32_p`      | `pmseq_dw`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Set Mask if Equal, Double-Wide Word`                                                                |
| `rv32_p`      | `pmslt_db`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Set Mask if Signed Less Than, Double-Wide Byte`                                                     |
| `rv32_p`      | `pmslt_dh`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Set Mask if Signed Less Than, Double-Wide Halfword`                                                 |
| `rv32_p`      | `pmslt_dw`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Set Mask if Signed Less Than, Double-Wide Word`                                                     |
| `rv32_p`      | `pmsltu_db`    | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Set Mask if Unsigned Less Than, Double-Wide Byte`                                                   |
| `rv32_p`      | `pmsltu_dh`    | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Set Mask if Unsigned Less Than, Double-Wide Halfword`                                               |
| `rv32_p`      | `pmsltu_dw`    | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Set Mask if Unsigned Less Than, Double-Wide Word`                                                   |
| `rv32_p`      | `pnclip_bs`    | `rs2, p_rs1_p, rd`           | `Packed Narrowing Right Shift and Saturation, Byte with Scalar Operand`                                     |
| `rv32_p`      | `pnclip_hs`    | `rs2, p_rs1_p, rd`           | `Packed Narrowing Right Shift and Saturation, Halfword with Scalar Operand`                                 |
| `rv32_p`      | `pnclipi_b`    | `p_w_uimm4, p_rs1_p, rd`     | `Packed Narrowing Right Shift and Saturation Immediate, Byte`                                               |
| `rv32_p`      | `pnclipi_h`    | `p_w_uimm5, p_rs1_p, rd`     | `Packed Narrowing Right Shift and Saturation Immediate, Halfword`                                           |
| `rv32_p`      | `pnclipiu_b`   | `p_w_uimm4, p_rs1_p, rd`     | `Packed Narrowing Right Shift and Saturation Immediate to Unsigned Range, Byte`                             |
| `rv32_p`      | `pnclipiu_h`   | `p_w_uimm5, p_rs1_p, rd`     | `Packed Narrowing Right Shift and Saturation Immediate to Unsigned Range, Halfword`                         |
| `rv32_p`      | `pnclipr_bs`   | `rs2, p_rs1_p, rd`           | `Packed Narrowing Right Shift and Saturation with Rounding, Byte with Scalar Operand`                       |
| `rv32_p`      | `pnclipr_hs`   | `rs2, p_rs1_p, rd`           | `Packed Narrowing Right Shift and Saturation with Rounding, Halfword with Scalar Operand`                   |
| `rv32_p`      | `pnclipri_b`   | `p_w_uimm4, p_rs1_p, rd`     | `Packed Narrowing Right Shift and Saturation with Rounding Immediate, Byte`                                 |
| `rv32_p`      | `pnclipri_h`   | `p_w_uimm5, p_rs1_p, rd`     | `Packed Narrowing Right Shift and Saturation with Rounding Immediate, Halfword`                             |
| `rv32_p`      | `pnclipriu_b`  | `p_w_uimm4, p_rs1_p, rd`     | `Packed Narrowing Right Shift and Saturation with Rounding Immediate to Unsigned Range, Byte`               |
| `rv32_p`      | `pnclipriu_h`  | `p_w_uimm5, p_rs1_p, rd`     | `Packed Narrowing Right Shift and Saturation with Rounding Immediate to Unsigned Range, Halfword`           |
| `rv32_p`      | `pnclipru_bs`  | `rs2, p_rs1_p, rd`           | `Packed Narrowing Right Shift and Saturation with Rounding to Unsigned Range, Byte with Scalar Operand`     |
| `rv32_p`      | `pnclipru_hs`  | `rs2, p_rs1_p, rd`           | `Packed Narrowing Right Shift and Saturation with Rounding to Unsigned Range, Halfword with Scalar Operand` |
| `rv32_p`      | `pnclipu_bs`   | `rs2, p_rs1_p, rd`           | `Packed Narrowing Right Shift and Saturation to Unsigned Range, Byte with Scalar Operand`                   |
| `rv32_p`      | `pnclipu_hs`   | `rs2, p_rs1_p, rd`           | `Packed Narrowing Right Shift and Saturation to Unsigned Range, Halfword with Scalar Operand`               |
| `rv32_p`      | `pnsra_bs`     | `rs2, p_rs1_p, rd`           | `Packed Narrowing Arithmetic Right Shift, Byte with Scalar Operand`                                         |
| `rv32_p`      | `pnsra_hs`     | `rs2, p_rs1_p, rd`           | `Packed Narrowing Arithmetic Right Shift, Halfword with Scalar Operand`                                     |
| `rv32_p`      | `pnsrai_b`     | `p_w_uimm4, p_rs1_p, rd`     | `Packed Narrowing Arithmetic Right Shift Immediate, Byte`                                                   |
| `rv32_p`      | `pnsrai_h`     | `p_w_uimm5, p_rs1_p, rd`     | `Packed Narrowing Arithmetic Right Shift Immediate, Halfword`                                               |
| `rv32_p`      | `pnsrar_bs`    | `rs2, p_rs1_p, rd`           | `Packed Narrowing Arithmetic Right Shift with Rounding, Byte with Scalar Operand`                           |
| `rv32_p`      | `pnsrar_hs`    | `rs2, p_rs1_p, rd`           | `Packed Narrowing Arithmetic Right Shift with Rounding, Halfword with Scalar Operand`                       |
| `rv32_p`      | `pnsrari_b`    | `p_w_uimm4, p_rs1_p, rd`     | `Packed Narrowing Arithmetic Right Shift with Rounding Immediate, Byte`                                     |
| `rv32_p`      | `pnsrari_h`    | `p_w_uimm5, p_rs1_p, rd`     | `Packed Narrowing Arithmetic Right Shift with Rounding Immediate, Halfword`                                 |
| `rv32_p`      | `pnsrl_bs`     | `rs2, p_rs1_p, rd`           | `Packed Narrowing Logical Right Shift, Byte with Scalar Operand`                                            |
| `rv32_p`      | `pnsrl_hs`     | `rs2, p_rs1_p, rd`           | `Packed Narrowing Logical Right Shift, Halfword with Scalar Operand`                                        |
| `rv32_p`      | `pnsrli_b`     | `p_w_uimm4, p_rs1_p, rd`     | `Packed Narrowing Logical Right Shift Immediate, Byte`                                                      |
| `rv32_p`      | `pnsrli_h`     | `p_w_uimm5, p_rs1_p, rd`     | `Packed Narrowing Logical Right Shift Immediate, Halfword`                                                  |
| `rv32_p`      | `ppaire_db`    | `p_rs2_p, p_rs1_p, p_rd_p`   | `Pack Even Elements, Double-Wide Byte`                                                                      |
| `rv32_p`      | `ppaire_dh`    | `p_rs2_p, p_rs1_p, p_rd_p`   | `Pack Even Elements, Double-Wide Halfword`                                                                  |
| `rv32_p`      | `ppaireo_db`   | `p_rs2_p, p_rs1_p, p_rd_p`   | `Pack Even-Odd Elements, Double-Wide Byte`                                                                  |
| `rv32_p`      | `ppaireo_dh`   | `p_rs2_p, p_rs1_p, p_rd_p`   | `Pack Even-Odd Elements, Double-Wide Halfword`                                                              |
| `rv32_p`      | `ppairo_db`    | `p_rs2_p, p_rs1_p, p_rd_p`   | `Pack Odd Elements, Double-Wide Byte`                                                                       |
| `rv32_p`      | `ppairo_dh`    | `p_rs2_p, p_rs1_p, p_rd_p`   | `Pack Odd Elements, Double-Wide Halfword`                                                                   |
| `rv32_p`      | `ppairoe_db`   | `p_rs2_p, p_rs1_p, p_rd_p`   | `Pack Odd-Even Elements, Double-Wide Byte`                                                                  |
| `rv32_p`      | `ppairoe_dh`   | `p_rs2_p, p_rs1_p, p_rd_p`   | `Pack Odd-Even Elements, Double-Wide Halfword`                                                              |
| `rv32_p`      | `predsum_dbs`  | `rs2, p_rs1_p, rd`           | `Packed Signed Reduction Sum, Double-Wide Byte with Scalar Operand`                                         |
| `rv32_p`      | `predsum_dhs`  | `rs2, p_rs1_p, rd`           | `Packed Signed Reduction Sum, Double-Wide Halfword with Scalar Operand`                                     |
| `rv32_p`      | `predsumu_dbs` | `rs2, p_rs1_p, rd`           | `Packed Unsigned Reduction Sum, Double-Wide Byte with Scalar Operand`                                       |
| `rv32_p`      | `predsumu_dhs` | `rs2, p_rs1_p, rd`           | `Packed Unsigned Reduction Sum, Double-Wide Halfword with Scalar Operand`                                   |
| `rv32_p`      | `psabs_db`     | `p_rs1_p, p_rd_p`            | `Packed Saturating Absolute Value, Double-Wide Byte`                                                        |
| `rv32_p`      | `psabs_dh`     | `p_rs1_p, p_rd_p`            | `Packed Saturating Absolute Value, Double-Wide Halfword`                                                    |
| `rv32_p`      | `psadd_db`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Signed Saturating Add, Double-Wide Byte`                                                            |
| `rv32_p`      | `psadd_dh`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Signed Saturating Add, Double-Wide Halfword`                                                        |
| `rv32_p`      | `psadd_dw`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Signed Saturating Add, Double-Wide Word`                                                            |
| `rv32_p`      | `psaddu_db`    | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Unsigned Saturating Add, Double-Wide Byte`                                                          |
| `rv32_p`      | `psaddu_dh`    | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Unsigned Saturating Add, Double-Wide Halfword`                                                      |
| `rv32_p`      | `psaddu_dw`    | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Unsigned Saturating Add, Double-Wide Word`                                                          |
| `rv32_p`      | `psa_dhx`      | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Cross Subtract-Add, Double-Wide Cross Halfword`                                                     |
| `rv32_p`      | `psas_dhx`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Saturating Cross Add-Subtract, Double-Wide Cross Halfword`                                          |
| `rv32_p`      | `psati_dh`     | `p_w_uimm4, p_rs1_p, p_rd_p` | `Packed Signed Saturation Immediate, Double-Wide Halfword`                                                  |
| `rv32_p`      | `psati_dw`     | `p_w_uimm5, p_rs1_p, p_rd_p` | `Packed Signed Saturation Immediate, Double-Wide Word`                                                      |
| `rv32_p`      | `psext_dh_b`   | `p_rs1_p, p_rd_p`            | `Packed Sign Extend, Double-Wide Halfword, Byte`                                                            |
| `rv32_p`      | `psext_dw_b`   | `p_rs1_p, p_rd_p`            | `Packed Sign Extend, Double-Wide Word, Byte`                                                                |
| `rv32_p`      | `psext_dw_h`   | `p_rs1_p, p_rd_p`            | `Packed Sign Extend, Double-Wide Word, Halfword`                                                            |
| `rv32_p`      | `psh1add_dh`   | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Shift Left by 1 and Add, Double-Wide Halfword`                                                      |
| `rv32_p`      | `psh1add_dw`   | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Shift Left by 1 and Add, Double-Wide Word`                                                          |
| `rv32_p`      | `psll_dbs`     | `rs2, p_rs1_p, p_rd_p`       | `Packed Logical Left Shift, Double-Wide Byte with Scalar Operand`                                           |
| `rv32_p`      | `psll_dhs`     | `rs2, p_rs1_p, p_rd_p`       | `Packed Logical Left Shift, Double-Wide Halfword with Scalar Operand`                                       |
| `rv32_p`      | `psll_dws`     | `rs2, p_rs1_p, p_rd_p`       | `Packed Logical Left Shift, Double-Wide Word with Scalar Operand`                                           |
| `rv32_p`      | `pslli_db`     | `p_w_uimm3, p_rs1_p, p_rd_p` | `Packed Logical Left Shift Immediate, Double-Wide Byte`                                                     |
| `rv32_p`      | `pslli_dh`     | `p_w_uimm4, p_rs1_p, p_rd_p` | `Packed Logical Left Shift Immediate, Double-Wide Halfword`                                                 |
| `rv32_p`      | `pslli_dw`     | `p_w_uimm5, p_rs1_p, p_rd_p` | `Packed Logical Left Shift Immediate, Double-Wide Word`                                                     |
| `rv32_p`      | `psra_dbs`     | `rs2, p_rs1_p, p_rd_p`       | `Packed Arithmetic Right Shift, Double-Wide Byte with Scalar Operand`                                       |
| `rv32_p`      | `psra_dhs`     | `rs2, p_rs1_p, p_rd_p`       | `Packed Arithmetic Right Shift, Double-Wide Halfword with Scalar Operand`                                   |
| `rv32_p`      | `psra_dws`     | `rs2, p_rs1_p, p_rd_p`       | `Packed Arithmetic Right Shift, Double-Wide Word with Scalar Operand`                                       |
| `rv32_p`      | `psrai_db`     | `p_w_uimm3, p_rs1_p, p_rd_p` | `Packed Arithmetic Right Shift Immediate, Double-Wide Byte`                                                 |
| `rv32_p`      | `psrai_dh`     | `p_w_uimm4, p_rs1_p, p_rd_p` | `Packed Arithmetic Right Shift Immediate, Double-Wide Halfword`                                             |
| `rv32_p`      | `psrai_dw`     | `p_w_uimm5, p_rs1_p, p_rd_p` | `Packed Arithmetic Right Shift Immediate, Double-Wide Word`                                                 |
| `rv32_p`      | `psrari_dh`    | `p_w_uimm4, p_rs1_p, p_rd_p` | `Packed Rounded Arithmetic Right Shift Immediate, Double-Wide Halfword`                                     |
| `rv32_p`      | `psrari_dw`    | `p_w_uimm5, p_rs1_p, p_rd_p` | `Packed Rounded Arithmetic Right Shift Immediate, Double-Wide Word`                                         |
| `rv32_p`      | `psrl_dbs`     | `rs2, p_rs1_p, p_rd_p`       | `Packed Logical Right Shift, Double-Wide Byte with Scalar Operand`                                          |
| `rv32_p`      | `psrl_dhs`     | `rs2, p_rs1_p, p_rd_p`       | `Packed Logical Right Shift, Double-Wide Halfword with Scalar Operand`                                      |
| `rv32_p`      | `psrl_dws`     | `rs2, p_rs1_p, p_rd_p`       | `Packed Logical Right Shift, Double-Wide Word with Scalar Operand`                                          |
| `rv32_p`      | `psrli_db`     | `p_w_uimm3, p_rs1_p, p_rd_p` | `Packed Logical Right Shift Immediate, Double-Wide Byte`                                                    |
| `rv32_p`      | `psrli_dh`     | `p_w_uimm4, p_rs1_p, p_rd_p` | `Packed Logical Right Shift Immediate, Double-Wide Halfword`                                                |
| `rv32_p`      | `psrli_dw`     | `p_w_uimm5, p_rs1_p, p_rd_p` | `Packed Logical Right Shift Immediate, Double-Wide Word`                                                    |
| `rv32_p`      | `pssa_dhx`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Saturating Cross Subtract-Add, Double-Wide Cross Halfword`                                          |
| `rv32_p`      | `pssh1sadd_dh` | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Saturating Shift Left by 1 and Saturating Add, Double-Wide Halfword`                                |
| `rv32_p`      | `pssh1sadd_dw` | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Saturating Shift Left by 1 and Saturating Add, Double-Wide Word`                                    |
| `rv32_p`      | `pssha_dhs`    | `rs2, p_rs1_p, p_rd_p`       | `Packed Saturating Bidirectional Arithmetic Shift, Double-Wide Halfword with Scalar Operand`                |
| `rv32_p`      | `pssha_dws`    | `rs2, p_rs1_p, p_rd_p`       | `Packed Saturating Bidirectional Arithmetic Shift, Double-Wide Word with Scalar Operand`                    |
| `rv32_p`      | `psshar_dhs`   | `rs2, p_rs1_p, p_rd_p`       | `Packed Rounded Saturating Bidirectional Arithmetic Shift, Double-Wide Halfword with Scalar Operand`        |
| `rv32_p`      | `psshar_dws`   | `rs2, p_rs1_p, p_rd_p`       | `Packed Rounded Saturating Bidirectional Arithmetic Shift, Double-Wide Word with Scalar Operand`            |
| `rv32_p`      | `psshl_dhs`    | `rs2, p_rs1_p, p_rd_p`       | `Packed Saturating Bidirectional Logical Shift, Double-Wide Halfword with Scalar Operand`                   |
| `rv32_p`      | `psshl_dws`    | `rs2, p_rs1_p, p_rd_p`       | `Packed Saturating Bidirectional Logical Shift, Double-Wide Word with Scalar Operand`                       |
| `rv32_p`      | `psshlr_dhs`   | `rs2, p_rs1_p, p_rd_p`       | `Packed Rounded Saturating Bidirectional Logical Shift, Double-Wide Halfword with Scalar Operand`           |
| `rv32_p`      | `psshlr_dws`   | `rs2, p_rs1_p, p_rd_p`       | `Packed Rounded Saturating Bidirectional Logical Shift, Double-Wide Word with Scalar Operand`               |
| `rv32_p`      | `psslai_dh`    | `p_w_uimm4, p_rs1_p, p_rd_p` | `Packed Saturating Arithmetic Left Shift Immediate, Double-Wide Halfword`                                   |
| `rv32_p`      | `psslai_dw`    | `p_w_uimm5, p_rs1_p, p_rd_p` | `Packed Saturating Arithmetic Left Shift Immediate, Double-Wide Word`                                       |
| `rv32_p`      | `pssub_db`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Signed Saturating Subtract, Double-Wide Byte`                                                       |
| `rv32_p`      | `pssub_dh`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Signed Saturating Subtract, Double-Wide Halfword`                                                   |
| `rv32_p`      | `pssub_dw`     | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Signed Saturating Subtract, Double-Wide Word`                                                       |
| `rv32_p`      | `pssubu_db`    | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Unsigned Saturating Subtract, Double-Wide Byte`                                                     |
| `rv32_p`      | `pssubu_dh`    | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Unsigned Saturating Subtract, Double-Wide Halfword`                                                 |
| `rv32_p`      | `pssubu_dw`    | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Unsigned Saturating Subtract, Double-Wide Word`                                                     |
| `rv32_p`      | `psub_db`      | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Subtract, Double-Wide Byte`                                                                         |
| `rv32_p`      | `psub_dh`      | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Subtract, Double-Wide Halfword`                                                                     |
| `rv32_p`      | `psub_dw`      | `p_rs2_p, p_rs1_p, p_rd_p`   | `Packed Subtract, Double-Wide Word`                                                                         |
| `rv32_p`      | `pusati_dh`    | `p_w_uimm4, p_rs1_p, p_rd_p` | `Packed Unsigned Saturation Immediate, Double-Wide Halfword`                                                |
| `rv32_p`      | `pusati_dw`    | `p_w_uimm5, p_rs1_p, p_rd_p` | `Packed Unsigned Saturation Immediate, Double-Wide Word`                                                    |
| `rv32_p`      | `pwadda_b`     | `rs2, rs1, p_rd_p`           | `Packed Widening Add and Accumulate, Byte`                                                                  |
| `rv32_p`      | `pwadda_h`     | `rs2, rs1, p_rd_p`           | `Packed Widening Add and Accumulate, Halfword`                                                              |
| `rv32_p`      | `pwaddau_b`    | `rs2, rs1, p_rd_p`           | `Packed Widening Add and Accumulate Unsigned, Byte`                                                         |
| `rv32_p`      | `pwaddau_h`    | `rs2, rs1, p_rd_p`           | `Packed Widening Add and Accumulate Unsigned, Halfword`                                                     |
| `rv32_p`      | `pwadd_b`      | `rs2, rs1, p_rd_p`           | `Packed Widening Add, Byte`                                                                                 |
| `rv32_p`      | `pwadd_h`      | `rs2, rs1, p_rd_p`           | `Packed Widening Add, Halfword`                                                                             |
| `rv32_p`      | `pwaddu_b`     | `rs2, rs1, p_rd_p`           | `Packed Widening Add Unsigned, Byte`                                                                        |
| `rv32_p`      | `pwaddu_h`     | `rs2, rs1, p_rd_p`           | `Packed Widening Add Unsigned, Halfword`                                                                    |
| `rv32_p`      | `pwmacc_h`     | `rs2, rs1, p_rd_p`           | `Packed Widening Multiply and Accumulate, Halfword`                                                         |
| `rv32_p`      | `pwmaccsu_h`   | `rs2, rs1, p_rd_p`           | `Packed Widening Multiply and Accumulate Signed by Unsigned, Halfword`                                      |
| `rv32_p`      | `pwmaccu_h`    | `rs2, rs1, p_rd_p`           | `Packed Widening Multiply and Accumulate Unsigned, Halfword`                                                |
| `rv32_p`      | `pwmul_b`      | `rs2, rs1, p_rd_p`           | `Packed Widening Multiply, Byte`                                                                            |
| `rv32_p`      | `pwmul_h`      | `rs2, rs1, p_rd_p`           | `Packed Widening Multiply, Halfword`                                                                        |
| `rv32_p`      | `pwmulsu_b`    | `rs2, rs1, p_rd_p`           | `Packed Widening Multiply Signed by Unsigned, Byte`                                                         |
| `rv32_p`      | `pwmulsu_h`    | `rs2, rs1, p_rd_p`           | `Packed Widening Multiply Signed by Unsigned, Halfword`                                                     |
| `rv32_p`      | `pwmulu_b`     | `rs2, rs1, p_rd_p`           | `Packed Widening Multiply Unsigned, Byte`                                                                   |
| `rv32_p`      | `pwmulu_h`     | `rs2, rs1, p_rd_p`           | `Packed Widening Multiply Unsigned, Halfword`                                                               |
| `rv32_p`      | `pwsla_bs`     | `rs2, rs1, p_rd_p`           | `Packed Widening Arithmetic Left Shift, Byte with Scalar Operand`                                           |
| `rv32_p`      | `pwsla_hs`     | `rs2, rs1, p_rd_p`           | `Packed Widening Arithmetic Left Shift, Halfword with Scalar Operand`                                       |
| `rv32_p`      | `pwslai_b`     | `p_w_uimm4, rs1, p_rd_p`     | `Packed Widening Arithmetic Left Shift Immediate, Byte`                                                     |
| `rv32_p`      | `pwslai_h`     | `p_w_uimm5, rs1, p_rd_p`     | `Packed Widening Arithmetic Left Shift Immediate, Halfword`                                                 |
| `rv32_p`      | `pwsll_bs`     | `rs2, rs1, p_rd_p`           | `Packed Widening Logical Left Shift, Byte with Scalar Operand`                                              |
| `rv32_p`      | `pwsll_hs`     | `rs2, rs1, p_rd_p`           | `Packed Widening Logical Left Shift, Halfword with Scalar Operand`                                          |
| `rv32_p`      | `pwslli_b`     | `p_w_uimm4, rs1, p_rd_p`     | `Packed Widening Logical Left Shift Immediate, Byte`                                                        |
| `rv32_p`      | `pwslli_h`     | `p_w_uimm5, rs1, p_rd_p`     | `Packed Widening Logical Left Shift Immediate, Halfword`                                                    |
| `rv32_p`      | `pwsuba_b`     | `rs2, rs1, p_rd_p`           | `Packed Widening Subtract and Accumulate, Byte`                                                             |
| `rv32_p`      | `pwsuba_h`     | `rs2, rs1, p_rd_p`           | `Packed Widening Subtract and Accumulate, Halfword`                                                         |
| `rv32_p`      | `pwsubau_b`    | `rs2, rs1, p_rd_p`           | `Packed Widening Subtract and Accumulate Unsigned, Byte`                                                    |
| `rv32_p`      | `pwsubau_h`    | `rs2, rs1, p_rd_p`           | `Packed Widening Subtract and Accumulate Unsigned, Halfword`                                                |
| `rv32_p`      | `pwsub_b`      | `rs2, rs1, p_rd_p`           | `Packed Widening Subtract, Byte`                                                                            |
| `rv32_p`      | `pwsub_h`      | `rs2, rs1, p_rd_p`           | `Packed Widening Subtract, Halfword`                                                                        |
| `rv32_p`      | `pwsubu_b`     | `rs2, rs1, p_rd_p`           | `Packed Widening Subtract Unsigned, Byte`                                                                   |
| `rv32_p`      | `pwsubu_h`     | `rs2, rs1, p_rd_p`           | `Packed Widening Subtract Unsigned, Halfword`                                                               |
| `rv32_p`      | `rev_rv32`     | `rd, rs1`                    | `Reverse Bits`                                                                                              |
| `rv32_p`      | `subd`         | `p_rs2_p, p_rs1_p, p_rd_p`   | `Subtract Doubleword`                                                                                       |
| `rv32_p`      | `wadd`         | `rs2, rs1, p_rd_p`           | `Widening Add`                                                                                              |
| `rv32_p`      | `wadda`        | `rs2, rs1, p_rd_p`           | `Widening Add and Accumulate`                                                                               |
| `rv32_p`      | `waddau`       | `rs2, rs1, p_rd_p`           | `Widening Add and Accumulate Unsigned`                                                                      |
| `rv32_p`      | `waddu`        | `rs2, rs1, p_rd_p`           | `Widening Add Unsigned`                                                                                     |
| `rv32_p`      | `wmacc`        | `rs2, rs1, p_rd_p`           | `Widening Multiply and Accumulate`                                                                          |
| `rv32_p`      | `wmaccsu`      | `rs2, rs1, p_rd_p`           | `Widening Multiply and Accumulate Signed by Unsigned`                                                       |
| `rv32_p`      | `wmaccu`       | `rs2, rs1, p_rd_p`           | `Widening Multiply and Accumulate Unsigned`                                                                 |
| `rv32_p`      | `wmul`         | `rs2, rs1, p_rd_p`           | `Widening Multiply`                                                                                         |
| `rv32_p`      | `wmulsu`       | `rs2, rs1, p_rd_p`           | `Widening Multiply Signed by Unsigned`                                                                      |
| `rv32_p`      | `wmulu`        | `rs2, rs1, p_rd_p`           | `Widening Multiply Unsigned`                                                                                |
| `rv32_p`      | `wsla`         | `rs2, rs1, p_rd_p`           | `Widening Arithmetic Left Shift`                                                                            |
| `rv32_p`      | `wslai`        | `p_w_uimm6, rs1, p_rd_p`     | `Widening Arithmetic Left Shift Immediate`                                                                  |
| `rv32_p`      | `wsll`         | `rs2, rs1, p_rd_p`           | `Widening Logical Left Shift`                                                                               |
| `rv32_p`      | `wslli`        | `p_w_uimm6, rs1, p_rd_p`     | `Widening Logical Left Shift Immediate`                                                                     |
| `rv32_p`      | `wsub`         | `rs2, rs1, p_rd_p`           | `Widening Subtract`                                                                                         |
| `rv32_p`      | `wsuba`        | `rs2, rs1, p_rd_p`           | `Widening Subtract and Accumulate`                                                                          |
| `rv32_p`      | `wsubau`       | `rs2, rs1, p_rd_p`           | `Widening Subtract and Accumulate Unsigned`                                                                 |
| `rv32_p`      | `wsubu`        | `rs2, rs1, p_rd_p`           | `Widening Subtract Unsigned`                                                                                |
| `rv32_p`      | `wzip16p`      | `rs2, rs1, p_rd_p`           | `Widening Interleave 16-Bit Elements`                                                                       |
| `rv32_p`      | `wzip8p`       | `rs2, rs1, p_rd_p`           | `Widening Interleave 8-Bit Elements`                                                                        |

:RV32P - Specific Extension for Packed SIMD Instructions (32 bit)

| **Extension** | **Name**        | **Variable-Fields**  | **Full-Name**                                                                                |
|:--------------|:----------------|:---------------------|:---------------------------------------------------------------------------------------------|
| `rv64_p`      | `absw`          | `rd, rs1`            | `Absolute Value Word`                                                                        |
| `rv64_p`      | `clsw`          | `rd, rs1`            | `Count Leading Redundant Sign Bits Word`                                                     |
| `rv64_p`      | `clzw`          | `rd, rs1`            | `Count leading zero bits in word`                                                            |
| `rv64_p`      | `maccsu_w00`    | `rs2, rs1, rd`       | `Multiply and Accumulate Signed by Unsigned, Word Low Pair`                                  |
| `rv64_p`      | `maccsu_w11`    | `rs2, rs1, rd`       | `Multiply and Accumulate Signed by Unsigned, Word High Pair`                                 |
| `rv64_p`      | `maccu_w00`     | `rs2, rs1, rd`       | `Multiply and Accumulate Unsigned, Word Low Pair`                                            |
| `rv64_p`      | `maccu_w01`     | `rs2, rs1, rd`       | `Multiply and Accumulate Unsigned, Word Low-High Pair`                                       |
| `rv64_p`      | `maccu_w11`     | `rs2, rs1, rd`       | `Multiply and Accumulate Unsigned, Word High Pair`                                           |
| `rv64_p`      | `macc_w00`      | `rs2, rs1, rd`       | `Multiply and Accumulate, Word Low Pair`                                                     |
| `rv64_p`      | `macc_w01`      | `rs2, rs1, rd`       | `Multiply and Accumulate, Word Low-High Pair`                                                |
| `rv64_p`      | `macc_w11`      | `rs2, rs1, rd`       | `Multiply and Accumulate, Word High Pair`                                                    |
| `rv64_p`      | `mqacc_w00`     | `rs2, rs1, rd`       | `Q-Format Multiply and Accumulate, Word Low Pair`                                            |
| `rv64_p`      | `mqacc_w01`     | `rs2, rs1, rd`       | `Q-Format Multiply and Accumulate, Word Low-High Pair`                                       |
| `rv64_p`      | `mqacc_w11`     | `rs2, rs1, rd`       | `Q-Format Multiply and Accumulate, Word High Pair`                                           |
| `rv64_p`      | `mqracc_w00`    | `rs2, rs1, rd`       | `Rounded Q-Format Multiply and Accumulate, Word Low Pair`                                    |
| `rv64_p`      | `mqracc_w01`    | `rs2, rs1, rd`       | `Rounded Q-Format Multiply and Accumulate, Word Low-High Pair`                               |
| `rv64_p`      | `mqracc_w11`    | `rs2, rs1, rd`       | `Rounded Q-Format Multiply and Accumulate, Word High Pair`                                   |
| `rv64_p`      | `mulsu_w00`     | `rs2, rs1, rd`       | `Multiply Signed by Unsigned, Word Low Pair`                                                 |
| `rv64_p`      | `mulsu_w11`     | `rs2, rs1, rd`       | `Multiply Signed by Unsigned, Word High Pair`                                                |
| `rv64_p`      | `mulu_w00`      | `rs2, rs1, rd`       | `Multiply Unsigned, Word Low Pair`                                                           |
| `rv64_p`      | `mulu_w01`      | `rs2, rs1, rd`       | `Multiply Unsigned, Word Low-High Pair`                                                      |
| `rv64_p`      | `mulu_w11`      | `rs2, rs1, rd`       | `Multiply Unsigned, Word High Pair`                                                          |
| `rv64_p`      | `mul_w00`       | `rs2, rs1, rd`       | `Multiply, Word Low Pair`                                                                    |
| `rv64_p`      | `mul_w01`       | `rs2, rs1, rd`       | `Multiply, Word Low-High Pair`                                                               |
| `rv64_p`      | `mul_w11`       | `rs2, rs1, rd`       | `Multiply, Word High Pair`                                                                   |
| `rv64_p`      | `paaddu_w`      | `rs2, rs1, rd`       | `Packed Unsigned Averaging Add, Word`                                                        |
| `rv64_p`      | `paadd_w`       | `rs2, rs1, rd`       | `Packed Signed Averaging Add, Word`                                                          |
| `rv64_p`      | `paas_wx`       | `rs2, rs1, rd`       | `Packed Averaging Cross Add-Subtract, Cross Word`                                            |
| `rv64_p`      | `padd_w`        | `rs2, rs1, rd`       | `Packed Add, Word`                                                                           |
| `rv64_p`      | `padd_ws`       | `rs2, rs1, rd`       | `Packed Add, Word with Scalar Operand`                                                       |
| `rv64_p`      | `pasa_wx`       | `rs2, rs1, rd`       | `Packed Averaging Cross Subtract-Add, Cross Word`                                            |
| `rv64_p`      | `pasubu_w`      | `rs2, rs1, rd`       | `Packed Unsigned Averaging Subtract, Word`                                                   |
| `rv64_p`      | `pasub_w`       | `rs2, rs1, rd`       | `Packed Signed Averaging Subtract, Word`                                                     |
| `rv64_p`      | `pas_wx`        | `rs2, rs1, rd`       | `Packed Cross Add-Subtract, Cross Word`                                                      |
| `rv64_p`      | `pli_w`         | `p_imm10, rd`        | `Packed Load Immediate, Word`                                                                |
| `rv64_p`      | `plui_w`        | `p_imm10, rd`        | `Packed Load Upper Immediate, Word`                                                          |
| `rv64_p`      | `pm2addasu_w`   | `rs2, rs1, rd`       | `Packed Multiply and Sum 2 Products and Accumulate Signed by Unsigned, Word`                 |
| `rv64_p`      | `pm2addau_w`    | `rs2, rs1, rd`       | `Packed Multiply and Sum 2 Products and Accumulate Unsigned, Word`                           |
| `rv64_p`      | `pm2adda_w`     | `rs2, rs1, rd`       | `Packed Multiply and Sum 2 Products and Accumulate, Word`                                    |
| `rv64_p`      | `pm2adda_wx`    | `rs2, rs1, rd`       | `Packed Multiply and Sum 2 Products and Accumulate, Cross Word`                              |
| `rv64_p`      | `pm2addsu_w`    | `rs2, rs1, rd`       | `Packed Multiply and Sum 2 Products Signed by Unsigned, Word`                                |
| `rv64_p`      | `pm2addu_w`     | `rs2, rs1, rd`       | `Packed Multiply and Sum 2 Products Unsigned, Word`                                          |
| `rv64_p`      | `pm2add_w`      | `rs2, rs1, rd`       | `Packed Multiply and Sum 2 Products, Word`                                                   |
| `rv64_p`      | `pm2add_wx`     | `rs2, rs1, rd`       | `Packed Multiply and Sum 2 Products, Cross Word`                                             |
| `rv64_p`      | `pm2suba_w`     | `rs2, rs1, rd`       | `Packed Multiply and Subtract 2 Products and Accumulate, Word`                               |
| `rv64_p`      | `pm2suba_wx`    | `rs2, rs1, rd`       | `Packed Multiply and Subtract 2 Products and Accumulate, Cross Word`                         |
| `rv64_p`      | `pm2sub_w`      | `rs2, rs1, rd`       | `Packed Multiply and Subtract 2 Products, Word`                                              |
| `rv64_p`      | `pm2sub_wx`     | `rs2, rs1, rd`       | `Packed Multiply and Subtract 2 Products, Cross Word`                                        |
| `rv64_p`      | `pm4adda_h`     | `rs2, rs1, rd`       | `Packed Multiply and Sum 4 Products and Accumulate, Halfword`                                |
| `rv64_p`      | `pm4addasu_h`   | `rs2, rs1, rd`       | `Packed Multiply and Sum 4 Products and Accumulate Signed by Unsigned, Halfword`             |
| `rv64_p`      | `pm4addau_h`    | `rs2, rs1, rd`       | `Packed Multiply and Sum 4 Products and Accumulate Unsigned, Halfword`                       |
| `rv64_p`      | `pm4add_h`      | `rs2, rs1, rd`       | `Packed Multiply and Sum 4 Products, Halfword`                                               |
| `rv64_p`      | `pm4addsu_h`    | `rs2, rs1, rd`       | `Packed Multiply and Sum 4 Products Signed by Unsigned, Halfword`                            |
| `rv64_p`      | `pm4addu_h`     | `rs2, rs1, rd`       | `Packed Multiply and Sum 4 Products Unsigned, Halfword`                                      |
| `rv64_p`      | `pmaccsu_w_h00` | `rs2, rs1, rd`       | `Packed Multiply and Accumulate Signed by Unsigned, Word, Halfword Low Pair`                 |
| `rv64_p`      | `pmaccsu_w_h11` | `rs2, rs1, rd`       | `Packed Multiply and Accumulate Signed by Unsigned, Word, Halfword High Pair`                |
| `rv64_p`      | `pmaccu_w_h00`  | `rs2, rs1, rd`       | `Packed Multiply and Accumulate Unsigned, Word, Halfword Low Pair`                           |
| `rv64_p`      | `pmaccu_w_h01`  | `rs2, rs1, rd`       | `Packed Multiply and Accumulate Unsigned, Word, Halfword Low-High Pair`                      |
| `rv64_p`      | `pmaccu_w_h11`  | `rs2, rs1, rd`       | `Packed Multiply and Accumulate Unsigned, Word, Halfword High Pair`                          |
| `rv64_p`      | `pmacc_w_h00`   | `rs2, rs1, rd`       | `Packed Multiply and Accumulate, Word, Halfword Low Pair`                                    |
| `rv64_p`      | `pmacc_w_h01`   | `rs2, rs1, rd`       | `Packed Multiply and Accumulate, Word, Halfword Low-High Pair`                               |
| `rv64_p`      | `pmacc_w_h11`   | `rs2, rs1, rd`       | `Packed Multiply and Accumulate, Word, Halfword High Pair`                                   |
| `rv64_p`      | `pmaxu_w`       | `rs2, rs1, rd`       | `Packed Unsigned Maximum, Word`                                                              |
| `rv64_p`      | `pmax_w`        | `rs2, rs1, rd`       | `Packed Signed Maximum, Word`                                                                |
| `rv64_p`      | `pmhaccsu_w`    | `rs2, rs1, rd`       | `Packed Multiply High and Accumulate Signed by Unsigned, Word`                               |
| `rv64_p`      | `pmhaccsu_w_h0` | `rs2, rs1, rd`       | `Packed Multiply High and Accumulate Signed by Unsigned, Word, Halfword Low Element`         |
| `rv64_p`      | `pmhaccsu_w_h1` | `rs2, rs1, rd`       | `Packed Multiply High and Accumulate Signed by Unsigned, Word, Halfword High Element`        |
| `rv64_p`      | `pmhaccu_w`     | `rs2, rs1, rd`       | `Packed Multiply High and Accumulate Unsigned, Word`                                         |
| `rv64_p`      | `pmhacc_w`      | `rs2, rs1, rd`       | `Packed Multiply High and Accumulate, Word`                                                  |
| `rv64_p`      | `pmhacc_w_h0`   | `rs2, rs1, rd`       | `Packed Multiply High and Accumulate, Word, Halfword Low Element`                            |
| `rv64_p`      | `pmhacc_w_h1`   | `rs2, rs1, rd`       | `Packed Multiply High and Accumulate, Word, Halfword High Element`                           |
| `rv64_p`      | `pmhraccsu_w`   | `rs2, rs1, rd`       | `Packed Rounded Multiply High and Accumulate Signed by Unsigned, Word`                       |
| `rv64_p`      | `pmhraccu_w`    | `rs2, rs1, rd`       | `Packed Rounded Multiply High and Accumulate Unsigned, Word`                                 |
| `rv64_p`      | `pmhracc_w`     | `rs2, rs1, rd`       | `Packed Rounded Multiply High and Accumulate, Word`                                          |
| `rv64_p`      | `pminu_w`       | `rs2, rs1, rd`       | `Packed Unsigned Minimum, Word`                                                              |
| `rv64_p`      | `pmin_w`        | `rs2, rs1, rd`       | `Packed Signed Minimum, Word`                                                                |
| `rv64_p`      | `pmq2adda_w`    | `rs2, rs1, rd`       | `Packed Q-Format Multiply and Sum 2 Products and Accumulate, Word`                           |
| `rv64_p`      | `pmq2add_w`     | `rs2, rs1, rd`       | `Packed Q-Format Multiply and Sum 2 Products, Word`                                          |
| `rv64_p`      | `pmqacc_w_h00`  | `rs2, rs1, rd`       | `Packed Q-Format Multiply and Accumulate, Word, Halfword Low Pair`                           |
| `rv64_p`      | `pmqacc_w_h01`  | `rs2, rs1, rd`       | `Packed Q-Format Multiply and Accumulate, Word, Halfword Low-High Pair`                      |
| `rv64_p`      | `pmqacc_w_h11`  | `rs2, rs1, rd`       | `Packed Q-Format Multiply and Accumulate, Word, Halfword High Pair`                          |
| `rv64_p`      | `pmqr2adda_w`   | `rs2, rs1, rd`       | `Packed Rounded Q-Format Multiply and Sum 2 Products and Accumulate, Word`                   |
| `rv64_p`      | `pmqr2add_w`    | `rs2, rs1, rd`       | `Packed Rounded Q-Format Multiply and Sum 2 Products, Word`                                  |
| `rv64_p`      | `pmqracc_w_h00` | `rs2, rs1, rd`       | `Packed Rounded Q-Format Multiply and Accumulate, Word, Halfword Low Pair`                   |
| `rv64_p`      | `pmqracc_w_h01` | `rs2, rs1, rd`       | `Packed Rounded Q-Format Multiply and Accumulate, Word, Halfword Low-High Pair`              |
| `rv64_p`      | `pmqracc_w_h11` | `rs2, rs1, rd`       | `Packed Rounded Q-Format Multiply and Accumulate, Word, Halfword High Pair`                  |
| `rv64_p`      | `pmseq_w`       | `rs2, rs1, rd`       | `Packed Set Mask if Equal, Word`                                                             |
| `rv64_p`      | `pmsltu_w`      | `rs2, rs1, rd`       | `Packed Set Mask if Unsigned Less Than, Word`                                                |
| `rv64_p`      | `pmslt_w`       | `rs2, rs1, rd`       | `Packed Set Mask if Signed Less Than, Word`                                                  |
| `rv64_p`      | `pmulhrsu_w`    | `rs2, rs1, rd`       | `Packed Rounded Multiply High Signed by Unsigned, Word`                                      |
| `rv64_p`      | `pmulhru_w`     | `rs2, rs1, rd`       | `Packed Rounded Multiply High Unsigned, Word`                                                |
| `rv64_p`      | `pmulhr_w`      | `rs2, rs1, rd`       | `Packed Rounded Multiply High, Word`                                                         |
| `rv64_p`      | `pmulhsu_w`     | `rs2, rs1, rd`       | `Packed Multiply High Signed by Unsigned, Word`                                              |
| `rv64_p`      | `pmulhsu_w_h0`  | `rs2, rs1, rd`       | `Packed Multiply High Signed by Unsigned, Word, Halfword Low Element`                        |
| `rv64_p`      | `pmulhsu_w_h1`  | `rs2, rs1, rd`       | `Packed Multiply High Signed by Unsigned, Word, Halfword High Element`                       |
| `rv64_p`      | `pmulhu_w`      | `rs2, rs1, rd`       | `Packed Multiply High Unsigned, Word`                                                        |
| `rv64_p`      | `pmulh_w`       | `rs2, rs1, rd`       | `Packed Multiply High, Word`                                                                 |
| `rv64_p`      | `pmulh_w_h0`    | `rs2, rs1, rd`       | `Packed Multiply High, Word, Halfword Low Element`                                           |
| `rv64_p`      | `pmulh_w_h1`    | `rs2, rs1, rd`       | `Packed Multiply High, Word, Halfword High Element`                                          |
| `rv64_p`      | `pmulqr_w`      | `rs2, rs1, rd`       | `Packed Rounded Q-Format Multiply, Word`                                                     |
| `rv64_p`      | `pmulq_w`       | `rs2, rs1, rd`       | `Packed Q-Format Multiply, Word`                                                             |
| `rv64_p`      | `pmulsu_w_h00`  | `rs2, rs1, rd`       | `Packed Multiply Signed by Unsigned, Word, Halfword Low Pair`                                |
| `rv64_p`      | `pmulsu_w_h11`  | `rs2, rs1, rd`       | `Packed Multiply Signed by Unsigned, Word, Halfword High Pair`                               |
| `rv64_p`      | `pmulu_w_h00`   | `rs2, rs1, rd`       | `Packed Multiply Unsigned, Word, Halfword Low Pair`                                          |
| `rv64_p`      | `pmulu_w_h01`   | `rs2, rs1, rd`       | `Packed Multiply Unsigned, Word, Halfword Low-High Pair`                                     |
| `rv64_p`      | `pmulu_w_h11`   | `rs2, rs1, rd`       | `Packed Multiply Unsigned, Word, Halfword High Pair`                                         |
| `rv64_p`      | `pmul_w_h00`    | `rs2, rs1, rd`       | `Packed Multiply, Word, Halfword Low Pair`                                                   |
| `rv64_p`      | `pmul_w_h01`    | `rs2, rs1, rd`       | `Packed Multiply, Word, Halfword Low-High Pair`                                              |
| `rv64_p`      | `pmul_w_h11`    | `rs2, rs1, rd`       | `Packed Multiply, Word, Halfword High Pair`                                                  |
| `rv64_p`      | `pnclipp_b`     | `rs2, rs1, rd`       | `Packed Narrowing Right Shift and Saturation from Register Pair, Byte`                       |
| `rv64_p`      | `pnclipp_h`     | `rs2, rs1, rd`       | `Packed Narrowing Right Shift and Saturation from Register Pair, Halfword`                   |
| `rv64_p`      | `pnclipp_w`     | `rs2, rs1, rd`       | `Packed Narrowing Right Shift and Saturation from Register Pair, Word`                       |
| `rv64_p`      | `pnclipup_b`    | `rs2, rs1, rd`       | `Packed Narrowing Right Shift and Saturation to Unsigned Range from Register Pair, Byte`     |
| `rv64_p`      | `pnclipup_h`    | `rs2, rs1, rd`       | `Packed Narrowing Right Shift and Saturation to Unsigned Range from Register Pair, Halfword` |
| `rv64_p`      | `pnclipup_w`    | `rs2, rs1, rd`       | `Packed Narrowing Right Shift and Saturation to Unsigned Range from Register Pair, Word`     |
| `rv64_p`      | `ppaire_h`      | `rs2, rs1, rd`       | `Pack Even Elements, Halfword`                                                               |
| `rv64_p`      | `ppaireo_w`     | `rs2, rs1, rd`       | `Pack Even-Odd Elements, Word`                                                               |
| `rv64_p`      | `ppairoe_w`     | `rs2, rs1, rd`       | `Pack Odd-Even Elements, Word`                                                               |
| `rv64_p`      | `ppairo_w`      | `rs2, rs1, rd`       | `Pack Odd Elements, Word`                                                                    |
| `rv64_p`      | `predsumu_ws`   | `rs2, rs1, rd`       | `Packed Unsigned Reduction Sum, Word with Scalar Operand`                                    |
| `rv64_p`      | `predsum_ws`    | `rs2, rs1, rd`       | `Packed Signed Reduction Sum, Word with Scalar Operand`                                      |
| `rv64_p`      | `psaddu_w`      | `rs2, rs1, rd`       | `Packed Unsigned Saturating Add, Word`                                                       |
| `rv64_p`      | `psadd_w`       | `rs2, rs1, rd`       | `Packed Signed Saturating Add, Word`                                                         |
| `rv64_p`      | `psas_wx`       | `rs2, rs1, rd`       | `Packed Saturating Cross Add-Subtract, Cross Word`                                           |
| `rv64_p`      | `psati_w`       | `p_w_uimm5, rs1, rd` | `Packed Signed Saturation Immediate, Word`                                                   |
| `rv64_p`      | `psa_wx`        | `rs2, rs1, rd`       | `Packed Cross Subtract-Add, Cross Word`                                                      |
| `rv64_p`      | `psext_w_b`     | `rs1, rd`            | `Packed Sign Extend, Word, Byte`                                                             |
| `rv64_p`      | `psext_w_h`     | `rs1, rd`            | `Packed Sign Extend, Word, Halfword`                                                         |
| `rv64_p`      | `psh1add_w`     | `rs2, rs1, rd`       | `Packed Shift Left by 1 and Add, Word`                                                       |
| `rv64_p`      | `pslli_w`       | `p_w_uimm5, rs1, rd` | `Packed Logical Left Shift Immediate, Word`                                                  |
| `rv64_p`      | `psll_ws`       | `rs2, rs1, rd`       | `Packed Logical Left Shift, Word with Scalar Operand`                                        |
| `rv64_p`      | `psrai_w`       | `p_w_uimm5, rs1, rd` | `Packed Arithmetic Right Shift Immediate, Word`                                              |
| `rv64_p`      | `psrari_w`      | `p_w_uimm5, rs1, rd` | `Packed Rounded Arithmetic Right Shift Immediate, Word`                                      |
| `rv64_p`      | `psra_ws`       | `rs2, rs1, rd`       | `Packed Arithmetic Right Shift, Word with Scalar Operand`                                    |
| `rv64_p`      | `psrli_w`       | `p_w_uimm5, rs1, rd` | `Packed Logical Right Shift Immediate, Word`                                                 |
| `rv64_p`      | `psrl_ws`       | `rs2, rs1, rd`       | `Packed Logical Right Shift, Word with Scalar Operand`                                       |
| `rv64_p`      | `pssa_wx`       | `rs2, rs1, rd`       | `Packed Saturating Cross Subtract-Add, Cross Word`                                           |
| `rv64_p`      | `pssh1sadd_w`   | `rs2, rs1, rd`       | `Packed Saturating Shift Left by 1 and Saturating Add, Word`                                 |
| `rv64_p`      | `psshar_ws`     | `rs2, rs1, rd`       | `Packed Rounded Saturating Bidirectional Arithmetic Shift, Word with Scalar Operand`         |
| `rv64_p`      | `pssha_ws`      | `rs2, rs1, rd`       | `Packed Saturating Bidirectional Arithmetic Shift, Word with Scalar Operand`                 |
| `rv64_p`      | `psshlr_ws`     | `rs2, rs1, rd`       | `Packed Rounded Saturating Bidirectional Logical Shift, Word with Scalar Operand`            |
| `rv64_p`      | `psshl_ws`      | `rs2, rs1, rd`       | `Packed Saturating Bidirectional Logical Shift, Word with Scalar Operand`                    |
| `rv64_p`      | `psslai_w`      | `p_w_uimm5, rs1, rd` | `Packed Saturating Arithmetic Left Shift Immediate, Word`                                    |
| `rv64_p`      | `pssubu_w`      | `rs2, rs1, rd`       | `Packed Unsigned Saturating Subtract, Word`                                                  |
| `rv64_p`      | `pssub_w`       | `rs2, rs1, rd`       | `Packed Signed Saturating Subtract, Word`                                                    |
| `rv64_p`      | `psub_w`        | `rs2, rs1, rd`       | `Packed Subtract, Word`                                                                      |
| `rv64_p`      | `pusati_w`      | `p_w_uimm5, rs1, rd` | `Packed Unsigned Saturation Immediate, Word`                                                 |
| `rv64_p`      | `rev`           | `rd, rs1`            | `Reverse Bits`                                                                               |
| `rv64_p`      | `rev16`         | `rd, rs1`            | `Reverse Halfwords`                                                                          |
| `rv64_p`      | `sati`          | `p_w_uimm6, rs1, rd` | `Signed Saturation Immediate`                                                                |
| `rv64_p`      | `sha`           | `rs2, rs1, rd`       | `Bidirectional Arithmetic Shift`                                                             |
| `rv64_p`      | `shar`          | `rs2, rs1, rd`       | `Rounded Bidirectional Arithmetic Shift`                                                     |
| `rv64_p`      | `shl`           | `rs2, rs1, rd`       | `Bidirectional Logical Shift`                                                                |
| `rv64_p`      | `shlr`          | `rs2, rs1, rd`       | `Rounded Bidirectional Logical Shift`                                                        |
| `rv64_p`      | `srari`         | `p_w_uimm6, rs1, rd` | `Rounded Arithmetic Right Shift Immediate`                                                   |
| `rv64_p`      | `unzip16hp`     | `rs2, rs1, rd`       | `Deinterleave 16-Bit Elements from Halfwords`                                                |
| `rv64_p`      | `unzip16p`      | `rs2, rs1, rd`       | `Deinterleave 16-Bit Elements`                                                               |
| `rv64_p`      | `unzip8hp`      | `rs2, rs1, rd`       | `Deinterleave 8-Bit Elements from Halfwords`                                                 |
| `rv64_p`      | `unzip8p`       | `rs2, rs1, rd`       | `Deinterleave 8-Bit Elements`                                                                |
| `rv64_p`      | `usati`         | `p_w_uimm6, rs1, rd` | `Unsigned Saturation Immediate`                                                              |
| `rv64_p`      | `zip16hp`       | `rs2, rs1, rd`       | `Interleave 16-Bit Elements from Halfwords`                                                  |
| `rv64_p`      | `zip16p`        | `rs2, rs1, rd`       | `Interleave 16-Bit Elements`                                                                 |
| `rv64_p`      | `zip8hp`        | `rs2, rs1, rd`       | `Interleave 8-Bit Elements from Halfwords`                                                   |
| `rv64_p`      | `zip8p`         | `rs2, rs1, rd`       | `Interleave 8-Bit Elements`                                                                  |

:RV64P - Specific Extension for Packed SIMD Instructions (64 bit)
