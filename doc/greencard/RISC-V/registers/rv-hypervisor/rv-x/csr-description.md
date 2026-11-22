## CONTROL AND STATUS REGISTER DESCRIPTIONS

| **Number** | **Privilege** | **Name**     | **Description**                                       |
|:-----------|:--------------|:-------------|:------------------------------------------------------|
| `0x600`    | `hrw`         | `hstatus`    | `Hypervisor status register`                          |
| `0x602`    | `hrw`         | `hedeleg`    | `Hypervisor exception delegation register`            |
| `0x603`    | `hrw`         | `hideleg`    | `Hypervisor interrupt delegation register`            |
| `0x604`    | `hrw`         | `hie`        | `Hypervisor interrupt-enable register`                |
| `0x606`    | `hrw`         | `hcounteren` | `Hypervisor counter enable`                           |
| `0x607`    | `hrw`         | `hgeie`      | `Hypervisor guest external interrupt-enable register` |
| `0x608`    | `hrw`         | `hvien`      | `Hypervisor virtual interrupt enables`                |
| `0x609`    | `hrw`         | `hvictl`     | `Hypervisor virtual interrupt control`                |
| `0x612`    | `hrw`         | `hedelegh`   | `Upper 32 bits of hedeleg, RV32 only`                 |
| `0x613`    | `hrw`         | `hidelegh`   | `Upper 32 bits of hideleg, RV32 only`                 |
| `0x618`    | `hrw`         | `hvienh`     | `Upper 32 bits of hvien, RV32 only`                   |
| `0x646`    | `hrw`         | `hviprio1`   | `Hypervisor VS-level interrupt priorities`            |
| `0x647`    | `hrw`         | `hviprio2`   | `Hypervisor VS-level interrupt priorities`            |
| `0x656`    | `hrw`         | `hviprio1h`  | `Upper 32 bits of hviprio1, RV32 only`                |
| `0x657`    | `hrw`         | `hviprio2h`  | `Upper 32 bits of hviprio2, RV32 only`                |

:Hypervisor Trap Setup

| **Number** | **Privilege** | **Name** | **Description**                               |
|:-----------|:--------------|:---------|:----------------------------------------------|
| `0x643`    | `hrw`         | `htval`  | `Hypervisor trap value`                       |
| `0x644`    | `hrw`         | `hip`    | `Hypervisor interrupt pending`                |
| `0x645`    | `hrw`         | `hvip`   | `Hypervisor virtual interrupt pending`        |
| `0x64A`    | `hrw`         | `htinst` | `Hypervisor trap instruction (transformed)`   |
| `0x655`    | `hrw`         | `hviph`  | `Upper 32 bits of hvip, RV32 only`            |
| `0xE12`    | `hro`         | `hgeip`  | `Hypervisor guest external interrupt pending` |

:Hypervisor Trap Handling

| **Number** | **Privilege** | **Name**   | **Description**                                 |
|:-----------|:--------------|:-----------|:------------------------------------------------|
| `0x60A`    | `hrw`         | `henvcfg`  | `Hypervisor environment configuration register` |
| `0x61A`    | `hrw`         | `henvcfgh` | `Upper 32 bits of henvcfg, RV32 only`           |

:Hypervisor Configuration

| **Number** | **Privilege** | **Name** | **Description**                                       |
|:-----------|:--------------|:---------|:------------------------------------------------------|
| `0x680`    | `hrw`         | `hgatp`  | `Hypervisor guest address translation and protection` |

:Hypervisor Protection and Translation

| **Number** | **Privilege** | **Name**   | **Description**                    |
|:-----------|:--------------|:-----------|:-----------------------------------|
| `0x6A8`    | `hrw`         | `hcontext` | `Hypervisor-mode context register` |

:Debug/Trace Registers

| **Number** | **Privilege** | **Name**      | **Description**                          |
|:-----------|:--------------|:--------------|:-----------------------------------------|
| `0x605`    | `hrw`         | `htimedelta`  | `Delta for VS/VU-mode timer`             |
| `0x615`    | `hrw`         | `htimedeltah` | `Upper 32 bits of htimedelta, RV32 only` |

:Hypervisor Counter/Timer Virtualization Registers

| **Number** | **Privilege** | **Name**     | **Description**                                                  |
|:-----------|:--------------|:-------------|:-----------------------------------------------------------------|
| `0x60C`    | `hrw`         | `hstateen0`  | `Hypervisor State Enable 0 Register`                             |
| `0x60D`    | `hrw`         | `hstateen1`  | `Hypervisor State Enable 1 Register`                             |
| `0x60E`    | `hrw`         | `hstateen2`  | `Hypervisor State Enable 2 Register`                             |
| `0x60F`    | `hrw`         | `hstateen3`  | `Hypervisor State Enable 3 Register`                             |
| `0x61C`    | `hrw`         | `hstateen0h` | `Upper 32 bits of Hypervisor State Enable 0 Register, RV32 only` |
| `0x61D`    | `hrw`         | `hstateen1h` | `Upper 32 bits of Hypervisor State Enable 1 Register, RV32 only` |
| `0x61E`    | `hrw`         | `hstateen2h` | `Upper 32 bits of Hypervisor State Enable 2 Register, RV32 only` |
| `0x61F`    | `hrw`         | `hstateen3h` | `Upper 32 bits of Hypervisor State Enable 3 Register, RV32 only` |

:Hypervisor State Enable Registers

| **Number** | **Privilege** | **Name**    | **Description**                                         |
|:-----------|:--------------|:------------|:--------------------------------------------------------|
| `0x200`    | `hrw`         | `vsstatus`  | `Virtual supervisor status register`                    |
| `0x204`    | `hrw`         | `vsie`      | `Virtual supervisor interrupt-enable register`          |
| `0x205`    | `hrw`         | `vstvec`    | `Virtual supervisor trap handler base address`          |
| `0x214`    | `hrw`         | `vsieh`     | `Upper 32 bits of vsie, RV32 only`                      |
| `0x240`    | `hrw`         | `vsscratch` | `Virtual supervisor scratch register`                   |
| `0x241`    | `hrw`         | `vsepc`     | `Virtual supervisor exception program counter`          |
| `0x242`    | `hrw`         | `vscause`   | `Virtual supervisor trap cause`                         |
| `0x243`    | `hrw`         | `vstval`    | `Virtual supervisor trap value`                         |
| `0x244`    | `hrw`         | `vsip`      | `Virtual supervisor interrupt pending`                  |
| `0x254`    | `hrw`         | `vsiph`     | `Upper 32 bits of vsip, RV32 only`                      |
| `0x25C`    | `hrw`         | `vstopei`   | `Virtual supervisor top external interrupt`             |
| `0x280`    | `hrw`         | `vsatp`     | `Virtual supervisor address translation and protection` |
| `0xEB0`    | `hro`         | `vstopi`    | `Virtual supervisor top interrupt`                      |

:Virtual Supervisor Registers

| **Number** | **Privilege** | **Name**    | **Description**                                |
|:-----------|:--------------|:------------|:-----------------------------------------------|
| `0x250`    | `hrw`         | `vsiselect` | `Virtual supervisor indirect register select`  |
| `0x251`    | `hrw`         | `vsireg`    | `Virtual supervisor indirect register alias`   |
| `0x252`    | `hrw`         | `vsireg2`   | `Virtual supervisor indirect register alias 2` |
| `0x253`    | `hrw`         | `vsireg3`   | `Virtual supervisor indirect register alias 3` |
| `0x255`    | `hrw`         | `vsireg4`   | `Virtual supervisor indirect register alias 4` |
| `0x256`    | `hrw`         | `vsireg5`   | `Virtual supervisor indirect register alias 5` |
| `0x257`    | `hrw`         | `vsireg6`   | `Virtual supervisor indirect register alias 6` |

:Virtual Supervisor Indirect

| **Number** | **Privilege** | **Name**     | **Description**                         |
|:-----------|:--------------|:-------------|:----------------------------------------|
| `0x24D`    | `hrw`         | `vstimecmp`  | `Virtual supervisor timer compare`      |
| `0x25D`    | `hrw`         | `vstimecmph` | `Upper 32 bits of vstimecmp, RV32 only` |

:Virtual Supervisor Timer Compare

| **Number** | **Privilege** | **Name**   | **Description**                                                |
|:-----------|:--------------|:-----------|:---------------------------------------------------------------|
| `0x24E`    | `hrw`         | `vsctrctl` | `Virtual Supervisor Control Transfer Records Control Register` |

:Virtual Supervisor Control Transfer Records Configuration