# RV-USER

## RV-X

### DESIGN OF REGISTERS

| **File**          | **Description**                            |
|:------------------|:-------------------------------------------|
| `gpr-description` | `General Purpose Register Descriptions`    |
| `gpr-field`       | `General Purpose Register Fields`          |
| `csr-description` | `Control and Status Register Descriptions` |
| `csr-field`       | `Control and Status Register Fields`       |

:Register Directory

### GENERAL PURPOSE REGISTER DESCRIPTIONS

| **Integer Register Number** | **Integer Register ABI Name** | **Type** | **Save** | **Description**                       |
|:----------------------------|:------------------------------|:---------|:---------|:--------------------------------------|
| `x0`                        | `zero`                        | `ireg`   | `zero`   | `Hard-wired zero`                     |
| `x1`                        | `ra`                          | `ireg`   | `caller` | `Return address Caller`               |
| `x2`                        | `sp`                          | `ireg`   | `callee` | `Stack pointer Callee`                |
| `x3`                        | `gp`                          | `ireg`   | `global` | `Global pointer`                      |
| `x4`                        | `tp`                          | `ireg`   | `global` | `Thread pointer`                      |
| `x5`                        | `t0`                          | `ireg`   | `caller` | `Temporaries Caller`                  |
| `x6`                        | `t1`                          | `ireg`   | `caller` | `Temporaries Caller`                  |
| `x7`                        | `t2`                          | `ireg`   | `caller` | `Temporaries Caller`                  |
| `x8`                        | `s0`                          | `ireg`   | `callee` | `Saved register/frame pointer Callee` |
| `x9`                        | `s1`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x10`                       | `a0`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x11`                       | `a1`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x12`                       | `a2`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x13`                       | `a3`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x14`                       | `a4`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x15`                       | `a5`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x16`                       | `a6`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x17`                       | `a7`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x18`                       | `s2`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x19`                       | `s3`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x20`                       | `s4`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x21`                       | `s5`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x22`                       | `s6`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x23`                       | `s7`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x24`                       | `s8`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x25`                       | `s9`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x26`                       | `s10`                         | `ireg`   | `callee` | `Saved registers Callee`              |
| `x27`                       | `s11`                         | `ireg`   | `callee` | `Saved registers Callee`              |
| `x28`                       | `t3`                          | `ireg`   | `caller` | `Temporaries Caller`                  |
| `x29`                       | `t4`                          | `ireg`   | `caller` | `Temporaries Caller`                  |
| `x30`                       | `t5`                          | `ireg`   | `caller` | `Temporaries Caller`                  |
| `x31`                       | `t6`                          | `ireg`   | `caller` | `Temporaries Caller`                  |

:Integer Base Registers

### GENERAL PURPOSE REGISTER FIELDS

| **Register** | **Name** | **Bits**   | **Description**          |
|:-------------|:---------|:-----------|:-------------------------|
| `x0`         | `zero`   | `XLEN-1:0` | `Hard-wired to zero`     |
| `x1`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x2`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x3`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x4`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x5`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x6`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x7`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x8`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x9`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x10`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x11`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x12`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x13`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x14`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x15`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x16`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x17`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x18`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x19`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x20`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x21`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x22`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x23`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x24`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x25`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x26`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x27`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x28`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x29`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x30`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x31`        | `value`  | `XLEN-1:0` | `Integer register value` |

:General Purpose Integer Register Fields

### CONTROL AND STATUS REGISTER DESCRIPTIONS

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

### CONTROL AND STATUS REGISTER FIELDS

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

## RV-F

### DESIGN OF REGISTERS

| **File**          | **Description**                            |
|:------------------|:-------------------------------------------|
| `gpr-description` | `General Purpose Register Descriptions`    |
| `gpr-field`       | `General Purpose Register Fields`          |
| `csr-description` | `Control and Status Register Descriptions` |
| `csr-field`       | `Control and Status Register Fields`       |

:Register Directory

### GENERAL PURPOSE REGISTER DESCRIPTIONS

| **Floating-Point Register Number** | **Floating-Point Register ABI Name** | **Type** | **Save** | **Description**             |
|:-----------------------------------|:-------------------------------------|:---------|:---------|:----------------------------|
| `f0`                               | `ft0`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f1`                               | `ft1`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f2`                               | `ft2`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f3`                               | `ft3`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f4`                               | `ft4`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f5`                               | `ft5`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f6`                               | `ft6`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f7`                               | `ft7`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f8`                               | `fs0`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f9`                               | `fs1`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f10`                              | `fa0`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f11`                              | `fa1`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f12`                              | `fa2`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f13`                              | `fa3`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f14`                              | `fa4`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f15`                              | `fa5`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f16`                              | `fa6`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f17`                              | `fa7`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f18`                              | `fs2`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f19`                              | `fs3`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f20`                              | `fs4`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f21`                              | `fs5`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f22`                              | `fs6`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f23`                              | `fs7`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f24`                              | `fs8`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f25`                              | `fs9`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f26`                              | `fs10`                               | `freg`   | `callee` | `FP saved registers Callee` |
| `f27`                              | `fs11`                               | `freg`   | `callee` | `FP saved registers Callee` |
| `f28`                              | `ft8`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f29`                              | `ft9`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f30`                              | `ft10`                               | `freg`   | `caller` | `FP temporaries Caller`     |
| `f31`                              | `ft11`                               | `freg`   | `caller` | `FP temporaries Caller`     |

:Floating-Point Extension Registers

### GENERAL PURPOSE REGISTER FIELDS

| **Register** | **Name** | **Bits**   | **Description**                                                                                   |
|:-------------|:---------|:-----------|:--------------------------------------------------------------------------------------------------|
| `f0`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f1`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f2`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f3`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f4`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f5`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f6`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f7`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f8`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f9`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f10`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f11`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f12`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f13`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f14`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f15`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f16`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f17`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f18`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f19`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f20`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f21`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f22`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f23`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f24`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f25`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f26`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f27`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f28`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f29`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f30`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f31`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |

:General Purpose Floating-Point Register Fields

### CONTROL AND STATUS REGISTER DESCRIPTIONS

| **Number** | **Privilege** | **Name** | **Description**                                             |
|:-----------|:--------------|:---------|:------------------------------------------------------------|
| `0x001`    | `urw`         | `fflags` | `Floating-Point Accrued Exceptions`                         |
| `0x002`    | `urw`         | `frm`    | `Floating-Point Dynamic Rounding Mode`                      |
| `0x003`    | `urw`         | `fcsr`   | `Floating-Point Control and Status Register (frm + fflags)` |

:User Floating-Point CSRs

### CONTROL AND STATUS REGISTER FIELDS

| **CSR**  | **Name** | **Bits** | **Privilege** | **Description**     |
|:---------|:---------|:---------|:--------------|:--------------------|
| `fflags` | `nx`     | `0`      | `u`           | `Inexact`           |
| `fflags` | `uf`     | `1`      | `u`           | `Underflow`         |
| `fflags` | `of`     | `2`      | `u`           | `Overflow`          |
| `fflags` | `dz`     | `3`      | `u`           | `Divide by zero`    |
| `fflags` | `nv`     | `4`      | `u`           | `Invalid operation` |

:Floating-Point Accrued Exceptions

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**         |
|:--------|:---------|:---------|:--------------|:------------------------|
| `frm`   | `frm`    | `2:0`    | `u`           | `Dynamic rounding mode` |

:Floating-Point Dynamic Rounding Mode

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**         |
|:--------|:---------|:---------|:--------------|:------------------------|
| `fcsr`  | `nx`     | `0`      | `u`           | `Inexact`               |
| `fcsr`  | `uf`     | `1`      | `u`           | `Underflow`             |
| `fcsr`  | `of`     | `2`      | `u`           | `Overflow`              |
| `fcsr`  | `dz`     | `3`      | `u`           | `Divide by zero`        |
| `fcsr`  | `nv`     | `4`      | `u`           | `Invalid operation`     |
| `fcsr`  | `frm`    | `7:5`    | `u`           | `Dynamic rounding mode` |

:Floating-Point Control and Status

## RV-V

### DESIGN OF REGISTERS

| **File**          | **Description**                            |
|:------------------|:-------------------------------------------|
| `gpr-description` | `General Purpose Register Descriptions`    |
| `gpr-field`       | `General Purpose Register Fields`          |
| `csr-description` | `Control and Status Register Descriptions` |
| `csr-field`       | `Control and Status Register Fields`       |

:Register Directory

### GENERAL PURPOSE REGISTER DESCRIPTIONS

| **Name** | **Alias** | **Type** | **Save** | **Description**          |
|:---------|:----------|:---------|:---------|:-------------------------|
| `v0`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v1`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v2`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v3`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v4`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v5`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v6`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v7`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v8`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v9`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v10`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v11`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v12`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v13`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v14`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v15`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v16`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v17`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v18`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v19`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v20`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v21`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v22`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v23`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v24`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v25`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v26`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v27`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v28`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v29`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v30`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v31`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |

:Vector Extension Registers

### GENERAL PURPOSE REGISTER FIELDS

| **Register** | **Name** | **Bits**   | **Description**                                                                                    |
|:-------------|:---------|:-----------|:---------------------------------------------------------------------------------------------------|
| `v0`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v1`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v2`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v3`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v4`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v5`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v6`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v7`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v8`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v9`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v10`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v11`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v12`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v13`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v14`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v15`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v16`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v17`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v18`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v19`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v20`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v21`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v22`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v23`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v24`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v25`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v26`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v27`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v28`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v29`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v30`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v31`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |

:General Purpose Vector Register Fields

### CONTROL AND STATUS REGISTER DESCRIPTIONS

| **Number** | **Privilege** | **Name** | **Description**                       |
|:-----------|:--------------|:---------|:--------------------------------------|
| `0x008`    | `urw`         | `vstart` | `Vector start position`               |
| `0x009`    | `urw`         | `vxsat`  | `Fixed-point accrued saturation flag` |
| `0x00A`    | `urw`         | `vxrm`   | `Fixed-point rounding mode`           |
| `0x00F`    | `urw`         | `vcsr`   | `Vector control and status register`  |
| `0xC20`    | `uro`         | `vl`     | `Vector length`                       |
| `0xC21`    | `uro`         | `vtype`  | `Vector data type register`           |
| `0xC22`    | `uro`         | `vlenb`  | `Vector register length in bytes`     |

:Unprivileged Vector CSRs

### CONTROL AND STATUS REGISTER FIELDS

| **CSR**  | **Name** | **Bits**   | **Privilege** | **Description**                                                                           |
|:---------|:---------|:-----------|:--------------|:------------------------------------------------------------------------------------------|
| `vstart` | `vstart` | `XLEN-1:0` | `u`           | `Vector start element index. Only bits needed to represent VLMAX minus one are writable.` |

:Vector Start Position

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                       |
|:--------|:---------|:---------|:--------------|:--------------------------------------|
| `vxsat` | `vxsat`  | `0`      | `u`           | `Fixed-point accrued saturation flag` |

:Fixed-Point Accrued Saturation Flag

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**             |
|:--------|:---------|:---------|:--------------|:----------------------------|
| `vxrm`  | `vxrm`   | `1:0`    | `u`           | `Fixed-point rounding mode` |

:Fixed-Point Rounding Mode

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                       |
|:--------|:---------|:---------|:--------------|:--------------------------------------|
| `vcsr`  | `vxsat`  | `0`      | `u`           | `Fixed-point accrued saturation flag` |
| `vcsr`  | `vxrm`   | `2:1`    | `u`           | `Fixed-point rounding mode`           |

:Vector Control and Status

| **CSR** | **Name** | **Bits**   | **Privilege** | **Description**                    |
|:--------|:---------|:-----------|:--------------|:-----------------------------------|
| `vl`    | `vl`     | `XLEN-1:0` | `u`           | `Active vector length in elements` |

:Vector Length

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                             |
|:--------|:---------|:---------|:--------------|:--------------------------------------------|
| `vtype` | `vlmul`  | `2:0`    | `u`           | `Vector register group multiplier encoding` |
| `vtype` | `vsew`   | `5:3`    | `u`           | `Selected element width encoding`           |
| `vtype` | `vta`    | `6`      | `u`           | `Tail agnostic policy`                      |
| `vtype` | `vma`    | `7`      | `u`           | `Mask agnostic policy`                      |
| `vtype` | `vill`   | `XLEN-1` | `u`           | `Illegal vector type`                       |

:Vector Data Type

| **CSR** | **Name** | **Bits**   | **Privilege** | **Description**                   |
|:--------|:---------|:-----------|:--------------|:----------------------------------|
| `vlenb` | `vlenb`  | `XLEN-1:0` | `u`           | `Vector register length in bytes` |

:Vector Register Length in Bytes

## RV-W

### DESIGN OF REGISTERS

| **File**          | **Description**                            |
|:------------------|:-------------------------------------------|
| `gpr-description` | `General Purpose Register Descriptions`    |
| `gpr-field`       | `General Purpose Register Fields`          |
| `csr-description` | `Control and Status Register Descriptions` |
| `csr-field`       | `Control and Status Register Fields`       |

:Register Directory

### GENERAL PURPOSE REGISTER DESCRIPTIONS

| **Name** | **Alias** | **Type** | **Save** | **Description**          |
|:---------|:----------|:---------|:---------|:-------------------------|
| `w0`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w1`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w2`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w3`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w4`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w5`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w6`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w7`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w8`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w9`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w10`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w11`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w12`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w13`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w14`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w15`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w16`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w17`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w18`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w19`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w20`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w21`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w22`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w23`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w24`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w25`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w26`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w27`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w28`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w29`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w30`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w31`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |

:Matrix Extension Registers

### GENERAL PURPOSE REGISTER FIELDS

| **Register** | **Name** | **Bits**   | **Description**            |
|:-------------|:---------|:-----------|:---------------------------|
| `w0`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w1`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w2`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w3`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w4`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w5`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w6`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w7`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w8`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w9`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w10`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w11`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w12`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w13`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w14`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w15`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w16`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w17`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w18`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w19`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w20`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w21`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w22`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w23`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w24`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w25`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w26`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w27`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w28`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w29`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w30`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w31`        | `value`  | `WLEN-1:0` | `Matrix register contents` |

:General Purpose Matrix Register Fields

### CONTROL AND STATUS REGISTER DESCRIPTIONS

| **Number** | **Privilege** | **Name** | **Description**                       |
|:-----------|:--------------|:---------|:--------------------------------------|
| `0x008`    | `urw`         | `wstart` | `Matrix start position`               |
| `0x009`    | `urw`         | `wxsat`  | `Fixed-point accrued saturation flag` |
| `0x00A`    | `urw`         | `wxrm`   | `Fixed-point rounding mode`           |
| `0x00F`    | `urw`         | `wcsr`   | `Matrix control and status register`  |
| `0xC20`    | `uro`         | `wl`     | `Matrix length`                       |
| `0xC21`    | `uro`         | `wtype`  | `Matrix data type register`           |
| `0xC22`    | `uro`         | `wlenb`  | `Matrix register length in bytes`     |

:Unprivileged Matrix CSRs

### CONTROL AND STATUS REGISTER FIELDS

| **CSR**  | **Name** | **Bits**   | **Privilege** | **Description**                                                                           |
|:---------|:---------|:-----------|:--------------|:------------------------------------------------------------------------------------------|
| `wstart` | `wstart` | `XLEN-1:0` | `u`           | `Matrix start element index. Only bits needed to represent VLMAX minus one are writable.` |

:Matrix Start Position

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                       |
|:--------|:---------|:---------|:--------------|:--------------------------------------|
| `wxsat` | `wxsat`  | `0`      | `u`           | `Fixed-point accrued saturation flag` |

:Fixed-Point Accrued Saturation Flag

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**             |
|:--------|:---------|:---------|:--------------|:----------------------------|
| `wxrm`  | `wxrm`   | `1:0`    | `u`           | `Fixed-point rounding mode` |

:Fixed-Point Rounding Mode

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                       |
|:--------|:---------|:---------|:--------------|:--------------------------------------|
| `wcsr`  | `wxsat`  | `0`      | `u`           | `Fixed-point accrued saturation flag` |
| `wcsr`  | `wxrm`   | `2:1`    | `u`           | `Fixed-point rounding mode`           |

:Matrix Control and Status

| **CSR** | **Name** | **Bits**   | **Privilege** | **Description**                    |
|:--------|:---------|:-----------|:--------------|:-----------------------------------|
| `wl`    | `wl`     | `XLEN-1:0` | `u`           | `Active vector length in elements` |

:Matrix Length

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                             |
|:--------|:---------|:---------|:--------------|:--------------------------------------------|
| `wtype` | `wlmul`  | `2:0`    | `u`           | `Matrix register group multiplier encoding` |
| `wtype` | `wsew`   | `5:3`    | `u`           | `Selected element width encoding`           |
| `wtype` | `wta`    | `6`      | `u`           | `Tail agnostic policy`                      |
| `wtype` | `wma`    | `7`      | `u`           | `Mask agnostic policy`                      |
| `wtype` | `will`   | `XLEN-1` | `u`           | `Illegal vector type`                       |

:Matrix Data Type

| **CSR** | **Name** | **Bits**   | **Privilege** | **Description**                   |
|:--------|:---------|:-----------|:--------------|:----------------------------------|
| `wlenb` | `wlenb`  | `XLEN-1:0` | `u`           | `Matrix register length in bytes` |

:Matrix Register Length in Bytes

## RV-Y

### DESIGN OF REGISTERS

| **File**          | **Description**                            |
|:------------------|:-------------------------------------------|
| `gpr-description` | `General Purpose Register Descriptions`    |
| `gpr-field`       | `General Purpose Register Fields`          |
| `csr-description` | `Control and Status Register Descriptions` |
| `csr-field`       | `Control and Status Register Fields`       |

:Register Directory

### GENERAL PURPOSE REGISTER DESCRIPTIONS

| **Name** | **Alias** | **Type** | **Save** | **Description**          |
|:---------|:----------|:---------|:---------|:-------------------------|
| `y0`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y1`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y2`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y3`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y4`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y5`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y6`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y7`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y8`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y9`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y10`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y11`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y12`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y13`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y14`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y15`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y16`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y17`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y18`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y19`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y20`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y21`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y22`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y23`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y24`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y25`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y26`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y27`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y28`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y29`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y30`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y31`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |

:Tensor Extension Registers

### GENERAL PURPOSE REGISTER FIELDS

| **Register** | **Name** | **Bits**   | **Description**            |
|:-------------|:---------|:-----------|:---------------------------|
| `y0`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y1`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y2`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y3`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y4`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y5`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y6`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y7`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y8`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y9`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y10`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y11`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y12`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y13`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y14`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y15`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y16`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y17`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y18`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y19`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y20`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y21`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y22`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y23`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y24`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y25`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y26`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y27`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y28`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y29`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y30`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y31`        | `value`  | `YLEN-1:0` | `Tensor register contents` |

:General Purpose Tensor Register Fields

### CONTROL AND STATUS REGISTER DESCRIPTIONS

| **Number** | **Privilege** | **Name** | **Description**                       |
|:-----------|:--------------|:---------|:--------------------------------------|
| `0x008`    | `urw`         | `ystart` | `Tensor start position`               |
| `0x009`    | `urw`         | `yxsat`  | `Fixed-point accrued saturation flag` |
| `0x00A`    | `urw`         | `yxrm`   | `Fixed-point rounding mode`           |
| `0x00F`    | `urw`         | `ycsr`   | `Tensor control and status register`  |
| `0xC20`    | `uro`         | `yl`     | `Tensor length`                       |
| `0xC21`    | `uro`         | `ytype`  | `Tensor data type register`           |
| `0xC22`    | `uro`         | `ylenb`  | `Tensor register length in bytes`     |

:Unprivileged Tensor CSRs

### CONTROL AND STATUS REGISTER FIELDS

| **CSR**  | **Name** | **Bits**   | **Privilege** | **Description**                                                                           |
|:---------|:---------|:-----------|:--------------|:------------------------------------------------------------------------------------------|
| `ystart` | `ystart` | `XLEN-1:0` | `u`           | `Tensor start element index. Only bits needed to represent VLMAX minus one are writable.` |

:Tensor Start Position

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                       |
|:--------|:---------|:---------|:--------------|:--------------------------------------|
| `yxsat` | `yxsat`  | `0`      | `u`           | `Fixed-point accrued saturation flag` |

:Fixed-Point Accrued Saturation Flag

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**             |
|:--------|:---------|:---------|:--------------|:----------------------------|
| `yxrm`  | `yxrm`   | `1:0`    | `u`           | `Fixed-point rounding mode` |

:Fixed-Point Rounding Mode

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                       |
|:--------|:---------|:---------|:--------------|:--------------------------------------|
| `ycsr`  | `yxsat`  | `0`      | `u`           | `Fixed-point accrued saturation flag` |
| `ycsr`  | `yxrm`   | `2:1`    | `u`           | `Fixed-point rounding mode`           |

:Tensor Control and Status

| **CSR** | **Name** | **Bits**   | **Privilege** | **Description**                    |
|:--------|:---------|:-----------|:--------------|:-----------------------------------|
| `yl`    | `yl`     | `XLEN-1:0` | `u`           | `Active vector length in elements` |

:Tensor Length

| **CSR** | **Name** | **Bits** | **Privilege** | **Description**                             |
|:--------|:---------|:---------|:--------------|:--------------------------------------------|
| `ytype` | `ylmul`  | `2:0`    | `u`           | `Tensor register group multiplier encoding` |
| `ytype` | `ysew`   | `5:3`    | `u`           | `Selected element width encoding`           |
| `ytype` | `yta`    | `6`      | `u`           | `Tail agnostic policy`                      |
| `ytype` | `yma`    | `7`      | `u`           | `Mask agnostic policy`                      |
| `ytype` | `yill`   | `XLEN-1` | `u`           | `Illegal vector type`                       |

:Tensor Data Type

| **CSR** | **Name** | **Bits**   | **Privilege** | **Description**                   |
|:--------|:---------|:-----------|:--------------|:----------------------------------|
| `ylenb` | `ylenb`  | `XLEN-1:0` | `u`           | `Tensor register length in bytes` |

:Tensor Register Length in Bytes

# RV-SUPERVISOR

## RV-X

### DESIGN OF REGISTERS

| **File**          | **Description**                            |
|:------------------|:-------------------------------------------|
| `gpr-description` | `General Purpose Register Descriptions`    |
| `gpr-field`       | `General Purpose Register Fields`          |
| `csr-description` | `Control and Status Register Descriptions` |
| `csr-field`       | `Control and Status Register Fields`       |

:Register Directory

### GENERAL PURPOSE REGISTER DESCRIPTIONS

| **Integer Register Number** | **Integer Register ABI Name** | **Type** | **Save** | **Description**                       |
|:----------------------------|:------------------------------|:---------|:---------|:--------------------------------------|
| `x0`                        | `zero`                        | `ireg`   | `zero`   | `Hard-wired zero`                     |
| `x1`                        | `ra`                          | `ireg`   | `caller` | `Return address Caller`               |
| `x2`                        | `sp`                          | `ireg`   | `callee` | `Stack pointer Callee`                |
| `x3`                        | `gp`                          | `ireg`   | `global` | `Global pointer`                      |
| `x4`                        | `tp`                          | `ireg`   | `global` | `Thread pointer`                      |
| `x5`                        | `t0`                          | `ireg`   | `caller` | `Temporaries Caller`                  |
| `x6`                        | `t1`                          | `ireg`   | `caller` | `Temporaries Caller`                  |
| `x7`                        | `t2`                          | `ireg`   | `caller` | `Temporaries Caller`                  |
| `x8`                        | `s0`                          | `ireg`   | `callee` | `Saved register/frame pointer Callee` |
| `x9`                        | `s1`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x10`                       | `a0`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x11`                       | `a1`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x12`                       | `a2`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x13`                       | `a3`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x14`                       | `a4`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x15`                       | `a5`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x16`                       | `a6`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x17`                       | `a7`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x18`                       | `s2`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x19`                       | `s3`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x20`                       | `s4`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x21`                       | `s5`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x22`                       | `s6`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x23`                       | `s7`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x24`                       | `s8`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x25`                       | `s9`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x26`                       | `s10`                         | `ireg`   | `callee` | `Saved registers Callee`              |
| `x27`                       | `s11`                         | `ireg`   | `callee` | `Saved registers Callee`              |
| `x28`                       | `t3`                          | `ireg`   | `caller` | `Temporaries Caller`                  |
| `x29`                       | `t4`                          | `ireg`   | `caller` | `Temporaries Caller`                  |
| `x30`                       | `t5`                          | `ireg`   | `caller` | `Temporaries Caller`                  |
| `x31`                       | `t6`                          | `ireg`   | `caller` | `Temporaries Caller`                  |

:Integer Base Registers

### GENERAL PURPOSE REGISTER FIELDS

| **Register** | **Name** | **Bits**   | **Description**          |
|:-------------|:---------|:-----------|:-------------------------|
| `x0`         | `zero`   | `XLEN-1:0` | `Hard-wired to zero`     |
| `x1`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x2`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x3`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x4`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x5`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x6`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x7`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x8`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x9`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x10`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x11`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x12`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x13`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x14`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x15`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x16`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x17`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x18`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x19`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x20`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x21`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x22`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x23`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x24`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x25`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x26`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x27`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x28`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x29`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x30`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x31`        | `value`  | `XLEN-1:0` | `Integer register value` |

:General Purpose Integer Register Fields

### CONTROL AND STATUS REGISTER DESCRIPTIONS

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

### CONTROL AND STATUS REGISTER FIELDS

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

## RV-F

### DESIGN OF REGISTERS

| **File**          | **Description**                         |
|:------------------|:----------------------------------------|
| `gpr-description` | `General Purpose Register Descriptions` |
| `gpr-field`       | `General Purpose Register Fields`       |

:Register Directory

### GENERAL PURPOSE REGISTER DESCRIPTIONS

| **Floating-Point Register Number** | **Floating-Point Register ABI Name** | **Type** | **Save** | **Description**             |
|:-----------------------------------|:-------------------------------------|:---------|:---------|:----------------------------|
| `f0`                               | `ft0`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f1`                               | `ft1`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f2`                               | `ft2`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f3`                               | `ft3`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f4`                               | `ft4`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f5`                               | `ft5`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f6`                               | `ft6`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f7`                               | `ft7`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f8`                               | `fs0`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f9`                               | `fs1`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f10`                              | `fa0`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f11`                              | `fa1`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f12`                              | `fa2`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f13`                              | `fa3`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f14`                              | `fa4`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f15`                              | `fa5`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f16`                              | `fa6`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f17`                              | `fa7`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f18`                              | `fs2`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f19`                              | `fs3`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f20`                              | `fs4`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f21`                              | `fs5`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f22`                              | `fs6`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f23`                              | `fs7`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f24`                              | `fs8`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f25`                              | `fs9`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f26`                              | `fs10`                               | `freg`   | `callee` | `FP saved registers Callee` |
| `f27`                              | `fs11`                               | `freg`   | `callee` | `FP saved registers Callee` |
| `f28`                              | `ft8`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f29`                              | `ft9`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f30`                              | `ft10`                               | `freg`   | `caller` | `FP temporaries Caller`     |
| `f31`                              | `ft11`                               | `freg`   | `caller` | `FP temporaries Caller`     |

:Floating-Point Extension Registers

### GENERAL PURPOSE REGISTER FIELDS

| **Register** | **Name** | **Bits**   | **Description**                                                                                   |
|:-------------|:---------|:-----------|:--------------------------------------------------------------------------------------------------|
| `f0`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f1`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f2`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f3`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f4`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f5`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f6`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f7`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f8`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f9`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f10`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f11`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f12`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f13`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f14`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f15`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f16`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f17`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f18`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f19`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f20`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f21`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f22`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f23`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f24`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f25`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f26`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f27`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f28`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f29`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f30`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f31`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |

:General Purpose Floating-Point Register Fields

## RV-V

### DESIGN OF REGISTERS

| **File**          | **Description**                         |
|:------------------|:----------------------------------------|
| `gpr-description` | `General Purpose Register Descriptions` |
| `gpr-field`       | `General Purpose Register Fields`       |

:Register Directory

### GENERAL PURPOSE REGISTER DESCRIPTIONS

| **Name** | **Alias** | **Type** | **Save** | **Description**          |
|:---------|:----------|:---------|:---------|:-------------------------|
| `v0`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v1`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v2`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v3`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v4`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v5`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v6`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v7`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v8`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v9`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v10`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v11`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v12`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v13`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v14`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v15`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v16`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v17`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v18`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v19`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v20`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v21`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v22`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v23`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v24`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v25`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v26`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v27`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v28`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v29`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v30`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v31`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |

:Vector Extension Registers

### GENERAL PURPOSE REGISTER FIELDS

| **Register** | **Name** | **Bits**   | **Description**                                                                                    |
|:-------------|:---------|:-----------|:---------------------------------------------------------------------------------------------------|
| `v0`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v1`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v2`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v3`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v4`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v5`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v6`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v7`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v8`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v9`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v10`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v11`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v12`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v13`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v14`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v15`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v16`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v17`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v18`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v19`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v20`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v21`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v22`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v23`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v24`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v25`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v26`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v27`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v28`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v29`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v30`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v31`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |

:General Purpose Vector Register Fields

## RV-W

### DESIGN OF REGISTERS

| **File**          | **Description**                         |
|:------------------|:----------------------------------------|
| `gpr-description` | `General Purpose Register Descriptions` |
| `gpr-field`       | `General Purpose Register Fields`       |

:Register Directory

### GENERAL PURPOSE REGISTER DESCRIPTIONS

| **Name** | **Alias** | **Type** | **Save** | **Description**          |
|:---------|:----------|:---------|:---------|:-------------------------|
| `w0`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w1`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w2`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w3`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w4`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w5`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w6`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w7`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w8`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w9`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w10`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w11`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w12`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w13`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w14`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w15`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w16`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w17`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w18`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w19`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w20`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w21`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w22`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w23`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w24`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w25`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w26`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w27`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w28`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w29`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w30`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w31`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |

:Matrix Extension Registers

### GENERAL PURPOSE REGISTER FIELDS

| **Register** | **Name** | **Bits**   | **Description**            |
|:-------------|:---------|:-----------|:---------------------------|
| `w0`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w1`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w2`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w3`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w4`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w5`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w6`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w7`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w8`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w9`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w10`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w11`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w12`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w13`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w14`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w15`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w16`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w17`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w18`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w19`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w20`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w21`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w22`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w23`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w24`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w25`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w26`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w27`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w28`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w29`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w30`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w31`        | `value`  | `WLEN-1:0` | `Matrix register contents` |

:General Purpose Matrix Register Fields

## RV-Y

### DESIGN OF REGISTERS

| **File**          | **Description**                         |
|:------------------|:----------------------------------------|
| `gpr-description` | `General Purpose Register Descriptions` |
| `gpr-field`       | `General Purpose Register Fields`       |

:Register Directory

### GENERAL PURPOSE REGISTER DESCRIPTIONS

| **Name** | **Alias** | **Type** | **Save** | **Description**          |
|:---------|:----------|:---------|:---------|:-------------------------|
| `y0`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y1`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y2`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y3`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y4`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y5`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y6`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y7`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y8`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y9`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y10`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y11`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y12`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y13`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y14`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y15`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y16`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y17`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y18`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y19`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y20`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y21`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y22`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y23`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y24`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y25`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y26`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y27`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y28`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y29`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y30`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y31`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |

:Tensor Extension Registers

### GENERAL PURPOSE REGISTER FIELDS

| **Register** | **Name** | **Bits**   | **Description**            |
|:-------------|:---------|:-----------|:---------------------------|
| `y0`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y1`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y2`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y3`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y4`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y5`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y6`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y7`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y8`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y9`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y10`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y11`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y12`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y13`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y14`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y15`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y16`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y17`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y18`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y19`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y20`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y21`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y22`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y23`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y24`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y25`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y26`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y27`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y28`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y29`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y30`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y31`        | `value`  | `YLEN-1:0` | `Tensor register contents` |

:General Purpose Tensor Register Fields

# RV-HYPERVISOR

## RV-X

### DESIGN OF REGISTERS

| **File**          | **Description**                            |
|:------------------|:-------------------------------------------|
| `gpr-description` | `General Purpose Register Descriptions`    |
| `gpr-field`       | `General Purpose Register Fields`          |
| `csr-description` | `Control and Status Register Descriptions` |
| `csr-field`       | `Control and Status Register Fields`       |

:Register Directory

### GENERAL PURPOSE REGISTER DESCRIPTIONS

| **Integer Register Number** | **Integer Register ABI Name** | **Type** | **Save** | **Description**                       |
|:----------------------------|:------------------------------|:---------|:---------|:--------------------------------------|
| `x0`                        | `zero`                        | `ireg`   | `zero`   | `Hard-wired zero`                     |
| `x1`                        | `ra`                          | `ireg`   | `caller` | `Return address Caller`               |
| `x2`                        | `sp`                          | `ireg`   | `callee` | `Stack pointer Callee`                |
| `x3`                        | `gp`                          | `ireg`   | `global` | `Global pointer`                      |
| `x4`                        | `tp`                          | `ireg`   | `global` | `Thread pointer`                      |
| `x5`                        | `t0`                          | `ireg`   | `caller` | `Temporaries Caller`                  |
| `x6`                        | `t1`                          | `ireg`   | `caller` | `Temporaries Caller`                  |
| `x7`                        | `t2`                          | `ireg`   | `caller` | `Temporaries Caller`                  |
| `x8`                        | `s0`                          | `ireg`   | `callee` | `Saved register/frame pointer Callee` |
| `x9`                        | `s1`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x10`                       | `a0`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x11`                       | `a1`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x12`                       | `a2`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x13`                       | `a3`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x14`                       | `a4`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x15`                       | `a5`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x16`                       | `a6`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x17`                       | `a7`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x18`                       | `s2`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x19`                       | `s3`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x20`                       | `s4`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x21`                       | `s5`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x22`                       | `s6`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x23`                       | `s7`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x24`                       | `s8`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x25`                       | `s9`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x26`                       | `s10`                         | `ireg`   | `callee` | `Saved registers Callee`              |
| `x27`                       | `s11`                         | `ireg`   | `callee` | `Saved registers Callee`              |
| `x28`                       | `t3`                          | `ireg`   | `caller` | `Temporaries Caller`                  |
| `x29`                       | `t4`                          | `ireg`   | `caller` | `Temporaries Caller`                  |
| `x30`                       | `t5`                          | `ireg`   | `caller` | `Temporaries Caller`                  |
| `x31`                       | `t6`                          | `ireg`   | `caller` | `Temporaries Caller`                  |

:Integer Base Registers

### GENERAL PURPOSE REGISTER FIELDS

| **Register** | **Name** | **Bits**   | **Description**          |
|:-------------|:---------|:-----------|:-------------------------|
| `x0`         | `zero`   | `XLEN-1:0` | `Hard-wired to zero`     |
| `x1`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x2`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x3`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x4`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x5`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x6`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x7`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x8`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x9`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x10`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x11`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x12`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x13`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x14`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x15`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x16`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x17`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x18`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x19`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x20`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x21`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x22`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x23`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x24`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x25`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x26`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x27`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x28`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x29`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x30`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x31`        | `value`  | `XLEN-1:0` | `Integer register value` |

:General Purpose Integer Register Fields

### CONTROL AND STATUS REGISTER DESCRIPTIONS

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

### CONTROL AND STATUS REGISTER FIELDS

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

## RV-F

### DESIGN OF REGISTERS

| **File**          | **Description**                         |
|:------------------|:----------------------------------------|
| `gpr-description` | `General Purpose Register Descriptions` |
| `gpr-field`       | `General Purpose Register Fields`       |

:Register Directory

### GENERAL PURPOSE REGISTER DESCRIPTIONS

| **Floating-Point Register Number** | **Floating-Point Register ABI Name** | **Type** | **Save** | **Description**             |
|:-----------------------------------|:-------------------------------------|:---------|:---------|:----------------------------|
| `f0`                               | `ft0`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f1`                               | `ft1`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f2`                               | `ft2`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f3`                               | `ft3`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f4`                               | `ft4`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f5`                               | `ft5`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f6`                               | `ft6`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f7`                               | `ft7`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f8`                               | `fs0`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f9`                               | `fs1`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f10`                              | `fa0`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f11`                              | `fa1`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f12`                              | `fa2`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f13`                              | `fa3`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f14`                              | `fa4`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f15`                              | `fa5`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f16`                              | `fa6`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f17`                              | `fa7`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f18`                              | `fs2`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f19`                              | `fs3`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f20`                              | `fs4`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f21`                              | `fs5`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f22`                              | `fs6`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f23`                              | `fs7`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f24`                              | `fs8`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f25`                              | `fs9`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f26`                              | `fs10`                               | `freg`   | `callee` | `FP saved registers Callee` |
| `f27`                              | `fs11`                               | `freg`   | `callee` | `FP saved registers Callee` |
| `f28`                              | `ft8`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f29`                              | `ft9`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f30`                              | `ft10`                               | `freg`   | `caller` | `FP temporaries Caller`     |
| `f31`                              | `ft11`                               | `freg`   | `caller` | `FP temporaries Caller`     |

:Floating-Point Extension Registers

### GENERAL PURPOSE REGISTER FIELDS

| **Register** | **Name** | **Bits**   | **Description**                                                                                   |
|:-------------|:---------|:-----------|:--------------------------------------------------------------------------------------------------|
| `f0`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f1`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f2`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f3`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f4`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f5`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f6`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f7`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f8`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f9`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f10`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f11`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f12`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f13`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f14`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f15`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f16`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f17`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f18`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f19`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f20`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f21`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f22`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f23`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f24`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f25`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f26`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f27`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f28`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f29`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f30`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f31`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |

:General Purpose Floating-Point Register Fields

## RV-V

### DESIGN OF REGISTERS

| **File**          | **Description**                         |
|:------------------|:----------------------------------------|
| `gpr-description` | `General Purpose Register Descriptions` |
| `gpr-field`       | `General Purpose Register Fields`       |

:Register Directory

### GENERAL PURPOSE REGISTER DESCRIPTIONS

| **Name** | **Alias** | **Type** | **Save** | **Description**          |
|:---------|:----------|:---------|:---------|:-------------------------|
| `v0`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v1`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v2`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v3`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v4`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v5`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v6`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v7`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v8`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v9`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v10`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v11`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v12`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v13`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v14`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v15`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v16`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v17`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v18`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v19`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v20`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v21`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v22`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v23`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v24`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v25`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v26`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v27`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v28`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v29`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v30`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v31`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |

:Vector Extension Registers

### GENERAL PURPOSE REGISTER FIELDS

| **Register** | **Name** | **Bits**   | **Description**                                                                                    |
|:-------------|:---------|:-----------|:---------------------------------------------------------------------------------------------------|
| `v0`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v1`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v2`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v3`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v4`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v5`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v6`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v7`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v8`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v9`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v10`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v11`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v12`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v13`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v14`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v15`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v16`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v17`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v18`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v19`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v20`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v21`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v22`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v23`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v24`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v25`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v26`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v27`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v28`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v29`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v30`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v31`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |

:General Purpose Vector Register Fields

## RV-W

### DESIGN OF REGISTERS

| **File**          | **Description**                         |
|:------------------|:----------------------------------------|
| `gpr-description` | `General Purpose Register Descriptions` |
| `gpr-field`       | `General Purpose Register Fields`       |

:Register Directory

### GENERAL PURPOSE REGISTER DESCRIPTIONS

| **Name** | **Alias** | **Type** | **Save** | **Description**          |
|:---------|:----------|:---------|:---------|:-------------------------|
| `w0`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w1`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w2`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w3`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w4`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w5`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w6`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w7`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w8`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w9`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w10`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w11`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w12`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w13`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w14`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w15`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w16`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w17`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w18`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w19`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w20`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w21`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w22`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w23`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w24`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w25`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w26`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w27`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w28`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w29`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w30`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w31`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |

:Matrix Extension Registers

### GENERAL PURPOSE REGISTER FIELDS

| **Register** | **Name** | **Bits**   | **Description**            |
|:-------------|:---------|:-----------|:---------------------------|
| `w0`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w1`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w2`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w3`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w4`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w5`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w6`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w7`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w8`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w9`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w10`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w11`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w12`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w13`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w14`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w15`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w16`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w17`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w18`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w19`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w20`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w21`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w22`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w23`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w24`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w25`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w26`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w27`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w28`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w29`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w30`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w31`        | `value`  | `WLEN-1:0` | `Matrix register contents` |

:General Purpose Matrix Register Fields

## RV-Y

### DESIGN OF REGISTERS

| **File**          | **Description**                         |
|:------------------|:----------------------------------------|
| `gpr-description` | `General Purpose Register Descriptions` |
| `gpr-field`       | `General Purpose Register Fields`       |

:Register Directory

### GENERAL PURPOSE REGISTER DESCRIPTIONS

| **Name** | **Alias** | **Type** | **Save** | **Description**          |
|:---------|:----------|:---------|:---------|:-------------------------|
| `y0`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y1`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y2`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y3`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y4`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y5`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y6`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y7`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y8`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y9`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y10`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y11`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y12`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y13`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y14`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y15`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y16`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y17`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y18`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y19`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y20`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y21`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y22`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y23`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y24`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y25`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y26`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y27`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y28`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y29`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y30`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y31`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |

:Tensor Extension Registers

### GENERAL PURPOSE REGISTER FIELDS

| **Register** | **Name** | **Bits**   | **Description**            |
|:-------------|:---------|:-----------|:---------------------------|
| `y0`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y1`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y2`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y3`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y4`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y5`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y6`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y7`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y8`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y9`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y10`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y11`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y12`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y13`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y14`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y15`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y16`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y17`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y18`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y19`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y20`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y21`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y22`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y23`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y24`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y25`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y26`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y27`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y28`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y29`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y30`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y31`        | `value`  | `YLEN-1:0` | `Tensor register contents` |

:General Purpose Tensor Register Fields

# RV-MACHINE

## RV-X

### DESIGN OF REGISTERS

| **File**          | **Description**                            |
|:------------------|:-------------------------------------------|
| `gpr-description` | `General Purpose Register Descriptions`    |
| `gpr-field`       | `General Purpose Register Fields`          |
| `csr-description` | `Control and Status Register Descriptions` |
| `csr-field`       | `Control and Status Register Fields`       |

:Register Directory

### GENERAL PURPOSE REGISTER DESCRIPTIONS

| **Integer Register Number** | **Integer Register ABI Name** | **Type** | **Save** | **Description**                       |
|:----------------------------|:------------------------------|:---------|:---------|:--------------------------------------|
| `x0`                        | `zero`                        | `ireg`   | `zero`   | `Hard-wired zero`                     |
| `x1`                        | `ra`                          | `ireg`   | `caller` | `Return address Caller`               |
| `x2`                        | `sp`                          | `ireg`   | `callee` | `Stack pointer Callee`                |
| `x3`                        | `gp`                          | `ireg`   | `global` | `Global pointer`                      |
| `x4`                        | `tp`                          | `ireg`   | `global` | `Thread pointer`                      |
| `x5`                        | `t0`                          | `ireg`   | `caller` | `Temporaries Caller`                  |
| `x6`                        | `t1`                          | `ireg`   | `caller` | `Temporaries Caller`                  |
| `x7`                        | `t2`                          | `ireg`   | `caller` | `Temporaries Caller`                  |
| `x8`                        | `s0`                          | `ireg`   | `callee` | `Saved register/frame pointer Callee` |
| `x9`                        | `s1`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x10`                       | `a0`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x11`                       | `a1`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x12`                       | `a2`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x13`                       | `a3`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x14`                       | `a4`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x15`                       | `a5`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x16`                       | `a6`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x17`                       | `a7`                          | `ireg`   | `caller` | `Function arguments Caller`           |
| `x18`                       | `s2`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x19`                       | `s3`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x20`                       | `s4`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x21`                       | `s5`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x22`                       | `s6`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x23`                       | `s7`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x24`                       | `s8`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x25`                       | `s9`                          | `ireg`   | `callee` | `Saved registers Callee`              |
| `x26`                       | `s10`                         | `ireg`   | `callee` | `Saved registers Callee`              |
| `x27`                       | `s11`                         | `ireg`   | `callee` | `Saved registers Callee`              |
| `x28`                       | `t3`                          | `ireg`   | `caller` | `Temporaries Caller`                  |
| `x29`                       | `t4`                          | `ireg`   | `caller` | `Temporaries Caller`                  |
| `x30`                       | `t5`                          | `ireg`   | `caller` | `Temporaries Caller`                  |
| `x31`                       | `t6`                          | `ireg`   | `caller` | `Temporaries Caller`                  |

:Integer Base Registers

### GENERAL PURPOSE REGISTER FIELDS

| **Register** | **Name** | **Bits**   | **Description**          |
|:-------------|:---------|:-----------|:-------------------------|
| `x0`         | `zero`   | `XLEN-1:0` | `Hard-wired to zero`     |
| `x1`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x2`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x3`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x4`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x5`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x6`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x7`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x8`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x9`         | `value`  | `XLEN-1:0` | `Integer register value` |
| `x10`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x11`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x12`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x13`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x14`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x15`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x16`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x17`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x18`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x19`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x20`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x21`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x22`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x23`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x24`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x25`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x26`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x27`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x28`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x29`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x30`        | `value`  | `XLEN-1:0` | `Integer register value` |
| `x31`        | `value`  | `XLEN-1:0` | `Integer register value` |

:General Purpose Integer Register Fields

### CONTROL AND STATUS REGISTER DESCRIPTIONS

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

### CONTROL AND STATUS REGISTER FIELDS

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

## RV-F

### DESIGN OF REGISTERS

| **File**          | **Description**                         |
|:------------------|:----------------------------------------|
| `gpr-description` | `General Purpose Register Descriptions` |
| `gpr-field`       | `General Purpose Register Fields`       |

:Register Directory

### GENERAL PURPOSE REGISTER DESCRIPTIONS

| **Floating-Point Register Number** | **Floating-Point Register ABI Name** | **Type** | **Save** | **Description**             |
|:-----------------------------------|:-------------------------------------|:---------|:---------|:----------------------------|
| `f0`                               | `ft0`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f1`                               | `ft1`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f2`                               | `ft2`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f3`                               | `ft3`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f4`                               | `ft4`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f5`                               | `ft5`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f6`                               | `ft6`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f7`                               | `ft7`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f8`                               | `fs0`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f9`                               | `fs1`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f10`                              | `fa0`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f11`                              | `fa1`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f12`                              | `fa2`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f13`                              | `fa3`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f14`                              | `fa4`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f15`                              | `fa5`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f16`                              | `fa6`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f17`                              | `fa7`                                | `freg`   | `caller` | `FP arguments Caller`       |
| `f18`                              | `fs2`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f19`                              | `fs3`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f20`                              | `fs4`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f21`                              | `fs5`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f22`                              | `fs6`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f23`                              | `fs7`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f24`                              | `fs8`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f25`                              | `fs9`                                | `freg`   | `callee` | `FP saved registers Callee` |
| `f26`                              | `fs10`                               | `freg`   | `callee` | `FP saved registers Callee` |
| `f27`                              | `fs11`                               | `freg`   | `callee` | `FP saved registers Callee` |
| `f28`                              | `ft8`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f29`                              | `ft9`                                | `freg`   | `caller` | `FP temporaries Caller`     |
| `f30`                              | `ft10`                               | `freg`   | `caller` | `FP temporaries Caller`     |
| `f31`                              | `ft11`                               | `freg`   | `caller` | `FP temporaries Caller`     |

:Floating-Point Extension Registers

### GENERAL PURPOSE REGISTER FIELDS

| **Register** | **Name** | **Bits**   | **Description**                                                                                   |
|:-------------|:---------|:-----------|:--------------------------------------------------------------------------------------------------|
| `f0`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f1`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f2`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f3`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f4`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f5`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f6`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f7`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f8`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f9`         | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f10`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f11`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f12`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f13`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f14`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f15`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f16`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f17`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f18`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f19`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f20`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f21`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f22`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f23`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f24`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f25`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f26`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f27`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f28`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f29`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f30`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |
| `f31`        | `value`  | `FLEN-1:0` | `Floating-point register value. Narrower values are NaN-boxed when FLEN exceeds the value width.` |

:General Purpose Floating-Point Register Fields

## RV-V

### DESIGN OF REGISTERS

| **File**          | **Description**                         |
|:------------------|:----------------------------------------|
| `gpr-description` | `General Purpose Register Descriptions` |
| `gpr-field`       | `General Purpose Register Fields`       |

:Register Directory

### GENERAL PURPOSE REGISTER DESCRIPTIONS

| **Name** | **Alias** | **Type** | **Save** | **Description**          |
|:---------|:----------|:---------|:---------|:-------------------------|
| `v0`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v1`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v2`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v3`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v4`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v5`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v6`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v7`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v8`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v9`     | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v10`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v11`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v12`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v13`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v14`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v15`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v16`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v17`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v18`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v19`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v20`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v21`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v22`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v23`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v24`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v25`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v26`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v27`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v28`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v29`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v30`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |
| `v31`    | `none`    | `vreg`   | `none`   | `Vector register (VLEN)` |

:Vector Extension Registers

### GENERAL PURPOSE REGISTER FIELDS

| **Register** | **Name** | **Bits**   | **Description**                                                                                    |
|:-------------|:---------|:-----------|:---------------------------------------------------------------------------------------------------|
| `v0`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v1`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v2`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v3`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v4`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v5`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v6`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v7`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v8`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v9`         | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v10`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v11`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v12`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v13`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v14`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v15`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v16`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v17`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v18`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v19`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v20`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v21`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v22`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v23`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v24`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v25`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v26`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v27`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v28`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v29`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v30`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |
| `v31`        | `value`  | `VLEN-1:0` | `Vector register contents. Element boundaries depend on the vector configuration and instruction.` |

:General Purpose Vector Register Fields

## RV-W

### DESIGN OF REGISTERS

| **File**          | **Description**                         |
|:------------------|:----------------------------------------|
| `gpr-description` | `General Purpose Register Descriptions` |
| `gpr-field`       | `General Purpose Register Fields`       |

:Register Directory

### GENERAL PURPOSE REGISTER DESCRIPTIONS

| **Name** | **Alias** | **Type** | **Save** | **Description**          |
|:---------|:----------|:---------|:---------|:-------------------------|
| `w0`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w1`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w2`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w3`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w4`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w5`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w6`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w7`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w8`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w9`     | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w10`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w11`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w12`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w13`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w14`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w15`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w16`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w17`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w18`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w19`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w20`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w21`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w22`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w23`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w24`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w25`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w26`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w27`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w28`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w29`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w30`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |
| `w31`    | `none`    | `wreg`   | `none`   | `wector register (WLEN)` |

:Matrix Extension Registers

### GENERAL PURPOSE REGISTER FIELDS

| **Register** | **Name** | **Bits**   | **Description**            |
|:-------------|:---------|:-----------|:---------------------------|
| `w0`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w1`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w2`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w3`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w4`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w5`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w6`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w7`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w8`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w9`         | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w10`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w11`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w12`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w13`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w14`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w15`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w16`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w17`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w18`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w19`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w20`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w21`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w22`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w23`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w24`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w25`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w26`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w27`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w28`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w29`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w30`        | `value`  | `WLEN-1:0` | `Matrix register contents` |
| `w31`        | `value`  | `WLEN-1:0` | `Matrix register contents` |

:General Purpose Matrix Register Fields

## RV-Y

### DESIGN OF REGISTERS

| **File**          | **Description**                         |
|:------------------|:----------------------------------------|
| `gpr-description` | `General Purpose Register Descriptions` |
| `gpr-field`       | `General Purpose Register Fields`       |

:Register Directory

### GENERAL PURPOSE REGISTER DESCRIPTIONS

| **Name** | **Alias** | **Type** | **Save** | **Description**          |
|:---------|:----------|:---------|:---------|:-------------------------|
| `y0`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y1`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y2`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y3`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y4`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y5`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y6`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y7`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y8`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y9`     | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y10`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y11`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y12`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y13`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y14`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y15`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y16`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y17`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y18`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y19`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y20`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y21`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y22`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y23`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y24`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y25`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y26`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y27`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y28`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y29`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y30`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |
| `y31`    | `none`    | `yreg`   | `none`   | `Tensor register (YLEN)` |

:Tensor Extension Registers

### GENERAL PURPOSE REGISTER FIELDS

| **Register** | **Name** | **Bits**   | **Description**            |
|:-------------|:---------|:-----------|:---------------------------|
| `y0`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y1`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y2`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y3`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y4`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y5`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y6`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y7`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y8`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y9`         | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y10`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y11`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y12`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y13`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y14`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y15`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y16`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y17`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y18`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y19`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y20`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y21`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y22`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y23`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y24`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y25`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y26`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y27`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y28`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y29`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y30`        | `value`  | `YLEN-1:0` | `Tensor register contents` |
| `y31`        | `value`  | `YLEN-1:0` | `Tensor register contents` |

:General Purpose Tensor Register Fields
