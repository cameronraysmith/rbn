set terminal svg size 600,400 dynamic enhanced fname 'HelveticaNeue' fsize 16
set output '../fig/apstab3x3.svg'
set key off
set xrange [2:10]
set xtics (3,4,5,6,7,8,9)
set xlabel "connectivity"
set yrange [0.05:0.15]
set ytics (0.05,0.10,0.15)
set ylabel "probability of stability"
plot './stab3x3.tsv' using 1:2 pt 7 ps 0.7 lc 0 title columnheader
plot './avgstab3x3.tsv' using 1:3 pt 7 ps 0.7 lc 1
