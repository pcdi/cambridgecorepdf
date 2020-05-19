#!/bin/bash
shopt -s nullglob

# Cambridge Core PDF
# Merges and Bookmarks PDFs from Cambridge Core
#
# Dependencies: pdftk awk

if [[ "$#" -eq 0 ]] || [[ "$1" == "-h" ]]; then
  printf "Cambridge Core PDF Tool 2020-05-19 Philipp Immel
This tool works on zip archives of PDFs downloaded from Cambridge Core.
It extracts the archives, merges the PDFs into one PDF and adds chapter bookmarks. 

Usage: $(basename "$0") file[.zip] [...]"
  exit 0
fi

printf "\\nCambridge Core PDF Tool 2020-05-19 Philipp Immel\\n\\n"

# Unzip the archive
printf "Unzipping the archive(s) ... "
INFILES=$@
BOOKNAME=$(echo $1 | cut -d'_' -f2)
OUTDIR=$BOOKNAME

mkdir $OUTDIR
for INFILE in $INFILES; do
    unzip $INFILE -d $OUTDIR > /dev/null
done
cd $OUTDIR
printf "done.\\n"

# Unify file naming for correct order, pad leading zeroes, pad trailing zero
printf "Unifying file names ... "
for file in *.pdf; do
    mv $file $(echo $file | sed -e 's/^[0-9]\{1\}\./00&/g; s/^[0-9]\{2\}\./0&/g; s/\([0-9]\)_/\1.0_/')
done
printf "done.\\n"

# Make bookmarks
printf "Making bookmarks ... "
BMFILE=bookmarks.txt
pageno=1

for file in *.pdf; do
    echo "BookmarkBegin" >> $BMFILE
    
    # Extract section titles from file names
    sectiontitle=$(echo $file | cut -d'_' -f5- | sed s/'_'/' '/g | sed s/'\.pdf'//g)
    echo "BookmarkTitle:" $sectiontitle >> $BMFILE

    # Extract bookmark level from file names
    bookmarklevel=$(echo $file | sed 's/\(\.0\)\{1,\}//g' | grep -io '\.' | wc -l)
    echo "BookmarkLevel:" $bookmarklevel >> $BMFILE
    
    # Calculate page numbers for bookmarks
    echo "BookmarkPageNumber:" $pageno >> $BMFILE
    pageno=$(($pageno+$(pdftk $file dump_data | awk '/'NumberOfPages'/ {print $2}')))
done
printf "done.\\n"

# Merge files
printf "Merging PDF files ... "
MERGED=merged.pdf
pdftk *.pdf cat output $MERGED
printf "done.\\n"

# Add bookmarks to pdf
printf "Adding bookmarks to merged PDF ... "
pdftk $MERGED update_info $BMFILE output $BOOKNAME.pdf
printf "done.\\n"

# Clean up
printf "Cleaning up ... "
rm $MERGED $BMFILE
printf "done.\\n\\n"
printf "The merged book PDF can be found at:\\n"
printf $BOOKNAME"/"$BOOKNAME".pdf\\n"
