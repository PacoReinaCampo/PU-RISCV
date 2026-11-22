## INSTRUCTION CLASSES

| **Extension**  | **Name**          | **Variable-Fields** | **Class** |
|:---------------|:------------------|:--------------------|:----------|
| `rv_sdext`     | `dret`            | `none`              | `system`  |
| `rv_smrnmi`    | `mnret`           | `none`              | `system`  |
| `rv_ssctr`     | `sctrclr`         | `none`              | `system`  |
| `rv_s`         | `sfence_vma`      | `rs1, rs2`          | `system`  |
| `rv_s`         | `sret`            | `none`              | `system`  |
| `rv_svinval_h` | `hinval_gvma`     | `rs1, rs2`          | `system`  |
| `rv_svinval_h` | `hinval_vvma`     | `rs1, rs2`          | `system`  |
| `rv_svinval`   | `sfence_inval_ir` | `none`              | `system`  |
| `rv_svinval`   | `sfence_w_inval`  | `none`              | `system`  |
| `rv_svinval`   | `sinval_vma`      | `rs1, rs2`          | `system`  |
| `rv_system`    | `mret`            | `none`              | `system`  |
| `rv_system`    | `wfi`             | `none`              | `system`  |

:RVS - Specific Extension for Supervisor-level Instructions