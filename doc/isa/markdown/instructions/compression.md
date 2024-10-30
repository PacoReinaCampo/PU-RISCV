## COMPRESSED INSTRUCTION

RISC-V also includes a compressed instruction set (RVC) to further enhance code density without sacrificing performance. Compressed instructions are 16 bits long and provide a subset of frequently used operations from the base ISA. They are seamlessly integrated with the standard instruction set, allowing compilers and assemblers to automatically select between compressed and uncompressed instructions based on optimization goals and target architecture support.

Format of a line in the table:

`<compressed opcode> <decompressed opcode> [<constraint name> ...]`

`<constraint> is one of imm_6, imm_7, imm_8, imm_9, imm_10, imm_12, imm_18, imm_nz, imm_x2, imm_x4, imm_x8, rd_b3, rs1_b3, rs2_b3, rs1_eq_sp, rd_eq_x0, rs1_eq_x0, rs2_eq_x0, rd_ne_x0, rs1_ne_x0, rs2_ne_x0, rd_eq_rs1, rd_eq_ra, rd_ne_x0_x2, rd_eq_sp`

| c-opcode     | d-opcode                       | constraint name                 |
|--------------|:-------------------------------|:--------------------------------|
| `c.addi4spn` | `addi   imm_10 imm_x4 imm_nz`  | `rd_b3 rs1_eq_sp`               |
| `c.fld`      | `fld    imm_8  imm_x8`         | `rd_b3 rs1_b3`                  |
| `c.lw`       | `lw     imm_7  imm_x4`         | `rd_b3 rs1_b3`                  |
| `c.flw`      | `flw    imm_7  imm_x4`         | `rd_b3 rs1_b3`                  |
| `c.fsd`      | `fsd    imm_8  imm_x8`         | `rs1_b3 rs2_b3`                 |
| `c.sw`       | `sw     imm_7  imm_x4`         | `rs1_b3 rs2_b3`                 |
| `c.fsw`      | `fsw    imm_7  imm_x4`         | `rs1_b3 rs2_b3`                 |
| `c.nop`      | `addi`                         | `rd_eq_x0 rs1_eq_x0 rs2_eq_x0`  |
| `c.addi`     | `addi   simm_6 imm_nz`         | `rd_ne_x0 rd_eq_rs1`            |
| `c.jal`      | `jal    imm_12 imm_x2`         | `rd_eq_ra`                      |
| `c.li`       | `addi   simm_6`                | `rd_ne_x0 rs1_eq_x0`            |
| `c.lui`      | `lui    imm_18 imm_nz`         | `rd_ne_x0_x2`                   |
| `c.addi16sp` | `addi   simm_10 imm_x4 imm_nz` | `rd_eq_sp rs1_eq_sp`            |
| `c.srli`     | `srli   imm_5 imm_nz`          | `rd_eq_rs1 rd_b3 rs1_b3`        |
| `c.srai`     | `srai   imm_5 imm_nz`          | `rd_eq_rs1 rd_b3 rs1_b3`        |
| `c.andi`     | `andi   imm_5 imm_nz`          | `rd_eq_rs1 rd_b3 rs1_b3`        |
| `c.sub`      | `sub`                          | `rd_eq_rs1 rd_b3 rs1_b3 rs2_b3` |
| `c.xor`      | `xor`                          | `rd_eq_rs1 rd_b3 rs1_b3 rs2_b3` |
| `c.or`       | `or`                           | `rd_eq_rs1 rd_b3 rs1_b3 rs2_b3` |
| `c.and`      | `and`                          | `rd_eq_rs1 rd_b3 rs1_b3 rs2_b3` |
| `c.subw`     | `subw`                         | `rd_eq_rs1 rd_b3 rs1_b3 rs2_b3` |
| `c.addw`     | `addw`                         | `rd_eq_rs1 rd_b3 rs1_b3 rs2_b3` |
| `c.j`        | `jal    simm_12 imm_x2`        | `rd_eq_x0`                      |
| `c.beqz`     | `beq    simm_9 imm_x2`         | `rs1_b3 rs2_eq_x0`              |
| `c.bnez`     | `bne    simm_9 imm_x2`         | `rs1_b3 rs2_eq_x0`              |
| `c.slli`     | `slli   imm_5 imm_nz`          | `rd_ne_x0 rd_eq_rs1`            |
| `c.fldsp`    | `fld    imm_9  imm_x8`         | `rs1_eq_sp`                     |
| `c.lwsp`     | `lw     imm_8  imm_x4`         | `rd_ne_x0 rs1_eq_sp`            |
| `c.flwsp`    | `flw    imm_8  imm_x4`         | `rs1_eq_sp`                     |
| `c.jr`       | `jalr   imm_eq_zero`           | `rd_eq_x0 rs1_ne_x0`            |
| `c.mv`       | `addi   imm_eq_zero`           | `rd_ne_x0`                      |
| `c.ebreak`   | `ebreak`                       |                                 |
| `c.jalr`     | `jalr   imm_eq_zero`           | `rd_eq_ra rs1_ne_x0`            |
| `c.add`      | `add`                          | `rd_eq_rs1 rd_ne_x0 rs2_ne_x0`  |
| `c.fsdsp`    | `fsd    imm_9  imm_x8`         | `rs1_eq_sp`                     |
| `c.swsp`     | `sw     imm_8  imm_x4`         | `rs1_eq_sp`                     |
| `c.fswsp`    | `fsw    imm_8  imm_x4`         | `rs1_eq_sp`                     |
| `c.ld`       | `ld     imm_8  imm_x8`         | `rd_b3 rs1_b3`                  |
| `c.sd`       | `sd     imm_8  imm_x8`         | `rs1_b3 rs2_b3`                 |
| `c.lq`       | `lq     imm_9  imm_x16`        |                                 |
| `c.sq`       | `sq     imm_9  imm_x16`        |                                 |
| `c.addiw`    | `addiw  simm_6`                | `rd_ne_x0 rd_eq_rs1`            |
| `c.ldsp`     | `ld     imm_9  imm_x8`         | `rd_ne_x0 rs1_eq_sp`            |
| `c.sdsp`     | `sd     imm_9  imm_x8`         | `rs1_eq_sp`                     |
| `c.lqsp`     | `lq     imm_10 imm_x16`        | `rs1_eq_sp`                     |
| `c.sqsp`     | `sq     imm_10 imm_x16`        | `rs1_eq_sp`                     |

: Compressed Instruction

The compressed instruction table lists specific examples and encodings of instructions that are available in compressed form, demonstrating how these instructions are encoded and decoded within the RISC-V architecture.
