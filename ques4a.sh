#!/bin/bash

FILE=$1

if [[ ! -f "$FILE" ]]; then
    echo "File not found!"
    exit 1
fi

SEX_1=0
SEX_0=0

while IFS=, read -r id sex other; do
    if [[ "$id" == "ID" ]]; then
        continue
    fi

    if [[ "$sex" -eq 1 ]]; then
        ((SEX_1++))
    elif [[ "$sex" -eq 0 ]]; then
        ((SEX_0++))
    fi
done < "$FILE"

echo "0 $SEX_0" > sex_count.dat
echo "1 $SEX_1" >> sex_count.dat
gnuplot << EOF
set terminal pdf
set output 'quest4(a).pdf'

set boxwidth 0.5
set style fill solid 0.5
set xlabel "Sex"
set ylabel "Count"
set title "Histogram of Sex vs Count"
set xtics ("Female" 0,"Male" 1)
plot 'sex_count.dat' using 2:xtic(1) with boxes notitle
EOF

echo "Histogram saved as quest4(a).pdf"

