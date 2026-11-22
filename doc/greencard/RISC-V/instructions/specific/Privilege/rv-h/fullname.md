## INSTRUCTION FULL-NAMES

| **Extension** | **Name**      | **Variable-Fields** | **Full-Name**                                                               |
|:--------------|:--------------|:--------------------|:----------------------------------------------------------------------------|
| `rv_h`        | `hfence_gvma` | `rs1, rs2`          | `Hypervisor G-stage Memory Management Fence`                                |
| `rv_h`        | `hfence_vvma` | `rs1, rs2`          | `Hypervisor VS-stage Memory Management Fence`                               |
| `rv_h`        | `hlv_b`       | `rd, rs1`           | `Hypervisor Virtual-Machine Load Byte`                                      |
| `rv_h`        | `hlv_bu`      | `rd, rs1`           | `Hypervisor Virtual-Machine Load Byte Unsigned`                             |
| `rv_h`        | `hlv_h`       | `rd, rs1`           | `Hypervisor Virtual-Machine Load Halfword`                                  |
| `rv_h`        | `hlv_hu`      | `rd, rs1`           | `Hypervisor Virtual-Machine Load Halfword Unsigned`                         |
| `rv_h`        | `hlv_w`       | `rd, rs1`           | `Hypervisor Virtual-Machine Load Word`                                      |
| `rv_h`        | `hlvx_hu`     | `rd, rs1`           | `Hypervisor Virtual-Machine Load Halfword Unsigned with Execute Permission` |
| `rv_h`        | `hlvx_wu`     | `rd, rs1`           | `Hypervisor Virtual-Machine Load Word Unsigned with Execute Permission`     |
| `rv_h`        | `hsv_b`       | `rs1, rs2`          | `Hypervisor Virtual-Machine Store Byte`                                     |
| `rv_h`        | `hsv_h`       | `rs1, rs2`          | `Hypervisor Virtual-Machine Store Halfword`                                 |
| `rv_h`        | `hsv_w`       | `rs1, rs2`          | `Hypervisor Virtual-Machine Store Word`                                     |

:RVH - Specific Extension for Hypervisor-level Instructions

| **Extension** | **Name** | **Variable-Fields** | **Full-Name**                                   |
|:--------------|:---------|:--------------------|:------------------------------------------------|
| `rv64_h`      | `hlv_d`  | `rd, rs1`           | `Hypervisor Virtual-Machine Load Doubleword`    |
| `rv64_h`      | `hlv_wu` | `rd, rs1`           | `Hypervisor Virtual-Machine Load Word Unsigned` |
| `rv64_h`      | `hsv_d`  | `rs1, rs2`          | `Hypervisor Virtual-Machine Store Doubleword`   |

:RV64H - Specific Extension for Hypervisor-level Instructions (64 bit)
