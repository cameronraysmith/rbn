set terminal svg size 600,400 dynamic enhanced fname 'arial'  fsize 10
# system "rm ../fig/stab3x3.svg"
set output '../fig/stab3x3.svg'
set xrange [1:10]
plot './stab3x3.tsv' using 1:3 pt 7 ps 1 lc 0 title columnheader

#system "rsvg-convert -f pdf -o ../fig/stab3x3.pdf ../fig/stab3x3.svg"
#system "evince ../fig/stab3x3.pdf"
