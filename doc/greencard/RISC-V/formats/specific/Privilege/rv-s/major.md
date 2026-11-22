## INSTRUCTION MAJORS

| **Extension**  | **Name**          | **Variable-Fields** | **Encoding**                       | **Match**    | **Mask**     | **Major** |
|:---------------|:------------------|:--------------------|:-----------------------------------|:-------------|:-------------|:----------|
| `rv_sdext`     | `dret`            | `none`              | `01111011001000000000000001110011` | `0x7b200073` | `0xffffffff` | `system`  |
| `rv_smrnmi`    | `mnret`           | `none`              | `01110000001000000000000001110011` | `0x70200073` | `0xffffffff` | `system`  |
| `rv_ssctr`     | `sctrclr`         | `none`              | `00010000010000000000000001110011` | `0x10400073` | `0xffffffff` | `system`  |
| `rv_s`         | `sfence_vma`      | `rs1, rs2`          | `0001001----------000000001110011` | `0x12000073` | `0xfe007fff` | `system`  |
| `rv_s`         | `sret`            | `none`              | `00010000001000000000000001110011` | `0x10200073` | `0xffffffff` | `system`  |
| `rv_svinval_h` | `hinval_gvma`     | `rs1, rs2`          | `0110011----------000000001110011` | `0x66000073` | `0xfe007fff` | `system`  |
| `rv_svinval_h` | `hinval_vvma`     | `rs1, rs2`          | `0010011----------000000001110011` | `0x26000073` | `0xfe007fff` | `system`  |
| `rv_svinval`   | `sfence_inval_ir` | `none`              | `00011000000100000000000001110011` | `0x18100073` | `0xffffffff` | `system`  |
| `rv_svinval`   | `sfence_w_inval`  | `none`              | `00011000000000000000000001110011` | `0x18000073` | `0xffffffff` | `system`  |
| `rv_svinval`   | `sinval_vma`      | `rs1, rs2`          | `0001011----------000000001110011` | `0x16000073` | `0xfe007fff` | `system`  |
| `rv_system`    | `mret`            | `none`              | `00110000001000000000000001110011` | `0x30200073` | `0xffffffff` | `system`  |
| `rv_system`    | `wfi`             | `none`              | `00010000010100000000000001110011` | `0x10500073` | `0xffffffff` | `system`  |

:RVS - Specific Extension for Supervisor-level Instructions
