(TeX-add-style-hook
 "sandbox"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("memoir" "10pt" "oneside")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("fontenc" "T1") ("inputenc" "utf8") ("hyperref" "setpagesize=false" "unicode=false" "xetex" "unicode=true")))
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "latex2e"
    "memoir"
    "memoir10"
    "lmodern"
    "amssymb"
    "amsmath"
    "ifxetex"
    "ifluatex"
    "fixltx2e"
    "fontenc"
    "inputenc"
    "mathspec"
    "xltxtra"
    "xunicode"
    "fontspec"
    "upquote"
    "microtype"
    "hyperref"
    "fancyhdr"
    "longtable"
    "booktabs"
    "etoolbox")
   (TeX-add-symbols
    "euro"
    "tightlist"
    "oldparagraph"
    "oldsubparagraph")
   (LaTeX-add-labels
    "sandbox-for-playing-with-pandocslate"))
 :latex)

