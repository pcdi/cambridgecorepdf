# Archived

This project is archived, please see the improved version [here]( https://github.com/pcdi/cambridge_core_downloader).

# Cambridge Core PDF Tool
This tool provides functionality toward PDFs downloaded from [Cambridge Core](https://www.cambridge.org/core). It extracts the archive(s), merges the PDFs into one PDF and adds chapter bookmarks. 

## Prerequisites
The tool relies on [PDFtk](https://www.pdflabs.com/tools/pdftk-server/).

Download and save the script, then make it executable:
```bash
chmod +x cambridgecorepdf.sh
```

## Usage
Download a book from Cambridge Core:
> Actions for selected content: > Select all > Download PDF (zip)

If the contents view has more than one page, only the chapters on the currently selected page will be downloaded, so you need to repeat this step until all chapters have been downloaded.

To merge the split PDFs, use
```bash
./cambridgecorepdf.sh file.zip [file.zip ...]
```
where `file.zip` are the downloaded files from Cambridge Core.

Example usage:
```bash
./cambridgecorepdf.sh cambridge-core_to-govern-china_15Aug2019.zip cambridge-core_to-govern-china_15Aug2019\(1\).zip
```
