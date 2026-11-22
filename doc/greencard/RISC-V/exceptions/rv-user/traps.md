## TRAPS

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
