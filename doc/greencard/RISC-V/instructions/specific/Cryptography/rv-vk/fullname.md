## INSTRUCTION FULL-NAMES

| **Extension** | **Name**     | **Variable-Fields**             | **Full-Name**                                        |
|:--------------|:-------------|:--------------------------------|:-----------------------------------------------------|
| `rv_zvkg`     | `vghsh_vv`   | `vs2, vs1, vd`                  | `Vector GHASH Add-Multiply`                          |
| `rv_zvkg`     | `vgmul_vv`   | `vs2, vd`                       | `Vector GHASH Multiply`                              |
| `rv_zvkned`   | `vaesdf_vs`  | `vs2, vd`                       | `Vector AES Final-Round Decryption (Vector-Scalar)`  |
| `rv_zvkned`   | `vaesdf_vv`  | `vs2, vd`                       | `Vector AES Final-Round Decryption (Vector-Vector)`  |
| `rv_zvkned`   | `vaesdm_vs`  | `vs2, vd`                       | `Vector AES Middle-Round Decryption (Vector-Scalar)` |
| `rv_zvkned`   | `vaesdm_vv`  | `vs2, vd`                       | `Vector AES Middle-Round Decryption (Vector-Vector)` |
| `rv_zvkned`   | `vaesef_vs`  | `vs2, vd`                       | `Vector AES Final-Round Encryption (Vector-Scalar)`  |
| `rv_zvkned`   | `vaesef_vv`  | `vs2, vd`                       | `Vector AES Final-Round Encryption (Vector-Vector)`  |
| `rv_zvkned`   | `vaesem_vs`  | `vs2, vd`                       | `Vector AES Middle-Round Encryption (Vector-Scalar)` |
| `rv_zvkned`   | `vaesem_vv`  | `vs2, vd`                       | `Vector AES Middle-Round Encryption (Vector-Vector)` |
| `rv_zvkned`   | `vaeskf1_vi` | `vs2, zimm5, vd`                | `Vector AES-128 Forward Key Schedule`                |
| `rv_zvkned`   | `vaeskf2_vi` | `vs2, zimm5, vd`                | `Vector AES-256 Forward Key Schedule`                |
| `rv_zvkned`   | `vaesz_vs`   | `vs2, vd`                       | `Vector AES Round Zero AddRoundKey (Vector-Scalar)`  |
| `rv_zvknha`   | `vsha2ch_vv` | `vs2, vs1, vd`                  | `Vector SHA-2 Two Compression Rounds (High Words)`   |
| `rv_zvknha`   | `vsha2cl_vv` | `vs2, vs1, vd`                  | `Vector SHA-2 Two Compression Rounds (Low Words)`    |
| `rv_zvknha`   | `vsha2ms_vv` | `vs2, vs1, vd`                  | `Vector SHA-2 Message Schedule`                      |
| `rv_zvknhb`   | `vsha2ch_vv` | `vs2, vs1, vd`                  | `Vector SHA-2 Two Compression Rounds (High Words)`   |
| `rv_zvknhb`   | `vsha2cl_vv` | `vs2, vs1, vd`                  | `Vector SHA-2 Two Compression Rounds (Low Words)`    |
| `rv_zvknhb`   | `vsha2ms_vv` | `vs2, vs1, vd`                  | `Vector SHA-2 Message Schedule`                      |
| `rv_zvkn`     | `vaesdf_vs`  | `vs2, vd`                       | `Vector AES Final-Round Decryption (Vector-Scalar)`  |
| `rv_zvkn`     | `vaesdf_vv`  | `vs2, vd`                       | `Vector AES Final-Round Decryption (Vector-Vector)`  |
| `rv_zvkn`     | `vaesdm_vs`  | `vs2, vd`                       | `Vector AES Middle-Round Decryption (Vector-Scalar)` |
| `rv_zvkn`     | `vaesdm_vv`  | `vs2, vd`                       | `Vector AES Middle-Round Decryption (Vector-Vector)` |
| `rv_zvkn`     | `vaesef_vs`  | `vs2, vd`                       | `Vector AES Final-Round Encryption (Vector-Scalar)`  |
| `rv_zvkn`     | `vaesef_vv`  | `vs2, vd`                       | `Vector AES Final-Round Encryption (Vector-Vector)`  |
| `rv_zvkn`     | `vaesem_vs`  | `vs2, vd`                       | `Vector AES Middle-Round Encryption (Vector-Scalar)` |
| `rv_zvkn`     | `vaesem_vv`  | `vs2, vd`                       | `Vector AES Middle-Round Encryption (Vector-Vector)` |
| `rv_zvkn`     | `vaeskf1_vi` | `vs2, zimm5, vd`                | `Vector AES-128 Forward Key Schedule`                |
| `rv_zvkn`     | `vaeskf2_vi` | `vs2, zimm5, vd`                | `Vector AES-256 Forward Key Schedule`                |
| `rv_zvkn`     | `vaesz_vs`   | `vs2, vd`                       | `Vector AES Round Zero AddRoundKey (Vector-Scalar)`  |
| `rv_zvkn`     | `vandn_vv`   | `vm, vs2, vs1, vd`              | `Vector Bitwise AND-NOT (Vector-Vector)`             |
| `rv_zvkn`     | `vandn_vx`   | `vm, vs2, rs1, vd`              | `Vector Bitwise AND-NOT (Vector-Scalar)`             |
| `rv_zvkn`     | `vbrev8_v`   | `vm, vs2, vd`                   | `Vector Reverse Bits in Bytes`                       |
| `rv_zvkn`     | `vrev8_v`    | `vm, vs2, vd`                   | `Vector Reverse Bytes`                               |
| `rv_zvkn`     | `vrol_vv`    | `vm, vs2, vs1, vd`              | `Vector Rotate Left (Vector-Vector)`                 |
| `rv_zvkn`     | `vrol_vx`    | `vm, vs2, rs1, vd`              | `Vector Rotate Left (Vector-Scalar)`                 |
| `rv_zvkn`     | `vror_vi`    | `zimm6hi, vm, vs2, zimm6lo, vd` | `Vector Rotate Right (Vector-Immediate)`             |
| `rv_zvkn`     | `vror_vv`    | `vm, vs2, vs1, vd`              | `Vector Rotate Right (Vector-Vector)`                |
| `rv_zvkn`     | `vror_vx`    | `vm, vs2, rs1, vd`              | `Vector Rotate Right (Vector-Scalar)`                |
| `rv_zvkn`     | `vsha2ch_vv` | `vs2, vs1, vd`                  | `Vector SHA-2 Two Compression Rounds (High Words)`   |
| `rv_zvkn`     | `vsha2cl_vv` | `vs2, vs1, vd`                  | `Vector SHA-2 Two Compression Rounds (Low Words)`    |
| `rv_zvkn`     | `vsha2ms_vv` | `vs2, vs1, vd`                  | `Vector SHA-2 Message Schedule`                      |
| `rv_zvksed`   | `vsm4k_vi`   | `vs2, zimm5, vd`                | `Vector SM4 Key Expansion`                           |
| `rv_zvksed`   | `vsm4r_vs`   | `vs2, vd`                       | `Vector SM4 Four Rounds (Vector-Scalar)`             |
| `rv_zvksed`   | `vsm4r_vv`   | `vs2, vd`                       | `Vector SM4 Four Rounds (Vector-Vector)`             |
| `rv_zvksh`    | `vsm3c_vi`   | `vs2, zimm5, vd`                | `Vector SM3 Two Compression Rounds`                  |
| `rv_zvksh`    | `vsm3me_vv`  | `vs2, vs1, vd`                  | `Vector SM3 Message Expansion`                       |
| `rv_zvks`     | `vandn_vv`   | `vm, vs2, vs1, vd`              | `Vector Bitwise AND-NOT (Vector-Vector)`             |
| `rv_zvks`     | `vandn_vx`   | `vm, vs2, rs1, vd`              | `Vector Bitwise AND-NOT (Vector-Scalar)`             |
| `rv_zvks`     | `vbrev8_v`   | `vm, vs2, vd`                   | `Vector Reverse Bits in Bytes`                       |
| `rv_zvks`     | `vrev8_v`    | `vm, vs2, vd`                   | `Vector Reverse Bytes`                               |
| `rv_zvks`     | `vrol_vv`    | `vm, vs2, vs1, vd`              | `Vector Rotate Left (Vector-Vector)`                 |
| `rv_zvks`     | `vrol_vx`    | `vm, vs2, rs1, vd`              | `Vector Rotate Left (Vector-Scalar)`                 |
| `rv_zvks`     | `vror_vi`    | `zimm6hi, vm, vs2, zimm6lo, vd` | `Vector Rotate Right (Vector-Immediate)`             |
| `rv_zvks`     | `vror_vv`    | `vm, vs2, vs1, vd`              | `Vector Rotate Right (Vector-Vector)`                |
| `rv_zvks`     | `vror_vx`    | `vm, vs2, rs1, vd`              | `Vector Rotate Right (Vector-Scalar)`                |
| `rv_zvks`     | `vsm3c_vi`   | `vs2, zimm5, vd`                | `Vector SM3 Two Compression Rounds`                  |
| `rv_zvks`     | `vsm3me_vv`  | `vs2, vs1, vd`                  | `Vector SM3 Message Expansion`                       |
| `rv_zvks`     | `vsm4k_vi`   | `vs2, zimm5, vd`                | `Vector SM4 Key Expansion`                           |
| `rv_zvks`     | `vsm4r_vs`   | `vs2, vd`                       | `Vector SM4 Four Rounds (Vector-Scalar)`             |
| `rv_zvks`     | `vsm4r_vv`   | `vs2, vd`                       | `Vector SM4 Four Rounds (Vector-Vector)`             |

:RVZVK - Specific Extension for Vector Cryptography Instructions
