## RV-USER

### DESIGN OF EXCEPTIONS

| **File** | **Description**               |
|:---------|:------------------------------|
| `causes` | `Cause Code of Traps`         |
| `traps`  | `Setup and Handling of Traps` |

:Exception Directory

### CAUSES

| **Interrupt** | **Exception Code** | **Description**                           |
|:--------------|:-------------------|:------------------------------------------|
| `1`           | `0`                | `Reserved`                                |
| `1`           | `1`                | `Supervisor software interrupt`           |
| `1`           | `2`                | `Virtual supervisor software interrupt`   |
| `1`           | `3`                | `Machine software interrupt`              |
| `1`           | `4`                | `Reserved`                                |
| `1`           | `5`                | `Supervisor timer interrupt`              |
| `1`           | `6`                | `Virtual supervisor timer interrupt`      |
| `1`           | `7`                | `Machine timer interrupt`                 |
| `1`           | `8`                | `Reserved`                                |
| `1`           | `9`                | `Supervisor external interrupt`           |
| `1`           | `10`               | `Virtual supervisor external interrupt`   |
| `1`           | `11`               | `Machine external interrupt`              |
| `1`           | `12`               | `Supervisor guest external interrupt`     |
| `1`           | `13`               | `Counter-overflow interrupt`              |
| `1`           | `14-15`            | `Reserved`                                |
| `1`           | `≥16`              | `Designated for platform use`             |
| `0`           | `0`                | `Instruction address misaligned`          |
| `0`           | `1`                | `Instruction access fault`                |
| `0`           | `2`                | `Illegal instruction`                     |
| `0`           | `3`                | `Breakpoint`                              |
| `0`           | `4`                | `Load address misaligned`                 |
| `0`           | `5`                | `Load access fault`                       |
| `0`           | `6`                | `Store/AMO address misaligned`            |
| `0`           | `7`                | `Store/AMO access fault`                  |
| `0`           | `8`                | `Environment call from U-mode or VU-mode` |
| `0`           | `9`                | `Environment call from HS-mode`           |
| `0`           | `10`               | `Environment call from VS-mode`           |
| `0`           | `11`               | `Environment call from M-mode`            |
| `0`           | `12`               | `Instruction page fault`                  |
| `0`           | `13`               | `Load page fault`                         |
| `0`           | `14`               | `Reserved`                                |
| `0`           | `15`               | `Store/AMO page fault`                    |
| `0`           | `16`               | `Double trap`                             |
| `0`           | `17`               | `Reserved`                                |
| `0`           | `18`               | `Software check`                          |
| `0`           | `19`               | `Hardware error`                          |
| `0`           | `20`               | `Instruction guest-page fault`            |
| `0`           | `21`               | `Load guest-page fault`                   |
| `0`           | `22`               | `Virtual instruction`                     |
| `0`           | `23`               | `Store/AMO guest-page fault`              |
| `0`           | `24-31`            | `Designated for custom use`               |
| `0`           | `32-47`            | `Reserved`                                |
| `0`           | `48-63`            | `Designated for custom use`               |
| `0`           | `≥64`              | `Reserved`                                |

: Trap Cause Code

### TRAPS

| **Number** | **Access** | **Name**  | **Description**                  |
|:-----------|:-----------|:----------|:---------------------------------|
| `0x000`    | `urw`      | `ustatus` | `User status register`           |
| `0x004`    | `urw`      | `uie`     | `User interrupt-enable register` |
| `0x005`    | `urw`      | `utvec`   | `User trap handler base address` |

:User Trap Setup

| **Number** | **Access** | **Name**   | **Description**                          |
|:-----------|:-----------|:-----------|:-----------------------------------------|
| `0x040`    | `urw`      | `uscratch` | `Scratch handler for user trap handlers` |
| `0x041`    | `urw`      | `uepc`     | `User exception program counter`         |
| `0x042`    | `urw`      | `ucause`   | `User trap cause`                        |
| `0x043`    | `urw`      | `ubadaddr` | `User bad address`                       |
| `0x043`    | `urw`      | `utval`    | `User bad address or instruction`        |
| `0x044`    | `urw`      | `uip`      | `User interrupt pending`                 |

:User Trap Handling

## RV-SUPERVISOR

### DESIGN OF EXCEPTIONS

| **File** | **Description**               |
|:---------|:------------------------------|
| `causes` | `Cause Code of Traps`         |
| `traps`  | `Setup and Handling of Traps` |

:Exception Directory

### CAUSES

| **Interrupt** | **Exception Code** | **Description**                           |
|:--------------|:-------------------|:------------------------------------------|
| `1`           | `0`                | `Reserved`                                |
| `1`           | `1`                | `Supervisor software interrupt`           |
| `1`           | `2`                | `Virtual supervisor software interrupt`   |
| `1`           | `3`                | `Machine software interrupt`              |
| `1`           | `4`                | `Reserved`                                |
| `1`           | `5`                | `Supervisor timer interrupt`              |
| `1`           | `6`                | `Virtual supervisor timer interrupt`      |
| `1`           | `7`                | `Machine timer interrupt`                 |
| `1`           | `8`                | `Reserved`                                |
| `1`           | `9`                | `Supervisor external interrupt`           |
| `1`           | `10`               | `Virtual supervisor external interrupt`   |
| `1`           | `11`               | `Machine external interrupt`              |
| `1`           | `12`               | `Supervisor guest external interrupt`     |
| `1`           | `13`               | `Counter-overflow interrupt`              |
| `1`           | `14-15`            | `Reserved`                                |
| `1`           | `≥16`              | `Designated for platform use`             |
| `0`           | `0`                | `Instruction address misaligned`          |
| `0`           | `1`                | `Instruction access fault`                |
| `0`           | `2`                | `Illegal instruction`                     |
| `0`           | `3`                | `Breakpoint`                              |
| `0`           | `4`                | `Load address misaligned`                 |
| `0`           | `5`                | `Load access fault`                       |
| `0`           | `6`                | `Store/AMO address misaligned`            |
| `0`           | `7`                | `Store/AMO access fault`                  |
| `0`           | `8`                | `Environment call from U-mode or VU-mode` |
| `0`           | `9`                | `Environment call from HS-mode`           |
| `0`           | `10`               | `Environment call from VS-mode`           |
| `0`           | `11`               | `Environment call from M-mode`            |
| `0`           | `12`               | `Instruction page fault`                  |
| `0`           | `13`               | `Load page fault`                         |
| `0`           | `14`               | `Reserved`                                |
| `0`           | `15`               | `Store/AMO page fault`                    |
| `0`           | `16`               | `Double trap`                             |
| `0`           | `17`               | `Reserved`                                |
| `0`           | `18`               | `Software check`                          |
| `0`           | `19`               | `Hardware error`                          |
| `0`           | `20`               | `Instruction guest-page fault`            |
| `0`           | `21`               | `Load guest-page fault`                   |
| `0`           | `22`               | `Virtual instruction`                     |
| `0`           | `23`               | `Store/AMO guest-page fault`              |
| `0`           | `24-31`            | `Designated for custom use`               |
| `0`           | `32-47`            | `Reserved`                                |
| `0`           | `48-63`            | `Designated for custom use`               |
| `0`           | `≥64`              | `Reserved`                                |

: Trap Cause Code

### TRAPS

| **Number** | **Access** | **Name**     | **Description**                            |
|:-----------|:-----------|:-------------|:-------------------------------------------|
| `0x100`    | `srw`      | `sstatus`    | `Supervisor status register`               |
| `0x102`    | `srw`      | `sedeleg`    | `Supervisor exception delegation register` |
| `0x103`    | `srw`      | `sideleg`    | `Supervisor interrupt delegation register` |
| `0x104`    | `src`      | `sie`        | `Supervisor interrupt-enable register`     |
| `0x105`    | `srw`      | `stvec`      | `Supervisor trap handler base address`     |
| `0x106`    | `swr`      | `scounteren` | `Supervisor counter enable`                |

:Supervisor Trap Setup

| **Number** | **Access** | **Name**   | **Description**                                 |
|:-----------|:-----------|:-----------|:------------------------------------------------|
| `0x140`    | `srw`      | `sscratch` | `Scratch register for supervisor trap handlers` |
| `0x141`    | `srw`      | `sepc`     | `Supervisor exception program counter`          |
| `0x142`    | `srw`      | `scause`   | `Supervisor trap cause`                         |
| `0x143`    | `srw`      | `sbadaddr` | `Supervisor bad address`                        |
| `0x143`    | `srw`      | `stval`    | `Supervisor bad address or instruction`         |
| `0x144`    | `srw`      | `sip`      | `Supervisor interrupt pending`                  |

:Supervisor Trap Handling

## RV-HYPERVISOR

### DESIGN OF EXCEPTIONS

| **File** | **Description**               |
|:---------|:------------------------------|
| `causes` | `Cause Code of Traps`         |
| `traps`  | `Setup and Handling of Traps` |

:Exception Directory

### CAUSES

| **Interrupt** | **Exception Code** | **Description**                           |
|:--------------|:-------------------|:------------------------------------------|
| `1`           | `0`                | `Reserved`                                |
| `1`           | `1`                | `Supervisor software interrupt`           |
| `1`           | `2`                | `Virtual supervisor software interrupt`   |
| `1`           | `3`                | `Machine software interrupt`              |
| `1`           | `4`                | `Reserved`                                |
| `1`           | `5`                | `Supervisor timer interrupt`              |
| `1`           | `6`                | `Virtual supervisor timer interrupt`      |
| `1`           | `7`                | `Machine timer interrupt`                 |
| `1`           | `8`                | `Reserved`                                |
| `1`           | `9`                | `Supervisor external interrupt`           |
| `1`           | `10`               | `Virtual supervisor external interrupt`   |
| `1`           | `11`               | `Machine external interrupt`              |
| `1`           | `12`               | `Supervisor guest external interrupt`     |
| `1`           | `13`               | `Counter-overflow interrupt`              |
| `1`           | `14-15`            | `Reserved`                                |
| `1`           | `≥16`              | `Designated for platform use`             |
| `0`           | `0`                | `Instruction address misaligned`          |
| `0`           | `1`                | `Instruction access fault`                |
| `0`           | `2`                | `Illegal instruction`                     |
| `0`           | `3`                | `Breakpoint`                              |
| `0`           | `4`                | `Load address misaligned`                 |
| `0`           | `5`                | `Load access fault`                       |
| `0`           | `6`                | `Store/AMO address misaligned`            |
| `0`           | `7`                | `Store/AMO access fault`                  |
| `0`           | `8`                | `Environment call from U-mode or VU-mode` |
| `0`           | `9`                | `Environment call from HS-mode`           |
| `0`           | `10`               | `Environment call from VS-mode`           |
| `0`           | `11`               | `Environment call from M-mode`            |
| `0`           | `12`               | `Instruction page fault`                  |
| `0`           | `13`               | `Load page fault`                         |
| `0`           | `14`               | `Reserved`                                |
| `0`           | `15`               | `Store/AMO page fault`                    |
| `0`           | `16`               | `Double trap`                             |
| `0`           | `17`               | `Reserved`                                |
| `0`           | `18`               | `Software check`                          |
| `0`           | `19`               | `Hardware error`                          |
| `0`           | `20`               | `Instruction guest-page fault`            |
| `0`           | `21`               | `Load guest-page fault`                   |
| `0`           | `22`               | `Virtual instruction`                     |
| `0`           | `23`               | `Store/AMO guest-page fault`              |
| `0`           | `24-31`            | `Designated for custom use`               |
| `0`           | `32-47`            | `Reserved`                                |
| `0`           | `48-63`            | `Designated for custom use`               |
| `0`           | `≥64`              | `Reserved`                                |

: Trap Cause Code

### TRAPS

| **Number** | **Access** | **Name**  | **Description**                            |
|:-----------|:-----------|:----------|:-------------------------------------------|
| `0x200`    | `hrw`      | `hstatus` | `Hypervisor status register`               |
| `0x202`    | `mrw`      | `hedeleg` | `Hypervisor exception delegation register` |
| `0x203`    | `mrw`      | `hideleg` | `Hypervisor interrupt delegation register` |
| `0x204`    | `mrw`      | `hie`     | `Hypervisor interrupt-enable register`     |
| `0x205`    | `hrw`      | `htvec`   | `Hypervisor trap handler base address`     |

:Hypervisor Trap Setup

| **Number** | **Access** | **Name**   | **Description**                                 |
|:-----------|:-----------|:-----------|:------------------------------------------------|
| `0x240`    | `hrw`      | `hscratch` | `Scratch register for hypervisor trap handlers` |
| `0x241`    | `hrw`      | `hepc`     | `Hypervisor exception program counter`          |
| `0x242`    | `hrw`      | `hcause`   | `Hypervisor trap cause`                         |
| `0x243`    | `hrw`      | `hbadaddr` | `Hypervisor bad address`                        |
| `0x244`    | `hrw`      | `hip`      | `Hypervisor interrupt pending`                  |

:Hypervisor Trap Handling

## RV-MACHINE

### DESIGN OF EXCEPTIONS

| **File** | **Description**               |
|:---------|:------------------------------|
| `causes` | `Cause Code of Traps`         |
| `traps`  | `Setup and Handling of Traps` |

:Exception Directory

### CAUSES

| **Interrupt** | **Exception Code** | **Description**                           |
|:--------------|:-------------------|:------------------------------------------|
| `1`           | `0`                | `Reserved`                                |
| `1`           | `1`                | `Supervisor software interrupt`           |
| `1`           | `2`                | `Virtual supervisor software interrupt`   |
| `1`           | `3`                | `Machine software interrupt`              |
| `1`           | `4`                | `Reserved`                                |
| `1`           | `5`                | `Supervisor timer interrupt`              |
| `1`           | `6`                | `Virtual supervisor timer interrupt`      |
| `1`           | `7`                | `Machine timer interrupt`                 |
| `1`           | `8`                | `Reserved`                                |
| `1`           | `9`                | `Supervisor external interrupt`           |
| `1`           | `10`               | `Virtual supervisor external interrupt`   |
| `1`           | `11`               | `Machine external interrupt`              |
| `1`           | `12`               | `Supervisor guest external interrupt`     |
| `1`           | `13`               | `Counter-overflow interrupt`              |
| `1`           | `14-15`            | `Reserved`                                |
| `1`           | `≥16`              | `Designated for platform use`             |
| `0`           | `0`                | `Instruction address misaligned`          |
| `0`           | `1`                | `Instruction access fault`                |
| `0`           | `2`                | `Illegal instruction`                     |
| `0`           | `3`                | `Breakpoint`                              |
| `0`           | `4`                | `Load address misaligned`                 |
| `0`           | `5`                | `Load access fault`                       |
| `0`           | `6`                | `Store/AMO address misaligned`            |
| `0`           | `7`                | `Store/AMO access fault`                  |
| `0`           | `8`                | `Environment call from U-mode or VU-mode` |
| `0`           | `9`                | `Environment call from HS-mode`           |
| `0`           | `10`               | `Environment call from VS-mode`           |
| `0`           | `11`               | `Environment call from M-mode`            |
| `0`           | `12`               | `Instruction page fault`                  |
| `0`           | `13`               | `Load page fault`                         |
| `0`           | `14`               | `Reserved`                                |
| `0`           | `15`               | `Store/AMO page fault`                    |
| `0`           | `16`               | `Double trap`                             |
| `0`           | `17`               | `Reserved`                                |
| `0`           | `18`               | `Software check`                          |
| `0`           | `19`               | `Hardware error`                          |
| `0`           | `20`               | `Instruction guest-page fault`            |
| `0`           | `21`               | `Load guest-page fault`                   |
| `0`           | `22`               | `Virtual instruction`                     |
| `0`           | `23`               | `Store/AMO guest-page fault`              |
| `0`           | `24-31`            | `Designated for custom use`               |
| `0`           | `32-47`            | `Reserved`                                |
| `0`           | `48-63`            | `Designated for custom use`               |
| `0`           | `≥64`              | `Reserved`                                |

: Trap Cause Code

### TRAPS

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
