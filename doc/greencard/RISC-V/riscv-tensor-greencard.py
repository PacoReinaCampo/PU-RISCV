#!/usr/bin/env python3
"""Build an A4 portrait reference for RV-Y on two double-sided sheets.

Run `python3 riscv-tensor-greencard.py` to generate a self-contained LaTeX
file and PDF in output/pdf/. Use `--output-dir DIR` to change that location.
Python 3.10+ and pdfLaTeX with the packages listed in the preamble are required.

The four required sources are the RV-Y instruction formats, user CSR fields,
user GPR fields and RISC-V exceptions. Instructions span the first three
pages, register fields appear on page three, and exceptions fill page four.
Exception Directory tables are omitted from the card.
"""

import argparse
from dataclasses import dataclass, replace
from pathlib import Path
import re
import shutil
import subprocess
from tempfile import TemporaryDirectory

ROOT = Path(__file__).resolve().parent
STEM = "riscv-tensor-greencard"
INSTRUCTIONS = Path("formats/specific/Algebra/rv-y/type.md")
CSR_FIELDS = Path("registers/rv-user/rv-y/csr-field.md")
GPR_FIELDS = Path("registers/rv-user/rv-y/gpr-field.md")
EXCEPTIONS = Path("exceptions/riscv-exceptions.md")
INSTRUCTION_COLUMNS = (
    "Extension", "Name", "Variable-Fields", "Encoding", "Match", "Mask", "Type",
)
CSR_COLUMNS = ("CSR", "Name", "Bits", "Privilege", "Description")
GPR_COLUMNS = ("Register", "Name", "Bits", "Description")
EXCEPTION_COLUMNS = (
    ("File", "Description"),
    ("Interrupt", "Exception Code", "Description"),
    ("Number", "Access", "Name", "Description"),
)
PIPE = re.compile(r"(?<!\\)\|")
LATEX_ESCAPES = str.maketrans({
    "\\": r"\textbackslash{}", "&": r"\&", "%": r"\%", "$": r"\$",
    "#": r"\#", "_": r"\_", "{": r"\{", "}": r"\}", "~": r"\textasciitilde{}",
    "^": r"\textasciicircum{}", "<": r"\textless{}", ">": r"\textgreater{}",
    "≥": r"\ensuremath{\geq}",
})


@dataclass(frozen=True)
class Table:
    """A source table, its subtitle, and its enclosing Markdown section."""

    columns: tuple[str, ...]
    rows: tuple[tuple[str, ...], ...]
    subtitle: str
    section: str


def unwrap(text: str, marker: str) -> str:
    """Remove matching Markdown wrappers from an entire cell."""
    if len(text) >= 2 * len(marker) and text.startswith(marker) and text.endswith(marker):
        return text[len(marker):-len(marker)]
    return text


def cells(line: str) -> tuple[str, ...]:
    """Split a pipe-table row and unescape literal pipes."""
    return tuple(part.strip().replace(r"\|", "|") for part in PIPE.split(line)[1:-1])


def read_tables(path: Path, schemas: tuple[tuple[str, ...], ...]) -> list[Table]:
    """Read the repository's pipe tables, validating all headings and rows."""
    lines = path.read_text(encoding="utf-8").splitlines()
    section = ""
    tables = []
    index = 0
    while index < len(lines):
        line = lines[index].strip()
        if line.startswith("## "):
            section = line[3:]
        if not line.startswith("|"):
            index += 1
            continue

        start = index + 1
        header = tuple(unwrap(cell, "**") for cell in cells(line))
        if header not in schemas:
            raise ValueError(f"{path}:{start}: unexpected table columns {header!r}")
        index += 1
        separator = cells(lines[index].strip()) if index < len(lines) else ()
        if len(separator) != len(header) or any(
            re.fullmatch(r":?-+:?", cell) is None for cell in separator
        ):
            raise ValueError(f"{path}:{start + 1}: invalid table separator")
        index += 1

        rows = []
        while index < len(lines) and lines[index].lstrip().startswith("|"):
            row = cells(lines[index].strip())
            if len(row) != len(header):
                raise ValueError(f"{path}:{index + 1}: expected {len(header)} cells")
            rows.append(tuple(unwrap(cell, "`") for cell in row))
            index += 1

        while index < len(lines) and not lines[index].strip():
            index += 1
        if not rows or index == len(lines) or not lines[index].lstrip().startswith(":"):
            raise ValueError(f"{path}:{start}: expected data rows and a table subtitle")
        tables.append(Table(header, tuple(rows), lines[index].strip()[1:].strip(), section))
        index += 1
    if not tables:
        raise ValueError(f"{path}: no tables found")
    return tables


def split_at(tables: list[Table], row_count: int) -> tuple[list[Table], list[Table]]:
    """Divide tables at a row boundary and label any continuation."""
    for index, table in enumerate(tables):
        if 0 < row_count < len(table.rows):
            head = replace(table, rows=table.rows[:row_count])
            suffix = " (continued)"
            tail = replace(table, rows=table.rows[row_count:],
                           subtitle=table.subtitle.removesuffix(suffix) + suffix)
            return tables[:index] + [head], [tail] + tables[index + 1:]
        if row_count == 0:
            return tables[:index], tables[index:]
        row_count -= len(table.rows)
    if row_count != 0:
        raise ValueError("Table split falls outside the available rows")
    return tables, []


def grid(tables: list[Table]) -> str:
    """Render tables with a common schema as a compact LaTeX grid."""
    header = tables[0].columns
    is_instruction = header == INSTRUCTION_COLUMNS
    flexible = 2 if is_instruction else len(header) - 1
    columns = "@{}" + "".join("Y" if k == flexible else "l"
                              for k in range(len(header))) + "@{}"
    lines = [
        rf"\begin{{tabularx}}{{\linewidth}}{{{columns}}}",
        r"\rowcolor{Frame}" + " & ".join(
            rf"\textcolor{{white}}{{\textbf{{{name}}}}}" for name in header
        ) + r" \\",
    ]
    for table in tables:
        caption = table.subtitle.translate(LATEX_ESCAPES)
        lines.append(
            rf"\rowcolor{{GroupTint}}\multicolumn{{{len(header)}}}"
            rf"{{@{{}}l@{{}}}}{{\strut\textbf{{{caption}}}}} \\"
        )
        for row in table.rows:
            values = []
            for index, value in enumerate(row):
                value = value.translate(LATEX_ESCAPES)
                if header[index] == "Encoding":
                    # Suppress TeX's dash ligatures so encoding bits copy verbatim.
                    value = value.replace("-", "-{}")
                if header[index] != "Description":
                    value = rf"\texttt{{{value}}}"
                if is_instruction and index == flexible:
                    value = rf"\fitcell{{{value}}}"
                values.append(value)
            lines.append(" & ".join(values) + r" \\")
    lines.append(r"\end{tabularx}")
    return "\n".join(lines)


def columns(left: str, right: str, *, widths: tuple[str, str] = ("0.495", "0.495")) -> str:
    """Arrange top-aligned columns inside the current frame or page."""
    return "\\hfill\n".join(
        rf"""\begin{{minipage}}[t]{{{width}\linewidth}}
\vspace{{0pt}}
{content}
\end{{minipage}}"""
        for content, width in zip((left, right), widths)
    )


def frame(title: str, content: str, font: str) -> str:
    """Wrap one source or a page of its continuation in a border."""
    return rf"""\begin{{sourceframe}}{{{title}}}
{font}
{content}
\end{{sourceframe}}"""


def two_column_grid(
    tables: list[Table], *, widths: tuple[str, str] = ("0.495", "0.495")
) -> str:
    """Balance matching tables between two columns without changing row order."""
    count = sum(len(table.rows) for table in tables)
    left, right = split_at(tables, (count + 1) // 2)
    return columns(grid(left), grid(right), widths=widths) if right else grid(left)


def exception_frame(tables: list[Table]) -> str:
    """Group exception and trap tables by privilege level in a single frame."""
    sections = {}
    for table in tables:
        sections.setdefault(table.section, []).append(table)
    content = []
    for section, group in sections.items():
        label = section.translate(LATEX_ESCAPES)
        content.append(rf"\textbf{{{label}}}\par\smallskip" + "\n"
                       + "\n\\par\\vspace{1pt}\n".join(grid([table]) for table in group))
    # Keep the privilege sections intact in two reading columns.
    midpoint = (len(content) + 1) // 2
    section_gap = "\n\\par\\vspace{6pt}\n"
    return frame(
        "Exceptions and traps",
        columns(section_gap.join(content[:midpoint]), section_gap.join(content[midpoint:]),
                widths=("0.49", "0.49")),
        r"\exceptionfont",
    )


PREAMBLE = r"""% Generated by riscv-tensor-greencard.py from the repository Markdown tables.
\documentclass[a4paper,twoside,10pt]{article}
\usepackage[portrait,margin=7mm]{geometry}
\usepackage[T1]{fontenc}
\usepackage{lmodern}
\usepackage[table]{xcolor}
\usepackage{tabularx}
\usepackage{adjustbox}
\input{glyphtounicode}
\pdfgentounicode=1
\pdfcatalog{/ViewerPreferences << /Duplex /DuplexFlipLongEdge >>}

\definecolor{Ink}{HTML}{182923}
\definecolor{Frame}{HTML}{427A68}
\definecolor{GroupTint}{HTML}{F2F6F3}
\pagestyle{empty}
\renewcommand{\familydefault}{\sfdefault}
\setlength{\parindent}{0pt}
\setlength{\parskip}{0pt}
\setlength{\fboxsep}{3pt}
\setlength{\fboxrule}{0.45pt}
\setlength{\tabcolsep}{0.72pt}
\newcolumntype{Y}{>{\raggedright\arraybackslash}X}
\newcommand{\fitcell}[1]{\adjustbox{max width=\linewidth}{#1}}
\newcommand{\instructionfont}{\fontsize{4.6pt}{5.65pt}\selectfont}
\newcommand{\registerfont}{\setlength{\tabcolsep}{1.3pt}\fontsize{6pt}{7pt}\selectfont}
\newcommand{\exceptionfont}{\setlength{\tabcolsep}{1.3pt}\fontsize{5.15pt}{4.95pt}\selectfont}
\newsavebox{\sourcebox}
\newenvironment{sourceframe}[1]{%
  \par\noindent\begin{lrbox}{\sourcebox}%
  \begin{minipage}{\dimexpr\linewidth-2\fboxsep-2\fboxrule\relax}%
  {\color{Frame}\fontsize{8pt}{9pt}\selectfont\bfseries #1\par}%
  \vspace{2pt}\noindent\ignorespaces
}{%
  \end{minipage}\end{lrbox}%
  \fcolorbox{Frame}{white}{\usebox{\sourcebox}}\par
}
\newsavebox{\pagetitle}
\newlength{\availableheight}
\newcommand{\sheettitle}[1]{%
  \sbox{\pagetitle}{\begin{minipage}{\textwidth}%
  {\fontsize{13pt}{14pt}\selectfont\bfseries RISC-V Tensor GreenCard}%
  \hfill{\fontsize{7pt}{8pt}\selectfont\color{Frame}#1}%
  \par\vspace{4pt}\end{minipage}}%
  \setlength{\availableheight}{\dimexpr\textheight-\ht\pagetitle-\dp\pagetitle-2pt\relax}%
  \noindent\usebox{\pagetitle}\par\nointerlineskip
}
\begin{document}
\color{Ink}
"""


def sheet(subtitle: str, content: str) -> str:
    """Scale one side to the available height while preserving its aspect ratio."""
    return rf"""\sheettitle{{{subtitle}}}
\noindent\adjustbox{{max totalsize={{\textwidth}}{{\availableheight}},center}}{{%
\begin{{minipage}}{{\textwidth}}
{content}
\end{{minipage}}%
}}
"""


def make_latex() -> str:
    """Read the four required sources and lay them out in duplex page order."""
    tables = read_tables(ROOT / INSTRUCTIONS, (INSTRUCTION_COLUMNS,))
    csr = read_tables(ROOT / CSR_FIELDS, (CSR_COLUMNS,))
    gpr = read_tables(ROOT / GPR_FIELDS, (GPR_COLUMNS,))
    exceptions = [
        table for table in read_tables(ROOT / EXCEPTIONS, EXCEPTION_COLUMNS)
        if table.subtitle.casefold() != "exception directory"
    ]
    row_count = sum(len(table.rows) for table in tables)
    # Give the first sheet more instruction rows to make room for registers on page three.
    first_sheet_rows = round(row_count * 0.72)
    first_sheet, third = split_at(tables, first_sheet_rows)
    first, second = split_at(first_sheet, (first_sheet_rows + 1) // 2)
    register_frames = columns(
        frame("User tensor CSR fields", grid(csr), r"\registerfont"),
        frame("User tensor GPR fields", two_column_grid(gpr), r"\registerfont"),
        widths=("0.44", "0.55"),
    )
    pages = []
    for page, segment in enumerate((first, second, third), start=1):
        title = "RV-Y instruction formats" + (" (continued)" if page > 1 else "")
        # The last column includes RVZY, whose extension names and operands are longer.
        widths = ("0.444", "0.546") if page == 3 else ("0.495", "0.495")
        content = (
            frame(title, two_column_grid(segment, widths=widths), r"\instructionfont")
            if segment else ""
        )
        subtitle = "Instruction formats"
        if page == 3:
            content += "\n\\par\\vspace{4pt}\n" + register_frames
            subtitle += " and register fields"
        pages.append(sheet(f"{subtitle} / {page} of 4", content))
    pages.append(sheet("Exceptions and traps / 4 of 4", exception_frame(exceptions)))
    return PREAMBLE + "\\newpage\n".join(pages) + "\\end{document}\n"


def compile_card(latex: str, output_dir: Path) -> None:
    """Run pdfLaTeX in isolation and copy only the validated deliverables."""
    compiler = shutil.which("pdflatex")
    if not compiler:
        raise ValueError("pdfLaTeX is required on PATH.")
    with TemporaryDirectory(prefix=f"{STEM}-") as tmp:
        build = Path(tmp)
        tex = build / f"{STEM}.tex"
        pdf = build / f"{STEM}.pdf"
        tex.write_text(latex, encoding="utf-8")
        result = subprocess.run(
            [compiler, "-interaction=nonstopmode", "-halt-on-error", "-no-shell-escape",
             "-file-line-error", tex.name],
            cwd=build, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
            text=True, errors="replace", check=False,
        )
        if result.returncode or not pdf.is_file():
            excerpt = "\n".join(result.stdout.splitlines()[-20:])
            raise ValueError(f"pdfLaTeX failed:\n{excerpt}")
        if not re.search(r"Output written on .+ \(4 pages,", result.stdout):
            raise ValueError("The GreenCard must fit on four pages for duplex printing.")
        output_dir.mkdir(parents=True, exist_ok=True)
        for generated in (tex, pdf):
            shutil.copyfile(generated, output_dir / generated.name)


def main() -> None:
    """Accept command-line options and generate the GreenCard."""
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--output-dir", type=Path, default=ROOT / "output" / "pdf",
                        help="destination for the TeX and PDF (default: output/pdf)")
    args = parser.parse_args()
    try:
        compile_card(make_latex(), args.output_dir)
    except (OSError, ValueError) as error:
        parser.exit(1, f"Could not generate the GreenCard: {error}\n")
    for ext in ("tex", "pdf"):
        print(args.output_dir.resolve() / f"{STEM}.{ext}")


if __name__ == "__main__":
    main()
