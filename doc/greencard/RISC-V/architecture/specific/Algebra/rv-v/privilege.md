## INSTRUCTION PRIVILEGE

| **Extension** | **Name**            | **Variable-Fields**  | **Privilege** |
|:--------------|:--------------------|:---------------------|:--------------|
| `rv_v`        | `vaaddu_vv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vaaddu_vx`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vaadd_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vaadd_vx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vadc_vim`          | `vs2, simm5, vd`     | `U`           |
| `rv_v`        | `vadc_vvm`          | `vs2, vs1, vd`       | `U`           |
| `rv_v`        | `vadc_vxm`          | `vs2, rs1, vd`       | `U`           |
| `rv_v`        | `vadd_vi`           | `vm, vs2, simm5, vd` | `U`           |
| `rv_v`        | `vadd_vv`           | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vadd_vx`           | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vand_vi`           | `vm, vs2, simm5, vd` | `U`           |
| `rv_v`        | `vand_vv`           | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vand_vx`           | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vasubu_vv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vasubu_vx`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vasub_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vasub_vx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vcompress_vm`      | `vs2, vs1, vd`       | `U`           |
| `rv_v`        | `vcpop_m`           | `vm, vs2, rd`        | `U`           |
| `rv_v`        | `vdivu_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vdivu_vx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vdiv_vv`           | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vdiv_vx`           | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfadd_vf`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfadd_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfclass_v`         | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vfcvt_f_xu_v`      | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vfcvt_f_x_v`       | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vfcvt_rtz_x_f_v`   | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vfcvt_rtz_xu_f_v`  | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vfcvt_x_f_v`       | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vfcvt_xu_f_v`      | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vfdiv_vf`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfdiv_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfirst_m`          | `vm, vs2, rd`        | `U`           |
| `rv_v`        | `vfmacc_vf`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfmacc_vv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfmadd_vf`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfmadd_vv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfmax_vf`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfmax_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfmerge_vfm`       | `vs2, rs1, vd`       | `U`           |
| `rv_v`        | `vfmin_vf`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfmin_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfmsac_vf`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfmsac_vv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfmsub_vf`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfmsub_vv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfmul_vf`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfmul_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfmv_f_s`          | `vs2, rd`            | `U`           |
| `rv_v`        | `vfmv_s_f`          | `rs1, vd`            | `U`           |
| `rv_v`        | `vfmv_v_f`          | `rs1, vd`            | `U`           |
| `rv_v`        | `vfncvt_f_f_w`      | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vfncvt_f_xu_w`     | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vfncvt_f_x_w`      | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vfncvt_rod_f_f_w`  | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vfncvt_rtz_x_f_w`  | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vfncvt_rtz_xu_f_w` | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vfncvt_x_f_w`      | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vfncvt_xu_f_w`     | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vfnmacc_vf`        | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfnmacc_vv`        | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfnmadd_vf`        | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfnmadd_vv`        | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfnmsac_vf`        | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfnmsac_vv`        | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfnmsub_vf`        | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfnmsub_vv`        | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfrdiv_vf`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfrec7_v`          | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vfredmax_vs`       | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfredmin_vs`       | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfredosum_vs`      | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfredusum_vs`      | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfrsqrt7_v`        | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vfrsub_vf`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfsgnjn_vf`        | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfsgnjn_vv`        | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfsgnj_vf`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfsgnj_vv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfsgnjx_vf`        | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfsgnjx_vv`        | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfslide1down_vf`   | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfslide1up_vf`     | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfsqrt_v`          | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vfsub_vf`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfsub_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfwadd_vf`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfwadd_vv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfwadd_wf`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfwadd_wv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfwcvt_f_f_v`      | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vfwcvt_f_xu_v`     | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vfwcvt_f_x_v`      | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vfwcvt_rtz_x_f_v`  | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vfwcvt_rtz_xu_f_v` | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vfwcvt_x_f_v`      | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vfwcvt_xu_f_v`     | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vfwmacc_vf`        | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfwmacc_vv`        | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfwmsac_vf`        | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfwmsac_vv`        | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfwmul_vf`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfwmul_vv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfwnmacc_vf`       | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfwnmacc_vv`       | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfwnmsac_vf`       | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfwnmsac_vv`       | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfwredosum_vs`     | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfwredusum_vs`     | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfwsub_vf`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfwsub_vv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vfwsub_wf`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vfwsub_wv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vid_v`             | `vm, vd`             | `U`           |
| `rv_v`        | `viota_m`           | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vl1re16_v`         | `rs1, vd`            | `U`           |
| `rv_v`        | `vl1re32_v`         | `rs1, vd`            | `U`           |
| `rv_v`        | `vl1re64_v`         | `rs1, vd`            | `U`           |
| `rv_v`        | `vl1re8_v`          | `rs1, vd`            | `U`           |
| `rv_v`        | `vl2re16_v`         | `rs1, vd`            | `U`           |
| `rv_v`        | `vl2re32_v`         | `rs1, vd`            | `U`           |
| `rv_v`        | `vl2re64_v`         | `rs1, vd`            | `U`           |
| `rv_v`        | `vl2re8_v`          | `rs1, vd`            | `U`           |
| `rv_v`        | `vl4re16_v`         | `rs1, vd`            | `U`           |
| `rv_v`        | `vl4re32_v`         | `rs1, vd`            | `U`           |
| `rv_v`        | `vl4re64_v`         | `rs1, vd`            | `U`           |
| `rv_v`        | `vl4re8_v`          | `rs1, vd`            | `U`           |
| `rv_v`        | `vl8re16_v`         | `rs1, vd`            | `U`           |
| `rv_v`        | `vl8re32_v`         | `rs1, vd`            | `U`           |
| `rv_v`        | `vl8re64_v`         | `rs1, vd`            | `U`           |
| `rv_v`        | `vl8re8_v`          | `rs1, vd`            | `U`           |
| `rv_v`        | `vle16ff_v`         | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vle16_v`           | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vle32ff_v`         | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vle32_v`           | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vle64ff_v`         | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vle64_v`           | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vle8ff_v`          | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vle8_v`            | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlm_v`             | `rs1, vd`            | `U`           |
| `rv_v`        | `vloxei16_v`        | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxei32_v`        | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxei64_v`        | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxei8_v`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg2ei16_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg2ei32_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg2ei64_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg2ei8_v`     | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg3ei16_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg3ei32_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg3ei64_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg3ei8_v`     | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg4ei16_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg4ei32_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg4ei64_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg4ei8_v`     | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg5ei16_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg5ei32_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg5ei64_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg5ei8_v`     | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg6ei16_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg6ei32_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg6ei64_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg6ei8_v`     | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg7ei16_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg7ei32_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg7ei64_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg7ei8_v`     | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg8ei16_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg8ei32_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg8ei64_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vloxseg8ei8_v`     | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlse16_v`          | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlse32_v`          | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlse64_v`          | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlse8_v`           | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlseg2e16ff_v`     | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg2e16_v`       | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg2e32ff_v`     | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg2e32_v`       | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg2e64ff_v`     | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg2e64_v`       | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg2e8ff_v`      | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg2e8_v`        | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg3e16ff_v`     | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg3e16_v`       | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg3e32ff_v`     | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg3e32_v`       | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg3e64ff_v`     | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg3e64_v`       | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg3e8ff_v`      | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg3e8_v`        | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg4e16ff_v`     | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg4e16_v`       | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg4e32ff_v`     | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg4e32_v`       | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg4e64ff_v`     | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg4e64_v`       | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg4e8ff_v`      | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg4e8_v`        | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg5e16ff_v`     | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg5e16_v`       | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg5e32ff_v`     | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg5e32_v`       | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg5e64ff_v`     | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg5e64_v`       | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg5e8ff_v`      | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg5e8_v`        | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg6e16ff_v`     | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg6e16_v`       | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg6e32ff_v`     | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg6e32_v`       | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg6e64ff_v`     | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg6e64_v`       | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg6e8ff_v`      | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg6e8_v`        | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg7e16ff_v`     | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg7e16_v`       | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg7e32ff_v`     | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg7e32_v`       | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg7e64ff_v`     | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg7e64_v`       | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg7e8ff_v`      | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg7e8_v`        | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg8e16ff_v`     | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg8e16_v`       | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg8e32ff_v`     | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg8e32_v`       | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg8e64ff_v`     | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg8e64_v`       | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg8e8ff_v`      | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlseg8e8_v`        | `vm, rs1, vd`        | `U`           |
| `rv_v`        | `vlsseg2e16_v`      | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg2e32_v`      | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg2e64_v`      | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg2e8_v`       | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg3e16_v`      | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg3e32_v`      | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg3e64_v`      | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg3e8_v`       | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg4e16_v`      | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg4e32_v`      | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg4e64_v`      | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg4e8_v`       | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg5e16_v`      | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg5e32_v`      | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg5e64_v`      | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg5e8_v`       | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg6e16_v`      | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg6e32_v`      | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg6e64_v`      | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg6e8_v`       | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg7e16_v`      | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg7e32_v`      | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg7e64_v`      | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg7e8_v`       | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg8e16_v`      | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg8e32_v`      | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg8e64_v`      | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vlsseg8e8_v`       | `vm, rs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxei16_v`        | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxei32_v`        | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxei64_v`        | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxei8_v`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg2ei16_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg2ei32_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg2ei64_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg2ei8_v`     | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg3ei16_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg3ei32_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg3ei64_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg3ei8_v`     | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg4ei16_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg4ei32_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg4ei64_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg4ei8_v`     | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg5ei16_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg5ei32_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg5ei64_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg5ei8_v`     | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg6ei16_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg6ei32_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg6ei64_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg6ei8_v`     | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg7ei16_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg7ei32_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg7ei64_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg7ei8_v`     | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg8ei16_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg8ei32_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg8ei64_v`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vluxseg8ei8_v`     | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vmacc_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vmacc_vx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vmadc_vi`          | `vs2, simm5, vd`     | `U`           |
| `rv_v`        | `vmadc_vim`         | `vs2, simm5, vd`     | `U`           |
| `rv_v`        | `vmadc_vv`          | `vs2, vs1, vd`       | `U`           |
| `rv_v`        | `vmadc_vvm`         | `vs2, vs1, vd`       | `U`           |
| `rv_v`        | `vmadc_vx`          | `vs2, rs1, vd`       | `U`           |
| `rv_v`        | `vmadc_vxm`         | `vs2, rs1, vd`       | `U`           |
| `rv_v`        | `vmadd_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vmadd_vx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vmand_mm`          | `vs2, vs1, vd`       | `U`           |
| `rv_v`        | `vmandn_mm`         | `vs2, vs1, vd`       | `U`           |
| `rv_v`        | `vmaxu_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vmaxu_vx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vmax_vv`           | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vmax_vx`           | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vmerge_vim`        | `vs2, simm5, vd`     | `U`           |
| `rv_v`        | `vmerge_vvm`        | `vs2, vs1, vd`       | `U`           |
| `rv_v`        | `vmerge_vxm`        | `vs2, rs1, vd`       | `U`           |
| `rv_v`        | `vmfeq_vf`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vmfeq_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vmfge_vf`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vmfgt_vf`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vmfle_vf`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vmfle_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vmflt_vf`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vmflt_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vmfne_vf`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vmfne_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vminu_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vminu_vx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vmin_vv`           | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vmin_vx`           | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vmnand_mm`         | `vs2, vs1, vd`       | `U`           |
| `rv_v`        | `vmnor_mm`          | `vs2, vs1, vd`       | `U`           |
| `rv_v`        | `vmor_mm`           | `vs2, vs1, vd`       | `U`           |
| `rv_v`        | `vmorn_mm`          | `vs2, vs1, vd`       | `U`           |
| `rv_v`        | `vmsbc_vv`          | `vs2, vs1, vd`       | `U`           |
| `rv_v`        | `vmsbc_vvm`         | `vs2, vs1, vd`       | `U`           |
| `rv_v`        | `vmsbc_vx`          | `vs2, rs1, vd`       | `U`           |
| `rv_v`        | `vmsbc_vxm`         | `vs2, rs1, vd`       | `U`           |
| `rv_v`        | `vmsbf_m`           | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vmseq_vi`          | `vm, vs2, simm5, vd` | `U`           |
| `rv_v`        | `vmseq_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vmseq_vx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vmsgtu_vi`         | `vm, vs2, simm5, vd` | `U`           |
| `rv_v`        | `vmsgtu_vx`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vmsgt_vi`          | `vm, vs2, simm5, vd` | `U`           |
| `rv_v`        | `vmsgt_vx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vmsif_m`           | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vmsleu_vi`         | `vm, vs2, simm5, vd` | `U`           |
| `rv_v`        | `vmsleu_vv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vmsleu_vx`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vmsle_vi`          | `vm, vs2, simm5, vd` | `U`           |
| `rv_v`        | `vmsle_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vmsle_vx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vmsltu_vv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vmsltu_vx`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vmslt_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vmslt_vx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vmsne_vi`          | `vm, vs2, simm5, vd` | `U`           |
| `rv_v`        | `vmsne_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vmsne_vx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vmsof_m`           | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vmulhsu_vv`        | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vmulhsu_vx`        | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vmulhu_vv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vmulhu_vx`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vmulh_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vmulh_vx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vmul_vv`           | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vmul_vx`           | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vmv1r_v`           | `vs2, vd`            | `U`           |
| `rv_v`        | `vmv2r_v`           | `vs2, vd`            | `U`           |
| `rv_v`        | `vmv4r_v`           | `vs2, vd`            | `U`           |
| `rv_v`        | `vmv8r_v`           | `vs2, vd`            | `U`           |
| `rv_v`        | `vmv_s_x`           | `rs1, vd`            | `U`           |
| `rv_v`        | `vmv_v_i`           | `simm5, vd`          | `U`           |
| `rv_v`        | `vmv_v_v`           | `vs1, vd`            | `U`           |
| `rv_v`        | `vmv_v_x`           | `rs1, vd`            | `U`           |
| `rv_v`        | `vmv_x_s`           | `vs2, rd`            | `U`           |
| `rv_v`        | `vmxnor_mm`         | `vs2, vs1, vd`       | `U`           |
| `rv_v`        | `vmxor_mm`          | `vs2, vs1, vd`       | `U`           |
| `rv_v`        | `vnclipu_wi`        | `vm, vs2, zimm5, vd` | `U`           |
| `rv_v`        | `vnclipu_wv`        | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vnclipu_wx`        | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vnclip_wi`         | `vm, vs2, zimm5, vd` | `U`           |
| `rv_v`        | `vnclip_wv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vnclip_wx`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vnmsac_vv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vnmsac_vx`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vnmsub_vv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vnmsub_vx`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vnsra_wi`          | `vm, vs2, zimm5, vd` | `U`           |
| `rv_v`        | `vnsra_wv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vnsra_wx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vnsrl_wi`          | `vm, vs2, zimm5, vd` | `U`           |
| `rv_v`        | `vnsrl_wv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vnsrl_wx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vor_vi`            | `vm, vs2, simm5, vd` | `U`           |
| `rv_v`        | `vor_vv`            | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vor_vx`            | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vredand_vs`        | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vredmaxu_vs`       | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vredmax_vs`        | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vredminu_vs`       | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vredmin_vs`        | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vredor_vs`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vredsum_vs`        | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vredxor_vs`        | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vremu_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vremu_vx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vrem_vv`           | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vrem_vx`           | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vrgatherei16_vv`   | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vrgather_vi`       | `vm, vs2, zimm5, vd` | `U`           |
| `rv_v`        | `vrgather_vv`       | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vrgather_vx`       | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vrsub_vi`          | `vm, vs2, simm5, vd` | `U`           |
| `rv_v`        | `vrsub_vx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vs1r_v`            | `rs1, vs3`           | `U`           |
| `rv_v`        | `vs2r_v`            | `rs1, vs3`           | `U`           |
| `rv_v`        | `vs4r_v`            | `rs1, vs3`           | `U`           |
| `rv_v`        | `vs8r_v`            | `rs1, vs3`           | `U`           |
| `rv_v`        | `vsaddu_vi`         | `vm, vs2, simm5, vd` | `U`           |
| `rv_v`        | `vsaddu_vv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vsaddu_vx`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vsadd_vi`          | `vm, vs2, simm5, vd` | `U`           |
| `rv_v`        | `vsadd_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vsadd_vx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vsbc_vvm`          | `vs2, vs1, vd`       | `U`           |
| `rv_v`        | `vsbc_vxm`          | `vs2, rs1, vd`       | `U`           |
| `rv_v`        | `vse16_v`           | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vse32_v`           | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vse64_v`           | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vse8_v`            | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsetivli`          | `zimm10, zimm5, rd`  | `U`           |
| `rv_v`        | `vsetvl`            | `rs2, rs1, rd`       | `U`           |
| `rv_v`        | `vsetvli`           | `zimm11, rs1, rd`    | `U`           |
| `rv_v`        | `vsext_vf2`         | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vsext_vf4`         | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vsext_vf8`         | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vslide1down_vx`    | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vslide1up_vx`      | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vslidedown_vi`     | `vm, vs2, zimm5, vd` | `U`           |
| `rv_v`        | `vslidedown_vx`     | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vslideup_vi`       | `vm, vs2, zimm5, vd` | `U`           |
| `rv_v`        | `vslideup_vx`       | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vsll_vi`           | `vm, vs2, zimm5, vd` | `U`           |
| `rv_v`        | `vsll_vv`           | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vsll_vx`           | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vsmul_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vsmul_vx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vsm_v`             | `rs1, vs3`           | `U`           |
| `rv_v`        | `vsoxei16_v`        | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxei32_v`        | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxei64_v`        | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxei8_v`         | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg2ei16_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg2ei32_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg2ei64_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg2ei8_v`     | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg3ei16_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg3ei32_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg3ei64_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg3ei8_v`     | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg4ei16_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg4ei32_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg4ei64_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg4ei8_v`     | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg5ei16_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg5ei32_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg5ei64_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg5ei8_v`     | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg6ei16_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg6ei32_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg6ei64_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg6ei8_v`     | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg7ei16_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg7ei32_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg7ei64_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg7ei8_v`     | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg8ei16_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg8ei32_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg8ei64_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsoxseg8ei8_v`     | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsra_vi`           | `vm, vs2, zimm5, vd` | `U`           |
| `rv_v`        | `vsra_vv`           | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vsra_vx`           | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vsrl_vi`           | `vm, vs2, zimm5, vd` | `U`           |
| `rv_v`        | `vsrl_vv`           | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vsrl_vx`           | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vsse16_v`          | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsse32_v`          | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsse64_v`          | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsse8_v`           | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsseg2e16_v`       | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg2e32_v`       | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg2e64_v`       | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg2e8_v`        | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg3e16_v`       | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg3e32_v`       | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg3e64_v`       | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg3e8_v`        | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg4e16_v`       | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg4e32_v`       | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg4e64_v`       | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg4e8_v`        | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg5e16_v`       | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg5e32_v`       | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg5e64_v`       | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg5e8_v`        | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg6e16_v`       | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg6e32_v`       | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg6e64_v`       | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg6e8_v`        | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg7e16_v`       | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg7e32_v`       | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg7e64_v`       | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg7e8_v`        | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg8e16_v`       | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg8e32_v`       | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg8e64_v`       | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vsseg8e8_v`        | `vm, rs1, vs3`       | `U`           |
| `rv_v`        | `vssra_vi`          | `vm, vs2, zimm5, vd` | `U`           |
| `rv_v`        | `vssra_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vssra_vx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vssrl_vi`          | `vm, vs2, zimm5, vd` | `U`           |
| `rv_v`        | `vssrl_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vssrl_vx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vssseg2e16_v`      | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg2e32_v`      | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg2e64_v`      | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg2e8_v`       | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg3e16_v`      | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg3e32_v`      | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg3e64_v`      | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg3e8_v`       | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg4e16_v`      | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg4e32_v`      | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg4e64_v`      | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg4e8_v`       | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg5e16_v`      | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg5e32_v`      | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg5e64_v`      | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg5e8_v`       | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg6e16_v`      | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg6e32_v`      | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg6e64_v`      | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg6e8_v`       | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg7e16_v`      | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg7e32_v`      | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg7e64_v`      | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg7e8_v`       | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg8e16_v`      | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg8e32_v`      | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg8e64_v`      | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssseg8e8_v`       | `vm, rs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vssubu_vv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vssubu_vx`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vssub_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vssub_vx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vsub_vv`           | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vsub_vx`           | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vsuxei16_v`        | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxei32_v`        | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxei64_v`        | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxei8_v`         | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg2ei16_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg2ei32_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg2ei64_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg2ei8_v`     | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg3ei16_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg3ei32_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg3ei64_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg3ei8_v`     | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg4ei16_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg4ei32_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg4ei64_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg4ei8_v`     | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg5ei16_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg5ei32_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg5ei64_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg5ei8_v`     | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg6ei16_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg6ei32_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg6ei64_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg6ei8_v`     | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg7ei16_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg7ei32_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg7ei64_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg7ei8_v`     | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg8ei16_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg8ei32_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg8ei64_v`    | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vsuxseg8ei8_v`     | `vm, vs2, rs1, vs3`  | `U`           |
| `rv_v`        | `vwaddu_vv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vwaddu_vx`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vwaddu_wv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vwaddu_wx`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vwadd_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vwadd_vx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vwadd_wv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vwadd_wx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vwmaccsu_vv`       | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vwmaccsu_vx`       | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vwmaccus_vx`       | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vwmaccu_vv`        | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vwmaccu_vx`        | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vwmacc_vv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vwmacc_vx`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vwmulsu_vv`        | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vwmulsu_vx`        | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vwmulu_vv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vwmulu_vx`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vwmul_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vwmul_vx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vwredsumu_vs`      | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vwredsum_vs`       | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vwsubu_vv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vwsubu_vx`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vwsubu_wv`         | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vwsubu_wx`         | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vwsub_vv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vwsub_vx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vwsub_wv`          | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vwsub_wx`          | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vxor_vi`           | `vm, vs2, simm5, vd` | `U`           |
| `rv_v`        | `vxor_vv`           | `vm, vs2, vs1, vd`   | `U`           |
| `rv_v`        | `vxor_vx`           | `vm, vs2, rs1, vd`   | `U`           |
| `rv_v`        | `vzext_vf2`         | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vzext_vf4`         | `vm, vs2, vd`        | `U`           |
| `rv_v`        | `vzext_vf8`         | `vm, vs2, vd`        | `U`           |

:RVV - Specific Extension for Vector Operations

| **Extension**      | **Name**               | **Variable-Fields**             | **Privilege** |
|:-------------------|:-----------------------|:--------------------------------|:--------------|
| `rv_zvabd`         | `vabdu_vv`             | `vm, vs2, vs1, vd`              | `U`           |
| `rv_zvabd`         | `vabdu_vx`             | `vm, vs2, rs1, vd`              | `U`           |
| `rv_zvabd`         | `vabd_vv`              | `vm, vs2, vs1, vd`              | `U`           |
| `rv_zvabd`         | `vabd_vx`              | `vm, vs2, rs1, vd`              | `U`           |
| `rv_zvabd`         | `vwabdau_vv`           | `vm, vs2, vs1, vd`              | `U`           |
| `rv_zvabd`         | `vwabdau_vx`           | `vm, vs2, rs1, vd`              | `U`           |
| `rv_zvabd`         | `vwabda_vv`            | `vm, vs2, vs1, vd`              | `U`           |
| `rv_zvabd`         | `vwabda_vx`            | `vm, vs2, rs1, vd`              | `U`           |
| `rv_zvbb`          | `vandn_vv`             | `vm, vs2, vs1, vd`              | `U`           |
| `rv_zvbb`          | `vandn_vx`             | `vm, vs2, rs1, vd`              | `U`           |
| `rv_zvbb`          | `vbrev8_v`             | `vm, vs2, vd`                   | `U`           |
| `rv_zvbb`          | `vbrev_v`              | `vm, vs2, vd`                   | `U`           |
| `rv_zvbb`          | `vclz_v`               | `vm, vs2, vd`                   | `U`           |
| `rv_zvbb`          | `vcpop_v`              | `vm, vs2, vd`                   | `U`           |
| `rv_zvbb`          | `vctz_v`               | `vm, vs2, vd`                   | `U`           |
| `rv_zvbb`          | `vrev8_v`              | `vm, vs2, vd`                   | `U`           |
| `rv_zvbb`          | `vrol_vv`              | `vm, vs2, vs1, vd`              | `U`           |
| `rv_zvbb`          | `vrol_vx`              | `vm, vs2, rs1, vd`              | `U`           |
| `rv_zvbb`          | `vror_vi`              | `zimm6hi, vm, vs2, zimm6lo, vd` | `U`           |
| `rv_zvbb`          | `vror_vv`              | `vm, vs2, vs1, vd`              | `U`           |
| `rv_zvbb`          | `vror_vx`              | `vm, vs2, rs1, vd`              | `U`           |
| `rv_zvbb`          | `vwsll_vi`             | `vm, vs2, zimm5, vd`            | `U`           |
| `rv_zvbb`          | `vwsll_vv`             | `vm, vs2, vs1, vd`              | `U`           |
| `rv_zvbb`          | `vwsll_vx`             | `vm, vs2, rs1, vd`              | `U`           |
| `rv_zvbc`          | `vclmulh_vv`           | `vm, vs2, vs1, vd`              | `U`           |
| `rv_zvbc`          | `vclmulh_vx`           | `vm, vs2, rs1, vd`              | `U`           |
| `rv_zvbc`          | `vclmul_vv`            | `vm, vs2, vs1, vd`              | `U`           |
| `rv_zvbc`          | `vclmul_vx`            | `vm, vs2, rs1, vd`              | `U`           |
| `rv_zvdot4a`       | `vdot4asu_vv`          | `vm, vs2, vs1, vd`              | `U`           |
| `rv_zvdot4a`       | `vdot4asu_vx`          | `vm, vs2, rs1, vd`              | `U`           |
| `rv_zvdot4a`       | `vdot4aus_vx`          | `vm, vs2, rs1, vd`              | `U`           |
| `rv_zvdot4a`       | `vdot4au_vv`           | `vm, vs2, vs1, vd`              | `U`           |
| `rv_zvdot4a`       | `vdot4au_vx`           | `vm, vs2, rs1, vd`              | `U`           |
| `rv_zvdot4a`       | `vdot4a_vv`            | `vm, vs2, vs1, vd`              | `U`           |
| `rv_zvdot4a`       | `vdot4a_vx`            | `vm, vs2, rs1, vd`              | `U`           |
| `rv_zvfbdota32f`   | `vfbdota_vv`           | `vm, vs2x8, ci, vs1, vd`        | `U`           |
| `rv_zvfbfmin`      | `vfncvtbf16_f_f_w`     | `vm, vs2, vd`                   | `U`           |
| `rv_zvfbfmin`      | `vfwcvtbf16_f_f_v`     | `vm, vs2, vd`                   | `U`           |
| `rv_zvfbfwma`      | `vfwmaccbf16_vf`       | `vm, vs2, rs1, vd`              | `U`           |
| `rv_zvfbfwma`      | `vfwmaccbf16_vv`       | `vm, vs2, vs1, vd`              | `U`           |
| `rv_zvfofp4min`    | `vfext_vf2`            | `vm, vs2, vd`                   | `U`           |
| `rv_zvfofp8min`    | `vfncvtbf16_sat_f_f_w` | `vm, vs2, vd`                   | `U`           |
| `rv_zvfofp8min`    | `vfncvt_f_f_q`         | `vm, vs2, vd`                   | `U`           |
| `rv_zvfofp8min`    | `vfncvt_sat_f_f_q`     | `vm, vs2, vd`                   | `U`           |
| `rv_zvfqwbdota8f`  | `vfqwbdota_alt_vv`     | `vm, vs2x8, ci, vs1, vd`        | `U`           |
| `rv_zvfqwbdota8f`  | `vfqwbdota_vv`         | `vm, vs2x8, ci, vs1, vd`        | `U`           |
| `rv_zvfqwdota8f`   | `vfqwdota_alt_vv`      | `vm, vs2, vs1, vd`              | `U`           |
| `rv_zvfqwdota8f`   | `vfqwdota_vv`          | `vm, vs2, vs1, vd`              | `U`           |
| `rv_zvfwbdota16bf` | `vfwbdota_vv`          | `vm, vs2x8, ci, vs1, vd`        | `U`           |
| `rv_zvfwdota16bf`  | `vfwdota_vv`           | `vm, vs2, vs1, vd`              | `U`           |
| `rv_zvqwbdota8i`   | `vqwbdotas_vv`         | `vm, vs2x8, ci, vs1, vd`        | `U`           |
| `rv_zvqwbdota8i`   | `vqwbdotau_vv`         | `vm, vs2x8, ci, vs1, vd`        | `U`           |
| `rv_zvqwdota8i`    | `vqwdotas_vv`          | `vm, vs2, vs1, vd`              | `U`           |
| `rv_zvqwdota8i`    | `vqwdotau_vv`          | `vm, vs2, vs1, vd`              | `U`           |
| `rv_zvt16e`        | `vtle16`               | `rs2, rs1`                      | `U`           |
| `rv_zvt16e`        | `vtse16`               | `rs2, rs1`                      | `U`           |
| `rv_zvt64e`        | `vtle64`               | `rs2, rs1`                      | `U`           |
| `rv_zvt64e`        | `vtse64`               | `rs2, rs1`                      | `U`           |
| `rv_zvt8e`         | `vtle8`                | `rs2, rs1`                      | `U`           |
| `rv_zvt8e`         | `vtse8`                | `rs2, rs1`                      | `U`           |
| `rv_zvtbase`       | `msetmtype`            | `rs2, rs1, rd`                  | `U`           |
| `rv_zvtbase`       | `msetmtypei`           | `altfmt, vsew, mtwiden, rd`     | `U`           |
| `rv_zvtbase`       | `msettk`               | `rs1, rd`                       | `U`           |
| `rv_zvtbase`       | `msettm`               | `rs1, rd`                       | `U`           |
| `rv_zvtbase`       | `msettn`               | `rs1, rd`                       | `U`           |
| `rv_zvtbase`       | `vtdiscard`            | `none`                          | `U`           |
| `rv_zvtbase`       | `vtle32`               | `rs2, rs1`                      | `U`           |
| `rv_zvtbase`       | `vtmv_t_v`             | `vs2, rs1`                      | `U`           |
| `rv_zvtbase`       | `vtmv_v_t`             | `rs1, vd`                       | `U`           |
| `rv_zvtbase`       | `vtse32`               | `rs2, rs1`                      | `U`           |
| `rv_zvtbase`       | `vtzero`               | `zvt_mtd16`                     | `U`           |
| `rv_zvtbf16fmm`    | `vtfmm_alt_tvv`        | `vs2, vs1, zvt_mtd8`            | `U`           |
| `rv_zvtdmm`        | `vtfmm_tvv`            | `vs2, vs1, zvt_mtd8`            | `U`           |
| `rv_zvtfmm`        | `vtfmm_tvv`            | `vs2, vs1, zvt_mtd8`            | `U`           |
| `rv_zvtfp16fmm`    | `vtfmm_tvv`            | `vs2, vs1, zvt_mtd8`            | `U`           |
| `rv_zvti8i32mm`    | `vtmms_tvv`            | `vs2, vs1, zvt_mtd8`            | `U`           |
| `rv_zvti8i32mm`    | `vtmmu_tvv`            | `vs2, vs1, zvt_mtd8`            | `U`           |
| `rv_zvtofp8fmm`    | `vtfmm_alt_tvv`        | `vs2, vs1, zvt_mtd8`            | `U`           |
| `rv_zvtofp8fmm`    | `vtfmm_tvv`            | `vs2, vs1, zvt_mtd8`            | `U`           |
| `rv_zvzip`         | `vpaire_vv`            | `vm, vs2, vs1, vd`              | `U`           |
| `rv_zvzip`         | `vpairo_vv`            | `vm, vs2, vs1, vd`              | `U`           |
| `rv_zvzip`         | `vunzipe_v`            | `vm, vs2, vd`                   | `U`           |
| `rv_zvzip`         | `vunzipo_v`            | `vm, vs2, vd`                   | `U`           |
| `rv_zvzip`         | `vzip_vv`              | `vm, vs2, vs1, vd`              | `U`           |

:RVZV - Specific Extension for Vector Operations
