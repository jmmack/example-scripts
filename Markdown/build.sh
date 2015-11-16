#!/usr/bin/env bash

set -e

FILE=$1
FIGS="figure"

rm -rf "${FIGS}"
Rscript -e "library(knitr); knit('${FILE}.Rmd')"
pandoc $1.md -o $1.pdf

