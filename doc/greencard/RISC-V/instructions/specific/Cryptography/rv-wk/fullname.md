## INSTRUCTION FULL-NAMES

| **Extension** | **Name**     | **Variable-Fields**             | **Full-Name**                                        |
|:--------------|:-------------|:--------------------------------|:-----------------------------------------------------|
| `rv_zwkg`     | `wghsh_ww`   | `ws2, ws1, wd`                  | `Matrix GHASH Add-Multiply`                          |
| `rv_zwkg`     | `wgmul_ww`   | `ws2, wd`                       | `Matrix GHASH Multiply`                              |
| `rv_zwkned`   | `waesdf_ws`  | `ws2, wd`                       | `Matrix AES Final-Round Decryption (Matrix-Scalar)`  |
| `rv_zwkned`   | `waesdf_ww`  | `ws2, wd`                       | `Matrix AES Final-Round Decryption (Matrix-Matrix)`  |
| `rv_zwkned`   | `waesdm_ws`  | `ws2, wd`                       | `Matrix AES Middle-Round Decryption (Matrix-Scalar)` |
| `rv_zwkned`   | `waesdm_ww`  | `ws2, wd`                       | `Matrix AES Middle-Round Decryption (Matrix-Matrix)` |
| `rv_zwkned`   | `waesef_ws`  | `ws2, wd`                       | `Matrix AES Final-Round Encryption (Matrix-Scalar)`  |
| `rv_zwkned`   | `waesef_ww`  | `ws2, wd`                       | `Matrix AES Final-Round Encryption (Matrix-Matrix)`  |
| `rv_zwkned`   | `waesem_ws`  | `ws2, wd`                       | `Matrix AES Middle-Round Encryption (Matrix-Scalar)` |
| `rv_zwkned`   | `waesem_ww`  | `ws2, wd`                       | `Matrix AES Middle-Round Encryption (Matrix-Matrix)` |
| `rv_zwkned`   | `waeskf1_wi` | `ws2, zimm5, wd`                | `Matrix AES-128 Forward Key Schedule`                |
| `rv_zwkned`   | `waeskf2_wi` | `ws2, zimm5, wd`                | `Matrix AES-256 Forward Key Schedule`                |
| `rv_zwkned`   | `waesz_ws`   | `ws2, wd`                       | `Matrix AES Round Zero AddRoundKey (Matrix-Scalar)`  |
| `rv_zwknha`   | `wsha2ch_ww` | `ws2, ws1, wd`                  | `Matrix SHA-2 Two Compression Rounds (High Words)`   |
| `rv_zwknha`   | `wsha2cl_ww` | `ws2, ws1, wd`                  | `Matrix SHA-2 Two Compression Rounds (Low Words)`    |
| `rv_zwknha`   | `wsha2ms_ww` | `ws2, ws1, wd`                  | `Matrix SHA-2 Message Schedule`                      |
| `rv_zwknhb`   | `wsha2ch_ww` | `ws2, ws1, wd`                  | `Matrix SHA-2 Two Compression Rounds (High Words)`   |
| `rv_zwknhb`   | `wsha2cl_ww` | `ws2, ws1, wd`                  | `Matrix SHA-2 Two Compression Rounds (Low Words)`    |
| `rv_zwknhb`   | `wsha2ms_ww` | `ws2, ws1, wd`                  | `Matrix SHA-2 Message Schedule`                      |
| `rv_zwkn`     | `waesdf_ws`  | `ws2, wd`                       | `Matrix AES Final-Round Decryption (Matrix-Scalar)`  |
| `rv_zwkn`     | `waesdf_ww`  | `ws2, wd`                       | `Matrix AES Final-Round Decryption (Matrix-Matrix)`  |
| `rv_zwkn`     | `waesdm_ws`  | `ws2, wd`                       | `Matrix AES Middle-Round Decryption (Matrix-Scalar)` |
| `rv_zwkn`     | `waesdm_ww`  | `ws2, wd`                       | `Matrix AES Middle-Round Decryption (Matrix-Matrix)` |
| `rv_zwkn`     | `waesef_ws`  | `ws2, wd`                       | `Matrix AES Final-Round Encryption (Matrix-Scalar)`  |
| `rv_zwkn`     | `waesef_ww`  | `ws2, wd`                       | `Matrix AES Final-Round Encryption (Matrix-Matrix)`  |
| `rv_zwkn`     | `waesem_ws`  | `ws2, wd`                       | `Matrix AES Middle-Round Encryption (Matrix-Scalar)` |
| `rv_zwkn`     | `waesem_ww`  | `ws2, wd`                       | `Matrix AES Middle-Round Encryption (Matrix-Matrix)` |
| `rv_zwkn`     | `waeskf1_wi` | `ws2, zimm5, wd`                | `Matrix AES-128 Forward Key Schedule`                |
| `rv_zwkn`     | `waeskf2_wi` | `ws2, zimm5, wd`                | `Matrix AES-256 Forward Key Schedule`                |
| `rv_zwkn`     | `waesz_ws`   | `ws2, wd`                       | `Matrix AES Round Zero AddRoundKey (Matrix-Scalar)`  |
| `rv_zwkn`     | `wandn_ww`   | `wm, ws2, ws1, wd`              | `Matrix Bitwise AND-NOT (Matrix-Matrix)`             |
| `rv_zwkn`     | `wandn_wx`   | `wm, ws2, rs1, wd`              | `Matrix Bitwise AND-NOT (Matrix-Scalar)`             |
| `rv_zwkn`     | `wbrev8_w`   | `wm, ws2, wd`                   | `Matrix Reverse Bits in Bytes`                       |
| `rv_zwkn`     | `wrev8_w`    | `wm, ws2, wd`                   | `Matrix Reverse Bytes`                               |
| `rv_zwkn`     | `wrol_ww`    | `wm, ws2, ws1, wd`              | `Matrix Rotate Left (Matrix-Matrix)`                 |
| `rv_zwkn`     | `wrol_wx`    | `wm, ws2, rs1, wd`              | `Matrix Rotate Left (Matrix-Scalar)`                 |
| `rv_zwkn`     | `wror_wi`    | `zimm6hi, wm, ws2, zimm6lo, wd` | `Matrix Rotate Right (Matrix-Immediate)`             |
| `rv_zwkn`     | `wror_ww`    | `wm, ws2, ws1, wd`              | `Matrix Rotate Right (Matrix-Matrix)`                |
| `rv_zwkn`     | `wror_wx`    | `wm, ws2, rs1, wd`              | `Matrix Rotate Right (Matrix-Scalar)`                |
| `rv_zwkn`     | `wsha2ch_ww` | `ws2, ws1, wd`                  | `Matrix SHA-2 Two Compression Rounds (High Words)`   |
| `rv_zwkn`     | `wsha2cl_ww` | `ws2, ws1, wd`                  | `Matrix SHA-2 Two Compression Rounds (Low Words)`    |
| `rv_zwkn`     | `wsha2ms_ww` | `ws2, ws1, wd`                  | `Matrix SHA-2 Message Schedule`                      |
| `rv_zwksed`   | `wsm4k_wi`   | `ws2, zimm5, wd`                | `Matrix SM4 Key Expansion`                           |
| `rv_zwksed`   | `wsm4r_ws`   | `ws2, wd`                       | `Matrix SM4 Four Rounds (Matrix-Scalar)`             |
| `rv_zwksed`   | `wsm4r_ww`   | `ws2, wd`                       | `Matrix SM4 Four Rounds (Matrix-Matrix)`             |
| `rv_zwksh`    | `wsm3c_wi`   | `ws2, zimm5, wd`                | `Matrix SM3 Two Compression Rounds`                  |
| `rv_zwksh`    | `wsm3me_ww`  | `ws2, ws1, wd`                  | `Matrix SM3 Message Expansion`                       |
| `rv_zwks`     | `wandn_ww`   | `wm, ws2, ws1, wd`              | `Matrix Bitwise AND-NOT (Matrix-Matrix)`             |
| `rv_zwks`     | `wandn_wx`   | `wm, ws2, rs1, wd`              | `Matrix Bitwise AND-NOT (Matrix-Scalar)`             |
| `rv_zwks`     | `wbrev8_w`   | `wm, ws2, wd`                   | `Matrix Reverse Bits in Bytes`                       |
| `rv_zwks`     | `wrev8_w`    | `wm, ws2, wd`                   | `Matrix Reverse Bytes`                               |
| `rv_zwks`     | `wrol_ww`    | `wm, ws2, ws1, wd`              | `Matrix Rotate Left (Matrix-Matrix)`                 |
| `rv_zwks`     | `wrol_wx`    | `wm, ws2, rs1, wd`              | `Matrix Rotate Left (Matrix-Scalar)`                 |
| `rv_zwks`     | `wror_wi`    | `zimm6hi, wm, ws2, zimm6lo, wd` | `Matrix Rotate Right (Matrix-Immediate)`             |
| `rv_zwks`     | `wror_ww`    | `wm, ws2, ws1, wd`              | `Matrix Rotate Right (Matrix-Matrix)`                |
| `rv_zwks`     | `wror_wx`    | `wm, ws2, rs1, wd`              | `Matrix Rotate Right (Matrix-Scalar)`                |
| `rv_zwks`     | `wsm3c_wi`   | `ws2, zimm5, wd`                | `Matrix SM3 Two Compression Rounds`                  |
| `rv_zwks`     | `wsm3me_ww`  | `ws2, ws1, wd`                  | `Matrix SM3 Message Expansion`                       |
| `rv_zwks`     | `wsm4k_wi`   | `ws2, zimm5, wd`                | `Matrix SM4 Key Expansion`                           |
| `rv_zwks`     | `wsm4r_ws`   | `ws2, wd`                       | `Matrix SM4 Four Rounds (Matrix-Scalar)`             |
| `rv_zwks`     | `wsm4r_ww`   | `ws2, wd`                       | `Matrix SM4 Four Rounds (Matrix-Matrix)`             |

:RVZWK - Specific Extension for Matrix Cryptography Instructions
