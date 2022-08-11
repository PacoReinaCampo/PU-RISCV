rm -f *.tex
rm -f *.pdf

pandoc BOOK.md -s -o PU-RISCV.tex
pandoc BOOK.md -s -o PU-RISCV.pdf
