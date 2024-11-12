#!/bin/bash

# Define input and output files
input_csv="heart.csv"
output_csv="age_group_counts.csv"
gnuplot_script="heart_disease_pie_chart.gp"

# Step 1: Process the input CSV to count occurrences of heart disease by age group
awk -F, 'NR > 1 {
    age=$1
    heart_disease=$8
    if (heart_disease == 1) {
        if (age >= 40 && age < 50) age_group="40-50";
        else if (age >= 50 && age < 60) age_group="50-60";
        else if (age >= 60 && age < 70) age_group="60-70";
        else if (age >= 70 && age < 80) age_group="70-80";
        else if (age >= 80 && age < 90) age_group="80-90";
        else if (age >= 90) age_group="90-100";
        print age_group;
    }
}' $input_csv | sort | uniq -c | awk '{print $2 "," $1}' > $output_csv

# Step 2: Add headers and calculate total cases
awk 'BEGIN {
    total=0;
    while ((getline line < "'"$output_csv"'") > 0) {
        split(line, fields, ",");
        total += fields[2];
    }
    close("'"$output_csv"'");

    print "Age Group,Count,Percentage";
    while ((getline line < "'"$output_csv"'") > 0) {
        split(line, fields, ",");
        percentage = fields[2] / total * 100;
        print fields[1] "," fields[2] "," percentage;
    }
}' > temp.csv && mv temp.csv $output_csv

# Step 3: Generate gnuplot script for pie chart
cat << EOF > heart_disease_pie_chart.gp
set terminal png size 800,600
set output '$output_img'
set title "Heart Disease by Age Group"
set key out top box
set style fill solid 1.0 border -1
set angles degree
set size square

# Define starting angle
start_angle = 0

# Define the angles based on percentage for each slice
a1 = 36      # 40-50
a2 = a1 + 61.2    # 50-60
a3 = a2 + 97.2    # 60-70
a4 = a3 + 108     # 70-80
a5 = a4 + 46.8    # 80-90
a6 = a5 + 10.8    # 90-100

# Define colors
colors = "red, blue, cyan, green, yellow, orange"

# Plot each slice as a separate object
set obj 1 circle arc [0:a1] fc rgb "red"
set obj 2 circle arc [a1:a2] fc rgb "blue"
set obj 3 circle arc [a2:a3] fc rgb "cyan"
set obj 4 circle arc [a3:a4] fc rgb "green"
set obj 5 circle arc [a4:a5] fc rgb "yellow"
set obj 6 circle arc [a5:a6] fc rgb "orange"

# Set each object at the center of the plot
set obj 1 circle at 0,0 size 1 front
set obj 2 circle at 0,0 size 1 front
set obj 3 circle at 0,0 size 1 front
set obj 4 circle at 0,0 size 1 front
set obj 5 circle at 0,0 size 1 front
set obj 6 circle at 0,0 size 1 front

# Show the plot
plot NaN title "facecream" with lines lc "red", \
     NaN title "facewash" with lines lc "blue", \
     NaN title "toothpaste" with lines lc "cyan", \
     NaN title "bathingsoap" with lines lc "green", \
     NaN title "shampoo" with lines lc "yellow", \
     NaN title "moisturizer" with lines lc "orange"

EOF

gnuplot heart_disease_pie_chart.gp

echo "Pie chart generated as ques4(d).png"


