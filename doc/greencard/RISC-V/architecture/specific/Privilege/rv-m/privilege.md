## INSTRUCTION PRIVILEGE

| **Extension**  | **Name**          | **Privilege** |
|:---------------|:------------------|:--------------|
| `rv_m`         | `mtrapret`        | `M`           |
| `rv_msctr`     | `mctrclr`         | `M`           |
| `rv_m`         | `mfence_vma`      | `M`           |
| `rv_mvinval`   | `minval_vma`      | `M`           |
| `rv_mvinval`   | `mfence_inval_ir` | `M`           |
| `rv_mvinval`   | `mfence_w_inval`  | `M`           |
| `rv_mrnmi`     | `mntrapret`       | `M`           |
| `rv_m`         | `mwait`           | `M`           |
| `rv_m_h`       | `mfence_gvma`     | `M`           |
| `rv_m_h`       | `mfence_vvma`     | `M`           |
| `rv_mvinval_h` | `minval_gvma`     | `M`           |
| `rv_mvinval_h` | `minval_vvma`     | `M`           |
| `rv_msctr`     | `mctrctl`         | `M`           |

:RVM - Specific Extension for Machine-level Instructions
