## INSTRUCTION OPCODES

| **Extension** | **Name**          | **Variable-Fields** | **Encoding**                       | **Match**    | **Mask**     |
|:--------------|:------------------|:--------------------|:-----------------------------------|:-------------|:-------------|
| `rv_u`        | `utrapret`        | `none`              | `10001100000000000000000001110011` | `0x8c000073` | `0xffffffff` |
| `rv_usctr`    | `uctrclr`         | `none`              | `10001100000000000000000011110011` | `0x8c0000f3` | `0xffffffff` |
| `rv_u`        | `ufence_vma`      | `rs1, rs2`          | `1000110----------000000101110011` | `0x8c000173` | `0xfe007fff` |
| `rv_uvinval`  | `uinval_vma`      | `rs1, rs2`          | `1000110----------000000111110011` | `0x8c0001f3` | `0xfe007fff` |
| `rv_uvinval`  | `ufence_inval_ir` | `none`              | `10001100000000000000001001110011` | `0x8c000273` | `0xffffffff` |
| `rv_uvinval`  | `ufence_w_inval`  | `none`              | `10001100000000000000001011110011` | `0x8c0002f3` | `0xffffffff` |

:RVU - Specific Extension for User-level Instructions
