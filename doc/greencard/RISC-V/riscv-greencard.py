#!/usr/bin/env python3
"""Build a one-page A4 portrait RISC-V GreenCard from repository Markdown tables.

Run `python3 riscv-greencard.py` to write riscv-greencard.tex and
riscv-greencard.pdf to output/pdf next to this script. Use `--output-dir DIR`
to choose a different destination. The script uses the Python standard library
and requires pdfLaTeX on PATH with the LaTeX packages declared in the preamble.
The generated TeX file is self-contained and can be recompiled independently.
"""

import argparse
from dataclasses import dataclass, replace
from pathlib import Path
import re
import shutil
import subprocess
from tempfile import TemporaryDirectory

ROOT = Path(__file__).resolve().parent
STEM = "riscv-greencard"
INSTRUCTION_SOURCE = Path("formats/base/rv-i/type.md")
CSR_SOURCES = {
    level: Path(f"registers/rv-{level}/rv-x/csr-description.md")
    for level in ("user", "supervisor", "hypervisor", "machine")
}
INSTRUCTION_COLUMNS = ("Extension", "Name", "Variable-Fields", "Encoding",
                       "Match", "Mask", "Type")
CSR_COLUMNS = ("Number", "Privilege", "Name", "Description")
PIPE = re.compile(r"(?<!\\)\|")

LATEX_ESCAPES = str.maketrans({
    "\\": r"\textbackslash{}", "&": r"\&", "%": r"\%", "$": r"\$",
    "#": r"\#", "_": r"\_", "{": r"\{", "}": r"\}", "~": r"\textasciitilde{}",
    "^": r"\textasciicircum{}", "<": r"\textless{}", ">": r"\textgreater{}",
})


@dataclass(frozen=True)
class Table:
    """A Markdown table and its following subtitle."""

    subtitle: str
    rows: tuple[tuple[str, ...], ...]


def markdown_cells(line: str) -> tuple[str, ...]:
    """Read a pipe-table row, preserving pipes escaped inside a cell."""
    return tuple(cell.strip().replace(r"\|", "|")
                 for cell in PIPE.split(line.strip())[1:-1])


def unwrap(value: str, marker: str) -> str:
    """Remove paired Markdown wrappers while preserving literal cell content."""
    if value.startswith(marker) and value.endswith(marker):
        return value[len(marker):-len(marker)]
    return value


def read_tables(path: Path, expected_columns: tuple[str, ...]) -> list[Table]:
    """Load all tables in source order and validate headers and row widths."""
    lines = path.read_text(encoding="utf-8").splitlines()
    tables = []
    index = 0
    while index < len(lines):
        if not lines[index].lstrip().startswith("|"):
            index += 1
            continue

        start = index + 1
        header = tuple(unwrap(cell, "**") for cell in markdown_cells(lines[index]))
        if header != expected_columns:
            raise ValueError(f"{path}:{start}: unexpected table header {header!r}")
        index += 1
        separator = markdown_cells(lines[index]) if index < len(lines) else ()
        if len(separator) != len(header) or any(
            not re.fullmatch(r":?-+:?", cell) for cell in separator
        ):
            raise ValueError(f"{path}:{start + 1}: invalid Markdown table separator")
        index += 1

        rows = []
        while index < len(lines) and lines[index].lstrip().startswith("|"):
            cells = markdown_cells(lines[index])
            if len(cells) != len(header):
                raise ValueError(f"{path}:{index + 1}: expected {len(header)} cells")
            rows.append(tuple(unwrap(cell, "`") for cell in cells))
            index += 1

        while index < len(lines) and not lines[index].strip():
            index += 1
        if not rows or index == len(lines) or not lines[index].lstrip().startswith(":"):
            raise ValueError(f"{path}:{start}: expected rows and a table subtitle")
        subtitle = lines[index].strip()[1:].strip()
        tables.append(Table(subtitle, tuple(rows)))
        index += 1

    if not tables:
        raise ValueError(f"{path}: no tables found")
    return tables


def split_columns(tables: list[Table]) -> tuple[list[Table], list[Table]]:
    """Balance the two CSR columns by their rows and group headings."""
    total_rows = sum(len(table.rows) for table in tables)
    if total_rows < 2:
        return tables, []
    total_weight = total_rows + len(tables)
    positions = []
    left_weight = 0
    for table_index, table in enumerate(tables):
        left_weight += 1
        for count in range(1, len(table.rows) + 1):
            left_weight += 1
            at_boundary = count == len(table.rows)
            if left_weight < total_weight:
                right = total_weight - left_weight + int(not at_boundary)
                positions.append((max(left_weight, right), not at_boundary, table_index, count))

    _, continued, table_index, count = min(positions)
    table = tables[table_index]
    left = tables[:table_index] + [replace(table, rows=table.rows[:count])]
    right = tables[table_index + 1:]
    if continued:
        right = [Table(f"{table.subtitle} (continued)", table.rows[count:])] + right
    return left, right


def latex_table(tables: list[Table], *, csr: bool) -> str:
    """Render a table grid with a heading for each source table."""
    column_labels = ("Number", "Priv.", "Name", "Description") if csr else INSTRUCTION_COLUMNS
    widths = "@{}lllY@{}" if csr else "@{}llYllll@{}"
    flex_column = 3 if csr else 2
    lines = [
        rf"\begin{{tabularx}}{{\linewidth}}{{{widths}}}",
        r"\rowcolor{HeaderTint}" + " & ".join(
            rf"\textbf{{{label}}}" for label in column_labels
        ) + r" \\",
    ]
    for table in tables:
        caption = table.subtitle.translate(LATEX_ESCAPES)
        lines.append(
            rf"\rowcolor{{GroupTint}}\multicolumn{{{len(column_labels)}}}"
            rf"{{@{{}}l@{{}}}}{{\strut\textbf{{{caption}}}}} \\"
        )
        for row in table.rows:
            cells = [value.translate(LATEX_ESCAPES) for value in row]
            if not csr:
                # Keep each wildcard as one copyable bit position in the PDF.
                cells[3] = cells[3].replace("-", "-{}")
            code_columns = len(cells) - 1 if csr else len(cells)
            formatted = [rf"\texttt{{{value}}}" if i < code_columns else value
                         for i, value in enumerate(cells)]
            formatted[flex_column] = rf"\fitcell{{{formatted[flex_column]}}}"
            lines.append(" & ".join(formatted) + r" \\")
    lines.append(r"\end{tabularx}")
    return "\n".join(lines)


def framed_source(title: str, tables: list[Table], *, csr: bool = True) -> str:
    """Place all tables of one input file within a single rectangular frame."""
    if csr:
        left, right = split_columns(tables)
        if right:
            contents = rf"""\begin{{minipage}}[t]{{0.492\linewidth}}
\vspace{{0pt}}
{latex_table(left, csr=True)}
\end{{minipage}}\hfill
\begin{{minipage}}[t]{{0.492\linewidth}}
\vspace{{0pt}}
{latex_table(right, csr=True)}
\end{{minipage}}"""
        else:
            contents = latex_table(left, csr=True)
    else:
        contents = latex_table(tables, csr=False)
    font = r"\csrfont" if csr else r"\instructionfont"
    return rf"""\begin{{sourceframe}}{{{title}}}
{font}
{contents}
\end{{sourceframe}}"""


def make_latex() -> str:
    """Assemble the five framed sources into a self-contained A4 document."""
    instructions = framed_source("RV-I instruction formats", read_tables(
        ROOT / INSTRUCTION_SOURCE, INSTRUCTION_COLUMNS
    ), csr=False)
    csrs = {
        level: framed_source(f"{level.title()} CSRs", read_tables(ROOT / path, CSR_COLUMNS))
        for level, path in CSR_SOURCES.items()
    }
    return r"""% Generated by riscv-greencard.py from the repository Markdown tables.
\documentclass[a4paper,10pt]{article}
\usepackage[portrait,margin=5mm]{geometry}
\usepackage[T1]{fontenc}
\usepackage{lmodern}
\usepackage[table]{xcolor}
\usepackage{tabularx}
\usepackage{adjustbox}

\definecolor{Ink}{HTML}{182923}
\definecolor{Frame}{HTML}{427A68}
\definecolor{HeaderTint}{HTML}{E9F2ED}
\definecolor{GroupTint}{HTML}{F2F6F3}

\pagestyle{empty}
\renewcommand{\familydefault}{\sfdefault}
\setlength{\parindent}{0pt}
\setlength{\parskip}{0pt}
\setlength{\fboxsep}{2.5pt}
\setlength{\fboxrule}{0.45pt}
\setlength{\tabcolsep}{0.9pt}
\setlength{\emergencystretch}{1em}
\renewcommand{\arraystretch}{1}
\newcolumntype{Y}{>{\raggedright\arraybackslash}X}
\newcommand{\fitcell}[1]{\adjustbox{max width=\linewidth}{#1}}
\newcommand{\instructionfont}{\fontsize{4.5pt}{4.75pt}\selectfont}
\newcommand{\csrfont}{\fontsize{3.85pt}{4.15pt}\selectfont}
\newsavebox{\sourcebox}
\newenvironment{sourceframe}[1]{%
  \par\noindent\begin{lrbox}{\sourcebox}%
  \begin{minipage}{\dimexpr\linewidth-2\fboxsep-2\fboxrule\relax}%
  {\color{Frame}\fontsize{6.8pt}{7.5pt}\selectfont\bfseries #1\par}%
  \vspace{1pt}\noindent\ignorespaces
}{%
  \end{minipage}\end{lrbox}%
  \fcolorbox{Frame}{white}{\usebox{\sourcebox}}\par
}

\newsavebox{\pagetitle}
\newlength{\availableheight}
\begin{document}
\color{Ink}
\sbox{\pagetitle}{%
  \begin{minipage}{\textwidth}
  {\fontsize{15pt}{16pt}\selectfont\bfseries RISC-V GreenCard}\enspace
  {\fontsize{6.5pt}{7pt}\selectfont\color{Frame}Instruction formats and control and status registers}
  \par\vspace{3pt}
  \end{minipage}}
\setlength{\availableheight}{\dimexpr\textheight-\ht\pagetitle-\dp\pagetitle-2pt\relax}
\noindent\usebox{\pagetitle}\par\nointerlineskip
\noindent\adjustbox{max totalsize={\textwidth}{\availableheight},center}{%
  \begin{minipage}[t]{\textwidth}
  \vspace{0pt}
  \begin{minipage}[t]{0.490\linewidth}
  \vspace{0pt}
""" + instructions + "\n" + r"\vspace{3pt}" + "\n" + csrs["user"] + "\n" + (
        r"\vspace{3pt}" + "\n" + csrs["supervisor"] + "\n"
    ) + r"""\end{minipage}\hfill
  \begin{minipage}[t]{0.502\linewidth}
  \vspace{0pt}
""" + csrs["machine"] + "\n" + r"\vspace{3pt}" + "\n" + csrs["hypervisor"] + "\n" + r"""
  \end{minipage}
  \end{minipage}%
}
\end{document}
"""


def compile_greencard(latex: str, output_dir: Path) -> None:
    """Compile in a temporary directory and publish only the TeX and PDF."""
    engine = shutil.which("pdflatex")
    if not engine:
        raise ValueError("pdfLaTeX was not found on PATH. Install a LaTeX distribution.")
    with TemporaryDirectory(prefix="riscv-greencard-") as workspace:
        build_dir = Path(workspace)
        tex = build_dir / f"{STEM}.tex"
        pdf = build_dir / f"{STEM}.pdf"
        tex.write_text(latex, encoding="utf-8")
        result = subprocess.run(
            [engine, "-interaction=nonstopmode", "-halt-on-error", "-no-shell-escape",
             "-file-line-error", tex.name],
            cwd=build_dir, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
            text=True, errors="replace", check=False,
        )
        if result.returncode or not pdf.is_file():
            details = "\n".join(result.stdout.splitlines()[-20:])
            raise ValueError(f"pdfLaTeX failed:\n{details}")
        if not re.search(r"Output written on .+ \(1 page,", result.stdout):
            raise ValueError("pdfLaTeX did not produce exactly one page.")

        output_dir.mkdir(parents=True, exist_ok=True)
        for generated in (tex, pdf):
            shutil.copyfile(generated, output_dir / generated.name)


def main() -> None:
    """Parse command-line options and report generation errors."""
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--output-dir", type=Path, default=ROOT / "output" / "pdf",
                        help="destination for the TeX and PDF (default: output/pdf)")
    options = parser.parse_args()
    try:
        compile_greencard(make_latex(), options.output_dir)
    except (OSError, ValueError) as error:
        parser.exit(1, f"Could not generate the GreenCard: {error}\n")
    for ext in ("tex", "pdf"):
        print(options.output_dir.resolve() / f"{STEM}.{ext}")


if __name__ == "__main__":
    main()
