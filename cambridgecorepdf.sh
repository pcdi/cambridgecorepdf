#!/bin/bash
shopt -s nullglob

# Cambridge Core PDF
# Merges and Bookmarks PDFs from Cambridge Core
#
# Dependencies: pdftk awk

if [[ "$#" -eq 0 ]] || [[ "$1" == "-h" ]]; then
  echo "Cambridge Core PDF Tool 2020-05-18 Philipp Immel
This tool works on zip archives of PDFs downloaded from Cambridge Core.
It extracts the archives, merges the PDFs into one PDF and adds chapter bookmarks. 

Usage: $(basename "$0") file[.zip]"
  exit 0
fi

# Unzip the archive
INFILE=$1
BOOKNAME=$(echo $1 | cut -d'_' -f2)
OUTDIR=$BOOKNAME

mkdir $OUTDIR
unzip $INFILE -d $OUTDIR
cd $OUTDIR

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
