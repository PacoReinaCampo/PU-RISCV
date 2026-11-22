## TRAPS

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
