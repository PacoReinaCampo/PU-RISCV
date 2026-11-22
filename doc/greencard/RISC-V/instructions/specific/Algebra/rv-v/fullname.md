## INSTRUCTION FULL-NAMES

| **Extension** | **Name**            | **Variable-Fields**  | **Full-Name**                                                                                    |
|:--------------|:--------------------|:---------------------|:-------------------------------------------------------------------------------------------------|
| `rv_v`        | `vaaddu_vv`         | `vm, vs2, vs1, vd`   | `Vector Averaging Add Unsigned (Vector-Vector)`                                                  |
| `rv_v`        | `vaaddu_vx`         | `vm, vs2, rs1, vd`   | `Vector Averaging Add Unsigned (Vector-Scalar)`                                                  |
| `rv_v`        | `vaadd_vv`          | `vm, vs2, vs1, vd`   | `Vector Averaging Add Signed (Vector-Vector)`                                                    |
| `rv_v`        | `vaadd_vx`          | `vm, vs2, rs1, vd`   | `Vector Averaging Add Signed (Vector-Scalar)`                                                    |
| `rv_v`        | `vadc_vim`          | `vs2, simm5, vd`     | `Vector Integer Add with Carry (Vector-Immediate with Mask Carry Input)`                         |
| `rv_v`        | `vadc_vvm`          | `vs2, vs1, vd`       | `Vector Integer Add with Carry (Vector-Vector with Mask Carry Input)`                            |
| `rv_v`        | `vadc_vxm`          | `vs2, rs1, vd`       | `Vector Integer Add with Carry (Vector-Scalar with Mask Carry Input)`                            |
| `rv_v`        | `vadd_vi`           | `vm, vs2, simm5, vd` | `Vector Integer Add (Vector-Immediate)`                                                          |
| `rv_v`        | `vadd_vv`           | `vm, vs2, vs1, vd`   | `Vector Integer Add (Vector-Vector)`                                                             |
| `rv_v`        | `vadd_vx`           | `vm, vs2, rs1, vd`   | `Vector Integer Add (Vector-Scalar)`                                                             |
| `rv_v`        | `vand_vi`           | `vm, vs2, simm5, vd` | `Vector Bitwise AND (Vector-Immediate)`                                                          |
| `rv_v`        | `vand_vv`           | `vm, vs2, vs1, vd`   | `Vector Bitwise AND (Vector-Vector)`                                                             |
| `rv_v`        | `vand_vx`           | `vm, vs2, rs1, vd`   | `Vector Bitwise AND (Vector-Scalar)`                                                             |
| `rv_v`        | `vasubu_vv`         | `vm, vs2, vs1, vd`   | `Vector Averaging Subtract Unsigned (Vector-Vector)`                                             |
| `rv_v`        | `vasubu_vx`         | `vm, vs2, rs1, vd`   | `Vector Averaging Subtract Unsigned (Vector-Scalar)`                                             |
| `rv_v`        | `vasub_vv`          | `vm, vs2, vs1, vd`   | `Vector Averaging Subtract Signed (Vector-Vector)`                                               |
| `rv_v`        | `vasub_vx`          | `vm, vs2, rs1, vd`   | `Vector Averaging Subtract Signed (Vector-Scalar)`                                               |
| `rv_v`        | `vcompress_vm`      | `vs2, vs1, vd`       | `Vector Compress`                                                                                |
| `rv_v`        | `vcpop_m`           | `vm, vs2, rd`        | `Vector Mask Population Count`                                                                   |
| `rv_v`        | `vdivu_vv`          | `vm, vs2, vs1, vd`   | `Vector Integer Divide Unsigned (Vector-Vector)`                                                 |
| `rv_v`        | `vdivu_vx`          | `vm, vs2, rs1, vd`   | `Vector Integer Divide Unsigned (Vector-Scalar)`                                                 |
| `rv_v`        | `vdiv_vv`           | `vm, vs2, vs1, vd`   | `Vector Integer Divide Signed (Vector-Vector)`                                                   |
| `rv_v`        | `vdiv_vx`           | `vm, vs2, rs1, vd`   | `Vector Integer Divide Signed (Vector-Scalar)`                                                   |
| `rv_v`        | `vfadd_vf`          | `vm, vs2, rs1, vd`   | `Vector Floating-Point Add (Vector-Scalar)`                                                      |
| `rv_v`        | `vfadd_vv`          | `vm, vs2, vs1, vd`   | `Vector Floating-Point Add (Vector-Vector)`                                                      |
| `rv_v`        | `vfclass_v`         | `vm, vs2, vd`        | `Vector Floating-Point Classify`                                                                 |
| `rv_v`        | `vfcvt_f_xu_v`      | `vm, vs2, vd`        | `Vector Convert Unsigned Integer to Floating-Point`                                              |
| `rv_v`        | `vfcvt_f_x_v`       | `vm, vs2, vd`        | `Vector Convert Signed Integer to Floating-Point`                                                |
| `rv_v`        | `vfcvt_rtz_x_f_v`   | `vm, vs2, vd`        | `Vector Convert Floating-Point to Signed Integer with Round Toward Zero`                         |
| `rv_v`        | `vfcvt_rtz_xu_f_v`  | `vm, vs2, vd`        | `Vector Convert Floating-Point to Unsigned Integer with Round Toward Zero`                       |
| `rv_v`        | `vfcvt_x_f_v`       | `vm, vs2, vd`        | `Vector Convert Floating-Point to Signed Integer`                                                |
| `rv_v`        | `vfcvt_xu_f_v`      | `vm, vs2, vd`        | `Vector Convert Floating-Point to Unsigned Integer`                                              |
| `rv_v`        | `vfdiv_vf`          | `vm, vs2, rs1, vd`   | `Vector Floating-Point Divide (Vector-Scalar)`                                                   |
| `rv_v`        | `vfdiv_vv`          | `vm, vs2, vs1, vd`   | `Vector Floating-Point Divide (Vector-Vector)`                                                   |
| `rv_v`        | `vfirst_m`          | `vm, vs2, rd`        | `Vector Mask Find First Set`                                                                     |
| `rv_v`        | `vfmacc_vf`         | `vm, vs2, rs1, vd`   | `Vector Floating-Point Fused Multiply-Accumulate (Vector-Scalar)`                                |
| `rv_v`        | `vfmacc_vv`         | `vm, vs2, vs1, vd`   | `Vector Floating-Point Fused Multiply-Accumulate (Vector-Vector)`                                |
| `rv_v`        | `vfmadd_vf`         | `vm, vs2, rs1, vd`   | `Vector Floating-Point Fused Multiply-Add, Overwrite Multiplicand (Vector-Scalar)`               |
| `rv_v`        | `vfmadd_vv`         | `vm, vs2, vs1, vd`   | `Vector Floating-Point Fused Multiply-Add, Overwrite Multiplicand (Vector-Vector)`               |
| `rv_v`        | `vfmax_vf`          | `vm, vs2, rs1, vd`   | `Vector Floating-Point Maximum (Vector-Scalar)`                                                  |
| `rv_v`        | `vfmax_vv`          | `vm, vs2, vs1, vd`   | `Vector Floating-Point Maximum (Vector-Vector)`                                                  |
| `rv_v`        | `vfmerge_vfm`       | `vs2, rs1, vd`       | `Vector Floating-Point Merge (Vector-Scalar)`                                                    |
| `rv_v`        | `vfmin_vf`          | `vm, vs2, rs1, vd`   | `Vector Floating-Point Minimum (Vector-Scalar)`                                                  |
| `rv_v`        | `vfmin_vv`          | `vm, vs2, vs1, vd`   | `Vector Floating-Point Minimum (Vector-Vector)`                                                  |
| `rv_v`        | `vfmsac_vf`         | `vm, vs2, rs1, vd`   | `Vector Floating-Point Fused Multiply-Subtract Accumulator (Vector-Scalar)`                      |
| `rv_v`        | `vfmsac_vv`         | `vm, vs2, vs1, vd`   | `Vector Floating-Point Fused Multiply-Subtract Accumulator (Vector-Vector)`                      |
| `rv_v`        | `vfmsub_vf`         | `vm, vs2, rs1, vd`   | `Vector Floating-Point Fused Multiply-Subtract, Overwrite Multiplicand (Vector-Scalar)`          |
| `rv_v`        | `vfmsub_vv`         | `vm, vs2, vs1, vd`   | `Vector Floating-Point Fused Multiply-Subtract, Overwrite Multiplicand (Vector-Vector)`          |
| `rv_v`        | `vfmul_vf`          | `vm, vs2, rs1, vd`   | `Vector Floating-Point Multiply (Vector-Scalar)`                                                 |
| `rv_v`        | `vfmul_vv`          | `vm, vs2, vs1, vd`   | `Vector Floating-Point Multiply (Vector-Vector)`                                                 |
| `rv_v`        | `vfmv_f_s`          | `vs2, rd`            | `Vector Move Vector Element to Floating-Point Scalar`                                            |
| `rv_v`        | `vfmv_s_f`          | `rs1, vd`            | `Vector Move Floating-Point Scalar to Vector Element`                                            |
| `rv_v`        | `vfmv_v_f`          | `rs1, vd`            | `Vector Broadcast Floating-Point Scalar`                                                         |
| `rv_v`        | `vfncvt_f_f_w`      | `vm, vs2, vd`        | `Vector Narrowing Convert Floating-Point to Floating-Point`                                      |
| `rv_v`        | `vfncvt_f_xu_w`     | `vm, vs2, vd`        | `Vector Narrowing Convert Unsigned Integer to Floating-Point`                                    |
| `rv_v`        | `vfncvt_f_x_w`      | `vm, vs2, vd`        | `Vector Narrowing Convert Signed Integer to Floating-Point`                                      |
| `rv_v`        | `vfncvt_rod_f_f_w`  | `vm, vs2, vd`        | `Vector Narrowing Convert Floating-Point to Floating-Point with Round to Odd`                    |
| `rv_v`        | `vfncvt_rtz_x_f_w`  | `vm, vs2, vd`        | `Vector Narrowing Convert Floating-Point to Signed Integer with Round Toward Zero`               |
| `rv_v`        | `vfncvt_rtz_xu_f_w` | `vm, vs2, vd`        | `Vector Narrowing Convert Floating-Point to Unsigned Integer with Round Toward Zero`             |
| `rv_v`        | `vfncvt_x_f_w`      | `vm, vs2, vd`        | `Vector Narrowing Convert Floating-Point to Signed Integer`                                      |
| `rv_v`        | `vfncvt_xu_f_w`     | `vm, vs2, vd`        | `Vector Narrowing Convert Floating-Point to Unsigned Integer`                                    |
| `rv_v`        | `vfnmacc_vf`        | `vm, vs2, rs1, vd`   | `Vector Floating-Point Fused Negative Multiply-Accumulate (Vector-Scalar)`                       |
| `rv_v`        | `vfnmacc_vv`        | `vm, vs2, vs1, vd`   | `Vector Floating-Point Fused Negative Multiply-Accumulate (Vector-Vector)`                       |
| `rv_v`        | `vfnmadd_vf`        | `vm, vs2, rs1, vd`   | `Vector Floating-Point Fused Negative Multiply-Add, Overwrite Multiplicand (Vector-Scalar)`      |
| `rv_v`        | `vfnmadd_vv`        | `vm, vs2, vs1, vd`   | `Vector Floating-Point Fused Negative Multiply-Add, Overwrite Multiplicand (Vector-Vector)`      |
| `rv_v`        | `vfnmsac_vf`        | `vm, vs2, rs1, vd`   | `Vector Floating-Point Fused Negative Multiply-Subtract Accumulator (Vector-Scalar)`             |
| `rv_v`        | `vfnmsac_vv`        | `vm, vs2, vs1, vd`   | `Vector Floating-Point Fused Negative Multiply-Subtract Accumulator (Vector-Vector)`             |
| `rv_v`        | `vfnmsub_vf`        | `vm, vs2, rs1, vd`   | `Vector Floating-Point Fused Negative Multiply-Subtract, Overwrite Multiplicand (Vector-Scalar)` |
| `rv_v`        | `vfnmsub_vv`        | `vm, vs2, vs1, vd`   | `Vector Floating-Point Fused Negative Multiply-Subtract, Overwrite Multiplicand (Vector-Vector)` |
| `rv_v`        | `vfrdiv_vf`         | `vm, vs2, rs1, vd`   | `Vector Floating-Point Reverse Divide (Vector-Scalar)`                                           |
| `rv_v`        | `vfrec7_v`          | `vm, vs2, vd`        | `Vector Floating-Point Reciprocal Estimate to 7 Bits`                                            |
| `rv_v`        | `vfredmax_vs`       | `vm, vs2, vs1, vd`   | `Vector Floating-Point Maximum Reduction`                                                        |
| `rv_v`        | `vfredmin_vs`       | `vm, vs2, vs1, vd`   | `Vector Floating-Point Minimum Reduction`                                                        |
| `rv_v`        | `vfredosum_vs`      | `vm, vs2, vs1, vd`   | `Vector Floating-Point Ordered Sum Reduction`                                                    |
| `rv_v`        | `vfredusum_vs`      | `vm, vs2, vs1, vd`   | `Vector Floating-Point Unordered Sum Reduction`                                                  |
| `rv_v`        | `vfrsqrt7_v`        | `vm, vs2, vd`        | `Vector Floating-Point Reciprocal Square-Root Estimate to 7 Bits`                                |
| `rv_v`        | `vfrsub_vf`         | `vm, vs2, rs1, vd`   | `Vector Floating-Point Reverse Subtract (Vector-Scalar)`                                         |
| `rv_v`        | `vfsgnjn_vf`        | `vm, vs2, rs1, vd`   | `Vector Floating-Point Negated Sign Injection (Vector-Scalar)`                                   |
| `rv_v`        | `vfsgnjn_vv`        | `vm, vs2, vs1, vd`   | `Vector Floating-Point Negated Sign Injection (Vector-Vector)`                                   |
| `rv_v`        | `vfsgnj_vf`         | `vm, vs2, rs1, vd`   | `Vector Floating-Point Sign Injection (Vector-Scalar)`                                           |
| `rv_v`        | `vfsgnj_vv`         | `vm, vs2, vs1, vd`   | `Vector Floating-Point Sign Injection (Vector-Vector)`                                           |
| `rv_v`        | `vfsgnjx_vf`        | `vm, vs2, rs1, vd`   | `Vector Floating-Point XOR Sign Injection (Vector-Scalar)`                                       |
| `rv_v`        | `vfsgnjx_vv`        | `vm, vs2, vs1, vd`   | `Vector Floating-Point XOR Sign Injection (Vector-Vector)`                                       |
| `rv_v`        | `vfslide1down_vf`   | `vm, vs2, rs1, vd`   | `Vector Floating-Point Slide One Down (Vector-Scalar)`                                           |
| `rv_v`        | `vfslide1up_vf`     | `vm, vs2, rs1, vd`   | `Vector Floating-Point Slide One Up (Vector-Scalar)`                                             |
| `rv_v`        | `vfsqrt_v`          | `vm, vs2, vd`        | `Vector Floating-Point Square Root`                                                              |
| `rv_v`        | `vfsub_vf`          | `vm, vs2, rs1, vd`   | `Vector Floating-Point Subtract (Vector-Scalar)`                                                 |
| `rv_v`        | `vfsub_vv`          | `vm, vs2, vs1, vd`   | `Vector Floating-Point Subtract (Vector-Vector)`                                                 |
| `rv_v`        | `vfwadd_vf`         | `vm, vs2, rs1, vd`   | `Vector Widening Floating-Point Add (Vector-Scalar)`                                             |
| `rv_v`        | `vfwadd_vv`         | `vm, vs2, vs1, vd`   | `Vector Widening Floating-Point Add (Vector-Vector)`                                             |
| `rv_v`        | `vfwadd_wf`         | `vm, vs2, rs1, vd`   | `Vector Widening Floating-Point Add (Wide Vector-Scalar)`                                        |
| `rv_v`        | `vfwadd_wv`         | `vm, vs2, vs1, vd`   | `Vector Widening Floating-Point Add (Wide Vector-Vector)`                                        |
| `rv_v`        | `vfwcvt_f_f_v`      | `vm, vs2, vd`        | `Vector Widening Convert Floating-Point to Floating-Point`                                       |
| `rv_v`        | `vfwcvt_f_xu_v`     | `vm, vs2, vd`        | `Vector Widening Convert Unsigned Integer to Floating-Point`                                     |
| `rv_v`        | `vfwcvt_f_x_v`      | `vm, vs2, vd`        | `Vector Widening Convert Signed Integer to Floating-Point`                                       |
| `rv_v`        | `vfwcvt_rtz_x_f_v`  | `vm, vs2, vd`        | `Vector Widening Convert Floating-Point to Signed Integer with Round Toward Zero`                |
| `rv_v`        | `vfwcvt_rtz_xu_f_v` | `vm, vs2, vd`        | `Vector Widening Convert Floating-Point to Unsigned Integer with Round Toward Zero`              |
| `rv_v`        | `vfwcvt_x_f_v`      | `vm, vs2, vd`        | `Vector Widening Convert Floating-Point to Signed Integer`                                       |
| `rv_v`        | `vfwcvt_xu_f_v`     | `vm, vs2, vd`        | `Vector Widening Convert Floating-Point to Unsigned Integer`                                     |
| `rv_v`        | `vfwmacc_vf`        | `vm, vs2, rs1, vd`   | `Vector Widening Floating-Point Fused Multiply-Accumulate (Vector-Scalar)`                       |
| `rv_v`        | `vfwmacc_vv`        | `vm, vs2, vs1, vd`   | `Vector Widening Floating-Point Fused Multiply-Accumulate (Vector-Vector)`                       |
| `rv_v`        | `vfwmsac_vf`        | `vm, vs2, rs1, vd`   | `Vector Widening Floating-Point Fused Multiply-Subtract Accumulator (Vector-Scalar)`             |
| `rv_v`        | `vfwmsac_vv`        | `vm, vs2, vs1, vd`   | `Vector Widening Floating-Point Fused Multiply-Subtract Accumulator (Vector-Vector)`             |
| `rv_v`        | `vfwmul_vf`         | `vm, vs2, rs1, vd`   | `Vector Widening Floating-Point Multiply (Vector-Scalar)`                                        |
| `rv_v`        | `vfwmul_vv`         | `vm, vs2, vs1, vd`   | `Vector Widening Floating-Point Multiply (Vector-Vector)`                                        |
| `rv_v`        | `vfwnmacc_vf`       | `vm, vs2, rs1, vd`   | `Vector Widening Floating-Point Fused Negative Multiply-Accumulate (Vector-Scalar)`              |
| `rv_v`        | `vfwnmacc_vv`       | `vm, vs2, vs1, vd`   | `Vector Widening Floating-Point Fused Negative Multiply-Accumulate (Vector-Vector)`              |
| `rv_v`        | `vfwnmsac_vf`       | `vm, vs2, rs1, vd`   | `Vector Widening Floating-Point Fused Negative Multiply-Subtract Accumulator (Vector-Scalar)`    |
| `rv_v`        | `vfwnmsac_vv`       | `vm, vs2, vs1, vd`   | `Vector Widening Floating-Point Fused Negative Multiply-Subtract Accumulator (Vector-Vector)`    |
| `rv_v`        | `vfwredosum_vs`     | `vm, vs2, vs1, vd`   | `Vector Widening Floating-Point Ordered Sum Reduction`                                           |
| `rv_v`        | `vfwredusum_vs`     | `vm, vs2, vs1, vd`   | `Vector Widening Floating-Point Unordered Sum Reduction`                                         |
| `rv_v`        | `vfwsub_vf`         | `vm, vs2, rs1, vd`   | `Vector Widening Floating-Point Subtract (Vector-Scalar)`                                        |
| `rv_v`        | `vfwsub_vv`         | `vm, vs2, vs1, vd`   | `Vector Widening Floating-Point Subtract (Vector-Vector)`                                        |
| `rv_v`        | `vfwsub_wf`         | `vm, vs2, rs1, vd`   | `Vector Widening Floating-Point Subtract (Wide Vector-Scalar)`                                   |
| `rv_v`        | `vfwsub_wv`         | `vm, vs2, vs1, vd`   | `Vector Widening Floating-Point Subtract (Wide Vector-Vector)`                                   |
| `rv_v`        | `vid_v`             | `vm, vd`             | `Vector Element Index`                                                                           |
| `rv_v`        | `viota_m`           | `vm, vs2, vd`        | `Vector Mask Iota`                                                                               |
| `rv_v`        | `vl1re16_v`         | `rs1, vd`            | `Vector Load 1 Whole Register with 16-Bit Encoded Element Width`                                 |
| `rv_v`        | `vl1re32_v`         | `rs1, vd`            | `Vector Load 1 Whole Register with 32-Bit Encoded Element Width`                                 |
| `rv_v`        | `vl1re64_v`         | `rs1, vd`            | `Vector Load 1 Whole Register with 64-Bit Encoded Element Width`                                 |
| `rv_v`        | `vl1re8_v`          | `rs1, vd`            | `Vector Load 1 Whole Register with 8-Bit Encoded Element Width`                                  |
| `rv_v`        | `vl2re16_v`         | `rs1, vd`            | `Vector Load 2 Whole Registers with 16-Bit Encoded Element Width`                                |
| `rv_v`        | `vl2re32_v`         | `rs1, vd`            | `Vector Load 2 Whole Registers with 32-Bit Encoded Element Width`                                |
| `rv_v`        | `vl2re64_v`         | `rs1, vd`            | `Vector Load 2 Whole Registers with 64-Bit Encoded Element Width`                                |
| `rv_v`        | `vl2re8_v`          | `rs1, vd`            | `Vector Load 2 Whole Registers with 8-Bit Encoded Element Width`                                 |
| `rv_v`        | `vl4re16_v`         | `rs1, vd`            | `Vector Load 4 Whole Registers with 16-Bit Encoded Element Width`                                |
| `rv_v`        | `vl4re32_v`         | `rs1, vd`            | `Vector Load 4 Whole Registers with 32-Bit Encoded Element Width`                                |
| `rv_v`        | `vl4re64_v`         | `rs1, vd`            | `Vector Load 4 Whole Registers with 64-Bit Encoded Element Width`                                |
| `rv_v`        | `vl4re8_v`          | `rs1, vd`            | `Vector Load 4 Whole Registers with 8-Bit Encoded Element Width`                                 |
| `rv_v`        | `vl8re16_v`         | `rs1, vd`            | `Vector Load 8 Whole Registers with 16-Bit Encoded Element Width`                                |
| `rv_v`        | `vl8re32_v`         | `rs1, vd`            | `Vector Load 8 Whole Registers with 32-Bit Encoded Element Width`                                |
| `rv_v`        | `vl8re64_v`         | `rs1, vd`            | `Vector Load 8 Whole Registers with 64-Bit Encoded Element Width`                                |
| `rv_v`        | `vl8re8_v`          | `rs1, vd`            | `Vector Load 8 Whole Registers with 8-Bit Encoded Element Width`                                 |
| `rv_v`        | `vle16ff_v`         | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Load with 16-Bit Elements`                                  |
| `rv_v`        | `vle16_v`           | `vm, rs1, vd`        | `Vector Unit-Stride Load with 16-Bit Elements`                                                   |
| `rv_v`        | `vle32ff_v`         | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Load with 32-Bit Elements`                                  |
| `rv_v`        | `vle32_v`           | `vm, rs1, vd`        | `Vector Unit-Stride Load with 32-Bit Elements`                                                   |
| `rv_v`        | `vle64ff_v`         | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Load with 64-Bit Elements`                                  |
| `rv_v`        | `vle64_v`           | `vm, rs1, vd`        | `Vector Unit-Stride Load with 64-Bit Elements`                                                   |
| `rv_v`        | `vle8ff_v`          | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Load with 8-Bit Elements`                                   |
| `rv_v`        | `vle8_v`            | `vm, rs1, vd`        | `Vector Unit-Stride Load with 8-Bit Elements`                                                    |
| `rv_v`        | `vlm_v`             | `rs1, vd`            | `Vector Mask Load`                                                                               |
| `rv_v`        | `vloxei16_v`        | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Load with 16-Bit Indices`                                                |
| `rv_v`        | `vloxei32_v`        | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Load with 32-Bit Indices`                                                |
| `rv_v`        | `vloxei64_v`        | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Load with 64-Bit Indices`                                                |
| `rv_v`        | `vloxei8_v`         | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Load with 8-Bit Indices`                                                 |
| `rv_v`        | `vloxseg2ei16_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 2 Fields with 16-Bit Indices`                            |
| `rv_v`        | `vloxseg2ei32_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 2 Fields with 32-Bit Indices`                            |
| `rv_v`        | `vloxseg2ei64_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 2 Fields with 64-Bit Indices`                            |
| `rv_v`        | `vloxseg2ei8_v`     | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 2 Fields with 8-Bit Indices`                             |
| `rv_v`        | `vloxseg3ei16_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 3 Fields with 16-Bit Indices`                            |
| `rv_v`        | `vloxseg3ei32_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 3 Fields with 32-Bit Indices`                            |
| `rv_v`        | `vloxseg3ei64_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 3 Fields with 64-Bit Indices`                            |
| `rv_v`        | `vloxseg3ei8_v`     | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 3 Fields with 8-Bit Indices`                             |
| `rv_v`        | `vloxseg4ei16_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 4 Fields with 16-Bit Indices`                            |
| `rv_v`        | `vloxseg4ei32_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 4 Fields with 32-Bit Indices`                            |
| `rv_v`        | `vloxseg4ei64_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 4 Fields with 64-Bit Indices`                            |
| `rv_v`        | `vloxseg4ei8_v`     | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 4 Fields with 8-Bit Indices`                             |
| `rv_v`        | `vloxseg5ei16_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 5 Fields with 16-Bit Indices`                            |
| `rv_v`        | `vloxseg5ei32_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 5 Fields with 32-Bit Indices`                            |
| `rv_v`        | `vloxseg5ei64_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 5 Fields with 64-Bit Indices`                            |
| `rv_v`        | `vloxseg5ei8_v`     | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 5 Fields with 8-Bit Indices`                             |
| `rv_v`        | `vloxseg6ei16_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 6 Fields with 16-Bit Indices`                            |
| `rv_v`        | `vloxseg6ei32_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 6 Fields with 32-Bit Indices`                            |
| `rv_v`        | `vloxseg6ei64_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 6 Fields with 64-Bit Indices`                            |
| `rv_v`        | `vloxseg6ei8_v`     | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 6 Fields with 8-Bit Indices`                             |
| `rv_v`        | `vloxseg7ei16_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 7 Fields with 16-Bit Indices`                            |
| `rv_v`        | `vloxseg7ei32_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 7 Fields with 32-Bit Indices`                            |
| `rv_v`        | `vloxseg7ei64_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 7 Fields with 64-Bit Indices`                            |
| `rv_v`        | `vloxseg7ei8_v`     | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 7 Fields with 8-Bit Indices`                             |
| `rv_v`        | `vloxseg8ei16_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 8 Fields with 16-Bit Indices`                            |
| `rv_v`        | `vloxseg8ei32_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 8 Fields with 32-Bit Indices`                            |
| `rv_v`        | `vloxseg8ei64_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 8 Fields with 64-Bit Indices`                            |
| `rv_v`        | `vloxseg8ei8_v`     | `vm, vs2, rs1, vd`   | `Vector Indexed-Ordered Segment Load of 8 Fields with 8-Bit Indices`                             |
| `rv_v`        | `vlse16_v`          | `vm, rs2, rs1, vd`   | `Vector Strided Load with 16-Bit Elements`                                                       |
| `rv_v`        | `vlse32_v`          | `vm, rs2, rs1, vd`   | `Vector Strided Load with 32-Bit Elements`                                                       |
| `rv_v`        | `vlse64_v`          | `vm, rs2, rs1, vd`   | `Vector Strided Load with 64-Bit Elements`                                                       |
| `rv_v`        | `vlse8_v`           | `vm, rs2, rs1, vd`   | `Vector Strided Load with 8-Bit Elements`                                                        |
| `rv_v`        | `vlseg2e16ff_v`     | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 2 Fields with 16-Bit Elements`              |
| `rv_v`        | `vlseg2e16_v`       | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 2 Fields with 16-Bit Elements`                               |
| `rv_v`        | `vlseg2e32ff_v`     | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 2 Fields with 32-Bit Elements`              |
| `rv_v`        | `vlseg2e32_v`       | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 2 Fields with 32-Bit Elements`                               |
| `rv_v`        | `vlseg2e64ff_v`     | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 2 Fields with 64-Bit Elements`              |
| `rv_v`        | `vlseg2e64_v`       | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 2 Fields with 64-Bit Elements`                               |
| `rv_v`        | `vlseg2e8ff_v`      | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 2 Fields with 8-Bit Elements`               |
| `rv_v`        | `vlseg2e8_v`        | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 2 Fields with 8-Bit Elements`                                |
| `rv_v`        | `vlseg3e16ff_v`     | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 3 Fields with 16-Bit Elements`              |
| `rv_v`        | `vlseg3e16_v`       | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 3 Fields with 16-Bit Elements`                               |
| `rv_v`        | `vlseg3e32ff_v`     | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 3 Fields with 32-Bit Elements`              |
| `rv_v`        | `vlseg3e32_v`       | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 3 Fields with 32-Bit Elements`                               |
| `rv_v`        | `vlseg3e64ff_v`     | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 3 Fields with 64-Bit Elements`              |
| `rv_v`        | `vlseg3e64_v`       | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 3 Fields with 64-Bit Elements`                               |
| `rv_v`        | `vlseg3e8ff_v`      | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 3 Fields with 8-Bit Elements`               |
| `rv_v`        | `vlseg3e8_v`        | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 3 Fields with 8-Bit Elements`                                |
| `rv_v`        | `vlseg4e16ff_v`     | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 4 Fields with 16-Bit Elements`              |
| `rv_v`        | `vlseg4e16_v`       | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 4 Fields with 16-Bit Elements`                               |
| `rv_v`        | `vlseg4e32ff_v`     | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 4 Fields with 32-Bit Elements`              |
| `rv_v`        | `vlseg4e32_v`       | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 4 Fields with 32-Bit Elements`                               |
| `rv_v`        | `vlseg4e64ff_v`     | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 4 Fields with 64-Bit Elements`              |
| `rv_v`        | `vlseg4e64_v`       | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 4 Fields with 64-Bit Elements`                               |
| `rv_v`        | `vlseg4e8ff_v`      | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 4 Fields with 8-Bit Elements`               |
| `rv_v`        | `vlseg4e8_v`        | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 4 Fields with 8-Bit Elements`                                |
| `rv_v`        | `vlseg5e16ff_v`     | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 5 Fields with 16-Bit Elements`              |
| `rv_v`        | `vlseg5e16_v`       | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 5 Fields with 16-Bit Elements`                               |
| `rv_v`        | `vlseg5e32ff_v`     | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 5 Fields with 32-Bit Elements`              |
| `rv_v`        | `vlseg5e32_v`       | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 5 Fields with 32-Bit Elements`                               |
| `rv_v`        | `vlseg5e64ff_v`     | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 5 Fields with 64-Bit Elements`              |
| `rv_v`        | `vlseg5e64_v`       | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 5 Fields with 64-Bit Elements`                               |
| `rv_v`        | `vlseg5e8ff_v`      | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 5 Fields with 8-Bit Elements`               |
| `rv_v`        | `vlseg5e8_v`        | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 5 Fields with 8-Bit Elements`                                |
| `rv_v`        | `vlseg6e16ff_v`     | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 6 Fields with 16-Bit Elements`              |
| `rv_v`        | `vlseg6e16_v`       | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 6 Fields with 16-Bit Elements`                               |
| `rv_v`        | `vlseg6e32ff_v`     | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 6 Fields with 32-Bit Elements`              |
| `rv_v`        | `vlseg6e32_v`       | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 6 Fields with 32-Bit Elements`                               |
| `rv_v`        | `vlseg6e64ff_v`     | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 6 Fields with 64-Bit Elements`              |
| `rv_v`        | `vlseg6e64_v`       | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 6 Fields with 64-Bit Elements`                               |
| `rv_v`        | `vlseg6e8ff_v`      | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 6 Fields with 8-Bit Elements`               |
| `rv_v`        | `vlseg6e8_v`        | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 6 Fields with 8-Bit Elements`                                |
| `rv_v`        | `vlseg7e16ff_v`     | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 7 Fields with 16-Bit Elements`              |
| `rv_v`        | `vlseg7e16_v`       | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 7 Fields with 16-Bit Elements`                               |
| `rv_v`        | `vlseg7e32ff_v`     | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 7 Fields with 32-Bit Elements`              |
| `rv_v`        | `vlseg7e32_v`       | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 7 Fields with 32-Bit Elements`                               |
| `rv_v`        | `vlseg7e64ff_v`     | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 7 Fields with 64-Bit Elements`              |
| `rv_v`        | `vlseg7e64_v`       | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 7 Fields with 64-Bit Elements`                               |
| `rv_v`        | `vlseg7e8ff_v`      | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 7 Fields with 8-Bit Elements`               |
| `rv_v`        | `vlseg7e8_v`        | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 7 Fields with 8-Bit Elements`                                |
| `rv_v`        | `vlseg8e16ff_v`     | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 8 Fields with 16-Bit Elements`              |
| `rv_v`        | `vlseg8e16_v`       | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 8 Fields with 16-Bit Elements`                               |
| `rv_v`        | `vlseg8e32ff_v`     | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 8 Fields with 32-Bit Elements`              |
| `rv_v`        | `vlseg8e32_v`       | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 8 Fields with 32-Bit Elements`                               |
| `rv_v`        | `vlseg8e64ff_v`     | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 8 Fields with 64-Bit Elements`              |
| `rv_v`        | `vlseg8e64_v`       | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 8 Fields with 64-Bit Elements`                               |
| `rv_v`        | `vlseg8e8ff_v`      | `vm, rs1, vd`        | `Vector Unit-Stride Fault-Only-First Segment Load of 8 Fields with 8-Bit Elements`               |
| `rv_v`        | `vlseg8e8_v`        | `vm, rs1, vd`        | `Vector Unit-Stride Segment Load of 8 Fields with 8-Bit Elements`                                |
| `rv_v`        | `vlsseg2e16_v`      | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 2 Fields with 16-Bit Elements`                                   |
| `rv_v`        | `vlsseg2e32_v`      | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 2 Fields with 32-Bit Elements`                                   |
| `rv_v`        | `vlsseg2e64_v`      | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 2 Fields with 64-Bit Elements`                                   |
| `rv_v`        | `vlsseg2e8_v`       | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 2 Fields with 8-Bit Elements`                                    |
| `rv_v`        | `vlsseg3e16_v`      | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 3 Fields with 16-Bit Elements`                                   |
| `rv_v`        | `vlsseg3e32_v`      | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 3 Fields with 32-Bit Elements`                                   |
| `rv_v`        | `vlsseg3e64_v`      | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 3 Fields with 64-Bit Elements`                                   |
| `rv_v`        | `vlsseg3e8_v`       | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 3 Fields with 8-Bit Elements`                                    |
| `rv_v`        | `vlsseg4e16_v`      | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 4 Fields with 16-Bit Elements`                                   |
| `rv_v`        | `vlsseg4e32_v`      | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 4 Fields with 32-Bit Elements`                                   |
| `rv_v`        | `vlsseg4e64_v`      | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 4 Fields with 64-Bit Elements`                                   |
| `rv_v`        | `vlsseg4e8_v`       | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 4 Fields with 8-Bit Elements`                                    |
| `rv_v`        | `vlsseg5e16_v`      | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 5 Fields with 16-Bit Elements`                                   |
| `rv_v`        | `vlsseg5e32_v`      | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 5 Fields with 32-Bit Elements`                                   |
| `rv_v`        | `vlsseg5e64_v`      | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 5 Fields with 64-Bit Elements`                                   |
| `rv_v`        | `vlsseg5e8_v`       | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 5 Fields with 8-Bit Elements`                                    |
| `rv_v`        | `vlsseg6e16_v`      | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 6 Fields with 16-Bit Elements`                                   |
| `rv_v`        | `vlsseg6e32_v`      | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 6 Fields with 32-Bit Elements`                                   |
| `rv_v`        | `vlsseg6e64_v`      | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 6 Fields with 64-Bit Elements`                                   |
| `rv_v`        | `vlsseg6e8_v`       | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 6 Fields with 8-Bit Elements`                                    |
| `rv_v`        | `vlsseg7e16_v`      | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 7 Fields with 16-Bit Elements`                                   |
| `rv_v`        | `vlsseg7e32_v`      | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 7 Fields with 32-Bit Elements`                                   |
| `rv_v`        | `vlsseg7e64_v`      | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 7 Fields with 64-Bit Elements`                                   |
| `rv_v`        | `vlsseg7e8_v`       | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 7 Fields with 8-Bit Elements`                                    |
| `rv_v`        | `vlsseg8e16_v`      | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 8 Fields with 16-Bit Elements`                                   |
| `rv_v`        | `vlsseg8e32_v`      | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 8 Fields with 32-Bit Elements`                                   |
| `rv_v`        | `vlsseg8e64_v`      | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 8 Fields with 64-Bit Elements`                                   |
| `rv_v`        | `vlsseg8e8_v`       | `vm, rs2, rs1, vd`   | `Vector Strided Segment Load of 8 Fields with 8-Bit Elements`                                    |
| `rv_v`        | `vluxei16_v`        | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Load with 16-Bit Indices`                                              |
| `rv_v`        | `vluxei32_v`        | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Load with 32-Bit Indices`                                              |
| `rv_v`        | `vluxei64_v`        | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Load with 64-Bit Indices`                                              |
| `rv_v`        | `vluxei8_v`         | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Load with 8-Bit Indices`                                               |
| `rv_v`        | `vluxseg2ei16_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 2 Fields with 16-Bit Indices`                          |
| `rv_v`        | `vluxseg2ei32_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 2 Fields with 32-Bit Indices`                          |
| `rv_v`        | `vluxseg2ei64_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 2 Fields with 64-Bit Indices`                          |
| `rv_v`        | `vluxseg2ei8_v`     | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 2 Fields with 8-Bit Indices`                           |
| `rv_v`        | `vluxseg3ei16_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 3 Fields with 16-Bit Indices`                          |
| `rv_v`        | `vluxseg3ei32_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 3 Fields with 32-Bit Indices`                          |
| `rv_v`        | `vluxseg3ei64_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 3 Fields with 64-Bit Indices`                          |
| `rv_v`        | `vluxseg3ei8_v`     | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 3 Fields with 8-Bit Indices`                           |
| `rv_v`        | `vluxseg4ei16_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 4 Fields with 16-Bit Indices`                          |
| `rv_v`        | `vluxseg4ei32_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 4 Fields with 32-Bit Indices`                          |
| `rv_v`        | `vluxseg4ei64_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 4 Fields with 64-Bit Indices`                          |
| `rv_v`        | `vluxseg4ei8_v`     | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 4 Fields with 8-Bit Indices`                           |
| `rv_v`        | `vluxseg5ei16_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 5 Fields with 16-Bit Indices`                          |
| `rv_v`        | `vluxseg5ei32_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 5 Fields with 32-Bit Indices`                          |
| `rv_v`        | `vluxseg5ei64_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 5 Fields with 64-Bit Indices`                          |
| `rv_v`        | `vluxseg5ei8_v`     | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 5 Fields with 8-Bit Indices`                           |
| `rv_v`        | `vluxseg6ei16_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 6 Fields with 16-Bit Indices`                          |
| `rv_v`        | `vluxseg6ei32_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 6 Fields with 32-Bit Indices`                          |
| `rv_v`        | `vluxseg6ei64_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 6 Fields with 64-Bit Indices`                          |
| `rv_v`        | `vluxseg6ei8_v`     | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 6 Fields with 8-Bit Indices`                           |
| `rv_v`        | `vluxseg7ei16_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 7 Fields with 16-Bit Indices`                          |
| `rv_v`        | `vluxseg7ei32_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 7 Fields with 32-Bit Indices`                          |
| `rv_v`        | `vluxseg7ei64_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 7 Fields with 64-Bit Indices`                          |
| `rv_v`        | `vluxseg7ei8_v`     | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 7 Fields with 8-Bit Indices`                           |
| `rv_v`        | `vluxseg8ei16_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 8 Fields with 16-Bit Indices`                          |
| `rv_v`        | `vluxseg8ei32_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 8 Fields with 32-Bit Indices`                          |
| `rv_v`        | `vluxseg8ei64_v`    | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 8 Fields with 64-Bit Indices`                          |
| `rv_v`        | `vluxseg8ei8_v`     | `vm, vs2, rs1, vd`   | `Vector Indexed-Unordered Segment Load of 8 Fields with 8-Bit Indices`                           |
| `rv_v`        | `vmacc_vv`          | `vm, vs2, vs1, vd`   | `Vector Integer Multiply-Accumulate (Vector-Vector)`                                             |
| `rv_v`        | `vmacc_vx`          | `vm, vs2, rs1, vd`   | `Vector Integer Multiply-Accumulate (Vector-Scalar)`                                             |
| `rv_v`        | `vmadc_vi`          | `vs2, simm5, vd`     | `Vector Integer Add Carry-Out (Vector-Immediate)`                                                |
| `rv_v`        | `vmadc_vim`         | `vs2, simm5, vd`     | `Vector Integer Add Carry-Out (Vector-Immediate with Mask Carry Input)`                          |
| `rv_v`        | `vmadc_vv`          | `vs2, vs1, vd`       | `Vector Integer Add Carry-Out (Vector-Vector)`                                                   |
| `rv_v`        | `vmadc_vvm`         | `vs2, vs1, vd`       | `Vector Integer Add Carry-Out (Vector-Vector with Mask Carry Input)`                             |
| `rv_v`        | `vmadc_vx`          | `vs2, rs1, vd`       | `Vector Integer Add Carry-Out (Vector-Scalar)`                                                   |
| `rv_v`        | `vmadc_vxm`         | `vs2, rs1, vd`       | `Vector Integer Add Carry-Out (Vector-Scalar with Mask Carry Input)`                             |
| `rv_v`        | `vmadd_vv`          | `vm, vs2, vs1, vd`   | `Vector Integer Multiply-Add, Overwrite Multiplicand (Vector-Vector)`                            |
| `rv_v`        | `vmadd_vx`          | `vm, vs2, rs1, vd`   | `Vector Integer Multiply-Add, Overwrite Multiplicand (Vector-Scalar)`                            |
| `rv_v`        | `vmand_mm`          | `vs2, vs1, vd`       | `Vector Mask AND`                                                                                |
| `rv_v`        | `vmandn_mm`         | `vs2, vs1, vd`       | `Vector Mask AND-NOT`                                                                            |
| `rv_v`        | `vmaxu_vv`          | `vm, vs2, vs1, vd`   | `Vector Integer Max Unsigned (Vector-Vector)`                                                    |
| `rv_v`        | `vmaxu_vx`          | `vm, vs2, rs1, vd`   | `Vector Integer Max Unsigned (Vector-Scalar)`                                                    |
| `rv_v`        | `vmax_vv`           | `vm, vs2, vs1, vd`   | `Vector Integer Max Signed (Vector-Vector)`                                                      |
| `rv_v`        | `vmax_vx`           | `vm, vs2, rs1, vd`   | `Vector Integer Max Signed (Vector-Scalar)`                                                      |
| `rv_v`        | `vmerge_vim`        | `vs2, simm5, vd`     | `Vector Integer Merge (Vector-Immediate)`                                                        |
| `rv_v`        | `vmerge_vvm`        | `vs2, vs1, vd`       | `Vector Integer Merge (Vector-Vector)`                                                           |
| `rv_v`        | `vmerge_vxm`        | `vs2, rs1, vd`       | `Vector Integer Merge (Vector-Scalar)`                                                           |
| `rv_v`        | `vmfeq_vf`          | `vm, vs2, rs1, vd`   | `Vector Floating-Point Compare Equal (Vector-Scalar)`                                            |
| `rv_v`        | `vmfeq_vv`          | `vm, vs2, vs1, vd`   | `Vector Floating-Point Compare Equal (Vector-Vector)`                                            |
| `rv_v`        | `vmfge_vf`          | `vm, vs2, rs1, vd`   | `Vector Floating-Point Compare Greater Than or Equal (Vector-Scalar)`                            |
| `rv_v`        | `vmfgt_vf`          | `vm, vs2, rs1, vd`   | `Vector Floating-Point Compare Greater Than (Vector-Scalar)`                                     |
| `rv_v`        | `vmfle_vf`          | `vm, vs2, rs1, vd`   | `Vector Floating-Point Compare Less Than or Equal (Vector-Scalar)`                               |
| `rv_v`        | `vmfle_vv`          | `vm, vs2, vs1, vd`   | `Vector Floating-Point Compare Less Than or Equal (Vector-Vector)`                               |
| `rv_v`        | `vmflt_vf`          | `vm, vs2, rs1, vd`   | `Vector Floating-Point Compare Less Than (Vector-Scalar)`                                        |
| `rv_v`        | `vmflt_vv`          | `vm, vs2, vs1, vd`   | `Vector Floating-Point Compare Less Than (Vector-Vector)`                                        |
| `rv_v`        | `vmfne_vf`          | `vm, vs2, rs1, vd`   | `Vector Floating-Point Compare Not Equal (Vector-Scalar)`                                        |
| `rv_v`        | `vmfne_vv`          | `vm, vs2, vs1, vd`   | `Vector Floating-Point Compare Not Equal (Vector-Vector)`                                        |
| `rv_v`        | `vminu_vv`          | `vm, vs2, vs1, vd`   | `Vector Integer Min Unsigned (Vector-Vector)`                                                    |
| `rv_v`        | `vminu_vx`          | `vm, vs2, rs1, vd`   | `Vector Integer Min Unsigned (Vector-Scalar)`                                                    |
| `rv_v`        | `vmin_vv`           | `vm, vs2, vs1, vd`   | `Vector Integer Min Signed (Vector-Vector)`                                                      |
| `rv_v`        | `vmin_vx`           | `vm, vs2, rs1, vd`   | `Vector Integer Min Signed (Vector-Scalar)`                                                      |
| `rv_v`        | `vmnand_mm`         | `vs2, vs1, vd`       | `Vector Mask NAND`                                                                               |
| `rv_v`        | `vmnor_mm`          | `vs2, vs1, vd`       | `Vector Mask NOR`                                                                                |
| `rv_v`        | `vmor_mm`           | `vs2, vs1, vd`       | `Vector Mask OR`                                                                                 |
| `rv_v`        | `vmorn_mm`          | `vs2, vs1, vd`       | `Vector Mask OR-NOT`                                                                             |
| `rv_v`        | `vmsbc_vv`          | `vs2, vs1, vd`       | `Vector Integer Subtract Borrow-Out (Vector-Vector)`                                             |
| `rv_v`        | `vmsbc_vvm`         | `vs2, vs1, vd`       | `Vector Integer Subtract Borrow-Out (Vector-Vector with Mask Borrow Input)`                      |
| `rv_v`        | `vmsbc_vx`          | `vs2, rs1, vd`       | `Vector Integer Subtract Borrow-Out (Vector-Scalar)`                                             |
| `rv_v`        | `vmsbc_vxm`         | `vs2, rs1, vd`       | `Vector Integer Subtract Borrow-Out (Vector-Scalar with Mask Borrow Input)`                      |
| `rv_v`        | `vmsbf_m`           | `vm, vs2, vd`        | `Vector Mask Set Before First`                                                                   |
| `rv_v`        | `vmseq_vi`          | `vm, vs2, simm5, vd` | `Vector Integer Compare Equal (Vector-Immediate)`                                                |
| `rv_v`        | `vmseq_vv`          | `vm, vs2, vs1, vd`   | `Vector Integer Compare Equal (Vector-Vector)`                                                   |
| `rv_v`        | `vmseq_vx`          | `vm, vs2, rs1, vd`   | `Vector Integer Compare Equal (Vector-Scalar)`                                                   |
| `rv_v`        | `vmsgtu_vi`         | `vm, vs2, simm5, vd` | `Vector Integer Compare Greater Than Unsigned (Vector-Immediate)`                                |
| `rv_v`        | `vmsgtu_vx`         | `vm, vs2, rs1, vd`   | `Vector Integer Compare Greater Than Unsigned (Vector-Scalar)`                                   |
| `rv_v`        | `vmsgt_vi`          | `vm, vs2, simm5, vd` | `Vector Integer Compare Greater Than Signed (Vector-Immediate)`                                  |
| `rv_v`        | `vmsgt_vx`          | `vm, vs2, rs1, vd`   | `Vector Integer Compare Greater Than Signed (Vector-Scalar)`                                     |
| `rv_v`        | `vmsif_m`           | `vm, vs2, vd`        | `Vector Mask Set Including First`                                                                |
| `rv_v`        | `vmsleu_vi`         | `vm, vs2, simm5, vd` | `Vector Integer Compare Less Than or Equal Unsigned (Vector-Immediate)`                          |
| `rv_v`        | `vmsleu_vv`         | `vm, vs2, vs1, vd`   | `Vector Integer Compare Less Than or Equal Unsigned (Vector-Vector)`                             |
| `rv_v`        | `vmsleu_vx`         | `vm, vs2, rs1, vd`   | `Vector Integer Compare Less Than or Equal Unsigned (Vector-Scalar)`                             |
| `rv_v`        | `vmsle_vi`          | `vm, vs2, simm5, vd` | `Vector Integer Compare Less Than or Equal Signed (Vector-Immediate)`                            |
| `rv_v`        | `vmsle_vv`          | `vm, vs2, vs1, vd`   | `Vector Integer Compare Less Than or Equal Signed (Vector-Vector)`                               |
| `rv_v`        | `vmsle_vx`          | `vm, vs2, rs1, vd`   | `Vector Integer Compare Less Than or Equal Signed (Vector-Scalar)`                               |
| `rv_v`        | `vmsltu_vv`         | `vm, vs2, vs1, vd`   | `Vector Integer Compare Less Than Unsigned (Vector-Vector)`                                      |
| `rv_v`        | `vmsltu_vx`         | `vm, vs2, rs1, vd`   | `Vector Integer Compare Less Than Unsigned (Vector-Scalar)`                                      |
| `rv_v`        | `vmslt_vv`          | `vm, vs2, vs1, vd`   | `Vector Integer Compare Less Than Signed (Vector-Vector)`                                        |
| `rv_v`        | `vmslt_vx`          | `vm, vs2, rs1, vd`   | `Vector Integer Compare Less Than Signed (Vector-Scalar)`                                        |
| `rv_v`        | `vmsne_vi`          | `vm, vs2, simm5, vd` | `Vector Integer Compare Not Equal (Vector-Immediate)`                                            |
| `rv_v`        | `vmsne_vv`          | `vm, vs2, vs1, vd`   | `Vector Integer Compare Not Equal (Vector-Vector)`                                               |
| `rv_v`        | `vmsne_vx`          | `vm, vs2, rs1, vd`   | `Vector Integer Compare Not Equal (Vector-Scalar)`                                               |
| `rv_v`        | `vmsof_m`           | `vm, vs2, vd`        | `Vector Mask Set Only First`                                                                     |
| `rv_v`        | `vmulhsu_vv`        | `vm, vs2, vs1, vd`   | `Vector Integer Multiply High Signed-Unsigned (Vector-Vector)`                                   |
| `rv_v`        | `vmulhsu_vx`        | `vm, vs2, rs1, vd`   | `Vector Integer Multiply High Signed-Unsigned (Vector-Scalar)`                                   |
| `rv_v`        | `vmulhu_vv`         | `vm, vs2, vs1, vd`   | `Vector Integer Multiply High Unsigned (Vector-Vector)`                                          |
| `rv_v`        | `vmulhu_vx`         | `vm, vs2, rs1, vd`   | `Vector Integer Multiply High Unsigned (Vector-Scalar)`                                          |
| `rv_v`        | `vmulh_vv`          | `vm, vs2, vs1, vd`   | `Vector Integer Multiply High Signed (Vector-Vector)`                                            |
| `rv_v`        | `vmulh_vx`          | `vm, vs2, rs1, vd`   | `Vector Integer Multiply High Signed (Vector-Scalar)`                                            |
| `rv_v`        | `vmul_vv`           | `vm, vs2, vs1, vd`   | `Vector Integer Multiply Signed (Vector-Vector)`                                                 |
| `rv_v`        | `vmul_vx`           | `vm, vs2, rs1, vd`   | `Vector Integer Multiply Signed (Vector-Scalar)`                                                 |
| `rv_v`        | `vmv1r_v`           | `vs2, vd`            | `Vector Move 1 Whole Register`                                                                   |
| `rv_v`        | `vmv2r_v`           | `vs2, vd`            | `Vector Move 2 Whole Registers`                                                                  |
| `rv_v`        | `vmv4r_v`           | `vs2, vd`            | `Vector Move 4 Whole Registers`                                                                  |
| `rv_v`        | `vmv8r_v`           | `vs2, vd`            | `Vector Move 8 Whole Registers`                                                                  |
| `rv_v`        | `vmv_s_x`           | `rs1, vd`            | `Vector Move Integer Scalar to Vector Element`                                                   |
| `rv_v`        | `vmv_v_i`           | `simm5, vd`          | `Vector Broadcast Signed Immediate`                                                              |
| `rv_v`        | `vmv_v_v`           | `vs1, vd`            | `Vector Move Vector Elements`                                                                    |
| `rv_v`        | `vmv_v_x`           | `rs1, vd`            | `Vector Broadcast Integer Scalar`                                                                |
| `rv_v`        | `vmv_x_s`           | `vs2, rd`            | `Vector Move Vector Element to Integer Scalar`                                                   |
| `rv_v`        | `vmxnor_mm`         | `vs2, vs1, vd`       | `Vector Mask XNOR`                                                                               |
| `rv_v`        | `vmxor_mm`          | `vs2, vs1, vd`       | `Vector Mask XOR`                                                                                |
| `rv_v`        | `vnclipu_wi`        | `vm, vs2, zimm5, vd` | `Vector Narrowing Clip Unsigned (Wide Vector-Immediate)`                                         |
| `rv_v`        | `vnclipu_wv`        | `vm, vs2, vs1, vd`   | `Vector Narrowing Clip Unsigned (Wide Vector-Vector)`                                            |
| `rv_v`        | `vnclipu_wx`        | `vm, vs2, rs1, vd`   | `Vector Narrowing Clip Unsigned (Wide Vector-Scalar)`                                            |
| `rv_v`        | `vnclip_wi`         | `vm, vs2, zimm5, vd` | `Vector Narrowing Clip Signed (Wide Vector-Immediate)`                                           |
| `rv_v`        | `vnclip_wv`         | `vm, vs2, vs1, vd`   | `Vector Narrowing Clip Signed (Wide Vector-Vector)`                                              |
| `rv_v`        | `vnclip_wx`         | `vm, vs2, rs1, vd`   | `Vector Narrowing Clip Signed (Wide Vector-Scalar)`                                              |
| `rv_v`        | `vnmsac_vv`         | `vm, vs2, vs1, vd`   | `Vector Integer Negative Multiply-Subtract from Accumulator (Vector-Vector)`                     |
| `rv_v`        | `vnmsac_vx`         | `vm, vs2, rs1, vd`   | `Vector Integer Negative Multiply-Subtract from Accumulator (Vector-Scalar)`                     |
| `rv_v`        | `vnmsub_vv`         | `vm, vs2, vs1, vd`   | `Vector Integer Negative Multiply-Subtract, Overwrite Multiplicand (Vector-Vector)`              |
| `rv_v`        | `vnmsub_vx`         | `vm, vs2, rs1, vd`   | `Vector Integer Negative Multiply-Subtract, Overwrite Multiplicand (Vector-Scalar)`              |
| `rv_v`        | `vnsra_wi`          | `vm, vs2, zimm5, vd` | `Vector Narrowing Shift Right Arithmetic (Wide Vector-Immediate)`                                |
| `rv_v`        | `vnsra_wv`          | `vm, vs2, vs1, vd`   | `Vector Narrowing Shift Right Arithmetic (Wide Vector-Vector)`                                   |
| `rv_v`        | `vnsra_wx`          | `vm, vs2, rs1, vd`   | `Vector Narrowing Shift Right Arithmetic (Wide Vector-Scalar)`                                   |
| `rv_v`        | `vnsrl_wi`          | `vm, vs2, zimm5, vd` | `Vector Narrowing Shift Right Logical (Wide Vector-Immediate)`                                   |
| `rv_v`        | `vnsrl_wv`          | `vm, vs2, vs1, vd`   | `Vector Narrowing Shift Right Logical (Wide Vector-Vector)`                                      |
| `rv_v`        | `vnsrl_wx`          | `vm, vs2, rs1, vd`   | `Vector Narrowing Shift Right Logical (Wide Vector-Scalar)`                                      |
| `rv_v`        | `vor_vi`            | `vm, vs2, simm5, vd` | `Vector Bitwise OR (Vector-Immediate)`                                                           |
| `rv_v`        | `vor_vv`            | `vm, vs2, vs1, vd`   | `Vector Bitwise OR (Vector-Vector)`                                                              |
| `rv_v`        | `vor_vx`            | `vm, vs2, rs1, vd`   | `Vector Bitwise OR (Vector-Scalar)`                                                              |
| `rv_v`        | `vredand_vs`        | `vm, vs2, vs1, vd`   | `Vector Integer AND Reduction`                                                                   |
| `rv_v`        | `vredmaxu_vs`       | `vm, vs2, vs1, vd`   | `Vector Integer Maximum Unsigned Reduction`                                                      |
| `rv_v`        | `vredmax_vs`        | `vm, vs2, vs1, vd`   | `Vector Integer Maximum Signed Reduction`                                                        |
| `rv_v`        | `vredminu_vs`       | `vm, vs2, vs1, vd`   | `Vector Integer Minimum Unsigned Reduction`                                                      |
| `rv_v`        | `vredmin_vs`        | `vm, vs2, vs1, vd`   | `Vector Integer Minimum Signed Reduction`                                                        |
| `rv_v`        | `vredor_vs`         | `vm, vs2, vs1, vd`   | `Vector Integer OR Reduction`                                                                    |
| `rv_v`        | `vredsum_vs`        | `vm, vs2, vs1, vd`   | `Vector Integer Sum Reduction`                                                                   |
| `rv_v`        | `vredxor_vs`        | `vm, vs2, vs1, vd`   | `Vector Integer XOR Reduction`                                                                   |
| `rv_v`        | `vremu_vv`          | `vm, vs2, vs1, vd`   | `Vector Integer Remainder Unsigned (Vector-Vector)`                                              |
| `rv_v`        | `vremu_vx`          | `vm, vs2, rs1, vd`   | `Vector Integer Remainder Unsigned (Vector-Scalar)`                                              |
| `rv_v`        | `vrem_vv`           | `vm, vs2, vs1, vd`   | `Vector Integer Remainder Signed (Vector-Vector)`                                                |
| `rv_v`        | `vrem_vx`           | `vm, vs2, rs1, vd`   | `Vector Integer Remainder Signed (Vector-Scalar)`                                                |
| `rv_v`        | `vrgatherei16_vv`   | `vm, vs2, vs1, vd`   | `Vector Register Gather with 16-Bit Element Indices (Vector-Vector)`                             |
| `rv_v`        | `vrgather_vi`       | `vm, vs2, zimm5, vd` | `Vector Register Gather (Vector-Immediate)`                                                      |
| `rv_v`        | `vrgather_vv`       | `vm, vs2, vs1, vd`   | `Vector Register Gather (Vector-Vector)`                                                         |
| `rv_v`        | `vrgather_vx`       | `vm, vs2, rs1, vd`   | `Vector Register Gather (Vector-Scalar)`                                                         |
| `rv_v`        | `vrsub_vi`          | `vm, vs2, simm5, vd` | `Vector Integer Reverse Subtract (Vector-Immediate)`                                             |
| `rv_v`        | `vrsub_vx`          | `vm, vs2, rs1, vd`   | `Vector Integer Reverse Subtract (Vector-Scalar)`                                                |
| `rv_v`        | `vs1r_v`            | `rs1, vs3`           | `Vector Store 1 Whole Register`                                                                  |
| `rv_v`        | `vs2r_v`            | `rs1, vs3`           | `Vector Store 2 Whole Registers`                                                                 |
| `rv_v`        | `vs4r_v`            | `rs1, vs3`           | `Vector Store 4 Whole Registers`                                                                 |
| `rv_v`        | `vs8r_v`            | `rs1, vs3`           | `Vector Store 8 Whole Registers`                                                                 |
| `rv_v`        | `vsaddu_vi`         | `vm, vs2, simm5, vd` | `Vector Integer Saturating Add Unsigned (Vector-Immediate)`                                      |
| `rv_v`        | `vsaddu_vv`         | `vm, vs2, vs1, vd`   | `Vector Integer Saturating Add Unsigned (Vector-Vector)`                                         |
| `rv_v`        | `vsaddu_vx`         | `vm, vs2, rs1, vd`   | `Vector Integer Saturating Add Unsigned (Vector-Scalar)`                                         |
| `rv_v`        | `vsadd_vi`          | `vm, vs2, simm5, vd` | `Vector Integer Saturating Add Signed (Vector-Immediate)`                                        |
| `rv_v`        | `vsadd_vv`          | `vm, vs2, vs1, vd`   | `Vector Integer Saturating Add Signed (Vector-Vector)`                                           |
| `rv_v`        | `vsadd_vx`          | `vm, vs2, rs1, vd`   | `Vector Integer Saturating Add Signed (Vector-Scalar)`                                           |
| `rv_v`        | `vsbc_vvm`          | `vs2, vs1, vd`       | `Vector Integer Subtract with Borrow (Vector-Vector with Mask Borrow Input)`                     |
| `rv_v`        | `vsbc_vxm`          | `vs2, rs1, vd`       | `Vector Integer Subtract with Borrow (Vector-Scalar with Mask Borrow Input)`                     |
| `rv_v`        | `vse16_v`           | `vm, rs1, vs3`       | `Vector Unit-Stride Store with 16-Bit Elements`                                                  |
| `rv_v`        | `vse32_v`           | `vm, rs1, vs3`       | `Vector Unit-Stride Store with 32-Bit Elements`                                                  |
| `rv_v`        | `vse64_v`           | `vm, rs1, vs3`       | `Vector Unit-Stride Store with 64-Bit Elements`                                                  |
| `rv_v`        | `vse8_v`            | `vm, rs1, vs3`       | `Vector Unit-Stride Store with 8-Bit Elements`                                                   |
| `rv_v`        | `vsetivli`          | `zimm10, zimm5, rd`  | `Set Vector Length and Immediate Vector Type with Immediate AVL`                                 |
| `rv_v`        | `vsetvl`            | `rs2, rs1, rd`       | `Set Vector Length and Register Vector Type`                                                     |
| `rv_v`        | `vsetvli`           | `zimm11, rs1, rd`    | `Set Vector Length and Immediate Vector Type`                                                    |
| `rv_v`        | `vsext_vf2`         | `vm, vs2, vd`        | `Vector Sign-Extend by Factor 2`                                                                 |
| `rv_v`        | `vsext_vf4`         | `vm, vs2, vd`        | `Vector Sign-Extend by Factor 4`                                                                 |
| `rv_v`        | `vsext_vf8`         | `vm, vs2, vd`        | `Vector Sign-Extend by Factor 8`                                                                 |
| `rv_v`        | `vslide1down_vx`    | `vm, vs2, rs1, vd`   | `Vector Slide One Down (Vector-Scalar)`                                                          |
| `rv_v`        | `vslide1up_vx`      | `vm, vs2, rs1, vd`   | `Vector Slide One Up (Vector-Scalar)`                                                            |
| `rv_v`        | `vslidedown_vi`     | `vm, vs2, zimm5, vd` | `Vector Slide Down (Vector-Immediate)`                                                           |
| `rv_v`        | `vslidedown_vx`     | `vm, vs2, rs1, vd`   | `Vector Slide Down (Vector-Scalar)`                                                              |
| `rv_v`        | `vslideup_vi`       | `vm, vs2, zimm5, vd` | `Vector Slide Up (Vector-Immediate)`                                                             |
| `rv_v`        | `vslideup_vx`       | `vm, vs2, rs1, vd`   | `Vector Slide Up (Vector-Scalar)`                                                                |
| `rv_v`        | `vsll_vi`           | `vm, vs2, zimm5, vd` | `Vector Shift Left Logical (Vector-Immediate)`                                                   |
| `rv_v`        | `vsll_vv`           | `vm, vs2, vs1, vd`   | `Vector Shift Left Logical (Vector-Vector)`                                                      |
| `rv_v`        | `vsll_vx`           | `vm, vs2, rs1, vd`   | `Vector Shift Left Logical (Vector-Scalar)`                                                      |
| `rv_v`        | `vsmul_vv`          | `vm, vs2, vs1, vd`   | `Vector Signed Fractional Multiply with Rounding and Saturation (Vector-Vector)`                 |
| `rv_v`        | `vsmul_vx`          | `vm, vs2, rs1, vd`   | `Vector Signed Fractional Multiply with Rounding and Saturation (Vector-Scalar)`                 |
| `rv_v`        | `vsm_v`             | `rs1, vs3`           | `Vector Mask Store`                                                                              |
| `rv_v`        | `vsoxei16_v`        | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Store with 16-Bit Indices`                                               |
| `rv_v`        | `vsoxei32_v`        | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Store with 32-Bit Indices`                                               |
| `rv_v`        | `vsoxei64_v`        | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Store with 64-Bit Indices`                                               |
| `rv_v`        | `vsoxei8_v`         | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Store with 8-Bit Indices`                                                |
| `rv_v`        | `vsoxseg2ei16_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 2 Fields with 16-Bit Indices`                           |
| `rv_v`        | `vsoxseg2ei32_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 2 Fields with 32-Bit Indices`                           |
| `rv_v`        | `vsoxseg2ei64_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 2 Fields with 64-Bit Indices`                           |
| `rv_v`        | `vsoxseg2ei8_v`     | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 2 Fields with 8-Bit Indices`                            |
| `rv_v`        | `vsoxseg3ei16_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 3 Fields with 16-Bit Indices`                           |
| `rv_v`        | `vsoxseg3ei32_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 3 Fields with 32-Bit Indices`                           |
| `rv_v`        | `vsoxseg3ei64_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 3 Fields with 64-Bit Indices`                           |
| `rv_v`        | `vsoxseg3ei8_v`     | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 3 Fields with 8-Bit Indices`                            |
| `rv_v`        | `vsoxseg4ei16_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 4 Fields with 16-Bit Indices`                           |
| `rv_v`        | `vsoxseg4ei32_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 4 Fields with 32-Bit Indices`                           |
| `rv_v`        | `vsoxseg4ei64_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 4 Fields with 64-Bit Indices`                           |
| `rv_v`        | `vsoxseg4ei8_v`     | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 4 Fields with 8-Bit Indices`                            |
| `rv_v`        | `vsoxseg5ei16_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 5 Fields with 16-Bit Indices`                           |
| `rv_v`        | `vsoxseg5ei32_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 5 Fields with 32-Bit Indices`                           |
| `rv_v`        | `vsoxseg5ei64_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 5 Fields with 64-Bit Indices`                           |
| `rv_v`        | `vsoxseg5ei8_v`     | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 5 Fields with 8-Bit Indices`                            |
| `rv_v`        | `vsoxseg6ei16_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 6 Fields with 16-Bit Indices`                           |
| `rv_v`        | `vsoxseg6ei32_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 6 Fields with 32-Bit Indices`                           |
| `rv_v`        | `vsoxseg6ei64_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 6 Fields with 64-Bit Indices`                           |
| `rv_v`        | `vsoxseg6ei8_v`     | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 6 Fields with 8-Bit Indices`                            |
| `rv_v`        | `vsoxseg7ei16_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 7 Fields with 16-Bit Indices`                           |
| `rv_v`        | `vsoxseg7ei32_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 7 Fields with 32-Bit Indices`                           |
| `rv_v`        | `vsoxseg7ei64_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 7 Fields with 64-Bit Indices`                           |
| `rv_v`        | `vsoxseg7ei8_v`     | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 7 Fields with 8-Bit Indices`                            |
| `rv_v`        | `vsoxseg8ei16_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 8 Fields with 16-Bit Indices`                           |
| `rv_v`        | `vsoxseg8ei32_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 8 Fields with 32-Bit Indices`                           |
| `rv_v`        | `vsoxseg8ei64_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 8 Fields with 64-Bit Indices`                           |
| `rv_v`        | `vsoxseg8ei8_v`     | `vm, vs2, rs1, vs3`  | `Vector Indexed-Ordered Segment Store of 8 Fields with 8-Bit Indices`                            |
| `rv_v`        | `vsra_vi`           | `vm, vs2, zimm5, vd` | `Vector Shift Right Arithmetic (Vector-Immediate)`                                               |
| `rv_v`        | `vsra_vv`           | `vm, vs2, vs1, vd`   | `Vector Shift Right Arithmetic (Vector-Vector)`                                                  |
| `rv_v`        | `vsra_vx`           | `vm, vs2, rs1, vd`   | `Vector Shift Right Arithmetic (Vector-Scalar)`                                                  |
| `rv_v`        | `vsrl_vi`           | `vm, vs2, zimm5, vd` | `Vector Shift Right Logical (Vector-Immediate)`                                                  |
| `rv_v`        | `vsrl_vv`           | `vm, vs2, vs1, vd`   | `Vector Shift Right Logical (Vector-Vector)`                                                     |
| `rv_v`        | `vsrl_vx`           | `vm, vs2, rs1, vd`   | `Vector Shift Right Logical (Vector-Scalar)`                                                     |
| `rv_v`        | `vsse16_v`          | `vm, rs2, rs1, vs3`  | `Vector Strided Store with 16-Bit Elements`                                                      |
| `rv_v`        | `vsse32_v`          | `vm, rs2, rs1, vs3`  | `Vector Strided Store with 32-Bit Elements`                                                      |
| `rv_v`        | `vsse64_v`          | `vm, rs2, rs1, vs3`  | `Vector Strided Store with 64-Bit Elements`                                                      |
| `rv_v`        | `vsse8_v`           | `vm, rs2, rs1, vs3`  | `Vector Strided Store with 8-Bit Elements`                                                       |
| `rv_v`        | `vsseg2e16_v`       | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 2 Fields with 16-Bit Elements`                              |
| `rv_v`        | `vsseg2e32_v`       | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 2 Fields with 32-Bit Elements`                              |
| `rv_v`        | `vsseg2e64_v`       | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 2 Fields with 64-Bit Elements`                              |
| `rv_v`        | `vsseg2e8_v`        | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 2 Fields with 8-Bit Elements`                               |
| `rv_v`        | `vsseg3e16_v`       | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 3 Fields with 16-Bit Elements`                              |
| `rv_v`        | `vsseg3e32_v`       | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 3 Fields with 32-Bit Elements`                              |
| `rv_v`        | `vsseg3e64_v`       | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 3 Fields with 64-Bit Elements`                              |
| `rv_v`        | `vsseg3e8_v`        | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 3 Fields with 8-Bit Elements`                               |
| `rv_v`        | `vsseg4e16_v`       | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 4 Fields with 16-Bit Elements`                              |
| `rv_v`        | `vsseg4e32_v`       | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 4 Fields with 32-Bit Elements`                              |
| `rv_v`        | `vsseg4e64_v`       | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 4 Fields with 64-Bit Elements`                              |
| `rv_v`        | `vsseg4e8_v`        | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 4 Fields with 8-Bit Elements`                               |
| `rv_v`        | `vsseg5e16_v`       | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 5 Fields with 16-Bit Elements`                              |
| `rv_v`        | `vsseg5e32_v`       | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 5 Fields with 32-Bit Elements`                              |
| `rv_v`        | `vsseg5e64_v`       | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 5 Fields with 64-Bit Elements`                              |
| `rv_v`        | `vsseg5e8_v`        | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 5 Fields with 8-Bit Elements`                               |
| `rv_v`        | `vsseg6e16_v`       | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 6 Fields with 16-Bit Elements`                              |
| `rv_v`        | `vsseg6e32_v`       | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 6 Fields with 32-Bit Elements`                              |
| `rv_v`        | `vsseg6e64_v`       | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 6 Fields with 64-Bit Elements`                              |
| `rv_v`        | `vsseg6e8_v`        | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 6 Fields with 8-Bit Elements`                               |
| `rv_v`        | `vsseg7e16_v`       | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 7 Fields with 16-Bit Elements`                              |
| `rv_v`        | `vsseg7e32_v`       | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 7 Fields with 32-Bit Elements`                              |
| `rv_v`        | `vsseg7e64_v`       | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 7 Fields with 64-Bit Elements`                              |
| `rv_v`        | `vsseg7e8_v`        | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 7 Fields with 8-Bit Elements`                               |
| `rv_v`        | `vsseg8e16_v`       | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 8 Fields with 16-Bit Elements`                              |
| `rv_v`        | `vsseg8e32_v`       | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 8 Fields with 32-Bit Elements`                              |
| `rv_v`        | `vsseg8e64_v`       | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 8 Fields with 64-Bit Elements`                              |
| `rv_v`        | `vsseg8e8_v`        | `vm, rs1, vs3`       | `Vector Unit-Stride Segment Store of 8 Fields with 8-Bit Elements`                               |
| `rv_v`        | `vssra_vi`          | `vm, vs2, zimm5, vd` | `Vector Scaling Shift Right Signed (Vector-Immediate)`                                           |
| `rv_v`        | `vssra_vv`          | `vm, vs2, vs1, vd`   | `Vector Scaling Shift Right Signed (Vector-Vector)`                                              |
| `rv_v`        | `vssra_vx`          | `vm, vs2, rs1, vd`   | `Vector Scaling Shift Right Signed (Vector-Scalar)`                                              |
| `rv_v`        | `vssrl_vi`          | `vm, vs2, zimm5, vd` | `Vector Scaling Shift Right Unsigned (Vector-Immediate)`                                         |
| `rv_v`        | `vssrl_vv`          | `vm, vs2, vs1, vd`   | `Vector Scaling Shift Right Unsigned (Vector-Vector)`                                            |
| `rv_v`        | `vssrl_vx`          | `vm, vs2, rs1, vd`   | `Vector Scaling Shift Right Unsigned (Vector-Scalar)`                                            |
| `rv_v`        | `vssseg2e16_v`      | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 2 Fields with 16-Bit Elements`                                  |
| `rv_v`        | `vssseg2e32_v`      | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 2 Fields with 32-Bit Elements`                                  |
| `rv_v`        | `vssseg2e64_v`      | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 2 Fields with 64-Bit Elements`                                  |
| `rv_v`        | `vssseg2e8_v`       | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 2 Fields with 8-Bit Elements`                                   |
| `rv_v`        | `vssseg3e16_v`      | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 3 Fields with 16-Bit Elements`                                  |
| `rv_v`        | `vssseg3e32_v`      | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 3 Fields with 32-Bit Elements`                                  |
| `rv_v`        | `vssseg3e64_v`      | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 3 Fields with 64-Bit Elements`                                  |
| `rv_v`        | `vssseg3e8_v`       | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 3 Fields with 8-Bit Elements`                                   |
| `rv_v`        | `vssseg4e16_v`      | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 4 Fields with 16-Bit Elements`                                  |
| `rv_v`        | `vssseg4e32_v`      | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 4 Fields with 32-Bit Elements`                                  |
| `rv_v`        | `vssseg4e64_v`      | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 4 Fields with 64-Bit Elements`                                  |
| `rv_v`        | `vssseg4e8_v`       | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 4 Fields with 8-Bit Elements`                                   |
| `rv_v`        | `vssseg5e16_v`      | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 5 Fields with 16-Bit Elements`                                  |
| `rv_v`        | `vssseg5e32_v`      | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 5 Fields with 32-Bit Elements`                                  |
| `rv_v`        | `vssseg5e64_v`      | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 5 Fields with 64-Bit Elements`                                  |
| `rv_v`        | `vssseg5e8_v`       | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 5 Fields with 8-Bit Elements`                                   |
| `rv_v`        | `vssseg6e16_v`      | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 6 Fields with 16-Bit Elements`                                  |
| `rv_v`        | `vssseg6e32_v`      | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 6 Fields with 32-Bit Elements`                                  |
| `rv_v`        | `vssseg6e64_v`      | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 6 Fields with 64-Bit Elements`                                  |
| `rv_v`        | `vssseg6e8_v`       | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 6 Fields with 8-Bit Elements`                                   |
| `rv_v`        | `vssseg7e16_v`      | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 7 Fields with 16-Bit Elements`                                  |
| `rv_v`        | `vssseg7e32_v`      | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 7 Fields with 32-Bit Elements`                                  |
| `rv_v`        | `vssseg7e64_v`      | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 7 Fields with 64-Bit Elements`                                  |
| `rv_v`        | `vssseg7e8_v`       | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 7 Fields with 8-Bit Elements`                                   |
| `rv_v`        | `vssseg8e16_v`      | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 8 Fields with 16-Bit Elements`                                  |
| `rv_v`        | `vssseg8e32_v`      | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 8 Fields with 32-Bit Elements`                                  |
| `rv_v`        | `vssseg8e64_v`      | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 8 Fields with 64-Bit Elements`                                  |
| `rv_v`        | `vssseg8e8_v`       | `vm, rs2, rs1, vs3`  | `Vector Strided Segment Store of 8 Fields with 8-Bit Elements`                                   |
| `rv_v`        | `vssubu_vv`         | `vm, vs2, vs1, vd`   | `Vector Integer Saturating Subtract Unsigned (Vector-Vector)`                                    |
| `rv_v`        | `vssubu_vx`         | `vm, vs2, rs1, vd`   | `Vector Integer Saturating Subtract Unsigned (Vector-Scalar)`                                    |
| `rv_v`        | `vssub_vv`          | `vm, vs2, vs1, vd`   | `Vector Integer Saturating Subtract Signed (Vector-Vector)`                                      |
| `rv_v`        | `vssub_vx`          | `vm, vs2, rs1, vd`   | `Vector Integer Saturating Subtract Signed (Vector-Scalar)`                                      |
| `rv_v`        | `vsub_vv`           | `vm, vs2, vs1, vd`   | `Vector Integer Subtract (Vector-Vector)`                                                        |
| `rv_v`        | `vsub_vx`           | `vm, vs2, rs1, vd`   | `Vector Integer Subtract (Vector-Scalar)`                                                        |
| `rv_v`        | `vsuxei16_v`        | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Store with 16-Bit Indices`                                             |
| `rv_v`        | `vsuxei32_v`        | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Store with 32-Bit Indices`                                             |
| `rv_v`        | `vsuxei64_v`        | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Store with 64-Bit Indices`                                             |
| `rv_v`        | `vsuxei8_v`         | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Store with 8-Bit Indices`                                              |
| `rv_v`        | `vsuxseg2ei16_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 2 Fields with 16-Bit Indices`                         |
| `rv_v`        | `vsuxseg2ei32_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 2 Fields with 32-Bit Indices`                         |
| `rv_v`        | `vsuxseg2ei64_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 2 Fields with 64-Bit Indices`                         |
| `rv_v`        | `vsuxseg2ei8_v`     | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 2 Fields with 8-Bit Indices`                          |
| `rv_v`        | `vsuxseg3ei16_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 3 Fields with 16-Bit Indices`                         |
| `rv_v`        | `vsuxseg3ei32_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 3 Fields with 32-Bit Indices`                         |
| `rv_v`        | `vsuxseg3ei64_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 3 Fields with 64-Bit Indices`                         |
| `rv_v`        | `vsuxseg3ei8_v`     | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 3 Fields with 8-Bit Indices`                          |
| `rv_v`        | `vsuxseg4ei16_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 4 Fields with 16-Bit Indices`                         |
| `rv_v`        | `vsuxseg4ei32_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 4 Fields with 32-Bit Indices`                         |
| `rv_v`        | `vsuxseg4ei64_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 4 Fields with 64-Bit Indices`                         |
| `rv_v`        | `vsuxseg4ei8_v`     | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 4 Fields with 8-Bit Indices`                          |
| `rv_v`        | `vsuxseg5ei16_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 5 Fields with 16-Bit Indices`                         |
| `rv_v`        | `vsuxseg5ei32_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 5 Fields with 32-Bit Indices`                         |
| `rv_v`        | `vsuxseg5ei64_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 5 Fields with 64-Bit Indices`                         |
| `rv_v`        | `vsuxseg5ei8_v`     | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 5 Fields with 8-Bit Indices`                          |
| `rv_v`        | `vsuxseg6ei16_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 6 Fields with 16-Bit Indices`                         |
| `rv_v`        | `vsuxseg6ei32_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 6 Fields with 32-Bit Indices`                         |
| `rv_v`        | `vsuxseg6ei64_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 6 Fields with 64-Bit Indices`                         |
| `rv_v`        | `vsuxseg6ei8_v`     | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 6 Fields with 8-Bit Indices`                          |
| `rv_v`        | `vsuxseg7ei16_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 7 Fields with 16-Bit Indices`                         |
| `rv_v`        | `vsuxseg7ei32_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 7 Fields with 32-Bit Indices`                         |
| `rv_v`        | `vsuxseg7ei64_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 7 Fields with 64-Bit Indices`                         |
| `rv_v`        | `vsuxseg7ei8_v`     | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 7 Fields with 8-Bit Indices`                          |
| `rv_v`        | `vsuxseg8ei16_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 8 Fields with 16-Bit Indices`                         |
| `rv_v`        | `vsuxseg8ei32_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 8 Fields with 32-Bit Indices`                         |
| `rv_v`        | `vsuxseg8ei64_v`    | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 8 Fields with 64-Bit Indices`                         |
| `rv_v`        | `vsuxseg8ei8_v`     | `vm, vs2, rs1, vs3`  | `Vector Indexed-Unordered Segment Store of 8 Fields with 8-Bit Indices`                          |
| `rv_v`        | `vwaddu_vv`         | `vm, vs2, vs1, vd`   | `Vector Widening Integer Add Unsigned (Vector-Vector)`                                           |
| `rv_v`        | `vwaddu_vx`         | `vm, vs2, rs1, vd`   | `Vector Widening Integer Add Unsigned (Vector-Scalar)`                                           |
| `rv_v`        | `vwaddu_wv`         | `vm, vs2, vs1, vd`   | `Vector Widening Integer Add Unsigned (Wide Vector-Vector)`                                      |
| `rv_v`        | `vwaddu_wx`         | `vm, vs2, rs1, vd`   | `Vector Widening Integer Add Unsigned (Wide Vector-Scalar)`                                      |
| `rv_v`        | `vwadd_vv`          | `vm, vs2, vs1, vd`   | `Vector Widening Integer Add Signed (Vector-Vector)`                                             |
| `rv_v`        | `vwadd_vx`          | `vm, vs2, rs1, vd`   | `Vector Widening Integer Add Signed (Vector-Scalar)`                                             |
| `rv_v`        | `vwadd_wv`          | `vm, vs2, vs1, vd`   | `Vector Widening Integer Add Signed (Wide Vector-Vector)`                                        |
| `rv_v`        | `vwadd_wx`          | `vm, vs2, rs1, vd`   | `Vector Widening Integer Add Signed (Wide Vector-Scalar)`                                        |
| `rv_v`        | `vwmaccsu_vv`       | `vm, vs2, vs1, vd`   | `Vector Widening Signed-Unsigned Integer Multiply-Accumulate (Vector-Vector)`                    |
| `rv_v`        | `vwmaccsu_vx`       | `vm, vs2, rs1, vd`   | `Vector Widening Signed-Unsigned Integer Multiply-Accumulate (Vector-Scalar)`                    |
| `rv_v`        | `vwmaccus_vx`       | `vm, vs2, rs1, vd`   | `Vector Widening Unsigned-Signed Integer Multiply-Accumulate (Vector-Scalar)`                    |
| `rv_v`        | `vwmaccu_vv`        | `vm, vs2, vs1, vd`   | `Vector Widening Unsigned Integer Multiply-Accumulate (Vector-Vector)`                           |
| `rv_v`        | `vwmaccu_vx`        | `vm, vs2, rs1, vd`   | `Vector Widening Unsigned Integer Multiply-Accumulate (Vector-Scalar)`                           |
| `rv_v`        | `vwmacc_vv`         | `vm, vs2, vs1, vd`   | `Vector Widening Signed Integer Multiply-Accumulate (Vector-Vector)`                             |
| `rv_v`        | `vwmacc_vx`         | `vm, vs2, rs1, vd`   | `Vector Widening Signed Integer Multiply-Accumulate (Vector-Scalar)`                             |
| `rv_v`        | `vwmulsu_vv`        | `vm, vs2, vs1, vd`   | `Vector Widening Integer Multiply Signed-Unsigned (Vector-Vector)`                               |
| `rv_v`        | `vwmulsu_vx`        | `vm, vs2, rs1, vd`   | `Vector Widening Integer Multiply Signed-Unsigned (Vector-Scalar)`                               |
| `rv_v`        | `vwmulu_vv`         | `vm, vs2, vs1, vd`   | `Vector Widening Integer Multiply Unsigned (Vector-Vector)`                                      |
| `rv_v`        | `vwmulu_vx`         | `vm, vs2, rs1, vd`   | `Vector Widening Integer Multiply Unsigned (Vector-Scalar)`                                      |
| `rv_v`        | `vwmul_vv`          | `vm, vs2, vs1, vd`   | `Vector Widening Integer Multiply Signed (Vector-Vector)`                                        |
| `rv_v`        | `vwmul_vx`          | `vm, vs2, rs1, vd`   | `Vector Widening Integer Multiply Signed (Vector-Scalar)`                                        |
| `rv_v`        | `vwredsumu_vs`      | `vm, vs2, vs1, vd`   | `Vector Widening Integer Sum Unsigned Reduction`                                                 |
| `rv_v`        | `vwredsum_vs`       | `vm, vs2, vs1, vd`   | `Vector Widening Integer Sum Reduction`                                                          |
| `rv_v`        | `vwsubu_vv`         | `vm, vs2, vs1, vd`   | `Vector Widening Integer Subtract Unsigned (Vector-Vector)`                                      |
| `rv_v`        | `vwsubu_vx`         | `vm, vs2, rs1, vd`   | `Vector Widening Integer Subtract Unsigned (Vector-Scalar)`                                      |
| `rv_v`        | `vwsubu_wv`         | `vm, vs2, vs1, vd`   | `Vector Widening Integer Subtract Unsigned (Wide Vector-Vector)`                                 |
| `rv_v`        | `vwsubu_wx`         | `vm, vs2, rs1, vd`   | `Vector Widening Integer Subtract Unsigned (Wide Vector-Scalar)`                                 |
| `rv_v`        | `vwsub_vv`          | `vm, vs2, vs1, vd`   | `Vector Widening Integer Subtract Signed (Vector-Vector)`                                        |
| `rv_v`        | `vwsub_vx`          | `vm, vs2, rs1, vd`   | `Vector Widening Integer Subtract Signed (Vector-Scalar)`                                        |
| `rv_v`        | `vwsub_wv`          | `vm, vs2, vs1, vd`   | `Vector Widening Integer Subtract Signed (Wide Vector-Vector)`                                   |
| `rv_v`        | `vwsub_wx`          | `vm, vs2, rs1, vd`   | `Vector Widening Integer Subtract Signed (Wide Vector-Scalar)`                                   |
| `rv_v`        | `vxor_vi`           | `vm, vs2, simm5, vd` | `Vector Bitwise XOR (Vector-Immediate)`                                                          |
| `rv_v`        | `vxor_vv`           | `vm, vs2, vs1, vd`   | `Vector Bitwise XOR (Vector-Vector)`                                                             |
| `rv_v`        | `vxor_vx`           | `vm, vs2, rs1, vd`   | `Vector Bitwise XOR (Vector-Scalar)`                                                             |
| `rv_v`        | `vzext_vf2`         | `vm, vs2, vd`        | `Vector Zero-Extend by Factor 2`                                                                 |
| `rv_v`        | `vzext_vf4`         | `vm, vs2, vd`        | `Vector Zero-Extend by Factor 4`                                                                 |
| `rv_v`        | `vzext_vf8`         | `vm, vs2, vd`        | `Vector Zero-Extend by Factor 8`                                                                 |

:RVV - Specific Extension for Vector Operations

| **Extension**      | **Name**               | **Variable-Fields**             | **Full-Name**                                                                      |
|:-------------------|:-----------------------|:--------------------------------|:-----------------------------------------------------------------------------------|
| `rv_zvabd`         | `vabdu_vv`             | `vm, vs2, vs1, vd`              | `Vector Unsigned Absolute Difference (Vector-Vector)`                              |
| `rv_zvabd`         | `vabdu_vx`             | `vm, vs2, rs1, vd`              | `Vector Unsigned Absolute Difference (Vector-Scalar)`                              |
| `rv_zvabd`         | `vabd_vv`              | `vm, vs2, vs1, vd`              | `Vector Signed Absolute Difference (Vector-Vector)`                                |
| `rv_zvabd`         | `vabd_vx`              | `vm, vs2, rs1, vd`              | `Vector Signed Absolute Difference (Vector-Scalar)`                                |
| `rv_zvabd`         | `vwabdau_vv`           | `vm, vs2, vs1, vd`              | `Vector Widening Unsigned Absolute Difference Accumulate (Vector-Vector)`          |
| `rv_zvabd`         | `vwabdau_vx`           | `vm, vs2, rs1, vd`              | `Vector Widening Unsigned Absolute Difference Accumulate (Vector-Scalar)`          |
| `rv_zvabd`         | `vwabda_vv`            | `vm, vs2, vs1, vd`              | `Vector Widening Signed Absolute Difference Accumulate (Vector-Vector)`            |
| `rv_zvabd`         | `vwabda_vx`            | `vm, vs2, rs1, vd`              | `Vector Widening Signed Absolute Difference Accumulate (Vector-Scalar)`            |
| `rv_zvbb`          | `vandn_vv`             | `vm, vs2, vs1, vd`              | `Vector And-Not (Vector-Vector)`                                                   |
| `rv_zvbb`          | `vandn_vx`             | `vm, vs2, rs1, vd`              | `Vector And-Not (Vector-Scalar)`                                                   |
| `rv_zvbb`          | `vbrev8_v`             | `vm, vs2, vd`                   | `Vector Reverse Bits in Bytes (Vector)`                                            |
| `rv_zvbb`          | `vbrev_v`              | `vm, vs2, vd`                   | `Vector Reverse Bits in Elements (Vector)`                                         |
| `rv_zvbb`          | `vclz_v`               | `vm, vs2, vd`                   | `Vector Count Leading Zeros (Vector)`                                              |
| `rv_zvbb`          | `vcpop_v`              | `vm, vs2, vd`                   | `Vector Population Count (Vector)`                                                 |
| `rv_zvbb`          | `vctz_v`               | `vm, vs2, vd`                   | `Vector Count Trailing Zeros (Vector)`                                             |
| `rv_zvbb`          | `vrev8_v`              | `vm, vs2, vd`                   | `Vector Reverse Bytes (Vector)`                                                    |
| `rv_zvbb`          | `vrol_vv`              | `vm, vs2, vs1, vd`              | `Vector Rotate Left (Vector-Vector)`                                               |
| `rv_zvbb`          | `vrol_vx`              | `vm, vs2, rs1, vd`              | `Vector Rotate Left (Vector-Scalar)`                                               |
| `rv_zvbb`          | `vror_vi`              | `zimm6hi, vm, vs2, zimm6lo, vd` | `Vector Rotate Right (Vector-Immediate)`                                           |
| `rv_zvbb`          | `vror_vv`              | `vm, vs2, vs1, vd`              | `Vector Rotate Right (Vector-Vector)`                                              |
| `rv_zvbb`          | `vror_vx`              | `vm, vs2, rs1, vd`              | `Vector Rotate Right (Vector-Scalar)`                                              |
| `rv_zvbb`          | `vwsll_vi`             | `vm, vs2, zimm5, vd`            | `Vector Widening Shift Left Logical (Vector-Immediate)`                            |
| `rv_zvbb`          | `vwsll_vv`             | `vm, vs2, vs1, vd`              | `Vector Widening Shift Left Logical (Vector-Vector)`                               |
| `rv_zvbb`          | `vwsll_vx`             | `vm, vs2, rs1, vd`              | `Vector Widening Shift Left Logical (Vector-Scalar)`                               |
| `rv_zvbc`          | `vclmulh_vv`           | `vm, vs2, vs1, vd`              | `Vector Carry-Less Multiply High (Vector-Vector)`                                  |
| `rv_zvbc`          | `vclmulh_vx`           | `vm, vs2, rs1, vd`              | `Vector Carry-Less Multiply High (Vector-Scalar)`                                  |
| `rv_zvbc`          | `vclmul_vv`            | `vm, vs2, vs1, vd`              | `Vector Carry-Less Multiply Low (Vector-Vector)`                                   |
| `rv_zvbc`          | `vclmul_vx`            | `vm, vs2, rs1, vd`              | `Vector Carry-Less Multiply Low (Vector-Scalar)`                                   |
| `rv_zvdot4a`       | `vdot4asu_vv`          | `vm, vs2, vs1, vd`              | `Vector Packed 8-Bit Dot Product Accumulate (Signed × Unsigned) (Vector-Vector)`   |
| `rv_zvdot4a`       | `vdot4asu_vx`          | `vm, vs2, rs1, vd`              | `Vector Packed 8-Bit Dot Product Accumulate (Signed × Unsigned) (Vector-Scalar)`   |
| `rv_zvdot4a`       | `vdot4aus_vx`          | `vm, vs2, rs1, vd`              | `Vector Packed 8-Bit Dot Product Accumulate (Unsigned × Signed) (Vector-Scalar)`   |
| `rv_zvdot4a`       | `vdot4au_vv`           | `vm, vs2, vs1, vd`              | `Vector Packed 8-Bit Dot Product Accumulate (Unsigned × Unsigned) (Vector-Vector)` |
| `rv_zvdot4a`       | `vdot4au_vx`           | `vm, vs2, rs1, vd`              | `Vector Packed 8-Bit Dot Product Accumulate (Unsigned × Unsigned) (Vector-Scalar)` |
| `rv_zvdot4a`       | `vdot4a_vv`            | `vm, vs2, vs1, vd`              | `Vector Packed 8-Bit Dot Product Accumulate (Signed × Signed) (Vector-Vector)`     |
| `rv_zvdot4a`       | `vdot4a_vx`            | `vm, vs2, rs1, vd`              | `Vector Packed 8-Bit Dot Product Accumulate (Signed × Signed) (Vector-Scalar)`     |
| `rv_zvfbdota32f`   | `vfbdota_vv`           | `vm, vs2x8, ci, vs1, vd`        | `Vector Batched FP32 Dot Product Accumulate`                                       |
| `rv_zvfbfmin`      | `vfncvtbf16_f_f_w`     | `vm, vs2, vd`                   | `Vector FP32 to BF16 Conversion`                                                   |
| `rv_zvfbfmin`      | `vfwcvtbf16_f_f_v`     | `vm, vs2, vd`                   | `Vector BF16 to FP32 Conversion`                                                   |
| `rv_zvfbfwma`      | `vfwmaccbf16_vf`       | `vm, vs2, rs1, vd`              | `Vector BF16 Widening Fused Multiply-Accumulate (Vector-Scalar)`                   |
| `rv_zvfbfwma`      | `vfwmaccbf16_vv`       | `vm, vs2, vs1, vd`              | `Vector BF16 Widening Fused Multiply-Accumulate (Vector-Vector)`                   |
| `rv_zvfofp4min`    | `vfext_vf2`            | `vm, vs2, vd`                   | `Vector E2M1 to E4M3 Conversion`                                                   |
| `rv_zvfofp8min`    | `vfncvtbf16_sat_f_f_w` | `vm, vs2, vd`                   | `Vector BF16 to OFP8 Saturating Conversion`                                        |
| `rv_zvfofp8min`    | `vfncvt_f_f_q`         | `vm, vs2, vd`                   | `Vector FP32 to OFP8 Conversion`                                                   |
| `rv_zvfofp8min`    | `vfncvt_sat_f_f_q`     | `vm, vs2, vd`                   | `Vector FP32 to OFP8 Saturating Conversion`                                        |
| `rv_zvfqwbdota8f`  | `vfqwbdota_alt_vv`     | `vm, vs2x8, ci, vs1, vd`        | `Vector Batched OFP8 Dot Product Accumulate (E5M2 Source 2)`                       |
| `rv_zvfqwbdota8f`  | `vfqwbdota_vv`         | `vm, vs2x8, ci, vs1, vd`        | `Vector Batched OFP8 Dot Product Accumulate (E4M3 Source 2)`                       |
| `rv_zvfqwdota8f`   | `vfqwdota_alt_vv`      | `vm, vs2, vs1, vd`              | `Vector Long OFP8 Dot Product Accumulate (E5M2 Source 2)`                          |
| `rv_zvfqwdota8f`   | `vfqwdota_vv`          | `vm, vs2, vs1, vd`              | `Vector Long OFP8 Dot Product Accumulate (E4M3 Source 2)`                          |
| `rv_zvfwbdota16bf` | `vfwbdota_vv`          | `vm, vs2x8, ci, vs1, vd`        | `Vector Batched BF16 Dot Product Accumulate`                                       |
| `rv_zvfwdota16bf`  | `vfwdota_vv`           | `vm, vs2, vs1, vd`              | `Vector Long BF16 Dot Product Accumulate`                                          |
| `rv_zvqwbdota8i`   | `vqwbdotas_vv`         | `vm, vs2x8, ci, vs1, vd`        | `Vector Batched 8-Bit Integer Dot Product Accumulate (Signed Source 2)`            |
| `rv_zvqwbdota8i`   | `vqwbdotau_vv`         | `vm, vs2x8, ci, vs1, vd`        | `Vector Batched 8-Bit Integer Dot Product Accumulate (Unsigned Source 2)`          |
| `rv_zvqwdota8i`    | `vqwdotas_vv`          | `vm, vs2, vs1, vd`              | `Vector Long 8-Bit Integer Dot Product Accumulate (Signed Source 2)`               |
| `rv_zvqwdota8i`    | `vqwdotau_vv`          | `vm, vs2, vs1, vd`              | `Vector Long 8-Bit Integer Dot Product Accumulate (Unsigned Source 2)`             |
| `rv_zvt16e`        | `vtle16`               | `rs2, rs1`                      | `Load 16-Bit Matrix Tile Elements`                                                 |
| `rv_zvt16e`        | `vtse16`               | `rs2, rs1`                      | `Store 16-Bit Matrix Tile Elements`                                                |
| `rv_zvt64e`        | `vtle64`               | `rs2, rs1`                      | `Load 64-Bit Matrix Tile Elements`                                                 |
| `rv_zvt64e`        | `vtse64`               | `rs2, rs1`                      | `Store 64-Bit Matrix Tile Elements`                                                |
| `rv_zvt8e`         | `vtle8`                | `rs2, rs1`                      | `Load 8-Bit Matrix Tile Elements`                                                  |
| `rv_zvt8e`         | `vtse8`                | `rs2, rs1`                      | `Store 8-Bit Matrix Tile Elements`                                                 |
| `rv_zvtbase`       | `msetmtype`            | `rs2, rs1, rd`                  | `Set Matrix and Vector Types`                                                      |
| `rv_zvtbase`       | `msetmtypei`           | `altfmt, vsew, mtwiden, rd`     | `Set Matrix and Vector Types from Immediates`                                      |
| `rv_zvtbase`       | `msettk`               | `rs1, rd`                       | `Set Matrix Reduction Width`                                                       |
| `rv_zvtbase`       | `msettm`               | `rs1, rd`                       | `Set Matrix Row Count`                                                             |
| `rv_zvtbase`       | `msettn`               | `rs1, rd`                       | `Set Matrix Column Count`                                                          |
| `rv_zvtbase`       | `vtdiscard`            | `none`                          | `Discard Matrix Tile Context`                                                      |
| `rv_zvtbase`       | `vtle32`               | `rs2, rs1`                      | `Load 32-Bit Matrix Tile Elements`                                                 |
| `rv_zvtbase`       | `vtmv_t_v`             | `vs2, rs1`                      | `Move Vector to Matrix Tile Subset`                                                |
| `rv_zvtbase`       | `vtmv_v_t`             | `rs1, vd`                       | `Move Matrix Tile Subset to Vector`                                                |
| `rv_zvtbase`       | `vtse32`               | `rs2, rs1`                      | `Store 32-Bit Matrix Tile Elements`                                                |
| `rv_zvtbase`       | `vtzero`               | `zvt_mtd16`                     | `Zero Matrix Tile Region`                                                          |
| `rv_zvtbf16fmm`    | `vtfmm_alt_tvv`        | `vs2, vs1, zvt_mtd8`            | `BF16 Matrix Tile Multiply-Accumulate (Alternate)`                                 |
| `rv_zvtdmm`        | `vtfmm_tvv`            | `vs2, vs1, zvt_mtd8`            | `FP64 Matrix Tile Multiply-Accumulate`                                             |
| `rv_zvtfmm`        | `vtfmm_tvv`            | `vs2, vs1, zvt_mtd8`            | `FP32 Matrix Tile Multiply-Accumulate`                                             |
| `rv_zvtfp16fmm`    | `vtfmm_tvv`            | `vs2, vs1, zvt_mtd8`            | `FP16 Matrix Tile Multiply-Accumulate`                                             |
| `rv_zvti8i32mm`    | `vtmms_tvv`            | `vs2, vs1, zvt_mtd8`            | `Signed 8-Bit Matrix Tile Multiply-Accumulate`                                     |
| `rv_zvti8i32mm`    | `vtmmu_tvv`            | `vs2, vs1, zvt_mtd8`            | `Unsigned 8-Bit Matrix Tile Multiply-Accumulate`                                   |
| `rv_zvtofp8fmm`    | `vtfmm_alt_tvv`        | `vs2, vs1, zvt_mtd8`            | `OFP8 Matrix Tile Multiply-Accumulate (Alternate)`                                 |
| `rv_zvtofp8fmm`    | `vtfmm_tvv`            | `vs2, vs1, zvt_mtd8`            | `OFP8 Matrix Tile Multiply-Accumulate`                                             |
| `rv_zvzip`         | `vpaire_vv`            | `vm, vs2, vs1, vd`              | `Vector Interleave Even Elements (Vector-Vector)`                                  |
| `rv_zvzip`         | `vpairo_vv`            | `vm, vs2, vs1, vd`              | `Vector Interleave Odd Elements (Vector-Vector)`                                   |
| `rv_zvzip`         | `vunzipe_v`            | `vm, vs2, vd`                   | `Vector Extract Even Elements (Vector)`                                            |
| `rv_zvzip`         | `vunzipo_v`            | `vm, vs2, vd`                   | `Vector Extract Odd Elements (Vector)`                                             |
| `rv_zvzip`         | `vzip_vv`              | `vm, vs2, vs1, vd`              | `Vector Interleave Elements (Vector-Vector)`                                       |

:RVZV - Specific Extension for Vector Operations
