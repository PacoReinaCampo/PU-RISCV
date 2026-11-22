## INSTRUCTION CLASSES

| **Extension** | **Name**               | **Variable-Fields**  | **Class**                                 |
|:--------------|:-----------------------|:---------------------|:------------------------------------------|
| `rv_y`        | `yaaddu_yy`            | `ym, ys2, ys1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `yaaddu_yx`            | `ym, ys2, rs1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `yaadd_yy`             | `ym, ys2, ys1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `yaadd_yx`             | `ym, ys2, rs1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `yadc_yim`             | `ys2, simm5, yd`     | `tensor, alu, integer`                    |
| `rv_y`        | `yadc_yym`             | `ys2, ys1, yd`       | `tensor, alu, integer`                    |
| `rv_y`        | `yadc_yxm`             | `ys2, rs1, yd`       | `tensor, alu, integer`                    |
| `rv_y`        | `yadd_yi`              | `ym, ys2, simm5, yd` | `tensor, alu, integer`                    |
| `rv_y`        | `yadd_yy`              | `ym, ys2, ys1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `yadd_yx`              | `ym, ys2, rs1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `yand_yi`              | `ym, ys2, simm5, yd` | `tensor, alu, integer`                    |
| `rv_y`        | `yand_yy`              | `ym, ys2, ys1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `yand_yx`              | `ym, ys2, rs1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `yasubu_yy`            | `ym, ys2, ys1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `yasubu_yx`            | `ym, ys2, rs1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `yasub_yy`             | `ym, ys2, ys1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `yasub_yx`             | `ym, ys2, rs1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `ycompress_ym`         | `ys2, ys1, yd`       | `tensor, permute, compress`               |
| `rv_y`        | `ycpop_m`              | `ym, ys2, rd`        | `tensor, mask, count`                     |
| `rv_y`        | `ydivu_yy`             | `ym, ys2, ys1, yd`   | `tensor, divide, integer`                 |
| `rv_y`        | `ydivu_yx`             | `ym, ys2, rs1, yd`   | `tensor, divide, integer`                 |
| `rv_y`        | `ydiv_yy`              | `ym, ys2, ys1, yd`   | `tensor, divide, integer`                 |
| `rv_y`        | `ydiv_yx`              | `ym, ys2, rs1, yd`   | `tensor, divide, integer`                 |
| `rv_y`        | `yfadd_yf`             | `ym, ys2, rs1, yd`   | `tensor, alu, floating-point`             |
| `rv_y`        | `yfadd_yy`             | `ym, ys2, ys1, yd`   | `tensor, alu, floating-point`             |
| `rv_y`        | `yfclass_y`            | `ym, ys2, yd`        | `tensor, classify, floating-point`        |
| `rv_y`        | `yfcvt_f_xu_y`         | `ym, ys2, yd`        | `tensor, convert, floating-point`         |
| `rv_y`        | `yfcvt_f_x_y`          | `ym, ys2, yd`        | `tensor, convert, floating-point`         |
| `rv_y`        | `yfcvt_rtz_x_f_y`      | `ym, ys2, yd`        | `tensor, convert, floating-point`         |
| `rv_y`        | `yfcvt_rtz_xu_f_y`     | `ym, ys2, yd`        | `tensor, convert, floating-point`         |
| `rv_y`        | `yfcvt_x_f_y`          | `ym, ys2, yd`        | `tensor, convert, floating-point`         |
| `rv_y`        | `yfcvt_xu_f_y`         | `ym, ys2, yd`        | `tensor, convert, floating-point`         |
| `rv_y`        | `yfdiv_yf`             | `ym, ys2, rs1, yd`   | `tensor, alu, floating-point`             |
| `rv_y`        | `yfdiv_yy`             | `ym, ys2, ys1, yd`   | `tensor, alu, floating-point`             |
| `rv_y`        | `yfirst_m`             | `ym, ys2, rd`        | `tensor, mask, search`                    |
| `rv_y`        | `yfmacc_yf`            | `ym, ys2, rs1, yd`   | `tensor, multiply, floating-point`        |
| `rv_y`        | `yfmacc_yy`            | `ym, ys2, ys1, yd`   | `tensor, multiply, floating-point`        |
| `rv_y`        | `yfmadd_yf`            | `ym, ys2, rs1, yd`   | `tensor, multiply, floating-point`        |
| `rv_y`        | `yfmadd_yy`            | `ym, ys2, ys1, yd`   | `tensor, multiply, floating-point`        |
| `rv_y`        | `yfmax_yf`             | `ym, ys2, rs1, yd`   | `tensor, alu, floating-point`             |
| `rv_y`        | `yfmax_yy`             | `ym, ys2, ys1, yd`   | `tensor, alu, floating-point`             |
| `rv_y`        | `yfmerge_yfm`          | `ys2, rs1, yd`       | `tensor, merge, floating-point`           |
| `rv_y`        | `yfmin_yf`             | `ym, ys2, rs1, yd`   | `tensor, alu, floating-point`             |
| `rv_y`        | `yfmin_yy`             | `ym, ys2, ys1, yd`   | `tensor, alu, floating-point`             |
| `rv_y`        | `yfmsac_yf`            | `ym, ys2, rs1, yd`   | `tensor, multiply, floating-point`        |
| `rv_y`        | `yfmsac_yy`            | `ym, ys2, ys1, yd`   | `tensor, multiply, floating-point`        |
| `rv_y`        | `yfmsub_yf`            | `ym, ys2, rs1, yd`   | `tensor, multiply, floating-point`        |
| `rv_y`        | `yfmsub_yy`            | `ym, ys2, ys1, yd`   | `tensor, multiply, floating-point`        |
| `rv_y`        | `yfmul_yf`             | `ym, ys2, rs1, yd`   | `tensor, alu, floating-point`             |
| `rv_y`        | `yfmul_yy`             | `ym, ys2, ys1, yd`   | `tensor, alu, floating-point`             |
| `rv_y`        | `yfmv_f_s`             | `ys2, rd`            | `tensor, move, floating-point`            |
| `rv_y`        | `yfmv_s_f`             | `rs1, yd`            | `tensor, move, floating-point`            |
| `rv_y`        | `yfmv_y_f`             | `rs1, yd`            | `tensor, move, floating-point`            |
| `rv_y`        | `yfncvt_f_f_wide`      | `ym, ys2, yd`        | `tensor, convert, floating-point`         |
| `rv_y`        | `yfncvt_f_xu_wide`     | `ym, ys2, yd`        | `tensor, convert, floating-point`         |
| `rv_y`        | `yfncvt_f_x_wide`      | `ym, ys2, yd`        | `tensor, convert, floating-point`         |
| `rv_y`        | `yfncvt_rod_f_f_wide`  | `ym, ys2, yd`        | `tensor, convert, floating-point`         |
| `rv_y`        | `yfncvt_rtz_x_f_wide`  | `ym, ys2, yd`        | `tensor, convert, floating-point`         |
| `rv_y`        | `yfncvt_rtz_xu_f_wide` | `ym, ys2, yd`        | `tensor, convert, floating-point`         |
| `rv_y`        | `yfncvt_x_f_wide`      | `ym, ys2, yd`        | `tensor, convert, floating-point`         |
| `rv_y`        | `yfncvt_xu_f_wide`     | `ym, ys2, yd`        | `tensor, convert, floating-point`         |
| `rv_y`        | `yfnmacc_yf`           | `ym, ys2, rs1, yd`   | `tensor, multiply, floating-point`        |
| `rv_y`        | `yfnmacc_yy`           | `ym, ys2, ys1, yd`   | `tensor, multiply, floating-point`        |
| `rv_y`        | `yfnmadd_yf`           | `ym, ys2, rs1, yd`   | `tensor, multiply, floating-point`        |
| `rv_y`        | `yfnmadd_yy`           | `ym, ys2, ys1, yd`   | `tensor, multiply, floating-point`        |
| `rv_y`        | `yfnmsac_yf`           | `ym, ys2, rs1, yd`   | `tensor, multiply, floating-point`        |
| `rv_y`        | `yfnmsac_yy`           | `ym, ys2, ys1, yd`   | `tensor, multiply, floating-point`        |
| `rv_y`        | `yfnmsub_yf`           | `ym, ys2, rs1, yd`   | `tensor, multiply, floating-point`        |
| `rv_y`        | `yfnmsub_yy`           | `ym, ys2, ys1, yd`   | `tensor, multiply, floating-point`        |
| `rv_y`        | `yfrdiv_yf`            | `ym, ys2, rs1, yd`   | `tensor, alu, floating-point`             |
| `rv_y`        | `yfrec7_y`             | `ym, ys2, yd`        | `tensor, alu, floating-point`             |
| `rv_y`        | `yfredmax_ys`          | `ym, ys2, ys1, yd`   | `tensor, reduction, floating-point`       |
| `rv_y`        | `yfredmin_ys`          | `ym, ys2, ys1, yd`   | `tensor, reduction, floating-point`       |
| `rv_y`        | `yfredosum_ys`         | `ym, ys2, ys1, yd`   | `tensor, reduction, floating-point`       |
| `rv_y`        | `yfredusum_ys`         | `ym, ys2, ys1, yd`   | `tensor, reduction, floating-point`       |
| `rv_y`        | `yfrsqrt7_y`           | `ym, ys2, yd`        | `tensor, alu, floating-point`             |
| `rv_y`        | `yfrsub_yf`            | `ym, ys2, rs1, yd`   | `tensor, alu, floating-point`             |
| `rv_y`        | `yfsgnjn_yf`           | `ym, ys2, rs1, yd`   | `tensor, logical, floating-point`         |
| `rv_y`        | `yfsgnjn_yy`           | `ym, ys2, ys1, yd`   | `tensor, logical, floating-point`         |
| `rv_y`        | `yfsgnj_yf`            | `ym, ys2, rs1, yd`   | `tensor, logical, floating-point`         |
| `rv_y`        | `yfsgnj_yy`            | `ym, ys2, ys1, yd`   | `tensor, logical, floating-point`         |
| `rv_y`        | `yfsgnjx_yf`           | `ym, ys2, rs1, yd`   | `tensor, logical, floating-point`         |
| `rv_y`        | `yfsgnjx_yy`           | `ym, ys2, ys1, yd`   | `tensor, logical, floating-point`         |
| `rv_y`        | `yfslide1down_yf`      | `ym, ys2, rs1, yd`   | `tensor, permute, floating-point`         |
| `rv_y`        | `yfslide1up_yf`        | `ym, ys2, rs1, yd`   | `tensor, permute, floating-point`         |
| `rv_y`        | `yfsqrt_y`             | `ym, ys2, yd`        | `tensor, alu, floating-point`             |
| `rv_y`        | `yfsub_yf`             | `ym, ys2, rs1, yd`   | `tensor, alu, floating-point`             |
| `rv_y`        | `yfsub_yy`             | `ym, ys2, ys1, yd`   | `tensor, alu, floating-point`             |
| `rv_y`        | `yfwadd_yf`            | `ym, ys2, rs1, yd`   | `tensor, alu, floating-point`             |
| `rv_y`        | `yfwadd_yy`            | `ym, ys2, ys1, yd`   | `tensor, alu, floating-point`             |
| `rv_y`        | `yfwadd_wide_yf`       | `ym, ys2, rs1, yd`   | `tensor, alu, floating-point`             |
| `rv_y`        | `yfwadd_wide_yy`       | `ym, ys2, ys1, yd`   | `tensor, alu, floating-point`             |
| `rv_y`        | `yfwcvt_f_f_y`         | `ym, ys2, yd`        | `tensor, convert, floating-point`         |
| `rv_y`        | `yfwcvt_f_xu_y`        | `ym, ys2, yd`        | `tensor, convert, floating-point`         |
| `rv_y`        | `yfwcvt_f_x_y`         | `ym, ys2, yd`        | `tensor, convert, floating-point`         |
| `rv_y`        | `yfwcvt_rtz_x_f_y`     | `ym, ys2, yd`        | `tensor, convert, floating-point`         |
| `rv_y`        | `yfwcvt_rtz_xu_f_y`    | `ym, ys2, yd`        | `tensor, convert, floating-point`         |
| `rv_y`        | `yfwcvt_x_f_y`         | `ym, ys2, yd`        | `tensor, convert, floating-point`         |
| `rv_y`        | `yfwcvt_xu_f_y`        | `ym, ys2, yd`        | `tensor, convert, floating-point`         |
| `rv_y`        | `yfwmacc_yf`           | `ym, ys2, rs1, yd`   | `tensor, multiply, floating-point`        |
| `rv_y`        | `yfwmacc_yy`           | `ym, ys2, ys1, yd`   | `tensor, multiply, floating-point`        |
| `rv_y`        | `yfwmsac_yf`           | `ym, ys2, rs1, yd`   | `tensor, multiply, floating-point`        |
| `rv_y`        | `yfwmsac_yy`           | `ym, ys2, ys1, yd`   | `tensor, multiply, floating-point`        |
| `rv_y`        | `yfwmul_yf`            | `ym, ys2, rs1, yd`   | `tensor, alu, floating-point`             |
| `rv_y`        | `yfwmul_yy`            | `ym, ys2, ys1, yd`   | `tensor, alu, floating-point`             |
| `rv_y`        | `yfwnmacc_yf`          | `ym, ys2, rs1, yd`   | `tensor, multiply, floating-point`        |
| `rv_y`        | `yfwnmacc_yy`          | `ym, ys2, ys1, yd`   | `tensor, multiply, floating-point`        |
| `rv_y`        | `yfwnmsac_yf`          | `ym, ys2, rs1, yd`   | `tensor, multiply, floating-point`        |
| `rv_y`        | `yfwnmsac_yy`          | `ym, ys2, ys1, yd`   | `tensor, multiply, floating-point`        |
| `rv_y`        | `yfwredosum_ys`        | `ym, ys2, ys1, yd`   | `tensor, reduction, floating-point`       |
| `rv_y`        | `yfwredusum_ys`        | `ym, ys2, ys1, yd`   | `tensor, reduction, floating-point`       |
| `rv_y`        | `yfwsub_yf`            | `ym, ys2, rs1, yd`   | `tensor, alu, floating-point`             |
| `rv_y`        | `yfwsub_yy`            | `ym, ys2, ys1, yd`   | `tensor, alu, floating-point`             |
| `rv_y`        | `yfwsub_wide_yf`       | `ym, ys2, rs1, yd`   | `tensor, alu, floating-point`             |
| `rv_y`        | `yfwsub_wide_yy`       | `ym, ys2, ys1, yd`   | `tensor, alu, floating-point`             |
| `rv_y`        | `yid_y`                | `ym, yd`             | `tensor, index`                           |
| `rv_y`        | `yiota_m`              | `ym, ys2, yd`        | `tensor, mask, prefix`                    |
| `rv_y`        | `yl1re16_y`            | `rs1, yd`            | `tensor, load, whole-register`            |
| `rv_y`        | `yl1re32_y`            | `rs1, yd`            | `tensor, load, whole-register`            |
| `rv_y`        | `yl1re64_y`            | `rs1, yd`            | `tensor, load, whole-register`            |
| `rv_y`        | `yl1re8_y`             | `rs1, yd`            | `tensor, load, whole-register`            |
| `rv_y`        | `yl2re16_y`            | `rs1, yd`            | `tensor, load, whole-register`            |
| `rv_y`        | `yl2re32_y`            | `rs1, yd`            | `tensor, load, whole-register`            |
| `rv_y`        | `yl2re64_y`            | `rs1, yd`            | `tensor, load, whole-register`            |
| `rv_y`        | `yl2re8_y`             | `rs1, yd`            | `tensor, load, whole-register`            |
| `rv_y`        | `yl4re16_y`            | `rs1, yd`            | `tensor, load, whole-register`            |
| `rv_y`        | `yl4re32_y`            | `rs1, yd`            | `tensor, load, whole-register`            |
| `rv_y`        | `yl4re64_y`            | `rs1, yd`            | `tensor, load, whole-register`            |
| `rv_y`        | `yl4re8_y`             | `rs1, yd`            | `tensor, load, whole-register`            |
| `rv_y`        | `yl8re16_y`            | `rs1, yd`            | `tensor, load, whole-register`            |
| `rv_y`        | `yl8re32_y`            | `rs1, yd`            | `tensor, load, whole-register`            |
| `rv_y`        | `yl8re64_y`            | `rs1, yd`            | `tensor, load, whole-register`            |
| `rv_y`        | `yl8re8_y`             | `rs1, yd`            | `tensor, load, whole-register`            |
| `rv_y`        | `yle16ff_y`            | `ym, rs1, yd`        | `tensor, load, fault-only-first`          |
| `rv_y`        | `yle16_y`              | `ym, rs1, yd`        | `tensor, load`                            |
| `rv_y`        | `yle32ff_y`            | `ym, rs1, yd`        | `tensor, load, fault-only-first`          |
| `rv_y`        | `yle32_y`              | `ym, rs1, yd`        | `tensor, load`                            |
| `rv_y`        | `yle64ff_y`            | `ym, rs1, yd`        | `tensor, load, fault-only-first`          |
| `rv_y`        | `yle64_y`              | `ym, rs1, yd`        | `tensor, load`                            |
| `rv_y`        | `yle8ff_y`             | `ym, rs1, yd`        | `tensor, load, fault-only-first`          |
| `rv_y`        | `yle8_y`               | `ym, rs1, yd`        | `tensor, load`                            |
| `rv_y`        | `ylm_y`                | `rs1, yd`            | `tensor, load, mask`                      |
| `rv_y`        | `yloxei16_y`           | `ym, ys2, rs1, yd`   | `tensor, load`                            |
| `rv_y`        | `yloxei32_y`           | `ym, ys2, rs1, yd`   | `tensor, load`                            |
| `rv_y`        | `yloxei64_y`           | `ym, ys2, rs1, yd`   | `tensor, load`                            |
| `rv_y`        | `yloxei8_y`            | `ym, ys2, rs1, yd`   | `tensor, load`                            |
| `rv_y`        | `yloxseg2ei16_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg2ei32_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg2ei64_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg2ei8_y`        | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg3ei16_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg3ei32_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg3ei64_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg3ei8_y`        | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg4ei16_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg4ei32_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg4ei64_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg4ei8_y`        | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg5ei16_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg5ei32_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg5ei64_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg5ei8_y`        | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg6ei16_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg6ei32_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg6ei64_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg6ei8_y`        | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg7ei16_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg7ei32_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg7ei64_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg7ei8_y`        | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg8ei16_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg8ei32_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg8ei64_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yloxseg8ei8_y`        | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylse16_y`             | `ym, rs2, rs1, yd`   | `tensor, load`                            |
| `rv_y`        | `ylse32_y`             | `ym, rs2, rs1, yd`   | `tensor, load`                            |
| `rv_y`        | `ylse64_y`             | `ym, rs2, rs1, yd`   | `tensor, load`                            |
| `rv_y`        | `ylse8_y`              | `ym, rs2, rs1, yd`   | `tensor, load`                            |
| `rv_y`        | `ylseg2e16ff_y`        | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg2e16_y`          | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg2e32ff_y`        | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg2e32_y`          | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg2e64ff_y`        | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg2e64_y`          | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg2e8ff_y`         | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg2e8_y`           | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg3e16ff_y`        | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg3e16_y`          | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg3e32ff_y`        | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg3e32_y`          | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg3e64ff_y`        | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg3e64_y`          | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg3e8ff_y`         | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg3e8_y`           | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg4e16ff_y`        | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg4e16_y`          | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg4e32ff_y`        | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg4e32_y`          | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg4e64ff_y`        | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg4e64_y`          | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg4e8ff_y`         | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg4e8_y`           | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg5e16ff_y`        | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg5e16_y`          | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg5e32ff_y`        | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg5e32_y`          | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg5e64ff_y`        | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg5e64_y`          | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg5e8ff_y`         | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg5e8_y`           | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg6e16ff_y`        | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg6e16_y`          | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg6e32ff_y`        | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg6e32_y`          | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg6e64ff_y`        | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg6e64_y`          | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg6e8ff_y`         | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg6e8_y`           | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg7e16ff_y`        | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg7e16_y`          | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg7e32ff_y`        | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg7e32_y`          | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg7e64ff_y`        | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg7e64_y`          | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg7e8ff_y`         | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg7e8_y`           | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg8e16ff_y`        | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg8e16_y`          | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg8e32ff_y`        | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg8e32_y`          | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg8e64ff_y`        | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg8e64_y`          | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylseg8e8ff_y`         | `ym, rs1, yd`        | `tensor, load, fault-only-first, segment` |
| `rv_y`        | `ylseg8e8_y`           | `ym, rs1, yd`        | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg2e16_y`         | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg2e32_y`         | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg2e64_y`         | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg2e8_y`          | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg3e16_y`         | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg3e32_y`         | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg3e64_y`         | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg3e8_y`          | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg4e16_y`         | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg4e32_y`         | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg4e64_y`         | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg4e8_y`          | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg5e16_y`         | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg5e32_y`         | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg5e64_y`         | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg5e8_y`          | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg6e16_y`         | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg6e32_y`         | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg6e64_y`         | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg6e8_y`          | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg7e16_y`         | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg7e32_y`         | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg7e64_y`         | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg7e8_y`          | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg8e16_y`         | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg8e32_y`         | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg8e64_y`         | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ylsseg8e8_y`          | `ym, rs2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxei16_y`           | `ym, ys2, rs1, yd`   | `tensor, load`                            |
| `rv_y`        | `yluxei32_y`           | `ym, ys2, rs1, yd`   | `tensor, load`                            |
| `rv_y`        | `yluxei64_y`           | `ym, ys2, rs1, yd`   | `tensor, load`                            |
| `rv_y`        | `yluxei8_y`            | `ym, ys2, rs1, yd`   | `tensor, load`                            |
| `rv_y`        | `yluxseg2ei16_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg2ei32_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg2ei64_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg2ei8_y`        | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg3ei16_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg3ei32_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg3ei64_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg3ei8_y`        | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg4ei16_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg4ei32_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg4ei64_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg4ei8_y`        | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg5ei16_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg5ei32_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg5ei64_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg5ei8_y`        | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg6ei16_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg6ei32_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg6ei64_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg6ei8_y`        | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg7ei16_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg7ei32_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg7ei64_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg7ei8_y`        | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg8ei16_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg8ei32_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg8ei64_y`       | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `yluxseg8ei8_y`        | `ym, ys2, rs1, yd`   | `tensor, load, segment`                   |
| `rv_y`        | `ymacc_yy`             | `ym, ys2, ys1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ymacc_yx`             | `ym, ys2, rs1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ymadc_yi`             | `ys2, simm5, yd`     | `tensor, alu, integer, mask`              |
| `rv_y`        | `ymadc_yim`            | `ys2, simm5, yd`     | `tensor, alu, integer, mask`              |
| `rv_y`        | `ymadc_yy`             | `ys2, ys1, yd`       | `tensor, alu, integer, mask`              |
| `rv_y`        | `ymadc_yym`            | `ys2, ys1, yd`       | `tensor, alu, integer, mask`              |
| `rv_y`        | `ymadc_yx`             | `ys2, rs1, yd`       | `tensor, alu, integer, mask`              |
| `rv_y`        | `ymadc_yxm`            | `ys2, rs1, yd`       | `tensor, alu, integer, mask`              |
| `rv_y`        | `ymadd_yy`             | `ym, ys2, ys1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ymadd_yx`             | `ym, ys2, rs1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ymand_mm`             | `ys2, ys1, yd`       | `tensor, logical, mask`                   |
| `rv_y`        | `ymandn_mm`            | `ys2, ys1, yd`       | `tensor, logical, mask`                   |
| `rv_y`        | `ymaxu_yy`             | `ym, ys2, ys1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ymaxu_yx`             | `ym, ys2, rs1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ymax_yy`              | `ym, ys2, ys1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ymax_yx`              | `ym, ys2, rs1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ymerge_yim`           | `ys2, simm5, yd`     | `tensor, merge, integer`                  |
| `rv_y`        | `ymerge_yym`           | `ys2, ys1, yd`       | `tensor, merge, integer`                  |
| `rv_y`        | `ymerge_yxm`           | `ys2, rs1, yd`       | `tensor, merge, integer`                  |
| `rv_y`        | `ymfeq_yf`             | `ym, ys2, rs1, yd`   | `tensor, compare, floating-point, mask`   |
| `rv_y`        | `ymfeq_yy`             | `ym, ys2, ys1, yd`   | `tensor, compare, floating-point, mask`   |
| `rv_y`        | `ymfge_yf`             | `ym, ys2, rs1, yd`   | `tensor, compare, floating-point, mask`   |
| `rv_y`        | `ymfgt_yf`             | `ym, ys2, rs1, yd`   | `tensor, compare, floating-point, mask`   |
| `rv_y`        | `ymfle_yf`             | `ym, ys2, rs1, yd`   | `tensor, compare, floating-point, mask`   |
| `rv_y`        | `ymfle_yy`             | `ym, ys2, ys1, yd`   | `tensor, compare, floating-point, mask`   |
| `rv_y`        | `ymflt_yf`             | `ym, ys2, rs1, yd`   | `tensor, compare, floating-point, mask`   |
| `rv_y`        | `ymflt_yy`             | `ym, ys2, ys1, yd`   | `tensor, compare, floating-point, mask`   |
| `rv_y`        | `ymfne_yf`             | `ym, ys2, rs1, yd`   | `tensor, compare, floating-point, mask`   |
| `rv_y`        | `ymfne_yy`             | `ym, ys2, ys1, yd`   | `tensor, compare, floating-point, mask`   |
| `rv_y`        | `yminu_yy`             | `ym, ys2, ys1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `yminu_yx`             | `ym, ys2, rs1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ymin_yy`              | `ym, ys2, ys1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ymin_yx`              | `ym, ys2, rs1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ymnand_mm`            | `ys2, ys1, yd`       | `tensor, logical, mask`                   |
| `rv_y`        | `ymnor_mm`             | `ys2, ys1, yd`       | `tensor, logical, mask`                   |
| `rv_y`        | `ymor_mm`              | `ys2, ys1, yd`       | `tensor, logical, mask`                   |
| `rv_y`        | `ymorn_mm`             | `ys2, ys1, yd`       | `tensor, logical, mask`                   |
| `rv_y`        | `ymsbc_yy`             | `ys2, ys1, yd`       | `tensor, alu, integer, mask`              |
| `rv_y`        | `ymsbc_yym`            | `ys2, ys1, yd`       | `tensor, alu, integer, mask`              |
| `rv_y`        | `ymsbc_yx`             | `ys2, rs1, yd`       | `tensor, alu, integer, mask`              |
| `rv_y`        | `ymsbc_yxm`            | `ys2, rs1, yd`       | `tensor, alu, integer, mask`              |
| `rv_y`        | `ymsbf_m`              | `ym, ys2, yd`        | `tensor, mask, prefix`                    |
| `rv_y`        | `ymseq_yi`             | `ym, ys2, simm5, yd` | `tensor, compare, integer, mask`          |
| `rv_y`        | `ymseq_yy`             | `ym, ys2, ys1, yd`   | `tensor, compare, integer, mask`          |
| `rv_y`        | `ymseq_yx`             | `ym, ys2, rs1, yd`   | `tensor, compare, integer, mask`          |
| `rv_y`        | `ymsgtu_yi`            | `ym, ys2, simm5, yd` | `tensor, compare, integer, mask`          |
| `rv_y`        | `ymsgtu_yx`            | `ym, ys2, rs1, yd`   | `tensor, compare, integer, mask`          |
| `rv_y`        | `ymsgt_yi`             | `ym, ys2, simm5, yd` | `tensor, compare, integer, mask`          |
| `rv_y`        | `ymsgt_yx`             | `ym, ys2, rs1, yd`   | `tensor, compare, integer, mask`          |
| `rv_y`        | `ymsif_m`              | `ym, ys2, yd`        | `tensor, mask, prefix`                    |
| `rv_y`        | `ymsleu_yi`            | `ym, ys2, simm5, yd` | `tensor, compare, integer, mask`          |
| `rv_y`        | `ymsleu_yy`            | `ym, ys2, ys1, yd`   | `tensor, compare, integer, mask`          |
| `rv_y`        | `ymsleu_yx`            | `ym, ys2, rs1, yd`   | `tensor, compare, integer, mask`          |
| `rv_y`        | `ymsle_yi`             | `ym, ys2, simm5, yd` | `tensor, compare, integer, mask`          |
| `rv_y`        | `ymsle_yy`             | `ym, ys2, ys1, yd`   | `tensor, compare, integer, mask`          |
| `rv_y`        | `ymsle_yx`             | `ym, ys2, rs1, yd`   | `tensor, compare, integer, mask`          |
| `rv_y`        | `ymsltu_yy`            | `ym, ys2, ys1, yd`   | `tensor, compare, integer, mask`          |
| `rv_y`        | `ymsltu_yx`            | `ym, ys2, rs1, yd`   | `tensor, compare, integer, mask`          |
| `rv_y`        | `ymslt_yy`             | `ym, ys2, ys1, yd`   | `tensor, compare, integer, mask`          |
| `rv_y`        | `ymslt_yx`             | `ym, ys2, rs1, yd`   | `tensor, compare, integer, mask`          |
| `rv_y`        | `ymsne_yi`             | `ym, ys2, simm5, yd` | `tensor, compare, integer, mask`          |
| `rv_y`        | `ymsne_yy`             | `ym, ys2, ys1, yd`   | `tensor, compare, integer, mask`          |
| `rv_y`        | `ymsne_yx`             | `ym, ys2, rs1, yd`   | `tensor, compare, integer, mask`          |
| `rv_y`        | `ymsof_m`              | `ym, ys2, yd`        | `tensor, mask, prefix`                    |
| `rv_y`        | `ymulhsu_yy`           | `ym, ys2, ys1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ymulhsu_yx`           | `ym, ys2, rs1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ymulhu_yy`            | `ym, ys2, ys1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ymulhu_yx`            | `ym, ys2, rs1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ymulh_yy`             | `ym, ys2, ys1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ymulh_yx`             | `ym, ys2, rs1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ymul_yy`              | `ym, ys2, ys1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ymul_yx`              | `ym, ys2, rs1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ymv1r_y`              | `ys2, yd`            | `tensor, move, whole-register`            |
| `rv_y`        | `ymv2r_y`              | `ys2, yd`            | `tensor, move, whole-register`            |
| `rv_y`        | `ymv4r_y`              | `ys2, yd`            | `tensor, move, whole-register`            |
| `rv_y`        | `ymv8r_y`              | `ys2, yd`            | `tensor, move, whole-register`            |
| `rv_y`        | `ymv_s_x`              | `rs1, yd`            | `tensor, move, integer`                   |
| `rv_y`        | `ymv_y_i`              | `simm5, yd`          | `tensor, move, integer`                   |
| `rv_y`        | `ymv_y_y`              | `ys1, yd`            | `tensor, move, integer`                   |
| `rv_y`        | `ymv_y_x`              | `rs1, yd`            | `tensor, move, integer`                   |
| `rv_y`        | `ymv_x_s`              | `ys2, rd`            | `tensor, move, integer`                   |
| `rv_y`        | `ymxnor_mm`            | `ys2, ys1, yd`       | `tensor, logical, mask`                   |
| `rv_y`        | `ymxor_mm`             | `ys2, ys1, yd`       | `tensor, logical, mask`                   |
| `rv_y`        | `ynclipu_wide_yi`      | `ym, ys2, zimm5, yd` | `tensor, alu, fixed-point`                |
| `rv_y`        | `ynclipu_wide_yy`      | `ym, ys2, ys1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `ynclipu_wide_yx`      | `ym, ys2, rs1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `ynclip_wide_yi`       | `ym, ys2, zimm5, yd` | `tensor, alu, fixed-point`                |
| `rv_y`        | `ynclip_wide_yy`       | `ym, ys2, ys1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `ynclip_wide_yx`       | `ym, ys2, rs1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `ynmsac_yy`            | `ym, ys2, ys1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ynmsac_yx`            | `ym, ys2, rs1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ynmsub_yy`            | `ym, ys2, ys1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ynmsub_yx`            | `ym, ys2, rs1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ynsra_wide_yi`        | `ym, ys2, zimm5, yd` | `tensor, alu, integer`                    |
| `rv_y`        | `ynsra_wide_yy`        | `ym, ys2, ys1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ynsra_wide_yx`        | `ym, ys2, rs1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ynsrl_wide_yi`        | `ym, ys2, zimm5, yd` | `tensor, alu, integer`                    |
| `rv_y`        | `ynsrl_wide_yy`        | `ym, ys2, ys1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ynsrl_wide_yx`        | `ym, ys2, rs1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `yor_yi`               | `ym, ys2, simm5, yd` | `tensor, alu, integer`                    |
| `rv_y`        | `yor_yy`               | `ym, ys2, ys1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `yor_yx`               | `ym, ys2, rs1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `yredand_ys`           | `ym, ys2, ys1, yd`   | `tensor, reduction, integer`              |
| `rv_y`        | `yredmaxu_ys`          | `ym, ys2, ys1, yd`   | `tensor, reduction, integer`              |
| `rv_y`        | `yredmax_ys`           | `ym, ys2, ys1, yd`   | `tensor, reduction, integer`              |
| `rv_y`        | `yredminu_ys`          | `ym, ys2, ys1, yd`   | `tensor, reduction, integer`              |
| `rv_y`        | `yredmin_ys`           | `ym, ys2, ys1, yd`   | `tensor, reduction, integer`              |
| `rv_y`        | `yredor_ys`            | `ym, ys2, ys1, yd`   | `tensor, reduction, integer`              |
| `rv_y`        | `yredsum_ys`           | `ym, ys2, ys1, yd`   | `tensor, reduction, integer`              |
| `rv_y`        | `yredxor_ys`           | `ym, ys2, ys1, yd`   | `tensor, reduction, integer`              |
| `rv_y`        | `yremu_yy`             | `ym, ys2, ys1, yd`   | `tensor, divide, integer`                 |
| `rv_y`        | `yremu_yx`             | `ym, ys2, rs1, yd`   | `tensor, divide, integer`                 |
| `rv_y`        | `yrem_yy`              | `ym, ys2, ys1, yd`   | `tensor, divide, integer`                 |
| `rv_y`        | `yrem_yx`              | `ym, ys2, rs1, yd`   | `tensor, divide, integer`                 |
| `rv_y`        | `yrgatherei16_yy`      | `ym, ys2, ys1, yd`   | `tensor, permute`                         |
| `rv_y`        | `yrgather_yi`          | `ym, ys2, zimm5, yd` | `tensor, permute`                         |
| `rv_y`        | `yrgather_yy`          | `ym, ys2, ys1, yd`   | `tensor, permute`                         |
| `rv_y`        | `yrgather_yx`          | `ym, ys2, rs1, yd`   | `tensor, permute`                         |
| `rv_y`        | `yrsub_yi`             | `ym, ys2, simm5, yd` | `tensor, alu, integer`                    |
| `rv_y`        | `yrsub_yx`             | `ym, ys2, rs1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ys1r_y`               | `rs1, ys3`           | `tensor, store, whole-register`           |
| `rv_y`        | `ys2r_y`               | `rs1, ys3`           | `tensor, store, whole-register`           |
| `rv_y`        | `ys4r_y`               | `rs1, ys3`           | `tensor, store, whole-register`           |
| `rv_y`        | `ys8r_y`               | `rs1, ys3`           | `tensor, store, whole-register`           |
| `rv_y`        | `ysaddu_yi`            | `ym, ys2, simm5, yd` | `tensor, alu, fixed-point`                |
| `rv_y`        | `ysaddu_yy`            | `ym, ys2, ys1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `ysaddu_yx`            | `ym, ys2, rs1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `ysadd_yi`             | `ym, ys2, simm5, yd` | `tensor, alu, fixed-point`                |
| `rv_y`        | `ysadd_yy`             | `ym, ys2, ys1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `ysadd_yx`             | `ym, ys2, rs1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `ysbc_yym`             | `ys2, ys1, yd`       | `tensor, alu, integer`                    |
| `rv_y`        | `ysbc_yxm`             | `ys2, rs1, yd`       | `tensor, alu, integer`                    |
| `rv_y`        | `yse16_y`              | `ym, rs1, ys3`       | `tensor, store`                           |
| `rv_y`        | `yse32_y`              | `ym, rs1, ys3`       | `tensor, store`                           |
| `rv_y`        | `yse64_y`              | `ym, rs1, ys3`       | `tensor, store`                           |
| `rv_y`        | `yse8_y`               | `ym, rs1, ys3`       | `tensor, store`                           |
| `rv_y`        | `ysetiyli`             | `zimm10, zimm5, rd`  | `tensor, configuration`                   |
| `rv_y`        | `ysetyl`               | `rs2, rs1, rd`       | `tensor, configuration`                   |
| `rv_y`        | `ysetyli`              | `zimm11, rs1, rd`    | `tensor, configuration`                   |
| `rv_y`        | `ysext_yf2`            | `ym, ys2, yd`        | `tensor, alu, integer`                    |
| `rv_y`        | `ysext_yf4`            | `ym, ys2, yd`        | `tensor, alu, integer`                    |
| `rv_y`        | `ysext_yf8`            | `ym, ys2, yd`        | `tensor, alu, integer`                    |
| `rv_y`        | `yslide1down_yx`       | `ym, ys2, rs1, yd`   | `tensor, permute`                         |
| `rv_y`        | `yslide1up_yx`         | `ym, ys2, rs1, yd`   | `tensor, permute`                         |
| `rv_y`        | `yslidedown_yi`        | `ym, ys2, zimm5, yd` | `tensor, permute`                         |
| `rv_y`        | `yslidedown_yx`        | `ym, ys2, rs1, yd`   | `tensor, permute`                         |
| `rv_y`        | `yslideup_yi`          | `ym, ys2, zimm5, yd` | `tensor, permute`                         |
| `rv_y`        | `yslideup_yx`          | `ym, ys2, rs1, yd`   | `tensor, permute`                         |
| `rv_y`        | `ysll_yi`              | `ym, ys2, zimm5, yd` | `tensor, alu, integer`                    |
| `rv_y`        | `ysll_yy`              | `ym, ys2, ys1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ysll_yx`              | `ym, ys2, rs1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ysmul_yy`             | `ym, ys2, ys1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `ysmul_yx`             | `ym, ys2, rs1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `ysm_y`                | `rs1, ys3`           | `tensor, store, mask`                     |
| `rv_y`        | `ysoxei16_y`           | `ym, ys2, rs1, ys3`  | `tensor, store`                           |
| `rv_y`        | `ysoxei32_y`           | `ym, ys2, rs1, ys3`  | `tensor, store`                           |
| `rv_y`        | `ysoxei64_y`           | `ym, ys2, rs1, ys3`  | `tensor, store`                           |
| `rv_y`        | `ysoxei8_y`            | `ym, ys2, rs1, ys3`  | `tensor, store`                           |
| `rv_y`        | `ysoxseg2ei16_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg2ei32_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg2ei64_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg2ei8_y`        | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg3ei16_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg3ei32_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg3ei64_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg3ei8_y`        | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg4ei16_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg4ei32_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg4ei64_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg4ei8_y`        | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg5ei16_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg5ei32_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg5ei64_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg5ei8_y`        | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg6ei16_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg6ei32_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg6ei64_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg6ei8_y`        | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg7ei16_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg7ei32_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg7ei64_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg7ei8_y`        | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg8ei16_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg8ei32_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg8ei64_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysoxseg8ei8_y`        | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysra_yi`              | `ym, ys2, zimm5, yd` | `tensor, alu, integer`                    |
| `rv_y`        | `ysra_yy`              | `ym, ys2, ys1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ysra_yx`              | `ym, ys2, rs1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ysrl_yi`              | `ym, ys2, zimm5, yd` | `tensor, alu, integer`                    |
| `rv_y`        | `ysrl_yy`              | `ym, ys2, ys1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ysrl_yx`              | `ym, ys2, rs1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ysse16_y`             | `ym, rs2, rs1, ys3`  | `tensor, store`                           |
| `rv_y`        | `ysse32_y`             | `ym, rs2, rs1, ys3`  | `tensor, store`                           |
| `rv_y`        | `ysse64_y`             | `ym, rs2, rs1, ys3`  | `tensor, store`                           |
| `rv_y`        | `ysse8_y`              | `ym, rs2, rs1, ys3`  | `tensor, store`                           |
| `rv_y`        | `ysseg2e16_y`          | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg2e32_y`          | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg2e64_y`          | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg2e8_y`           | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg3e16_y`          | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg3e32_y`          | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg3e64_y`          | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg3e8_y`           | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg4e16_y`          | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg4e32_y`          | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg4e64_y`          | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg4e8_y`           | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg5e16_y`          | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg5e32_y`          | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg5e64_y`          | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg5e8_y`           | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg6e16_y`          | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg6e32_y`          | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg6e64_y`          | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg6e8_y`           | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg7e16_y`          | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg7e32_y`          | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg7e64_y`          | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg7e8_y`           | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg8e16_y`          | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg8e32_y`          | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg8e64_y`          | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `ysseg8e8_y`           | `ym, rs1, ys3`       | `tensor, store, segment`                  |
| `rv_y`        | `yssra_yi`             | `ym, ys2, zimm5, yd` | `tensor, alu, fixed-point`                |
| `rv_y`        | `yssra_yy`             | `ym, ys2, ys1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `yssra_yx`             | `ym, ys2, rs1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `yssrl_yi`             | `ym, ys2, zimm5, yd` | `tensor, alu, fixed-point`                |
| `rv_y`        | `yssrl_yy`             | `ym, ys2, ys1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `yssrl_yx`             | `ym, ys2, rs1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `yssseg2e16_y`         | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg2e32_y`         | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg2e64_y`         | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg2e8_y`          | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg3e16_y`         | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg3e32_y`         | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg3e64_y`         | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg3e8_y`          | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg4e16_y`         | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg4e32_y`         | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg4e64_y`         | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg4e8_y`          | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg5e16_y`         | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg5e32_y`         | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg5e64_y`         | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg5e8_y`          | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg6e16_y`         | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg6e32_y`         | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg6e64_y`         | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg6e8_y`          | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg7e16_y`         | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg7e32_y`         | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg7e64_y`         | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg7e8_y`          | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg8e16_y`         | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg8e32_y`         | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg8e64_y`         | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssseg8e8_y`          | `ym, rs2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `yssubu_yy`            | `ym, ys2, ys1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `yssubu_yx`            | `ym, ys2, rs1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `yssub_yy`             | `ym, ys2, ys1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `yssub_yx`             | `ym, ys2, rs1, yd`   | `tensor, alu, fixed-point`                |
| `rv_y`        | `ysub_yy`              | `ym, ys2, ys1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ysub_yx`              | `ym, ys2, rs1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ysuxei16_y`           | `ym, ys2, rs1, ys3`  | `tensor, store`                           |
| `rv_y`        | `ysuxei32_y`           | `ym, ys2, rs1, ys3`  | `tensor, store`                           |
| `rv_y`        | `ysuxei64_y`           | `ym, ys2, rs1, ys3`  | `tensor, store`                           |
| `rv_y`        | `ysuxei8_y`            | `ym, ys2, rs1, ys3`  | `tensor, store`                           |
| `rv_y`        | `ysuxseg2ei16_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg2ei32_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg2ei64_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg2ei8_y`        | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg3ei16_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg3ei32_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg3ei64_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg3ei8_y`        | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg4ei16_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg4ei32_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg4ei64_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg4ei8_y`        | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg5ei16_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg5ei32_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg5ei64_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg5ei8_y`        | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg6ei16_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg6ei32_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg6ei64_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg6ei8_y`        | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg7ei16_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg7ei32_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg7ei64_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg7ei8_y`        | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg8ei16_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg8ei32_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg8ei64_y`       | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ysuxseg8ei8_y`        | `ym, ys2, rs1, ys3`  | `tensor, store, segment`                  |
| `rv_y`        | `ywaddu_yy`            | `ym, ys2, ys1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ywaddu_yx`            | `ym, ys2, rs1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ywaddu_wide_yy`       | `ym, ys2, ys1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ywaddu_wide_yx`       | `ym, ys2, rs1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ywadd_yy`             | `ym, ys2, ys1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ywadd_yx`             | `ym, ys2, rs1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ywadd_wide_yy`        | `ym, ys2, ys1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ywadd_wide_yx`        | `ym, ys2, rs1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ywmaccsu_yy`          | `ym, ys2, ys1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ywmaccsu_yx`          | `ym, ys2, rs1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ywmaccus_yx`          | `ym, ys2, rs1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ywmaccu_yy`           | `ym, ys2, ys1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ywmaccu_yx`           | `ym, ys2, rs1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ywmacc_yy`            | `ym, ys2, ys1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ywmacc_yx`            | `ym, ys2, rs1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ywmulsu_yy`           | `ym, ys2, ys1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ywmulsu_yx`           | `ym, ys2, rs1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ywmulu_yy`            | `ym, ys2, ys1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ywmulu_yx`            | `ym, ys2, rs1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ywmul_yy`             | `ym, ys2, ys1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ywmul_yx`             | `ym, ys2, rs1, yd`   | `tensor, multiply, integer`               |
| `rv_y`        | `ywredsumu_ys`         | `ym, ys2, ys1, yd`   | `tensor, reduction, integer`              |
| `rv_y`        | `ywredsum_ys`          | `ym, ys2, ys1, yd`   | `tensor, reduction, integer`              |
| `rv_y`        | `ywsubu_yy`            | `ym, ys2, ys1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ywsubu_yx`            | `ym, ys2, rs1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ywsubu_wide_yy`       | `ym, ys2, ys1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ywsubu_wide_yx`       | `ym, ys2, rs1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ywsub_yy`             | `ym, ys2, ys1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ywsub_yx`             | `ym, ys2, rs1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ywsub_wide_yy`        | `ym, ys2, ys1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `ywsub_wide_yx`        | `ym, ys2, rs1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `yxor_yi`              | `ym, ys2, simm5, yd` | `tensor, alu, integer`                    |
| `rv_y`        | `yxor_yy`              | `ym, ys2, ys1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `yxor_yx`              | `ym, ys2, rs1, yd`   | `tensor, alu, integer`                    |
| `rv_y`        | `yzext_yf2`            | `ym, ys2, yd`        | `tensor, alu, integer`                    |
| `rv_y`        | `yzext_yf4`            | `ym, ys2, yd`        | `tensor, alu, integer`                    |
| `rv_y`        | `yzext_yf8`            | `ym, ys2, yd`        | `tensor, alu, integer`                    |

:RVY - Specific Extension for Tensor Operations

| **Extension**      | **Name**                  | **Variable-Fields**             | **Class**                                         |
|:-------------------|:--------------------------|:--------------------------------|:--------------------------------------------------|
| `rv_zyabd`         | `yabdu_yy`                | `ym, ys2, ys1, yd`              | `tensor, alu, integer`                            |
| `rv_zyabd`         | `yabdu_yx`                | `ym, ys2, rs1, yd`              | `tensor, alu, integer`                            |
| `rv_zyabd`         | `yabd_yy`                 | `ym, ys2, ys1, yd`              | `tensor, alu, integer`                            |
| `rv_zyabd`         | `yabd_yx`                 | `ym, ys2, rs1, yd`              | `tensor, alu, integer`                            |
| `rv_zyabd`         | `ywabdau_yy`              | `ym, ys2, ys1, yd`              | `tensor, alu, integer`                            |
| `rv_zyabd`         | `ywabdau_yx`              | `ym, ys2, rs1, yd`              | `tensor, alu, integer`                            |
| `rv_zyabd`         | `ywabda_yy`               | `ym, ys2, ys1, yd`              | `tensor, alu, integer`                            |
| `rv_zyabd`         | `ywabda_yx`               | `ym, ys2, rs1, yd`              | `tensor, alu, integer`                            |
| `rv_zybb`          | `yandn_yy`                | `ym, ys2, ys1, yd`              | `tensor, alu, bit-manipulation`                   |
| `rv_zybb`          | `yandn_yx`                | `ym, ys2, rs1, yd`              | `tensor, alu, bit-manipulation`                   |
| `rv_zybb`          | `ybrev8_y`                | `ym, ys2, yd`                   | `tensor, alu, bit-manipulation`                   |
| `rv_zybb`          | `ybrev_y`                 | `ym, ys2, yd`                   | `tensor, alu, bit-manipulation`                   |
| `rv_zybb`          | `yclz_y`                  | `ym, ys2, yd`                   | `tensor, alu, bit-manipulation`                   |
| `rv_zybb`          | `ycpop_y`                 | `ym, ys2, yd`                   | `tensor, alu, bit-manipulation`                   |
| `rv_zybb`          | `yctz_y`                  | `ym, ys2, yd`                   | `tensor, alu, bit-manipulation`                   |
| `rv_zybb`          | `yrev8_y`                 | `ym, ys2, yd`                   | `tensor, alu, bit-manipulation`                   |
| `rv_zybb`          | `yrol_yy`                 | `ym, ys2, ys1, yd`              | `tensor, alu, bit-manipulation`                   |
| `rv_zybb`          | `yrol_yx`                 | `ym, ys2, rs1, yd`              | `tensor, alu, bit-manipulation`                   |
| `rv_zybb`          | `yror_yi`                 | `zimm6hi, ym, ys2, zimm6lo, yd` | `tensor, alu, bit-manipulation`                   |
| `rv_zybb`          | `yror_yy`                 | `ym, ys2, ys1, yd`              | `tensor, alu, bit-manipulation`                   |
| `rv_zybb`          | `yror_yx`                 | `ym, ys2, rs1, yd`              | `tensor, alu, bit-manipulation`                   |
| `rv_zybb`          | `ywsll_yi`                | `ym, ys2, zimm5, yd`            | `tensor, alu, bit-manipulation`                   |
| `rv_zybb`          | `ywsll_yy`                | `ym, ys2, ys1, yd`              | `tensor, alu, bit-manipulation`                   |
| `rv_zybb`          | `ywsll_yx`                | `ym, ys2, rs1, yd`              | `tensor, alu, bit-manipulation`                   |
| `rv_zybc`          | `yclmulh_yy`              | `ym, ys2, ys1, yd`              | `tensor, alu, bit-manipulation`                   |
| `rv_zybc`          | `yclmulh_yx`              | `ym, ys2, rs1, yd`              | `tensor, alu, bit-manipulation`                   |
| `rv_zybc`          | `yclmul_yy`               | `ym, ys2, ys1, yd`              | `tensor, alu, bit-manipulation`                   |
| `rv_zybc`          | `yclmul_yx`               | `ym, ys2, rs1, yd`              | `tensor, alu, bit-manipulation`                   |
| `rv_zydot4a`       | `ydot4asu_yy`             | `ym, ys2, ys1, yd`              | `tensor, alu, integer, dot-product`               |
| `rv_zydot4a`       | `ydot4asu_yx`             | `ym, ys2, rs1, yd`              | `tensor, alu, integer, dot-product`               |
| `rv_zydot4a`       | `ydot4aus_yx`             | `ym, ys2, rs1, yd`              | `tensor, alu, integer, dot-product`               |
| `rv_zydot4a`       | `ydot4au_yy`              | `ym, ys2, ys1, yd`              | `tensor, alu, integer, dot-product`               |
| `rv_zydot4a`       | `ydot4au_yx`              | `ym, ys2, rs1, yd`              | `tensor, alu, integer, dot-product`               |
| `rv_zydot4a`       | `ydot4a_yy`               | `ym, ys2, ys1, yd`              | `tensor, alu, integer, dot-product`               |
| `rv_zydot4a`       | `ydot4a_yx`               | `ym, ys2, rs1, yd`              | `tensor, alu, integer, dot-product`               |
| `rv_zyfbdota32f`   | `yfbdota_yy`              | `ym, ys2x8, ci, ys1, yd`        | `tensor, alu, floating-point, dot-product`        |
| `rv_zyfbfmin`      | `yfncvtbf16_f_f_wide`     | `ym, ys2, yd`                   | `tensor, alu, floating-point, conversion`         |
| `rv_zyfbfmin`      | `yfwcvtbf16_f_f_y`        | `ym, ys2, yd`                   | `tensor, alu, floating-point, conversion`         |
| `rv_zyfbfwma`      | `yfwmaccbf16_yf`          | `ym, ys2, rs1, yd`              | `tensor, alu, floating-point, fused-multiply-add` |
| `rv_zyfbfwma`      | `yfwmaccbf16_yy`          | `ym, ys2, ys1, yd`              | `tensor, alu, floating-point, fused-multiply-add` |
| `rv_zyfofp4min`    | `yfext_yf2`               | `ym, ys2, yd`                   | `tensor, alu, floating-point, conversion`         |
| `rv_zyfofp8min`    | `yfncvtbf16_sat_f_f_wide` | `ym, ys2, yd`                   | `tensor, alu, floating-point, conversion`         |
| `rv_zyfofp8min`    | `yfncvt_f_f_q`            | `ym, ys2, yd`                   | `tensor, alu, floating-point, conversion`         |
| `rv_zyfofp8min`    | `yfncvt_sat_f_f_q`        | `ym, ys2, yd`                   | `tensor, alu, floating-point, conversion`         |
| `rv_zyfqwbdota8f`  | `yfqwbdota_alt_yy`        | `ym, ys2x8, ci, ys1, yd`        | `tensor, alu, floating-point, dot-product`        |
| `rv_zyfqwbdota8f`  | `yfqwbdota_yy`            | `ym, ys2x8, ci, ys1, yd`        | `tensor, alu, floating-point, dot-product`        |
| `rv_zyfqwdota8f`   | `yfqwdota_alt_yy`         | `ym, ys2, ys1, yd`              | `tensor, alu, floating-point, dot-product`        |
| `rv_zyfqwdota8f`   | `yfqwdota_yy`             | `ym, ys2, ys1, yd`              | `tensor, alu, floating-point, dot-product`        |
| `rv_zyfwbdota16bf` | `yfwbdota_yy`             | `ym, ys2x8, ci, ys1, yd`        | `tensor, alu, floating-point, dot-product`        |
| `rv_zyfwdota16bf`  | `yfwdota_yy`              | `ym, ys2, ys1, yd`              | `tensor, alu, floating-point, dot-product`        |
| `rv_zyqwbdota8i`   | `yqwbdotas_yy`            | `ym, ys2x8, ci, ys1, yd`        | `tensor, alu, integer, dot-product`               |
| `rv_zyqwbdota8i`   | `yqwbdotau_yy`            | `ym, ys2x8, ci, ys1, yd`        | `tensor, alu, integer, dot-product`               |
| `rv_zyqwdota8i`    | `yqwdotas_yy`             | `ym, ys2, ys1, yd`              | `tensor, alu, integer, dot-product`               |
| `rv_zyqwdota8i`    | `yqwdotau_yy`             | `ym, ys2, ys1, yd`              | `tensor, alu, integer, dot-product`               |
| `rv_zyt16e`        | `ytle16`                  | `rs2, rs1`                      | `tensor, tile, load`                              |
| `rv_zyt16e`        | `ytse16`                  | `rs2, rs1`                      | `tensor, tile, store`                             |
| `rv_zyt64e`        | `ytle64`                  | `rs2, rs1`                      | `tensor, tile, load`                              |
| `rv_zyt64e`        | `ytse64`                  | `rs2, rs1`                      | `tensor, tile, store`                             |
| `rv_zyt8e`         | `ytle8`                   | `rs2, rs1`                      | `tensor, tile, load`                              |
| `rv_zyt8e`         | `ytse8`                   | `rs2, rs1`                      | `tensor, tile, store`                             |
| `rv_zytbase`       | `ymsetmtype`              | `rs2, rs1, rd`                  | `tensor, tile, configuration`                     |
| `rv_zytbase`       | `ymsetmtypei`             | `altfmt, ysew, mtwiden, rd`     | `tensor, tile, configuration`                     |
| `rv_zytbase`       | `ymsettk`                 | `rs1, rd`                       | `tensor, tile, configuration`                     |
| `rv_zytbase`       | `ymsettm`                 | `rs1, rd`                       | `tensor, tile, configuration`                     |
| `rv_zytbase`       | `ymsettn`                 | `rs1, rd`                       | `tensor, tile, configuration`                     |
| `rv_zytbase`       | `ytdiscard`               | `none`                          | `tensor, tile, context`                           |
| `rv_zytbase`       | `ytle32`                  | `rs2, rs1`                      | `tensor, tile, load`                              |
| `rv_zytbase`       | `ytmv_t_y`                | `ys2, rs1`                      | `tensor, tile, move`                              |
| `rv_zytbase`       | `ytmv_y_t`                | `rs1, yd`                       | `tensor, tile, move`                              |
| `rv_zytbase`       | `ytse32`                  | `rs2, rs1`                      | `tensor, tile, store`                             |
| `rv_zytbase`       | `ytzero`                  | `zyt_mtd16`                     | `tensor, tile, context`                           |
| `rv_zytbf16fmm`    | `ytfmm_alt_tyy`           | `ys2, ys1, zyt_mtd8`            | `tensor, tile, multiply-accumulate`               |
| `rv_zytdmm`        | `ytfmm_tyy`               | `ys2, ys1, zyt_mtd8`            | `tensor, tile, multiply-accumulate`               |
| `rv_zytfmm`        | `ytfmm_tyy`               | `ys2, ys1, zyt_mtd8`            | `tensor, tile, multiply-accumulate`               |
| `rv_zytfp16fmm`    | `ytfmm_tyy`               | `ys2, ys1, zyt_mtd8`            | `tensor, tile, multiply-accumulate`               |
| `rv_zyti8i32mm`    | `ytmms_tyy`               | `ys2, ys1, zyt_mtd8`            | `tensor, tile, multiply-accumulate`               |
| `rv_zyti8i32mm`    | `ytmmu_tyy`               | `ys2, ys1, zyt_mtd8`            | `tensor, tile, multiply-accumulate`               |
| `rv_zytofp8fmm`    | `ytfmm_alt_tyy`           | `ys2, ys1, zyt_mtd8`            | `tensor, tile, multiply-accumulate`               |
| `rv_zytofp8fmm`    | `ytfmm_tyy`               | `ys2, ys1, zyt_mtd8`            | `tensor, tile, multiply-accumulate`               |
| `rv_zyzip`         | `ypaire_yy`               | `ym, ys2, ys1, yd`              | `tensor, permutation`                             |
| `rv_zyzip`         | `ypairo_yy`               | `ym, ys2, ys1, yd`              | `tensor, permutation`                             |
| `rv_zyzip`         | `yunzipe_y`               | `ym, ys2, yd`                   | `tensor, permutation`                             |
| `rv_zyzip`         | `yunzipo_y`               | `ym, ys2, yd`                   | `tensor, permutation`                             |
| `rv_zyzip`         | `yzip_yy`                 | `ym, ys2, ys1, yd`              | `tensor, permutation`                             |

:RVZY - Specific Extension for Tensor Operations
