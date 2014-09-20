set terminal svg size 1200,1200 dynamic enhanced fname 'HelveticaNeue'  fsize 16
set output '../fig/combinedfigs.svg'
set multiplot layout 3,2
set tmargin 3
set bmargin 3
set lmargin 10
set rmargin 5

############# plot 1 ##############

set key off
set xrange [2:10]
set xtics (3,4,5,6,7,8,9)
set xlabel "connectivity"
set yrange [0.05:0.15]
set ytics (0.05,0.10,0.15)
set label 1 "A" font "HelveticaNeue, 23" at graph -0.25, graph 1.20
set ylabel "probability of stability"
plot './stab3x3.tsv' using 1:2 pt 7 ps 0.7 lc 0 title columnheader, './avgstab3x3.tsv' using 1:3 pt 7 ps 0.7 lc 1

############# plot 2 ##############

# system "rm ../fig/stab3x3.svg"
set key off
set xrange [2:10]
set xtics (3,4,5,6,7,8,9)
set xlabel "connectivity"
set yrange [0.3:0.9]
set ytics (0.4,0.5,0.6,0.7,0.8)
set label 1 "B" font "HelveticaNeue, 23" at graph -0.25, graph 1.20
set ylabel "robustness"
plot './stab3x3.tsv' using 1:3 pt 7 ps 0.7 lc 0 title columnheader, './avgstab3x3.tsv' using 1:2 pt 7 ps 0.7 lc 1

############# plot 3 ##############

set key off
set xrange [-1:6]
set xtics (0,1,2,3,4,5)
set xlabel "number of cycles"
set yrange [0.3:0.9]
set ytics (0.4,0.5,0.6,0.7,0.8)
set label 1 "C" font "HelveticaNeue, 23" at graph -0.25, graph 1.20
set ylabel "robustness"
plot './stab3x3.tsv' using 4:3 pt 7 ps 0.7 lc 0 title columnheader

############# plot 4 ##############

set key off
set xrange [-1:7]
set xtics (0,1,2,3,4,5,6)
set xlabel "graph edit distance"
set yrange [0.3:0.9]
set ytics (0.4,0.5,0.6,0.7,0.8)
set label 1 "D" font "HelveticaNeue, 23" at graph -0.25, graph 1.20
set ylabel "robustness"
plot './stab3x3.tsv' using 5:3 pt 7 ps 0.7 lc 0 title columnheader

############# plot 5 ##############

set key off
set autoscale
set parametric

# x-axis
set yrange [-1:6] reverse
set ytics (0,1,2,3,4,5)
set ylabel "number of cycles" offset 0,-0.5

# y-axis
set xrange [2:10]
set xtics (3,4,5,6,7,8,9) offset 0.5,-0.2
set xlabel "connectivity" offset 0,-0.5

# z-axis
# set zrange [0.3:0.9]
# set ztics (0.4,0.5,0.6,0.7,0.8) offset 2,0
# set zlabel "probability" rotate by 90 offset 0,-0.5

# colorbar
set cbrange [0.4:0.8]
set cbtics (0.4,0.5,0.6,0.7,0.8)
set cblabel "probability"

# set pm3d
# set palette
# unset pm3d
load('RdBu.plt')
set label 1 "E" font "HelveticaNeue, 23" at graph -0.25, graph 1.20
set palette negative
plot './stab3x3.tsv' using 1:4:3 with points palette pt 7 ps 0.7 title columnheader

############# plot 6 ##############

set key off
set autoscale
set parametric

# x-axis
set yrange [-1:7] reverse
set ytics (0,1,2,3,4,5,6)
set ylabel "graph edit distance" offset 0,-0.5

# y-axis
set xrange [2:10]
set xtics (3,4,5,6,7,8,9) offset 0.5,-0.2
set xlabel "connectivity" offset 0,-0.5

# z-axis
# set zrange [0.3:0.9]
# set ztics (0.4,0.5,0.6,0.7,0.8) offset 2,0
# set zlabel "probability" rotate by 90 offset 0,-0.5

# colorbar
set cbrange [0.4:0.8]
set cbtics (0.4,0.5,0.6,0.7,0.8)
set cblabel "probability"

# set pm3d
# set palette
# unset pm3d
load('RdBu.plt')
set label 1 "F" font "HelveticaNeue, 23" at graph -0.25, graph 1.20
set palette negative
plot './stab3x3.tsv' using 1:5:3 with points palette pt 7 ps 0.7 title columnheader
unset multiplot
