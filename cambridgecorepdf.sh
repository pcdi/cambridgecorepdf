#!/bin/bash
shopt -s nullglob

# Cambridge Core PDF
# Merges and Bookmarks PDFs from Cambridge Core
#
# Dependencies: pdftk awk

# Unzip the archive

# Merge files
pdftk *.pdf cat output merged.pdf

# Extract section titles from file names
for filename in *.pdf; do
    filename=$(echo $filename | cut -d'_' -f5- | sed s/'_'/' '/g | sed s/'\.pdf'//g)
    echo $filename
done

# Calculate page numbers for bookmarks
pageno=1
for file in *.pdf; do
    echo $pageno
    pageno=$(($pageno+$(pdftk $file dump_data | awk '/'NumberOfPages'/ {print $2}')))
done
