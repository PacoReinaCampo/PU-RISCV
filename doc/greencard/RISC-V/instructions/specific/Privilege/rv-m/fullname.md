## INSTRUCTION FULL-NAMES

| **Extension**  | **Name**          | **Variable-Fields** | **Full-Name**                                             |
|:---------------|:------------------|:--------------------|:----------------------------------------------------------|
| `rv_m`         | `mtrapret`        | `none`              | `Machine Trap Return`                                     |
| `rv_msctr`     | `mctrclr`         | `none`              | `Machine Control Transfer Record Clear`                   |
| `rv_m`         | `mfence_vma`      | `rs1, rs2`          | `Machine Supervisor Address Translation Fence`            |
| `rv_mvinval`   | `minval_vma`      | `rs1, rs2`          | `Machine Supervisor Address Translation Invalidation`     |
| `rv_mvinval`   | `mfence_inval_ir` | `none`              | `Machine Fence Invalidation Before Implicit Reads`        |
| `rv_mvinval`   | `mfence_w_inval`  | `none`              | `Machine Fence Writes Before Invalidation`                |
| `rv_mrnmi`     | `mntrapret`       | `none`              | `Machine Non-Maskable Interrupt Trap Return`              |
| `rv_m`         | `mwait`           | `none`              | `Machine Wait for Event`                                  |
| `rv_m_h`       | `mfence_gvma`     | `rs1, rs2`          | `Machine Guest-Physical Address Translation Fence`        |
| `rv_m_h`       | `mfence_vvma`     | `rs1, rs2`          | `Machine Guest-Virtual Address Translation Fence`         |
| `rv_mvinval_h` | `minval_gvma`     | `rs1, rs2`          | `Machine Guest-Physical Address Translation Invalidation` |
| `rv_mvinval_h` | `minval_vvma`     | `rs1, rs2`          | `Machine Guest-Virtual Address Translation Invalidation`  |
| `rv_msctr`     | `mctrctl`         | `rs1`               | `Machine Control Transfer Record Control`                 |

:RVM - Specific Extension for Machine-level Instructions
