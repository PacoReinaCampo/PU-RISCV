| format                     | implementation                                     |
|----------------------------|----------------------------------------------------|
| add rd, rs1, rs2           | x[rd] = x[rs1] + x[rs2]                            |
| addi rd, rs1, immediate    | x[rd] = x[rs1] + sext(immediate)                   |
| addiw rd, rs1, immediate   | x[rd] = sext((x[rs1] + sext(immediate))[31:0])     |
| addw rd, rs1, rs2          | x[rd] = sext((x[rs1] + x[rs2])[31:0])              |
| amoadd.d rd, rs2, (rs1)    | x[rd] = AMO64(M[x[rs1]] + x[rs2])                  |
| amoadd.w rd, rs2, (rs1)    | x[rd] = AMO32(M[x[rs1]] + x[rs2])                  |
| amoand.d rd, rs2, (rs1)    | x[rd] = AMO64(M[x[rs1]] and x[rs2])                |
| amoand.w rd, rs2, (rs1)    | x[rd] = AMO32(M[x[rs1]] and x[rs2])                |
| amomax.d rd, rs2, (rs1)    | x[rd] = AMO64(M[x[rs1]] MAX x[rs2])                |
| amomax.w rd, rs2, (rs1)    | x[rd] = AMO32(M[x[rs1]] MAX x[rs2])                |
| amomaxu.d rd, rs2, (rs1)   | x[rd] = AMO64(M[x[rs1]] MAXU x[rs2])               |
| amomaxu.w rd, rs2, (rs1)   | x[rd] = AMO32(M[x[rs1]] MAXU x[rs2])               |
| amomin.d rd, rs2, (rs1)    | x[rd] = AMO64(M[x[rs1]] MIN x[rs2])                |
| amomin.w rd, rs2, (rs1)    | x[rd] = AMO32(M[x[rs1]] MIN x[rs2])                |
| amominu.d rd, rs2, (rs1)   | x[rd] = AMO64(M[x[rs1]] MINU x[rs2])               |
| amominu.w rd, rs2, (rs1)   | x[rd] = AMO32(M[x[rs1]] MINU x[rs2])               |
| amoor.d rd, rs2, (rs1)     | x[rd] = AMO64(M[x[rs1]] or x[rs2])                 |
| amoor.w rd, rs2, (rs1)     | x[rd] = AMO32(M[x[rs1]] or x[rs2])                 |
| amoswap.d rd, rs2, (rs1)   | x[rd] = AMO64(M[x[rs1]] SWAP x[rs2])               |
| amoswap.w rd, rs2, (rs1)   | x[rd] = AMO32(M[x[rs1]] SWAP x[rs2])               |
| amoxor.d rd, rs2, (rs1)    | x[rd] = AMO64(M[x[rs1]] ^ x[rs2])                  |
| amoxor.w rd, rs2, (rs1)    | x[rd] = AMO32(M[x[rs1]] ^ x[rs2])                  |
| and rd, rs1, rs2           | x[rd] = x[rs1] and x[rs2]                          |
| andi rd, rs1, immediate    | x[rd] = x[rs1] and sext(immediate)                 |
| auipc rd, immediate        | x[rd] = pc + sext(immediate[31:12] << 12)          |
| beq rs1, rs2, offset       | if (rs1 == rs2) pc += sext(offset)                 |
| beqz rs1, offset           | if (rs1 == 0) pc += sext(offset)                   |
| bge rs1, rs2, offset       | if (rs1 >=s rs2) pc += sext(offset)                |
| bgeu rs1, rs2, offset      | if (rs1 >=u rs2) pc += sext(offset)                |
| bgez rs1, offset           | if (rs1 >=s 0) pc += sext(offset)                  |
| bgt rs1, rs2, offset       | if (rs1 >s rs2) pc += sext(offset)                 |
| bgtu rs1, rs2, offset      | if (rs1 >u rs2) pc += sext(offset)                 |
| bgtz rs2, offset           | if (rs2 >s 0) pc += sext(offset)                   |
| ble rs1, rs2, offset       | if (rs1 <=s rs2) pc += sext(offset)                |
| bleu rs1, rs2, offset      | if (rs1 <=u rs2) pc += sext(offset)                |
| blez rs2, offset           | if (rs2 <=s 0) pc += sext(offset)                  |
| blt rs1, rs2, offset       | if (rs1 <s rs2) pc += sext(offset)                 |
| bltz rs1, offset           | if (rs1 <s 0) pc += sext(offset)                   |
| bltu rs1, rs2, offset      | if (rs1 <u rs2) pc += sext(offset)                 |
| bne rs1, rs2, offset       | if (rs1 == rs2) pc += sext(offset)                 |
| bnez rs1, offset           | if (rs1 != 0) pc += sext(offset)                   |
| c.add rd, rs2              | x[rd] = x[rd] + x[rs2]                             |
| c.addi rd, imm             | x[rd] = x[rd] + sext(imm)                          |
| c.addi16sp imm             | x[2] = x[2] + sext(imm)                            |
| c.addi4spn rd', uimm       | x[8+rd'] = x[2] + uimm                             |
| c.addiw rd, imm            | x[rd] = sext((x[rd] + sext(imm))[31:0])            |
| c.and rd', rs2'            | x[8+rd'] = x[8+rd'] and x[8+rs2']                  |
| c.addw rd', rs2'           | x[8+rd'] = sext((x[8+rd'] + x[8+rs2'])[31:0])      |
| c.a ndi rd', imm           | x[8+rd'] = x[8+rd'] and sext(imm)                  |
| c.b eqz rs1', offset       | if (x[8+rs1'] == 0) pc += sext(offset)             |
| c.bnez rs1', offset        | if (x[8+rs1'] != 0) pc += sext(offset)             |
| c.ebreak                   | RaiseException(Breakpoint)                         |
| c.fld rd', uimm(rs1')      | f[8+rd'] = M[x[8+rs1'] + uimm][63:0]               |
| c.fldsp rd, uimm(x2)       | f[rd] = M[x[2] + uimm][63:0]                       |
| c.flw rd', uimm(rs1')      | f[8+rd'] = M[x[8+rs1'] + uimm][31:0]               |
| c.flwsp rd, uimm(x2)       | f[rd] = M[x[2] + uimm][31:0]                       |
| c.fsd rs2', uimm(rs1')     | M[x[8+rs1'] + uimm][63:0] = f[8+rs2']              |
| c.fsdsp rs2, uimm(x2)      | M[x[2] + uimm][63:0] = f[rs2]                      |
| c.fsw rs2', uimm(rs1')     | M[x[8+rs1'] + uimm][31:0] = f[8+rs2']              |
| c.fswsp rs2, uimm(x2)      | M[x[2] + uimm][31:0] = f[rs2]                      |
| c.j offset                 | pc += sext(offset)                                 |
| c.jal offset               | x[1] = pc+2; pc += sext(offset)                    |
| c.jalr rs1                 | t = pc+2; pc = x[rs1]; x[1] = t                    |
| c.jr rs1                   | pc = x[rs1]                                        |
| c.ld rd', uimm(rs1')       | x[8+rd'] = M[x[8+rs1'] + uimm][63:0]               |
| c.ldsp rd, uimm(x2)        | x[rd] = M[x[2] + uimm][63:0]                       |
| c.li rd, imm               | x[rd] = sext(imm)                                  |
| c.lui rd, imm              | x[rd] = sext(imm[17:12] << 12)                     |
| c.lw rd', uimm(rs1')       | x[8+rd'] = sext(M[x[8+rs1'] + uimm][31:0])         |
| c.lwsp rd, uimm(x2)        | x[rd] = sext(M[x[2] + uimm][31:0])                 |
| c.mv rd, rs2               | x[rd] = x[rs2]                                     |
| c.or rd', rs2'             | x[8+rd'] = x[8+rd'] or x[8+rs2']                   |
| c.sd rs2', uimm(rs1')      | M[x[8+rs1'] + uimm][63:0] = x[8+rs2']              |
| c.sdsp rs2, uimm(x2)       | M[x[2] + uimm][63:0] = x[rs2]                      |
| c.slli rd, uimm            | x[rd] = x[rd] << uimm                              |
| c.srai rd', uimm           | x[8+rd'] = x[8+rd'] >>s uimm                       |
| c.srli rd', uimm           | x[8+rd'] = x[8+rd'] >>u uimm                       |
| c.sub rd', rs2'            | x[8+rd'] = x[8+rd'] - x[8+rs2']                    |
| c.subw rd', rs2'           | x[8+rd'] = sext((x[8+rd'] - x[8+rs2'])[31:0])      |
| c.sw rs2', uimm(rs1')      | M[x[8+rs1'] + uimm][31:0] = x[8+rs2']              |
| c.swsp rs2, uimm(x2)       | M[x[2] + uimm][31:0] = x[rs2]                      |
| c.xor rd', rs2'            | x[8+rd'] = x[8+rd'] ^ x[8+rs2']                    |
| call rd, symbol            | x[rd] = pc+8; pc = &symbol                         |
| csrr rd, csr               | x[rd] = CSRs[csr]                                  |
| csrc csr, rs1              | CSRs[csr] and= ~x[rs1]                             |
| csrci csr, zimm[4:0]       | CSRs[csr] and= ~zimm                               |
| csrrc rd, csr, rs1         | t = CSRs[csr]; CSRs[csr] = t and x[rs1]; x[rd] = t |
| csrrci rd, csr, zimm[4:0]  | t = CSRs[csr]; CSRs[csr] = t and ~zimm; x[rd] = t  |
| csrrs rd, csr, rs1         | t = CSRs[csr]; CSRs[csr] = t or x[rs1]; x[rd] = t  |
| csrrsi rd, csr, zimm[4:0]  | t = CSRs[csr]; CSRs[csr] = t or zimm; x[rd] = t    |
| csrrw rd, csr, rs1         | t = CSRs[csr]; CSRs[csr] = x[rs1]; x[rd] = t       |
| csrrwi rd, csr, zimm[4:0]  | x[rd] = CSRs[csr]; CSRs[csr] = zimm                |
| csrs csr, rs1              | CSRs[csr] or= x[rs1]                               |
| csrsi csr, zimm[4:0]       | CSRs[csr] or= zimm                                 |
| csrw csr, rs1              | CSRs[csr] = x[rs1]                                 |
| csrwi csr, zimm[4:0]       | CSRs[csr] = zimm                                   |
| div rd, rs1, rs2           | x[rd] = x[rs1] /s x[rs2]                           |
| divu rd, rs1, rs2          | x[rd] = x[rs1] /u x[rs2]                           |
| divuw rd, rs1, rs2         | x[rd] = sext(x[rs1][31:0] /u x[rs2][31:0])         |
| divw rd, rs1, rs2          | x[rd] = sext(x[rs1][31:0] /s x[rs2][31:0])         |
| ebreak                     | RaiseException(Breakpoint)                         |
| ecall                      | RaiseException(EnvironmentCall)                    |
| fabs.d rd, rs1             | f[rd] = f[rs1]                                     |
| fabs.s rd, rs1             | f[rd] = f[rs1]                                     |
| fadd.d rd, rs1, rs2        | f[rd] = f[rs1] + f[rs2]                            |
| fadd.s rd, rs1, rs2        | f[rd] = f[rs1] + f[rs2]                            |
| fclass.d rd, rs1, rs2      | x[rd] = classifyd(f[rs1])                          |
| fclass.s rd, rs1, rs2      | x[rd] = classifys(f[rs1])                          |
| fcvt.d.l rd, rs1, rs2      | f[rd] = f64s64(x[rs1])                             |
| fcvt.d.lu rd, rs1, rs2     | f[rd] = f64u64(x[rs1])                             |
| fcvt.d.s rd, rs1, rs2      | f[rd] = f64f32(f[rs1])                             |
| fcvt.d.w rd, rs1, rs2      | f[rd] = f64s32(x[rs1])                             |
| fcvt.d.wu rd, rs1, rs2     | f[rd] = f64u32(x[rs1])                             |
| fcvt.l.d rd, rs1, rs2      | x[rd] = s64f64(f[rs1])                             |
| fcvt.l.s rd, rs1, rs2      | x[rd] = s64f32(f[rs1])                             |
| fcvt.lu.d rd, rs1, rs2     | x[rd] = u64f64(f[rs1])                             |
| fcvt.lu.s rd, rs1, rs2     | x[rd] = u64f32(f[rs1])                             |
| fcvt.s.d rd, rs1, rs2      | f[rd] = f32f64(f[rs1])                             |
| fcvt.s.l rd, rs1, rs2      | f[rd] = f32s64(x[rs1])                             |
| fcvt.s.lu rd, rs1, rs2     | f[rd] = f32u64(x[rs1])                             |
| fcvt.s.w rd, rs1, rs2      | f[rd] = f32s32(x[rs1])                             |
| fcvt.s.wu rd, rs1, rs2     | f[rd] = f32u32(x[rs1])                             |
| fcvt.w.d rd, rs1, rs2      | x[rd] = sext(s32f64(f[rs1]))                       |
| fcvt.wu.d rd, rs1, rs2     | x[rd] = sext(u32f64(f[rs1]))                       |
| fcvt.w.s rd, rs1, rs2      | x[rd] = sext(s32f32(f[rs1]))                       |
| fcvt.wu.s rd, rs1, rs2     | x[rd] = sext(u32f32(f[rs1]))                       |
| fdiv.d rd, rs1, rs2        | f[rd] = f[rs1] / f[rs2]                            |
| fdiv.s rd, rs1, rs2        | f[rd] = f[rs1] / f[rs2]                            |
| fence pred, succ           | fence(pred, succ)                                  |
| fence.i                    | fence(Store, Fetch)                                |
| feq.d rd, rs1, rs2         | x[rd] = f[rs1] == f[rs2]                           |
| feq.s rd, rs1, rs2         | x[rd] = f[rs1] == f[rs2]                           |
| fld rd, offset(rs1)        | f[rd] = M[x[rs1] + sext(offset)][63:0]             |
| fle.d rd, rs1, rs2         | x[rd] = f[rs1] or f[rs2]                           |
| fle.s rd, rs1, rs2         | x[rd] = f[rs1] or f[rs2]                           |
| flt.d rd, rs1, rs2         | x[rd] = f[rs1] < f[rs2]                            |
| flt.s rd, rs1, rs2         | x[rd] = f[rs1] < f[rs2]                            |
| flw rd, offset(rs1)        | f[rd] = M[x[rs1] + sext(offset)][31:0]             |
| fmadd.d rd, rs1, rs2, rs3  | f[rd] = f[rs1] f[rs2]+f[rs3]                       |
| fmadd.s rd, rs1, rs2, rs3  | f[rd] = f[rs1] f[rs2]+f[rs3]                       |
| fmax.d rd, rs1, rs2        | f[rd] = max(f[rs1], f[rs2])                        |
| fmax.s rd, rs1, rs2        | f[rd] = max(f[rs1], f[rs2])                        |
| fmin.d rd, rs1, rs2        | f[rd] = min(f[rs1], f[rs2])                        |
| fmin.s rd, rs1, rs2        | f[rd] = min(f[rs1], f[rs2])                        |
| fmsub.d rd, rs1, rs2, rs3  | f[rd] = f[rs1] * f[rs2] - f[rs3]                   |
| fmsub.s rd, rs1, rs2, rs3  | f[rd] = f[rs1] * f[rs2] - f[rs3]                   |
| fmul.d rd, rs1, rs2        | f[rd] = f[rs1] * f[rs2]                            |
| fmul.s rd, rs1, rs2        | f[rd] = f[rs1] * f[rs2]                            |
| fmv.d rd, rs1              | f[rd] = f[rs1]                                     |
| fmv.d.x rd, rs1, rs2       | f[rd] = x[rs1][63:0]                               |
| fmv.s rd, rs1              | f[rd] = f[rs1]                                     |
| fmv.w.x rd, rs1, rs2       | f[rd] = x[rs1][31:0]                               |
| fmv.x.d rd, rs1, rs2       | x[rd] = f[rs1][63:0]                               |
| fmv.x.w rd, rs1, rs2       | x[rd] = sext(f[rs1][31:0])                         |
| fneg.d rd, rs1             | f[rd] = -f[rs1]                                    |
| fneg.s rd, rs1             | f[rd] = -f[rs1]                                    |
| fnmadd.d rd, rs1, rs2, rs3 | f[rd] = -f[rs1] * f[rs2] - f[rs3]                  |
| fnmadd.s rd, rs1, rs2, rs3 | f[rd] = -f[rs1] * f[rs2] - f[rs3]                  |
| fnmsub.d rd, rs1, rs2, rs3 | f[rd] = -f[rs1] * f[rs2] + f[rs3]                  |
| fnmsub.s rd, rs1, rs2, rs3 | f[rd] = -f[rs1] * f[rs2] + f[rs3]                  |
| frcsr rd                   | x[rd] = CSRs[fcsr]                                 |
| frflags rd                 | x[rd] = CSRs[fflags]                               |
| frrm rd                    | x[rd] = CSRs[frm]                                  |
| fscsr rd, rs1              | t = CSRs[fcsr]; CSRs[fcsr] = x[rs1]; x[rd] = t     |
| fsd rs2, offset(rs1)       | M[x[rs1] + sext(offset)] = f[rs2][63:0]            |
| fsflags rd, rs1            | t = CSRs[fflags]; CSRs[fflags] = x[rs1]; x[rd] = t |
| fsgnj.d rd, rs1, rs2       | f[rd] = {f[rs2][63], f[rs1][62:0]}                 |
| fsgnj.s rd, rs1, rs2       | f[rd] = {f[rs2][31], f[rs1][30:0]}                 |
| fsgnjn.d rd, rs1, rs2      | f[rd] = {f[rs2][63], f[rs1][62:0]}                 |
| fsgnjn.s rd, rs1, rs2      | f[rd] = { f[rs2][31], f[rs1][30:0]}                |
| fsgnjx.d rd, rs1, rs2      | f[rd] = {f[rs1][63] ^ f[rs2][63], f[rs1][62:0]}    |
| fsgnjx.s rd, rs1, rs2      | f[rd] = {f[rs1][31] ^ f[rs2][31], f[rs1][30:0]}    |
| fsqrt.d rd, rs1, rs2       | f[rd] = √f[rs1]                                    |
| fsqrt.s rd, rs1, rs2       | f[rd] = √f[rs1]                                    |
| fsrm rd, rs1               | t = CSRs[frm]; CSRs[frm] = x[rs1]; x[rd] = t       |
| fsub.d rd, rs1, rs2        | f[rd] = f[rs1] - f[rs2]                            |
| fsub.s rd, rs1, rs2        | f[rd] = f[rs1] - f[rs2]                            |
| fsw rs2, offset(rs1)       | M[x[rs1] + sext(offset)] = f[rs2][31:0]            |
| j offset                   | pc += sext(offset)                                 |
| jal rd, offset             | x[rd] = pc+4; pc += sext(offset)                   |
| jalr rd, offset(rs1)       | t = pc+4; pc = (x[rs1]+sext(offset))& 1; x[rd]=t   |
| jr rs1                     | pc = x[rs1]                                        |
| la rd, symbol              | x[rd] = &symbol                                    |
| lb rd, offset(rs1)         | x[rd] = sext(M[x[rs1] + sext(offset)][7:0])        |
| lbu rd, offset(rs1)        | x[rd] = M[x[rs1] + sext(offset)][7:0]              |
| ld rd, offset(rs1)         | x[rd] = M[x[rs1] + sext(offset)][63:0]             |
| lh rd, offset(rs1)         | x[rd] = sext(M[x[rs1] + sext(offset)][15:0])       |
| lhu rd, offset(rs1)        | x[rd] = M[x[rs1] + sext(offset)][15:0]             |
| li rd, immediate           | x[rd] = immediate                                  |
| lla rd, symbol             | x[rd] = &symbol                                    |
| lr.d rd, (rs1)             | x[rd] = LoadReserved64(M[x[rs1]])                  |
| lr.w rd, (rs1)             | x[rd] = LoadReserved32(M[x[rs1]])                  |
| lw rd, offset(rs1)         | x[rd] = sext(M[x[rs1] + sext(offset)][31:0])       |
| lwu rd, offset(rs1)        | x[rd] = M[x[rs1] + sext(offset)][31:0]             |
| lui rd, immediate          | x[rd] = sext(immediate[31:12] << 12)               |
| mret                       | ExceptionReturn(Machine)                           |
| mul rd, rs1, rs2           | x[rd] = x[rs1] * x[rs2]                            |
| mulh rd, rs1, rs2          | x[rd] = (x[rs1] s*s x[rs2]) >>s XLEN               |
| mulhsu rd, rs1, rs2        | x[rd] = (x[rs1] s u x[rs2]) >>s XLEN               |
| mulhu rd, rs1, rs2         | x[rd] = (x[rs1] u u x[rs2]) >>u XLEN               |
| mulw rd, rs1, rs2          | x[rd] = sext((x[rs1] * x[rs2])[31:0])              |
| mv rd, rs1                 | x[rd] = x[rs1]                                     |
| neg rd, rs2                | x[rd] = -x[rs2]                                    |
| negw rd, rs2               | x[rd] = sext((-x[rs2])[31:0])                      |
| nop                        | Nothing                                            |
| not rd, rs1                | x[rd] = ~x[rs1]                                    |
| or rd, rs1, rs2            | x[rd] = x[rs1] or x[rs2]                           |
| ori rd, rs1, immediate     | x[rd] = x[rs1] or sext(immediate)                  |
| rdcycle rd                 | x[rd] = CSRs[cycle]                                |
| rdcycleh rd                | x[rd] = CSRs[cycleh]                               |
| rdinstret rd               | x[rd] = CSRs[instret]                              |
| rdinstreth rd              | x[rd] = CSRs[instreth]                             |
| rdtime rd                  | x[rd] = CSRs[time]                                 |
| rdtimeh rd                 | x[rd] = CSRs[timeh]                                |
| rem rd, rs1, rs2           | x[rd] = x[rs1] %s x[rs2]                           |
| remu rd, rs1, rs2          | x[rd] = x[rs1] %u x[rs2]                           |
| remuw rd, rs1, rs2         | x[rd] = sext(x[rs1][31:0] %u x[rs2][31:0])         |
| remw rd, rs1, rs2          | x[rd] = sext(x[rs1][31:0] %s x[rs2][31:0])         |
| ret                        | pc = x[1]                                          |
| sb rs2, offset(rs1)        | M[x[rs1] + sext(offset)] = x[rs2][7:0]             |
| sc.d rd, rs2, (rs1)        | x[rd] = StoreConditional64(M[x[rs1]], x[rs2])      |
| sc.w rd, rs2, (rs1)        | x[rd] = StoreConditional32(M[x[rs1]], x[rs2])      |
| sd rs2, offset(rs1)        | M[x[rs1] + sext(offset)] = x[rs2][63:0]            |
| seqz rd, rs1               | x[rd] = (x[rs1] == 0)                              |
| sext.w rd, rs1             | x[rd] = sext(x[rs1][31:0])                         |
| sfence.vma rs1, rs2        | fence(Store, AddressTranslation)                   |
| sgtz rd, rs2               | x[rd] = (x[rs2] >s 0)                              |
| sh rs2, offset(rs1)        | M[x[rs1] + sext(offset)] = x[rs2][15:0]            |
| sw rs2, offset(rs1)        | M[x[rs1] + sext(offset)] = x[rs2][31:0]            |
| sll rd, rs1, rs2           | x[rd] = x[rs1] << x[rs2]                           |
| slli rd, rs1, shamt        | x[rd] = x[rs1] << shamt                            |
| slliw rd, rs1, shamt       | x[rd] = sext((x[rs1] << shamt)[31:0])              |
| sllw rd, rs1, rs2          | x[rd] = sext((x[rs1] << x[rs2][4:0])[31:0])        |
| slt rd, rs1, rs2           | x[rd] = x[rs1] <s x[rs2]                           |
| slti rd, rs1, immediate    | x[rd] = x[rs1] <s sext(immediate)                  |
| sltiu rd, rs1, immediate   | x[rd] = x[rs1] <u sext(immediate)                  |
| sltu rd, rs1, rs2          | x[rd] = x[rs1] <u x[rs2]                           |
| sltz rd, rs1               | x[rd] = (x[rs1] <s 0)                              |
| snez rd, rs2               | x[rd] = (x[rs2] = 0)                               |
| sra rd, rs1, rs2           | x[rd] = x[rs1] >>s x[rs2]                          |
| srai rd, rs1, shamt        | x[rd] = x[rs1] >>s shamt                           |
| sraiw rd, rs1, shamt       | x[rd] = sext(x[rs1][31:0] >>s shamt)               |
| sraw rd, rs1, rs2          | x[rd] = sext(x[rs1][31:0] >>s x[rs2][4:0])         |
| sret                       | ExceptionReturn(Supervisor)                        |
| srl rd, rs1, rs2           | x[rd] = x[rs1] >>u x[rs2]                          |
| srli rd, rs1, shamt        | x[rd] = x[rs1] >>u shamt                           |
| srliw rd, rs1, shamt       | x[rd] = sext(x[rs1][31:0] >>u shamt)               |
| srlw rd, rs1, rs2          | x[rd] = sext(x[rs1][31:0] >>u x[rs2][4:0])         |
| sub rd, rs1, rs2           | x[rd] = x[rs1] - x[rs2]                            |
| subw rd, rs1, rs2          | x[rd] = sext((x[rs1] - x[rs2])[31:0])              |
| tail symbol                | pc = &symbol; clobber x[6]                         |
| wfi                        | while (noInterruptsPending) idle                   |
| xor rd, rs1, rs2           | x[rd] = x[rs1] ^ x[rs2]                            |
| xori rd, rs1, immediate    | x[rd] = x[rs1] ^ sext(immediate)                   |
