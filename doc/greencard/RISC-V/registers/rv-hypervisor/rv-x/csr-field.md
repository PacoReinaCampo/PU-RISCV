## CONTROL AND STATUS REGISTER FIELDS

| **CSR**   | **Name** | **Bits** | **Privilege** | **Description**                                                |
|:----------|:---------|:---------|:--------------|:---------------------------------------------------------------|
| `hstatus` | `vsbe`   | `5`      | `hs`          | `VS-mode data endianness`                                      |
| `hstatus` | `gva`    | `6`      | `hs`          | `Trap value holds a guest virtual address`                     |
| `hstatus` | `spv`    | `7`      | `hs`          | `Previous virtualization mode`                                 |
| `hstatus` | `spvp`   | `8`      | `hs`          | `Previous virtual privilege`                                   |
| `hstatus` | `hu`     | `9`      | `hs`          | `Permit hypervisor virtual-machine loads and stores in U-mode` |
| `hstatus` | `vgein`  | `17:12`  | `hs`          | `Virtual guest external interrupt number`                      |
| `hstatus` | `vtvm`   | `20`     | `hs`          | `Trap VS-mode virtual-memory management operations`            |
| `hstatus` | `vtw`    | `21`     | `hs`          | `Trap VS-mode WFI after a timeout`                             |
| `hstatus` | `vtsr`   | `22`     | `hs`          | `Trap VS-mode SRET`                                            |
| `hstatus` | `vsxl`   | `33:32`  | `hs`          | `VS-mode XLEN encoding (RV64)`                                 |
| `hstatus` | `hupmm`  | `49:48`  | `hs`          | `U-mode pointer masking in HS-mode (RV64 with Ssnpm)`          |

:Hypervisor Status

| **CSR**   | **Name**     | **Bits** | **Privilege** | **Description**                                                    |
|:----------|:-------------|:---------|:--------------|:-------------------------------------------------------------------|
| `hedeleg` | `delegation` | `63:0`   | `hs`          | `One bit per synchronous exception cause. RV32 uses the low half.` |

:Hypervisor Exception Delegation

| **CSR**   | **Name**     | **Bits** | **Privilege** | **Description**                                        |
|:----------|:-------------|:---------|:--------------|:-------------------------------------------------------|
| `hideleg` | `delegation` | `63:0`   | `hs`          | `One bit per interrupt cause. RV32 uses the low half.` |

:Hypervisor Interrupt Delegation

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                                |
|:--------|:---------|:---------|:--------------|:-----------------------------------------------|
| `hie`   | `vssie`  | `2`      | `hs`          | `Virtual supervisor software interrupt enable` |
| `hie`   | `vstie`  | `6`      | `hs`          | `Virtual supervisor timer interrupt enable`    |
| `hie`   | `vseie`  | `10`     | `hs`          | `Virtual supervisor external interrupt enable` |
| `hie`   | `sgeie`  | `12`     | `hs`          | `Supervisor guest external interrupt enable`   |

:Hypervisor Interrupt Enable

| **CSR**      | **Name** | **Bits** | **Privilege** | **Description**                           |
|:-------------|:---------|:---------|:--------------|:------------------------------------------|
| `hcounteren` | `cy`     | `0`      | `hs`          | `Enable access to cycle`                  |
| `hcounteren` | `tm`     | `1`      | `hs`          | `Enable access to time`                   |
| `hcounteren` | `ir`     | `2`      | `hs`          | `Enable access to instret`                |
| `hcounteren` | `hpm3`   | `3`      | `hs`          | `Enable access to performance counter 3`  |
| `hcounteren` | `hpm4`   | `4`      | `hs`          | `Enable access to performance counter 4`  |
| `hcounteren` | `hpm5`   | `5`      | `hs`          | `Enable access to performance counter 5`  |
| `hcounteren` | `hpm6`   | `6`      | `hs`          | `Enable access to performance counter 6`  |
| `hcounteren` | `hpm7`   | `7`      | `hs`          | `Enable access to performance counter 7`  |
| `hcounteren` | `hpm8`   | `8`      | `hs`          | `Enable access to performance counter 8`  |
| `hcounteren` | `hpm9`   | `9`      | `hs`          | `Enable access to performance counter 9`  |
| `hcounteren` | `hpm10`  | `10`     | `hs`          | `Enable access to performance counter 10` |
| `hcounteren` | `hpm11`  | `11`     | `hs`          | `Enable access to performance counter 11` |
| `hcounteren` | `hpm12`  | `12`     | `hs`          | `Enable access to performance counter 12` |
| `hcounteren` | `hpm13`  | `13`     | `hs`          | `Enable access to performance counter 13` |
| `hcounteren` | `hpm14`  | `14`     | `hs`          | `Enable access to performance counter 14` |
| `hcounteren` | `hpm15`  | `15`     | `hs`          | `Enable access to performance counter 15` |
| `hcounteren` | `hpm16`  | `16`     | `hs`          | `Enable access to performance counter 16` |
| `hcounteren` | `hpm17`  | `17`     | `hs`          | `Enable access to performance counter 17` |
| `hcounteren` | `hpm18`  | `18`     | `hs`          | `Enable access to performance counter 18` |
| `hcounteren` | `hpm19`  | `19`     | `hs`          | `Enable access to performance counter 19` |
| `hcounteren` | `hpm20`  | `20`     | `hs`          | `Enable access to performance counter 20` |
| `hcounteren` | `hpm21`  | `21`     | `hs`          | `Enable access to performance counter 21` |
| `hcounteren` | `hpm22`  | `22`     | `hs`          | `Enable access to performance counter 22` |
| `hcounteren` | `hpm23`  | `23`     | `hs`          | `Enable access to performance counter 23` |
| `hcounteren` | `hpm24`  | `24`     | `hs`          | `Enable access to performance counter 24` |
| `hcounteren` | `hpm25`  | `25`     | `hs`          | `Enable access to performance counter 25` |
| `hcounteren` | `hpm26`  | `26`     | `hs`          | `Enable access to performance counter 26` |
| `hcounteren` | `hpm27`  | `27`     | `hs`          | `Enable access to performance counter 27` |
| `hcounteren` | `hpm28`  | `28`     | `hs`          | `Enable access to performance counter 28` |
| `hcounteren` | `hpm29`  | `29`     | `hs`          | `Enable access to performance counter 29` |
| `hcounteren` | `hpm30`  | `30`     | `hs`          | `Enable access to performance counter 30` |
| `hcounteren` | `hpm31`  | `31`     | `hs`          | `Enable access to performance counter 31` |

:Hypervisor Counter Enable

| **CSR** | **Name** | **Bits**     | **Privilege** | **Description**                                          |
|:--------|:---------|:-------------|:--------------|:---------------------------------------------------------|
| `hgeie` | `enable` | `HSXLEN-1:1` | `hs`          | `Enable bits indexed by guest external interrupt number` |

:Hypervisor Guest External Interrupt Enable

| **CSR** | **Name**     | **Bits** | **Privilege** | **Description**                                                                    |
|:--------|:-------------|:---------|:--------------|:-----------------------------------------------------------------------------------|
| `hvien` | `interrupts` | `63:0`   | `hs`          | `Virtual supervisor interrupt virtualization enable bits. RV32 uses the low half.` |

:Hypervisor Virtual Interrupt Enables

| **CSR**  | **Name** | **Bits** | **Privilege** | **Description**                             |
|:---------|:---------|:---------|:--------------|:--------------------------------------------|
| `hvictl` | `iprio`  | `7:0`    | `hs`          | `Injected interrupt priority`               |
| `hvictl` | `ipriom` | `8`      | `hs`          | `Virtual interrupt priority reporting mode` |
| `hvictl` | `dpr`    | `9`      | `hs`          | `Default priority order`                    |
| `hvictl` | `iid`    | `27:16`  | `hs`          | `Injected interrupt identity`               |
| `hvictl` | `vti`    | `30`     | `hs`          | `Virtual trap interrupt control`            |

:Hypervisor Virtual Interrupt Control

| **CSR**    | **Name**     | **Bits** | **Privilege** | **Description**                                   |
|:-----------|:-------------|:---------|:--------------|:--------------------------------------------------|
| `hedelegh` | `delegation` | `31:0`   | `hs`          | `Delegation bits for cause numbers 32 through 63` |

:Hypervisor Exception Delegation (Upper 32 Bits)

| **CSR**    | **Name**     | **Bits** | **Privilege** | **Description**                                   |
|:-----------|:-------------|:---------|:--------------|:--------------------------------------------------|
| `hidelegh` | `delegation` | `31:0`   | `hs`          | `Delegation bits for cause numbers 32 through 63` |

:Hypervisor Interrupt Delegation (Upper 32 Bits)

| **CSR**  | **Name**     | **Bits** | **Privilege** | **Description**                                                   |
|:---------|:-------------|:---------|:--------------|:------------------------------------------------------------------|
| `hvienh` | `interrupts` | `31:0`   | `hs`          | `Bits corresponding to interrupt identities 32 through 63 (RV32)` |

:Hypervisor Virtual Interrupt Enables (Upper 32 Bits)

| **CSR**    | **Name**  | **Bits** | **Privilege** | **Description**                            |
|:-----------|:----------|:---------|:--------------|:-------------------------------------------|
| `hviprio1` | `iprio0`  | `7:0`    | `hs`          | `Reserved priority for interrupt 0`        |
| `hviprio1` | `iprio1`  | `15:8`   | `hs`          | `Priority for interrupt 1`                 |
| `hviprio1` | `iprio4`  | `23:16`  | `hs`          | `Reserved priority for interrupt 4`        |
| `hviprio1` | `iprio5`  | `31:24`  | `hs`          | `Priority for interrupt 5`                 |
| `hviprio1` | `iprio8`  | `39:32`  | `hs`          | `Reserved priority for interrupt 8 (RV64)` |
| `hviprio1` | `iprio13` | `47:40`  | `hs`          | `Priority for interrupt 13 (RV64)`         |
| `hviprio1` | `iprio14` | `55:48`  | `hs`          | `Priority for interrupt 14 (RV64)`         |
| `hviprio1` | `iprio15` | `63:56`  | `hs`          | `Priority for interrupt 15 (RV64)`         |
| `hviprio2` | `iprio16` | `7:0`    | `hs`          | `Priority for interrupt 16`                |
| `hviprio2` | `iprio17` | `15:8`   | `hs`          | `Priority for interrupt 17`                |
| `hviprio2` | `iprio18` | `23:16`  | `hs`          | `Priority for interrupt 18`                |
| `hviprio2` | `iprio19` | `31:24`  | `hs`          | `Priority for interrupt 19`                |
| `hviprio2` | `iprio20` | `39:32`  | `hs`          | `Priority for interrupt 20 (RV64)`         |
| `hviprio2` | `iprio21` | `47:40`  | `hs`          | `Priority for interrupt 21 (RV64)`         |
| `hviprio2` | `iprio22` | `55:48`  | `hs`          | `Priority for interrupt 22 (RV64)`         |
| `hviprio2` | `iprio23` | `63:56`  | `hs`          | `Priority for interrupt 23 (RV64)`         |

:Hypervisor Virtual Supervisor Interrupt Priorities

| **CSR**     | **Name**  | **Bits** | **Privilege** | **Description**                            |
|:------------|:----------|:---------|:--------------|:-------------------------------------------|
| `hviprio1h` | `iprio8`  | `7:0`    | `hs`          | `Reserved priority for interrupt 8 (RV32)` |
| `hviprio1h` | `iprio13` | `15:8`   | `hs`          | `Priority for interrupt 13 (RV32)`         |
| `hviprio1h` | `iprio14` | `23:16`  | `hs`          | `Priority for interrupt 14 (RV32)`         |
| `hviprio1h` | `iprio15` | `31:24`  | `hs`          | `Priority for interrupt 15 (RV32)`         |
| `hviprio2h` | `iprio20` | `7:0`    | `hs`          | `Priority for interrupt 20 (RV32)`         |
| `hviprio2h` | `iprio21` | `15:8`   | `hs`          | `Priority for interrupt 21 (RV32)`         |
| `hviprio2h` | `iprio22` | `23:16`  | `hs`          | `Priority for interrupt 22 (RV32)`         |
| `hviprio2h` | `iprio23` | `31:24`  | `hs`          | `Priority for interrupt 23 (RV32)`         |

:Hypervisor Virtual Supervisor Interrupt Priorities (Upper 32 Bits)

| **CSR** | **Name** | **Bits**     | **Privilege** | **Description**               |
|:--------|:---------|:-------------|:--------------|:------------------------------|
| `htval` | `htval`  | `HSXLEN-1:0` | `hs`          | `Additional trap information` |

:Hypervisor Trap Value

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                                 |
|:--------|:---------|:---------|:--------------|:------------------------------------------------|
| `hip`   | `vssip`  | `2`      | `hs`          | `Virtual supervisor software interrupt pending` |
| `hip`   | `vstip`  | `6`      | `hs`          | `Virtual supervisor timer interrupt pending`    |
| `hip`   | `vseip`  | `10`     | `hs`          | `Virtual supervisor external interrupt pending` |
| `hip`   | `sgeip`  | `12`     | `hs`          | `Supervisor guest external interrupt pending`   |

:Hypervisor Interrupt Pending

| **CSR** | **Name**     | **Bits** | **Privilege** | **Description**                                      |
|:--------|:-------------|:---------|:--------------|:-----------------------------------------------------|
| `hvip`  | `vssip`      | `2`      | `hs`          | `Virtual supervisor software interrupt pending`      |
| `hvip`  | `vstip`      | `6`      | `hs`          | `Virtual supervisor timer interrupt pending`         |
| `hvip`  | `vseip`      | `10`     | `hs`          | `Virtual supervisor external interrupt pending`      |
| `hvip`  | `interrupts` | `63:13`  | `hs`          | `Additional virtual interrupt pending bits with AIA` |

:Hypervisor Virtual Interrupt Pending

| **CSR**  | **Name** | **Bits**     | **Privilege** | **Description**               |
|:---------|:---------|:-------------|:--------------|:------------------------------|
| `htinst` | `htinst` | `HSXLEN-1:0` | `hs`          | `Additional trap information` |

:Hypervisor Trap Instruction

| **CSR** | **Name**     | **Bits** | **Privilege** | **Description**                                                   |
|:--------|:-------------|:---------|:--------------|:------------------------------------------------------------------|
| `hviph` | `interrupts` | `31:0`   | `hs`          | `Bits corresponding to interrupt identities 32 through 63 (RV32)` |

:Hypervisor Virtual Interrupt Pending (Upper 32 Bits)

| **CSR** | **Name**  | **Bits**     | **Privilege** | **Description**                                           |
|:--------|:----------|:-------------|:--------------|:----------------------------------------------------------|
| `hgeip` | `pending` | `HSXLEN-1:1` | `hs`          | `Pending bits indexed by guest external interrupt number` |

:Hypervisor Guest External Interrupt Pending

| **CSR**   | **Name** | **Bits** | **Privilege** | **Description**                                |
|:----------|:---------|:---------|:--------------|:-----------------------------------------------|
| `henvcfg` | `fiom`   | `0`      | `hs`          | `Fence I/O implies memory`                     |
| `henvcfg` | `lpe`    | `2`      | `hs`          | `Landing pad enforcement enable`               |
| `henvcfg` | `sse`    | `3`      | `hs`          | `Shadow stack enable`                          |
| `henvcfg` | `cbie`   | `5:4`    | `hs`          | `Cache-block invalidate configuration`         |
| `henvcfg` | `cbcfe`  | `6`      | `hs`          | `Cache-block clean and flush enable`           |
| `henvcfg` | `cbze`   | `7`      | `hs`          | `Cache-block zero enable`                      |
| `henvcfg` | `pmm`    | `33:32`  | `hs`          | `Pointer masking mode (RV64)`                  |
| `henvcfg` | `dte`    | `59`     | `hs`          | `Double-trap enable (RV64)`                    |
| `henvcfg` | `adue`   | `61`     | `hs`          | `Hardware page-table A/D update enable (RV64)` |
| `henvcfg` | `pbmte`  | `62`     | `hs`          | `Page-based memory types enable (RV64)`        |
| `henvcfg` | `stce`   | `63`     | `hs`          | `Supervisor timer compare enable (RV64)`       |

:Hypervisor Environment Configuration

| **CSR**    | **Name** | **Bits** | **Privilege** | **Description**                         |
|:-----------|:---------|:---------|:--------------|:----------------------------------------|
| `henvcfgh` | `pmm`    | `1:0`    | `hs`          | `Pointer masking mode`                  |
| `henvcfgh` | `dte`    | `27`     | `hs`          | `Double-trap enable`                    |
| `henvcfgh` | `adue`   | `29`     | `hs`          | `Hardware page-table A/D update enable` |
| `henvcfgh` | `pbmte`  | `30`     | `hs`          | `Page-based memory types enable`        |
| `henvcfgh` | `stce`   | `31`     | `hs`          | `Supervisor timer compare enable`       |

:Hypervisor Environment Configuration (Upper 32 Bits)

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                                       |
|:--------|:---------|:---------|:--------------|:------------------------------------------------------|
| `hgatp` | `ppn`    | `21:0`   | `hs`          | `G-stage root page table physical page number (RV32)` |
| `hgatp` | `vmid`   | `28:22`  | `hs`          | `Virtual machine identifier (RV32)`                   |
| `hgatp` | `mode`   | `31`     | `hs`          | `G-stage translation mode (RV32)`                     |
| `hgatp` | `ppn`    | `43:0`   | `hs`          | `G-stage root page table physical page number (RV64)` |
| `hgatp` | `vmid`   | `57:44`  | `hs`          | `Virtual machine identifier (RV64)`                   |
| `hgatp` | `mode`   | `63:60`  | `hs`          | `G-stage translation mode (RV64)`                     |

:Hypervisor Guest Address Translation and Protection

| **CSR**    | **Name**   | **Bits** | **Privilege** | **Description**                                                               |
|:-----------|:-----------|:---------|:--------------|:------------------------------------------------------------------------------|
| `hcontext` | `hcontext` | `13:0`   | `hs`          | `Context value for trigger matching. Implementations may support fewer bits.` |

:Hypervisor-Mode Context

| **CSR**      | **Name** | **Bits** | **Privilege** | **Description**                                             |
|:-------------|:---------|:---------|:--------------|:------------------------------------------------------------|
| `htimedelta` | `value`  | `63:0`   | `hs`          | `Offset added to time for a guest. RV32 uses the low half.` |

:Delta for VS/VU-Mode Timer

| **CSR**       | **Name** | **Bits** | **Privilege** | **Description**                                       |
|:--------------|:---------|:---------|:--------------|:------------------------------------------------------|
| `htimedeltah` | `value`  | `31:0`   | `hs`          | `Offset added to time for a guest, bits 63:32 (RV32)` |

:Delta for VS/VU-Mode Timer (Upper 32 Bits)

| **CSR**     | **Name**   | **Bits** | **Privilege** | **Description**                                                                 |
|:------------|:-----------|:---------|:--------------|:--------------------------------------------------------------------------------|
| `hstateen0` | `c`        | `0`      | `hs`          | `Custom state access enable`                                                    |
| `hstateen0` | `fcsr`     | `1`      | `hs`          | `Floating-point CSR access enable for Zfinx`                                    |
| `hstateen0` | `jvt`      | `2`      | `hs`          | `Jump vector table access enable`                                               |
| `hstateen0` | `ctr`      | `54`     | `hs`          | `Control transfer records access enable (RV64)`                                 |
| `hstateen0` | `context`  | `57`     | `hs`          | `Context register access enable (RV64)`                                         |
| `hstateen0` | `imsic`    | `58`     | `hs`          | `IMSIC access enable (RV64)`                                                    |
| `hstateen0` | `aia`      | `59`     | `hs`          | `AIA state access enable (RV64)`                                                |
| `hstateen0` | `csrind`   | `60`     | `hs`          | `Indirect CSR access enable (RV64)`                                             |
| `hstateen0` | `envcfg`   | `62`     | `hs`          | `Environment configuration access enable (RV64)`                                |
| `hstateen0` | `se0`      | `63`     | `hs`          | `State-enable register 0 access enable (RV64)`                                  |
| `hstateen1` | `reserved` | `62:0`   | `hs`          | `Reserved state-enable bits`                                                    |
| `hstateen1` | `se1`      | `63`     | `hs`          | `Access enable for corresponding lower-privilege state-enable registers (RV64)` |
| `hstateen2` | `reserved` | `62:0`   | `hs`          | `Reserved state-enable bits`                                                    |
| `hstateen2` | `se2`      | `63`     | `hs`          | `Access enable for corresponding lower-privilege state-enable registers (RV64)` |
| `hstateen3` | `reserved` | `62:0`   | `hs`          | `Reserved state-enable bits`                                                    |
| `hstateen3` | `se3`      | `63`     | `hs`          | `Access enable for corresponding lower-privilege state-enable registers (RV64)` |

:Hypervisor State Enable Registers

| **CSR**      | **Name**   | **Bits** | **Privilege** | **Description**                                                                 |
|:-------------|:-----------|:---------|:--------------|:--------------------------------------------------------------------------------|
| `hstateen0h` | `ctr`      | `22`     | `hs`          | `Control transfer records access enable`                                        |
| `hstateen0h` | `context`  | `25`     | `hs`          | `Context register access enable`                                                |
| `hstateen0h` | `imsic`    | `26`     | `hs`          | `IMSIC access enable`                                                           |
| `hstateen0h` | `aia`      | `27`     | `hs`          | `AIA state access enable`                                                       |
| `hstateen0h` | `csrind`   | `28`     | `hs`          | `Indirect CSR access enable`                                                    |
| `hstateen0h` | `envcfg`   | `30`     | `hs`          | `Environment configuration access enable`                                       |
| `hstateen0h` | `se0`      | `31`     | `hs`          | `State-enable register 0 access enable`                                         |
| `hstateen1h` | `reserved` | `30:0`   | `hs`          | `Reserved upper state-enable bits (RV32)`                                       |
| `hstateen1h` | `se1`      | `31`     | `hs`          | `Access enable for corresponding lower-privilege state-enable registers (RV32)` |
| `hstateen2h` | `reserved` | `30:0`   | `hs`          | `Reserved upper state-enable bits (RV32)`                                       |
| `hstateen2h` | `se2`      | `31`     | `hs`          | `Access enable for corresponding lower-privilege state-enable registers (RV32)` |
| `hstateen3h` | `reserved` | `30:0`   | `hs`          | `Reserved upper state-enable bits (RV32)`                                       |
| `hstateen3h` | `se3`      | `31`     | `hs`          | `Access enable for corresponding lower-privilege state-enable registers (RV32)` |

:Hypervisor State Enable Registers (Upper 32 Bits)

| **CSR**    | **Name** | **Bits** | **Privilege** | **Description**                                 |
|:-----------|:---------|:---------|:--------------|:------------------------------------------------|
| `vsstatus` | `sie`    | `1`      | `hs`          | `Supervisor interrupt enable`                   |
| `vsstatus` | `spie`   | `5`      | `hs`          | `Previous supervisor interrupt enable`          |
| `vsstatus` | `ube`    | `6`      | `hs`          | `User-mode data endianness`                     |
| `vsstatus` | `spp`    | `8`      | `hs`          | `Previous supervisor privilege`                 |
| `vsstatus` | `vs`     | `10:9`   | `hs`          | `Vector extension state`                        |
| `vsstatus` | `fs`     | `14:13`  | `hs`          | `Floating-point extension state`                |
| `vsstatus` | `xs`     | `16:15`  | `hs`          | `Summary of other extension state`              |
| `vsstatus` | `sum`    | `18`     | `hs`          | `Permit supervisor data access to user pages`   |
| `vsstatus` | `mxr`    | `19`     | `hs`          | `Make executable pages readable`                |
| `vsstatus` | `spelp`  | `23`     | `hs`          | `Previous expected landing pad state (Zicfilp)` |
| `vsstatus` | `sdt`    | `24`     | `hs`          | `Supervisor double-trap control (Ssdbltrp)`     |
| `vsstatus` | `uxl`    | `33:32`  | `hs`          | `User XLEN encoding (64-bit CSR)`               |
| `vsstatus` | `sd`     | `31`     | `hs`          | `Summary dirty bit (32-bit CSR)`                |
| `vsstatus` | `sd`     | `63`     | `hs`          | `Summary dirty bit (64-bit CSR)`                |

:Virtual Supervisor Status

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                                          |
|:--------|:---------|:---------|:--------------|:---------------------------------------------------------|
| `vsie`  | `ssie`   | `1`      | `hs`          | `Supervisor software interrupt enable`                   |
| `vsie`  | `stie`   | `5`      | `hs`          | `Supervisor timer interrupt enable`                      |
| `vsie`  | `seie`   | `9`      | `hs`          | `Supervisor external interrupt enable`                   |
| `vsie`  | `lcofie` | `13`     | `hs`          | `Local counter-overflow (Shlcofideleg) interrupt enable` |

:Virtual Supervisor Interrupt Enable

| **CSR**  | **Name** | **Bits**     | **Privilege** | **Description**                 |
|:---------|:---------|:-------------|:--------------|:--------------------------------|
| `vstvec` | `mode`   | `1:0`        | `hs`          | `Trap vector mode`              |
| `vstvec` | `base`   | `VSXLEN-1:2` | `hs`          | `Trap vector base address bits` |

:Virtual Supervisor Trap Handler Base Address

| **CSR** | **Name**     | **Bits** | **Privilege** | **Description**                                                   |
|:--------|:-------------|:---------|:--------------|:------------------------------------------------------------------|
| `vsieh` | `interrupts` | `31:0`   | `hs`          | `Bits corresponding to interrupt identities 32 through 63 (RV32)` |

:Virtual Supervisor Interrupt Enable (Upper 32 Bits)

| **CSR**     | **Name**    | **Bits**     | **Privilege** | **Description**          |
|:------------|:------------|:-------------|:--------------|:-------------------------|
| `vsscratch` | `vsscratch` | `VSXLEN-1:0` | `hs`          | `Software scratch value` |

:Virtual Supervisor Scratch

| **CSR** | **Name** | **Bits**     | **Privilege** | **Description**             |
|:--------|:---------|:-------------|:--------------|:----------------------------|
| `vsepc` | `vsepc`  | `VSXLEN-1:0` | `hs`          | `Exception program counter` |

:Virtual Supervisor Exception Program Counter

| **CSR**   | **Name**         | **Bits**     | **Privilege** | **Description**       |
|:----------|:-----------------|:-------------|:--------------|:----------------------|
| `vscause` | `exception_code` | `VSXLEN-2:0` | `hs`          | `Trap cause code`     |
| `vscause` | `interrupt`      | `VSXLEN-1`   | `hs`          | `Interrupt indicator` |

:Virtual Supervisor Trap Cause

| **CSR**  | **Name** | **Bits**     | **Privilege** | **Description**                 |
|:---------|:---------|:-------------|:--------------|:--------------------------------|
| `vstval` | `vstval` | `VSXLEN-1:0` | `hs`          | `Exception-specific trap value` |

:Virtual Supervisor Trap Value

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                                           |
|:--------|:---------|:---------|:--------------|:----------------------------------------------------------|
| `vsip`  | `ssip`   | `1`      | `hs`          | `Supervisor software interrupt pending`                   |
| `vsip`  | `stip`   | `5`      | `hs`          | `Supervisor timer interrupt pending`                      |
| `vsip`  | `seip`   | `9`      | `hs`          | `Supervisor external interrupt pending`                   |
| `vsip`  | `lcofip` | `13`     | `hs`          | `Local counter-overflow (Shlcofideleg) interrupt pending` |

:Virtual Supervisor Interrupt Pending

| **CSR** | **Name**     | **Bits** | **Privilege** | **Description**                                                   |
|:--------|:-------------|:---------|:--------------|:------------------------------------------------------------------|
| `vsiph` | `interrupts` | `31:0`   | `hs`          | `Bits corresponding to interrupt identities 32 through 63 (RV32)` |

:Virtual Supervisor Interrupt Pending (Upper 32 Bits)

| **CSR**   | **Name**   | **Bits** | **Privilege** | **Description**                                                 |
|:----------|:-----------|:---------|:--------------|:----------------------------------------------------------------|
| `vstopei` | `priority` | `10:0`   | `hs`          | `Priority of the top external interrupt, equal to its identity` |
| `vstopei` | `identity` | `26:16`  | `hs`          | `Identity of the top external interrupt`                        |

:Virtual Supervisor Top External Interrupt

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                                     |
|:--------|:---------|:---------|:--------------|:----------------------------------------------------|
| `vsatp` | `ppn`    | `21:0`   | `hs`          | `Root page table physical page number (32-bit CSR)` |
| `vsatp` | `asid`   | `30:22`  | `hs`          | `Address space identifier (32-bit CSR)`             |
| `vsatp` | `mode`   | `31`     | `hs`          | `Address translation mode (32-bit CSR)`             |
| `vsatp` | `ppn`    | `43:0`   | `hs`          | `Root page table physical page number (64-bit CSR)` |
| `vsatp` | `asid`   | `59:44`  | `hs`          | `Address space identifier (64-bit CSR)`             |
| `vsatp` | `mode`   | `63:60`  | `hs`          | `Address translation mode (64-bit CSR)`             |

:Virtual Supervisor Address Translation and Protection

| **CSR**  | **Name** | **Bits** | **Privilege** | **Description**                                     |
|:---------|:---------|:---------|:--------------|:----------------------------------------------------|
| `vstopi` | `iprio`  | `7:0`    | `hs`          | `Priority of the top pending-and-enabled interrupt` |
| `vstopi` | `iid`    | `27:16`  | `hs`          | `Identity of the top pending-and-enabled interrupt` |

:Virtual Supervisor Top Interrupt

| **CSR**     | **Name** | **Bits**     | **Privilege** | **Description**              |
|:------------|:---------|:-------------|:--------------|:-----------------------------|
| `vsiselect` | `select` | `VSXLEN-1:0` | `hs`          | `Indirect register selector` |

:Virtual Supervisor Indirect Register Select

| **CSR**   | **Name** | **Bits**     | **Privilege** | **Description**                                                   |
|:----------|:---------|:-------------|:--------------|:------------------------------------------------------------------|
| `vsireg`  | `data`   | `VSXLEN-1:0` | `hs`          | `Field layout depends on the selector and the defining extension` |
| `vsireg2` | `data`   | `VSXLEN-1:0` | `hs`          | `Field layout depends on the selector and the defining extension` |
| `vsireg3` | `data`   | `VSXLEN-1:0` | `hs`          | `Field layout depends on the selector and the defining extension` |
| `vsireg4` | `data`   | `VSXLEN-1:0` | `hs`          | `Field layout depends on the selector and the defining extension` |
| `vsireg5` | `data`   | `VSXLEN-1:0` | `hs`          | `Field layout depends on the selector and the defining extension` |
| `vsireg6` | `data`   | `VSXLEN-1:0` | `hs`          | `Field layout depends on the selector and the defining extension` |

:Virtual Supervisor Indirect Register Aliases

| **CSR**     | **Name** | **Bits** | **Privilege** | **Description**                                                   |
|:------------|:---------|:---------|:--------------|:------------------------------------------------------------------|
| `vstimecmp` | `value`  | `63:0`   | `hs`          | `Virtual supervisor timer compare value. RV32 uses the low half.` |

:Virtual Supervisor Timer Compare

| **CSR**      | **Name** | **Bits** | **Privilege** | **Description**                                             |
|:-------------|:---------|:---------|:--------------|:------------------------------------------------------------|
| `vstimecmph` | `value`  | `31:0`   | `hs`          | `Virtual supervisor timer compare value, bits 63:32 (RV32)` |

:Virtual Supervisor Timer Compare (Upper 32 Bits)

| **CSR**    | **Name**     | **Bits** | **Privilege** | **Description**                                          |
|:-----------|:-------------|:---------|:--------------|:---------------------------------------------------------|
| `vsctrctl` | `u`          | `0`      | `hs`          | `Enable recording in VU-mode`                            |
| `vsctrctl` | `s`          | `1`      | `hs`          | `Enable recording in VS-mode`                            |
| `vsctrctl` | `rasemu`     | `7`      | `hs`          | `Return-address stack emulation`                         |
| `vsctrctl` | `ste`        | `8`      | `hs`          | `Enable recording of traps to VS-mode`                   |
| `vsctrctl` | `bpfrz`      | `11`     | `hs`          | `Freeze on a breakpoint exception`                       |
| `vsctrctl` | `lcofifrz`   | `12`     | `hs`          | `Freeze on a local counter-overflow interrupt`           |
| `vsctrctl` | `excinh`     | `33`     | `hs`          | `Inhibit exception recording`                            |
| `vsctrctl` | `intrinh`    | `34`     | `hs`          | `Inhibit interrupt recording`                            |
| `vsctrctl` | `tretinh`    | `35`     | `hs`          | `Inhibit trap-return recording`                          |
| `vsctrctl` | `ntbren`     | `36`     | `hs`          | `Enable recording of not-taken branches`                 |
| `vsctrctl` | `tkbrinh`    | `37`     | `hs`          | `Inhibit recording of taken branches`                    |
| `vsctrctl` | `indcallinh` | `40`     | `hs`          | `Inhibit recording of indirect calls`                    |
| `vsctrctl` | `dircallinh` | `41`     | `hs`          | `Inhibit recording of direct calls`                      |
| `vsctrctl` | `indjmpinh`  | `42`     | `hs`          | `Inhibit recording of indirect jumps`                    |
| `vsctrctl` | `dirjmpinh`  | `43`     | `hs`          | `Inhibit recording of direct jumps`                      |
| `vsctrctl` | `corswapinh` | `44`     | `hs`          | `Inhibit recording of coroutine swaps`                   |
| `vsctrctl` | `retinh`     | `45`     | `hs`          | `Inhibit recording of function returns`                  |
| `vsctrctl` | `indljmpinh` | `46`     | `hs`          | `Inhibit recording of other indirect jumps with linkage` |
| `vsctrctl` | `dirljmpinh` | `47`     | `hs`          | `Inhibit recording of other direct jumps with linkage`   |
| `vsctrctl` | `custom`     | `63:60`  | `hs`          | `Custom controls`                                        |

:Virtual Supervisor Control Transfer Records Control
