## INSTRUCTION FULL-NAMES

| **Extension**  | **Name**          | **Variable-Fields** | **Full-Name**                                                |
|:---------------|:------------------|:--------------------|:-------------------------------------------------------------|
| `rv_sdext`     | `dret`            | `none`              | `Debug-Mode Return`                                          |
| `rv_smrnmi`    | `mnret`           | `none`              | `Machine-Mode Resumable Non-Maskable Interrupt Return`       |
| `rv_ssctr`     | `sctrclr`         | `none`              | `Supervisor Control Transfer Record Clear`                   |
| `rv_s`         | `sfence_vma`      | `rs1, rs2`          | `Supervisor Memory Management Fence`                         |
| `rv_s`         | `sret`            | `none`              | `System Return`                                              |
| `rv_svinval_h` | `hinval_gvma`     | `rs1, rs2`          | `Hypervisor Guest-Physical Address Translation Invalidation` |
| `rv_svinval_h` | `hinval_vvma`     | `rs1, rs2`          | `Hypervisor Guest-Virtual Address Translation Invalidation`  |
| `rv_svinval`   | `sfence_inval_ir` | `none`              | `Fence Invalidation Before Implicit Reads`                   |
| `rv_svinval`   | `sfence_w_inval`  | `none`              | `Fence Writes Before Invalidation`                           |
| `rv_svinval`   | `sinval_vma`      | `rs1, rs2`          | `Supervisor Address Translation Invalidation`                |
| `rv_system`    | `mret`            | `none`              | `Machine-Mode Return`                                        |
| `rv_system`    | `wfi`             | `none`              | `Wait For Interrupt`                                         |

:RVS - Specific Extension for Supervisor-level Instructions