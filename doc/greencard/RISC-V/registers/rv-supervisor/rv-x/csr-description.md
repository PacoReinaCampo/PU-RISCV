## CONTROL AND STATUS REGISTER DESCRIPTIONS

| **Number** | **Privilege** | **Name**     | **Description**                        |
|:-----------|:--------------|:-------------|:---------------------------------------|
| `0x100`    | `srw`         | `sstatus`    | `Supervisor status register`           |
| `0x104`    | `srw`         | `sie`        | `Supervisor interrupt-enable register` |
| `0x105`    | `srw`         | `stvec`      | `Supervisor trap handler base address` |
| `0x106`    | `srw`         | `scounteren` | `Supervisor counter enable`            |
| `0x114`    | `srw`         | `sieh`       | `Upper 32 bits of sie, RV32 only`      |

:Supervisor Trap Setup

| **Number** | **Privilege** | **Name**  | **Description**                                 |
|:-----------|:--------------|:----------|:------------------------------------------------|
| `0x10A`    | `srw`         | `senvcfg` | `Supervisor environment configuration register` |

:Supervisor Configuration

| **Number** | **Privilege** | **Name**        | **Description**                       |
|:-----------|:--------------|:----------------|:--------------------------------------|
| `0x120`    | `srw`         | `scountinhibit` | `Supervisor counter-inhibit register` |

:Supervisor Counter Setup

| **Number** | **Privilege** | **Name**    | **Description**                        |
|:-----------|:--------------|:------------|:---------------------------------------|
| `0x140`    | `srw`         | `sscratch`  | `Supervisor scratch register`          |
| `0x141`    | `srw`         | `sepc`      | `Supervisor exception program counter` |
| `0x142`    | `srw`         | `scause`    | `Supervisor trap cause`                |
| `0x143`    | `srw`         | `stval`     | `Supervisor trap value`                |
| `0x144`    | `srw`         | `sip`       | `Supervisor interrupt pending`         |
| `0x154`    | `srw`         | `siph`      | `Upper 32 bits of sip, RV32 only`      |
| `0x15C`    | `srw`         | `stopei`    | `Supervisor top external interrupt`    |
| `0xDA0`    | `sro`         | `scountovf` | `Supervisor count overflow`            |
| `0xDB0`    | `sro`         | `stopi`     | `Supervisor top interrupt`             |

:Supervisor Trap Handling

| **Number** | **Privilege** | **Name**   | **Description**                        |
|:-----------|:--------------|:-----------|:---------------------------------------|
| `0x150`    | `srw`         | `siselect` | `Supervisor indirect register select`  |
| `0x151`    | `srw`         | `sireg`    | `Supervisor indirect register alias`   |
| `0x152`    | `srw`         | `sireg2`   | `Supervisor indirect register alias 2` |
| `0x153`    | `srw`         | `sireg3`   | `Supervisor indirect register alias 3` |
| `0x155`    | `srw`         | `sireg4`   | `Supervisor indirect register alias 4` |
| `0x156`    | `srw`         | `sireg5`   | `Supervisor indirect register alias 5` |
| `0x157`    | `srw`         | `sireg6`   | `Supervisor indirect register alias 6` |

:Supervisor Indirect

| **Number** | **Privilege** | **Name** | **Description**                                 |
|:-----------|:--------------|:---------|:------------------------------------------------|
| `0x180`    | `srw`         | `satp`   | `Supervisor address translation and protection` |

:Supervisor Protection and Translation

| **Number** | **Privilege** | **Name**    | **Description**                        |
|:-----------|:--------------|:------------|:---------------------------------------|
| `0x14D`    | `srw`         | `stimecmp`  | `Supervisor timer compare`             |
| `0x15D`    | `srw`         | `stimecmph` | `Upper 32 bits of stimecmp, RV32 only` |

:Supervisor Timer Compare

| **Number** | **Privilege** | **Name**   | **Description**                    |
|:-----------|:--------------|:-----------|:-----------------------------------|
| `0x5A8`    | `srw`         | `scontext` | `Supervisor-mode context register` |

:Debug/Trace Registers

| **Number** | **Privilege** | **Name** | **Description**                                |
|:-----------|:--------------|:---------|:-----------------------------------------------|
| `0x181`    | `srw`         | `srmcfg` | `Supervisor Resource Management Configuration` |

:Supervisor Resource Management Configuration

| **Number** | **Privilege** | **Name**    | **Description**                      |
|:-----------|:--------------|:------------|:-------------------------------------|
| `0x10C`    | `srw`         | `sstateen0` | `Supervisor State Enable 0 Register` |
| `0x10D`    | `srw`         | `sstateen1` | `Supervisor State Enable 1 Register` |
| `0x10E`    | `srw`         | `sstateen2` | `Supervisor State Enable 2 Register` |
| `0x10F`    | `srw`         | `sstateen3` | `Supervisor State Enable 3 Register` |

:Supervisor State Enable Registers

| **Number** | **Privilege** | **Name**     | **Description**                                        |
|:-----------|:--------------|:-------------|:-------------------------------------------------------|
| `0x14E`    | `srw`         | `sctrctl`    | `Supervisor Control Transfer Records Control Register` |
| `0x14F`    | `srw`         | `sctrstatus` | `Supervisor Control Transfer Records Status Register`  |
| `0x15F`    | `srw`         | `sctrdepth`  | `Supervisor Control Transfer Records Depth Register`   |

:Supervisor Control Transfer Records Configuration