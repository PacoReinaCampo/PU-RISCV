# DESIGN OF INSTRUCTIONS

The RISC-V ISA features a streamlined design for its instructions, aiming to balance simplicity, efficiency, and extensibility across a wide range of computing devices. Instructions are structured to be fixed-width (32 or 64 bits) and are categorized into different types and extensions to accommodate diverse application needs.

This directory contains MetaData for the RISC-V Instruction Set Architecture

| File                           | Description                             |
|--------------------------------|:----------------------------------------|
| `extensions`                   | `Instruction Set Extensions`            |
| `types`                        | `Instruction Types`                     |
| `codecs`                       | `Instruction Encodings`                 |
| `compression`                  | `Compressed Instruction`                |
| `pseudos`                      | `Pseudo Instructions`                   |
: Instruction Directory

The instruction directory provides a comprehensive listing and categorization of all instructions defined in the RISC-V ISA, organized by their types and functionalities, facilitating easy reference and understanding of their usage.

![Dependences](assets/dependences-global.svg){width=10cm}

![RV32IMAC](assets/RV32IMAC.svg){width=10cm}

![RV64IMAC](assets/RV64IMAC.svg){width=10cm}

![RV128IMAC](assets/RV128IMAC.svg){width=10cm}
