## GENERAL PURPOSE REGISTER DESCRIPTIONS

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
