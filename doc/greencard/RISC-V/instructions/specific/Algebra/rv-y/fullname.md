## INSTRUCTION FULL-NAMES

| **Extension** | **Name**               | **Variable-Fields**  | **Full-Name**                                                                                    |
|:--------------|:-----------------------|:---------------------|:-------------------------------------------------------------------------------------------------|
| `rv_y`        | `yaaddu_yy`            | `ym, ys2, ys1, yd`   | `Tensor Averaging Add Unsigned (Tensor-Tensor)`                                                  |
| `rv_y`        | `yaaddu_yx`            | `ym, ys2, rs1, yd`   | `Tensor Averaging Add Unsigned (Tensor-Scalar)`                                                  |
| `rv_y`        | `yaadd_yy`             | `ym, ys2, ys1, yd`   | `Tensor Averaging Add Signed (Tensor-Tensor)`                                                    |
| `rv_y`        | `yaadd_yx`             | `ym, ys2, rs1, yd`   | `Tensor Averaging Add Signed (Tensor-Scalar)`                                                    |
| `rv_y`        | `yadc_yim`             | `ys2, simm5, yd`     | `Tensor Integer Add with Carry (Tensor-Immediate with Mask Carry Input)`                         |
| `rv_y`        | `yadc_yym`             | `ys2, ys1, yd`       | `Tensor Integer Add with Carry (Tensor-Tensor with Mask Carry Input)`                            |
| `rv_y`        | `yadc_yxm`             | `ys2, rs1, yd`       | `Tensor Integer Add with Carry (Tensor-Scalar with Mask Carry Input)`                            |
| `rv_y`        | `yadd_yi`              | `ym, ys2, simm5, yd` | `Tensor Integer Add (Tensor-Immediate)`                                                          |
| `rv_y`        | `yadd_yy`              | `ym, ys2, ys1, yd`   | `Tensor Integer Add (Tensor-Tensor)`                                                             |
| `rv_y`        | `yadd_yx`              | `ym, ys2, rs1, yd`   | `Tensor Integer Add (Tensor-Scalar)`                                                             |
| `rv_y`        | `yand_yi`              | `ym, ys2, simm5, yd` | `Tensor Bitwise AND (Tensor-Immediate)`                                                          |
| `rv_y`        | `yand_yy`              | `ym, ys2, ys1, yd`   | `Tensor Bitwise AND (Tensor-Tensor)`                                                             |
| `rv_y`        | `yand_yx`              | `ym, ys2, rs1, yd`   | `Tensor Bitwise AND (Tensor-Scalar)`                                                             |
| `rv_y`        | `yasubu_yy`            | `ym, ys2, ys1, yd`   | `Tensor Averaging Subtract Unsigned (Tensor-Tensor)`                                             |
| `rv_y`        | `yasubu_yx`            | `ym, ys2, rs1, yd`   | `Tensor Averaging Subtract Unsigned (Tensor-Scalar)`                                             |
| `rv_y`        | `yasub_yy`             | `ym, ys2, ys1, yd`   | `Tensor Averaging Subtract Signed (Tensor-Tensor)`                                               |
| `rv_y`        | `yasub_yx`             | `ym, ys2, rs1, yd`   | `Tensor Averaging Subtract Signed (Tensor-Scalar)`                                               |
| `rv_y`        | `ycompress_ym`         | `ys2, ys1, yd`       | `Tensor Compress`                                                                                |
| `rv_y`        | `ycpop_m`              | `ym, ys2, rd`        | `Tensor Mask Population Count`                                                                   |
| `rv_y`        | `ydivu_yy`             | `ym, ys2, ys1, yd`   | `Tensor Integer Divide Unsigned (Tensor-Tensor)`                                                 |
| `rv_y`        | `ydivu_yx`             | `ym, ys2, rs1, yd`   | `Tensor Integer Divide Unsigned (Tensor-Scalar)`                                                 |
| `rv_y`        | `ydiv_yy`              | `ym, ys2, ys1, yd`   | `Tensor Integer Divide Signed (Tensor-Tensor)`                                                   |
| `rv_y`        | `ydiv_yx`              | `ym, ys2, rs1, yd`   | `Tensor Integer Divide Signed (Tensor-Scalar)`                                                   |
| `rv_y`        | `yfadd_yf`             | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Add (Tensor-Scalar)`                                                      |
| `rv_y`        | `yfadd_yy`             | `ym, ys2, ys1, yd`   | `Tensor Floating-Point Add (Tensor-Tensor)`                                                      |
| `rv_y`        | `yfclass_y`            | `ym, ys2, yd`        | `Tensor Floating-Point Classify`                                                                 |
| `rv_y`        | `yfcvt_f_xu_y`         | `ym, ys2, yd`        | `Tensor Convert Unsigned Integer to Floating-Point`                                              |
| `rv_y`        | `yfcvt_f_x_y`          | `ym, ys2, yd`        | `Tensor Convert Signed Integer to Floating-Point`                                                |
| `rv_y`        | `yfcvt_rtz_x_f_y`      | `ym, ys2, yd`        | `Tensor Convert Floating-Point to Signed Integer with Round Toward Zero`                         |
| `rv_y`        | `yfcvt_rtz_xu_f_y`     | `ym, ys2, yd`        | `Tensor Convert Floating-Point to Unsigned Integer with Round Toward Zero`                       |
| `rv_y`        | `yfcvt_x_f_y`          | `ym, ys2, yd`        | `Tensor Convert Floating-Point to Signed Integer`                                                |
| `rv_y`        | `yfcvt_xu_f_y`         | `ym, ys2, yd`        | `Tensor Convert Floating-Point to Unsigned Integer`                                              |
| `rv_y`        | `yfdiv_yf`             | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Divide (Tensor-Scalar)`                                                   |
| `rv_y`        | `yfdiv_yy`             | `ym, ys2, ys1, yd`   | `Tensor Floating-Point Divide (Tensor-Tensor)`                                                   |
| `rv_y`        | `yfirst_m`             | `ym, ys2, rd`        | `Tensor Mask Find First Set`                                                                     |
| `rv_y`        | `yfmacc_yf`            | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Fused Multiply-Accumulate (Tensor-Scalar)`                                |
| `rv_y`        | `yfmacc_yy`            | `ym, ys2, ys1, yd`   | `Tensor Floating-Point Fused Multiply-Accumulate (Tensor-Tensor)`                                |
| `rv_y`        | `yfmadd_yf`            | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Fused Multiply-Add, Overwrite Multiplicand (Tensor-Scalar)`               |
| `rv_y`        | `yfmadd_yy`            | `ym, ys2, ys1, yd`   | `Tensor Floating-Point Fused Multiply-Add, Overwrite Multiplicand (Tensor-Tensor)`               |
| `rv_y`        | `yfmax_yf`             | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Maximum (Tensor-Scalar)`                                                  |
| `rv_y`        | `yfmax_yy`             | `ym, ys2, ys1, yd`   | `Tensor Floating-Point Maximum (Tensor-Tensor)`                                                  |
| `rv_y`        | `yfmerge_yfm`          | `ys2, rs1, yd`       | `Tensor Floating-Point Merge (Tensor-Scalar)`                                                    |
| `rv_y`        | `yfmin_yf`             | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Minimum (Tensor-Scalar)`                                                  |
| `rv_y`        | `yfmin_yy`             | `ym, ys2, ys1, yd`   | `Tensor Floating-Point Minimum (Tensor-Tensor)`                                                  |
| `rv_y`        | `yfmsac_yf`            | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Fused Multiply-Subtract Accumulator (Tensor-Scalar)`                      |
| `rv_y`        | `yfmsac_yy`            | `ym, ys2, ys1, yd`   | `Tensor Floating-Point Fused Multiply-Subtract Accumulator (Tensor-Tensor)`                      |
| `rv_y`        | `yfmsub_yf`            | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Fused Multiply-Subtract, Overwrite Multiplicand (Tensor-Scalar)`          |
| `rv_y`        | `yfmsub_yy`            | `ym, ys2, ys1, yd`   | `Tensor Floating-Point Fused Multiply-Subtract, Overwrite Multiplicand (Tensor-Tensor)`          |
| `rv_y`        | `yfmul_yf`             | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Multiply (Tensor-Scalar)`                                                 |
| `rv_y`        | `yfmul_yy`             | `ym, ys2, ys1, yd`   | `Tensor Floating-Point Multiply (Tensor-Tensor)`                                                 |
| `rv_y`        | `yfmv_f_s`             | `ys2, rd`            | `Tensor Move Tensor Element to Floating-Point Scalar`                                            |
| `rv_y`        | `yfmv_s_f`             | `rs1, yd`            | `Tensor Move Floating-Point Scalar to Tensor Element`                                            |
| `rv_y`        | `yfmv_y_f`             | `rs1, yd`            | `Tensor Broadcast Floating-Point Scalar`                                                         |
| `rv_y`        | `yfncvt_f_f_wide`      | `ym, ys2, yd`        | `Tensor Narrowing Convert Floating-Point to Floating-Point`                                      |
| `rv_y`        | `yfncvt_f_xu_wide`     | `ym, ys2, yd`        | `Tensor Narrowing Convert Unsigned Integer to Floating-Point`                                    |
| `rv_y`        | `yfncvt_f_x_wide`      | `ym, ys2, yd`        | `Tensor Narrowing Convert Signed Integer to Floating-Point`                                      |
| `rv_y`        | `yfncvt_rod_f_f_wide`  | `ym, ys2, yd`        | `Tensor Narrowing Convert Floating-Point to Floating-Point with Round to Odd`                    |
| `rv_y`        | `yfncvt_rtz_x_f_wide`  | `ym, ys2, yd`        | `Tensor Narrowing Convert Floating-Point to Signed Integer with Round Toward Zero`               |
| `rv_y`        | `yfncvt_rtz_xu_f_wide` | `ym, ys2, yd`        | `Tensor Narrowing Convert Floating-Point to Unsigned Integer with Round Toward Zero`             |
| `rv_y`        | `yfncvt_x_f_wide`      | `ym, ys2, yd`        | `Tensor Narrowing Convert Floating-Point to Signed Integer`                                      |
| `rv_y`        | `yfncvt_xu_f_wide`     | `ym, ys2, yd`        | `Tensor Narrowing Convert Floating-Point to Unsigned Integer`                                    |
| `rv_y`        | `yfnmacc_yf`           | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Fused Negative Multiply-Accumulate (Tensor-Scalar)`                       |
| `rv_y`        | `yfnmacc_yy`           | `ym, ys2, ys1, yd`   | `Tensor Floating-Point Fused Negative Multiply-Accumulate (Tensor-Tensor)`                       |
| `rv_y`        | `yfnmadd_yf`           | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Fused Negative Multiply-Add, Overwrite Multiplicand (Tensor-Scalar)`      |
| `rv_y`        | `yfnmadd_yy`           | `ym, ys2, ys1, yd`   | `Tensor Floating-Point Fused Negative Multiply-Add, Overwrite Multiplicand (Tensor-Tensor)`      |
| `rv_y`        | `yfnmsac_yf`           | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Fused Negative Multiply-Subtract Accumulator (Tensor-Scalar)`             |
| `rv_y`        | `yfnmsac_yy`           | `ym, ys2, ys1, yd`   | `Tensor Floating-Point Fused Negative Multiply-Subtract Accumulator (Tensor-Tensor)`             |
| `rv_y`        | `yfnmsub_yf`           | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Fused Negative Multiply-Subtract, Overwrite Multiplicand (Tensor-Scalar)` |
| `rv_y`        | `yfnmsub_yy`           | `ym, ys2, ys1, yd`   | `Tensor Floating-Point Fused Negative Multiply-Subtract, Overwrite Multiplicand (Tensor-Tensor)` |
| `rv_y`        | `yfrdiv_yf`            | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Reverse Divide (Tensor-Scalar)`                                           |
| `rv_y`        | `yfrec7_y`             | `ym, ys2, yd`        | `Tensor Floating-Point Reciprocal Estimate to 7 Bits`                                            |
| `rv_y`        | `yfredmax_ys`          | `ym, ys2, ys1, yd`   | `Tensor Floating-Point Maximum Reduction`                                                        |
| `rv_y`        | `yfredmin_ys`          | `ym, ys2, ys1, yd`   | `Tensor Floating-Point Minimum Reduction`                                                        |
| `rv_y`        | `yfredosum_ys`         | `ym, ys2, ys1, yd`   | `Tensor Floating-Point Ordered Sum Reduction`                                                    |
| `rv_y`        | `yfredusum_ys`         | `ym, ys2, ys1, yd`   | `Tensor Floating-Point Unordered Sum Reduction`                                                  |
| `rv_y`        | `yfrsqrt7_y`           | `ym, ys2, yd`        | `Tensor Floating-Point Reciprocal Square-Root Estimate to 7 Bits`                                |
| `rv_y`        | `yfrsub_yf`            | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Reverse Subtract (Tensor-Scalar)`                                         |
| `rv_y`        | `yfsgnjn_yf`           | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Negated Sign Injection (Tensor-Scalar)`                                   |
| `rv_y`        | `yfsgnjn_yy`           | `ym, ys2, ys1, yd`   | `Tensor Floating-Point Negated Sign Injection (Tensor-Tensor)`                                   |
| `rv_y`        | `yfsgnj_yf`            | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Sign Injection (Tensor-Scalar)`                                           |
| `rv_y`        | `yfsgnj_yy`            | `ym, ys2, ys1, yd`   | `Tensor Floating-Point Sign Injection (Tensor-Tensor)`                                           |
| `rv_y`        | `yfsgnjx_yf`           | `ym, ys2, rs1, yd`   | `Tensor Floating-Point XOR Sign Injection (Tensor-Scalar)`                                       |
| `rv_y`        | `yfsgnjx_yy`           | `ym, ys2, ys1, yd`   | `Tensor Floating-Point XOR Sign Injection (Tensor-Tensor)`                                       |
| `rv_y`        | `yfslide1down_yf`      | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Slide One Down (Tensor-Scalar)`                                           |
| `rv_y`        | `yfslide1up_yf`        | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Slide One Up (Tensor-Scalar)`                                             |
| `rv_y`        | `yfsqrt_y`             | `ym, ys2, yd`        | `Tensor Floating-Point Square Root`                                                              |
| `rv_y`        | `yfsub_yf`             | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Subtract (Tensor-Scalar)`                                                 |
| `rv_y`        | `yfsub_yy`             | `ym, ys2, ys1, yd`   | `Tensor Floating-Point Subtract (Tensor-Tensor)`                                                 |
| `rv_y`        | `yfwadd_yf`            | `ym, ys2, rs1, yd`   | `Tensor Widening Floating-Point Add (Tensor-Scalar)`                                             |
| `rv_y`        | `yfwadd_yy`            | `ym, ys2, ys1, yd`   | `Tensor Widening Floating-Point Add (Tensor-Tensor)`                                             |
| `rv_y`        | `yfwadd_wide_yf`       | `ym, ys2, rs1, yd`   | `Tensor Widening Floating-Point Add (Wide Tensor-Scalar)`                                        |
| `rv_y`        | `yfwadd_wide_yy`       | `ym, ys2, ys1, yd`   | `Tensor Widening Floating-Point Add (Wide Tensor-Tensor)`                                        |
| `rv_y`        | `yfwcvt_f_f_y`         | `ym, ys2, yd`        | `Tensor Widening Convert Floating-Point to Floating-Point`                                       |
| `rv_y`        | `yfwcvt_f_xu_y`        | `ym, ys2, yd`        | `Tensor Widening Convert Unsigned Integer to Floating-Point`                                     |
| `rv_y`        | `yfwcvt_f_x_y`         | `ym, ys2, yd`        | `Tensor Widening Convert Signed Integer to Floating-Point`                                       |
| `rv_y`        | `yfwcvt_rtz_x_f_y`     | `ym, ys2, yd`        | `Tensor Widening Convert Floating-Point to Signed Integer with Round Toward Zero`                |
| `rv_y`        | `yfwcvt_rtz_xu_f_y`    | `ym, ys2, yd`        | `Tensor Widening Convert Floating-Point to Unsigned Integer with Round Toward Zero`              |
| `rv_y`        | `yfwcvt_x_f_y`         | `ym, ys2, yd`        | `Tensor Widening Convert Floating-Point to Signed Integer`                                       |
| `rv_y`        | `yfwcvt_xu_f_y`        | `ym, ys2, yd`        | `Tensor Widening Convert Floating-Point to Unsigned Integer`                                     |
| `rv_y`        | `yfwmacc_yf`           | `ym, ys2, rs1, yd`   | `Tensor Widening Floating-Point Fused Multiply-Accumulate (Tensor-Scalar)`                       |
| `rv_y`        | `yfwmacc_yy`           | `ym, ys2, ys1, yd`   | `Tensor Widening Floating-Point Fused Multiply-Accumulate (Tensor-Tensor)`                       |
| `rv_y`        | `yfwmsac_yf`           | `ym, ys2, rs1, yd`   | `Tensor Widening Floating-Point Fused Multiply-Subtract Accumulator (Tensor-Scalar)`             |
| `rv_y`        | `yfwmsac_yy`           | `ym, ys2, ys1, yd`   | `Tensor Widening Floating-Point Fused Multiply-Subtract Accumulator (Tensor-Tensor)`             |
| `rv_y`        | `yfwmul_yf`            | `ym, ys2, rs1, yd`   | `Tensor Widening Floating-Point Multiply (Tensor-Scalar)`                                        |
| `rv_y`        | `yfwmul_yy`            | `ym, ys2, ys1, yd`   | `Tensor Widening Floating-Point Multiply (Tensor-Tensor)`                                        |
| `rv_y`        | `yfwnmacc_yf`          | `ym, ys2, rs1, yd`   | `Tensor Widening Floating-Point Fused Negative Multiply-Accumulate (Tensor-Scalar)`              |
| `rv_y`        | `yfwnmacc_yy`          | `ym, ys2, ys1, yd`   | `Tensor Widening Floating-Point Fused Negative Multiply-Accumulate (Tensor-Tensor)`              |
| `rv_y`        | `yfwnmsac_yf`          | `ym, ys2, rs1, yd`   | `Tensor Widening Floating-Point Fused Negative Multiply-Subtract Accumulator (Tensor-Scalar)`    |
| `rv_y`        | `yfwnmsac_yy`          | `ym, ys2, ys1, yd`   | `Tensor Widening Floating-Point Fused Negative Multiply-Subtract Accumulator (Tensor-Tensor)`    |
| `rv_y`        | `yfwredosum_ys`        | `ym, ys2, ys1, yd`   | `Tensor Widening Floating-Point Ordered Sum Reduction`                                           |
| `rv_y`        | `yfwredusum_ys`        | `ym, ys2, ys1, yd`   | `Tensor Widening Floating-Point Unordered Sum Reduction`                                         |
| `rv_y`        | `yfwsub_yf`            | `ym, ys2, rs1, yd`   | `Tensor Widening Floating-Point Subtract (Tensor-Scalar)`                                        |
| `rv_y`        | `yfwsub_yy`            | `ym, ys2, ys1, yd`   | `Tensor Widening Floating-Point Subtract (Tensor-Tensor)`                                        |
| `rv_y`        | `yfwsub_wide_yf`       | `ym, ys2, rs1, yd`   | `Tensor Widening Floating-Point Subtract (Wide Tensor-Scalar)`                                   |
| `rv_y`        | `yfwsub_wide_yy`       | `ym, ys2, ys1, yd`   | `Tensor Widening Floating-Point Subtract (Wide Tensor-Tensor)`                                   |
| `rv_y`        | `yid_y`                | `ym, yd`             | `Tensor Element Index`                                                                           |
| `rv_y`        | `yiota_m`              | `ym, ys2, yd`        | `Tensor Mask Iota`                                                                               |
| `rv_y`        | `yl1re16_y`            | `rs1, yd`            | `Tensor Load 1 Whole Register with 16-Bit Encoded Element Width`                                 |
| `rv_y`        | `yl1re32_y`            | `rs1, yd`            | `Tensor Load 1 Whole Register with 32-Bit Encoded Element Width`                                 |
| `rv_y`        | `yl1re64_y`            | `rs1, yd`            | `Tensor Load 1 Whole Register with 64-Bit Encoded Element Width`                                 |
| `rv_y`        | `yl1re8_y`             | `rs1, yd`            | `Tensor Load 1 Whole Register with 8-Bit Encoded Element Width`                                  |
| `rv_y`        | `yl2re16_y`            | `rs1, yd`            | `Tensor Load 2 Whole Registers with 16-Bit Encoded Element Width`                                |
| `rv_y`        | `yl2re32_y`            | `rs1, yd`            | `Tensor Load 2 Whole Registers with 32-Bit Encoded Element Width`                                |
| `rv_y`        | `yl2re64_y`            | `rs1, yd`            | `Tensor Load 2 Whole Registers with 64-Bit Encoded Element Width`                                |
| `rv_y`        | `yl2re8_y`             | `rs1, yd`            | `Tensor Load 2 Whole Registers with 8-Bit Encoded Element Width`                                 |
| `rv_y`        | `yl4re16_y`            | `rs1, yd`            | `Tensor Load 4 Whole Registers with 16-Bit Encoded Element Width`                                |
| `rv_y`        | `yl4re32_y`            | `rs1, yd`            | `Tensor Load 4 Whole Registers with 32-Bit Encoded Element Width`                                |
| `rv_y`        | `yl4re64_y`            | `rs1, yd`            | `Tensor Load 4 Whole Registers with 64-Bit Encoded Element Width`                                |
| `rv_y`        | `yl4re8_y`             | `rs1, yd`            | `Tensor Load 4 Whole Registers with 8-Bit Encoded Element Width`                                 |
| `rv_y`        | `yl8re16_y`            | `rs1, yd`            | `Tensor Load 8 Whole Registers with 16-Bit Encoded Element Width`                                |
| `rv_y`        | `yl8re32_y`            | `rs1, yd`            | `Tensor Load 8 Whole Registers with 32-Bit Encoded Element Width`                                |
| `rv_y`        | `yl8re64_y`            | `rs1, yd`            | `Tensor Load 8 Whole Registers with 64-Bit Encoded Element Width`                                |
| `rv_y`        | `yl8re8_y`             | `rs1, yd`            | `Tensor Load 8 Whole Registers with 8-Bit Encoded Element Width`                                 |
| `rv_y`        | `yle16ff_y`            | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Load with 16-Bit Elements`                                  |
| `rv_y`        | `yle16_y`              | `ym, rs1, yd`        | `Tensor Unit-Stride Load with 16-Bit Elements`                                                   |
| `rv_y`        | `yle32ff_y`            | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Load with 32-Bit Elements`                                  |
| `rv_y`        | `yle32_y`              | `ym, rs1, yd`        | `Tensor Unit-Stride Load with 32-Bit Elements`                                                   |
| `rv_y`        | `yle64ff_y`            | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Load with 64-Bit Elements`                                  |
| `rv_y`        | `yle64_y`              | `ym, rs1, yd`        | `Tensor Unit-Stride Load with 64-Bit Elements`                                                   |
| `rv_y`        | `yle8ff_y`             | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Load with 8-Bit Elements`                                   |
| `rv_y`        | `yle8_y`               | `ym, rs1, yd`        | `Tensor Unit-Stride Load with 8-Bit Elements`                                                    |
| `rv_y`        | `ylm_y`                | `rs1, yd`            | `Tensor Mask Load`                                                                               |
| `rv_y`        | `yloxei16_y`           | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Load with 16-Bit Indices`                                                |
| `rv_y`        | `yloxei32_y`           | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Load with 32-Bit Indices`                                                |
| `rv_y`        | `yloxei64_y`           | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Load with 64-Bit Indices`                                                |
| `rv_y`        | `yloxei8_y`            | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Load with 8-Bit Indices`                                                 |
| `rv_y`        | `yloxseg2ei16_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 2 Fields with 16-Bit Indices`                            |
| `rv_y`        | `yloxseg2ei32_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 2 Fields with 32-Bit Indices`                            |
| `rv_y`        | `yloxseg2ei64_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 2 Fields with 64-Bit Indices`                            |
| `rv_y`        | `yloxseg2ei8_y`        | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 2 Fields with 8-Bit Indices`                             |
| `rv_y`        | `yloxseg3ei16_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 3 Fields with 16-Bit Indices`                            |
| `rv_y`        | `yloxseg3ei32_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 3 Fields with 32-Bit Indices`                            |
| `rv_y`        | `yloxseg3ei64_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 3 Fields with 64-Bit Indices`                            |
| `rv_y`        | `yloxseg3ei8_y`        | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 3 Fields with 8-Bit Indices`                             |
| `rv_y`        | `yloxseg4ei16_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 4 Fields with 16-Bit Indices`                            |
| `rv_y`        | `yloxseg4ei32_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 4 Fields with 32-Bit Indices`                            |
| `rv_y`        | `yloxseg4ei64_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 4 Fields with 64-Bit Indices`                            |
| `rv_y`        | `yloxseg4ei8_y`        | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 4 Fields with 8-Bit Indices`                             |
| `rv_y`        | `yloxseg5ei16_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 5 Fields with 16-Bit Indices`                            |
| `rv_y`        | `yloxseg5ei32_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 5 Fields with 32-Bit Indices`                            |
| `rv_y`        | `yloxseg5ei64_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 5 Fields with 64-Bit Indices`                            |
| `rv_y`        | `yloxseg5ei8_y`        | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 5 Fields with 8-Bit Indices`                             |
| `rv_y`        | `yloxseg6ei16_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 6 Fields with 16-Bit Indices`                            |
| `rv_y`        | `yloxseg6ei32_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 6 Fields with 32-Bit Indices`                            |
| `rv_y`        | `yloxseg6ei64_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 6 Fields with 64-Bit Indices`                            |
| `rv_y`        | `yloxseg6ei8_y`        | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 6 Fields with 8-Bit Indices`                             |
| `rv_y`        | `yloxseg7ei16_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 7 Fields with 16-Bit Indices`                            |
| `rv_y`        | `yloxseg7ei32_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 7 Fields with 32-Bit Indices`                            |
| `rv_y`        | `yloxseg7ei64_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 7 Fields with 64-Bit Indices`                            |
| `rv_y`        | `yloxseg7ei8_y`        | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 7 Fields with 8-Bit Indices`                             |
| `rv_y`        | `yloxseg8ei16_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 8 Fields with 16-Bit Indices`                            |
| `rv_y`        | `yloxseg8ei32_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 8 Fields with 32-Bit Indices`                            |
| `rv_y`        | `yloxseg8ei64_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 8 Fields with 64-Bit Indices`                            |
| `rv_y`        | `yloxseg8ei8_y`        | `ym, ys2, rs1, yd`   | `Tensor Indexed-Ordered Segment Load of 8 Fields with 8-Bit Indices`                             |
| `rv_y`        | `ylse16_y`             | `ym, rs2, rs1, yd`   | `Tensor Strided Load with 16-Bit Elements`                                                       |
| `rv_y`        | `ylse32_y`             | `ym, rs2, rs1, yd`   | `Tensor Strided Load with 32-Bit Elements`                                                       |
| `rv_y`        | `ylse64_y`             | `ym, rs2, rs1, yd`   | `Tensor Strided Load with 64-Bit Elements`                                                       |
| `rv_y`        | `ylse8_y`              | `ym, rs2, rs1, yd`   | `Tensor Strided Load with 8-Bit Elements`                                                        |
| `rv_y`        | `ylseg2e16ff_y`        | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 2 Fields with 16-Bit Elements`              |
| `rv_y`        | `ylseg2e16_y`          | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 2 Fields with 16-Bit Elements`                               |
| `rv_y`        | `ylseg2e32ff_y`        | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 2 Fields with 32-Bit Elements`              |
| `rv_y`        | `ylseg2e32_y`          | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 2 Fields with 32-Bit Elements`                               |
| `rv_y`        | `ylseg2e64ff_y`        | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 2 Fields with 64-Bit Elements`              |
| `rv_y`        | `ylseg2e64_y`          | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 2 Fields with 64-Bit Elements`                               |
| `rv_y`        | `ylseg2e8ff_y`         | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 2 Fields with 8-Bit Elements`               |
| `rv_y`        | `ylseg2e8_y`           | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 2 Fields with 8-Bit Elements`                                |
| `rv_y`        | `ylseg3e16ff_y`        | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 3 Fields with 16-Bit Elements`              |
| `rv_y`        | `ylseg3e16_y`          | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 3 Fields with 16-Bit Elements`                               |
| `rv_y`        | `ylseg3e32ff_y`        | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 3 Fields with 32-Bit Elements`              |
| `rv_y`        | `ylseg3e32_y`          | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 3 Fields with 32-Bit Elements`                               |
| `rv_y`        | `ylseg3e64ff_y`        | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 3 Fields with 64-Bit Elements`              |
| `rv_y`        | `ylseg3e64_y`          | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 3 Fields with 64-Bit Elements`                               |
| `rv_y`        | `ylseg3e8ff_y`         | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 3 Fields with 8-Bit Elements`               |
| `rv_y`        | `ylseg3e8_y`           | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 3 Fields with 8-Bit Elements`                                |
| `rv_y`        | `ylseg4e16ff_y`        | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 4 Fields with 16-Bit Elements`              |
| `rv_y`        | `ylseg4e16_y`          | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 4 Fields with 16-Bit Elements`                               |
| `rv_y`        | `ylseg4e32ff_y`        | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 4 Fields with 32-Bit Elements`              |
| `rv_y`        | `ylseg4e32_y`          | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 4 Fields with 32-Bit Elements`                               |
| `rv_y`        | `ylseg4e64ff_y`        | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 4 Fields with 64-Bit Elements`              |
| `rv_y`        | `ylseg4e64_y`          | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 4 Fields with 64-Bit Elements`                               |
| `rv_y`        | `ylseg4e8ff_y`         | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 4 Fields with 8-Bit Elements`               |
| `rv_y`        | `ylseg4e8_y`           | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 4 Fields with 8-Bit Elements`                                |
| `rv_y`        | `ylseg5e16ff_y`        | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 5 Fields with 16-Bit Elements`              |
| `rv_y`        | `ylseg5e16_y`          | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 5 Fields with 16-Bit Elements`                               |
| `rv_y`        | `ylseg5e32ff_y`        | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 5 Fields with 32-Bit Elements`              |
| `rv_y`        | `ylseg5e32_y`          | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 5 Fields with 32-Bit Elements`                               |
| `rv_y`        | `ylseg5e64ff_y`        | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 5 Fields with 64-Bit Elements`              |
| `rv_y`        | `ylseg5e64_y`          | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 5 Fields with 64-Bit Elements`                               |
| `rv_y`        | `ylseg5e8ff_y`         | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 5 Fields with 8-Bit Elements`               |
| `rv_y`        | `ylseg5e8_y`           | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 5 Fields with 8-Bit Elements`                                |
| `rv_y`        | `ylseg6e16ff_y`        | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 6 Fields with 16-Bit Elements`              |
| `rv_y`        | `ylseg6e16_y`          | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 6 Fields with 16-Bit Elements`                               |
| `rv_y`        | `ylseg6e32ff_y`        | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 6 Fields with 32-Bit Elements`              |
| `rv_y`        | `ylseg6e32_y`          | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 6 Fields with 32-Bit Elements`                               |
| `rv_y`        | `ylseg6e64ff_y`        | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 6 Fields with 64-Bit Elements`              |
| `rv_y`        | `ylseg6e64_y`          | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 6 Fields with 64-Bit Elements`                               |
| `rv_y`        | `ylseg6e8ff_y`         | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 6 Fields with 8-Bit Elements`               |
| `rv_y`        | `ylseg6e8_y`           | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 6 Fields with 8-Bit Elements`                                |
| `rv_y`        | `ylseg7e16ff_y`        | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 7 Fields with 16-Bit Elements`              |
| `rv_y`        | `ylseg7e16_y`          | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 7 Fields with 16-Bit Elements`                               |
| `rv_y`        | `ylseg7e32ff_y`        | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 7 Fields with 32-Bit Elements`              |
| `rv_y`        | `ylseg7e32_y`          | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 7 Fields with 32-Bit Elements`                               |
| `rv_y`        | `ylseg7e64ff_y`        | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 7 Fields with 64-Bit Elements`              |
| `rv_y`        | `ylseg7e64_y`          | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 7 Fields with 64-Bit Elements`                               |
| `rv_y`        | `ylseg7e8ff_y`         | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 7 Fields with 8-Bit Elements`               |
| `rv_y`        | `ylseg7e8_y`           | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 7 Fields with 8-Bit Elements`                                |
| `rv_y`        | `ylseg8e16ff_y`        | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 8 Fields with 16-Bit Elements`              |
| `rv_y`        | `ylseg8e16_y`          | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 8 Fields with 16-Bit Elements`                               |
| `rv_y`        | `ylseg8e32ff_y`        | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 8 Fields with 32-Bit Elements`              |
| `rv_y`        | `ylseg8e32_y`          | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 8 Fields with 32-Bit Elements`                               |
| `rv_y`        | `ylseg8e64ff_y`        | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 8 Fields with 64-Bit Elements`              |
| `rv_y`        | `ylseg8e64_y`          | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 8 Fields with 64-Bit Elements`                               |
| `rv_y`        | `ylseg8e8ff_y`         | `ym, rs1, yd`        | `Tensor Unit-Stride Fault-Only-First Segment Load of 8 Fields with 8-Bit Elements`               |
| `rv_y`        | `ylseg8e8_y`           | `ym, rs1, yd`        | `Tensor Unit-Stride Segment Load of 8 Fields with 8-Bit Elements`                                |
| `rv_y`        | `ylsseg2e16_y`         | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 2 Fields with 16-Bit Elements`                                   |
| `rv_y`        | `ylsseg2e32_y`         | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 2 Fields with 32-Bit Elements`                                   |
| `rv_y`        | `ylsseg2e64_y`         | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 2 Fields with 64-Bit Elements`                                   |
| `rv_y`        | `ylsseg2e8_y`          | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 2 Fields with 8-Bit Elements`                                    |
| `rv_y`        | `ylsseg3e16_y`         | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 3 Fields with 16-Bit Elements`                                   |
| `rv_y`        | `ylsseg3e32_y`         | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 3 Fields with 32-Bit Elements`                                   |
| `rv_y`        | `ylsseg3e64_y`         | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 3 Fields with 64-Bit Elements`                                   |
| `rv_y`        | `ylsseg3e8_y`          | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 3 Fields with 8-Bit Elements`                                    |
| `rv_y`        | `ylsseg4e16_y`         | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 4 Fields with 16-Bit Elements`                                   |
| `rv_y`        | `ylsseg4e32_y`         | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 4 Fields with 32-Bit Elements`                                   |
| `rv_y`        | `ylsseg4e64_y`         | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 4 Fields with 64-Bit Elements`                                   |
| `rv_y`        | `ylsseg4e8_y`          | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 4 Fields with 8-Bit Elements`                                    |
| `rv_y`        | `ylsseg5e16_y`         | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 5 Fields with 16-Bit Elements`                                   |
| `rv_y`        | `ylsseg5e32_y`         | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 5 Fields with 32-Bit Elements`                                   |
| `rv_y`        | `ylsseg5e64_y`         | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 5 Fields with 64-Bit Elements`                                   |
| `rv_y`        | `ylsseg5e8_y`          | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 5 Fields with 8-Bit Elements`                                    |
| `rv_y`        | `ylsseg6e16_y`         | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 6 Fields with 16-Bit Elements`                                   |
| `rv_y`        | `ylsseg6e32_y`         | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 6 Fields with 32-Bit Elements`                                   |
| `rv_y`        | `ylsseg6e64_y`         | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 6 Fields with 64-Bit Elements`                                   |
| `rv_y`        | `ylsseg6e8_y`          | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 6 Fields with 8-Bit Elements`                                    |
| `rv_y`        | `ylsseg7e16_y`         | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 7 Fields with 16-Bit Elements`                                   |
| `rv_y`        | `ylsseg7e32_y`         | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 7 Fields with 32-Bit Elements`                                   |
| `rv_y`        | `ylsseg7e64_y`         | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 7 Fields with 64-Bit Elements`                                   |
| `rv_y`        | `ylsseg7e8_y`          | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 7 Fields with 8-Bit Elements`                                    |
| `rv_y`        | `ylsseg8e16_y`         | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 8 Fields with 16-Bit Elements`                                   |
| `rv_y`        | `ylsseg8e32_y`         | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 8 Fields with 32-Bit Elements`                                   |
| `rv_y`        | `ylsseg8e64_y`         | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 8 Fields with 64-Bit Elements`                                   |
| `rv_y`        | `ylsseg8e8_y`          | `ym, rs2, rs1, yd`   | `Tensor Strided Segment Load of 8 Fields with 8-Bit Elements`                                    |
| `rv_y`        | `yluxei16_y`           | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Load with 16-Bit Indices`                                              |
| `rv_y`        | `yluxei32_y`           | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Load with 32-Bit Indices`                                              |
| `rv_y`        | `yluxei64_y`           | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Load with 64-Bit Indices`                                              |
| `rv_y`        | `yluxei8_y`            | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Load with 8-Bit Indices`                                               |
| `rv_y`        | `yluxseg2ei16_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 2 Fields with 16-Bit Indices`                          |
| `rv_y`        | `yluxseg2ei32_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 2 Fields with 32-Bit Indices`                          |
| `rv_y`        | `yluxseg2ei64_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 2 Fields with 64-Bit Indices`                          |
| `rv_y`        | `yluxseg2ei8_y`        | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 2 Fields with 8-Bit Indices`                           |
| `rv_y`        | `yluxseg3ei16_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 3 Fields with 16-Bit Indices`                          |
| `rv_y`        | `yluxseg3ei32_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 3 Fields with 32-Bit Indices`                          |
| `rv_y`        | `yluxseg3ei64_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 3 Fields with 64-Bit Indices`                          |
| `rv_y`        | `yluxseg3ei8_y`        | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 3 Fields with 8-Bit Indices`                           |
| `rv_y`        | `yluxseg4ei16_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 4 Fields with 16-Bit Indices`                          |
| `rv_y`        | `yluxseg4ei32_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 4 Fields with 32-Bit Indices`                          |
| `rv_y`        | `yluxseg4ei64_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 4 Fields with 64-Bit Indices`                          |
| `rv_y`        | `yluxseg4ei8_y`        | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 4 Fields with 8-Bit Indices`                           |
| `rv_y`        | `yluxseg5ei16_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 5 Fields with 16-Bit Indices`                          |
| `rv_y`        | `yluxseg5ei32_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 5 Fields with 32-Bit Indices`                          |
| `rv_y`        | `yluxseg5ei64_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 5 Fields with 64-Bit Indices`                          |
| `rv_y`        | `yluxseg5ei8_y`        | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 5 Fields with 8-Bit Indices`                           |
| `rv_y`        | `yluxseg6ei16_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 6 Fields with 16-Bit Indices`                          |
| `rv_y`        | `yluxseg6ei32_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 6 Fields with 32-Bit Indices`                          |
| `rv_y`        | `yluxseg6ei64_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 6 Fields with 64-Bit Indices`                          |
| `rv_y`        | `yluxseg6ei8_y`        | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 6 Fields with 8-Bit Indices`                           |
| `rv_y`        | `yluxseg7ei16_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 7 Fields with 16-Bit Indices`                          |
| `rv_y`        | `yluxseg7ei32_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 7 Fields with 32-Bit Indices`                          |
| `rv_y`        | `yluxseg7ei64_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 7 Fields with 64-Bit Indices`                          |
| `rv_y`        | `yluxseg7ei8_y`        | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 7 Fields with 8-Bit Indices`                           |
| `rv_y`        | `yluxseg8ei16_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 8 Fields with 16-Bit Indices`                          |
| `rv_y`        | `yluxseg8ei32_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 8 Fields with 32-Bit Indices`                          |
| `rv_y`        | `yluxseg8ei64_y`       | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 8 Fields with 64-Bit Indices`                          |
| `rv_y`        | `yluxseg8ei8_y`        | `ym, ys2, rs1, yd`   | `Tensor Indexed-Unordered Segment Load of 8 Fields with 8-Bit Indices`                           |
| `rv_y`        | `ymacc_yy`             | `ym, ys2, ys1, yd`   | `Tensor Integer Multiply-Accumulate (Tensor-Tensor)`                                             |
| `rv_y`        | `ymacc_yx`             | `ym, ys2, rs1, yd`   | `Tensor Integer Multiply-Accumulate (Tensor-Scalar)`                                             |
| `rv_y`        | `ymadc_yi`             | `ys2, simm5, yd`     | `Tensor Integer Add Carry-Out (Tensor-Immediate)`                                                |
| `rv_y`        | `ymadc_yim`            | `ys2, simm5, yd`     | `Tensor Integer Add Carry-Out (Tensor-Immediate with Mask Carry Input)`                          |
| `rv_y`        | `ymadc_yy`             | `ys2, ys1, yd`       | `Tensor Integer Add Carry-Out (Tensor-Tensor)`                                                   |
| `rv_y`        | `ymadc_yym`            | `ys2, ys1, yd`       | `Tensor Integer Add Carry-Out (Tensor-Tensor with Mask Carry Input)`                             |
| `rv_y`        | `ymadc_yx`             | `ys2, rs1, yd`       | `Tensor Integer Add Carry-Out (Tensor-Scalar)`                                                   |
| `rv_y`        | `ymadc_yxm`            | `ys2, rs1, yd`       | `Tensor Integer Add Carry-Out (Tensor-Scalar with Mask Carry Input)`                             |
| `rv_y`        | `ymadd_yy`             | `ym, ys2, ys1, yd`   | `Tensor Integer Multiply-Add, Overwrite Multiplicand (Tensor-Tensor)`                            |
| `rv_y`        | `ymadd_yx`             | `ym, ys2, rs1, yd`   | `Tensor Integer Multiply-Add, Overwrite Multiplicand (Tensor-Scalar)`                            |
| `rv_y`        | `ymand_mm`             | `ys2, ys1, yd`       | `Tensor Mask AND`                                                                                |
| `rv_y`        | `ymandn_mm`            | `ys2, ys1, yd`       | `Tensor Mask AND-NOT`                                                                            |
| `rv_y`        | `ymaxu_yy`             | `ym, ys2, ys1, yd`   | `Tensor Integer Max Unsigned (Tensor-Tensor)`                                                    |
| `rv_y`        | `ymaxu_yx`             | `ym, ys2, rs1, yd`   | `Tensor Integer Max Unsigned (Tensor-Scalar)`                                                    |
| `rv_y`        | `ymax_yy`              | `ym, ys2, ys1, yd`   | `Tensor Integer Max Signed (Tensor-Tensor)`                                                      |
| `rv_y`        | `ymax_yx`              | `ym, ys2, rs1, yd`   | `Tensor Integer Max Signed (Tensor-Scalar)`                                                      |
| `rv_y`        | `ymerge_yim`           | `ys2, simm5, yd`     | `Tensor Integer Merge (Tensor-Immediate)`                                                        |
| `rv_y`        | `ymerge_yym`           | `ys2, ys1, yd`       | `Tensor Integer Merge (Tensor-Tensor)`                                                           |
| `rv_y`        | `ymerge_yxm`           | `ys2, rs1, yd`       | `Tensor Integer Merge (Tensor-Scalar)`                                                           |
| `rv_y`        | `ymfeq_yf`             | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Compare Equal (Tensor-Scalar)`                                            |
| `rv_y`        | `ymfeq_yy`             | `ym, ys2, ys1, yd`   | `Tensor Floating-Point Compare Equal (Tensor-Tensor)`                                            |
| `rv_y`        | `ymfge_yf`             | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Compare Greater Than or Equal (Tensor-Scalar)`                            |
| `rv_y`        | `ymfgt_yf`             | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Compare Greater Than (Tensor-Scalar)`                                     |
| `rv_y`        | `ymfle_yf`             | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Compare Less Than or Equal (Tensor-Scalar)`                               |
| `rv_y`        | `ymfle_yy`             | `ym, ys2, ys1, yd`   | `Tensor Floating-Point Compare Less Than or Equal (Tensor-Tensor)`                               |
| `rv_y`        | `ymflt_yf`             | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Compare Less Than (Tensor-Scalar)`                                        |
| `rv_y`        | `ymflt_yy`             | `ym, ys2, ys1, yd`   | `Tensor Floating-Point Compare Less Than (Tensor-Tensor)`                                        |
| `rv_y`        | `ymfne_yf`             | `ym, ys2, rs1, yd`   | `Tensor Floating-Point Compare Not Equal (Tensor-Scalar)`                                        |
| `rv_y`        | `ymfne_yy`             | `ym, ys2, ys1, yd`   | `Tensor Floating-Point Compare Not Equal (Tensor-Tensor)`                                        |
| `rv_y`        | `yminu_yy`             | `ym, ys2, ys1, yd`   | `Tensor Integer Min Unsigned (Tensor-Tensor)`                                                    |
| `rv_y`        | `yminu_yx`             | `ym, ys2, rs1, yd`   | `Tensor Integer Min Unsigned (Tensor-Scalar)`                                                    |
| `rv_y`        | `ymin_yy`              | `ym, ys2, ys1, yd`   | `Tensor Integer Min Signed (Tensor-Tensor)`                                                      |
| `rv_y`        | `ymin_yx`              | `ym, ys2, rs1, yd`   | `Tensor Integer Min Signed (Tensor-Scalar)`                                                      |
| `rv_y`        | `ymnand_mm`            | `ys2, ys1, yd`       | `Tensor Mask NAND`                                                                               |
| `rv_y`        | `ymnor_mm`             | `ys2, ys1, yd`       | `Tensor Mask NOR`                                                                                |
| `rv_y`        | `ymor_mm`              | `ys2, ys1, yd`       | `Tensor Mask OR`                                                                                 |
| `rv_y`        | `ymorn_mm`             | `ys2, ys1, yd`       | `Tensor Mask OR-NOT`                                                                             |
| `rv_y`        | `ymsbc_yy`             | `ys2, ys1, yd`       | `Tensor Integer Subtract Borrow-Out (Tensor-Tensor)`                                             |
| `rv_y`        | `ymsbc_yym`            | `ys2, ys1, yd`       | `Tensor Integer Subtract Borrow-Out (Tensor-Tensor with Mask Borrow Input)`                      |
| `rv_y`        | `ymsbc_yx`             | `ys2, rs1, yd`       | `Tensor Integer Subtract Borrow-Out (Tensor-Scalar)`                                             |
| `rv_y`        | `ymsbc_yxm`            | `ys2, rs1, yd`       | `Tensor Integer Subtract Borrow-Out (Tensor-Scalar with Mask Borrow Input)`                      |
| `rv_y`        | `ymsbf_m`              | `ym, ys2, yd`        | `Tensor Mask Set Before First`                                                                   |
| `rv_y`        | `ymseq_yi`             | `ym, ys2, simm5, yd` | `Tensor Integer Compare Equal (Tensor-Immediate)`                                                |
| `rv_y`        | `ymseq_yy`             | `ym, ys2, ys1, yd`   | `Tensor Integer Compare Equal (Tensor-Tensor)`                                                   |
| `rv_y`        | `ymseq_yx`             | `ym, ys2, rs1, yd`   | `Tensor Integer Compare Equal (Tensor-Scalar)`                                                   |
| `rv_y`        | `ymsgtu_yi`            | `ym, ys2, simm5, yd` | `Tensor Integer Compare Greater Than Unsigned (Tensor-Immediate)`                                |
| `rv_y`        | `ymsgtu_yx`            | `ym, ys2, rs1, yd`   | `Tensor Integer Compare Greater Than Unsigned (Tensor-Scalar)`                                   |
| `rv_y`        | `ymsgt_yi`             | `ym, ys2, simm5, yd` | `Tensor Integer Compare Greater Than Signed (Tensor-Immediate)`                                  |
| `rv_y`        | `ymsgt_yx`             | `ym, ys2, rs1, yd`   | `Tensor Integer Compare Greater Than Signed (Tensor-Scalar)`                                     |
| `rv_y`        | `ymsif_m`              | `ym, ys2, yd`        | `Tensor Mask Set Including First`                                                                |
| `rv_y`        | `ymsleu_yi`            | `ym, ys2, simm5, yd` | `Tensor Integer Compare Less Than or Equal Unsigned (Tensor-Immediate)`                          |
| `rv_y`        | `ymsleu_yy`            | `ym, ys2, ys1, yd`   | `Tensor Integer Compare Less Than or Equal Unsigned (Tensor-Tensor)`                             |
| `rv_y`        | `ymsleu_yx`            | `ym, ys2, rs1, yd`   | `Tensor Integer Compare Less Than or Equal Unsigned (Tensor-Scalar)`                             |
| `rv_y`        | `ymsle_yi`             | `ym, ys2, simm5, yd` | `Tensor Integer Compare Less Than or Equal Signed (Tensor-Immediate)`                            |
| `rv_y`        | `ymsle_yy`             | `ym, ys2, ys1, yd`   | `Tensor Integer Compare Less Than or Equal Signed (Tensor-Tensor)`                               |
| `rv_y`        | `ymsle_yx`             | `ym, ys2, rs1, yd`   | `Tensor Integer Compare Less Than or Equal Signed (Tensor-Scalar)`                               |
| `rv_y`        | `ymsltu_yy`            | `ym, ys2, ys1, yd`   | `Tensor Integer Compare Less Than Unsigned (Tensor-Tensor)`                                      |
| `rv_y`        | `ymsltu_yx`            | `ym, ys2, rs1, yd`   | `Tensor Integer Compare Less Than Unsigned (Tensor-Scalar)`                                      |
| `rv_y`        | `ymslt_yy`             | `ym, ys2, ys1, yd`   | `Tensor Integer Compare Less Than Signed (Tensor-Tensor)`                                        |
| `rv_y`        | `ymslt_yx`             | `ym, ys2, rs1, yd`   | `Tensor Integer Compare Less Than Signed (Tensor-Scalar)`                                        |
| `rv_y`        | `ymsne_yi`             | `ym, ys2, simm5, yd` | `Tensor Integer Compare Not Equal (Tensor-Immediate)`                                            |
| `rv_y`        | `ymsne_yy`             | `ym, ys2, ys1, yd`   | `Tensor Integer Compare Not Equal (Tensor-Tensor)`                                               |
| `rv_y`        | `ymsne_yx`             | `ym, ys2, rs1, yd`   | `Tensor Integer Compare Not Equal (Tensor-Scalar)`                                               |
| `rv_y`        | `ymsof_m`              | `ym, ys2, yd`        | `Tensor Mask Set Only First`                                                                     |
| `rv_y`        | `ymulhsu_yy`           | `ym, ys2, ys1, yd`   | `Tensor Integer Multiply High Signed-Unsigned (Tensor-Tensor)`                                   |
| `rv_y`        | `ymulhsu_yx`           | `ym, ys2, rs1, yd`   | `Tensor Integer Multiply High Signed-Unsigned (Tensor-Scalar)`                                   |
| `rv_y`        | `ymulhu_yy`            | `ym, ys2, ys1, yd`   | `Tensor Integer Multiply High Unsigned (Tensor-Tensor)`                                          |
| `rv_y`        | `ymulhu_yx`            | `ym, ys2, rs1, yd`   | `Tensor Integer Multiply High Unsigned (Tensor-Scalar)`                                          |
| `rv_y`        | `ymulh_yy`             | `ym, ys2, ys1, yd`   | `Tensor Integer Multiply High Signed (Tensor-Tensor)`                                            |
| `rv_y`        | `ymulh_yx`             | `ym, ys2, rs1, yd`   | `Tensor Integer Multiply High Signed (Tensor-Scalar)`                                            |
| `rv_y`        | `ymul_yy`              | `ym, ys2, ys1, yd`   | `Tensor Integer Multiply Signed (Tensor-Tensor)`                                                 |
| `rv_y`        | `ymul_yx`              | `ym, ys2, rs1, yd`   | `Tensor Integer Multiply Signed (Tensor-Scalar)`                                                 |
| `rv_y`        | `ymv1r_y`              | `ys2, yd`            | `Tensor Move 1 Whole Register`                                                                   |
| `rv_y`        | `ymv2r_y`              | `ys2, yd`            | `Tensor Move 2 Whole Registers`                                                                  |
| `rv_y`        | `ymv4r_y`              | `ys2, yd`            | `Tensor Move 4 Whole Registers`                                                                  |
| `rv_y`        | `ymv8r_y`              | `ys2, yd`            | `Tensor Move 8 Whole Registers`                                                                  |
| `rv_y`        | `ymv_s_x`              | `rs1, yd`            | `Tensor Move Integer Scalar to Tensor Element`                                                   |
| `rv_y`        | `ymv_y_i`              | `simm5, yd`          | `Tensor Broadcast Signed Immediate`                                                              |
| `rv_y`        | `ymv_y_y`              | `ys1, yd`            | `Tensor Move Tensor Elements`                                                                    |
| `rv_y`        | `ymv_y_x`              | `rs1, yd`            | `Tensor Broadcast Integer Scalar`                                                                |
| `rv_y`        | `ymv_x_s`              | `ys2, rd`            | `Tensor Move Tensor Element to Integer Scalar`                                                   |
| `rv_y`        | `ymxnor_mm`            | `ys2, ys1, yd`       | `Tensor Mask XNOR`                                                                               |
| `rv_y`        | `ymxor_mm`             | `ys2, ys1, yd`       | `Tensor Mask XOR`                                                                                |
| `rv_y`        | `ynclipu_wide_yi`      | `ym, ys2, zimm5, yd` | `Tensor Narrowing Clip Unsigned (Wide Tensor-Immediate)`                                         |
| `rv_y`        | `ynclipu_wide_yy`      | `ym, ys2, ys1, yd`   | `Tensor Narrowing Clip Unsigned (Wide Tensor-Tensor)`                                            |
| `rv_y`        | `ynclipu_wide_yx`      | `ym, ys2, rs1, yd`   | `Tensor Narrowing Clip Unsigned (Wide Tensor-Scalar)`                                            |
| `rv_y`        | `ynclip_wide_yi`       | `ym, ys2, zimm5, yd` | `Tensor Narrowing Clip Signed (Wide Tensor-Immediate)`                                           |
| `rv_y`        | `ynclip_wide_yy`       | `ym, ys2, ys1, yd`   | `Tensor Narrowing Clip Signed (Wide Tensor-Tensor)`                                              |
| `rv_y`        | `ynclip_wide_yx`       | `ym, ys2, rs1, yd`   | `Tensor Narrowing Clip Signed (Wide Tensor-Scalar)`                                              |
| `rv_y`        | `ynmsac_yy`            | `ym, ys2, ys1, yd`   | `Tensor Integer Negative Multiply-Subtract from Accumulator (Tensor-Tensor)`                     |
| `rv_y`        | `ynmsac_yx`            | `ym, ys2, rs1, yd`   | `Tensor Integer Negative Multiply-Subtract from Accumulator (Tensor-Scalar)`                     |
| `rv_y`        | `ynmsub_yy`            | `ym, ys2, ys1, yd`   | `Tensor Integer Negative Multiply-Subtract, Overwrite Multiplicand (Tensor-Tensor)`              |
| `rv_y`        | `ynmsub_yx`            | `ym, ys2, rs1, yd`   | `Tensor Integer Negative Multiply-Subtract, Overwrite Multiplicand (Tensor-Scalar)`              |
| `rv_y`        | `ynsra_wide_yi`        | `ym, ys2, zimm5, yd` | `Tensor Narrowing Shift Right Arithmetic (Wide Tensor-Immediate)`                                |
| `rv_y`        | `ynsra_wide_yy`        | `ym, ys2, ys1, yd`   | `Tensor Narrowing Shift Right Arithmetic (Wide Tensor-Tensor)`                                   |
| `rv_y`        | `ynsra_wide_yx`        | `ym, ys2, rs1, yd`   | `Tensor Narrowing Shift Right Arithmetic (Wide Tensor-Scalar)`                                   |
| `rv_y`        | `ynsrl_wide_yi`        | `ym, ys2, zimm5, yd` | `Tensor Narrowing Shift Right Logical (Wide Tensor-Immediate)`                                   |
| `rv_y`        | `ynsrl_wide_yy`        | `ym, ys2, ys1, yd`   | `Tensor Narrowing Shift Right Logical (Wide Tensor-Tensor)`                                      |
| `rv_y`        | `ynsrl_wide_yx`        | `ym, ys2, rs1, yd`   | `Tensor Narrowing Shift Right Logical (Wide Tensor-Scalar)`                                      |
| `rv_y`        | `yor_yi`               | `ym, ys2, simm5, yd` | `Tensor Bitwise OR (Tensor-Immediate)`                                                           |
| `rv_y`        | `yor_yy`               | `ym, ys2, ys1, yd`   | `Tensor Bitwise OR (Tensor-Tensor)`                                                              |
| `rv_y`        | `yor_yx`               | `ym, ys2, rs1, yd`   | `Tensor Bitwise OR (Tensor-Scalar)`                                                              |
| `rv_y`        | `yredand_ys`           | `ym, ys2, ys1, yd`   | `Tensor Integer AND Reduction`                                                                   |
| `rv_y`        | `yredmaxu_ys`          | `ym, ys2, ys1, yd`   | `Tensor Integer Maximum Unsigned Reduction`                                                      |
| `rv_y`        | `yredmax_ys`           | `ym, ys2, ys1, yd`   | `Tensor Integer Maximum Signed Reduction`                                                        |
| `rv_y`        | `yredminu_ys`          | `ym, ys2, ys1, yd`   | `Tensor Integer Minimum Unsigned Reduction`                                                      |
| `rv_y`        | `yredmin_ys`           | `ym, ys2, ys1, yd`   | `Tensor Integer Minimum Signed Reduction`                                                        |
| `rv_y`        | `yredor_ys`            | `ym, ys2, ys1, yd`   | `Tensor Integer OR Reduction`                                                                    |
| `rv_y`        | `yredsum_ys`           | `ym, ys2, ys1, yd`   | `Tensor Integer Sum Reduction`                                                                   |
| `rv_y`        | `yredxor_ys`           | `ym, ys2, ys1, yd`   | `Tensor Integer XOR Reduction`                                                                   |
| `rv_y`        | `yremu_yy`             | `ym, ys2, ys1, yd`   | `Tensor Integer Remainder Unsigned (Tensor-Tensor)`                                              |
| `rv_y`        | `yremu_yx`             | `ym, ys2, rs1, yd`   | `Tensor Integer Remainder Unsigned (Tensor-Scalar)`                                              |
| `rv_y`        | `yrem_yy`              | `ym, ys2, ys1, yd`   | `Tensor Integer Remainder Signed (Tensor-Tensor)`                                                |
| `rv_y`        | `yrem_yx`              | `ym, ys2, rs1, yd`   | `Tensor Integer Remainder Signed (Tensor-Scalar)`                                                |
| `rv_y`        | `yrgatherei16_yy`      | `ym, ys2, ys1, yd`   | `Tensor Register Gather with 16-Bit Element Indices (Tensor-Tensor)`                             |
| `rv_y`        | `yrgather_yi`          | `ym, ys2, zimm5, yd` | `Tensor Register Gather (Tensor-Immediate)`                                                      |
| `rv_y`        | `yrgather_yy`          | `ym, ys2, ys1, yd`   | `Tensor Register Gather (Tensor-Tensor)`                                                         |
| `rv_y`        | `yrgather_yx`          | `ym, ys2, rs1, yd`   | `Tensor Register Gather (Tensor-Scalar)`                                                         |
| `rv_y`        | `yrsub_yi`             | `ym, ys2, simm5, yd` | `Tensor Integer Reverse Subtract (Tensor-Immediate)`                                             |
| `rv_y`        | `yrsub_yx`             | `ym, ys2, rs1, yd`   | `Tensor Integer Reverse Subtract (Tensor-Scalar)`                                                |
| `rv_y`        | `ys1r_y`               | `rs1, ys3`           | `Tensor Store 1 Whole Register`                                                                  |
| `rv_y`        | `ys2r_y`               | `rs1, ys3`           | `Tensor Store 2 Whole Registers`                                                                 |
| `rv_y`        | `ys4r_y`               | `rs1, ys3`           | `Tensor Store 4 Whole Registers`                                                                 |
| `rv_y`        | `ys8r_y`               | `rs1, ys3`           | `Tensor Store 8 Whole Registers`                                                                 |
| `rv_y`        | `ysaddu_yi`            | `ym, ys2, simm5, yd` | `Tensor Integer Saturating Add Unsigned (Tensor-Immediate)`                                      |
| `rv_y`        | `ysaddu_yy`            | `ym, ys2, ys1, yd`   | `Tensor Integer Saturating Add Unsigned (Tensor-Tensor)`                                         |
| `rv_y`        | `ysaddu_yx`            | `ym, ys2, rs1, yd`   | `Tensor Integer Saturating Add Unsigned (Tensor-Scalar)`                                         |
| `rv_y`        | `ysadd_yi`             | `ym, ys2, simm5, yd` | `Tensor Integer Saturating Add Signed (Tensor-Immediate)`                                        |
| `rv_y`        | `ysadd_yy`             | `ym, ys2, ys1, yd`   | `Tensor Integer Saturating Add Signed (Tensor-Tensor)`                                           |
| `rv_y`        | `ysadd_yx`             | `ym, ys2, rs1, yd`   | `Tensor Integer Saturating Add Signed (Tensor-Scalar)`                                           |
| `rv_y`        | `ysbc_yym`             | `ys2, ys1, yd`       | `Tensor Integer Subtract with Borrow (Tensor-Tensor with Mask Borrow Input)`                     |
| `rv_y`        | `ysbc_yxm`             | `ys2, rs1, yd`       | `Tensor Integer Subtract with Borrow (Tensor-Scalar with Mask Borrow Input)`                     |
| `rv_y`        | `yse16_y`              | `ym, rs1, ys3`       | `Tensor Unit-Stride Store with 16-Bit Elements`                                                  |
| `rv_y`        | `yse32_y`              | `ym, rs1, ys3`       | `Tensor Unit-Stride Store with 32-Bit Elements`                                                  |
| `rv_y`        | `yse64_y`              | `ym, rs1, ys3`       | `Tensor Unit-Stride Store with 64-Bit Elements`                                                  |
| `rv_y`        | `yse8_y`               | `ym, rs1, ys3`       | `Tensor Unit-Stride Store with 8-Bit Elements`                                                   |
| `rv_y`        | `ysetiyli`             | `zimm10, zimm5, rd`  | `Set Tensor Length and Immediate Tensor Type with Immediate AVL`                                 |
| `rv_y`        | `ysetyl`               | `rs2, rs1, rd`       | `Set Tensor Length and Register Tensor Type`                                                     |
| `rv_y`        | `ysetyli`              | `zimm11, rs1, rd`    | `Set Tensor Length and Immediate Tensor Type`                                                    |
| `rv_y`        | `ysext_yf2`            | `ym, ys2, yd`        | `Tensor Sign-Extend by Factor 2`                                                                 |
| `rv_y`        | `ysext_yf4`            | `ym, ys2, yd`        | `Tensor Sign-Extend by Factor 4`                                                                 |
| `rv_y`        | `ysext_yf8`            | `ym, ys2, yd`        | `Tensor Sign-Extend by Factor 8`                                                                 |
| `rv_y`        | `yslide1down_yx`       | `ym, ys2, rs1, yd`   | `Tensor Slide One Down (Tensor-Scalar)`                                                          |
| `rv_y`        | `yslide1up_yx`         | `ym, ys2, rs1, yd`   | `Tensor Slide One Up (Tensor-Scalar)`                                                            |
| `rv_y`        | `yslidedown_yi`        | `ym, ys2, zimm5, yd` | `Tensor Slide Down (Tensor-Immediate)`                                                           |
| `rv_y`        | `yslidedown_yx`        | `ym, ys2, rs1, yd`   | `Tensor Slide Down (Tensor-Scalar)`                                                              |
| `rv_y`        | `yslideup_yi`          | `ym, ys2, zimm5, yd` | `Tensor Slide Up (Tensor-Immediate)`                                                             |
| `rv_y`        | `yslideup_yx`          | `ym, ys2, rs1, yd`   | `Tensor Slide Up (Tensor-Scalar)`                                                                |
| `rv_y`        | `ysll_yi`              | `ym, ys2, zimm5, yd` | `Tensor Shift Left Logical (Tensor-Immediate)`                                                   |
| `rv_y`        | `ysll_yy`              | `ym, ys2, ys1, yd`   | `Tensor Shift Left Logical (Tensor-Tensor)`                                                      |
| `rv_y`        | `ysll_yx`              | `ym, ys2, rs1, yd`   | `Tensor Shift Left Logical (Tensor-Scalar)`                                                      |
| `rv_y`        | `ysmul_yy`             | `ym, ys2, ys1, yd`   | `Tensor Signed Fractional Multiply with Rounding and Saturation (Tensor-Tensor)`                 |
| `rv_y`        | `ysmul_yx`             | `ym, ys2, rs1, yd`   | `Tensor Signed Fractional Multiply with Rounding and Saturation (Tensor-Scalar)`                 |
| `rv_y`        | `ysm_y`                | `rs1, ys3`           | `Tensor Mask Store`                                                                              |
| `rv_y`        | `ysoxei16_y`           | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Store with 16-Bit Indices`                                               |
| `rv_y`        | `ysoxei32_y`           | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Store with 32-Bit Indices`                                               |
| `rv_y`        | `ysoxei64_y`           | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Store with 64-Bit Indices`                                               |
| `rv_y`        | `ysoxei8_y`            | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Store with 8-Bit Indices`                                                |
| `rv_y`        | `ysoxseg2ei16_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 2 Fields with 16-Bit Indices`                           |
| `rv_y`        | `ysoxseg2ei32_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 2 Fields with 32-Bit Indices`                           |
| `rv_y`        | `ysoxseg2ei64_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 2 Fields with 64-Bit Indices`                           |
| `rv_y`        | `ysoxseg2ei8_y`        | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 2 Fields with 8-Bit Indices`                            |
| `rv_y`        | `ysoxseg3ei16_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 3 Fields with 16-Bit Indices`                           |
| `rv_y`        | `ysoxseg3ei32_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 3 Fields with 32-Bit Indices`                           |
| `rv_y`        | `ysoxseg3ei64_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 3 Fields with 64-Bit Indices`                           |
| `rv_y`        | `ysoxseg3ei8_y`        | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 3 Fields with 8-Bit Indices`                            |
| `rv_y`        | `ysoxseg4ei16_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 4 Fields with 16-Bit Indices`                           |
| `rv_y`        | `ysoxseg4ei32_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 4 Fields with 32-Bit Indices`                           |
| `rv_y`        | `ysoxseg4ei64_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 4 Fields with 64-Bit Indices`                           |
| `rv_y`        | `ysoxseg4ei8_y`        | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 4 Fields with 8-Bit Indices`                            |
| `rv_y`        | `ysoxseg5ei16_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 5 Fields with 16-Bit Indices`                           |
| `rv_y`        | `ysoxseg5ei32_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 5 Fields with 32-Bit Indices`                           |
| `rv_y`        | `ysoxseg5ei64_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 5 Fields with 64-Bit Indices`                           |
| `rv_y`        | `ysoxseg5ei8_y`        | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 5 Fields with 8-Bit Indices`                            |
| `rv_y`        | `ysoxseg6ei16_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 6 Fields with 16-Bit Indices`                           |
| `rv_y`        | `ysoxseg6ei32_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 6 Fields with 32-Bit Indices`                           |
| `rv_y`        | `ysoxseg6ei64_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 6 Fields with 64-Bit Indices`                           |
| `rv_y`        | `ysoxseg6ei8_y`        | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 6 Fields with 8-Bit Indices`                            |
| `rv_y`        | `ysoxseg7ei16_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 7 Fields with 16-Bit Indices`                           |
| `rv_y`        | `ysoxseg7ei32_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 7 Fields with 32-Bit Indices`                           |
| `rv_y`        | `ysoxseg7ei64_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 7 Fields with 64-Bit Indices`                           |
| `rv_y`        | `ysoxseg7ei8_y`        | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 7 Fields with 8-Bit Indices`                            |
| `rv_y`        | `ysoxseg8ei16_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 8 Fields with 16-Bit Indices`                           |
| `rv_y`        | `ysoxseg8ei32_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 8 Fields with 32-Bit Indices`                           |
| `rv_y`        | `ysoxseg8ei64_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 8 Fields with 64-Bit Indices`                           |
| `rv_y`        | `ysoxseg8ei8_y`        | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Ordered Segment Store of 8 Fields with 8-Bit Indices`                            |
| `rv_y`        | `ysra_yi`              | `ym, ys2, zimm5, yd` | `Tensor Shift Right Arithmetic (Tensor-Immediate)`                                               |
| `rv_y`        | `ysra_yy`              | `ym, ys2, ys1, yd`   | `Tensor Shift Right Arithmetic (Tensor-Tensor)`                                                  |
| `rv_y`        | `ysra_yx`              | `ym, ys2, rs1, yd`   | `Tensor Shift Right Arithmetic (Tensor-Scalar)`                                                  |
| `rv_y`        | `ysrl_yi`              | `ym, ys2, zimm5, yd` | `Tensor Shift Right Logical (Tensor-Immediate)`                                                  |
| `rv_y`        | `ysrl_yy`              | `ym, ys2, ys1, yd`   | `Tensor Shift Right Logical (Tensor-Tensor)`                                                     |
| `rv_y`        | `ysrl_yx`              | `ym, ys2, rs1, yd`   | `Tensor Shift Right Logical (Tensor-Scalar)`                                                     |
| `rv_y`        | `ysse16_y`             | `ym, rs2, rs1, ys3`  | `Tensor Strided Store with 16-Bit Elements`                                                      |
| `rv_y`        | `ysse32_y`             | `ym, rs2, rs1, ys3`  | `Tensor Strided Store with 32-Bit Elements`                                                      |
| `rv_y`        | `ysse64_y`             | `ym, rs2, rs1, ys3`  | `Tensor Strided Store with 64-Bit Elements`                                                      |
| `rv_y`        | `ysse8_y`              | `ym, rs2, rs1, ys3`  | `Tensor Strided Store with 8-Bit Elements`                                                       |
| `rv_y`        | `ysseg2e16_y`          | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 2 Fields with 16-Bit Elements`                              |
| `rv_y`        | `ysseg2e32_y`          | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 2 Fields with 32-Bit Elements`                              |
| `rv_y`        | `ysseg2e64_y`          | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 2 Fields with 64-Bit Elements`                              |
| `rv_y`        | `ysseg2e8_y`           | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 2 Fields with 8-Bit Elements`                               |
| `rv_y`        | `ysseg3e16_y`          | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 3 Fields with 16-Bit Elements`                              |
| `rv_y`        | `ysseg3e32_y`          | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 3 Fields with 32-Bit Elements`                              |
| `rv_y`        | `ysseg3e64_y`          | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 3 Fields with 64-Bit Elements`                              |
| `rv_y`        | `ysseg3e8_y`           | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 3 Fields with 8-Bit Elements`                               |
| `rv_y`        | `ysseg4e16_y`          | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 4 Fields with 16-Bit Elements`                              |
| `rv_y`        | `ysseg4e32_y`          | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 4 Fields with 32-Bit Elements`                              |
| `rv_y`        | `ysseg4e64_y`          | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 4 Fields with 64-Bit Elements`                              |
| `rv_y`        | `ysseg4e8_y`           | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 4 Fields with 8-Bit Elements`                               |
| `rv_y`        | `ysseg5e16_y`          | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 5 Fields with 16-Bit Elements`                              |
| `rv_y`        | `ysseg5e32_y`          | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 5 Fields with 32-Bit Elements`                              |
| `rv_y`        | `ysseg5e64_y`          | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 5 Fields with 64-Bit Elements`                              |
| `rv_y`        | `ysseg5e8_y`           | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 5 Fields with 8-Bit Elements`                               |
| `rv_y`        | `ysseg6e16_y`          | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 6 Fields with 16-Bit Elements`                              |
| `rv_y`        | `ysseg6e32_y`          | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 6 Fields with 32-Bit Elements`                              |
| `rv_y`        | `ysseg6e64_y`          | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 6 Fields with 64-Bit Elements`                              |
| `rv_y`        | `ysseg6e8_y`           | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 6 Fields with 8-Bit Elements`                               |
| `rv_y`        | `ysseg7e16_y`          | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 7 Fields with 16-Bit Elements`                              |
| `rv_y`        | `ysseg7e32_y`          | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 7 Fields with 32-Bit Elements`                              |
| `rv_y`        | `ysseg7e64_y`          | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 7 Fields with 64-Bit Elements`                              |
| `rv_y`        | `ysseg7e8_y`           | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 7 Fields with 8-Bit Elements`                               |
| `rv_y`        | `ysseg8e16_y`          | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 8 Fields with 16-Bit Elements`                              |
| `rv_y`        | `ysseg8e32_y`          | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 8 Fields with 32-Bit Elements`                              |
| `rv_y`        | `ysseg8e64_y`          | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 8 Fields with 64-Bit Elements`                              |
| `rv_y`        | `ysseg8e8_y`           | `ym, rs1, ys3`       | `Tensor Unit-Stride Segment Store of 8 Fields with 8-Bit Elements`                               |
| `rv_y`        | `yssra_yi`             | `ym, ys2, zimm5, yd` | `Tensor Scaling Shift Right Signed (Tensor-Immediate)`                                           |
| `rv_y`        | `yssra_yy`             | `ym, ys2, ys1, yd`   | `Tensor Scaling Shift Right Signed (Tensor-Tensor)`                                              |
| `rv_y`        | `yssra_yx`             | `ym, ys2, rs1, yd`   | `Tensor Scaling Shift Right Signed (Tensor-Scalar)`                                              |
| `rv_y`        | `yssrl_yi`             | `ym, ys2, zimm5, yd` | `Tensor Scaling Shift Right Unsigned (Tensor-Immediate)`                                         |
| `rv_y`        | `yssrl_yy`             | `ym, ys2, ys1, yd`   | `Tensor Scaling Shift Right Unsigned (Tensor-Tensor)`                                            |
| `rv_y`        | `yssrl_yx`             | `ym, ys2, rs1, yd`   | `Tensor Scaling Shift Right Unsigned (Tensor-Scalar)`                                            |
| `rv_y`        | `yssseg2e16_y`         | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 2 Fields with 16-Bit Elements`                                  |
| `rv_y`        | `yssseg2e32_y`         | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 2 Fields with 32-Bit Elements`                                  |
| `rv_y`        | `yssseg2e64_y`         | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 2 Fields with 64-Bit Elements`                                  |
| `rv_y`        | `yssseg2e8_y`          | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 2 Fields with 8-Bit Elements`                                   |
| `rv_y`        | `yssseg3e16_y`         | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 3 Fields with 16-Bit Elements`                                  |
| `rv_y`        | `yssseg3e32_y`         | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 3 Fields with 32-Bit Elements`                                  |
| `rv_y`        | `yssseg3e64_y`         | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 3 Fields with 64-Bit Elements`                                  |
| `rv_y`        | `yssseg3e8_y`          | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 3 Fields with 8-Bit Elements`                                   |
| `rv_y`        | `yssseg4e16_y`         | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 4 Fields with 16-Bit Elements`                                  |
| `rv_y`        | `yssseg4e32_y`         | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 4 Fields with 32-Bit Elements`                                  |
| `rv_y`        | `yssseg4e64_y`         | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 4 Fields with 64-Bit Elements`                                  |
| `rv_y`        | `yssseg4e8_y`          | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 4 Fields with 8-Bit Elements`                                   |
| `rv_y`        | `yssseg5e16_y`         | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 5 Fields with 16-Bit Elements`                                  |
| `rv_y`        | `yssseg5e32_y`         | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 5 Fields with 32-Bit Elements`                                  |
| `rv_y`        | `yssseg5e64_y`         | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 5 Fields with 64-Bit Elements`                                  |
| `rv_y`        | `yssseg5e8_y`          | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 5 Fields with 8-Bit Elements`                                   |
| `rv_y`        | `yssseg6e16_y`         | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 6 Fields with 16-Bit Elements`                                  |
| `rv_y`        | `yssseg6e32_y`         | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 6 Fields with 32-Bit Elements`                                  |
| `rv_y`        | `yssseg6e64_y`         | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 6 Fields with 64-Bit Elements`                                  |
| `rv_y`        | `yssseg6e8_y`          | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 6 Fields with 8-Bit Elements`                                   |
| `rv_y`        | `yssseg7e16_y`         | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 7 Fields with 16-Bit Elements`                                  |
| `rv_y`        | `yssseg7e32_y`         | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 7 Fields with 32-Bit Elements`                                  |
| `rv_y`        | `yssseg7e64_y`         | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 7 Fields with 64-Bit Elements`                                  |
| `rv_y`        | `yssseg7e8_y`          | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 7 Fields with 8-Bit Elements`                                   |
| `rv_y`        | `yssseg8e16_y`         | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 8 Fields with 16-Bit Elements`                                  |
| `rv_y`        | `yssseg8e32_y`         | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 8 Fields with 32-Bit Elements`                                  |
| `rv_y`        | `yssseg8e64_y`         | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 8 Fields with 64-Bit Elements`                                  |
| `rv_y`        | `yssseg8e8_y`          | `ym, rs2, rs1, ys3`  | `Tensor Strided Segment Store of 8 Fields with 8-Bit Elements`                                   |
| `rv_y`        | `yssubu_yy`            | `ym, ys2, ys1, yd`   | `Tensor Integer Saturating Subtract Unsigned (Tensor-Tensor)`                                    |
| `rv_y`        | `yssubu_yx`            | `ym, ys2, rs1, yd`   | `Tensor Integer Saturating Subtract Unsigned (Tensor-Scalar)`                                    |
| `rv_y`        | `yssub_yy`             | `ym, ys2, ys1, yd`   | `Tensor Integer Saturating Subtract Signed (Tensor-Tensor)`                                      |
| `rv_y`        | `yssub_yx`             | `ym, ys2, rs1, yd`   | `Tensor Integer Saturating Subtract Signed (Tensor-Scalar)`                                      |
| `rv_y`        | `ysub_yy`              | `ym, ys2, ys1, yd`   | `Tensor Integer Subtract (Tensor-Tensor)`                                                        |
| `rv_y`        | `ysub_yx`              | `ym, ys2, rs1, yd`   | `Tensor Integer Subtract (Tensor-Scalar)`                                                        |
| `rv_y`        | `ysuxei16_y`           | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Store with 16-Bit Indices`                                             |
| `rv_y`        | `ysuxei32_y`           | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Store with 32-Bit Indices`                                             |
| `rv_y`        | `ysuxei64_y`           | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Store with 64-Bit Indices`                                             |
| `rv_y`        | `ysuxei8_y`            | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Store with 8-Bit Indices`                                              |
| `rv_y`        | `ysuxseg2ei16_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 2 Fields with 16-Bit Indices`                         |
| `rv_y`        | `ysuxseg2ei32_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 2 Fields with 32-Bit Indices`                         |
| `rv_y`        | `ysuxseg2ei64_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 2 Fields with 64-Bit Indices`                         |
| `rv_y`        | `ysuxseg2ei8_y`        | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 2 Fields with 8-Bit Indices`                          |
| `rv_y`        | `ysuxseg3ei16_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 3 Fields with 16-Bit Indices`                         |
| `rv_y`        | `ysuxseg3ei32_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 3 Fields with 32-Bit Indices`                         |
| `rv_y`        | `ysuxseg3ei64_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 3 Fields with 64-Bit Indices`                         |
| `rv_y`        | `ysuxseg3ei8_y`        | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 3 Fields with 8-Bit Indices`                          |
| `rv_y`        | `ysuxseg4ei16_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 4 Fields with 16-Bit Indices`                         |
| `rv_y`        | `ysuxseg4ei32_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 4 Fields with 32-Bit Indices`                         |
| `rv_y`        | `ysuxseg4ei64_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 4 Fields with 64-Bit Indices`                         |
| `rv_y`        | `ysuxseg4ei8_y`        | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 4 Fields with 8-Bit Indices`                          |
| `rv_y`        | `ysuxseg5ei16_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 5 Fields with 16-Bit Indices`                         |
| `rv_y`        | `ysuxseg5ei32_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 5 Fields with 32-Bit Indices`                         |
| `rv_y`        | `ysuxseg5ei64_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 5 Fields with 64-Bit Indices`                         |
| `rv_y`        | `ysuxseg5ei8_y`        | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 5 Fields with 8-Bit Indices`                          |
| `rv_y`        | `ysuxseg6ei16_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 6 Fields with 16-Bit Indices`                         |
| `rv_y`        | `ysuxseg6ei32_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 6 Fields with 32-Bit Indices`                         |
| `rv_y`        | `ysuxseg6ei64_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 6 Fields with 64-Bit Indices`                         |
| `rv_y`        | `ysuxseg6ei8_y`        | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 6 Fields with 8-Bit Indices`                          |
| `rv_y`        | `ysuxseg7ei16_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 7 Fields with 16-Bit Indices`                         |
| `rv_y`        | `ysuxseg7ei32_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 7 Fields with 32-Bit Indices`                         |
| `rv_y`        | `ysuxseg7ei64_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 7 Fields with 64-Bit Indices`                         |
| `rv_y`        | `ysuxseg7ei8_y`        | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 7 Fields with 8-Bit Indices`                          |
| `rv_y`        | `ysuxseg8ei16_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 8 Fields with 16-Bit Indices`                         |
| `rv_y`        | `ysuxseg8ei32_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 8 Fields with 32-Bit Indices`                         |
| `rv_y`        | `ysuxseg8ei64_y`       | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 8 Fields with 64-Bit Indices`                         |
| `rv_y`        | `ysuxseg8ei8_y`        | `ym, ys2, rs1, ys3`  | `Tensor Indexed-Unordered Segment Store of 8 Fields with 8-Bit Indices`                          |
| `rv_y`        | `ywaddu_yy`            | `ym, ys2, ys1, yd`   | `Tensor Widening Integer Add Unsigned (Tensor-Tensor)`                                           |
| `rv_y`        | `ywaddu_yx`            | `ym, ys2, rs1, yd`   | `Tensor Widening Integer Add Unsigned (Tensor-Scalar)`                                           |
| `rv_y`        | `ywaddu_wide_yy`       | `ym, ys2, ys1, yd`   | `Tensor Widening Integer Add Unsigned (Wide Tensor-Tensor)`                                      |
| `rv_y`        | `ywaddu_wide_yx`       | `ym, ys2, rs1, yd`   | `Tensor Widening Integer Add Unsigned (Wide Tensor-Scalar)`                                      |
| `rv_y`        | `ywadd_yy`             | `ym, ys2, ys1, yd`   | `Tensor Widening Integer Add Signed (Tensor-Tensor)`                                             |
| `rv_y`        | `ywadd_yx`             | `ym, ys2, rs1, yd`   | `Tensor Widening Integer Add Signed (Tensor-Scalar)`                                             |
| `rv_y`        | `ywadd_wide_yy`        | `ym, ys2, ys1, yd`   | `Tensor Widening Integer Add Signed (Wide Tensor-Tensor)`                                        |
| `rv_y`        | `ywadd_wide_yx`        | `ym, ys2, rs1, yd`   | `Tensor Widening Integer Add Signed (Wide Tensor-Scalar)`                                        |
| `rv_y`        | `ywmaccsu_yy`          | `ym, ys2, ys1, yd`   | `Tensor Widening Signed-Unsigned Integer Multiply-Accumulate (Tensor-Tensor)`                    |
| `rv_y`        | `ywmaccsu_yx`          | `ym, ys2, rs1, yd`   | `Tensor Widening Signed-Unsigned Integer Multiply-Accumulate (Tensor-Scalar)`                    |
| `rv_y`        | `ywmaccus_yx`          | `ym, ys2, rs1, yd`   | `Tensor Widening Unsigned-Signed Integer Multiply-Accumulate (Tensor-Scalar)`                    |
| `rv_y`        | `ywmaccu_yy`           | `ym, ys2, ys1, yd`   | `Tensor Widening Unsigned Integer Multiply-Accumulate (Tensor-Tensor)`                           |
| `rv_y`        | `ywmaccu_yx`           | `ym, ys2, rs1, yd`   | `Tensor Widening Unsigned Integer Multiply-Accumulate (Tensor-Scalar)`                           |
| `rv_y`        | `ywmacc_yy`            | `ym, ys2, ys1, yd`   | `Tensor Widening Signed Integer Multiply-Accumulate (Tensor-Tensor)`                             |
| `rv_y`        | `ywmacc_yx`            | `ym, ys2, rs1, yd`   | `Tensor Widening Signed Integer Multiply-Accumulate (Tensor-Scalar)`                             |
| `rv_y`        | `ywmulsu_yy`           | `ym, ys2, ys1, yd`   | `Tensor Widening Integer Multiply Signed-Unsigned (Tensor-Tensor)`                               |
| `rv_y`        | `ywmulsu_yx`           | `ym, ys2, rs1, yd`   | `Tensor Widening Integer Multiply Signed-Unsigned (Tensor-Scalar)`                               |
| `rv_y`        | `ywmulu_yy`            | `ym, ys2, ys1, yd`   | `Tensor Widening Integer Multiply Unsigned (Tensor-Tensor)`                                      |
| `rv_y`        | `ywmulu_yx`            | `ym, ys2, rs1, yd`   | `Tensor Widening Integer Multiply Unsigned (Tensor-Scalar)`                                      |
| `rv_y`        | `ywmul_yy`             | `ym, ys2, ys1, yd`   | `Tensor Widening Integer Multiply Signed (Tensor-Tensor)`                                        |
| `rv_y`        | `ywmul_yx`             | `ym, ys2, rs1, yd`   | `Tensor Widening Integer Multiply Signed (Tensor-Scalar)`                                        |
| `rv_y`        | `ywredsumu_ys`         | `ym, ys2, ys1, yd`   | `Tensor Widening Integer Sum Unsigned Reduction`                                                 |
| `rv_y`        | `ywredsum_ys`          | `ym, ys2, ys1, yd`   | `Tensor Widening Integer Sum Reduction`                                                          |
| `rv_y`        | `ywsubu_yy`            | `ym, ys2, ys1, yd`   | `Tensor Widening Integer Subtract Unsigned (Tensor-Tensor)`                                      |
| `rv_y`        | `ywsubu_yx`            | `ym, ys2, rs1, yd`   | `Tensor Widening Integer Subtract Unsigned (Tensor-Scalar)`                                      |
| `rv_y`        | `ywsubu_wide_yy`       | `ym, ys2, ys1, yd`   | `Tensor Widening Integer Subtract Unsigned (Wide Tensor-Tensor)`                                 |
| `rv_y`        | `ywsubu_wide_yx`       | `ym, ys2, rs1, yd`   | `Tensor Widening Integer Subtract Unsigned (Wide Tensor-Scalar)`                                 |
| `rv_y`        | `ywsub_yy`             | `ym, ys2, ys1, yd`   | `Tensor Widening Integer Subtract Signed (Tensor-Tensor)`                                        |
| `rv_y`        | `ywsub_yx`             | `ym, ys2, rs1, yd`   | `Tensor Widening Integer Subtract Signed (Tensor-Scalar)`                                        |
| `rv_y`        | `ywsub_wide_yy`        | `ym, ys2, ys1, yd`   | `Tensor Widening Integer Subtract Signed (Wide Tensor-Tensor)`                                   |
| `rv_y`        | `ywsub_wide_yx`        | `ym, ys2, rs1, yd`   | `Tensor Widening Integer Subtract Signed (Wide Tensor-Scalar)`                                   |
| `rv_y`        | `yxor_yi`              | `ym, ys2, simm5, yd` | `Tensor Bitwise XOR (Tensor-Immediate)`                                                          |
| `rv_y`        | `yxor_yy`              | `ym, ys2, ys1, yd`   | `Tensor Bitwise XOR (Tensor-Tensor)`                                                             |
| `rv_y`        | `yxor_yx`              | `ym, ys2, rs1, yd`   | `Tensor Bitwise XOR (Tensor-Scalar)`                                                             |
| `rv_y`        | `yzext_yf2`            | `ym, ys2, yd`        | `Tensor Zero-Extend by Factor 2`                                                                 |
| `rv_y`        | `yzext_yf4`            | `ym, ys2, yd`        | `Tensor Zero-Extend by Factor 4`                                                                 |
| `rv_y`        | `yzext_yf8`            | `ym, ys2, yd`        | `Tensor Zero-Extend by Factor 8`                                                                 |

:RVY - Specific Extension for Tensor Operations

| **Extension**      | **Name**                  | **Variable-Fields**             | **Full-Name**                                                                      |
|:-------------------|:--------------------------|:--------------------------------|:-----------------------------------------------------------------------------------|
| `rv_zyabd`         | `yabdu_yy`                | `ym, ys2, ys1, yd`              | `Tensor Unsigned Absolute Difference (Tensor-Tensor)`                              |
| `rv_zyabd`         | `yabdu_yx`                | `ym, ys2, rs1, yd`              | `Tensor Unsigned Absolute Difference (Tensor-Scalar)`                              |
| `rv_zyabd`         | `yabd_yy`                 | `ym, ys2, ys1, yd`              | `Tensor Signed Absolute Difference (Tensor-Tensor)`                                |
| `rv_zyabd`         | `yabd_yx`                 | `ym, ys2, rs1, yd`              | `Tensor Signed Absolute Difference (Tensor-Scalar)`                                |
| `rv_zyabd`         | `ywabdau_yy`              | `ym, ys2, ys1, yd`              | `Tensor Widening Unsigned Absolute Difference Accumulate (Tensor-Tensor)`          |
| `rv_zyabd`         | `ywabdau_yx`              | `ym, ys2, rs1, yd`              | `Tensor Widening Unsigned Absolute Difference Accumulate (Tensor-Scalar)`          |
| `rv_zyabd`         | `ywabda_yy`               | `ym, ys2, ys1, yd`              | `Tensor Widening Signed Absolute Difference Accumulate (Tensor-Tensor)`            |
| `rv_zyabd`         | `ywabda_yx`               | `ym, ys2, rs1, yd`              | `Tensor Widening Signed Absolute Difference Accumulate (Tensor-Scalar)`            |
| `rv_zybb`          | `yandn_yy`                | `ym, ys2, ys1, yd`              | `Tensor And-Not (Tensor-Tensor)`                                                   |
| `rv_zybb`          | `yandn_yx`                | `ym, ys2, rs1, yd`              | `Tensor And-Not (Tensor-Scalar)`                                                   |
| `rv_zybb`          | `ybrev8_y`                | `ym, ys2, yd`                   | `Tensor Reverse Bits in Bytes (Tensor)`                                            |
| `rv_zybb`          | `ybrev_y`                 | `ym, ys2, yd`                   | `Tensor Reverse Bits in Elements (Tensor)`                                         |
| `rv_zybb`          | `yclz_y`                  | `ym, ys2, yd`                   | `Tensor Count Leading Zeros (Tensor)`                                              |
| `rv_zybb`          | `ycpop_y`                 | `ym, ys2, yd`                   | `Tensor Population Count (Tensor)`                                                 |
| `rv_zybb`          | `yctz_y`                  | `ym, ys2, yd`                   | `Tensor Count Trailing Zeros (Tensor)`                                             |
| `rv_zybb`          | `yrev8_y`                 | `ym, ys2, yd`                   | `Tensor Reverse Bytes (Tensor)`                                                    |
| `rv_zybb`          | `yrol_yy`                 | `ym, ys2, ys1, yd`              | `Tensor Rotate Left (Tensor-Tensor)`                                               |
| `rv_zybb`          | `yrol_yx`                 | `ym, ys2, rs1, yd`              | `Tensor Rotate Left (Tensor-Scalar)`                                               |
| `rv_zybb`          | `yror_yi`                 | `zimm6hi, ym, ys2, zimm6lo, yd` | `Tensor Rotate Right (Tensor-Immediate)`                                           |
| `rv_zybb`          | `yror_yy`                 | `ym, ys2, ys1, yd`              | `Tensor Rotate Right (Tensor-Tensor)`                                              |
| `rv_zybb`          | `yror_yx`                 | `ym, ys2, rs1, yd`              | `Tensor Rotate Right (Tensor-Scalar)`                                              |
| `rv_zybb`          | `ywsll_yi`                | `ym, ys2, zimm5, yd`            | `Tensor Widening Shift Left Logical (Tensor-Immediate)`                            |
| `rv_zybb`          | `ywsll_yy`                | `ym, ys2, ys1, yd`              | `Tensor Widening Shift Left Logical (Tensor-Tensor)`                               |
| `rv_zybb`          | `ywsll_yx`                | `ym, ys2, rs1, yd`              | `Tensor Widening Shift Left Logical (Tensor-Scalar)`                               |
| `rv_zybc`          | `yclmulh_yy`              | `ym, ys2, ys1, yd`              | `Tensor Carry-Less Multiply High (Tensor-Tensor)`                                  |
| `rv_zybc`          | `yclmulh_yx`              | `ym, ys2, rs1, yd`              | `Tensor Carry-Less Multiply High (Tensor-Scalar)`                                  |
| `rv_zybc`          | `yclmul_yy`               | `ym, ys2, ys1, yd`              | `Tensor Carry-Less Multiply Low (Tensor-Tensor)`                                   |
| `rv_zybc`          | `yclmul_yx`               | `ym, ys2, rs1, yd`              | `Tensor Carry-Less Multiply Low (Tensor-Scalar)`                                   |
| `rv_zydot4a`       | `ydot4asu_yy`             | `ym, ys2, ys1, yd`              | `Tensor Packed 8-Bit Dot Product Accumulate (Signed × Unsigned) (Tensor-Tensor)`   |
| `rv_zydot4a`       | `ydot4asu_yx`             | `ym, ys2, rs1, yd`              | `Tensor Packed 8-Bit Dot Product Accumulate (Signed × Unsigned) (Tensor-Scalar)`   |
| `rv_zydot4a`       | `ydot4aus_yx`             | `ym, ys2, rs1, yd`              | `Tensor Packed 8-Bit Dot Product Accumulate (Unsigned × Signed) (Tensor-Scalar)`   |
| `rv_zydot4a`       | `ydot4au_yy`              | `ym, ys2, ys1, yd`              | `Tensor Packed 8-Bit Dot Product Accumulate (Unsigned × Unsigned) (Tensor-Tensor)` |
| `rv_zydot4a`       | `ydot4au_yx`              | `ym, ys2, rs1, yd`              | `Tensor Packed 8-Bit Dot Product Accumulate (Unsigned × Unsigned) (Tensor-Scalar)` |
| `rv_zydot4a`       | `ydot4a_yy`               | `ym, ys2, ys1, yd`              | `Tensor Packed 8-Bit Dot Product Accumulate (Signed × Signed) (Tensor-Tensor)`     |
| `rv_zydot4a`       | `ydot4a_yx`               | `ym, ys2, rs1, yd`              | `Tensor Packed 8-Bit Dot Product Accumulate (Signed × Signed) (Tensor-Scalar)`     |
| `rv_zyfbdota32f`   | `yfbdota_yy`              | `ym, ys2x8, ci, ys1, yd`        | `Tensor Batched FP32 Dot Product Accumulate`                                       |
| `rv_zyfbfmin`      | `yfncvtbf16_f_f_wide`     | `ym, ys2, yd`                   | `Tensor FP32 to BF16 Conversion`                                                   |
| `rv_zyfbfmin`      | `yfwcvtbf16_f_f_y`        | `ym, ys2, yd`                   | `Tensor BF16 to FP32 Conversion`                                                   |
| `rv_zyfbfwma`      | `yfwmaccbf16_yf`          | `ym, ys2, rs1, yd`              | `Tensor BF16 Widening Fused Multiply-Accumulate (Tensor-Scalar)`                   |
| `rv_zyfbfwma`      | `yfwmaccbf16_yy`          | `ym, ys2, ys1, yd`              | `Tensor BF16 Widening Fused Multiply-Accumulate (Tensor-Tensor)`                   |
| `rv_zyfofp4min`    | `yfext_yf2`               | `ym, ys2, yd`                   | `Tensor E2M1 to E4M3 Conversion`                                                   |
| `rv_zyfofp8min`    | `yfncvtbf16_sat_f_f_wide` | `ym, ys2, yd`                   | `Tensor BF16 to OFP8 Saturating Conversion`                                        |
| `rv_zyfofp8min`    | `yfncvt_f_f_q`            | `ym, ys2, yd`                   | `Tensor FP32 to OFP8 Conversion`                                                   |
| `rv_zyfofp8min`    | `yfncvt_sat_f_f_q`        | `ym, ys2, yd`                   | `Tensor FP32 to OFP8 Saturating Conversion`                                        |
| `rv_zyfqwbdota8f`  | `yfqwbdota_alt_yy`        | `ym, ys2x8, ci, ys1, yd`        | `Tensor Batched OFP8 Dot Product Accumulate (E5M2 Source 2)`                       |
| `rv_zyfqwbdota8f`  | `yfqwbdota_yy`            | `ym, ys2x8, ci, ys1, yd`        | `Tensor Batched OFP8 Dot Product Accumulate (E4M3 Source 2)`                       |
| `rv_zyfqwdota8f`   | `yfqwdota_alt_yy`         | `ym, ys2, ys1, yd`              | `Tensor Long OFP8 Dot Product Accumulate (E5M2 Source 2)`                          |
| `rv_zyfqwdota8f`   | `yfqwdota_yy`             | `ym, ys2, ys1, yd`              | `Tensor Long OFP8 Dot Product Accumulate (E4M3 Source 2)`                          |
| `rv_zyfwbdota16bf` | `yfwbdota_yy`             | `ym, ys2x8, ci, ys1, yd`        | `Tensor Batched BF16 Dot Product Accumulate`                                       |
| `rv_zyfwdota16bf`  | `yfwdota_yy`              | `ym, ys2, ys1, yd`              | `Tensor Long BF16 Dot Product Accumulate`                                          |
| `rv_zyqwbdota8i`   | `yqwbdotas_yy`            | `ym, ys2x8, ci, ys1, yd`        | `Tensor Batched 8-Bit Integer Dot Product Accumulate (Signed Source 2)`            |
| `rv_zyqwbdota8i`   | `yqwbdotau_yy`            | `ym, ys2x8, ci, ys1, yd`        | `Tensor Batched 8-Bit Integer Dot Product Accumulate (Unsigned Source 2)`          |
| `rv_zyqwdota8i`    | `yqwdotas_yy`             | `ym, ys2, ys1, yd`              | `Tensor Long 8-Bit Integer Dot Product Accumulate (Signed Source 2)`               |
| `rv_zyqwdota8i`    | `yqwdotau_yy`             | `ym, ys2, ys1, yd`              | `Tensor Long 8-Bit Integer Dot Product Accumulate (Unsigned Source 2)`             |
| `rv_zyt16e`        | `ytle16`                  | `rs2, rs1`                      | `Load 16-Bit Matrix Tile Elements`                                                 |
| `rv_zyt16e`        | `ytse16`                  | `rs2, rs1`                      | `Store 16-Bit Matrix Tile Elements`                                                |
| `rv_zyt64e`        | `ytle64`                  | `rs2, rs1`                      | `Load 64-Bit Matrix Tile Elements`                                                 |
| `rv_zyt64e`        | `ytse64`                  | `rs2, rs1`                      | `Store 64-Bit Matrix Tile Elements`                                                |
| `rv_zyt8e`         | `ytle8`                   | `rs2, rs1`                      | `Load 8-Bit Matrix Tile Elements`                                                  |
| `rv_zyt8e`         | `ytse8`                   | `rs2, rs1`                      | `Store 8-Bit Matrix Tile Elements`                                                 |
| `rv_zytbase`       | `ymsetmtype`              | `rs2, rs1, rd`                  | `Set Matrix Tile and Tensor Register Types`                                        |
| `rv_zytbase`       | `ymsetmtypei`             | `altfmt, ysew, mtwiden, rd`     | `Set Matrix Tile and Tensor Register Types from Immediates`                        |
| `rv_zytbase`       | `ymsettk`                 | `rs1, rd`                       | `Set Matrix Reduction Width`                                                       |
| `rv_zytbase`       | `ymsettm`                 | `rs1, rd`                       | `Set Matrix Row Count`                                                             |
| `rv_zytbase`       | `ymsettn`                 | `rs1, rd`                       | `Set Matrix Column Count`                                                          |
| `rv_zytbase`       | `ytdiscard`               | `none`                          | `Discard Matrix Tile Context`                                                      |
| `rv_zytbase`       | `ytle32`                  | `rs2, rs1`                      | `Load 32-Bit Matrix Tile Elements`                                                 |
| `rv_zytbase`       | `ytmv_t_y`                | `ys2, rs1`                      | `Move Tensor to Matrix Tile Subset`                                                |
| `rv_zytbase`       | `ytmv_y_t`                | `rs1, yd`                       | `Move Matrix Tile Subset to Tensor`                                                |
| `rv_zytbase`       | `ytse32`                  | `rs2, rs1`                      | `Store 32-Bit Matrix Tile Elements`                                                |
| `rv_zytbase`       | `ytzero`                  | `zyt_mtd16`                     | `Zero Matrix Tile Region`                                                          |
| `rv_zytbf16fmm`    | `ytfmm_alt_tyy`           | `ys2, ys1, zyt_mtd8`            | `BF16 Matrix Tile Multiply-Accumulate (Alternate)`                                 |
| `rv_zytdmm`        | `ytfmm_tyy`               | `ys2, ys1, zyt_mtd8`            | `FP64 Matrix Tile Multiply-Accumulate`                                             |
| `rv_zytfmm`        | `ytfmm_tyy`               | `ys2, ys1, zyt_mtd8`            | `FP32 Matrix Tile Multiply-Accumulate`                                             |
| `rv_zytfp16fmm`    | `ytfmm_tyy`               | `ys2, ys1, zyt_mtd8`            | `FP16 Matrix Tile Multiply-Accumulate`                                             |
| `rv_zyti8i32mm`    | `ytmms_tyy`               | `ys2, ys1, zyt_mtd8`            | `Signed 8-Bit Matrix Tile Multiply-Accumulate`                                     |
| `rv_zyti8i32mm`    | `ytmmu_tyy`               | `ys2, ys1, zyt_mtd8`            | `Unsigned 8-Bit Matrix Tile Multiply-Accumulate`                                   |
| `rv_zytofp8fmm`    | `ytfmm_alt_tyy`           | `ys2, ys1, zyt_mtd8`            | `OFP8 Matrix Tile Multiply-Accumulate (Alternate)`                                 |
| `rv_zytofp8fmm`    | `ytfmm_tyy`               | `ys2, ys1, zyt_mtd8`            | `OFP8 Matrix Tile Multiply-Accumulate`                                             |
| `rv_zyzip`         | `ypaire_yy`               | `ym, ys2, ys1, yd`              | `Tensor Interleave Even Elements (Tensor-Tensor)`                                  |
| `rv_zyzip`         | `ypairo_yy`               | `ym, ys2, ys1, yd`              | `Tensor Interleave Odd Elements (Tensor-Tensor)`                                   |
| `rv_zyzip`         | `yunzipe_y`               | `ym, ys2, yd`                   | `Tensor Extract Even Elements (Tensor)`                                            |
| `rv_zyzip`         | `yunzipo_y`               | `ym, ys2, yd`                   | `Tensor Extract Odd Elements (Tensor)`                                             |
| `rv_zyzip`         | `yzip_yy`                 | `ym, ys2, ys1, yd`              | `Tensor Interleave Elements (Tensor-Tensor)`                                       |

:RVZY - Specific Extension for Tensor Operations
