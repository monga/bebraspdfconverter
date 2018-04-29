#!/bin/bash

# Mattia Monga, mattia.monga@unimi.it, 2017-05-26
# Initial verison

# Christian Datzko, christian.datzko@informatik-biber.ch, 2017-05-26:
# For compatibility with Ubuntu 16.04LTS as well as 14.04LTS (and probably many other flavors of Ubuntu or even Debian):
# - install wkhtmltopdf, unoconv (and no longer pdftk, 2018-04-28)
# - change first line of this file to #/bin/bash
# This does not work with html files that have spaces in its name.
# Headless running on a linux server (html -> pdf fails because no X server is running):
# - install xvfb
# - run xvfb-run --server-args="-screen 0, 1024x768x24" ./mkpdf.sh

# Mattia Monga, mattia.monga@unimi.it, 2017-05-27
# Space in file names are evil.... but not it works
# use a temporal var to cope with double quoting

# Ahto Truu, ahto.truu@ut.ee, 2017-05-27
# Now
# - keeps just one copy of a task that has both odt and html sources (odt preferred if both exist)
# - recognizes both *.htm and *.html as html inputs (html preferred if both exist)
# - survives colliding file names within separate directories
# - maintains task code order in the final pdf

# Ahto Truu, ahto.truu@ut.ee, 2017-06-01
# - version for the Accepted Tasks directory structure

# Christian Datzko, christian.datzko@informatik-biber.ch, 2018-03-16
# - added a variable for the bebras year and changed it throughout the script to have more flexibility

bebrasyear="2018"
# Christian Datzko, christian.datzko@informatik-biber.ch, 2018-04-28
# - replaced pdftk with Ghostscript, because pdftk is no longer available in Ubuntu 18.04 LTS


killall unoconv
unoconv -l &

rm -rf pdf
mkdir -p pdf/pdf
find -type d -name "$bebrasyear*" | while read d; do
    find "$d" -type f -name "$bebrasyear*" | grep -E 'htm$|html$' | sort | while read f; do
        echo html2pdf "$f" "pdf${d:1}.pdf"
        wkhtmltopdf "$f" "pdf${d:1}.pdf" 2> /dev/null
    done
    find "$d" -type f -name "$bebrasyear*" | grep -E 'odt$' | sort | while read f; do
        echo odt2pdf "$f" "pdf${d:1}.pdf"
        odt2pdf -o "pdf${d:1}.pdf" "$f" 2> /dev/null
    done
done
l=0
find pdf -type f -name "*.pdf" | sort | while read p; do
    t=$(printf "%03d" "$l")
    echo mv "$p" "pdf/pdf/$t.pdf"
    mv "$p" "pdf/pdf/$t.pdf"
    l=$(($l + 1))
done
echo gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -sOutputFile=all.pdf pdf/pdf/*.pdf
gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -sOutputFile=all.pdf pdf/pdf/*.pdf

echo gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dFirstPage=1 -dLastPage=1 -sOutputFile=all-first.pdf pdf/pdf/*.pdf
gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dFirstPage=1 -dLastPage=1 -sOutputFile=all-first.pdf pdf/pdf/*.pdf

rm -rf pdf
