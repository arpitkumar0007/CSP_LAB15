#!/bin/bash

CSV_FILE=$1
 
LATEX_FILE="${CSV_FILE%.csv}.tex"
 
echo "\\documentclass{article}" > "$LATEX_FILE"
echo "\\usepackage{longtable}" >> "$LATEX_FILE"
echo "\\usepackage{graphicx}" >> "$LATEX_FILE"
echo "\\title{Heart Disease Data}" >> "$LATEX_FILE"
echo "\\author{Arpit Kumar}" >> "$LATEX_FILE"
echo "\\date{\\today}" >> "$LATEX_FILE"
echo "\\newpage" >> "$LATEX_FILE"
echo "\\begin{document}" >> "$LATEX_FILE"
echo "\\maketitle" >> "$LATEX_FILE"
echo "\\begin{longtable}{" >> "$LATEX_FILE"

columns=$(head -n 1 "$CSV_FILE" | sed 's/[^,]//g' | wc -c)
columns=$((columns + 1))
echo "|" >> "$LATEX_FILE"
for ((i=1; i<=columns; i++)); do
  echo -n "c|" >> "$LATEX_FILE"
done

echo "}" >> "$LATEX_FILE"

header=$(head -n 1 "$CSV_FILE")
escaped_header=$(echo "$header" | sed 's/_/\\_/g; s/&/\\&/g; s/%/\\%/g; s/\$/\\\$/g; s/#/\\#/g; s/{/\\{/g; s/}/\\}/g; s/~/\\textasciitilde/g; s/\^/\\textasciicircum/g')
latex_header=$(echo "$escaped_header" | sed 's/,/ \& /g')
echo "\\hline" >> "$LATEX_FILE"
echo "$latex_header \\\\" >> "$LATEX_FILE"
echo "\\hline" >> "$LATEX_FILE"
echo "\\endfirsthead" >> "$LATEX_FILE"
echo "\\hline" >> "$LATEX_FILE"

tail -n +2 "$CSV_FILE" | while IFS=, read -r line; do
  escaped_line=$(echo "$line" | sed 's/_/\\_/g; s/&/\\&/g; s/%/\\%/g; s/\$/\\\$/g; s/#/\\#/g; s/{/\\{/g; s/}/\\}/g; s/~/\\textasciitilde/g; s/\^/\\textasciicircum/g')
  
  latex_line=$(echo "$escaped_line" | sed 's/,/ \& /g')
  
  echo "$latex_line \\\\" >> "$LATEX_FILE"
  echo "\\hline" >> "$LATEX_FILE"
done
 
echo "\\end{longtable}" >> "$LATEX_FILE"
echo "\\end{document}" >> "$LATEX_FILE"
 
echo "LaTeX table generated successfully! You can compile $LATEX_FILE to create the PDF."

