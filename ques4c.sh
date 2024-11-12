#!/bin/bash

FILE=$1

if [[ ! -f "$FILE" ]]; then
    echo "File not found!"
    exit 1
fi

DATA_FILE="age_cholesterol_data.dat"
> "$DATA_FILE" 
while IFS=, read -r age sex chestpain bloodpressure cholesterol bloodsugar maxheartrate heartdisease; do
    if [[ "$age" == "Age" ]]; then
        continue
    fi
    if [[ "$heartdisease" == "0" ]]; then
        echo "$age $cholesterol" >> "$DATA_FILE"
    fi
done < "$FILE"

gnuplot << EOF
set terminal png size 800,600
set output 'ques4(c).png'

set title "Correlation Between Age and Cholesterol (No Heart Disease)"
set xlabel "Age"
set ylabel "Cholesterol"

# Plot the data points using line points
plot '$DATA_FILE' using 1:2 with linespoints pt 7 ps 1.5 title 'Age vs Cholesterol'
EOF

echo "Plot saved as ques4(c).png"

