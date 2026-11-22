## CONTROL AND STATUS REGISTER FIELDS

| **CSR**   | **Name** | **Bits** | **Privilege** | **Description**                                 |
|:----------|:---------|:---------|:--------------|:------------------------------------------------|
| `sstatus` | `sie`    | `1`      | `s`           | `Supervisor interrupt enable`                   |
| `sstatus` | `spie`   | `5`      | `s`           | `Previous supervisor interrupt enable`          |
| `sstatus` | `ube`    | `6`      | `s`           | `User-mode data endianness`                     |
| `sstatus` | `spp`    | `8`      | `s`           | `Previous supervisor privilege`                 |
| `sstatus` | `vs`     | `10:9`   | `s`           | `Vector extension state`                        |
| `sstatus` | `fs`     | `14:13`  | `s`           | `Floating-point extension state`                |
| `sstatus` | `xs`     | `16:15`  | `s`           | `Summary of other extension state`              |
| `sstatus` | `sum`    | `18`     | `s`           | `Permit supervisor data access to user pages`   |
| `sstatus` | `mxr`    | `19`     | `s`           | `Make executable pages readable`                |
| `sstatus` | `spelp`  | `23`     | `s`           | `Previous expected landing pad state (Zicfilp)` |
| `sstatus` | `sdt`    | `24`     | `s`           | `Supervisor double-trap control (Ssdbltrp)`     |
| `sstatus` | `uxl`    | `33:32`  | `s`           | `User XLEN encoding (64-bit CSR)`               |
| `sstatus` | `sd`     | `31`     | `s`           | `Summary dirty bit (32-bit CSR)`                |
| `sstatus` | `sd`     | `63`     | `s`           | `Summary dirty bit (64-bit CSR)`                |

:Supervisor Status

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                                     |
|:--------|:---------|:---------|:--------------|:----------------------------------------------------|
| `sie`   | `ssie`   | `1`      | `s`           | `Supervisor software interrupt enable`              |
| `sie`   | `stie`   | `5`      | `s`           | `Supervisor timer interrupt enable`                 |
| `sie`   | `seie`   | `9`      | `s`           | `Supervisor external interrupt enable`              |
| `sie`   | `lcofie` | `13`     | `s`           | `Local counter-overflow (Sscofpm) interrupt enable` |

:Supervisor Interrupt Enable

| **CSR** | **Name** | **Bits**    | **Privilege** | **Description**                 |
|:--------|:---------|:------------|:--------------|:--------------------------------|
| `stvec` | `mode`   | `1:0`       | `s`           | `Trap vector mode`              |
| `stvec` | `base`   | `SXLEN-1:2` | `s`           | `Trap vector base address bits` |

:Supervisor Trap Handler Base Address

| **CSR**      | **Name** | **Bits** | **Privilege** | **Description**                           |
|:-------------|:---------|:---------|:--------------|:------------------------------------------|
| `scounteren` | `cy`     | `0`      | `s`           | `Enable access to cycle`                  |
| `scounteren` | `tm`     | `1`      | `s`           | `Enable access to time`                   |
| `scounteren` | `ir`     | `2`      | `s`           | `Enable access to instret`                |
| `scounteren` | `hpm3`   | `3`      | `s`           | `Enable access to performance counter 3`  |
| `scounteren` | `hpm4`   | `4`      | `s`           | `Enable access to performance counter 4`  |
| `scounteren` | `hpm5`   | `5`      | `s`           | `Enable access to performance counter 5`  |
| `scounteren` | `hpm6`   | `6`      | `s`           | `Enable access to performance counter 6`  |
| `scounteren` | `hpm7`   | `7`      | `s`           | `Enable access to performance counter 7`  |
| `scounteren` | `hpm8`   | `8`      | `s`           | `Enable access to performance counter 8`  |
| `scounteren` | `hpm9`   | `9`      | `s`           | `Enable access to performance counter 9`  |
| `scounteren` | `hpm10`  | `10`     | `s`           | `Enable access to performance counter 10` |
| `scounteren` | `hpm11`  | `11`     | `s`           | `Enable access to performance counter 11` |
| `scounteren` | `hpm12`  | `12`     | `s`           | `Enable access to performance counter 12` |
| `scounteren` | `hpm13`  | `13`     | `s`           | `Enable access to performance counter 13` |
| `scounteren` | `hpm14`  | `14`     | `s`           | `Enable access to performance counter 14` |
| `scounteren` | `hpm15`  | `15`     | `s`           | `Enable access to performance counter 15` |
| `scounteren` | `hpm16`  | `16`     | `s`           | `Enable access to performance counter 16` |
| `scounteren` | `hpm17`  | `17`     | `s`           | `Enable access to performance counter 17` |
| `scounteren` | `hpm18`  | `18`     | `s`           | `Enable access to performance counter 18` |
| `scounteren` | `hpm19`  | `19`     | `s`           | `Enable access to performance counter 19` |
| `scounteren` | `hpm20`  | `20`     | `s`           | `Enable access to performance counter 20` |
| `scounteren` | `hpm21`  | `21`     | `s`           | `Enable access to performance counter 21` |
| `scounteren` | `hpm22`  | `22`     | `s`           | `Enable access to performance counter 22` |
| `scounteren` | `hpm23`  | `23`     | `s`           | `Enable access to performance counter 23` |
| `scounteren` | `hpm24`  | `24`     | `s`           | `Enable access to performance counter 24` |
| `scounteren` | `hpm25`  | `25`     | `s`           | `Enable access to performance counter 25` |
| `scounteren` | `hpm26`  | `26`     | `s`           | `Enable access to performance counter 26` |
| `scounteren` | `hpm27`  | `27`     | `s`           | `Enable access to performance counter 27` |
| `scounteren` | `hpm28`  | `28`     | `s`           | `Enable access to performance counter 28` |
| `scounteren` | `hpm29`  | `29`     | `s`           | `Enable access to performance counter 29` |
| `scounteren` | `hpm30`  | `30`     | `s`           | `Enable access to performance counter 30` |
| `scounteren` | `hpm31`  | `31`     | `s`           | `Enable access to performance counter 31` |

:Supervisor Counter Enable

| **CSR** | **Name**     | **Bits** | **Privilege** | **Description**                                                   |
|:--------|:-------------|:---------|:--------------|:------------------------------------------------------------------|
| `sieh`  | `interrupts` | `31:0`   | `s`           | `Bits corresponding to interrupt identities 32 through 63 (RV32)` |

:Supervisor Interrupt Enable (Upper 32 Bits)

| **CSR**   | **Name** | **Bits** | **Privilege** | **Description**                        |
|:----------|:---------|:---------|:--------------|:---------------------------------------|
| `senvcfg` | `fiom`   | `0`      | `s`           | `Fence I/O implies memory`             |
| `senvcfg` | `lpe`    | `2`      | `s`           | `Landing pad enforcement enable`       |
| `senvcfg` | `sse`    | `3`      | `s`           | `Shadow stack enable`                  |
| `senvcfg` | `cbie`   | `5:4`    | `s`           | `Cache-block invalidate configuration` |
| `senvcfg` | `cbcfe`  | `6`      | `s`           | `Cache-block clean and flush enable`   |
| `senvcfg` | `cbze`   | `7`      | `s`           | `Cache-block zero enable`              |
| `senvcfg` | `pmm`    | `33:32`  | `s`           | `Pointer masking mode`                 |

:Supervisor Environment Configuration

| **CSR**         | **Name** | **Bits** | **Privilege** | **Description**                               |
|:----------------|:---------|:---------|:--------------|:----------------------------------------------|
| `scountinhibit` | `cy`     | `0`      | `s`           | `Inhibit counting for cycle`                  |
| `scountinhibit` | `ir`     | `2`      | `s`           | `Inhibit counting for instret`                |
| `scountinhibit` | `hpm3`   | `3`      | `s`           | `Inhibit counting for performance counter 3`  |
| `scountinhibit` | `hpm4`   | `4`      | `s`           | `Inhibit counting for performance counter 4`  |
| `scountinhibit` | `hpm5`   | `5`      | `s`           | `Inhibit counting for performance counter 5`  |
| `scountinhibit` | `hpm6`   | `6`      | `s`           | `Inhibit counting for performance counter 6`  |
| `scountinhibit` | `hpm7`   | `7`      | `s`           | `Inhibit counting for performance counter 7`  |
| `scountinhibit` | `hpm8`   | `8`      | `s`           | `Inhibit counting for performance counter 8`  |
| `scountinhibit` | `hpm9`   | `9`      | `s`           | `Inhibit counting for performance counter 9`  |
| `scountinhibit` | `hpm10`  | `10`     | `s`           | `Inhibit counting for performance counter 10` |
| `scountinhibit` | `hpm11`  | `11`     | `s`           | `Inhibit counting for performance counter 11` |
| `scountinhibit` | `hpm12`  | `12`     | `s`           | `Inhibit counting for performance counter 12` |
| `scountinhibit` | `hpm13`  | `13`     | `s`           | `Inhibit counting for performance counter 13` |
| `scountinhibit` | `hpm14`  | `14`     | `s`           | `Inhibit counting for performance counter 14` |
| `scountinhibit` | `hpm15`  | `15`     | `s`           | `Inhibit counting for performance counter 15` |
| `scountinhibit` | `hpm16`  | `16`     | `s`           | `Inhibit counting for performance counter 16` |
| `scountinhibit` | `hpm17`  | `17`     | `s`           | `Inhibit counting for performance counter 17` |
| `scountinhibit` | `hpm18`  | `18`     | `s`           | `Inhibit counting for performance counter 18` |
| `scountinhibit` | `hpm19`  | `19`     | `s`           | `Inhibit counting for performance counter 19` |
| `scountinhibit` | `hpm20`  | `20`     | `s`           | `Inhibit counting for performance counter 20` |
| `scountinhibit` | `hpm21`  | `21`     | `s`           | `Inhibit counting for performance counter 21` |
| `scountinhibit` | `hpm22`  | `22`     | `s`           | `Inhibit counting for performance counter 22` |
| `scountinhibit` | `hpm23`  | `23`     | `s`           | `Inhibit counting for performance counter 23` |
| `scountinhibit` | `hpm24`  | `24`     | `s`           | `Inhibit counting for performance counter 24` |
| `scountinhibit` | `hpm25`  | `25`     | `s`           | `Inhibit counting for performance counter 25` |
| `scountinhibit` | `hpm26`  | `26`     | `s`           | `Inhibit counting for performance counter 26` |
| `scountinhibit` | `hpm27`  | `27`     | `s`           | `Inhibit counting for performance counter 27` |
| `scountinhibit` | `hpm28`  | `28`     | `s`           | `Inhibit counting for performance counter 28` |
| `scountinhibit` | `hpm29`  | `29`     | `s`           | `Inhibit counting for performance counter 29` |
| `scountinhibit` | `hpm30`  | `30`     | `s`           | `Inhibit counting for performance counter 30` |
| `scountinhibit` | `hpm31`  | `31`     | `s`           | `Inhibit counting for performance counter 31` |

:Supervisor Counter-Inhibit

| **CSR**    | **Name**   | **Bits**    | **Privilege** | **Description**          |
|:-----------|:-----------|:------------|:--------------|:-------------------------|
| `sscratch` | `sscratch` | `SXLEN-1:0` | `s`           | `Software scratch value` |

:Supervisor Scratch

| **CSR** | **Name** | **Bits**    | **Privilege** | **Description**             |
|:--------|:---------|:------------|:--------------|:----------------------------|
| `sepc`  | `sepc`   | `SXLEN-1:0` | `s`           | `Exception program counter` |

:Supervisor Exception Program Counter

| **CSR**  | **Name**         | **Bits**    | **Privilege** | **Description**       |
|:---------|:-----------------|:------------|:--------------|:----------------------|
| `scause` | `exception_code` | `SXLEN-2:0` | `s`           | `Trap cause code`     |
| `scause` | `interrupt`      | `SXLEN-1`   | `s`           | `Interrupt indicator` |

:Supervisor Trap Cause

| **CSR** | **Name** | **Bits**    | **Privilege** | **Description**                 |
|:--------|:---------|:------------|:--------------|:--------------------------------|
| `stval` | `stval`  | `SXLEN-1:0` | `s`           | `Exception-specific trap value` |

:Supervisor Trap Value

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                                      |
|:--------|:---------|:---------|:--------------|:-----------------------------------------------------|
| `sip`   | `ssip`   | `1`      | `s`           | `Supervisor software interrupt pending`              |
| `sip`   | `stip`   | `5`      | `s`           | `Supervisor timer interrupt pending`                 |
| `sip`   | `seip`   | `9`      | `s`           | `Supervisor external interrupt pending`              |
| `sip`   | `lcofip` | `13`     | `s`           | `Local counter-overflow (Sscofpm) interrupt pending` |

:Supervisor Interrupt Pending

| **CSR** | **Name**     | **Bits** | **Privilege** | **Description**                                                   |
|:--------|:-------------|:---------|:--------------|:------------------------------------------------------------------|
| `siph`  | `interrupts` | `31:0`   | `s`           | `Bits corresponding to interrupt identities 32 through 63 (RV32)` |

:Supervisor Interrupt Pending (Upper 32 Bits)

| **CSR**  | **Name**   | **Bits** | **Privilege** | **Description**                                                 |
|:---------|:-----------|:---------|:--------------|:----------------------------------------------------------------|
| `stopei` | `priority` | `10:0`   | `s`           | `Priority of the top external interrupt, equal to its identity` |
| `stopei` | `identity` | `26:16`  | `s`           | `Identity of the top external interrupt`                        |

:Supervisor Top External Interrupt

| **CSR**     | **Name** | **Bits** | **Privilege** | **Description**                              |
|:------------|:---------|:---------|:--------------|:---------------------------------------------|
| `scountovf` | `hpm3`   | `3`      | `s`           | `Overflow status for performance counter 3`  |
| `scountovf` | `hpm4`   | `4`      | `s`           | `Overflow status for performance counter 4`  |
| `scountovf` | `hpm5`   | `5`      | `s`           | `Overflow status for performance counter 5`  |
| `scountovf` | `hpm6`   | `6`      | `s`           | `Overflow status for performance counter 6`  |
| `scountovf` | `hpm7`   | `7`      | `s`           | `Overflow status for performance counter 7`  |
| `scountovf` | `hpm8`   | `8`      | `s`           | `Overflow status for performance counter 8`  |
| `scountovf` | `hpm9`   | `9`      | `s`           | `Overflow status for performance counter 9`  |
| `scountovf` | `hpm10`  | `10`     | `s`           | `Overflow status for performance counter 10` |
| `scountovf` | `hpm11`  | `11`     | `s`           | `Overflow status for performance counter 11` |
| `scountovf` | `hpm12`  | `12`     | `s`           | `Overflow status for performance counter 12` |
| `scountovf` | `hpm13`  | `13`     | `s`           | `Overflow status for performance counter 13` |
| `scountovf` | `hpm14`  | `14`     | `s`           | `Overflow status for performance counter 14` |
| `scountovf` | `hpm15`  | `15`     | `s`           | `Overflow status for performance counter 15` |
| `scountovf` | `hpm16`  | `16`     | `s`           | `Overflow status for performance counter 16` |
| `scountovf` | `hpm17`  | `17`     | `s`           | `Overflow status for performance counter 17` |
| `scountovf` | `hpm18`  | `18`     | `s`           | `Overflow status for performance counter 18` |
| `scountovf` | `hpm19`  | `19`     | `s`           | `Overflow status for performance counter 19` |
| `scountovf` | `hpm20`  | `20`     | `s`           | `Overflow status for performance counter 20` |
| `scountovf` | `hpm21`  | `21`     | `s`           | `Overflow status for performance counter 21` |
| `scountovf` | `hpm22`  | `22`     | `s`           | `Overflow status for performance counter 22` |
| `scountovf` | `hpm23`  | `23`     | `s`           | `Overflow status for performance counter 23` |
| `scountovf` | `hpm24`  | `24`     | `s`           | `Overflow status for performance counter 24` |
| `scountovf` | `hpm25`  | `25`     | `s`           | `Overflow status for performance counter 25` |
| `scountovf` | `hpm26`  | `26`     | `s`           | `Overflow status for performance counter 26` |
| `scountovf` | `hpm27`  | `27`     | `s`           | `Overflow status for performance counter 27` |
| `scountovf` | `hpm28`  | `28`     | `s`           | `Overflow status for performance counter 28` |
| `scountovf` | `hpm29`  | `29`     | `s`           | `Overflow status for performance counter 29` |
| `scountovf` | `hpm30`  | `30`     | `s`           | `Overflow status for performance counter 30` |
| `scountovf` | `hpm31`  | `31`     | `s`           | `Overflow status for performance counter 31` |

:Supervisor Count Overflow

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                                     |
|:--------|:---------|:---------|:--------------|:----------------------------------------------------|
| `stopi` | `iprio`  | `7:0`    | `s`           | `Priority of the top pending-and-enabled interrupt` |
| `stopi` | `iid`    | `27:16`  | `s`           | `Identity of the top pending-and-enabled interrupt` |

:Supervisor Top Interrupt

| **CSR**    | **Name** | **Bits**    | **Privilege** | **Description**              |
|:-----------|:---------|:------------|:--------------|:-----------------------------|
| `siselect` | `select` | `SXLEN-1:0` | `s`           | `Indirect register selector` |

:Supervisor Indirect Register Select

| **CSR**  | **Name** | **Bits**    | **Privilege** | **Description**                                                   |
|:---------|:---------|:------------|:--------------|:------------------------------------------------------------------|
| `sireg`  | `data`   | `SXLEN-1:0` | `s`           | `Field layout depends on the selector and the defining extension` |
| `sireg2` | `data`   | `SXLEN-1:0` | `s`           | `Field layout depends on the selector and the defining extension` |
| `sireg3` | `data`   | `SXLEN-1:0` | `s`           | `Field layout depends on the selector and the defining extension` |
| `sireg4` | `data`   | `SXLEN-1:0` | `s`           | `Field layout depends on the selector and the defining extension` |
| `sireg5` | `data`   | `SXLEN-1:0` | `s`           | `Field layout depends on the selector and the defining extension` |
| `sireg6` | `data`   | `SXLEN-1:0` | `s`           | `Field layout depends on the selector and the defining extension` |

:Supervisor Indirect Register Aliases

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                                     |
|:--------|:---------|:---------|:--------------|:----------------------------------------------------|
| `satp`  | `ppn`    | `21:0`   | `s`           | `Root page table physical page number (32-bit CSR)` |
| `satp`  | `asid`   | `30:22`  | `s`           | `Address space identifier (32-bit CSR)`             |
| `satp`  | `mode`   | `31`     | `s`           | `Address translation mode (32-bit CSR)`             |
| `satp`  | `ppn`    | `43:0`   | `s`           | `Root page table physical page number (64-bit CSR)` |
| `satp`  | `asid`   | `59:44`  | `s`           | `Address space identifier (64-bit CSR)`             |
| `satp`  | `mode`   | `63:60`  | `s`           | `Address translation mode (64-bit CSR)`             |

:Supervisor Address Translation and Protection

| **CSR**    | **Name** | **Bits** | **Privilege** | **Description**                                           |
|:-----------|:---------|:---------|:--------------|:----------------------------------------------------------|
| `stimecmp` | `value`  | `63:0`   | `s`           | `Supervisor timer compare value. RV32 uses the low half.` |

:Supervisor Timer Compare

| **CSR**     | **Name** | **Bits** | **Privilege** | **Description**                                     |
|:------------|:---------|:---------|:--------------|:----------------------------------------------------|
| `stimecmph` | `value`  | `31:0`   | `s`           | `Supervisor timer compare value, bits 63:32 (RV32)` |

:Supervisor Timer Compare (Upper 32 Bits)

| **CSR**    | **Name** | **Bits** | **Privilege** | **Description**                                                                          |
|:-----------|:---------|:---------|:--------------|:-----------------------------------------------------------------------------------------|
| `scontext` | `data`   | `31:0`   | `s`           | `Supervisor context value for trigger matching. Implementations may support fewer bits.` |

:Supervisor-Mode Context

| **CSR**  | **Name** | **Bits** | **Privilege** | **Description**                 |
|:---------|:---------|:---------|:--------------|:--------------------------------|
| `srmcfg` | `rcid`   | `11:0`   | `s`           | `Resource control identifier`   |
| `srmcfg` | `mcid`   | `27:16`  | `s`           | `Monitoring counter identifier` |

:Supervisor Resource Management Configuration

| **CSR**     | **Name**   | **Bits**    | **Privilege** | **Description**                              |
|:------------|:-----------|:------------|:--------------|:---------------------------------------------|
| `sstateen0` | `c`        | `0`         | `s`           | `Custom state access enable`                 |
| `sstateen0` | `fcsr`     | `1`         | `s`           | `Floating-point CSR access enable for Zfinx` |
| `sstateen0` | `jvt`      | `2`         | `s`           | `Jump vector table access enable`            |
| `sstateen1` | `reserved` | `SXLEN-1:0` | `s`           | `Reserved state-enable bits`                 |
| `sstateen2` | `reserved` | `SXLEN-1:0` | `s`           | `Reserved state-enable bits`                 |
| `sstateen3` | `reserved` | `SXLEN-1:0` | `s`           | `Reserved state-enable bits`                 |

:Supervisor State Enable Registers

| **CSR**   | **Name**     | **Bits** | **Privilege** | **Description**                                          |
|:----------|:-------------|:---------|:--------------|:---------------------------------------------------------|
| `sctrctl` | `u`          | `0`      | `s`           | `Enable recording in U-mode`                             |
| `sctrctl` | `s`          | `1`      | `s`           | `Enable recording in S-mode`                             |
| `sctrctl` | `rasemu`     | `7`      | `s`           | `Return-address stack emulation`                         |
| `sctrctl` | `ste`        | `8`      | `s`           | `Enable recording of traps to S-mode`                    |
| `sctrctl` | `bpfrz`      | `11`     | `s`           | `Freeze on a breakpoint exception`                       |
| `sctrctl` | `lcofifrz`   | `12`     | `s`           | `Freeze on a local counter-overflow interrupt`           |
| `sctrctl` | `excinh`     | `33`     | `s`           | `Inhibit exception recording`                            |
| `sctrctl` | `intrinh`    | `34`     | `s`           | `Inhibit interrupt recording`                            |
| `sctrctl` | `tretinh`    | `35`     | `s`           | `Inhibit trap-return recording`                          |
| `sctrctl` | `ntbren`     | `36`     | `s`           | `Enable recording of not-taken branches`                 |
| `sctrctl` | `tkbrinh`    | `37`     | `s`           | `Inhibit recording of taken branches`                    |
| `sctrctl` | `indcallinh` | `40`     | `s`           | `Inhibit recording of indirect calls`                    |
| `sctrctl` | `dircallinh` | `41`     | `s`           | `Inhibit recording of direct calls`                      |
| `sctrctl` | `indjmpinh`  | `42`     | `s`           | `Inhibit recording of indirect jumps`                    |
| `sctrctl` | `dirjmpinh`  | `43`     | `s`           | `Inhibit recording of direct jumps`                      |
| `sctrctl` | `corswapinh` | `44`     | `s`           | `Inhibit recording of coroutine swaps`                   |
| `sctrctl` | `retinh`     | `45`     | `s`           | `Inhibit recording of function returns`                  |
| `sctrctl` | `indljmpinh` | `46`     | `s`           | `Inhibit recording of other indirect jumps with linkage` |
| `sctrctl` | `dirljmpinh` | `47`     | `s`           | `Inhibit recording of other direct jumps with linkage`   |
| `sctrctl` | `custom`     | `63:60`  | `s`           | `Custom controls`                                        |

:Supervisor Control Transfer Records Control

| **CSR**      | **Name** | **Bits** | **Privilege** | **Description**                                |
|:-------------|:---------|:---------|:--------------|:-----------------------------------------------|
| `sctrstatus` | `wrptr`  | `7:0`    | `s`           | `Next physical CTR buffer entry to be written` |
| `sctrstatus` | `frozen` | `31`     | `s`           | `Inhibit transfer recording`                   |

:Supervisor Control Transfer Records Status

| **CSR**     | **Name** | **Bits** | **Privilege** | **Description**             |
|:------------|:---------|:---------|:--------------|:----------------------------|
| `sctrdepth` | `depth`  | `2:0`    | `s`           | `CTR buffer depth encoding` |

:Supervisor Control Transfer Records Depth
