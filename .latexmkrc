# Configure latexmk to use XeLaTeX for Thai language support
$pdf_mode = 5;  # Use xelatex
$postscript_mode = 0;
$dvi_mode = 0;

# XeLaTeX command
$xelatex = 'xelatex -interaction=nonstopmode -synctex=1 %O %S';

# Biber for bibliography
$biber = 'biber %O %S';

# Cleanup extensions
$clean_ext = 'bbl synctex.gz';
