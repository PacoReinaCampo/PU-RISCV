## OPCODE ENCODING MACHINE INFORMATION

Machine-level information specifies how opcodes and their associated fields are encoded into binary machine code. This information dictates the exact bit patterns used for instructions, ensuring uniformity and predictability in instruction decoding and execution across various RISC-V processor implementations. It forms the foundation for assembler and compiler toolchains to generate executable code targeting RISC-V architectures.

Format of a line in the table:

| `RV32I`             | `31:25`    | `24:20`  | `19:15`  | `14:12` | `11:7`   | `6:0`     |
|  -------------------|  :------:  |  :----:  |  :----:  |  :---:  |  :----:  |  :------: |
| `LUI   RD, IMM`     | `IIIIIII`  | `IIIII`  | `IIIII`  | `III`   | `RD4:0`  | `0110111` |
| `AUPIC RD, IMM`     | `IIIIIII`  | `IIIII`  | `IIIII`  | `III`   | `RD4:0`  | `0010111` |
| `JAL   RD, IMM`     | `IIIIIII`  | `IIIII`  | `IIIII`  | `III`   | `RD4:0`  | `1101111` |
| `JALR  RD,RS1,IMM`  | `IIIIIII`  | `IIIII`  | `RS14:0` | `000`   | `RD4:0`  | `1101111` |
| `BEQ   RS1,RS2,IMM` | `IIIIIII`  | `RS24:0` | `RS14:0` | `000`   | `IIIII`  | `1100011` |
| `BNE   RS1,RS2,IMM` | `IIIIIII`  | `RS24:0` | `RS14:0` | `001`   | `IIIII`  | `1100011` |
| `BLT   RS1,RS2,IMM` | `IIIIIII`  | `RS24:0` | `RS14:0` | `100`   | `IIIII`  | `1100011` |
| `BGE   RS1,RS2,IMM` | `IIIIIII`  | `RS24:0` | `RS14:0` | `101`   | `IIIII`  | `1100011` |
| `BLTU  RS1,RS2,IMM` | `IIIIIII`  | `RS24:0` | `RS14:0` | `110`   | `IIIII`  | `1100011` |
| `BGEU  RS1,RS2,IMM` | `IIIIIII`  | `RS24:0` | `RS14:0` | `111`   | `IIIII`  | `1100011` |
| `LB    RD, RS1`     | `IIIIIII`  | `IIIII`  | `RS14:0` | `000`   | `RD4:0`  | `0000011` |
| `LH    RD, RS1`     | `IIIIIII`  | `IIIII`  | `RS14:0` | `001`   | `RD4:0`  | `0000011` |
| `LW    RD, RS1`     | `IIIIIII`  | `IIIII`  | `RS14:0` | `010`   | `RD4:0`  | `0000011` |
| `LBU   RD, RS1`     | `IIIIIII`  | `IIIII`  | `RS14:0` | `100`   | `RD4:0`  | `0000011` |
| `LHU   RD, RS1`     | `IIIIIII`  | `IIIII`  | `RS14:0` | `101`   | `RD4:0`  | `0000011` |
| `SB    RS2,RS1`     | `IIIIIII`  | `RS24:0` | `RS14:0` | `000`   | `IIIII`  | `0100011` |
| `SH    RS2,RS1`     | `IIIIIII`  | `RS24:0` | `RS14:0` | `001`   | `IIIII`  | `0100011` |
| `SW    RS2,RS1`     | `IIIIIII`  | `RS24:0` | `RS14:0` | `010`   | `IIIII`  | `0100011` |
| `ADDI  RD,RS1,IMM`  | `IIIIIII`  | `IIIII`  | `RS14:0` | `000`   | `RD4:0`  | `0010011` |
| `SLTI  RD,RS1,IMM`  | `IIIIIII`  | `IIIII`  | `RS14:0` | `010`   | `RD4:0`  | `0010011` |
| `SLTIU RD,RS1,IMM`  | `IIIIIII`  | `IIIII`  | `RS14:0` | `011`   | `RD4:0`  | `0010011` |
| `XORI  RD,RS1,IMM`  | `IIIIIII`  | `IIIII`  | `RS14:0` | `100`   | `RD4:0`  | `0010011` |
| `ORI   RD,RS1,IMM`  | `IIIIIII`  | `IIIII`  | `RS14:0` | `110`   | `RD4:0`  | `0010011` |
| `ANDI  RD,RS1,IMM`  | `IIIIIII`  | `IIIII`  | `RS14:0` | `111`   | `RD4:0`  | `0010011` |
| `SLLI  RD,RS1,IMM`  | `0000000`  | `IIII`   | `RS14:0` | `001`   | `RD4:0`  | `0010011` |
| `SRLI  RD,RS1,IMM`  | `0000000`  | `IIII`   | `RS14:0` | `101`   | `RD4:0`  | `0010011` |
| `SRAI  RD,RS1,IMM`  | `0100000`  | `IIII`   | `RS14:0` | `101`   | `RD4:0`  | `0010011` |
| `ADD   RD,RS1,RS2`  | `0000000`  | `RS24:0` | `RS14:0` | `000`   | `RD4:0`  | `0110011` |
| `SUB   RD,RS1,RS2`  | `0100000`  | `RS24:0` | `RS14:0` | `000`   | `RD4:0`  | `0110011` |
| `SLL   RD,RS1,RS2`  | `0000000`  | `RS24:0` | `RS14:0` | `001`   | `RD4:0`  | `0110011` |
| `SLT   RD,RS1,RS2`  | `0000000`  | `RS24:0` | `RS14:0` | `010`   | `RD4:0`  | `0110011` |
| `SLTU  RD,RS1,RS2`  | `0000000`  | `RS24:0` | `RS14:0` | `011`   | `RD4:0`  | `0110011` |
| `XOR   RD,RS1,RS2`  | `0000000`  | `RS24:0` | `RS14:0` | `100`   | `RD4:0`  | `0110011` |
| `SRL   RD,RS1,RS2`  | `0000000`  | `RS24:0` | `RS14:0` | `101`   | `RD4:0`  | `0110011` |
| `SRA   RD,RS1,RS2`  | `0100000`  | `RS24:0` | `RS14:0` | `101`   | `RD4:0`  | `0110011` |
| `OR    RD,RS1,RS2`  | `0000000`  | `RS24:0` | `RS14:0` | `110`   | `RD4:0`  | `0110011` |
| `AND   RD,RS1,RS2`  | `0000000`  | `RS24:0` | `RS14:0` | `111`   | `RD4:0`  | `0110011` |
| `FENCE PRED,SUCC`   | `0000PPP`  | `PSSSS`  | `00000`  | `000`   | `00000`  | `0001111` |
| `FENCE.I`           | `0000P00`  | `00000`  | `00000`  | `001`   | `00000`  | `0001111` |
| `ECALL`             | `0000000`  | `00000`  | `00000`  | `000`   | `00000`  | `1110011` |
| `EBREAK`            | `0000000`  | `00001`  | `00000`  | `000`   | `00000`  | `1110011` |
: RV32I - Base Integer Instruction Set (32 bit)

The RV32I table details the base integer instruction set for the 32-bit RISC-V architecture, encompassing essential operations and functionalities supported at the machine level.

| `RV64I`             | `31:25`    | `24:20`  | `19:15`  | `14:12` | `11:7`   | `6:0`     |
|  -------------------|  :------:  |  :----:  |  :----:  |  :---:  |  :----:  |  :------: |
| `LWU   RD, RS1`     | `IIIIIII`  | `IIIII`  | `RS14:0` | `110`   | `RD4:0`  | `0000011` |
| `LD    RD, RS1`     | `IIIIIII`  | `IIIII`  | `RS14:0` | `011`   | `RD4:0`  | `0000011` |
| `SD    RD, RS1,RS2` | `IIIIIII`  | `RS24:0` | `RS14:0` | `011`   | `IIIII`  | `0000011` |
| `SLLI  RD, RS1,IMM` | `0000000`  | `IIIII`  | `RS14:0` | `001`   | `RD4:0`  | `0010011` |
| `SRLI  RD, RS1,IMM` | `0000000`  | `IIIII`  | `RS14:0` | `001`   | `RD4:0`  | `0010011` |
| `SRAI  RD, RS1,IMM` | `0100000`  | `IIIII`  | `RS14:0` | `001`   | `RD4:0`  | `0010011` |
| `ADDIW RD, RS1`     | `IIIIIII`  | `IIIII`  | `RS14:0` | `000`   | `RD4:0`  | `0011011` |
| `SLLIW RD, RS1`     | `0000000`  | `IIIII`  | `RS14:0` | `001`   | `RD4:0`  | `0011011` |
| `SRLIW RD, RS1`     | `0000000`  | `IIIII`  | `RS14:0` | `101`   | `RD4:0`  | `0011011` |
| `SRAIW RD, RS1`     | `0100000`  | `IIIII`  | `RS14:0` | `101`   | `RD4:0`  | `0011011` |
| `ADDW  RD, RS1,RS2` | `0000000`  | `RS24:0` | `RS14:0` | `000`   | `RD4:0`  | `0111011` |
| `SUBW  RD, RS1,RS2` | `0100000`  | `RS24:0` | `RS14:0` | `000`   | `RD4:0`  | `0111011` |
| `SLIW  RD, RS1,RS2` | `0000000`  | `RS24:0` | `RS14:0` | `001`   | `RD4:0`  | `0111011` |
| `SRLW  RD, RS1,RS2` | `0000000`  | `RS24:0` | `RS14:0` | `101`   | `RD4:0`  | `0111011` |
| `SRAW  RD, RS1,RS2` | `0100000`  | `RS24:0` | `RS14:0` | `101`   | `RD4:0`  | `0111011` |
: RV64I - Base Integer Instruction Set (64 bit)

Building upon RV32I, RV64I extends the base integer instruction set to 64-bit, maintaining compatibility with RV32I while adding support for larger data and addressing spaces.

| `RV32M`             | `31:25`    | `24:20`  | `19:15`  | `14:12` | `11:7`   | `6:0`     |
|  -------------------|  :------:  |  :----:  |  :----:  |  :---:  |  :----:  |  :------: |
| `MUL    RD,RS1,RS2` | `0000001`  | `RS24:0` | `RS14:0` | `000`   | `RD4:0`  | `0110011` |
| `MULH   RD,RS1,RS2` | `0000001`  | `RS24:0` | `RS14:0` | `001`   | `RD4:0`  | `0110011` |
| `MULHSU RD,RS1,RS2` | `0000001`  | `RS24:0` | `RS14:0` | `010`   | `RD4:0`  | `0110011` |
| `MULHU  RD,RS1,RS2` | `0000001`  | `RS24:0` | `RS14:0` | `011`   | `RD4:0`  | `0110011` |
| `DIV    RD,RS1,RS2` | `0000001`  | `RS24:0` | `RS14:0` | `100`   | `RD4:0`  | `0110011` |
| `DIVU   RD,RS1,RS2` | `0000001`  | `RS24:0` | `RS14:0` | `101`   | `RD4:0`  | `0110011` |
| `REM    RD,RS1,RS2` | `0000001`  | `RS24:0` | `RS14:0` | `110`   | `RD4:0`  | `0110011` |
| `REMU   RD,RS1,RS2` | `0000001`  | `RS24:0` | `RS14:0` | `111`   | `RD4:0`  | `0110011` |
: RV32M - Standard Extension for Integer Multiply and Divide (32 bit)

This table outlines the standard extension for integer multiplication and division operations in the 32-bit RISC-V architecture, enhancing computational capabilities with dedicated instructions.

| `RV64M`              | `31:25`    | `24:20`  | `19:15`  | `14:12` | `11:7`   | `6:0`     |
|  --------------------|  :------:  |  :----:  |  :----:  |  :---:  |  :----:  |  :------: |
| `MULW  RD,RS1,RS2`   | `0000001`  | `RS24:0` | `RS14:0` | `000`   | `RD4:0`  | `0111011` |
| `DIVW  RD,RS1,RS2`   | `0000001`  | `RS24:0` | `RS14:0` | `100`   | `RD4:0`  | `0111011` |
| `DIVUW RD,RS1,RS2`   | `0000001`  | `RS24:0` | `RS14:0` | `101`   | `RD4:0`  | `0111011` |
| `REMW  RD,RS1,RS2`   | `0000001`  | `RS24:0` | `RS14:0` | `110`   | `RD4:0`  | `0111011` |
| `REMUW RD,RS1,RS2`   | `0000001`  | `RS24:0` | `RS14:0` | `111`   | `RD4:0`  | `0111011` |
: RV64M - Standard Extension for Integer Multiply and Divide (64 bit)

Extending RV32M to 64-bit, RV64M introduces support for integer multiplication and division operations, catering to applications requiring larger data processing capabilities.

| `RV32A`                     | `31:25`     | `24:20`  | `19:15`  | `14:12` | `11:7`   | `6:0`     |
|  ---------------------------|  :-------:  |  :----:  |  :----:  |  :---:  |  :----:  |  :------: |
| `LR.W      AQRL,RD,RS1`     | `00010AQRL` | `00000`  | `RS14:0` | `010`   | `RD4:0`  | `0101111` |
| `SC.W      AQRL,RD,RS2,RS1` | `00011AQRL` | `RS24:0` | `RS14:0` | `010`   | `RD4:0`  | `0101111` |
| `AMOSWAP.W AQRL,RD,RS2,RS1` | `00001AQRL` | `RS24:0` | `RS14:0` | `010`   | `RD4:0`  | `0101111` |
| `AMOSADD.W AQRL,RD,RS2,RS1` | `00000AQRL` | `RS24:0` | `RS14:0` | `010`   | `RD4:0`  | `0101111` |
| `AMOSXOR.W AQRL,RD,RS2,RS1` | `00100AQRL` | `RS24:0` | `RS14:0` | `010`   | `RD4:0`  | `0101111` |
| `AMOOR.W   AQRL,RD,RS2,RS1` | `01000AQRL` | `RS24:0` | `RS14:0` | `010`   | `RD4:0`  | `0101111` |
| `AMOAMD.W  AQRL,RD,RS2,RS1` | `01100AQRL` | `RS24:0` | `RS14:0` | `010`   | `RD4:0`  | `0101111` |
| `AMOMIN.W  AQRL,RD,RS2,RS1` | `10000AQRL` | `RS24:0` | `RS14:0` | `010`   | `RD4:0`  | `0101111` |
| `AMOMAX.W  AQRL,RD,RS2,RS1` | `10100AQRL` | `RS24:0` | `RS14:0` | `010`   | `RD4:0`  | `0101111` |
| `AMOMINU.W AQRL,RD,RS2,RS1` | `11000AQRL` | `RS24:0` | `RS14:0` | `010`   | `RD4:0`  | `0101111` |
| `AMOMAXU.W AQRL,RD,RS2,RS1` | `11100AQRL` | `RS24:0` | `RS14:0` | `010`   | `RD4:0`  | `0101111` |
: RV32A - Standard Extension for Atomic Instructions (32 bit)

Detailed here are the atomic instruction set extensions for the 32-bit RISC-V architecture, providing concurrency control primitives essential for synchronization in multi-threaded environments.

| `RV64A`                     | `31:25`     | `24:20`  | `19:15`  | `14:12` | `11:7`   | `6:0`     |
|  ---------------------------|  :-------:  |  :----:  |  :----:  |  :---:  |  :----:  |  :------: |
| `LR.D AQRL,RD,RS1`          | `00010AQRL` | `00000`  | `RS14:0` | `011`   | `RD4:0`  | `0101111` |
| `SC.D AQRL,RD,RS2,RS1`      | `00011AQRL` | `RS24:0` | `RS14:0` | `011`   | `RD4:0`  | `0101111` |
| `AMOSWAP.D AQRL,RD,RS2,RS1` | `00001AQRL` | `RS24:0` | `RS14:0` | `011`   | `RD4:0`  | `0101111` |
| `AMOSADD.D AQRL,RD,RS2,RS1` | `00000AQRL` | `RS24:0` | `RS14:0` | `011`   | `RD4:0`  | `0101111` |
| `AMOSXOR.D AQRL,RD,RS2,RS1` | `00100AQRL` | `RS24:0` | `RS14:0` | `011`   | `RD4:0`  | `0101111` |
| `AMOOR.D AQRL,RD,RS2,RS1`   | `01000AQRL` | `RS24:0` | `RS14:0` | `011`   | `RD4:0`  | `0101111` |
| `AMOAMD.D AQRL,RD,RS2,RS1`  | `01100AQRL` | `RS24:0` | `RS14:0` | `011`   | `RD4:0`  | `0101111` |
| `AMOMIN.D AQRL,RD,RS2,RS1`  | `10000AQRL` | `RS24:0` | `RS14:0` | `011`   | `RD4:0`  | `0101111` |
| `AMOMAX.D AQRL,RD,RS2,RS1`  | `10100AQRL` | `RS24:0` | `RS14:0` | `011`   | `RD4:0`  | `0101111` |
| `AMOMINU.D AQRL,RD,RS2,RS1` | `11000AQRL` | `RS24:0` | `RS14:0` | `011`   | `RD4:0`  | `0101111` |
| `AMOMAXU.D AQRL,RD,RS2,RS1` | `11100AQRL` | `RS24:0` | `RS14:0` | `011`   | `RD4:0`  | `0101111` |
: RV64A - Standard Extension for Atomic Instructions (64 bit)

Extending atomic operations to 64-bit, RV64A builds upon RV32A by offering atomic instructions for manipulating memory in a thread-safe manner across larger data sets.

| `RV32F`                          | `31:25`     | `24:20`  | `19:15`  | `14:12` | `11:7`   | `6:0`     |
|  --------------------------------|  :-------:  |  :----:  |  :----:  |  :---:  |  :----:  |  :------: |
| `FLW FRD,RS1`                    | `IIIIIII`   | `IIIII`  | `FRS1`   | `010`   | `FRD`    | `0000111` |
| `FSW FRS2,RS1`                   | `IIIIIII`   | `FRS2`   | `FRS1`   | `010`   | `IIIII`  | `0100111` |
| `FMADD.S RM,FRD,FRS1,FRS2,FRS3`  | `FRS3_00`   | `FRS2`   | `FRS1`   | `RM`    | `FRD`    | `1000011` |
| `FMSUB.S RM,FRD,FRS1,FRS2,FRS3`  | `FRS3_00`   | `FRS2`   | `FRS1`   | `RM`    | `FRD`    | `1000111` |
| `FNMSUB.S RM,FRD,FRS1,FRS2,FRS3` | `FRS3_00`   | `FRS2`   | `FRS1`   | `RM`    | `FRD`    | `1001011` |
| `FNMADD.S RM,FRD,FRS1,FRS2,FRS3` | `FRS3_00`   | `FRS2`   | `FRS1`   | `RM`    | `FRD`    | `1001111` |
| `FADD.S RM,FRD,FRS1,FRS2,FRS3`   | `0000000`   | `FRS2`   | `FRS1`   | `RM`    | `FRD`    | `1010011` |
| `FSUB.S RM,FRD,FRS1,FRS2,FRS3`   | `0000100`   | `FRS2`   | `FRS1`   | `RM`    | `FRD`    | `1010011` |
| `FMUL.S RM,FRD,FRS1,FRS2,FRS3`   | `0001000`   | `FRS2`   | `FRS1`   | `RM`    | `FRD`    | `1010011` |
| `FDIV.S RM,FRD,FRS1,FRS2,FRS3`   | `0001100`   | `FRS2`   | `FRS1`   | `RM`    | `FRD`    | `1010011` |
| `FSGNJ.S FRD,FRS1,FRS2`          | `0010000`   | `FRS2`   | `FRS1`   | `000`   | `FRD`    | `1010011` |
| `FSGNJN.S FRD,FRS1,FRS2`         | `0010000`   | `FRS2`   | `FRS1`   | `001`   | `FRD`    | `1010011` |
| `FSGNJX.S FRD,FRS1,FRS2`         | `0010000`   | `FRS2`   | `FRS1`   | `010`   | `FRD`    | `1010011` |
| `FMIN.S FRD,FRS1,FRS2`           | `0010100`   | `FRS2`   | `FRS1`   | `000`   | `FRD`    | `1010011` |
| `FMAX.S FRD,FRS1,FRS2`           | `0010100`   | `FRS2`   | `FRS1`   | `001`   | `FRD`    | `1010011` |
| `FSQRT.S FRD,FRS1,FRS2`          | `0101100`   | `00000`  | `FRS1`   | `RM`    | `FRD`    | `1010011` |
| `FLE.S FRD,FRS1,FRS2`            | `1010000`   | `FRS2`   | `FRS1`   | `000`   | `FRD`    | `1010011` |
| `FLT.S FRD,FRS1,FRS2`            | `1010000`   | `FRS2`   | `FRS1`   | `001`   | `FRD`    | `1010011` |
| `FEQ.S FRD,FRS1,FRS2`            | `1010000`   | `FRS2`   | `FRS1`   | `010`   | `FRD`    | `1010011` |
| `FCVT.W.S RM,RD,FRS1`            | `1100000`   | `00000`  | `FRS1`   | `RM`    | `FRD`    | `1010011` |
| `FCVT.WU.S RM,RD,FRS1`           | `1100000`   | `00010`  | `FRS1`   | `RM`    | `FRD`    | `1010011` |
| `FCVT.S.W RM,RD,FRS1`            | `1101000`   | `00000`  | `FRS1`   | `RM`    | `FRD`    | `1010011` |
| `FCVT.S.WU RM,RD,FRS1`           | `1101000`   | `00010`  | `FRS1`   | `RM`    | `FRD`    | `1010011` |
| `FMV.X.S RD,FRS1`                | `1110000`   | `00000`  | `FRS1`   | `000`   | `RD`     | `1010011` |
| `FCLASS.S RD,FRS1`               | `1110000`   | `00000`  | `FRS1`   | `001`   | `RD`     | `1010011` |
| `FMV.S.X RD,FRS1`                | `1111000`   | `00000`  | `RS1`    | `000`   | `FRD`    | `1010011` |
| `FRCSR`                          | `0000000`   | `00011`  | `00000`  | `010`   | `RD`     | `1110011` |
| `FRRM`                           | `0000000`   | `00010`  | `00000`  | `010`   | `RD`     | `1110011` |
| `FRFLAGS`                        | `0000000`   | `00001`  | `00000`  | `010`   | `RD`     | `1110011` |
| `FSCSR`                          | `0000000`   | `00011`  | `RS1`    | `001`   | `RD`     | `1110011` |
| `FSRM`                           | `0000000`   | `00010`  | `RS1`    | `001`   | `RD`     | `1110011` |
| `FSFLAGS`                        | `0000000`   | `00001`  | `RS1`    | `001`   | `RD`     | `1110011` |
| `FSRMI`                          | `0000000`   | `00010`  | `00000`  | `101`   | `RD`     | `1110011` |
| `FSFLAGSI`                       | `0000000`   | `00001`  | `00000`  | `101`   | `RD`     | `1110011` |
: RV32F - Standard Extension for Single-Precision Floating-Point (32 bit)

The RV32F table details the single-precision floating-point extension for the 32-bit RISC-V architecture, supporting operations on 32-bit floating-point numbers according to IEEE 754 standards.

| `RV64F`                          | `31:25`     | `24:20`  | `19:15`  | `14:12` | `11:7`   | `6:0`     |
|  --------------------------------|  :-------:  |  :----:  |  :----:  |  :---:  |  :----:  |  :------: |
| `FCVT.L.S RM,RD,FRS1`            | `1100000`   | `00010`  | `FRS1`   | `RM`    | `FRD`    | `1010011` |
| `FCVT.LU.S RM,RD,FRS1`           | `1100000`   | `00011`  | `FRS1`   | `RM`    | `FRD`    | `1010011` |
| `FCVT.S.L RM,RD,FRS1`            | `1101000`   | `00010`  | `FRS1`   | `RM`    | `FRD`    | `1010011` |
| `FCVT.S.LU RM,RD,FRS1`           | `1101000`   | `00011`  | `FRS1`   | `RM`    | `FRD`    | `1010011` |
: RV64F - Standard Extension for Single-Precision Floating-Point (64 bit)

 Expanding on RV32F, RV64F introduces support for single-precision floating-point operations in the 64-bit RISC-V architecture, maintaining compatibility with RV32F for seamless transition.
 
| `RV32D`                          | `31:25`     | `24:20`  | `19:15`  | `14:12` | `11:7`   | `6:0`     |
|  --------------------------------|  :-------:  |  :----:  |  :----:  |  :---:  |  :----:  |  :------: |
| `FLW FRD,RS1`                    | `IIIIIII`   | `IIIII`  | `FRS1`   | `011`   | `FRD`    | `0000111` |
| `FSW FRS2,RS1`                   | `IIIIIII`   | `FRS2`   | `FRS1`   | `011`   | `IIIII`  | `0100111` |
| `FMADD.D RM,FRD,FRS1,FRS2,FRS3`  | `FRS3_01`   | `FRS2`   | `FRS1`   | `RM`    | `FRD`    | `1000011` |
| `FMSUB.D RM,FRD,FRS1,FRS2,FRS3`  | `FRS3_01`   | `FRS2`   | `FRS1`   | `RM`    | `FRD`    | `1000111` |
| `FNMSUB.D RM,FRD,FRS1,FRS2,FRS3` | `FRS3_01`   | `FRS2`   | `FRS1`   | `RM`    | `FRD`    | `1001011` |
| `FNMADD.D RM,FRD,FRS1,FRS2,FRS3` | `FRS3_01`   | `FRS2`   | `FRS1`   | `RM`    | `FRD`    | `1001111` |
| `FADD.D RM,FRD,FRS1,FRS2,FRS3`   | `0000001`   | `FRS2`   | `FRS1`   | `RM`    | `FRD`    | `1010011` |
| `FSUB.D RM,FRD,FRS1,FRS2,FRS3`   | `0000101`   | `FRS2`   | `FRS1`   | `RM`    | `FRD`    | `1010011` |
| `FMUL.D RM,FRD,FRS1,FRS2,FRS3`   | `0001001`   | `FRS2`   | `FRS1`   | `RM`    | `FRD`    | `1010011` |
| `FDIV.D RM,FRD,FRS1,FRS2,FRS3`   | `0001101`   | `FRS2`   | `FRS1`   | `RM`    | `FRD`    | `1010011` |
| `FSGNJ.D FRD,FRS1,FRS2`          | `0010001`   | `FRS2`   | `FRS1`   | `000`   | `FRD`    | `1010011` |
| `FSGNJN.D FRD,FRS1,FRS2`         | `0010001`   | `FRS2`   | `FRS1`   | `001`   | `FRD`    | `1010011` |
| `FSGNJX.D FRD,FRS1,FRS2`         | `0010001`   | `FRS2`   | `FRS1`   | `010`   | `FRD`    | `1010011` |
| `FMIN.D FRD,FRS1,FRS2`           | `0010101`   | `FRS2`   | `FRS1`   | `000`   | `FRD`    | `1010011` |
| `FMAX.D FRD,FRS1,FRS2`           | `0010101`   | `FRS2`   | `FRS1`   | `001`   | `FRD`    | `1010011` |
| `FSQRT.D FRD,FRS1,FRS2`          | `0101101`   | `00000`  | `FRS1`   | `RM`    | `FRD`    | `1010011` |
| `FLE.D FRD,FRS1,FRS2`            | `1010001`   | `FRS2`   | `FRS1`   | `000`   | `FRD`    | `1010011` |
| `FLT.D FRD,FRS1,FRS2`            | `1010001`   | `FRS2`   | `FRS1`   | `001`   | `FRD`    | `1010011` |
| `FEQ.D FRD,FRS1,FRS2`            | `1010001`   | `FRS2`   | `FRS1`   | `010`   | `FRD`    | `1010011` |
| `FCVT.W.D RM,RD,FRS1`            | `1100001`   | `00000`  | `FRS1`   | `RM`    | `FRD`    | `1010011` |
| `FCVT.WU.D RM,RD,FRS1`           | `1100001`   | `00010`  | `FRS1`   | `RM`    | `FRD`    | `1010011` |
| `FCVT.D.W RM,RD,FRS1`            | `1101001`   | `00000`  | `FRS1`   | `RM`    | `FRD`    | `1010011` |
| `FCVT.D.WU RM,RD,FRS1`           | `1101001`   | `00010`  | `FRS1`   | `RM`    | `FRD`    | `1010011` |
| `FCLASS.D RD,FRS1`               | `1110001`   | `00000`  | `FRS1`   | `001`   | `RD`     | `1010011` |
| `FCVT.W.D`                       | `1100001`   | `00000`  | `FRS1`   | `RM`    | `RD`     | `1010011` |
| `FCVT.WU.D`                      | `1100001`   | `00001`  | `FRS1`   | `RM`    | `RD`     | `1010011` |
| `FCVT.D.W`                       | `1101001`   | `00000`  | `FRS1`   | `RM`    | `RD`     | `1010011` |
| `FCVT.D.WU`                      | `1101001`   | `00001`  | `FRS1`   | `RM`    | `RD`     | `1010011` |
: RV32D - Standard Extension for Double-Precision Floating-Point (32 bit)

 This table describes the double-precision floating-point extension for the 32-bit RISC-V architecture, enabling operations on 64-bit floating-point numbers conforming to IEEE 754 standards.

| `RV64D`                          | `31:25`     | `24:20`  | `19:15`  | `14:12` | `11:7`   | `6:0`     |
|  --------------------------------|  :-------:  |  :----:  |  :----:  |  :---:  |  :----:  |  :------: |
| `FCVT.L.D RM,RD,FRS1`            | `1100001`   | `00010`  | `FRS1`   | `RM`    | `FRD`    | `1010011` |
| `FCVT.LU.D RM,RD,FRS1`           | `1100001`   | `00011`  | `FRS1`   | `RM`    | `FRD`    | `1010011` |
| `FCVT.D.L RM,RD,FRS1`            | `1101001`   | `00010`  | `FRS1`   | `RM`    | `FRD`    | `1010011` |
| `FCVT.D.LU RM,RD,FRS1`           | `1101001`   | `00011`  | `FRS1`   | `RM`    | `FRD`    | `1010011` |
| `FMV.X.D RD,FRS1`                | `1110001`   | `00000`  | `FRS1`   | `000`   | `RD`     | `1010011` |
| `FMV.D.X RD,FRS1`                | `1111001`   | `00000`  | `RS1`    | `000`   | `FRD`    | `1010011` |
: RV64D - Standard Extension for Double-Precision Floating-Point (64 bit)

 Building upon RV32D, RV64D extends support for double-precision floating-point operations to the 64-bit RISC-V architecture, facilitating higher precision computations.
