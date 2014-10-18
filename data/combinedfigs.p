set terminal svg size 1200,800 dynamic enhanced fname 'HelveticaNeue'  fsize 20
set output '../fig/combinedfigs.svg'
set multiplot layout 2,2
set tmargin 3
set bmargin 3
set lmargin 10
set rmargin 5

############# plot 1 ##############

# system "rm ../fig/stab3x3.svg"
set key off
set xrange [2:10]
set xtics (3,4,5,6,7,8,9)
set xlabel "connectivity"
set yrange [0.3:0.9]
set ytics (0.4,0.5,0.6,0.7,0.8)
set ylabel "robustness"
f(x) = m*x + b
fit f(x) './stab3x3.tsv' using 1:3 via m,b
# plot './stab3x3.tsv' using 1:3 pt 7 ps 0.7 lc 0 title columnheader, './avgstab3x3.tsv' using 1:2 pt 7 ps 0.7 lc 1, f(x) lt rgb "red" lw 3
set label 1 "A" font "HelveticaNeue, 25" at graph -0.25, graph 1.20
plot './stab3x3.tsv' using 1:3 pt 7 ps 0.7 lc 0 title columnheader, f(x) lt rgb "red" lw 3
stats "./stab3x3.tsv" using 1:3 name "AB"

############# plot 2 ##############

set key off
set xrange [-1:6]
set xtics (0,1,2,3,4,5)
set xlabel "hierarchy"
set yrange [0.3:0.9]
set ytics (0.4,0.5,0.6,0.7,0.8)
set ylabel "robustness"
f(x) = m*x + b
fit f(x) './stab3x3.tsv' using (5-$5):3 via m,b
set label 1 "B" font "HelveticaNeue, 25" at graph -0.25, graph 1.20
plot './stab3x3.tsv' using (5-$5):3 pt 7 ps 0.7 lc 0 title columnheader, f(x) lt rgb "red" lw 3
stats "./stab3x3.tsv" using (5-$5):3 name "AB"

############# plot 3 ##############

set key off
set autoscale
set parametric

# x-axis
set yrange [-1:6] reverse
set ytics (0,1,2,3,4,5)
set ylabel "number of cycles" # offset 0,-0.5

# y-axis
set xrange [2:10] noreverse
set xtics (3,4,5,6,7,8,9) # offset 0.5,-0.2
set xlabel "connectivity" # offset 0,-0.5

# z-axis
# set zrange [0.3:0.9]
# set ztics (0.4,0.5,0.6,0.7,0.8) offset 2,0
# set zlabel "probability" rotate by 90 offset 0,-0.5

# colorbar
set cbrange [0.4:0.8]
set cbtics (0.4,0.5,0.6,0.7,0.8)
set cblabel "robustness"

# set pm3d
# set palette
# unset pm3d
load('RdBu.plt')
set label 1 "C" font "HelveticaNeue, 25" at graph -0.25, graph 1.20
set palette negative
plot './avgconnectcycle.tsv' using 1:4:3 with points palette pt 7 ps 0.7 title columnheader

############# plot 4 ##############

set key off
set autoscale
set parametric

# x-axis
set yrange [-1:6] noreverse
set ytics (0,1,2,3,4,5)
set ylabel "hierarchy" # offset 0,-0.5

# y-axis
set xrange [2:10] noreverse
set xtics (3,4,5,6,7,8,9) # offset 0.5,-0.2
set xlabel "connectivity" # offset 0,-0.5

# z-axis
# set zrange [0.3:0.9]
# set ztics (0.4,0.5,0.6,0.7,0.8) offset 2,0
# set zlabel "probability" rotate by 90 offset 0,-0.5

# colorbar
set cbrange [0.4:0.8]
set cbtics (0.4,0.5,0.6,0.7,0.8)
set cblabel "robustness"

# set pm3d
# set palette
# unset pm3d
load('RdBu.plt')
set label 1 "D" font "HelveticaNeue, 25" at graph -0.25, graph 1.20
set palette negative
plot './avgconnectdist.tsv' using 1:(5-$5):3 with points palette pt 7 ps 0.7 title columnheader
unset multiplot
