#!/bin/bash
shopt -s nullglob

# Cambridge Core PDF
# Merges and Bookmarks PDFs from Cambridge Core
#
# Dependencies: pdftk awk

# Unzip the archive

# Make bookmarks
BMFILE=bookmarks.txt
pageno=1

for file in *.pdf; do
    echo "BookmarkBegin" >> $BMFILE
    
    # Extract section titles from file names
    sectiontitle=$(echo $file | cut -d'_' -f5- | sed s/'_'/' '/g | sed s/'\.pdf'//g)
    echo "BookmarkTitle:" $sectiontitle >> $BMFILE
    echo "BookmarkLevel: 1" >> $BMFILE
    
    # Calculate page numbers for bookmarks
    echo "BookmarkPageNumber:" $pageno >> $BMFILE
    pageno=$(($pageno+$(pdftk $file dump_data | awk '/'NumberOfPages'/ {print $2}')))
done

# Merge files
MERGED=merged.pdf
pdftk *.pdf cat output $MERGED

# Add bookmarks to pdf
pdftk $MERGED update_info $BMFILE output out.pdf

# Clean up
rm $MERGED $BMFILE
