## INSTRUCTION PSEUDO-CODE (PL)

| **Extension** | **Name**      | **Variable-Fields** | **Pseudo-Code**                                                                                                                                                                   |
|:--------------|:--------------|:--------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `rv_h`        | `hfence_gvma` | `rs1, rs2`          | `check_hfence_access(privilege, V, mstatus.TVM); addr = rs1 == x0 ? ALL : x[rs1] << 2; id = rs2 == x0 ? ALL : low_bits(x[rs2], VMIDLEN); fence_g_stage(addr, id);`                |
| `rv_h`        | `hfence_vvma` | `rs1, rs2`          | `check_hfence_access(privilege, V, false); addr = rs1 == x0 ? ALL : x[rs1]; id = rs2 == x0 ? ALL : low_bits(x[rs2], ASIDLEN); fence_vs_stage(addr, id, hgatp.VMID);`              |
| `rv_h`        | `hlv_b`       | `rd, rs1`           | `check_guest_memory_access(privilege, V, hstatus.HU); guest_mode = hstatus.SPVP ? VS : VU; value = guest_load(x[rs1], 8, guest_mode); x[rd] = sign_extend(value, XLEN);`          |
| `rv_h`        | `hlv_bu`      | `rd, rs1`           | `check_guest_memory_access(privilege, V, hstatus.HU); guest_mode = hstatus.SPVP ? VS : VU; value = guest_load(x[rs1], 8, guest_mode); x[rd] = zero_extend(value, XLEN);`          |
| `rv_h`        | `hlv_h`       | `rd, rs1`           | `check_guest_memory_access(privilege, V, hstatus.HU); guest_mode = hstatus.SPVP ? VS : VU; value = guest_load(x[rs1], 16, guest_mode); x[rd] = sign_extend(value, XLEN);`         |
| `rv_h`        | `hlv_hu`      | `rd, rs1`           | `check_guest_memory_access(privilege, V, hstatus.HU); guest_mode = hstatus.SPVP ? VS : VU; value = guest_load(x[rs1], 16, guest_mode); x[rd] = zero_extend(value, XLEN);`         |
| `rv_h`        | `hlv_w`       | `rd, rs1`           | `check_guest_memory_access(privilege, V, hstatus.HU); guest_mode = hstatus.SPVP ? VS : VU; value = guest_load(x[rs1], 32, guest_mode); x[rd] = sign_extend(value, XLEN);`         |
| `rv_h`        | `hlvx_hu`     | `rd, rs1`           | `check_guest_memory_access(privilege, V, hstatus.HU); guest_mode = hstatus.SPVP ? VS : VU; value = guest_load_execute(x[rs1], 16, guest_mode); x[rd] = zero_extend(value, XLEN);` |
| `rv_h`        | `hlvx_wu`     | `rd, rs1`           | `check_guest_memory_access(privilege, V, hstatus.HU); guest_mode = hstatus.SPVP ? VS : VU; value = guest_load_execute(x[rs1], 32, guest_mode); x[rd] = zero_extend(value, XLEN);` |
| `rv_h`        | `hsv_b`       | `rs1, rs2`          | `check_guest_memory_access(privilege, V, hstatus.HU); guest_mode = hstatus.SPVP ? VS : VU; guest_store(x[rs1], 8, low_bits(x[rs2], 8), guest_mode);`                              |
| `rv_h`        | `hsv_h`       | `rs1, rs2`          | `check_guest_memory_access(privilege, V, hstatus.HU); guest_mode = hstatus.SPVP ? VS : VU; guest_store(x[rs1], 16, low_bits(x[rs2], 16), guest_mode);`                            |
| `rv_h`        | `hsv_w`       | `rs1, rs2`          | `check_guest_memory_access(privilege, V, hstatus.HU); guest_mode = hstatus.SPVP ? VS : VU; guest_store(x[rs1], 32, low_bits(x[rs2], 32), guest_mode);`                            |

:RVH - Specific Extension for Hypervisor-level Instructions

| **Extension** | **Name** | **Variable-Fields** | **Pseudo-Code**                                                                                                                                                           |
|:--------------|:---------|:--------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `rv64_h`      | `hlv_d`  | `rd, rs1`           | `check_guest_memory_access(privilege, V, hstatus.HU); guest_mode = hstatus.SPVP ? VS : VU; value = guest_load(x[rs1], 64, guest_mode); x[rd] = sign_extend(value, XLEN);` |
| `rv64_h`      | `hlv_wu` | `rd, rs1`           | `check_guest_memory_access(privilege, V, hstatus.HU); guest_mode = hstatus.SPVP ? VS : VU; value = guest_load(x[rs1], 32, guest_mode); x[rd] = zero_extend(value, XLEN);` |
| `rv64_h`      | `hsv_d`  | `rs1, rs2`          | `check_guest_memory_access(privilege, V, hstatus.HU); guest_mode = hstatus.SPVP ? VS : VU; guest_store(x[rs1], 64, low_bits(x[rs2], 64), guest_mode);`                    |

:RV64H - Specific Extension for Hypervisor-level Instructions (64 bit)
