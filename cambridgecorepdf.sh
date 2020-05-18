#!/bin/bash

# Cambridge Core PDF
# Merges and Bookmarks PDFs from Cambridge Core
#
# Dependencies: pdftk

# Unzip the archive

# Merge files
pdftk *.pdf cat output merged.pdf
