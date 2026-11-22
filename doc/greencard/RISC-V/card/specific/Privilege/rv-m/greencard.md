# GREENCARD

| **Extension**  | **Name**          | **Variable-Fields** | **Encoding**                       | **Match**    | **Mask**     |
|:---------------|:------------------|:--------------------|:-----------------------------------|:-------------|:-------------|
| `rv_m`         | `mtrapret`        | `none`              | `10111100000000000000000001110011` | `0xbc000073` | `0xffffffff` |
| `rv_msctr`     | `mctrclr`         | `none`              | `10111100000000000000000011110011` | `0xbc0000f3` | `0xffffffff` |
| `rv_m`         | `mfence_vma`      | `rs1, rs2`          | `1011110----------000000101110011` | `0xbc000173` | `0xfe007fff` |
| `rv_mvinval`   | `minval_vma`      | `rs1, rs2`          | `1011110----------000000111110011` | `0xbc0001f3` | `0xfe007fff` |
| `rv_mvinval`   | `mfence_inval_ir` | `none`              | `10111100000000000000001001110011` | `0xbc000273` | `0xffffffff` |
| `rv_mvinval`   | `mfence_w_inval`  | `none`              | `10111100000000000000001011110011` | `0xbc0002f3` | `0xffffffff` |
| `rv_mrnmi`     | `mntrapret`       | `none`              | `10111100000000000000001101110011` | `0xbc000373` | `0xffffffff` |
| `rv_m`         | `mwait`           | `none`              | `10111100000000000000001111110011` | `0xbc0003f3` | `0xffffffff` |
| `rv_m_h`       | `mfence_gvma`     | `rs1, rs2`          | `1011110----------000010001110011` | `0xbc000473` | `0xfe007fff` |
| `rv_m_h`       | `mfence_vvma`     | `rs1, rs2`          | `1011110----------000010011110011` | `0xbc0004f3` | `0xfe007fff` |
| `rv_mvinval_h` | `minval_gvma`     | `rs1, rs2`          | `1011110----------000010101110011` | `0xbc000573` | `0xfe007fff` |
| `rv_mvinval_h` | `minval_vvma`     | `rs1, rs2`          | `1011110----------000010111110011` | `0xbc0005f3` | `0xfe007fff` |
| `rv_msctr`     | `mctrctl`         | `rs1`               | `101111000000-----000011001110011` | `0xbc000673` | `0xfff07fff` |

:RVM - Specific Extension for Machine-level Instructions