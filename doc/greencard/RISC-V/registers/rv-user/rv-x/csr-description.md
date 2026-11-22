## CONTROL AND STATUS REGISTER DESCRIPTIONS

| **Number** | **Privilege** | **Name** | **Description**        |
|:-----------|:--------------|:---------|:-----------------------|
| `0x011`    | `urw`         | `ssp`    | `Shadow Stack Pointer` |

:Unprivileged Zicfiss Extension CSR

| **Number** | **Privilege** | **Name** | **Description**                                |
|:-----------|:--------------|:---------|:-----------------------------------------------|
| `0x015`    | `urw`         | `seed`   | `Seed for cryptographic random bit generators` |

:Unprivileged Zkr Extension CSR

| **Number** | **Privilege** | **Name** | **Description**                               |
|:-----------|:--------------|:---------|:----------------------------------------------|
| `0x017`    | `urw`         | `jvt`    | `Table jump base vector and control register` |

:Unprivileged Zcmt Extension CSR

| **Number** | **Privilege** | **Name**        | **Description**                                          |
|:-----------|:--------------|:----------------|:---------------------------------------------------------|
| `0xC00`    | `uro`         | `cycle`         | `Cycle counter for RDCYCLE instruction`                  |
| `0xC01`    | `uro`         | `time`          | `Timer for RDTIME instruction`                           |
| `0xC02`    | `uro`         | `instret`       | `Instructions-retired counter for RDINSTRET instruction` |
| `0xC03`    | `uro`         | `hpmcounter3`   | `Performance-monitoring counter`                         |
| `0xC04`    | `uro`         | `hpmcounter4`   | `Performance-monitoring counter`                         |
| `0xC05`    | `uro`         | `hpmcounter5`   | `Performance-monitoring counter`                         |
| `0xC06`    | `uro`         | `hpmcounter6`   | `Performance-monitoring counter`                         |
| `0xC07`    | `uro`         | `hpmcounter7`   | `Performance-monitoring counter`                         |
| `0xC08`    | `uro`         | `hpmcounter8`   | `Performance-monitoring counter`                         |
| `0xC09`    | `uro`         | `hpmcounter9`   | `Performance-monitoring counter`                         |
| `0xC0A`    | `uro`         | `hpmcounter10`  | `Performance-monitoring counter`                         |
| `0xC0B`    | `uro`         | `hpmcounter11`  | `Performance-monitoring counter`                         |
| `0xC0C`    | `uro`         | `hpmcounter12`  | `Performance-monitoring counter`                         |
| `0xC0D`    | `uro`         | `hpmcounter13`  | `Performance-monitoring counter`                         |
| `0xC0E`    | `uro`         | `hpmcounter14`  | `Performance-monitoring counter`                         |
| `0xC0F`    | `uro`         | `hpmcounter15`  | `Performance-monitoring counter`                         |
| `0xC10`    | `uro`         | `hpmcounter16`  | `Performance-monitoring counter`                         |
| `0xC11`    | `uro`         | `hpmcounter17`  | `Performance-monitoring counter`                         |
| `0xC12`    | `uro`         | `hpmcounter18`  | `Performance-monitoring counter`                         |
| `0xC13`    | `uro`         | `hpmcounter19`  | `Performance-monitoring counter`                         |
| `0xC14`    | `uro`         | `hpmcounter20`  | `Performance-monitoring counter`                         |
| `0xC15`    | `uro`         | `hpmcounter21`  | `Performance-monitoring counter`                         |
| `0xC16`    | `uro`         | `hpmcounter22`  | `Performance-monitoring counter`                         |
| `0xC17`    | `uro`         | `hpmcounter23`  | `Performance-monitoring counter`                         |
| `0xC18`    | `uro`         | `hpmcounter24`  | `Performance-monitoring counter`                         |
| `0xC19`    | `uro`         | `hpmcounter25`  | `Performance-monitoring counter`                         |
| `0xC1A`    | `uro`         | `hpmcounter26`  | `Performance-monitoring counter`                         |
| `0xC1B`    | `uro`         | `hpmcounter27`  | `Performance-monitoring counter`                         |
| `0xC1C`    | `uro`         | `hpmcounter28`  | `Performance-monitoring counter`                         |
| `0xC1D`    | `uro`         | `hpmcounter29`  | `Performance-monitoring counter`                         |
| `0xC1E`    | `uro`         | `hpmcounter30`  | `Performance-monitoring counter`                         |
| `0xC1F`    | `uro`         | `hpmcounter31`  | `Performance-monitoring counter`                         |
| `0xC80`    | `uro`         | `cycleh`        | `Upper 32 bits of cycle, RV32 only`                      |
| `0xC81`    | `uro`         | `timeh`         | `Upper 32 bits of time, RV32 only`                       |
| `0xC82`    | `uro`         | `instreth`      | `Upper 32 bits of instret, RV32 only`                    |
| `0xC83`    | `uro`         | `hpmcounter3h`  | `Upper 32 bits of hpmcounter3, RV32 only`                |
| `0xC84`    | `uro`         | `hpmcounter4h`  | `Upper 32 bits of hpmcounter4, RV32 only`                |
| `0xC85`    | `uro`         | `hpmcounter5h`  | `Upper 32 bits of hpmcounter5, RV32 only`                |
| `0xC86`    | `uro`         | `hpmcounter6h`  | `Upper 32 bits of hpmcounter6, RV32 only`                |
| `0xC87`    | `uro`         | `hpmcounter7h`  | `Upper 32 bits of hpmcounter7, RV32 only`                |
| `0xC88`    | `uro`         | `hpmcounter8h`  | `Upper 32 bits of hpmcounter8, RV32 only`                |
| `0xC89`    | `uro`         | `hpmcounter9h`  | `Upper 32 bits of hpmcounter9, RV32 only`                |
| `0xC8A`    | `uro`         | `hpmcounter10h` | `Upper 32 bits of hpmcounter10, RV32 only`               |
| `0xC8B`    | `uro`         | `hpmcounter11h` | `Upper 32 bits of hpmcounter11, RV32 only`               |
| `0xC8C`    | `uro`         | `hpmcounter12h` | `Upper 32 bits of hpmcounter12, RV32 only`               |
| `0xC8D`    | `uro`         | `hpmcounter13h` | `Upper 32 bits of hpmcounter13, RV32 only`               |
| `0xC8E`    | `uro`         | `hpmcounter14h` | `Upper 32 bits of hpmcounter14, RV32 only`               |
| `0xC8F`    | `uro`         | `hpmcounter15h` | `Upper 32 bits of hpmcounter15, RV32 only`               |
| `0xC90`    | `uro`         | `hpmcounter16h` | `Upper 32 bits of hpmcounter16, RV32 only`               |
| `0xC91`    | `uro`         | `hpmcounter17h` | `Upper 32 bits of hpmcounter17, RV32 only`               |
| `0xC92`    | `uro`         | `hpmcounter18h` | `Upper 32 bits of hpmcounter18, RV32 only`               |
| `0xC93`    | `uro`         | `hpmcounter19h` | `Upper 32 bits of hpmcounter19, RV32 only`               |
| `0xC94`    | `uro`         | `hpmcounter20h` | `Upper 32 bits of hpmcounter20, RV32 only`               |
| `0xC95`    | `uro`         | `hpmcounter21h` | `Upper 32 bits of hpmcounter21, RV32 only`               |
| `0xC96`    | `uro`         | `hpmcounter22h` | `Upper 32 bits of hpmcounter22, RV32 only`               |
| `0xC97`    | `uro`         | `hpmcounter23h` | `Upper 32 bits of hpmcounter23, RV32 only`               |
| `0xC98`    | `uro`         | `hpmcounter24h` | `Upper 32 bits of hpmcounter24, RV32 only`               |
| `0xC99`    | `uro`         | `hpmcounter25h` | `Upper 32 bits of hpmcounter25, RV32 only`               |
| `0xC9A`    | `uro`         | `hpmcounter26h` | `Upper 32 bits of hpmcounter26, RV32 only`               |
| `0xC9B`    | `uro`         | `hpmcounter27h` | `Upper 32 bits of hpmcounter27, RV32 only`               |
| `0xC9C`    | `uro`         | `hpmcounter28h` | `Upper 32 bits of hpmcounter28, RV32 only`               |
| `0xC9D`    | `uro`         | `hpmcounter29h` | `Upper 32 bits of hpmcounter29, RV32 only`               |
| `0xC9E`    | `uro`         | `hpmcounter30h` | `Upper 32 bits of hpmcounter30, RV32 only`               |
| `0xC9F`    | `uro`         | `hpmcounter31h` | `Upper 32 bits of hpmcounter31, RV32 only`               |

:User Timers and Counters