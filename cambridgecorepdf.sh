#!/bin/bash
shopt -s nullglob

# Cambridge Core PDF
# Merges and Bookmarks PDFs from Cambridge Core
#
# Dependencies: pdftk awk

# Unzip the archive

# Merge files
# pdftk *.pdf cat output merged.pdf

pageno=1
for file in *.pdf; do
    # Extract section titles from file names
    sectiontitle=$(echo $file | cut -d'_' -f5- | sed s/'_'/' '/g | sed s/'\.pdf'//g)
    echo $sectiontitle
    # Calculate page numbers for bookmarks
    echo $pageno
    pageno=$(($pageno+$(pdftk $file dump_data | awk '/'NumberOfPages'/ {print $2}')))
done
