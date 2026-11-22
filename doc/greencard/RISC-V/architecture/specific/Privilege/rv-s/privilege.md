## INSTRUCTION PRIVILEGE

| **Extension**  | **Name**          | **Privilege** |
|:---------------|:------------------|:--------------|
| `rv_sdext`     | `dret`            | `D`           |
| `rv_smrnmi`    | `mnret`           | `M`           |
| `rv_ssctr`     | `sctrclr`         | `S`           |
| `rv_s`         | `sfence_vma`      | `S`           |
| `rv_s`         | `sret`            | `S`           |
| `rv_svinval_h` | `hinval_gvma`     | `S`           |
| `rv_svinval_h` | `hinval_vvma`     | `S`           |
| `rv_svinval`   | `sfence_inval_ir` | `S`           |
| `rv_svinval`   | `sfence_w_inval`  | `S`           |
| `rv_svinval`   | `sinval_vma`      | `S`           |
| `rv_system`    | `mret`            | `M`           |
| `rv_system`    | `wfi`             | `S`           |

:RVS - Specific Extension for Supervisor-level Instructions
