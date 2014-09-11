#!/bin/bash

# usage:
#   ./plot.sh stab3x3

gnuplot $1.p
rsvg-convert -f pdf -o ../fig/$1.pdf ../fig/$1.svg
evince ../fig/$1.pdf
