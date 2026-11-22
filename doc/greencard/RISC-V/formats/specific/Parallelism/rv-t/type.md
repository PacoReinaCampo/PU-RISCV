## INSTRUCTION TYPES

| **Extension** | **Name**  | **Variable-Fields** | **Encoding**                       | **Match**    | **Mask**     | **Type**  |
|:--------------|:----------|:--------------------|:-----------------------------------|:-------------|:-------------|:----------|
| `rv_t`        | `tbegin`  | `rd`                | `00000000000000000000-----0001011` | `0x0000000b` | `0xfffff07f` | `UNKNOWN` |
| `rv_t`        | `tcommit` | `none`              | `00000000000000000001000000001011` | `0x0000100b` | `0xffffffff` | `UNKNOWN` |
| `rv_t`        | `tabort`  | `uimm12`            | `------------00000010000000001011` | `0x0000200b` | `0x000fffff` | `UNKNOWN` |
| `rv_t`        | `ttest`   | `rd`                | `00000000000000000011-----0001011` | `0x0000300b` | `0xfffff07f` | `UNKNOWN` |

:RVT - Specific Extension for Transactional Memory Instructions
