## CONTROL AND STATUS REGISTER FIELDS

| **CSR** | **Name** | **Bits**   | **Privilege** | **Description**        |
|:--------|:---------|:-----------|:--------------|:-----------------------|
| `ssp`   | `ssp`    | `XLEN-1:0` | `u`           | `Shadow stack pointer` |

:Shadow Stack Pointer

| **CSR** | **Name**   | **Bits** | **Privilege** | **Description**                    |
|:--------|:-----------|:---------|:--------------|:-----------------------------------|
| `seed`  | `entropy`  | `15:0`   | `u`           | `Entropy sample when OPST is ES16` |
| `seed`  | `custom`   | `23:16`  | `u`           | `Custom or experimental use`       |
| `seed`  | `reserved` | `29:24`  | `u`           | `Reserved for future standard use` |
| `seed`  | `opst`     | `31:30`  | `u`           | `Entropy source status`            |

:Seed for Cryptographic Random Bit Generators

| **CSR** | **Name** | **Bits**   | **Privilege** | **Description**                |
|:--------|:---------|:-----------|:--------------|:-------------------------------|
| `jvt`   | `mode`   | `5:0`      | `u`           | `Jump table mode`              |
| `jvt`   | `base`   | `XLEN-1:6` | `u`           | `Jump table base address bits` |

:Table Jump Base Vector and Control

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                                 |
|:--------|:---------|:---------|:--------------|:------------------------------------------------|
| `cycle` | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |

:Cycle Counter for RDCYCLE Instruction

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                                 |
|:--------|:---------|:---------|:--------------|:------------------------------------------------|
| `time`  | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |

:Timer for RDTIME Instruction

| **CSR**   | **Name** | **Bits** | **Privilege** | **Description**                                 |
|:----------|:---------|:---------|:--------------|:------------------------------------------------|
| `instret` | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |

:Instructions-Retired Counter for RDINSTRET Instruction

| **CSR**        | **Name** | **Bits** | **Privilege** | **Description**                                 |
|:---------------|:---------|:---------|:--------------|:------------------------------------------------|
| `hpmcounter3`  | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter4`  | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter5`  | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter6`  | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter7`  | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter8`  | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter9`  | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter10` | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter11` | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter12` | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter13` | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter14` | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter15` | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter16` | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter17` | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter18` | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter19` | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter20` | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter21` | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter22` | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter23` | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter24` | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter25` | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter26` | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter27` | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter28` | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter29` | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter30` | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |
| `hpmcounter31` | `count`  | `63:0`   | `u`           | `64-bit counter value. RV32 uses the low half.` |

:Performance-Monitoring Counters

| **CSR**  | **Name** | **Bits** | **Privilege** | **Description**             |
|:---------|:---------|:---------|:--------------|:----------------------------|
| `cycleh` | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |

:Cycle Counter for RDCYCLE Instruction (Upper 32 Bits)

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**             |
|:--------|:---------|:---------|:--------------|:----------------------------|
| `timeh` | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |

:Timer for RDTIME Instruction (Upper 32 Bits)

| **CSR**    | **Name** | **Bits** | **Privilege** | **Description**             |
|:-----------|:---------|:---------|:--------------|:----------------------------|
| `instreth` | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |

:Instructions-Retired Counter for RDINSTRET Instruction (Upper 32 Bits)

| **CSR**         | **Name** | **Bits** | **Privilege** | **Description**             |
|:----------------|:---------|:---------|:--------------|:----------------------------|
| `hpmcounter3h`  | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter4h`  | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter5h`  | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter6h`  | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter7h`  | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter8h`  | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter9h`  | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter10h` | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter11h` | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter12h` | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter13h` | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter14h` | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter15h` | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter16h` | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter17h` | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter18h` | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter19h` | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter20h` | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter21h` | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter22h` | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter23h` | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter24h` | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter25h` | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter26h` | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter27h` | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter28h` | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter29h` | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter30h` | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |
| `hpmcounter31h` | `count`  | `31:0`   | `u`           | `Counter bits 63:32 (RV32)` |

:Performance-Monitoring Counters (Upper 32 Bits)
