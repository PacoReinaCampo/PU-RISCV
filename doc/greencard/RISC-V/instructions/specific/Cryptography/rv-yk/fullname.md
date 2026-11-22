## INSTRUCTION FULL-NAMES

| **Extension** | **Name**     | **Variable-Fields**             | **Full-Name**                                        |
|:--------------|:-------------|:--------------------------------|:-----------------------------------------------------|
| `rv_zykg`     | `yghsh_yy`   | `ys2, ys1, yd`                  | `Tensor GHASH Add-Multiply`                          |
| `rv_zykg`     | `ygmul_yy`   | `ys2, yd`                       | `Tensor GHASH Multiply`                              |
| `rv_zykned`   | `yaesdf_ys`  | `ys2, yd`                       | `Tensor AES Final-Round Decryption (Tensor-Scalar)`  |
| `rv_zykned`   | `yaesdf_yy`  | `ys2, yd`                       | `Tensor AES Final-Round Decryption (Tensor-Tensor)`  |
| `rv_zykned`   | `yaesdm_ys`  | `ys2, yd`                       | `Tensor AES Middle-Round Decryption (Tensor-Scalar)` |
| `rv_zykned`   | `yaesdm_yy`  | `ys2, yd`                       | `Tensor AES Middle-Round Decryption (Tensor-Tensor)` |
| `rv_zykned`   | `yaesef_ys`  | `ys2, yd`                       | `Tensor AES Final-Round Encryption (Tensor-Scalar)`  |
| `rv_zykned`   | `yaesef_yy`  | `ys2, yd`                       | `Tensor AES Final-Round Encryption (Tensor-Tensor)`  |
| `rv_zykned`   | `yaesem_ys`  | `ys2, yd`                       | `Tensor AES Middle-Round Encryption (Tensor-Scalar)` |
| `rv_zykned`   | `yaesem_yy`  | `ys2, yd`                       | `Tensor AES Middle-Round Encryption (Tensor-Tensor)` |
| `rv_zykned`   | `yaeskf1_yi` | `ys2, zimm5, yd`                | `Tensor AES-128 Forward Key Schedule`                |
| `rv_zykned`   | `yaeskf2_yi` | `ys2, zimm5, yd`                | `Tensor AES-256 Forward Key Schedule`                |
| `rv_zykned`   | `yaesz_ys`   | `ys2, yd`                       | `Tensor AES Round Zero AddRoundKey (Tensor-Scalar)`  |
| `rv_zyknha`   | `ysha2ch_yy` | `ys2, ys1, yd`                  | `Tensor SHA-2 Two Compression Rounds (High Words)`   |
| `rv_zyknha`   | `ysha2cl_yy` | `ys2, ys1, yd`                  | `Tensor SHA-2 Two Compression Rounds (Low Words)`    |
| `rv_zyknha`   | `ysha2ms_yy` | `ys2, ys1, yd`                  | `Tensor SHA-2 Message Schedule`                      |
| `rv_zyknhb`   | `ysha2ch_yy` | `ys2, ys1, yd`                  | `Tensor SHA-2 Two Compression Rounds (High Words)`   |
| `rv_zyknhb`   | `ysha2cl_yy` | `ys2, ys1, yd`                  | `Tensor SHA-2 Two Compression Rounds (Low Words)`    |
| `rv_zyknhb`   | `ysha2ms_yy` | `ys2, ys1, yd`                  | `Tensor SHA-2 Message Schedule`                      |
| `rv_zykn`     | `yaesdf_ys`  | `ys2, yd`                       | `Tensor AES Final-Round Decryption (Tensor-Scalar)`  |
| `rv_zykn`     | `yaesdf_yy`  | `ys2, yd`                       | `Tensor AES Final-Round Decryption (Tensor-Tensor)`  |
| `rv_zykn`     | `yaesdm_ys`  | `ys2, yd`                       | `Tensor AES Middle-Round Decryption (Tensor-Scalar)` |
| `rv_zykn`     | `yaesdm_yy`  | `ys2, yd`                       | `Tensor AES Middle-Round Decryption (Tensor-Tensor)` |
| `rv_zykn`     | `yaesef_ys`  | `ys2, yd`                       | `Tensor AES Final-Round Encryption (Tensor-Scalar)`  |
| `rv_zykn`     | `yaesef_yy`  | `ys2, yd`                       | `Tensor AES Final-Round Encryption (Tensor-Tensor)`  |
| `rv_zykn`     | `yaesem_ys`  | `ys2, yd`                       | `Tensor AES Middle-Round Encryption (Tensor-Scalar)` |
| `rv_zykn`     | `yaesem_yy`  | `ys2, yd`                       | `Tensor AES Middle-Round Encryption (Tensor-Tensor)` |
| `rv_zykn`     | `yaeskf1_yi` | `ys2, zimm5, yd`                | `Tensor AES-128 Forward Key Schedule`                |
| `rv_zykn`     | `yaeskf2_yi` | `ys2, zimm5, yd`                | `Tensor AES-256 Forward Key Schedule`                |
| `rv_zykn`     | `yaesz_ys`   | `ys2, yd`                       | `Tensor AES Round Zero AddRoundKey (Tensor-Scalar)`  |
| `rv_zykn`     | `yandn_yy`   | `ym, ys2, ys1, yd`              | `Tensor Bitwise AND-NOT (Tensor-Tensor)`             |
| `rv_zykn`     | `yandn_yx`   | `ym, ys2, rs1, yd`              | `Tensor Bitwise AND-NOT (Tensor-Scalar)`             |
| `rv_zykn`     | `ybrev8_y`   | `ym, ys2, yd`                   | `Tensor Reverse Bits in Bytes`                       |
| `rv_zykn`     | `yrev8_y`    | `ym, ys2, yd`                   | `Tensor Reverse Bytes`                               |
| `rv_zykn`     | `yrol_yy`    | `ym, ys2, ys1, yd`              | `Tensor Rotate Left (Tensor-Tensor)`                 |
| `rv_zykn`     | `yrol_yx`    | `ym, ys2, rs1, yd`              | `Tensor Rotate Left (Tensor-Scalar)`                 |
| `rv_zykn`     | `yror_yi`    | `zimm6hi, ym, ys2, zimm6lo, yd` | `Tensor Rotate Right (Tensor-Immediate)`             |
| `rv_zykn`     | `yror_yy`    | `ym, ys2, ys1, yd`              | `Tensor Rotate Right (Tensor-Tensor)`                |
| `rv_zykn`     | `yror_yx`    | `ym, ys2, rs1, yd`              | `Tensor Rotate Right (Tensor-Scalar)`                |
| `rv_zykn`     | `ysha2ch_yy` | `ys2, ys1, yd`                  | `Tensor SHA-2 Two Compression Rounds (High Words)`   |
| `rv_zykn`     | `ysha2cl_yy` | `ys2, ys1, yd`                  | `Tensor SHA-2 Two Compression Rounds (Low Words)`    |
| `rv_zykn`     | `ysha2ms_yy` | `ys2, ys1, yd`                  | `Tensor SHA-2 Message Schedule`                      |
| `rv_zyksed`   | `ysm4k_yi`   | `ys2, zimm5, yd`                | `Tensor SM4 Key Expansion`                           |
| `rv_zyksed`   | `ysm4r_ys`   | `ys2, yd`                       | `Tensor SM4 Four Rounds (Tensor-Scalar)`             |
| `rv_zyksed`   | `ysm4r_yy`   | `ys2, yd`                       | `Tensor SM4 Four Rounds (Tensor-Tensor)`             |
| `rv_zyksh`    | `ysm3c_yi`   | `ys2, zimm5, yd`                | `Tensor SM3 Two Compression Rounds`                  |
| `rv_zyksh`    | `ysm3me_yy`  | `ys2, ys1, yd`                  | `Tensor SM3 Message Expansion`                       |
| `rv_zyks`     | `yandn_yy`   | `ym, ys2, ys1, yd`              | `Tensor Bitwise AND-NOT (Tensor-Tensor)`             |
| `rv_zyks`     | `yandn_yx`   | `ym, ys2, rs1, yd`              | `Tensor Bitwise AND-NOT (Tensor-Scalar)`             |
| `rv_zyks`     | `ybrev8_y`   | `ym, ys2, yd`                   | `Tensor Reverse Bits in Bytes`                       |
| `rv_zyks`     | `yrev8_y`    | `ym, ys2, yd`                   | `Tensor Reverse Bytes`                               |
| `rv_zyks`     | `yrol_yy`    | `ym, ys2, ys1, yd`              | `Tensor Rotate Left (Tensor-Tensor)`                 |
| `rv_zyks`     | `yrol_yx`    | `ym, ys2, rs1, yd`              | `Tensor Rotate Left (Tensor-Scalar)`                 |
| `rv_zyks`     | `yror_yi`    | `zimm6hi, ym, ys2, zimm6lo, yd` | `Tensor Rotate Right (Tensor-Immediate)`             |
| `rv_zyks`     | `yror_yy`    | `ym, ys2, ys1, yd`              | `Tensor Rotate Right (Tensor-Tensor)`                |
| `rv_zyks`     | `yror_yx`    | `ym, ys2, rs1, yd`              | `Tensor Rotate Right (Tensor-Scalar)`                |
| `rv_zyks`     | `ysm3c_yi`   | `ys2, zimm5, yd`                | `Tensor SM3 Two Compression Rounds`                  |
| `rv_zyks`     | `ysm3me_yy`  | `ys2, ys1, yd`                  | `Tensor SM3 Message Expansion`                       |
| `rv_zyks`     | `ysm4k_yi`   | `ys2, zimm5, yd`                | `Tensor SM4 Key Expansion`                           |
| `rv_zyks`     | `ysm4r_ys`   | `ys2, yd`                       | `Tensor SM4 Four Rounds (Tensor-Scalar)`             |
| `rv_zyks`     | `ysm4r_yy`   | `ys2, yd`                       | `Tensor SM4 Four Rounds (Tensor-Tensor)`             |

:RVZYK - Specific Extension for Tensor Cryptography Instructions
