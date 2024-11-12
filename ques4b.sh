#!/bin/bash


FILE=$1
if [[ ! -f "$FILE" ]]; then
    echo "File not found!"
    exit 1
fi

DATA_FILE="age_bp_data.dat"
> "$DATA_FILE" 


while IFS=, read -r age sex other bp; do

    if [[ "$age" == "Age" ]]; then
        continue
    fi
    echo "$age $bp" >> "$DATA_FILE"
done < "$FILE"

echo "Data extracted and saved to $DATA_FILE"


gnuplot << EOF
set terminal png size 800,600
set output 'ques4(b).png'

set title "Correlation Between Age and Blood Pressure"
set xlabel "Age"
set ylabel "Blood Pressure"

# Plot data points using the extracted file
plot '$DATA_FILE' using 1:2 with points pt 7 ps 1.5 title 'Age vs Blood Pressure'
EOF

echo "Plot saved as ques4(b).png"

