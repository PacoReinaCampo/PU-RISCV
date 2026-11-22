## CONTROL AND STATUS REGISTER FIELDS

| **CSR**     | **Name** | **Bits** | **Privilege** | **Description**                      |
|:------------|:---------|:---------|:--------------|:-------------------------------------|
| `mvendorid` | `bank`   | `31:7`   | `m`           | `Number of JEDEC continuation bytes` |
| `mvendorid` | `offset` | `6:0`    | `m`           | `JEDEC manufacturer code`            |

:Vendor ID

| **CSR**   | **Name**  | **Bits**    | **Privilege** | **Description**   |
|:----------|:----------|:------------|:--------------|:------------------|
| `marchid` | `marchid` | `MXLEN-1:0` | `m`           | `Architecture ID` |

:Architecture ID

| **CSR**  | **Name** | **Bits**    | **Privilege** | **Description**     |
|:---------|:---------|:------------|:--------------|:--------------------|
| `mimpid` | `mimpid` | `MXLEN-1:0` | `m`           | `Implementation ID` |

:Implementation ID

| **CSR**   | **Name**  | **Bits**    | **Privilege** | **Description** |
|:----------|:----------|:------------|:--------------|:----------------|
| `mhartid` | `mhartid` | `MXLEN-1:0` | `m`           | `Hart ID`       |

:Hardware Thread ID

| **CSR**      | **Name**     | **Bits**    | **Privilege** | **Description**              |
|:-------------|:-------------|:------------|:--------------|:-----------------------------|
| `mconfigptr` | `mconfigptr` | `MXLEN-1:0` | `m`           | `Configuration data pointer` |

:Pointer to Configuration Data Structure

| **CSR**   | **Name** | **Bits** | **Privilege** | **Description**                                           |
|:----------|:---------|:---------|:--------------|:----------------------------------------------------------|
| `mstatus` | `sie`    | `1`      | `m`           | `Supervisor interrupt enable`                             |
| `mstatus` | `mie`    | `3`      | `m`           | `Machine interrupt enable`                                |
| `mstatus` | `spie`   | `5`      | `m`           | `Previous supervisor interrupt enable`                    |
| `mstatus` | `ube`    | `6`      | `m`           | `User-mode data endianness`                               |
| `mstatus` | `mpie`   | `7`      | `m`           | `Previous machine interrupt enable`                       |
| `mstatus` | `spp`    | `8`      | `m`           | `Previous supervisor privilege`                           |
| `mstatus` | `vs`     | `10:9`   | `m`           | `Vector extension state`                                  |
| `mstatus` | `mpp`    | `12:11`  | `m`           | `Previous machine privilege`                              |
| `mstatus` | `fs`     | `14:13`  | `m`           | `Floating-point extension state`                          |
| `mstatus` | `xs`     | `16:15`  | `m`           | `Summary of other extension state`                        |
| `mstatus` | `mprv`   | `17`     | `m`           | `Use MPP privilege for explicit data accesses`            |
| `mstatus` | `sum`    | `18`     | `m`           | `Permit supervisor data access to user pages`             |
| `mstatus` | `mxr`    | `19`     | `m`           | `Make executable pages readable`                          |
| `mstatus` | `tvm`    | `20`     | `m`           | `Trap virtual-memory management operations`               |
| `mstatus` | `tw`     | `21`     | `m`           | `Trap WFI after a timeout`                                |
| `mstatus` | `tsr`    | `22`     | `m`           | `Trap SRET`                                               |
| `mstatus` | `spelp`  | `23`     | `m`           | `Previous expected landing pad state (Zicfilp)`           |
| `mstatus` | `sdt`    | `24`     | `m`           | `Supervisor double-trap control (Ssdbltrp)`               |
| `mstatus` | `sd`     | `31`     | `m`           | `Summary dirty bit (32-bit CSR)`                          |
| `mstatus` | `uxl`    | `33:32`  | `m`           | `User XLEN encoding (64-bit CSR)`                         |
| `mstatus` | `sxl`    | `35:34`  | `m`           | `Supervisor XLEN encoding (RV64)`                         |
| `mstatus` | `sbe`    | `36`     | `m`           | `Supervisor data endianness (RV64)`                       |
| `mstatus` | `mbe`    | `37`     | `m`           | `Machine data endianness (RV64)`                          |
| `mstatus` | `gva`    | `38`     | `m`           | `Trap value holds a guest virtual address (RV64 with H)`  |
| `mstatus` | `mpv`    | `39`     | `m`           | `Previous virtualization mode (RV64 with H)`              |
| `mstatus` | `mpelp`  | `41`     | `m`           | `Previous expected landing pad state (RV64 with Zicfilp)` |
| `mstatus` | `mdt`    | `42`     | `m`           | `Machine double-trap control (RV64 with Smdbltrp)`        |
| `mstatus` | `sd`     | `63`     | `m`           | `Summary dirty bit (64-bit CSR)`                          |

:Machine Status

| **CSR** | **Name**     | **Bits**          | **Privilege** | **Description**                            |
|:--------|:-------------|:------------------|:--------------|:-------------------------------------------|
| `misa`  | `extensions` | `25:0`            | `m`           | `Supported ISA extension bits A through Z` |
| `misa`  | `mxl`        | `MXLEN-1:MXLEN-2` | `m`           | `Machine XLEN encoding`                    |

:ISA and Extensions

| **CSR**   | **Name**     | **Bits** | **Privilege** | **Description**                                                    |
|:----------|:-------------|:---------|:--------------|:-------------------------------------------------------------------|
| `medeleg` | `delegation` | `63:0`   | `m`           | `One bit per synchronous exception cause. RV32 uses the low half.` |

:Machine Exception Delegation

| **CSR**   | **Name**     | **Bits** | **Privilege** | **Description**                                        |
|:----------|:-------------|:---------|:--------------|:-------------------------------------------------------|
| `mideleg` | `delegation` | `63:0`   | `m`           | `One bit per interrupt cause. RV32 uses the low half.` |

:Machine Interrupt Delegation

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                                              |
|:--------|:---------|:---------|:--------------|:-------------------------------------------------------------|
| `mie`   | `ssie`   | `1`      | `m`           | `Supervisor software interrupt enable`                       |
| `mie`   | `vssie`  | `2`      | `m`           | `Virtual supervisor software interrupt enable (H extension)` |
| `mie`   | `msie`   | `3`      | `m`           | `Machine software interrupt enable`                          |
| `mie`   | `stie`   | `5`      | `m`           | `Supervisor timer interrupt enable`                          |
| `mie`   | `vstie`  | `6`      | `m`           | `Virtual supervisor timer interrupt enable (H extension)`    |
| `mie`   | `mtie`   | `7`      | `m`           | `Machine timer interrupt enable`                             |
| `mie`   | `seie`   | `9`      | `m`           | `Supervisor external interrupt enable`                       |
| `mie`   | `vseie`  | `10`     | `m`           | `Virtual supervisor external interrupt enable (H extension)` |
| `mie`   | `meie`   | `11`     | `m`           | `Machine external interrupt enable`                          |
| `mie`   | `sgeie`  | `12`     | `m`           | `Supervisor guest external interrupt enable (H extension)`   |
| `mie`   | `lcofie` | `13`     | `m`           | `Local counter-overflow (Sscofpm) interrupt enable`          |

:Machine Interrupt Enable

| **CSR** | **Name** | **Bits**    | **Privilege** | **Description**                 |
|:--------|:---------|:------------|:--------------|:--------------------------------|
| `mtvec` | `mode`   | `1:0`       | `m`           | `Trap vector mode`              |
| `mtvec` | `base`   | `MXLEN-1:2` | `m`           | `Trap vector base address bits` |

:Machine Trap-Handler Base Address

| **CSR**      | **Name** | **Bits** | **Privilege** | **Description**                           |
|:-------------|:---------|:---------|:--------------|:------------------------------------------|
| `mcounteren` | `cy`     | `0`      | `m`           | `Enable access to cycle`                  |
| `mcounteren` | `tm`     | `1`      | `m`           | `Enable access to time`                   |
| `mcounteren` | `ir`     | `2`      | `m`           | `Enable access to instret`                |
| `mcounteren` | `hpm3`   | `3`      | `m`           | `Enable access to performance counter 3`  |
| `mcounteren` | `hpm4`   | `4`      | `m`           | `Enable access to performance counter 4`  |
| `mcounteren` | `hpm5`   | `5`      | `m`           | `Enable access to performance counter 5`  |
| `mcounteren` | `hpm6`   | `6`      | `m`           | `Enable access to performance counter 6`  |
| `mcounteren` | `hpm7`   | `7`      | `m`           | `Enable access to performance counter 7`  |
| `mcounteren` | `hpm8`   | `8`      | `m`           | `Enable access to performance counter 8`  |
| `mcounteren` | `hpm9`   | `9`      | `m`           | `Enable access to performance counter 9`  |
| `mcounteren` | `hpm10`  | `10`     | `m`           | `Enable access to performance counter 10` |
| `mcounteren` | `hpm11`  | `11`     | `m`           | `Enable access to performance counter 11` |
| `mcounteren` | `hpm12`  | `12`     | `m`           | `Enable access to performance counter 12` |
| `mcounteren` | `hpm13`  | `13`     | `m`           | `Enable access to performance counter 13` |
| `mcounteren` | `hpm14`  | `14`     | `m`           | `Enable access to performance counter 14` |
| `mcounteren` | `hpm15`  | `15`     | `m`           | `Enable access to performance counter 15` |
| `mcounteren` | `hpm16`  | `16`     | `m`           | `Enable access to performance counter 16` |
| `mcounteren` | `hpm17`  | `17`     | `m`           | `Enable access to performance counter 17` |
| `mcounteren` | `hpm18`  | `18`     | `m`           | `Enable access to performance counter 18` |
| `mcounteren` | `hpm19`  | `19`     | `m`           | `Enable access to performance counter 19` |
| `mcounteren` | `hpm20`  | `20`     | `m`           | `Enable access to performance counter 20` |
| `mcounteren` | `hpm21`  | `21`     | `m`           | `Enable access to performance counter 21` |
| `mcounteren` | `hpm22`  | `22`     | `m`           | `Enable access to performance counter 22` |
| `mcounteren` | `hpm23`  | `23`     | `m`           | `Enable access to performance counter 23` |
| `mcounteren` | `hpm24`  | `24`     | `m`           | `Enable access to performance counter 24` |
| `mcounteren` | `hpm25`  | `25`     | `m`           | `Enable access to performance counter 25` |
| `mcounteren` | `hpm26`  | `26`     | `m`           | `Enable access to performance counter 26` |
| `mcounteren` | `hpm27`  | `27`     | `m`           | `Enable access to performance counter 27` |
| `mcounteren` | `hpm28`  | `28`     | `m`           | `Enable access to performance counter 28` |
| `mcounteren` | `hpm29`  | `29`     | `m`           | `Enable access to performance counter 29` |
| `mcounteren` | `hpm30`  | `30`     | `m`           | `Enable access to performance counter 30` |
| `mcounteren` | `hpm31`  | `31`     | `m`           | `Enable access to performance counter 31` |

:Machine Counter Enable

| **CSR** | **Name**     | **Bits** | **Privilege** | **Description**                                                            |
|:--------|:-------------|:---------|:--------------|:---------------------------------------------------------------------------|
| `mvien` | `interrupts` | `63:0`   | `m`           | `Supervisor interrupt virtualization enable bits. RV32 uses the low half.` |

:Machine Virtual Interrupt Enables

| **CSR** | **Name**     | **Bits** | **Privilege** | **Description**                                                      |
|:--------|:-------------|:---------|:--------------|:---------------------------------------------------------------------|
| `mvip`  | `interrupts` | `63:0`   | `m`           | `Supervisor virtual interrupt pending bits. RV32 uses the low half.` |

:Machine Virtual Interrupt Pending Bits

| **CSR**    | **Name** | **Bits** | **Privilege** | **Description**                                           |
|:-----------|:---------|:---------|:--------------|:----------------------------------------------------------|
| `mstatush` | `sbe`    | `4`      | `m`           | `Supervisor data endianness (RV32)`                       |
| `mstatush` | `mbe`    | `5`      | `m`           | `Machine data endianness (RV32)`                          |
| `mstatush` | `gva`    | `6`      | `m`           | `Trap value holds a guest virtual address (RV32 with H)`  |
| `mstatush` | `mpv`    | `7`      | `m`           | `Previous virtualization mode (RV32 with H)`              |
| `mstatush` | `mpelp`  | `9`      | `m`           | `Previous expected landing pad state (RV32 with Zicfilp)` |
| `mstatush` | `mdt`    | `10`     | `m`           | `Machine double-trap control (RV32 with Smdbltrp)`        |

:Machine Status (Upper 32 Bits)

| **CSR**    | **Name**     | **Bits** | **Privilege** | **Description**                                   |
|:-----------|:-------------|:---------|:--------------|:--------------------------------------------------|
| `medelegh` | `delegation` | `31:0`   | `m`           | `Delegation bits for cause numbers 32 through 63` |

:Machine Exception Delegation (Upper 32 Bits)

| **CSR**    | **Name**     | **Bits** | **Privilege** | **Description**                                   |
|:-----------|:-------------|:---------|:--------------|:--------------------------------------------------|
| `midelegh` | `delegation` | `31:0`   | `m`           | `Delegation bits for cause numbers 32 through 63` |

:Machine Interrupt Delegation (Upper 32 Bits)

| **CSR** | **Name**     | **Bits** | **Privilege** | **Description**                                                   |
|:--------|:-------------|:---------|:--------------|:------------------------------------------------------------------|
| `mieh`  | `interrupts` | `31:0`   | `m`           | `Bits corresponding to interrupt identities 32 through 63 (RV32)` |

:Machine Interrupt Enable (Upper 32 Bits)

| **CSR**  | **Name**     | **Bits** | **Privilege** | **Description**                                                   |
|:---------|:-------------|:---------|:--------------|:------------------------------------------------------------------|
| `mvienh` | `interrupts` | `31:0`   | `m`           | `Bits corresponding to interrupt identities 32 through 63 (RV32)` |

:Machine Virtual Interrupt Enables (Upper 32 Bits)

| **CSR** | **Name**     | **Bits** | **Privilege** | **Description**                                                   |
|:--------|:-------------|:---------|:--------------|:------------------------------------------------------------------|
| `mviph` | `interrupts` | `31:0`   | `m`           | `Bits corresponding to interrupt identities 32 through 63 (RV32)` |

:Machine Virtual Interrupt Pending Bits (Upper 32 Bits)

| **CSR**    | **Name**   | **Bits**    | **Privilege** | **Description**          |
|:-----------|:-----------|:------------|:--------------|:-------------------------|
| `mscratch` | `mscratch` | `MXLEN-1:0` | `m`           | `Software scratch value` |

:Machine Scratch

| **CSR** | **Name** | **Bits**    | **Privilege** | **Description**             |
|:--------|:---------|:------------|:--------------|:----------------------------|
| `mepc`  | `mepc`   | `MXLEN-1:0` | `m`           | `Exception program counter` |

:Machine Exception Program Counter

| **CSR**  | **Name**         | **Bits**    | **Privilege** | **Description**       |
|:---------|:-----------------|:------------|:--------------|:----------------------|
| `mcause` | `exception_code` | `MXLEN-2:0` | `m`           | `Trap cause code`     |
| `mcause` | `interrupt`      | `MXLEN-1`   | `m`           | `Interrupt indicator` |

:Machine Trap Cause

| **CSR** | **Name** | **Bits**    | **Privilege** | **Description**                 |
|:--------|:---------|:------------|:--------------|:--------------------------------|
| `mtval` | `mtval`  | `MXLEN-1:0` | `m`           | `Exception-specific trap value` |

:Machine Trap Value

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                                               |
|:--------|:---------|:---------|:--------------|:--------------------------------------------------------------|
| `mip`   | `ssip`   | `1`      | `m`           | `Supervisor software interrupt pending`                       |
| `mip`   | `vssip`  | `2`      | `m`           | `Virtual supervisor software interrupt pending (H extension)` |
| `mip`   | `msip`   | `3`      | `m`           | `Machine software interrupt pending`                          |
| `mip`   | `stip`   | `5`      | `m`           | `Supervisor timer interrupt pending`                          |
| `mip`   | `vstip`  | `6`      | `m`           | `Virtual supervisor timer interrupt pending (H extension)`    |
| `mip`   | `mtip`   | `7`      | `m`           | `Machine timer interrupt pending`                             |
| `mip`   | `seip`   | `9`      | `m`           | `Supervisor external interrupt pending`                       |
| `mip`   | `vseip`  | `10`     | `m`           | `Virtual supervisor external interrupt pending (H extension)` |
| `mip`   | `meip`   | `11`     | `m`           | `Machine external interrupt pending`                          |
| `mip`   | `sgeip`  | `12`     | `m`           | `Supervisor guest external interrupt pending (H extension)`   |
| `mip`   | `lcofip` | `13`     | `m`           | `Local counter-overflow (Sscofpm) interrupt pending`          |

:Machine Interrupt Pending

| **CSR**  | **Name** | **Bits**    | **Privilege** | **Description**               |
|:---------|:---------|:------------|:--------------|:------------------------------|
| `mtinst` | `mtinst` | `MXLEN-1:0` | `m`           | `Additional trap information` |

:Machine Trap Instruction

| **CSR**  | **Name** | **Bits**    | **Privilege** | **Description**               |
|:---------|:---------|:------------|:--------------|:------------------------------|
| `mtval2` | `mtval2` | `MXLEN-1:0` | `m`           | `Additional trap information` |

:Machine Second Trap Value

| **CSR** | **Name**     | **Bits** | **Privilege** | **Description**                                                   |
|:--------|:-------------|:---------|:--------------|:------------------------------------------------------------------|
| `miph`  | `interrupts` | `31:0`   | `m`           | `Bits corresponding to interrupt identities 32 through 63 (RV32)` |

:Machine Interrupt Pending (Upper 32 Bits)

| **CSR**  | **Name**   | **Bits** | **Privilege** | **Description**                                                 |
|:---------|:-----------|:---------|:--------------|:----------------------------------------------------------------|
| `mtopei` | `priority` | `10:0`   | `m`           | `Priority of the top external interrupt, equal to its identity` |
| `mtopei` | `identity` | `26:16`  | `m`           | `Identity of the top external interrupt`                        |

:Machine Top External Interrupt

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                                     |
|:--------|:---------|:---------|:--------------|:----------------------------------------------------|
| `mtopi` | `iprio`  | `7:0`    | `m`           | `Priority of the top pending-and-enabled interrupt` |
| `mtopi` | `iid`    | `27:16`  | `m`           | `Identity of the top pending-and-enabled interrupt` |

:Machine Top Interrupt

| **CSR**    | **Name** | **Bits**    | **Privilege** | **Description**              |
|:-----------|:---------|:------------|:--------------|:-----------------------------|
| `miselect` | `select` | `MXLEN-1:0` | `m`           | `Indirect register selector` |

:Machine Indirect Register Select

| **CSR**  | **Name** | **Bits**    | **Privilege** | **Description**                                                   |
|:---------|:---------|:------------|:--------------|:------------------------------------------------------------------|
| `mireg`  | `data`   | `MXLEN-1:0` | `m`           | `Field layout depends on the selector and the defining extension` |
| `mireg2` | `data`   | `MXLEN-1:0` | `m`           | `Field layout depends on the selector and the defining extension` |
| `mireg3` | `data`   | `MXLEN-1:0` | `m`           | `Field layout depends on the selector and the defining extension` |
| `mireg4` | `data`   | `MXLEN-1:0` | `m`           | `Field layout depends on the selector and the defining extension` |
| `mireg5` | `data`   | `MXLEN-1:0` | `m`           | `Field layout depends on the selector and the defining extension` |
| `mireg6` | `data`   | `MXLEN-1:0` | `m`           | `Field layout depends on the selector and the defining extension` |

:Machine Indirect Register Aliases

| **CSR**   | **Name** | **Bits** | **Privilege** | **Description**                                |
|:----------|:---------|:---------|:--------------|:-----------------------------------------------|
| `menvcfg` | `fiom`   | `0`      | `m`           | `Fence I/O implies memory`                     |
| `menvcfg` | `lpe`    | `2`      | `m`           | `Landing pad enforcement enable`               |
| `menvcfg` | `sse`    | `3`      | `m`           | `Shadow stack enable`                          |
| `menvcfg` | `cbie`   | `5:4`    | `m`           | `Cache-block invalidate configuration`         |
| `menvcfg` | `cbcfe`  | `6`      | `m`           | `Cache-block clean and flush enable`           |
| `menvcfg` | `cbze`   | `7`      | `m`           | `Cache-block zero enable`                      |
| `menvcfg` | `pmm`    | `33:32`  | `m`           | `Pointer masking mode (RV64)`                  |
| `menvcfg` | `dte`    | `59`     | `m`           | `Double-trap enable (RV64)`                    |
| `menvcfg` | `adue`   | `61`     | `m`           | `Hardware page-table A/D update enable (RV64)` |
| `menvcfg` | `pbmte`  | `62`     | `m`           | `Page-based memory types enable (RV64)`        |
| `menvcfg` | `stce`   | `63`     | `m`           | `Supervisor timer compare enable (RV64)`       |
| `menvcfg` | `cde`    | `60`     | `m`           | `Counter delegation enable (RV64)`             |

:Machine Environment Configuration

| **CSR**    | **Name** | **Bits** | **Privilege** | **Description**                         |
|:-----------|:---------|:---------|:--------------|:----------------------------------------|
| `menvcfgh` | `pmm`    | `1:0`    | `m`           | `Pointer masking mode`                  |
| `menvcfgh` | `dte`    | `27`     | `m`           | `Double-trap enable`                    |
| `menvcfgh` | `adue`   | `29`     | `m`           | `Hardware page-table A/D update enable` |
| `menvcfgh` | `pbmte`  | `30`     | `m`           | `Page-based memory types enable`        |
| `menvcfgh` | `stce`   | `31`     | `m`           | `Supervisor timer compare enable`       |
| `menvcfgh` | `cde`    | `28`     | `m`           | `Counter delegation enable`             |

:Machine Environment Configuration (Upper 32 Bits)

| **CSR**   | **Name** | **Bits** | **Privilege** | **Description**                          |
|:----------|:---------|:---------|:--------------|:-----------------------------------------|
| `mseccfg` | `mml`    | `0`      | `m`           | `Machine mode lockdown`                  |
| `mseccfg` | `mmwp`   | `1`      | `m`           | `Machine mode whitelist policy`          |
| `mseccfg` | `rlb`    | `2`      | `m`           | `Rule locking bypass`                    |
| `mseccfg` | `useed`  | `8`      | `m`           | `User-mode seed access enable`           |
| `mseccfg` | `sseed`  | `9`      | `m`           | `Supervisor-mode seed access enable`     |
| `mseccfg` | `mlpe`   | `10`     | `m`           | `Machine landing pad enforcement enable` |
| `mseccfg` | `pmm`    | `33:32`  | `m`           | `Machine pointer masking mode (RV64)`    |

:Machine Security Configuration

| **CSR**    | **Name** | **Bits** | **Privilege** | **Description**                |
|:-----------|:---------|:---------|:--------------|:-------------------------------|
| `mseccfgh` | `pmm`    | `1:0`    | `m`           | `Machine pointer masking mode` |

:Machine Security Configuration (Upper 32 Bits)

| **CSR**    | **Name**     | **Bits** | **Privilege** | **Description**                |
|:-----------|:-------------|:---------|:--------------|:-------------------------------|
| `pmpcfg0`  | `pmp0cfg.r`  | `0`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg0`  | `pmp0cfg.w`  | `1`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg0`  | `pmp0cfg.x`  | `2`      | `m`           | `Execute permission (RV32)`    |
| `pmpcfg0`  | `pmp0cfg.a`  | `4:3`    | `m`           | `Address matching mode (RV32)` |
| `pmpcfg0`  | `pmp0cfg.l`  | `7`      | `m`           | `Lock bit (RV32)`              |
| `pmpcfg0`  | `pmp1cfg.r`  | `8`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg0`  | `pmp1cfg.w`  | `9`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg0`  | `pmp1cfg.x`  | `10`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg0`  | `pmp1cfg.a`  | `12:11`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg0`  | `pmp1cfg.l`  | `15`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg0`  | `pmp2cfg.r`  | `16`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg0`  | `pmp2cfg.w`  | `17`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg0`  | `pmp2cfg.x`  | `18`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg0`  | `pmp2cfg.a`  | `20:19`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg0`  | `pmp2cfg.l`  | `23`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg0`  | `pmp3cfg.r`  | `24`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg0`  | `pmp3cfg.w`  | `25`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg0`  | `pmp3cfg.x`  | `26`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg0`  | `pmp3cfg.a`  | `28:27`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg0`  | `pmp3cfg.l`  | `31`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg0`  | `pmp0cfg.r`  | `0`      | `m`           | `Read permission (RV64)`       |
| `pmpcfg0`  | `pmp0cfg.w`  | `1`      | `m`           | `Write permission (RV64)`      |
| `pmpcfg0`  | `pmp0cfg.x`  | `2`      | `m`           | `Execute permission (RV64)`    |
| `pmpcfg0`  | `pmp0cfg.a`  | `4:3`    | `m`           | `Address matching mode (RV64)` |
| `pmpcfg0`  | `pmp0cfg.l`  | `7`      | `m`           | `Lock bit (RV64)`              |
| `pmpcfg0`  | `pmp1cfg.r`  | `8`      | `m`           | `Read permission (RV64)`       |
| `pmpcfg0`  | `pmp1cfg.w`  | `9`      | `m`           | `Write permission (RV64)`      |
| `pmpcfg0`  | `pmp1cfg.x`  | `10`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg0`  | `pmp1cfg.a`  | `12:11`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg0`  | `pmp1cfg.l`  | `15`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg0`  | `pmp2cfg.r`  | `16`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg0`  | `pmp2cfg.w`  | `17`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg0`  | `pmp2cfg.x`  | `18`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg0`  | `pmp2cfg.a`  | `20:19`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg0`  | `pmp2cfg.l`  | `23`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg0`  | `pmp3cfg.r`  | `24`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg0`  | `pmp3cfg.w`  | `25`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg0`  | `pmp3cfg.x`  | `26`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg0`  | `pmp3cfg.a`  | `28:27`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg0`  | `pmp3cfg.l`  | `31`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg0`  | `pmp4cfg.r`  | `32`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg0`  | `pmp4cfg.w`  | `33`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg0`  | `pmp4cfg.x`  | `34`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg0`  | `pmp4cfg.a`  | `36:35`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg0`  | `pmp4cfg.l`  | `39`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg0`  | `pmp5cfg.r`  | `40`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg0`  | `pmp5cfg.w`  | `41`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg0`  | `pmp5cfg.x`  | `42`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg0`  | `pmp5cfg.a`  | `44:43`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg0`  | `pmp5cfg.l`  | `47`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg0`  | `pmp6cfg.r`  | `48`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg0`  | `pmp6cfg.w`  | `49`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg0`  | `pmp6cfg.x`  | `50`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg0`  | `pmp6cfg.a`  | `52:51`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg0`  | `pmp6cfg.l`  | `55`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg0`  | `pmp7cfg.r`  | `56`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg0`  | `pmp7cfg.w`  | `57`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg0`  | `pmp7cfg.x`  | `58`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg0`  | `pmp7cfg.a`  | `60:59`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg0`  | `pmp7cfg.l`  | `63`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg1`  | `pmp4cfg.r`  | `0`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg1`  | `pmp4cfg.w`  | `1`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg1`  | `pmp4cfg.x`  | `2`      | `m`           | `Execute permission (RV32)`    |
| `pmpcfg1`  | `pmp4cfg.a`  | `4:3`    | `m`           | `Address matching mode (RV32)` |
| `pmpcfg1`  | `pmp4cfg.l`  | `7`      | `m`           | `Lock bit (RV32)`              |
| `pmpcfg1`  | `pmp5cfg.r`  | `8`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg1`  | `pmp5cfg.w`  | `9`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg1`  | `pmp5cfg.x`  | `10`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg1`  | `pmp5cfg.a`  | `12:11`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg1`  | `pmp5cfg.l`  | `15`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg1`  | `pmp6cfg.r`  | `16`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg1`  | `pmp6cfg.w`  | `17`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg1`  | `pmp6cfg.x`  | `18`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg1`  | `pmp6cfg.a`  | `20:19`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg1`  | `pmp6cfg.l`  | `23`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg1`  | `pmp7cfg.r`  | `24`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg1`  | `pmp7cfg.w`  | `25`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg1`  | `pmp7cfg.x`  | `26`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg1`  | `pmp7cfg.a`  | `28:27`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg1`  | `pmp7cfg.l`  | `31`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg2`  | `pmp8cfg.r`  | `0`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg2`  | `pmp8cfg.w`  | `1`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg2`  | `pmp8cfg.x`  | `2`      | `m`           | `Execute permission (RV32)`    |
| `pmpcfg2`  | `pmp8cfg.a`  | `4:3`    | `m`           | `Address matching mode (RV32)` |
| `pmpcfg2`  | `pmp8cfg.l`  | `7`      | `m`           | `Lock bit (RV32)`              |
| `pmpcfg2`  | `pmp9cfg.r`  | `8`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg2`  | `pmp9cfg.w`  | `9`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg2`  | `pmp9cfg.x`  | `10`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg2`  | `pmp9cfg.a`  | `12:11`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg2`  | `pmp9cfg.l`  | `15`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg2`  | `pmp10cfg.r` | `16`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg2`  | `pmp10cfg.w` | `17`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg2`  | `pmp10cfg.x` | `18`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg2`  | `pmp10cfg.a` | `20:19`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg2`  | `pmp10cfg.l` | `23`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg2`  | `pmp11cfg.r` | `24`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg2`  | `pmp11cfg.w` | `25`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg2`  | `pmp11cfg.x` | `26`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg2`  | `pmp11cfg.a` | `28:27`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg2`  | `pmp11cfg.l` | `31`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg2`  | `pmp8cfg.r`  | `0`      | `m`           | `Read permission (RV64)`       |
| `pmpcfg2`  | `pmp8cfg.w`  | `1`      | `m`           | `Write permission (RV64)`      |
| `pmpcfg2`  | `pmp8cfg.x`  | `2`      | `m`           | `Execute permission (RV64)`    |
| `pmpcfg2`  | `pmp8cfg.a`  | `4:3`    | `m`           | `Address matching mode (RV64)` |
| `pmpcfg2`  | `pmp8cfg.l`  | `7`      | `m`           | `Lock bit (RV64)`              |
| `pmpcfg2`  | `pmp9cfg.r`  | `8`      | `m`           | `Read permission (RV64)`       |
| `pmpcfg2`  | `pmp9cfg.w`  | `9`      | `m`           | `Write permission (RV64)`      |
| `pmpcfg2`  | `pmp9cfg.x`  | `10`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg2`  | `pmp9cfg.a`  | `12:11`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg2`  | `pmp9cfg.l`  | `15`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg2`  | `pmp10cfg.r` | `16`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg2`  | `pmp10cfg.w` | `17`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg2`  | `pmp10cfg.x` | `18`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg2`  | `pmp10cfg.a` | `20:19`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg2`  | `pmp10cfg.l` | `23`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg2`  | `pmp11cfg.r` | `24`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg2`  | `pmp11cfg.w` | `25`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg2`  | `pmp11cfg.x` | `26`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg2`  | `pmp11cfg.a` | `28:27`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg2`  | `pmp11cfg.l` | `31`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg2`  | `pmp12cfg.r` | `32`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg2`  | `pmp12cfg.w` | `33`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg2`  | `pmp12cfg.x` | `34`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg2`  | `pmp12cfg.a` | `36:35`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg2`  | `pmp12cfg.l` | `39`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg2`  | `pmp13cfg.r` | `40`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg2`  | `pmp13cfg.w` | `41`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg2`  | `pmp13cfg.x` | `42`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg2`  | `pmp13cfg.a` | `44:43`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg2`  | `pmp13cfg.l` | `47`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg2`  | `pmp14cfg.r` | `48`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg2`  | `pmp14cfg.w` | `49`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg2`  | `pmp14cfg.x` | `50`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg2`  | `pmp14cfg.a` | `52:51`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg2`  | `pmp14cfg.l` | `55`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg2`  | `pmp15cfg.r` | `56`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg2`  | `pmp15cfg.w` | `57`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg2`  | `pmp15cfg.x` | `58`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg2`  | `pmp15cfg.a` | `60:59`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg2`  | `pmp15cfg.l` | `63`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg3`  | `pmp12cfg.r` | `0`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg3`  | `pmp12cfg.w` | `1`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg3`  | `pmp12cfg.x` | `2`      | `m`           | `Execute permission (RV32)`    |
| `pmpcfg3`  | `pmp12cfg.a` | `4:3`    | `m`           | `Address matching mode (RV32)` |
| `pmpcfg3`  | `pmp12cfg.l` | `7`      | `m`           | `Lock bit (RV32)`              |
| `pmpcfg3`  | `pmp13cfg.r` | `8`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg3`  | `pmp13cfg.w` | `9`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg3`  | `pmp13cfg.x` | `10`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg3`  | `pmp13cfg.a` | `12:11`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg3`  | `pmp13cfg.l` | `15`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg3`  | `pmp14cfg.r` | `16`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg3`  | `pmp14cfg.w` | `17`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg3`  | `pmp14cfg.x` | `18`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg3`  | `pmp14cfg.a` | `20:19`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg3`  | `pmp14cfg.l` | `23`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg3`  | `pmp15cfg.r` | `24`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg3`  | `pmp15cfg.w` | `25`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg3`  | `pmp15cfg.x` | `26`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg3`  | `pmp15cfg.a` | `28:27`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg3`  | `pmp15cfg.l` | `31`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg4`  | `pmp16cfg.r` | `0`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg4`  | `pmp16cfg.w` | `1`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg4`  | `pmp16cfg.x` | `2`      | `m`           | `Execute permission (RV32)`    |
| `pmpcfg4`  | `pmp16cfg.a` | `4:3`    | `m`           | `Address matching mode (RV32)` |
| `pmpcfg4`  | `pmp16cfg.l` | `7`      | `m`           | `Lock bit (RV32)`              |
| `pmpcfg4`  | `pmp17cfg.r` | `8`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg4`  | `pmp17cfg.w` | `9`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg4`  | `pmp17cfg.x` | `10`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg4`  | `pmp17cfg.a` | `12:11`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg4`  | `pmp17cfg.l` | `15`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg4`  | `pmp18cfg.r` | `16`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg4`  | `pmp18cfg.w` | `17`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg4`  | `pmp18cfg.x` | `18`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg4`  | `pmp18cfg.a` | `20:19`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg4`  | `pmp18cfg.l` | `23`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg4`  | `pmp19cfg.r` | `24`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg4`  | `pmp19cfg.w` | `25`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg4`  | `pmp19cfg.x` | `26`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg4`  | `pmp19cfg.a` | `28:27`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg4`  | `pmp19cfg.l` | `31`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg4`  | `pmp16cfg.r` | `0`      | `m`           | `Read permission (RV64)`       |
| `pmpcfg4`  | `pmp16cfg.w` | `1`      | `m`           | `Write permission (RV64)`      |
| `pmpcfg4`  | `pmp16cfg.x` | `2`      | `m`           | `Execute permission (RV64)`    |
| `pmpcfg4`  | `pmp16cfg.a` | `4:3`    | `m`           | `Address matching mode (RV64)` |
| `pmpcfg4`  | `pmp16cfg.l` | `7`      | `m`           | `Lock bit (RV64)`              |
| `pmpcfg4`  | `pmp17cfg.r` | `8`      | `m`           | `Read permission (RV64)`       |
| `pmpcfg4`  | `pmp17cfg.w` | `9`      | `m`           | `Write permission (RV64)`      |
| `pmpcfg4`  | `pmp17cfg.x` | `10`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg4`  | `pmp17cfg.a` | `12:11`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg4`  | `pmp17cfg.l` | `15`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg4`  | `pmp18cfg.r` | `16`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg4`  | `pmp18cfg.w` | `17`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg4`  | `pmp18cfg.x` | `18`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg4`  | `pmp18cfg.a` | `20:19`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg4`  | `pmp18cfg.l` | `23`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg4`  | `pmp19cfg.r` | `24`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg4`  | `pmp19cfg.w` | `25`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg4`  | `pmp19cfg.x` | `26`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg4`  | `pmp19cfg.a` | `28:27`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg4`  | `pmp19cfg.l` | `31`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg4`  | `pmp20cfg.r` | `32`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg4`  | `pmp20cfg.w` | `33`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg4`  | `pmp20cfg.x` | `34`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg4`  | `pmp20cfg.a` | `36:35`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg4`  | `pmp20cfg.l` | `39`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg4`  | `pmp21cfg.r` | `40`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg4`  | `pmp21cfg.w` | `41`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg4`  | `pmp21cfg.x` | `42`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg4`  | `pmp21cfg.a` | `44:43`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg4`  | `pmp21cfg.l` | `47`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg4`  | `pmp22cfg.r` | `48`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg4`  | `pmp22cfg.w` | `49`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg4`  | `pmp22cfg.x` | `50`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg4`  | `pmp22cfg.a` | `52:51`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg4`  | `pmp22cfg.l` | `55`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg4`  | `pmp23cfg.r` | `56`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg4`  | `pmp23cfg.w` | `57`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg4`  | `pmp23cfg.x` | `58`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg4`  | `pmp23cfg.a` | `60:59`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg4`  | `pmp23cfg.l` | `63`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg5`  | `pmp20cfg.r` | `0`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg5`  | `pmp20cfg.w` | `1`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg5`  | `pmp20cfg.x` | `2`      | `m`           | `Execute permission (RV32)`    |
| `pmpcfg5`  | `pmp20cfg.a` | `4:3`    | `m`           | `Address matching mode (RV32)` |
| `pmpcfg5`  | `pmp20cfg.l` | `7`      | `m`           | `Lock bit (RV32)`              |
| `pmpcfg5`  | `pmp21cfg.r` | `8`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg5`  | `pmp21cfg.w` | `9`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg5`  | `pmp21cfg.x` | `10`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg5`  | `pmp21cfg.a` | `12:11`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg5`  | `pmp21cfg.l` | `15`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg5`  | `pmp22cfg.r` | `16`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg5`  | `pmp22cfg.w` | `17`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg5`  | `pmp22cfg.x` | `18`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg5`  | `pmp22cfg.a` | `20:19`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg5`  | `pmp22cfg.l` | `23`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg5`  | `pmp23cfg.r` | `24`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg5`  | `pmp23cfg.w` | `25`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg5`  | `pmp23cfg.x` | `26`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg5`  | `pmp23cfg.a` | `28:27`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg5`  | `pmp23cfg.l` | `31`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg6`  | `pmp24cfg.r` | `0`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg6`  | `pmp24cfg.w` | `1`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg6`  | `pmp24cfg.x` | `2`      | `m`           | `Execute permission (RV32)`    |
| `pmpcfg6`  | `pmp24cfg.a` | `4:3`    | `m`           | `Address matching mode (RV32)` |
| `pmpcfg6`  | `pmp24cfg.l` | `7`      | `m`           | `Lock bit (RV32)`              |
| `pmpcfg6`  | `pmp25cfg.r` | `8`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg6`  | `pmp25cfg.w` | `9`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg6`  | `pmp25cfg.x` | `10`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg6`  | `pmp25cfg.a` | `12:11`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg6`  | `pmp25cfg.l` | `15`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg6`  | `pmp26cfg.r` | `16`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg6`  | `pmp26cfg.w` | `17`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg6`  | `pmp26cfg.x` | `18`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg6`  | `pmp26cfg.a` | `20:19`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg6`  | `pmp26cfg.l` | `23`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg6`  | `pmp27cfg.r` | `24`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg6`  | `pmp27cfg.w` | `25`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg6`  | `pmp27cfg.x` | `26`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg6`  | `pmp27cfg.a` | `28:27`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg6`  | `pmp27cfg.l` | `31`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg6`  | `pmp24cfg.r` | `0`      | `m`           | `Read permission (RV64)`       |
| `pmpcfg6`  | `pmp24cfg.w` | `1`      | `m`           | `Write permission (RV64)`      |
| `pmpcfg6`  | `pmp24cfg.x` | `2`      | `m`           | `Execute permission (RV64)`    |
| `pmpcfg6`  | `pmp24cfg.a` | `4:3`    | `m`           | `Address matching mode (RV64)` |
| `pmpcfg6`  | `pmp24cfg.l` | `7`      | `m`           | `Lock bit (RV64)`              |
| `pmpcfg6`  | `pmp25cfg.r` | `8`      | `m`           | `Read permission (RV64)`       |
| `pmpcfg6`  | `pmp25cfg.w` | `9`      | `m`           | `Write permission (RV64)`      |
| `pmpcfg6`  | `pmp25cfg.x` | `10`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg6`  | `pmp25cfg.a` | `12:11`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg6`  | `pmp25cfg.l` | `15`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg6`  | `pmp26cfg.r` | `16`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg6`  | `pmp26cfg.w` | `17`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg6`  | `pmp26cfg.x` | `18`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg6`  | `pmp26cfg.a` | `20:19`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg6`  | `pmp26cfg.l` | `23`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg6`  | `pmp27cfg.r` | `24`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg6`  | `pmp27cfg.w` | `25`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg6`  | `pmp27cfg.x` | `26`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg6`  | `pmp27cfg.a` | `28:27`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg6`  | `pmp27cfg.l` | `31`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg6`  | `pmp28cfg.r` | `32`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg6`  | `pmp28cfg.w` | `33`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg6`  | `pmp28cfg.x` | `34`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg6`  | `pmp28cfg.a` | `36:35`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg6`  | `pmp28cfg.l` | `39`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg6`  | `pmp29cfg.r` | `40`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg6`  | `pmp29cfg.w` | `41`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg6`  | `pmp29cfg.x` | `42`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg6`  | `pmp29cfg.a` | `44:43`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg6`  | `pmp29cfg.l` | `47`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg6`  | `pmp30cfg.r` | `48`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg6`  | `pmp30cfg.w` | `49`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg6`  | `pmp30cfg.x` | `50`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg6`  | `pmp30cfg.a` | `52:51`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg6`  | `pmp30cfg.l` | `55`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg6`  | `pmp31cfg.r` | `56`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg6`  | `pmp31cfg.w` | `57`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg6`  | `pmp31cfg.x` | `58`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg6`  | `pmp31cfg.a` | `60:59`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg6`  | `pmp31cfg.l` | `63`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg7`  | `pmp28cfg.r` | `0`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg7`  | `pmp28cfg.w` | `1`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg7`  | `pmp28cfg.x` | `2`      | `m`           | `Execute permission (RV32)`    |
| `pmpcfg7`  | `pmp28cfg.a` | `4:3`    | `m`           | `Address matching mode (RV32)` |
| `pmpcfg7`  | `pmp28cfg.l` | `7`      | `m`           | `Lock bit (RV32)`              |
| `pmpcfg7`  | `pmp29cfg.r` | `8`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg7`  | `pmp29cfg.w` | `9`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg7`  | `pmp29cfg.x` | `10`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg7`  | `pmp29cfg.a` | `12:11`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg7`  | `pmp29cfg.l` | `15`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg7`  | `pmp30cfg.r` | `16`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg7`  | `pmp30cfg.w` | `17`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg7`  | `pmp30cfg.x` | `18`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg7`  | `pmp30cfg.a` | `20:19`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg7`  | `pmp30cfg.l` | `23`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg7`  | `pmp31cfg.r` | `24`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg7`  | `pmp31cfg.w` | `25`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg7`  | `pmp31cfg.x` | `26`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg7`  | `pmp31cfg.a` | `28:27`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg7`  | `pmp31cfg.l` | `31`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg8`  | `pmp32cfg.r` | `0`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg8`  | `pmp32cfg.w` | `1`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg8`  | `pmp32cfg.x` | `2`      | `m`           | `Execute permission (RV32)`    |
| `pmpcfg8`  | `pmp32cfg.a` | `4:3`    | `m`           | `Address matching mode (RV32)` |
| `pmpcfg8`  | `pmp32cfg.l` | `7`      | `m`           | `Lock bit (RV32)`              |
| `pmpcfg8`  | `pmp33cfg.r` | `8`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg8`  | `pmp33cfg.w` | `9`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg8`  | `pmp33cfg.x` | `10`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg8`  | `pmp33cfg.a` | `12:11`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg8`  | `pmp33cfg.l` | `15`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg8`  | `pmp34cfg.r` | `16`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg8`  | `pmp34cfg.w` | `17`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg8`  | `pmp34cfg.x` | `18`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg8`  | `pmp34cfg.a` | `20:19`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg8`  | `pmp34cfg.l` | `23`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg8`  | `pmp35cfg.r` | `24`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg8`  | `pmp35cfg.w` | `25`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg8`  | `pmp35cfg.x` | `26`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg8`  | `pmp35cfg.a` | `28:27`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg8`  | `pmp35cfg.l` | `31`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg8`  | `pmp32cfg.r` | `0`      | `m`           | `Read permission (RV64)`       |
| `pmpcfg8`  | `pmp32cfg.w` | `1`      | `m`           | `Write permission (RV64)`      |
| `pmpcfg8`  | `pmp32cfg.x` | `2`      | `m`           | `Execute permission (RV64)`    |
| `pmpcfg8`  | `pmp32cfg.a` | `4:3`    | `m`           | `Address matching mode (RV64)` |
| `pmpcfg8`  | `pmp32cfg.l` | `7`      | `m`           | `Lock bit (RV64)`              |
| `pmpcfg8`  | `pmp33cfg.r` | `8`      | `m`           | `Read permission (RV64)`       |
| `pmpcfg8`  | `pmp33cfg.w` | `9`      | `m`           | `Write permission (RV64)`      |
| `pmpcfg8`  | `pmp33cfg.x` | `10`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg8`  | `pmp33cfg.a` | `12:11`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg8`  | `pmp33cfg.l` | `15`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg8`  | `pmp34cfg.r` | `16`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg8`  | `pmp34cfg.w` | `17`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg8`  | `pmp34cfg.x` | `18`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg8`  | `pmp34cfg.a` | `20:19`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg8`  | `pmp34cfg.l` | `23`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg8`  | `pmp35cfg.r` | `24`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg8`  | `pmp35cfg.w` | `25`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg8`  | `pmp35cfg.x` | `26`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg8`  | `pmp35cfg.a` | `28:27`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg8`  | `pmp35cfg.l` | `31`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg8`  | `pmp36cfg.r` | `32`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg8`  | `pmp36cfg.w` | `33`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg8`  | `pmp36cfg.x` | `34`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg8`  | `pmp36cfg.a` | `36:35`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg8`  | `pmp36cfg.l` | `39`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg8`  | `pmp37cfg.r` | `40`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg8`  | `pmp37cfg.w` | `41`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg8`  | `pmp37cfg.x` | `42`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg8`  | `pmp37cfg.a` | `44:43`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg8`  | `pmp37cfg.l` | `47`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg8`  | `pmp38cfg.r` | `48`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg8`  | `pmp38cfg.w` | `49`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg8`  | `pmp38cfg.x` | `50`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg8`  | `pmp38cfg.a` | `52:51`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg8`  | `pmp38cfg.l` | `55`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg8`  | `pmp39cfg.r` | `56`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg8`  | `pmp39cfg.w` | `57`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg8`  | `pmp39cfg.x` | `58`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg8`  | `pmp39cfg.a` | `60:59`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg8`  | `pmp39cfg.l` | `63`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg9`  | `pmp36cfg.r` | `0`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg9`  | `pmp36cfg.w` | `1`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg9`  | `pmp36cfg.x` | `2`      | `m`           | `Execute permission (RV32)`    |
| `pmpcfg9`  | `pmp36cfg.a` | `4:3`    | `m`           | `Address matching mode (RV32)` |
| `pmpcfg9`  | `pmp36cfg.l` | `7`      | `m`           | `Lock bit (RV32)`              |
| `pmpcfg9`  | `pmp37cfg.r` | `8`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg9`  | `pmp37cfg.w` | `9`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg9`  | `pmp37cfg.x` | `10`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg9`  | `pmp37cfg.a` | `12:11`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg9`  | `pmp37cfg.l` | `15`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg9`  | `pmp38cfg.r` | `16`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg9`  | `pmp38cfg.w` | `17`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg9`  | `pmp38cfg.x` | `18`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg9`  | `pmp38cfg.a` | `20:19`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg9`  | `pmp38cfg.l` | `23`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg9`  | `pmp39cfg.r` | `24`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg9`  | `pmp39cfg.w` | `25`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg9`  | `pmp39cfg.x` | `26`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg9`  | `pmp39cfg.a` | `28:27`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg9`  | `pmp39cfg.l` | `31`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg10` | `pmp40cfg.r` | `0`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg10` | `pmp40cfg.w` | `1`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg10` | `pmp40cfg.x` | `2`      | `m`           | `Execute permission (RV32)`    |
| `pmpcfg10` | `pmp40cfg.a` | `4:3`    | `m`           | `Address matching mode (RV32)` |
| `pmpcfg10` | `pmp40cfg.l` | `7`      | `m`           | `Lock bit (RV32)`              |
| `pmpcfg10` | `pmp41cfg.r` | `8`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg10` | `pmp41cfg.w` | `9`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg10` | `pmp41cfg.x` | `10`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg10` | `pmp41cfg.a` | `12:11`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg10` | `pmp41cfg.l` | `15`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg10` | `pmp42cfg.r` | `16`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg10` | `pmp42cfg.w` | `17`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg10` | `pmp42cfg.x` | `18`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg10` | `pmp42cfg.a` | `20:19`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg10` | `pmp42cfg.l` | `23`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg10` | `pmp43cfg.r` | `24`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg10` | `pmp43cfg.w` | `25`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg10` | `pmp43cfg.x` | `26`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg10` | `pmp43cfg.a` | `28:27`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg10` | `pmp43cfg.l` | `31`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg10` | `pmp40cfg.r` | `0`      | `m`           | `Read permission (RV64)`       |
| `pmpcfg10` | `pmp40cfg.w` | `1`      | `m`           | `Write permission (RV64)`      |
| `pmpcfg10` | `pmp40cfg.x` | `2`      | `m`           | `Execute permission (RV64)`    |
| `pmpcfg10` | `pmp40cfg.a` | `4:3`    | `m`           | `Address matching mode (RV64)` |
| `pmpcfg10` | `pmp40cfg.l` | `7`      | `m`           | `Lock bit (RV64)`              |
| `pmpcfg10` | `pmp41cfg.r` | `8`      | `m`           | `Read permission (RV64)`       |
| `pmpcfg10` | `pmp41cfg.w` | `9`      | `m`           | `Write permission (RV64)`      |
| `pmpcfg10` | `pmp41cfg.x` | `10`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg10` | `pmp41cfg.a` | `12:11`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg10` | `pmp41cfg.l` | `15`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg10` | `pmp42cfg.r` | `16`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg10` | `pmp42cfg.w` | `17`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg10` | `pmp42cfg.x` | `18`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg10` | `pmp42cfg.a` | `20:19`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg10` | `pmp42cfg.l` | `23`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg10` | `pmp43cfg.r` | `24`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg10` | `pmp43cfg.w` | `25`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg10` | `pmp43cfg.x` | `26`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg10` | `pmp43cfg.a` | `28:27`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg10` | `pmp43cfg.l` | `31`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg10` | `pmp44cfg.r` | `32`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg10` | `pmp44cfg.w` | `33`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg10` | `pmp44cfg.x` | `34`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg10` | `pmp44cfg.a` | `36:35`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg10` | `pmp44cfg.l` | `39`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg10` | `pmp45cfg.r` | `40`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg10` | `pmp45cfg.w` | `41`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg10` | `pmp45cfg.x` | `42`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg10` | `pmp45cfg.a` | `44:43`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg10` | `pmp45cfg.l` | `47`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg10` | `pmp46cfg.r` | `48`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg10` | `pmp46cfg.w` | `49`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg10` | `pmp46cfg.x` | `50`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg10` | `pmp46cfg.a` | `52:51`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg10` | `pmp46cfg.l` | `55`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg10` | `pmp47cfg.r` | `56`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg10` | `pmp47cfg.w` | `57`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg10` | `pmp47cfg.x` | `58`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg10` | `pmp47cfg.a` | `60:59`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg10` | `pmp47cfg.l` | `63`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg11` | `pmp44cfg.r` | `0`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg11` | `pmp44cfg.w` | `1`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg11` | `pmp44cfg.x` | `2`      | `m`           | `Execute permission (RV32)`    |
| `pmpcfg11` | `pmp44cfg.a` | `4:3`    | `m`           | `Address matching mode (RV32)` |
| `pmpcfg11` | `pmp44cfg.l` | `7`      | `m`           | `Lock bit (RV32)`              |
| `pmpcfg11` | `pmp45cfg.r` | `8`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg11` | `pmp45cfg.w` | `9`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg11` | `pmp45cfg.x` | `10`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg11` | `pmp45cfg.a` | `12:11`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg11` | `pmp45cfg.l` | `15`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg11` | `pmp46cfg.r` | `16`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg11` | `pmp46cfg.w` | `17`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg11` | `pmp46cfg.x` | `18`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg11` | `pmp46cfg.a` | `20:19`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg11` | `pmp46cfg.l` | `23`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg11` | `pmp47cfg.r` | `24`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg11` | `pmp47cfg.w` | `25`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg11` | `pmp47cfg.x` | `26`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg11` | `pmp47cfg.a` | `28:27`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg11` | `pmp47cfg.l` | `31`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg12` | `pmp48cfg.r` | `0`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg12` | `pmp48cfg.w` | `1`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg12` | `pmp48cfg.x` | `2`      | `m`           | `Execute permission (RV32)`    |
| `pmpcfg12` | `pmp48cfg.a` | `4:3`    | `m`           | `Address matching mode (RV32)` |
| `pmpcfg12` | `pmp48cfg.l` | `7`      | `m`           | `Lock bit (RV32)`              |
| `pmpcfg12` | `pmp49cfg.r` | `8`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg12` | `pmp49cfg.w` | `9`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg12` | `pmp49cfg.x` | `10`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg12` | `pmp49cfg.a` | `12:11`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg12` | `pmp49cfg.l` | `15`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg12` | `pmp50cfg.r` | `16`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg12` | `pmp50cfg.w` | `17`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg12` | `pmp50cfg.x` | `18`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg12` | `pmp50cfg.a` | `20:19`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg12` | `pmp50cfg.l` | `23`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg12` | `pmp51cfg.r` | `24`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg12` | `pmp51cfg.w` | `25`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg12` | `pmp51cfg.x` | `26`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg12` | `pmp51cfg.a` | `28:27`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg12` | `pmp51cfg.l` | `31`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg12` | `pmp48cfg.r` | `0`      | `m`           | `Read permission (RV64)`       |
| `pmpcfg12` | `pmp48cfg.w` | `1`      | `m`           | `Write permission (RV64)`      |
| `pmpcfg12` | `pmp48cfg.x` | `2`      | `m`           | `Execute permission (RV64)`    |
| `pmpcfg12` | `pmp48cfg.a` | `4:3`    | `m`           | `Address matching mode (RV64)` |
| `pmpcfg12` | `pmp48cfg.l` | `7`      | `m`           | `Lock bit (RV64)`              |
| `pmpcfg12` | `pmp49cfg.r` | `8`      | `m`           | `Read permission (RV64)`       |
| `pmpcfg12` | `pmp49cfg.w` | `9`      | `m`           | `Write permission (RV64)`      |
| `pmpcfg12` | `pmp49cfg.x` | `10`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg12` | `pmp49cfg.a` | `12:11`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg12` | `pmp49cfg.l` | `15`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg12` | `pmp50cfg.r` | `16`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg12` | `pmp50cfg.w` | `17`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg12` | `pmp50cfg.x` | `18`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg12` | `pmp50cfg.a` | `20:19`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg12` | `pmp50cfg.l` | `23`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg12` | `pmp51cfg.r` | `24`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg12` | `pmp51cfg.w` | `25`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg12` | `pmp51cfg.x` | `26`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg12` | `pmp51cfg.a` | `28:27`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg12` | `pmp51cfg.l` | `31`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg12` | `pmp52cfg.r` | `32`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg12` | `pmp52cfg.w` | `33`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg12` | `pmp52cfg.x` | `34`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg12` | `pmp52cfg.a` | `36:35`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg12` | `pmp52cfg.l` | `39`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg12` | `pmp53cfg.r` | `40`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg12` | `pmp53cfg.w` | `41`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg12` | `pmp53cfg.x` | `42`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg12` | `pmp53cfg.a` | `44:43`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg12` | `pmp53cfg.l` | `47`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg12` | `pmp54cfg.r` | `48`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg12` | `pmp54cfg.w` | `49`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg12` | `pmp54cfg.x` | `50`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg12` | `pmp54cfg.a` | `52:51`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg12` | `pmp54cfg.l` | `55`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg12` | `pmp55cfg.r` | `56`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg12` | `pmp55cfg.w` | `57`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg12` | `pmp55cfg.x` | `58`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg12` | `pmp55cfg.a` | `60:59`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg12` | `pmp55cfg.l` | `63`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg13` | `pmp52cfg.r` | `0`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg13` | `pmp52cfg.w` | `1`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg13` | `pmp52cfg.x` | `2`      | `m`           | `Execute permission (RV32)`    |
| `pmpcfg13` | `pmp52cfg.a` | `4:3`    | `m`           | `Address matching mode (RV32)` |
| `pmpcfg13` | `pmp52cfg.l` | `7`      | `m`           | `Lock bit (RV32)`              |
| `pmpcfg13` | `pmp53cfg.r` | `8`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg13` | `pmp53cfg.w` | `9`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg13` | `pmp53cfg.x` | `10`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg13` | `pmp53cfg.a` | `12:11`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg13` | `pmp53cfg.l` | `15`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg13` | `pmp54cfg.r` | `16`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg13` | `pmp54cfg.w` | `17`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg13` | `pmp54cfg.x` | `18`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg13` | `pmp54cfg.a` | `20:19`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg13` | `pmp54cfg.l` | `23`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg13` | `pmp55cfg.r` | `24`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg13` | `pmp55cfg.w` | `25`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg13` | `pmp55cfg.x` | `26`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg13` | `pmp55cfg.a` | `28:27`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg13` | `pmp55cfg.l` | `31`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg14` | `pmp56cfg.r` | `0`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg14` | `pmp56cfg.w` | `1`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg14` | `pmp56cfg.x` | `2`      | `m`           | `Execute permission (RV32)`    |
| `pmpcfg14` | `pmp56cfg.a` | `4:3`    | `m`           | `Address matching mode (RV32)` |
| `pmpcfg14` | `pmp56cfg.l` | `7`      | `m`           | `Lock bit (RV32)`              |
| `pmpcfg14` | `pmp57cfg.r` | `8`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg14` | `pmp57cfg.w` | `9`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg14` | `pmp57cfg.x` | `10`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg14` | `pmp57cfg.a` | `12:11`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg14` | `pmp57cfg.l` | `15`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg14` | `pmp58cfg.r` | `16`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg14` | `pmp58cfg.w` | `17`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg14` | `pmp58cfg.x` | `18`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg14` | `pmp58cfg.a` | `20:19`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg14` | `pmp58cfg.l` | `23`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg14` | `pmp59cfg.r` | `24`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg14` | `pmp59cfg.w` | `25`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg14` | `pmp59cfg.x` | `26`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg14` | `pmp59cfg.a` | `28:27`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg14` | `pmp59cfg.l` | `31`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg14` | `pmp56cfg.r` | `0`      | `m`           | `Read permission (RV64)`       |
| `pmpcfg14` | `pmp56cfg.w` | `1`      | `m`           | `Write permission (RV64)`      |
| `pmpcfg14` | `pmp56cfg.x` | `2`      | `m`           | `Execute permission (RV64)`    |
| `pmpcfg14` | `pmp56cfg.a` | `4:3`    | `m`           | `Address matching mode (RV64)` |
| `pmpcfg14` | `pmp56cfg.l` | `7`      | `m`           | `Lock bit (RV64)`              |
| `pmpcfg14` | `pmp57cfg.r` | `8`      | `m`           | `Read permission (RV64)`       |
| `pmpcfg14` | `pmp57cfg.w` | `9`      | `m`           | `Write permission (RV64)`      |
| `pmpcfg14` | `pmp57cfg.x` | `10`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg14` | `pmp57cfg.a` | `12:11`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg14` | `pmp57cfg.l` | `15`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg14` | `pmp58cfg.r` | `16`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg14` | `pmp58cfg.w` | `17`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg14` | `pmp58cfg.x` | `18`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg14` | `pmp58cfg.a` | `20:19`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg14` | `pmp58cfg.l` | `23`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg14` | `pmp59cfg.r` | `24`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg14` | `pmp59cfg.w` | `25`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg14` | `pmp59cfg.x` | `26`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg14` | `pmp59cfg.a` | `28:27`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg14` | `pmp59cfg.l` | `31`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg14` | `pmp60cfg.r` | `32`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg14` | `pmp60cfg.w` | `33`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg14` | `pmp60cfg.x` | `34`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg14` | `pmp60cfg.a` | `36:35`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg14` | `pmp60cfg.l` | `39`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg14` | `pmp61cfg.r` | `40`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg14` | `pmp61cfg.w` | `41`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg14` | `pmp61cfg.x` | `42`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg14` | `pmp61cfg.a` | `44:43`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg14` | `pmp61cfg.l` | `47`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg14` | `pmp62cfg.r` | `48`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg14` | `pmp62cfg.w` | `49`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg14` | `pmp62cfg.x` | `50`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg14` | `pmp62cfg.a` | `52:51`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg14` | `pmp62cfg.l` | `55`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg14` | `pmp63cfg.r` | `56`     | `m`           | `Read permission (RV64)`       |
| `pmpcfg14` | `pmp63cfg.w` | `57`     | `m`           | `Write permission (RV64)`      |
| `pmpcfg14` | `pmp63cfg.x` | `58`     | `m`           | `Execute permission (RV64)`    |
| `pmpcfg14` | `pmp63cfg.a` | `60:59`  | `m`           | `Address matching mode (RV64)` |
| `pmpcfg14` | `pmp63cfg.l` | `63`     | `m`           | `Lock bit (RV64)`              |
| `pmpcfg15` | `pmp60cfg.r` | `0`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg15` | `pmp60cfg.w` | `1`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg15` | `pmp60cfg.x` | `2`      | `m`           | `Execute permission (RV32)`    |
| `pmpcfg15` | `pmp60cfg.a` | `4:3`    | `m`           | `Address matching mode (RV32)` |
| `pmpcfg15` | `pmp60cfg.l` | `7`      | `m`           | `Lock bit (RV32)`              |
| `pmpcfg15` | `pmp61cfg.r` | `8`      | `m`           | `Read permission (RV32)`       |
| `pmpcfg15` | `pmp61cfg.w` | `9`      | `m`           | `Write permission (RV32)`      |
| `pmpcfg15` | `pmp61cfg.x` | `10`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg15` | `pmp61cfg.a` | `12:11`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg15` | `pmp61cfg.l` | `15`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg15` | `pmp62cfg.r` | `16`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg15` | `pmp62cfg.w` | `17`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg15` | `pmp62cfg.x` | `18`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg15` | `pmp62cfg.a` | `20:19`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg15` | `pmp62cfg.l` | `23`     | `m`           | `Lock bit (RV32)`              |
| `pmpcfg15` | `pmp63cfg.r` | `24`     | `m`           | `Read permission (RV32)`       |
| `pmpcfg15` | `pmp63cfg.w` | `25`     | `m`           | `Write permission (RV32)`      |
| `pmpcfg15` | `pmp63cfg.x` | `26`     | `m`           | `Execute permission (RV32)`    |
| `pmpcfg15` | `pmp63cfg.a` | `28:27`  | `m`           | `Address matching mode (RV32)` |
| `pmpcfg15` | `pmp63cfg.l` | `31`     | `m`           | `Lock bit (RV32)`              |

:Physical Memory Protection Configuration Registers

| **CSR**     | **Name**  | **Bits** | **Privilege** | **Description**                     |
|:------------|:----------|:---------|:--------------|:------------------------------------|
| `pmpaddr0`  | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr0`  | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr1`  | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr1`  | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr2`  | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr2`  | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr3`  | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr3`  | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr4`  | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr4`  | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr5`  | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr5`  | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr6`  | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr6`  | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr7`  | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr7`  | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr8`  | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr8`  | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr9`  | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr9`  | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr10` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr10` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr11` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr11` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr12` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr12` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr13` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr13` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr14` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr14` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr15` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr15` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr16` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr16` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr17` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr17` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr18` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr18` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr19` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr19` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr20` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr20` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr21` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr21` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr22` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr22` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr23` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr23` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr24` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr24` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr25` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr25` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr26` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr26` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr27` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr27` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr28` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr28` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr29` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr29` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr30` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr30` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr31` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr31` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr32` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr32` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr33` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr33` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr34` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr34` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr35` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr35` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr36` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr36` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr37` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr37` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr38` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr38` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr39` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr39` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr40` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr40` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr41` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr41` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr42` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr42` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr43` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr43` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr44` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr44` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr45` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr45` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr46` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr46` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr47` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr47` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr48` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr48` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr49` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr49` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr50` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr50` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr51` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr51` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr52` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr52` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr53` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr53` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr54` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr54` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr55` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr55` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr56` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr56` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr57` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr57` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr58` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr58` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr59` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr59` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr60` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr60` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr61` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr61` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr62` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr62` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |
| `pmpaddr63` | `address` | `31:0`   | `m`           | `Physical address bits 33:2 (RV32)` |
| `pmpaddr63` | `address` | `53:0`   | `m`           | `Physical address bits 55:2 (RV64)` |

:Physical Memory Protection Address Registers

| **CSR**     | **Name**   | **Bits** | **Privilege** | **Description**                                                                 |
|:------------|:-----------|:---------|:--------------|:--------------------------------------------------------------------------------|
| `mstateen0` | `c`        | `0`      | `m`           | `Custom state access enable`                                                    |
| `mstateen0` | `fcsr`     | `1`      | `m`           | `Floating-point CSR access enable for Zfinx`                                    |
| `mstateen0` | `jvt`      | `2`      | `m`           | `Jump vector table access enable`                                               |
| `mstateen0` | `ctr`      | `54`     | `m`           | `Control transfer records access enable (RV64)`                                 |
| `mstateen0` | `context`  | `57`     | `m`           | `Context register access enable (RV64)`                                         |
| `mstateen0` | `imsic`    | `58`     | `m`           | `IMSIC access enable (RV64)`                                                    |
| `mstateen0` | `aia`      | `59`     | `m`           | `AIA state access enable (RV64)`                                                |
| `mstateen0` | `csrind`   | `60`     | `m`           | `Indirect CSR access enable (RV64)`                                             |
| `mstateen0` | `envcfg`   | `62`     | `m`           | `Environment configuration access enable (RV64)`                                |
| `mstateen0` | `se0`      | `63`     | `m`           | `State-enable register 0 access enable (RV64)`                                  |
| `mstateen0` | `srmcfg`   | `55`     | `m`           | `Supervisor resource management configuration access enable (RV64)`             |
| `mstateen0` | `p1p13`    | `56`     | `m`           | `Upper hypervisor exception delegation register access enable (RV64)`           |
| `mstateen1` | `reserved` | `62:0`   | `m`           | `Reserved state-enable bits`                                                    |
| `mstateen1` | `se1`      | `63`     | `m`           | `Access enable for corresponding lower-privilege state-enable registers (RV64)` |
| `mstateen2` | `reserved` | `62:0`   | `m`           | `Reserved state-enable bits`                                                    |
| `mstateen2` | `se2`      | `63`     | `m`           | `Access enable for corresponding lower-privilege state-enable registers (RV64)` |
| `mstateen3` | `reserved` | `62:0`   | `m`           | `Reserved state-enable bits`                                                    |
| `mstateen3` | `se3`      | `63`     | `m`           | `Access enable for corresponding lower-privilege state-enable registers (RV64)` |

:Machine State Enable Registers

| **CSR**      | **Name**   | **Bits** | **Privilege** | **Description**                                                                 |
|:-------------|:-----------|:---------|:--------------|:--------------------------------------------------------------------------------|
| `mstateen0h` | `ctr`      | `22`     | `m`           | `Control transfer records access enable`                                        |
| `mstateen0h` | `context`  | `25`     | `m`           | `Context register access enable`                                                |
| `mstateen0h` | `imsic`    | `26`     | `m`           | `IMSIC access enable`                                                           |
| `mstateen0h` | `aia`      | `27`     | `m`           | `AIA state access enable`                                                       |
| `mstateen0h` | `csrind`   | `28`     | `m`           | `Indirect CSR access enable`                                                    |
| `mstateen0h` | `envcfg`   | `30`     | `m`           | `Environment configuration access enable`                                       |
| `mstateen0h` | `se0`      | `31`     | `m`           | `State-enable register 0 access enable`                                         |
| `mstateen0h` | `srmcfg`   | `23`     | `m`           | `Supervisor resource management configuration access enable`                    |
| `mstateen0h` | `p1p13`    | `24`     | `m`           | `Upper hypervisor exception delegation register access enable`                  |
| `mstateen1h` | `reserved` | `30:0`   | `m`           | `Reserved upper state-enable bits (RV32)`                                       |
| `mstateen1h` | `se1`      | `31`     | `m`           | `Access enable for corresponding lower-privilege state-enable registers (RV32)` |
| `mstateen2h` | `reserved` | `30:0`   | `m`           | `Reserved upper state-enable bits (RV32)`                                       |
| `mstateen2h` | `se2`      | `31`     | `m`           | `Access enable for corresponding lower-privilege state-enable registers (RV32)` |
| `mstateen3h` | `reserved` | `30:0`   | `m`           | `Reserved upper state-enable bits (RV32)`                                       |
| `mstateen3h` | `se3`      | `31`     | `m`           | `Access enable for corresponding lower-privilege state-enable registers (RV32)` |

:Machine State Enable Registers (Upper 32 Bits)

| **CSR**     | **Name**    | **Bits**    | **Privilege** | **Description**          |
|:------------|:------------|:------------|:--------------|:-------------------------|
| `mnscratch` | `mnscratch` | `MXLEN-1:0` | `m`           | `Software scratch value` |

:Resumable NMI Scratch

| **CSR** | **Name** | **Bits**    | **Privilege** | **Description**             |
|:--------|:---------|:------------|:--------------|:----------------------------|
| `mnepc` | `mnepc`  | `MXLEN-1:0` | `m`           | `Exception program counter` |

:Resumable NMI Program Counter

| **CSR**   | **Name**         | **Bits**    | **Privilege** | **Description**       |
|:----------|:-----------------|:------------|:--------------|:----------------------|
| `mncause` | `exception_code` | `MXLEN-2:0` | `m`           | `Trap cause code`     |
| `mncause` | `interrupt`      | `MXLEN-1`   | `m`           | `Interrupt indicator` |

:Resumable NMI Cause

| **CSR**    | **Name** | **Bits** | **Privilege** | **Description**                             |
|:-----------|:---------|:---------|:--------------|:--------------------------------------------|
| `mnstatus` | `nmie`   | `3`      | `m`           | `Resumable non-maskable interrupts enabled` |
| `mnstatus` | `mnpv`   | `7`      | `m`           | `Previous virtualization mode`              |
| `mnstatus` | `mnpelp` | `9`      | `m`           | `Previous expected landing pad state`       |
| `mnstatus` | `mnpp`   | `12:11`  | `m`           | `Previous privilege mode`                   |

:Resumable NMI Status

| **CSR**  | **Name** | **Bits** | **Privilege** | **Description**                                 |
|:---------|:---------|:---------|:--------------|:------------------------------------------------|
| `mcycle` | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |

:Machine Cycle Counter

| **CSR**    | **Name** | **Bits** | **Privilege** | **Description**                                 |
|:-----------|:---------|:---------|:--------------|:------------------------------------------------|
| `minstret` | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |

:Machine Instructions-Retired Counter

| **CSR**         | **Name** | **Bits** | **Privilege** | **Description**                                 |
|:----------------|:---------|:---------|:--------------|:------------------------------------------------|
| `mhpmcounter3`  | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter4`  | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter5`  | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter6`  | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter7`  | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter8`  | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter9`  | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter10` | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter11` | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter12` | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter13` | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter14` | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter15` | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter16` | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter17` | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter18` | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter19` | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter20` | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter21` | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter22` | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter23` | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter24` | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter25` | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter26` | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter27` | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter28` | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter29` | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter30` | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |
| `mhpmcounter31` | `count`  | `63:0`   | `m`           | `64-bit counter value. RV32 uses the low half.` |

:Machine Performance-Monitoring Counters

| **CSR**   | **Name** | **Bits** | **Privilege** | **Description**             |
|:----------|:---------|:---------|:--------------|:----------------------------|
| `mcycleh` | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |

:Machine Cycle Counter (Upper 32 Bits)

| **CSR**     | **Name** | **Bits** | **Privilege** | **Description**             |
|:------------|:---------|:---------|:--------------|:----------------------------|
| `minstreth` | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |

:Machine Instructions-Retired Counter (Upper 32 Bits)

| **CSR**          | **Name** | **Bits** | **Privilege** | **Description**             |
|:-----------------|:---------|:---------|:--------------|:----------------------------|
| `mhpmcounter3h`  | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter4h`  | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter5h`  | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter6h`  | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter7h`  | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter8h`  | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter9h`  | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter10h` | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter11h` | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter12h` | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter13h` | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter14h` | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter15h` | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter16h` | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter17h` | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter18h` | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter19h` | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter20h` | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter21h` | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter22h` | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter23h` | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter24h` | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter25h` | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter26h` | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter27h` | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter28h` | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter29h` | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter30h` | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |
| `mhpmcounter31h` | `count`  | `31:0`   | `m`           | `Counter bits 63:32 (RV32)` |

:Machine Performance-Monitoring Counters (Upper 32 Bits)

| **CSR**         | **Name** | **Bits** | **Privilege** | **Description**                               |
|:----------------|:---------|:---------|:--------------|:----------------------------------------------|
| `mcountinhibit` | `cy`     | `0`      | `m`           | `Inhibit counting for cycle`                  |
| `mcountinhibit` | `ir`     | `2`      | `m`           | `Inhibit counting for instret`                |
| `mcountinhibit` | `hpm3`   | `3`      | `m`           | `Inhibit counting for performance counter 3`  |
| `mcountinhibit` | `hpm4`   | `4`      | `m`           | `Inhibit counting for performance counter 4`  |
| `mcountinhibit` | `hpm5`   | `5`      | `m`           | `Inhibit counting for performance counter 5`  |
| `mcountinhibit` | `hpm6`   | `6`      | `m`           | `Inhibit counting for performance counter 6`  |
| `mcountinhibit` | `hpm7`   | `7`      | `m`           | `Inhibit counting for performance counter 7`  |
| `mcountinhibit` | `hpm8`   | `8`      | `m`           | `Inhibit counting for performance counter 8`  |
| `mcountinhibit` | `hpm9`   | `9`      | `m`           | `Inhibit counting for performance counter 9`  |
| `mcountinhibit` | `hpm10`  | `10`     | `m`           | `Inhibit counting for performance counter 10` |
| `mcountinhibit` | `hpm11`  | `11`     | `m`           | `Inhibit counting for performance counter 11` |
| `mcountinhibit` | `hpm12`  | `12`     | `m`           | `Inhibit counting for performance counter 12` |
| `mcountinhibit` | `hpm13`  | `13`     | `m`           | `Inhibit counting for performance counter 13` |
| `mcountinhibit` | `hpm14`  | `14`     | `m`           | `Inhibit counting for performance counter 14` |
| `mcountinhibit` | `hpm15`  | `15`     | `m`           | `Inhibit counting for performance counter 15` |
| `mcountinhibit` | `hpm16`  | `16`     | `m`           | `Inhibit counting for performance counter 16` |
| `mcountinhibit` | `hpm17`  | `17`     | `m`           | `Inhibit counting for performance counter 17` |
| `mcountinhibit` | `hpm18`  | `18`     | `m`           | `Inhibit counting for performance counter 18` |
| `mcountinhibit` | `hpm19`  | `19`     | `m`           | `Inhibit counting for performance counter 19` |
| `mcountinhibit` | `hpm20`  | `20`     | `m`           | `Inhibit counting for performance counter 20` |
| `mcountinhibit` | `hpm21`  | `21`     | `m`           | `Inhibit counting for performance counter 21` |
| `mcountinhibit` | `hpm22`  | `22`     | `m`           | `Inhibit counting for performance counter 22` |
| `mcountinhibit` | `hpm23`  | `23`     | `m`           | `Inhibit counting for performance counter 23` |
| `mcountinhibit` | `hpm24`  | `24`     | `m`           | `Inhibit counting for performance counter 24` |
| `mcountinhibit` | `hpm25`  | `25`     | `m`           | `Inhibit counting for performance counter 25` |
| `mcountinhibit` | `hpm26`  | `26`     | `m`           | `Inhibit counting for performance counter 26` |
| `mcountinhibit` | `hpm27`  | `27`     | `m`           | `Inhibit counting for performance counter 27` |
| `mcountinhibit` | `hpm28`  | `28`     | `m`           | `Inhibit counting for performance counter 28` |
| `mcountinhibit` | `hpm29`  | `29`     | `m`           | `Inhibit counting for performance counter 29` |
| `mcountinhibit` | `hpm30`  | `30`     | `m`           | `Inhibit counting for performance counter 30` |
| `mcountinhibit` | `hpm31`  | `31`     | `m`           | `Inhibit counting for performance counter 31` |

:Machine Counter-Inhibit

| **CSR**       | **Name** | **Bits** | **Privilege** | **Description**                           |
|:--------------|:---------|:---------|:--------------|:------------------------------------------|
| `mcyclecfg`   | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode (RV64)`      |
| `mcyclecfg`   | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode (RV64)`      |
| `mcyclecfg`   | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode (RV64)`       |
| `mcyclecfg`   | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode (RV64)` |
| `mcyclecfg`   | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode (RV64)`       |
| `minstretcfg` | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode (RV64)`      |
| `minstretcfg` | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode (RV64)`      |
| `minstretcfg` | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode (RV64)`       |
| `minstretcfg` | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode (RV64)` |
| `minstretcfg` | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode (RV64)`       |

:Machine Cycle and Instructions-Retired Counter Configuration

| **CSR**       | **Name** | **Bits** | **Privilege** | **Description**                                                                 |
|:--------------|:---------|:---------|:--------------|:--------------------------------------------------------------------------------|
| `mhpmevent3`  | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent3`  | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent3`  | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent3`  | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent3`  | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent3`  | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent3`  | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent3`  | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent4`  | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent4`  | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent4`  | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent4`  | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent4`  | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent4`  | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent4`  | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent4`  | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent5`  | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent5`  | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent5`  | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent5`  | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent5`  | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent5`  | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent5`  | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent5`  | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent6`  | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent6`  | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent6`  | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent6`  | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent6`  | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent6`  | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent6`  | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent6`  | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent7`  | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent7`  | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent7`  | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent7`  | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent7`  | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent7`  | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent7`  | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent7`  | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent8`  | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent8`  | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent8`  | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent8`  | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent8`  | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent8`  | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent8`  | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent8`  | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent9`  | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent9`  | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent9`  | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent9`  | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent9`  | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent9`  | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent9`  | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent9`  | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent10` | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent10` | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent10` | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent10` | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent10` | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent10` | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent10` | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent10` | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent11` | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent11` | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent11` | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent11` | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent11` | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent11` | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent11` | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent11` | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent12` | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent12` | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent12` | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent12` | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent12` | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent12` | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent12` | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent12` | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent13` | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent13` | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent13` | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent13` | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent13` | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent13` | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent13` | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent13` | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent14` | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent14` | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent14` | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent14` | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent14` | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent14` | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent14` | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent14` | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent15` | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent15` | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent15` | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent15` | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent15` | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent15` | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent15` | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent15` | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent16` | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent16` | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent16` | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent16` | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent16` | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent16` | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent16` | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent16` | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent17` | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent17` | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent17` | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent17` | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent17` | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent17` | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent17` | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent17` | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent18` | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent18` | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent18` | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent18` | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent18` | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent18` | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent18` | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent18` | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent19` | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent19` | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent19` | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent19` | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent19` | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent19` | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent19` | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent19` | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent20` | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent20` | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent20` | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent20` | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent20` | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent20` | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent20` | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent20` | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent21` | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent21` | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent21` | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent21` | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent21` | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent21` | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent21` | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent21` | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent22` | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent22` | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent22` | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent22` | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent22` | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent22` | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent22` | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent22` | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent23` | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent23` | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent23` | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent23` | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent23` | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent23` | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent23` | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent23` | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent24` | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent24` | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent24` | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent24` | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent24` | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent24` | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent24` | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent24` | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent25` | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent25` | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent25` | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent25` | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent25` | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent25` | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent25` | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent25` | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent26` | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent26` | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent26` | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent26` | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent26` | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent26` | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent26` | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent26` | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent27` | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent27` | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent27` | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent27` | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent27` | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent27` | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent27` | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent27` | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent28` | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent28` | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent28` | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent28` | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent28` | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent28` | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent28` | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent28` | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent29` | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent29` | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent29` | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent29` | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent29` | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent29` | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent29` | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent29` | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent30` | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent30` | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent30` | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent30` | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent30` | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent30` | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent30` | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent30` | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |
| `mhpmevent31` | `event`  | `55:0`   | `m`           | `Platform-defined event selector with Sscofpmf`                                 |
| `mhpmevent31` | `vuinh`  | `58`     | `m`           | `Inhibit counting in VU-mode`                                                   |
| `mhpmevent31` | `vsinh`  | `59`     | `m`           | `Inhibit counting in VS-mode`                                                   |
| `mhpmevent31` | `uinh`   | `60`     | `m`           | `Inhibit counting in U-mode`                                                    |
| `mhpmevent31` | `sinh`   | `61`     | `m`           | `Inhibit counting in S or HS mode`                                              |
| `mhpmevent31` | `minh`   | `62`     | `m`           | `Inhibit counting in M-mode`                                                    |
| `mhpmevent31` | `of`     | `63`     | `m`           | `Counter overflow flag with Sscofpmf`                                           |
| `mhpmevent31` | `event`  | `63:0`   | `m`           | `Platform-defined event selector without Sscofpmf. RV32 accesses the low half.` |

:Machine Performance-Monitoring Event Selectors

| **CSR**        | **Name** | **Bits** | **Privilege** | **Description**                    |
|:---------------|:---------|:---------|:--------------|:-----------------------------------|
| `mcyclecfgh`   | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`      |
| `mcyclecfgh`   | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`      |
| `mcyclecfgh`   | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`       |
| `mcyclecfgh`   | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode` |
| `mcyclecfgh`   | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`       |
| `minstretcfgh` | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`      |
| `minstretcfgh` | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`      |
| `minstretcfgh` | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`       |
| `minstretcfgh` | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode` |
| `minstretcfgh` | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`       |

:Machine Cycle and Instructions-Retired Counter Configuration (Upper 32 Bits)

| **CSR**        | **Name** | **Bits** | **Privilege** | **Description**                                  |
|:---------------|:---------|:---------|:--------------|:-------------------------------------------------|
| `mhpmevent3h`  | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent3h`  | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent3h`  | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent3h`  | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent3h`  | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent3h`  | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent3h`  | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent4h`  | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent4h`  | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent4h`  | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent4h`  | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent4h`  | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent4h`  | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent4h`  | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent5h`  | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent5h`  | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent5h`  | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent5h`  | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent5h`  | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent5h`  | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent5h`  | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent6h`  | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent6h`  | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent6h`  | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent6h`  | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent6h`  | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent6h`  | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent6h`  | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent7h`  | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent7h`  | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent7h`  | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent7h`  | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent7h`  | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent7h`  | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent7h`  | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent8h`  | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent8h`  | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent8h`  | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent8h`  | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent8h`  | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent8h`  | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent8h`  | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent9h`  | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent9h`  | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent9h`  | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent9h`  | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent9h`  | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent9h`  | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent9h`  | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent10h` | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent10h` | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent10h` | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent10h` | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent10h` | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent10h` | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent10h` | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent11h` | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent11h` | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent11h` | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent11h` | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent11h` | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent11h` | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent11h` | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent12h` | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent12h` | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent12h` | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent12h` | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent12h` | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent12h` | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent12h` | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent13h` | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent13h` | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent13h` | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent13h` | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent13h` | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent13h` | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent13h` | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent14h` | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent14h` | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent14h` | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent14h` | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent14h` | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent14h` | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent14h` | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent15h` | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent15h` | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent15h` | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent15h` | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent15h` | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent15h` | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent15h` | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent16h` | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent16h` | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent16h` | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent16h` | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent16h` | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent16h` | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent16h` | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent17h` | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent17h` | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent17h` | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent17h` | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent17h` | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent17h` | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent17h` | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent18h` | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent18h` | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent18h` | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent18h` | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent18h` | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent18h` | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent18h` | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent19h` | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent19h` | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent19h` | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent19h` | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent19h` | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent19h` | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent19h` | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent20h` | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent20h` | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent20h` | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent20h` | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent20h` | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent20h` | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent20h` | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent21h` | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent21h` | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent21h` | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent21h` | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent21h` | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent21h` | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent21h` | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent22h` | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent22h` | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent22h` | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent22h` | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent22h` | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent22h` | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent22h` | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent23h` | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent23h` | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent23h` | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent23h` | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent23h` | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent23h` | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent23h` | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent24h` | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent24h` | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent24h` | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent24h` | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent24h` | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent24h` | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent24h` | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent25h` | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent25h` | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent25h` | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent25h` | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent25h` | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent25h` | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent25h` | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent26h` | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent26h` | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent26h` | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent26h` | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent26h` | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent26h` | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent26h` | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent27h` | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent27h` | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent27h` | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent27h` | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent27h` | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent27h` | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent27h` | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent28h` | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent28h` | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent28h` | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent28h` | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent28h` | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent28h` | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent28h` | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent29h` | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent29h` | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent29h` | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent29h` | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent29h` | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent29h` | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent29h` | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent30h` | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent30h` | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent30h` | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent30h` | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent30h` | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent30h` | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent30h` | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |
| `mhpmevent31h` | `event`  | `23:0`   | `m`           | `Upper event selector bits (RV32 with Sscofpmf)` |
| `mhpmevent31h` | `vuinh`  | `26`     | `m`           | `Inhibit counting in VU-mode`                    |
| `mhpmevent31h` | `vsinh`  | `27`     | `m`           | `Inhibit counting in VS-mode`                    |
| `mhpmevent31h` | `uinh`   | `28`     | `m`           | `Inhibit counting in U-mode`                     |
| `mhpmevent31h` | `sinh`   | `29`     | `m`           | `Inhibit counting in S or HS mode`               |
| `mhpmevent31h` | `minh`   | `30`     | `m`           | `Inhibit counting in M-mode`                     |
| `mhpmevent31h` | `of`     | `31`     | `m`           | `Counter overflow flag with Sscofpmf`            |

:Machine Performance-Monitoring Event Selectors (Upper 32 Bits)

| **CSR**   | **Name**     | **Bits** | **Privilege** | **Description**                                          |
|:----------|:-------------|:---------|:--------------|:---------------------------------------------------------|
| `mctrctl` | `u`          | `0`      | `m`           | `Enable recording in U-mode`                             |
| `mctrctl` | `s`          | `1`      | `m`           | `Enable recording in S-mode`                             |
| `mctrctl` | `m`          | `2`      | `m`           | `Enable recording in M-mode`                             |
| `mctrctl` | `rasemu`     | `7`      | `m`           | `Return-address stack emulation`                         |
| `mctrctl` | `ste`        | `8`      | `m`           | `Enable recording of traps to S-mode`                    |
| `mctrctl` | `mte`        | `9`      | `m`           | `Enable recording of traps to M-mode`                    |
| `mctrctl` | `bpfrz`      | `11`     | `m`           | `Freeze on a breakpoint exception`                       |
| `mctrctl` | `lcofifrz`   | `12`     | `m`           | `Freeze on a local counter-overflow interrupt`           |
| `mctrctl` | `excinh`     | `33`     | `m`           | `Inhibit exception recording`                            |
| `mctrctl` | `intrinh`    | `34`     | `m`           | `Inhibit interrupt recording`                            |
| `mctrctl` | `tretinh`    | `35`     | `m`           | `Inhibit trap-return recording`                          |
| `mctrctl` | `ntbren`     | `36`     | `m`           | `Enable recording of not-taken branches`                 |
| `mctrctl` | `tkbrinh`    | `37`     | `m`           | `Inhibit recording of taken branches`                    |
| `mctrctl` | `indcallinh` | `40`     | `m`           | `Inhibit recording of indirect calls`                    |
| `mctrctl` | `dircallinh` | `41`     | `m`           | `Inhibit recording of direct calls`                      |
| `mctrctl` | `indjmpinh`  | `42`     | `m`           | `Inhibit recording of indirect jumps`                    |
| `mctrctl` | `dirjmpinh`  | `43`     | `m`           | `Inhibit recording of direct jumps`                      |
| `mctrctl` | `corswapinh` | `44`     | `m`           | `Inhibit recording of coroutine swaps`                   |
| `mctrctl` | `retinh`     | `45`     | `m`           | `Inhibit recording of function returns`                  |
| `mctrctl` | `indljmpinh` | `46`     | `m`           | `Inhibit recording of other indirect jumps with linkage` |
| `mctrctl` | `dirljmpinh` | `47`     | `m`           | `Inhibit recording of other direct jumps with linkage`   |
| `mctrctl` | `custom`     | `63:60`  | `m`           | `Custom controls`                                        |

:Machine Control Transfer Records Control

| **CSR**   | **Name** | **Bits**   | **Privilege** | **Description**          |
|:----------|:---------|:-----------|:--------------|:-------------------------|
| `tselect` | `index`  | `XLEN-1:0` | `m`           | `Selected trigger index` |

:Debug/Trace Trigger Register Select

| **CSR**  | **Name** | **Bits**        | **Privilege** | **Description**                                    |
|:---------|:---------|:----------------|:--------------|:---------------------------------------------------|
| `tdata1` | `data`   | `XLEN-6:0`      | `m`           | `Trigger-type-specific data`                       |
| `tdata1` | `dmode`  | `XLEN-5`        | `m`           | `Debug-mode write control`                         |
| `tdata1` | `type`   | `XLEN-1:XLEN-4` | `m`           | `Trigger type`                                     |
| `tdata2` | `data`   | `XLEN-1:0`      | `m`           | `Data format depends on the selected trigger type` |
| `tdata3` | `data`   | `XLEN-1:0`      | `m`           | `Data format depends on the selected trigger type` |

:Debug/Trace Trigger Data Registers

| **CSR** | **Name**  | **Bits** | **Privilege** | **Description**                 |
|:--------|:----------|:---------|:--------------|:--------------------------------|
| `tinfo` | `info`    | `15:0`   | `m`           | `Supported trigger types`       |
| `tinfo` | `version` | `31:24`  | `m`           | `Trigger specification version` |

:Trigger Info

| **CSR**    | **Name** | **Bits** | **Privilege** | **Description**                        |
|:-----------|:---------|:---------|:--------------|:---------------------------------------|
| `tcontrol` | `mte`    | `3`      | `m`           | `Machine-mode trigger enable`          |
| `tcontrol` | `mpte`   | `7`      | `m`           | `Previous machine-mode trigger enable` |

:Trigger Control

| **CSR**    | **Name**   | **Bits** | **Privilege** | **Description**                                                               |
|:-----------|:-----------|:---------|:--------------|:------------------------------------------------------------------------------|
| `mcontext` | `hcontext` | `13:0`   | `m`           | `Context value for trigger matching. Implementations may support fewer bits.` |

:Machine-Mode Context

| **CSR** | **Name**    | **Bits** | **Privilege** | **Description**                        |
|:--------|:------------|:---------|:--------------|:---------------------------------------|
| `dcsr`  | `prv`       | `1:0`    | `d`           | `Privilege mode on debug entry`        |
| `dcsr`  | `step`      | `2`      | `d`           | `Single-step enable`                   |
| `dcsr`  | `nmip`      | `3`      | `d`           | `Non-maskable interrupt pending`       |
| `dcsr`  | `mprven`    | `4`      | `d`           | `Honor mstatus.MPRV in Debug Mode`     |
| `dcsr`  | `v`         | `5`      | `d`           | `Virtualization mode on debug entry`   |
| `dcsr`  | `cause`     | `8:6`    | `d`           | `Cause of debug entry`                 |
| `dcsr`  | `stoptime`  | `9`      | `d`           | `Stop timers in Debug Mode`            |
| `dcsr`  | `stopcount` | `10`     | `d`           | `Stop counters in Debug Mode`          |
| `dcsr`  | `stepie`    | `11`     | `d`           | `Enable interrupts during single-step` |
| `dcsr`  | `ebreaku`   | `12`     | `d`           | `Enter Debug Mode on U-mode EBREAK`    |
| `dcsr`  | `ebreaks`   | `13`     | `d`           | `Enter Debug Mode on S-mode EBREAK`    |
| `dcsr`  | `ebreakm`   | `15`     | `d`           | `Enter Debug Mode on M-mode EBREAK`    |
| `dcsr`  | `ebreakvu`  | `16`     | `d`           | `Enter Debug Mode on VU-mode EBREAK`   |
| `dcsr`  | `ebreakvs`  | `17`     | `d`           | `Enter Debug Mode on VS-mode EBREAK`   |
| `dcsr`  | `pelp`      | `18`     | `d`           | `Previous expected landing pad state`  |
| `dcsr`  | `cetrig`    | `19`     | `d`           | `Critical-error trigger status`        |
| `dcsr`  | `extcause`  | `26:24`  | `d`           | `Extended cause of debug entry`        |
| `dcsr`  | `debugver`  | `31:28`  | `d`           | `Debug specification version`          |

:Debug Control and Status

| **CSR** | **Name** | **Bits**   | **Privilege** | **Description**                                |
|:--------|:---------|:-----------|:--------------|:-----------------------------------------------|
| `dpc`   | `dpc`    | `XLEN-1:0` | `d`           | `Program counter saved on entry to Debug Mode` |

:Debug Program Counter

| **CSR**     | **Name** | **Bits**   | **Privilege** | **Description**       |
|:------------|:---------|:-----------|:--------------|:----------------------|
| `dscratch0` | `data`   | `XLEN-1:0` | `d`           | `Debug scratch value` |
| `dscratch1` | `data`   | `XLEN-1:0` | `d`           | `Debug scratch value` |

:Debug Scratch Registers
