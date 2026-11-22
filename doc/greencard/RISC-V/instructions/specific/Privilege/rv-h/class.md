## INSTRUCTION CLASSES

| **Extension** | **Name**      | **Variable-Fields** | **Class**    |
|:--------------|:--------------|:--------------------|:-------------|
| `rv_h`        | `hfence_gvma` | `rs1, rs2`          | `hypervisor` |
| `rv_h`        | `hfence_vvma` | `rs1, rs2`          | `hypervisor` |
| `rv_h`        | `hlv_b`       | `rd, rs1`           | `hypervisor` |
| `rv_h`        | `hlv_bu`      | `rd, rs1`           | `hypervisor` |
| `rv_h`        | `hlv_h`       | `rd, rs1`           | `hypervisor` |
| `rv_h`        | `hlv_hu`      | `rd, rs1`           | `hypervisor` |
| `rv_h`        | `hlv_w`       | `rd, rs1`           | `hypervisor` |
| `rv_h`        | `hlvx_hu`     | `rd, rs1`           | `hypervisor` |
| `rv_h`        | `hlvx_wu`     | `rd, rs1`           | `hypervisor` |
| `rv_h`        | `hsv_b`       | `rs1, rs2`          | `hypervisor` |
| `rv_h`        | `hsv_h`       | `rs1, rs2`          | `hypervisor` |
| `rv_h`        | `hsv_w`       | `rs1, rs2`          | `hypervisor` |

:RVH - Specific Extension for Hypervisor-level Instructions

| **Extension** | **Name** | **Variable-Fields** | **Class**    |
|:--------------|:---------|:--------------------|:-------------|
| `rv64_h`      | `hlv_d`  | `rd, rs1`           | `hypervisor` |
| `rv64_h`      | `hlv_wu` | `rd, rs1`           | `hypervisor` |
| `rv64_h`      | `hsv_d`  | `rs1, rs2`          | `hypervisor` |

:RV64H - Specific Extension for Hypervisor-level Instructions (64 bit)
