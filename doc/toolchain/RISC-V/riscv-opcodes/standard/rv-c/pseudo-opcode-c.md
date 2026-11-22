## PSEUDO-INSTRUCTIONS

| **Extension** | **Name** | **Variable-Fields**      | **Pseudo-Instruction** | **Encoding**                       |
|:--------------|:---------|:-------------------------|:-----------------------|:-----------------------------------|
| `rv64_c`      | `c_srli` | `rd_rs1_p, c_nzuimm5`    | `c_srli`               | `----------------100000--------01` |
| `rv64_c`      | `c_srai` | `rd_rs1_p, c_nzuimm5`    | `c_srai`               | `----------------100001--------01` |
| `rv64_c`      | `c_slli` | `rd_rs1_n0, c_nzuimm6lo` | `c_slli`               | `----------------0000----------10` |
| `rv64_c`      | `c_srli` | `rd_rs1_p, c_nzuimm5`    | `c_srli_rv32`          | `----------------100000--------01` |
| `rv64_c`      | `c_srai` | `rd_rs1_p, c_nzuimm5`    | `c_srai_rv32`          | `----------------100001--------01` |
| `rv64_c`      | `c_slli` | `rd_rs1_n0, c_nzuimm6lo` | `c_slli_rv32`          | `----------------0000----------10` |

:RV64C - RV64C Standard Extension for Compressed Instructions (+ RV32C)
