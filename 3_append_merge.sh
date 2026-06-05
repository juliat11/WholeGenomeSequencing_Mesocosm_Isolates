#!/bin/bash
#===============================================================================
# Title          : 3_append_merge.sh
# Description    : Append filename as new column and merge all .with_file.txt into one file
# Author         : Julia Thiffault, inspired by Julius Eyiuche Nweze
# Date           : 05/06/2026
# Version        : v1
# Usage          : ./3_append_merge.sh
#===============================================================================

WKDIR="/Users/juliathiffault/Desktop/genes"
INPUT="$WKDIR/TXT"
OUTPUT="$WKDIR/Result"
MERGED="$WKDIR/Merged_genes_hits.txt"

# Ensure output directory exists
mkdir -p "$OUTPUT"

# Temporary file to store merged content before dedup
TEMP="$OUTPUT/temp_merged.txt"
> "$TEMP"

# Loop through each .output.txt file
for f in "$INPUT"/*.output.txt; do
    filename=$(basename "$f")
    awk -v fname="$filename" '{print $0 "\t" fname}' "$f" >> "$TEMP"
done

# Remove duplicate rows while retaining order
awk '!seen[$0]++' "$TEMP" > "$MERGED"

# Remove temporary file
rm "$TEMP"

echo "✅ All files processed, merged, and duplicates removed. Output: $MERGED"

