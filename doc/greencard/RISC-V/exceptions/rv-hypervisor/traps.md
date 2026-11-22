## TRAPS

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
