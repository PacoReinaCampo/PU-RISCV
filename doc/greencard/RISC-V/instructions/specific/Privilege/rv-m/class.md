## INSTRUCTION CLASSES

| **Extension**  | **Name**          | **Variable-Fields** | **Class** |
|:---------------|:------------------|:--------------------|:----------|
| `rv_m`         | `mtrapret`        | `none`              | `system`  |
| `rv_msctr`     | `mctrclr`         | `none`              | `system`  |
| `rv_m`         | `mfence_vma`      | `rs1, rs2`          | `system`  |
| `rv_mvinval`   | `minval_vma`      | `rs1, rs2`          | `system`  |
| `rv_mvinval`   | `mfence_inval_ir` | `none`              | `system`  |
| `rv_mvinval`   | `mfence_w_inval`  | `none`              | `system`  |
| `rv_mrnmi`     | `mntrapret`       | `none`              | `system`  |
| `rv_m`         | `mwait`           | `none`              | `system`  |
| `rv_m_h`       | `mfence_gvma`     | `rs1, rs2`          | `system`  |
| `rv_m_h`       | `mfence_vvma`     | `rs1, rs2`          | `system`  |
| `rv_mvinval_h` | `minval_gvma`     | `rs1, rs2`          | `system`  |
| `rv_mvinval_h` | `minval_vvma`     | `rs1, rs2`          | `system`  |
| `rv_msctr`     | `mctrctl`         | `rs1`               | `system`  |

:RVM - Specific Extension for Machine-level Instructions
