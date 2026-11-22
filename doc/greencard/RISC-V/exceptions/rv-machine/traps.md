## TRAPS

| **Number** | **Access** | **Name**     | **Description**                         |
|:-----------|:-----------|:-------------|:----------------------------------------|
| `0x300`    | `mrw`      | `mstatus`    | `Machine status register`               |
| `0x301`    | `mrw`      | `misa`       | `ISA and extensions supported`          |
| `0x302`    | `mrw`      | `medeleg`    | `Machine exception delegation register` |
| `0x303`    | `mrw`      | `mideleg`    | `Machine interrupt delegation register` |
| `0x304`    | `mrw`      | `mie`        | `Machine interrupt-enable register`     |
| `0x305`    | `mrw`      | `mtvec`      | `Machine trap-handler base address`     |
| `0x306`    | `mrw`      | `mcounteren` | `Machine counter enable`                |

:Machine Trap Setup

| **Number** | **Access** | **Name**    | **Description**                                   |
|:-----------|:-----------|:------------|:--------------------------------------------------|
| `0x340`    | `mrw`      | `mscratch`  | `Scratch register for machine trap handlers`      |
| `0x341`    | `mrw`      | `mepc`      | `Machine exception program counter`               |
| `0x342`    | `mrw`      | `mcause`    | `Machine trap cause`                              |
| `0x343`    | `mrw`      | `mbadaddr`  | `Machine bad address`                             |
| `0x343`    | `mrw`      | `mtval`     | `Machine bad address or instruction`              |
| `0x344`    | `mrw`      | `mip`       | `Machine interrupt pending`                       |
| `0x3A0`    | `mrw`      | `pmpcfg0`   | `Physical memory protection configuration`        |
| `0x3A1`    | `mrw`      | `pmpcfg1`   | `Physical memory protection configuration (RV32)` |
| `0x3A2`    | `mrw`      | `pmpcfg2`   | `Physical memory protection configuration`        |
| `0x3A3`    | `mrw`      | `pmpcfg3`   | `Physical memory protection configuration (RV32)` |
| `0x3B0`    | `mrw`      | `pmpaddr0`  | `Physical memory protection address register`     |
| `0x3B1`    | `mrw`      | `pmpaddr1`  | `Physical memory protection address register`     |
| `0x3B2`    | `mrw`      | `pmpaddr2`  | `Physical memory protection address register`     |
| `0x3B3`    | `mrw`      | `pmpaddr3`  | `Physical memory protection address register`     |
| `0x3B4`    | `mrw`      | `pmpaddr4`  | `Physical memory protection address register`     |
| `0x3B5`    | `mrw`      | `pmpaddr5`  | `Physical memory protection address register`     |
| `0x3B6`    | `mrw`      | `pmpaddr6`  | `Physical memory protection address register`     |
| `0x3B7`    | `mrw`      | `pmpaddr7`  | `Physical memory protection address register`     |
| `0x3B8`    | `mrw`      | `pmpaddr8`  | `Physical memory protection address register`     |
| `0x3B9`    | `mrw`      | `pmpaddr9`  | `Physical memory protection address register`     |
| `0x3BA`    | `mrw`      | `pmpaddr10` | `Physical memory protection address register`     |
| `0x3BB`    | `mrw`      | `pmpaddr11` | `Physical memory protection address register`     |
| `0x3BC`    | `mrw`      | `pmpaddr12` | `Physical memory protection address register`     |
| `0x3BE`    | `mrw`      | `pmpaddr13` | `Physical memory protection address register`     |
| `0x3BD`    | `mrw`      | `pmpaddr14` | `Physical memory protection address register`     |
| `0x3BF`    | `mrw`      | `pmpaddr15` | `Physical memory protection address register`     |

:Machine Trap Handling
