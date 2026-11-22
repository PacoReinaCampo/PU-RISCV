## CONTROL AND STATUS REGISTER DESCRIPTIONS

| **Number** | **Privilege** | **Name**     | **Description**                           |
|:-----------|:--------------|:-------------|:------------------------------------------|
| `0xF11`    | `mro`         | `mvendorid`  | `Vendor ID`                               |
| `0xF12`    | `mro`         | `marchid`    | `Architecture ID`                         |
| `0xF13`    | `mro`         | `mimpid`     | `Implementation ID`                       |
| `0xF14`    | `mro`         | `mhartid`    | `Hardware thread ID`                      |
| `0xF15`    | `mro`         | `mconfigptr` | `Pointer to configuration data structure` |

:Machine Information Registers

| **Number** | **Privilege** | **Name**     | **Description**                          |
|:-----------|:--------------|:-------------|:-----------------------------------------|
| `0x300`    | `mrw`         | `mstatus`    | `Machine status register`                |
| `0x301`    | `mrw`         | `misa`       | `ISA and extensions`                     |
| `0x302`    | `mrw`         | `medeleg`    | `Machine exception delegation register`  |
| `0x303`    | `mrw`         | `mideleg`    | `Machine interrupt delegation register`  |
| `0x304`    | `mrw`         | `mie`        | `Machine interrupt-enable register`      |
| `0x305`    | `mrw`         | `mtvec`      | `Machine trap-handler base address`      |
| `0x306`    | `mrw`         | `mcounteren` | `Machine counter enable`                 |
| `0x308`    | `mrw`         | `mvien`      | `Machine virtual interrupt enables`      |
| `0x309`    | `mrw`         | `mvip`       | `Machine virtual interrupt-pending bits` |
| `0x310`    | `mrw`         | `mstatush`   | `Upper 32 bits of mstatus, RV32 only`    |
| `0x312`    | `mrw`         | `medelegh`   | `Upper 32 bits of medeleg, RV32 only`    |
| `0x313`    | `mrw`         | `midelegh`   | `Upper 32 bits of mideleg, RV32 only`    |
| `0x314`    | `mrw`         | `mieh`       | `Upper 32 bits of mie, RV32 only`        |
| `0x318`    | `mrw`         | `mvienh`     | `Upper 32 bits of mvien, RV32 only`      |
| `0x319`    | `mrw`         | `mviph`      | `Upper 32 bits of mvip, RV32 only`       |

:Machine Trap Setup

| **Number** | **Privilege** | **Name**   | **Description**                          |
|:-----------|:--------------|:-----------|:-----------------------------------------|
| `0x340`    | `mrw`         | `mscratch` | `Machine scratch register`               |
| `0x341`    | `mrw`         | `mepc`     | `Machine exception program counter`      |
| `0x342`    | `mrw`         | `mcause`   | `Machine trap cause`                     |
| `0x343`    | `mrw`         | `mtval`    | `Machine trap value`                     |
| `0x344`    | `mrw`         | `mip`      | `Machine interrupt pending`              |
| `0x34A`    | `mrw`         | `mtinst`   | `Machine trap instruction (transformed)` |
| `0x34B`    | `mrw`         | `mtval2`   | `Machine second trap value`              |
| `0x354`    | `mrw`         | `miph`     | `Upper 32 bits of mip, RV32 only`        |
| `0x35C`    | `mrw`         | `mtopei`   | `Machine top external interrupt`         |
| `0xFB0`    | `mro`         | `mtopi`    | `Machine top interrupt`                  |

:Machine Trap Handling

| **Number** | **Privilege** | **Name**   | **Description**                     |
|:-----------|:--------------|:-----------|:------------------------------------|
| `0x350`    | `mrw`         | `miselect` | `Machine indirect register select`  |
| `0x351`    | `mrw`         | `mireg`    | `Machine indirect register alias`   |
| `0x352`    | `mrw`         | `mireg2`   | `Machine indirect register alias 2` |
| `0x353`    | `mrw`         | `mireg3`   | `Machine indirect register alias 3` |
| `0x355`    | `mrw`         | `mireg4`   | `Machine indirect register alias 4` |
| `0x356`    | `mrw`         | `mireg5`   | `Machine indirect register alias 5` |
| `0x357`    | `mrw`         | `mireg6`   | `Machine indirect register alias 6` |

:Machine Indirect

| **Number** | **Privilege** | **Name**   | **Description**                              |
|:-----------|:--------------|:-----------|:---------------------------------------------|
| `0x30A`    | `mrw`         | `menvcfg`  | `Machine environment configuration register` |
| `0x31A`    | `mrw`         | `menvcfgh` | `Upper 32 bits of menvcfg, RV32 only`        |
| `0x747`    | `mrw`         | `mseccfg`  | `Machine security configuration register`    |
| `0x757`    | `mrw`         | `mseccfgh` | `Upper 32 bits of mseccfg, RV32 only`        |

:Machine Configuration

| **Number** | **Privilege** | **Name**    | **Description**                                       |
|:-----------|:--------------|:------------|:------------------------------------------------------|
| `0x3A0`    | `mrw`         | `pmpcfg0`   | `Physical memory protection configuration`            |
| `0x3A1`    | `mrw`         | `pmpcfg1`   | `Physical memory protection configuration, RV32 only` |
| `0x3A2`    | `mrw`         | `pmpcfg2`   | `Physical memory protection configuration`            |
| `0x3A3`    | `mrw`         | `pmpcfg3`   | `Physical memory protection configuration, RV32 only` |
| `0x3A4`    | `mrw`         | `pmpcfg4`   | `Physical memory protection configuration`            |
| `0x3A5`    | `mrw`         | `pmpcfg5`   | `Physical memory protection configuration, RV32 only` |
| `0x3A6`    | `mrw`         | `pmpcfg6`   | `Physical memory protection configuration`            |
| `0x3A7`    | `mrw`         | `pmpcfg7`   | `Physical memory protection configuration, RV32 only` |
| `0x3A8`    | `mrw`         | `pmpcfg8`   | `Physical memory protection configuration`            |
| `0x3A9`    | `mrw`         | `pmpcfg9`   | `Physical memory protection configuration, RV32 only` |
| `0x3AA`    | `mrw`         | `pmpcfg10`  | `Physical memory protection configuration`            |
| `0x3AB`    | `mrw`         | `pmpcfg11`  | `Physical memory protection configuration, RV32 only` |
| `0x3AC`    | `mrw`         | `pmpcfg12`  | `Physical memory protection configuration`            |
| `0x3AD`    | `mrw`         | `pmpcfg13`  | `Physical memory protection configuration, RV32 only` |
| `0x3AE`    | `mrw`         | `pmpcfg14`  | `Physical memory protection configuration`            |
| `0x3AF`    | `mrw`         | `pmpcfg15`  | `Physical memory protection configuration, RV32 only` |
| `0x3B0`    | `mrw`         | `pmpaddr0`  | `Physical memory protection address register`         |
| `0x3B1`    | `mrw`         | `pmpaddr1`  | `Physical memory protection address register`         |
| `0x3B2`    | `mrw`         | `pmpaddr2`  | `Physical memory protection address register`         |
| `0x3B3`    | `mrw`         | `pmpaddr3`  | `Physical memory protection address register`         |
| `0x3B4`    | `mrw`         | `pmpaddr4`  | `Physical memory protection address register`         |
| `0x3B5`    | `mrw`         | `pmpaddr5`  | `Physical memory protection address register`         |
| `0x3B6`    | `mrw`         | `pmpaddr6`  | `Physical memory protection address register`         |
| `0x3B7`    | `mrw`         | `pmpaddr7`  | `Physical memory protection address register`         |
| `0x3B8`    | `mrw`         | `pmpaddr8`  | `Physical memory protection address register`         |
| `0x3B9`    | `mrw`         | `pmpaddr9`  | `Physical memory protection address register`         |
| `0x3BA`    | `mrw`         | `pmpaddr10` | `Physical memory protection address register`         |
| `0x3BB`    | `mrw`         | `pmpaddr11` | `Physical memory protection address register`         |
| `0x3BC`    | `mrw`         | `pmpaddr12` | `Physical memory protection address register`         |
| `0x3BD`    | `mrw`         | `pmpaddr13` | `Physical memory protection address register`         |
| `0x3BE`    | `mrw`         | `pmpaddr14` | `Physical memory protection address register`         |
| `0x3BF`    | `mrw`         | `pmpaddr15` | `Physical memory protection address register`         |
| `0x3C0`    | `mrw`         | `pmpaddr16` | `Physical memory protection address register`         |
| `0x3C1`    | `mrw`         | `pmpaddr17` | `Physical memory protection address register`         |
| `0x3C2`    | `mrw`         | `pmpaddr18` | `Physical memory protection address register`         |
| `0x3C3`    | `mrw`         | `pmpaddr19` | `Physical memory protection address register`         |
| `0x3C4`    | `mrw`         | `pmpaddr20` | `Physical memory protection address register`         |
| `0x3C5`    | `mrw`         | `pmpaddr21` | `Physical memory protection address register`         |
| `0x3C6`    | `mrw`         | `pmpaddr22` | `Physical memory protection address register`         |
| `0x3C7`    | `mrw`         | `pmpaddr23` | `Physical memory protection address register`         |
| `0x3C8`    | `mrw`         | `pmpaddr24` | `Physical memory protection address register`         |
| `0x3C9`    | `mrw`         | `pmpaddr25` | `Physical memory protection address register`         |
| `0x3CA`    | `mrw`         | `pmpaddr26` | `Physical memory protection address register`         |
| `0x3CB`    | `mrw`         | `pmpaddr27` | `Physical memory protection address register`         |
| `0x3CC`    | `mrw`         | `pmpaddr28` | `Physical memory protection address register`         |
| `0x3CD`    | `mrw`         | `pmpaddr29` | `Physical memory protection address register`         |
| `0x3CE`    | `mrw`         | `pmpaddr30` | `Physical memory protection address register`         |
| `0x3CF`    | `mrw`         | `pmpaddr31` | `Physical memory protection address register`         |
| `0x3D0`    | `mrw`         | `pmpaddr32` | `Physical memory protection address register`         |
| `0x3D1`    | `mrw`         | `pmpaddr33` | `Physical memory protection address register`         |
| `0x3D2`    | `mrw`         | `pmpaddr34` | `Physical memory protection address register`         |
| `0x3D3`    | `mrw`         | `pmpaddr35` | `Physical memory protection address register`         |
| `0x3D4`    | `mrw`         | `pmpaddr36` | `Physical memory protection address register`         |
| `0x3D5`    | `mrw`         | `pmpaddr37` | `Physical memory protection address register`         |
| `0x3D6`    | `mrw`         | `pmpaddr38` | `Physical memory protection address register`         |
| `0x3D7`    | `mrw`         | `pmpaddr39` | `Physical memory protection address register`         |
| `0x3D8`    | `mrw`         | `pmpaddr40` | `Physical memory protection address register`         |
| `0x3D9`    | `mrw`         | `pmpaddr41` | `Physical memory protection address register`         |
| `0x3DA`    | `mrw`         | `pmpaddr42` | `Physical memory protection address register`         |
| `0x3DB`    | `mrw`         | `pmpaddr43` | `Physical memory protection address register`         |
| `0x3DC`    | `mrw`         | `pmpaddr44` | `Physical memory protection address register`         |
| `0x3DD`    | `mrw`         | `pmpaddr45` | `Physical memory protection address register`         |
| `0x3DE`    | `mrw`         | `pmpaddr46` | `Physical memory protection address register`         |
| `0x3DF`    | `mrw`         | `pmpaddr47` | `Physical memory protection address register`         |
| `0x3E0`    | `mrw`         | `pmpaddr48` | `Physical memory protection address register`         |
| `0x3E1`    | `mrw`         | `pmpaddr49` | `Physical memory protection address register`         |
| `0x3E2`    | `mrw`         | `pmpaddr50` | `Physical memory protection address register`         |
| `0x3E3`    | `mrw`         | `pmpaddr51` | `Physical memory protection address register`         |
| `0x3E4`    | `mrw`         | `pmpaddr52` | `Physical memory protection address register`         |
| `0x3E5`    | `mrw`         | `pmpaddr53` | `Physical memory protection address register`         |
| `0x3E6`    | `mrw`         | `pmpaddr54` | `Physical memory protection address register`         |
| `0x3E7`    | `mrw`         | `pmpaddr55` | `Physical memory protection address register`         |
| `0x3E8`    | `mrw`         | `pmpaddr56` | `Physical memory protection address register`         |
| `0x3E9`    | `mrw`         | `pmpaddr57` | `Physical memory protection address register`         |
| `0x3EA`    | `mrw`         | `pmpaddr58` | `Physical memory protection address register`         |
| `0x3EB`    | `mrw`         | `pmpaddr59` | `Physical memory protection address register`         |
| `0x3EC`    | `mrw`         | `pmpaddr60` | `Physical memory protection address register`         |
| `0x3ED`    | `mrw`         | `pmpaddr61` | `Physical memory protection address register`         |
| `0x3EE`    | `mrw`         | `pmpaddr62` | `Physical memory protection address register`         |
| `0x3EF`    | `mrw`         | `pmpaddr63` | `Physical memory protection address register`         |

:Machine Memory Protection

| **Number** | **Privilege** | **Name**     | **Description**                                               |
|:-----------|:--------------|:-------------|:--------------------------------------------------------------|
| `0x30C`    | `mrw`         | `mstateen0`  | `Machine State Enable 0 Register`                             |
| `0x30D`    | `mrw`         | `mstateen1`  | `Machine State Enable 1 Register`                             |
| `0x30E`    | `mrw`         | `mstateen2`  | `Machine State Enable 2 Register`                             |
| `0x30F`    | `mrw`         | `mstateen3`  | `Machine State Enable 3 Register`                             |
| `0x31C`    | `mrw`         | `mstateen0h` | `Upper 32 bits of Machine State Enable 0 Register, RV32 only` |
| `0x31D`    | `mrw`         | `mstateen1h` | `Upper 32 bits of Machine State Enable 1 Register, RV32 only` |
| `0x31E`    | `mrw`         | `mstateen2h` | `Upper 32 bits of Machine State Enable 2 Register, RV32 only` |
| `0x31F`    | `mrw`         | `mstateen3h` | `Upper 32 bits of Machine State Enable 3 Register, RV32 only` |

:Machine State Enable Registers

| **Number** | **Privilege** | **Name**    | **Description**                  |
|:-----------|:--------------|:------------|:---------------------------------|
| `0x740`    | `mrw`         | `mnscratch` | `Resumable NMI scratch register` |
| `0x741`    | `mrw`         | `mnepc`     | `Resumable NMI program counter`  |
| `0x742`    | `mrw`         | `mncause`   | `Resumable NMI cause`            |
| `0x744`    | `mrw`         | `mnstatus`  | `Resumable NMI status`           |

:Machine Non-Maskable Interrupt Handling

| **Number** | **Privilege** | **Name**         | **Description**                             |
|:-----------|:--------------|:-----------------|:--------------------------------------------|
| `0xB00`    | `mrw`         | `mcycle`         | `Machine cycle counter`                     |
| `0xB02`    | `mrw`         | `minstret`       | `Machine instructions-retired counter`      |
| `0xB03`    | `mrw`         | `mhpmcounter3`   | `Machine performance-monitoring counter`    |
| `0xB04`    | `mrw`         | `mhpmcounter4`   | `Machine performance-monitoring counter`    |
| `0xB05`    | `mrw`         | `mhpmcounter5`   | `Machine performance-monitoring counter`    |
| `0xB06`    | `mrw`         | `mhpmcounter6`   | `Machine performance-monitoring counter`    |
| `0xB07`    | `mrw`         | `mhpmcounter7`   | `Machine performance-monitoring counter`    |
| `0xB08`    | `mrw`         | `mhpmcounter8`   | `Machine performance-monitoring counter`    |
| `0xB09`    | `mrw`         | `mhpmcounter9`   | `Machine performance-monitoring counter`    |
| `0xB0A`    | `mrw`         | `mhpmcounter10`  | `Machine performance-monitoring counter`    |
| `0xB0B`    | `mrw`         | `mhpmcounter11`  | `Machine performance-monitoring counter`    |
| `0xB0C`    | `mrw`         | `mhpmcounter12`  | `Machine performance-monitoring counter`    |
| `0xB0D`    | `mrw`         | `mhpmcounter13`  | `Machine performance-monitoring counter`    |
| `0xB0E`    | `mrw`         | `mhpmcounter14`  | `Machine performance-monitoring counter`    |
| `0xB0F`    | `mrw`         | `mhpmcounter15`  | `Machine performance-monitoring counter`    |
| `0xB10`    | `mrw`         | `mhpmcounter16`  | `Machine performance-monitoring counter`    |
| `0xB11`    | `mrw`         | `mhpmcounter17`  | `Machine performance-monitoring counter`    |
| `0xB12`    | `mrw`         | `mhpmcounter18`  | `Machine performance-monitoring counter`    |
| `0xB13`    | `mrw`         | `mhpmcounter19`  | `Machine performance-monitoring counter`    |
| `0xB14`    | `mrw`         | `mhpmcounter20`  | `Machine performance-monitoring counter`    |
| `0xB15`    | `mrw`         | `mhpmcounter21`  | `Machine performance-monitoring counter`    |
| `0xB16`    | `mrw`         | `mhpmcounter22`  | `Machine performance-monitoring counter`    |
| `0xB17`    | `mrw`         | `mhpmcounter23`  | `Machine performance-monitoring counter`    |
| `0xB18`    | `mrw`         | `mhpmcounter24`  | `Machine performance-monitoring counter`    |
| `0xB19`    | `mrw`         | `mhpmcounter25`  | `Machine performance-monitoring counter`    |
| `0xB1A`    | `mrw`         | `mhpmcounter26`  | `Machine performance-monitoring counter`    |
| `0xB1B`    | `mrw`         | `mhpmcounter27`  | `Machine performance-monitoring counter`    |
| `0xB1C`    | `mrw`         | `mhpmcounter28`  | `Machine performance-monitoring counter`    |
| `0xB1D`    | `mrw`         | `mhpmcounter29`  | `Machine performance-monitoring counter`    |
| `0xB1E`    | `mrw`         | `mhpmcounter30`  | `Machine performance-monitoring counter`    |
| `0xB1F`    | `mrw`         | `mhpmcounter31`  | `Machine performance-monitoring counter`    |
| `0xB80`    | `mrw`         | `mcycleh`        | `Upper 32 bits of mcycle, RV32 only`        |
| `0xB82`    | `mrw`         | `minstreth`      | `Upper 32 bits of minstret, RV32 only`      |
| `0xB83`    | `mrw`         | `mhpmcounter3h`  | `Upper 32 bits of mhpmcounter3, RV32 only`  |
| `0xB84`    | `mrw`         | `mhpmcounter4h`  | `Upper 32 bits of mhpmcounter4, RV32 only`  |
| `0xB85`    | `mrw`         | `mhpmcounter5h`  | `Upper 32 bits of mhpmcounter5, RV32 only`  |
| `0xB86`    | `mrw`         | `mhpmcounter6h`  | `Upper 32 bits of mhpmcounter6, RV32 only`  |
| `0xB87`    | `mrw`         | `mhpmcounter7h`  | `Upper 32 bits of mhpmcounter7, RV32 only`  |
| `0xB88`    | `mrw`         | `mhpmcounter8h`  | `Upper 32 bits of mhpmcounter8, RV32 only`  |
| `0xB89`    | `mrw`         | `mhpmcounter9h`  | `Upper 32 bits of mhpmcounter9, RV32 only`  |
| `0xB8A`    | `mrw`         | `mhpmcounter10h` | `Upper 32 bits of mhpmcounter10, RV32 only` |
| `0xB8B`    | `mrw`         | `mhpmcounter11h` | `Upper 32 bits of mhpmcounter11, RV32 only` |
| `0xB8C`    | `mrw`         | `mhpmcounter12h` | `Upper 32 bits of mhpmcounter12, RV32 only` |
| `0xB8D`    | `mrw`         | `mhpmcounter13h` | `Upper 32 bits of mhpmcounter13, RV32 only` |
| `0xB8E`    | `mrw`         | `mhpmcounter14h` | `Upper 32 bits of mhpmcounter14, RV32 only` |
| `0xB8F`    | `mrw`         | `mhpmcounter15h` | `Upper 32 bits of mhpmcounter15, RV32 only` |
| `0xB90`    | `mrw`         | `mhpmcounter16h` | `Upper 32 bits of mhpmcounter16, RV32 only` |
| `0xB91`    | `mrw`         | `mhpmcounter17h` | `Upper 32 bits of mhpmcounter17, RV32 only` |
| `0xB92`    | `mrw`         | `mhpmcounter18h` | `Upper 32 bits of mhpmcounter18, RV32 only` |
| `0xB93`    | `mrw`         | `mhpmcounter19h` | `Upper 32 bits of mhpmcounter19, RV32 only` |
| `0xB94`    | `mrw`         | `mhpmcounter20h` | `Upper 32 bits of mhpmcounter20, RV32 only` |
| `0xB95`    | `mrw`         | `mhpmcounter21h` | `Upper 32 bits of mhpmcounter21, RV32 only` |
| `0xB96`    | `mrw`         | `mhpmcounter22h` | `Upper 32 bits of mhpmcounter22, RV32 only` |
| `0xB97`    | `mrw`         | `mhpmcounter23h` | `Upper 32 bits of mhpmcounter23, RV32 only` |
| `0xB98`    | `mrw`         | `mhpmcounter24h` | `Upper 32 bits of mhpmcounter24, RV32 only` |
| `0xB99`    | `mrw`         | `mhpmcounter25h` | `Upper 32 bits of mhpmcounter25, RV32 only` |
| `0xB9A`    | `mrw`         | `mhpmcounter26h` | `Upper 32 bits of mhpmcounter26, RV32 only` |
| `0xB9B`    | `mrw`         | `mhpmcounter27h` | `Upper 32 bits of mhpmcounter27, RV32 only` |
| `0xB9C`    | `mrw`         | `mhpmcounter28h` | `Upper 32 bits of mhpmcounter28, RV32 only` |
| `0xB9D`    | `mrw`         | `mhpmcounter29h` | `Upper 32 bits of mhpmcounter29, RV32 only` |
| `0xB9E`    | `mrw`         | `mhpmcounter30h` | `Upper 32 bits of mhpmcounter30, RV32 only` |
| `0xB9F`    | `mrw`         | `mhpmcounter31h` | `Upper 32 bits of mhpmcounter31, RV32 only` |

:Machine Counters / Timers

| **Number** | **Privilege** | **Name**        | **Description**                                  |
|:-----------|:--------------|:----------------|:-------------------------------------------------|
| `0x320`    | `mrw`         | `mcountinhibit` | `Machine counter-inhibit register`               |
| `0x321`    | `mrw`         | `mcyclecfg`     | `Machine cycle counter configuration register`   |
| `0x322`    | `mrw`         | `minstretcfg`   | `Machine instret counter configuration register` |
| `0x323`    | `mrw`         | `mhpmevent3`    | `Machine performance-monitoring event selector`  |
| `0x324`    | `mrw`         | `mhpmevent4`    | `Machine performance-monitoring event selector`  |
| `0x325`    | `mrw`         | `mhpmevent5`    | `Machine performance-monitoring event selector`  |
| `0x326`    | `mrw`         | `mhpmevent6`    | `Machine performance-monitoring event selector`  |
| `0x327`    | `mrw`         | `mhpmevent7`    | `Machine performance-monitoring event selector`  |
| `0x328`    | `mrw`         | `mhpmevent8`    | `Machine performance-monitoring event selector`  |
| `0x329`    | `mrw`         | `mhpmevent9`    | `Machine performance-monitoring event selector`  |
| `0x32A`    | `mrw`         | `mhpmevent10`   | `Machine performance-monitoring event selector`  |
| `0x32B`    | `mrw`         | `mhpmevent11`   | `Machine performance-monitoring event selector`  |
| `0x32C`    | `mrw`         | `mhpmevent12`   | `Machine performance-monitoring event selector`  |
| `0x32D`    | `mrw`         | `mhpmevent13`   | `Machine performance-monitoring event selector`  |
| `0x32E`    | `mrw`         | `mhpmevent14`   | `Machine performance-monitoring event selector`  |
| `0x32F`    | `mrw`         | `mhpmevent15`   | `Machine performance-monitoring event selector`  |
| `0x330`    | `mrw`         | `mhpmevent16`   | `Machine performance-monitoring event selector`  |
| `0x331`    | `mrw`         | `mhpmevent17`   | `Machine performance-monitoring event selector`  |
| `0x332`    | `mrw`         | `mhpmevent18`   | `Machine performance-monitoring event selector`  |
| `0x333`    | `mrw`         | `mhpmevent19`   | `Machine performance-monitoring event selector`  |
| `0x334`    | `mrw`         | `mhpmevent20`   | `Machine performance-monitoring event selector`  |
| `0x335`    | `mrw`         | `mhpmevent21`   | `Machine performance-monitoring event selector`  |
| `0x336`    | `mrw`         | `mhpmevent22`   | `Machine performance-monitoring event selector`  |
| `0x337`    | `mrw`         | `mhpmevent23`   | `Machine performance-monitoring event selector`  |
| `0x338`    | `mrw`         | `mhpmevent24`   | `Machine performance-monitoring event selector`  |
| `0x339`    | `mrw`         | `mhpmevent25`   | `Machine performance-monitoring event selector`  |
| `0x33A`    | `mrw`         | `mhpmevent26`   | `Machine performance-monitoring event selector`  |
| `0x33B`    | `mrw`         | `mhpmevent27`   | `Machine performance-monitoring event selector`  |
| `0x33C`    | `mrw`         | `mhpmevent28`   | `Machine performance-monitoring event selector`  |
| `0x33D`    | `mrw`         | `mhpmevent29`   | `Machine performance-monitoring event selector`  |
| `0x33E`    | `mrw`         | `mhpmevent30`   | `Machine performance-monitoring event selector`  |
| `0x33F`    | `mrw`         | `mhpmevent31`   | `Machine performance-monitoring event selector`  |
| `0x721`    | `mrw`         | `mcyclecfgh`    | `Upper 32 bits of mcyclecfg, RV32 only`          |
| `0x722`    | `mrw`         | `minstretcfgh`  | `Upper 32 bits of minstretcfg, RV32 only`        |
| `0x723`    | `mrw`         | `mhpmevent3h`   | `Upper 32 bits of mhpmevent3, RV32 only`         |
| `0x724`    | `mrw`         | `mhpmevent4h`   | `Upper 32 bits of mhpmevent4, RV32 only`         |
| `0x725`    | `mrw`         | `mhpmevent5h`   | `Upper 32 bits of mhpmevent5, RV32 only`         |
| `0x726`    | `mrw`         | `mhpmevent6h`   | `Upper 32 bits of mhpmevent6, RV32 only`         |
| `0x727`    | `mrw`         | `mhpmevent7h`   | `Upper 32 bits of mhpmevent7, RV32 only`         |
| `0x728`    | `mrw`         | `mhpmevent8h`   | `Upper 32 bits of mhpmevent8, RV32 only`         |
| `0x729`    | `mrw`         | `mhpmevent9h`   | `Upper 32 bits of mhpmevent9, RV32 only`         |
| `0x72A`    | `mrw`         | `mhpmevent10h`  | `Upper 32 bits of mhpmevent10, RV32 only`        |
| `0x72B`    | `mrw`         | `mhpmevent11h`  | `Upper 32 bits of mhpmevent11, RV32 only`        |
| `0x72C`    | `mrw`         | `mhpmevent12h`  | `Upper 32 bits of mhpmevent12, RV32 only`        |
| `0x72D`    | `mrw`         | `mhpmevent13h`  | `Upper 32 bits of mhpmevent13, RV32 only`        |
| `0x72E`    | `mrw`         | `mhpmevent14h`  | `Upper 32 bits of mhpmevent14, RV32 only`        |
| `0x72F`    | `mrw`         | `mhpmevent15h`  | `Upper 32 bits of mhpmevent15, RV32 only`        |
| `0x730`    | `mrw`         | `mhpmevent16h`  | `Upper 32 bits of mhpmevent16, RV32 only`        |
| `0x731`    | `mrw`         | `mhpmevent17h`  | `Upper 32 bits of mhpmevent17, RV32 only`        |
| `0x732`    | `mrw`         | `mhpmevent18h`  | `Upper 32 bits of mhpmevent18, RV32 only`        |
| `0x733`    | `mrw`         | `mhpmevent19h`  | `Upper 32 bits of mhpmevent19, RV32 only`        |
| `0x734`    | `mrw`         | `mhpmevent20h`  | `Upper 32 bits of mhpmevent20, RV32 only`        |
| `0x735`    | `mrw`         | `mhpmevent21h`  | `Upper 32 bits of mhpmevent21, RV32 only`        |
| `0x736`    | `mrw`         | `mhpmevent22h`  | `Upper 32 bits of mhpmevent22, RV32 only`        |
| `0x737`    | `mrw`         | `mhpmevent23h`  | `Upper 32 bits of mhpmevent23, RV32 only`        |
| `0x738`    | `mrw`         | `mhpmevent24h`  | `Upper 32 bits of mhpmevent24, RV32 only`        |
| `0x739`    | `mrw`         | `mhpmevent25h`  | `Upper 32 bits of mhpmevent25, RV32 only`        |
| `0x73A`    | `mrw`         | `mhpmevent26h`  | `Upper 32 bits of mhpmevent26, RV32 only`        |
| `0x73B`    | `mrw`         | `mhpmevent27h`  | `Upper 32 bits of mhpmevent27, RV32 only`        |
| `0x73C`    | `mrw`         | `mhpmevent28h`  | `Upper 32 bits of mhpmevent28, RV32 only`        |
| `0x73D`    | `mrw`         | `mhpmevent29h`  | `Upper 32 bits of mhpmevent29, RV32 only`        |
| `0x73E`    | `mrw`         | `mhpmevent30h`  | `Upper 32 bits of mhpmevent30, RV32 only`        |
| `0x73F`    | `mrw`         | `mhpmevent31h`  | `Upper 32 bits of mhpmevent31, RV32 only`        |

:Machine Counter Setup

| **Number** | **Privilege** | **Name**  | **Description**                                     |
|:-----------|:--------------|:----------|:----------------------------------------------------|
| `0x34E`    | `mrw`         | `mctrctl` | `Machine Control Transfer Records Control Register` |

:Machine Control Transfer Records Configuration

| **Number** | **Privilege** | **Name**   | **Description**                            |
|:-----------|:--------------|:-----------|:-------------------------------------------|
| `0x7A0`    | `mrw`         | `tselect`  | `Debug/Trace trigger register select`      |
| `0x7A1`    | `mrw`         | `tdata1`   | `First Debug/Trace trigger data register`  |
| `0x7A2`    | `mrw`         | `tdata2`   | `Second Debug/Trace trigger data register` |
| `0x7A3`    | `mrw`         | `tdata3`   | `Third Debug/Trace trigger data register`  |
| `0x7A4`    | `mrw`         | `tinfo`    | `Trigger info register`                    |
| `0x7A5`    | `mrw`         | `tcontrol` | `Trigger control register`                 |
| `0x7A8`    | `mrw`         | `mcontext` | `Machine-mode context register`            |

:Debug/Trace Registers (shared with Debug Mode)

| **Number** | **Privilege** | **Name**    | **Description**                     |
|:-----------|:--------------|:------------|:------------------------------------|
| `0x7B0`    | `drw`         | `dcsr`      | `Debug control and status register` |
| `0x7B1`    | `drw`         | `dpc`       | `Debug program counter`             |
| `0x7B2`    | `drw`         | `dscratch0` | `Debug scratch register 0`          |
| `0x7B3`    | `drw`         | `dscratch1` | `Debug scratch register 1`          |

:Debug Mode Registers