#!/bin/bash

CSV_FILE=$1
 
LATEX_FILE="${CSV_FILE%.csv}.tex"
 
echo "\\documentclass{article}" > "$LATEX_FILE"
echo "\\usepackage{longtable}" >> "$LATEX_FILE"
echo "\\usepackage{graphicx}" >> "$LATEX_FILE"
echo "\\usepackage{caption}" >> "$LATEX_FILE"
echo "\\usepackage{float}" >> "$LATEX_FILE"
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
echo "\\section{gender vs number of people having heart disease}" >> $LATEX_FILE
echo "\\begin{figure}[H]" >> $LATEX_FILE
echo "\\centering" >> $LATEX_FILE
echo "\\includegraphics[width=0.5\\textwidth]{quest4(a).png}" >> $LATEX_FILE
echo "\\caption{gender(x-axis) vs number of people having heart disease(y-axis)}" >> $LATEX_FILE
echo "\\label{fig:image1}" >> $LATEX_FILE
echo "\\end{figure}" >> $LATEX_FILE

# Referencing the image in the text
echo "As shown in Figure \\ref{fig:image1} shows gender(x-axis) vs number of people having heart disease(y-axis)" >> $LATEX_FILE


echo "\\section{correlation between Age (x-axis) vs Blood pressure (y-axis)}" >> $LATEX_FILE
echo "\\begin{figure}[H]" >> $LATEX_FILE
echo "\\centering" >> $LATEX_FILE
echo "\\includegraphics[width=0.5\\textwidth]{ques4(b).png}" >> $LATEX_FILE
echo "\\caption{correlation between Age (x-axis) vs Blood pressure (y-axis)}" >> $LATEX_FILE
echo "\\label{fig:image2}" >> $LATEX_FILE
echo "\\end{figure}" >> $LATEX_FILE

# Referencing the image in the text
echo "As shown in Figure \\ref{fig:image2} shows correlation between Age (x-axis) vs Blood pressure (y-axis)" >> $LATEX_FILE

echo "\\section{correlation between Age (x-axis) vs Cholesterol (y-axis)}" >> $LATEX_FILE
echo "\\begin{figure}[H]" >> $LATEX_FILE
echo "\\centering" >> $LATEX_FILE
echo "\\includegraphics[width=0.5\\textwidth]{ques4(c).png}" >> $LATEX_FILE
echo "\\caption{Age (x-axis) vs Cholesterol (y-axis)}" >> $LATEX_FILE
echo "\\label{fig:image3}" >> $LATEX_FILE
echo "\\end{figure}" >> $LATEX_FILE

# Referencing the image in the text
echo "As shown in Figure \\ref{fig:image3} shows the correlation between Age (x-axis) vs Cholesterol (y-axis)" >> $LATEX_FILE

echo "\\section{pie chart to show the percentage of age groups that have heart disease}" >> $LATEX_FILE
echo "\\begin{figure}[H]" >> $LATEX_FILE
echo "\\centering" >> $LATEX_FILE
echo "\\includegraphics[width=0.5\\textwidth]{ques4(d).png}" >> $LATEX_FILE
echo "\\caption{pie chart to show the percentage of age groups that have heart disease}" >> $LATEX_FILE
echo "\\label{fig:image4}" >> $LATEX_FILE
echo "\\end{figure}" >> $LATEX_FILE

# Referencing the image in the text
echo "As shown in Figure \\ref{fig:image4} shows pie chart to show the percentage of age groups that have heart disease" >> $LATEX_FILE
echo "\\end{document}" >> "$LATEX_FILE"
 
echo "LaTeX table generated successfully! You can compile $LATEX_FILE to create the PDF."

