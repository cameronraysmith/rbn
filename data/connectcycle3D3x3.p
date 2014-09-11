# set terminal svg size 600,400 dynamic enhanced fname 'HelveticaNeue'  fsize 16
set terminal svg size 600,400 dynamic enhanced fname 'HelveticaNeue' fsize 16
set output '../fig/connectcycle3D3x3.svg'
set key off
set autoscale
set parametric
set xrange [-1:6]
set xtics (0,1,2,3,4,5)
set xlabel "number of cycles" offset 0,-0.5
set yrange [2:10]
set ytics (3,4,5,6,7,8,9) offset 0.5,-0.2
set ylabel "connectivity" offset 0,-0.5
set zrange [0.3:0.9]
set ztics (0.4,0.5,0.6,0.7,0.8) offset 2,0
set zlabel "probability" rotate by 90 offset 0,-0.5
splot './stab3x3.tsv' using 4:1:3 pt 7 ps 0.7 lc 0 title columnheader
