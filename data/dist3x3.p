set terminal svg size 600,400 dynamic enhanced fname 'HelveticaNeue'  fsize 16
set output '../fig/dist3x3.svg'
set key off
set xrange [-1:7]
set xtics (0,1,2,3,4,5,6)
set xlabel "graph edit distance"
set yrange [0.3:0.9]
set ytics (0.4,0.5,0.6,0.7,0.8)
set ylabel "probability of stability to perturbation"
plot './stab3x3.tsv' using 5:3 pt 7 ps 0.7 lc 0 title columnheader