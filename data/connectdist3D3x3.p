# set terminal svg size 600,400 dynamic enhanced fname 'HelveticaNeue'  fsize 16
set terminal svg size 600,400 dynamic enhanced fname 'HelveticaNeue' fsize 16
set output '../fig/connectdist3D3x3.svg'
set key off
set autoscale
set parametric

# x-axis
set yrange [-1:6] reverse
set ytics (0,1,2,3,4,5)
set ylabel "hierarchy" # offset 0,-0.5

# y-axis
set xrange [2:10]
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
set palette negative
plot './stab3x3.tsv' using 1:5:3 with points palette pt 7 ps 0.7 title columnheader
