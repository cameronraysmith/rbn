set terminal svg size 600,400 dynamic enhanced fname 'HelveticaNeue'  fsize 16
# system "rm ../fig/stab3x3.svg"
set output '../fig/stab3x3.svg'
set key off
set xrange [2:10]
set xtics (3,4,5,6,7,8,9)
set xlabel "connectivity"
set yrange [0.3:0.9]
set ytics (0.4,0.5,0.6,0.7,0.8)
set ylabel "probability of stability to perturbation"
plot './stab3x3.tsv' using 1:3 pt 7 ps 0.7 lc 0 title columnheader

#system "rsvg-convert -f pdf -o ../fig/stab3x3.pdf ../fig/stab3x3.svg"
#system "evince ../fig/stab3x3.pdf"
