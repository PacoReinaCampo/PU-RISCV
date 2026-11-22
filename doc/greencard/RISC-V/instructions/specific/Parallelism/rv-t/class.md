## INSTRUCTION CLASSES

| **Extension** | **Name**  | **Variable-Fields** | **Class**       |
|:--------------|:----------|:--------------------|:----------------|
| `rv_t`        | `tbegin`  | `rd`                | `transactional` |
| `rv_t`        | `tcommit` | `none`              | `transactional` |
| `rv_t`        | `tabort`  | `uimm12`            | `transactional` |
| `rv_t`        | `ttest`   | `rd`                | `transactional` |

:RVT - Specific Extension for Transactional Memory Instructions
