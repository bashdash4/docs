(TeX-add-style-hook
 "darpa-template"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("$documentclass$" "$if(fontsize)$$fontsize$" "$endif$$if(lang)$$lang$" "$endif$$if(papersize)$$papersize$" "$endif$$for(classoption)$$classoption$$sep$" "$endfor$")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("fontenc" "T1") ("inputenc" "utf8") ("geometry" "$for(geometry)$$geometry$$sep$" "$endfor$") ("hyperref" "setpagesize=false" "unicode=false" "xetex" "unicode=true") ("babel" "shorthands=off" "$lang$") ("ulem" "normalem")))
   (add-to-list 'LaTeX-verbatim-environments-local "VerbatimOut")
   (add-to-list 'LaTeX-verbatim-environments-local "SaveVerbatim")
   (add-to-list 'LaTeX-verbatim-environments-local "LVerbatim*")
   (add-to-list 'LaTeX-verbatim-environments-local "LVerbatim")
   (add-to-list 'LaTeX-verbatim-environments-local "BVerbatim*")
   (add-to-list 'LaTeX-verbatim-environments-local "BVerbatim")
   (add-to-list 'LaTeX-verbatim-environments-local "Verbatim*")
   (add-to-list 'LaTeX-verbatim-environments-local "Verbatim")
   (add-to-list 'LaTeX-verbatim-environments-local "lstlisting")
   (add-to-list 'LaTeX-verbatim-environments-local "code")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "lstinline")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "Verb")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "lstinline")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "latex2e"
    "$documentclass$"
    "$documentclass$10"
    "$fontfamily$"
    "lmodern"
    "setspace"
    "amssymb"
    "amsmath"
    "ifxetex"
    "ifluatex"
    "fixltx2e"
    "fontenc"
    "inputenc"
    "eurosym"
    "mathspec"
    "xltxtra"
    "xunicode"
    "fontspec"
    "upquote"
    "microtype"
    "geometry"
    "hyperref"
    "fancyhdr"
    "polyglossia"
    "babel"
    "natbib"
    "biblatex"
    "listings"
    "fancyvrb"
    "longtable"
    "booktabs"
    "etoolbox"
    "graphicx"
    "grffile"
    "ulem")
   (TeX-add-symbols
    '("cardinality" 1)
    "euro"
    "tightlist"
    "maxwidth"
    "maxheight"
    "oldparagraph"
    "oldsubparagraph")
   (LaTeX-add-bibliographies
    "$for(bibliography)$$bibliography$$sep$"
    "$endfor$"))
 :latex)

