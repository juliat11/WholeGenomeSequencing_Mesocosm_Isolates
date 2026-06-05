#!/bin/bash
#===============================================================================
# Title          : 2_blastp.sh
# Description    : Search for genes in sequenced genomes and extract homologous sequences
# Author         : Julia Thiffault, inspired by Julius Eyiuche Nweze
# Date           : 05/06/2026
# Version        : V.1
# Usage          : ./2_blastp.sh
#===============================================================================

# Set directories
WORKDIR="/Users/juliathiffault/Desktop/genes"
DATABASE="/Users/juliathiffault/Desktop/genes/Database"
OUTPUT1="$WORKDIR/Genes"
OUTPUT2="$WORKDIR/TXT"
OUTPUT3="$WORKDIR/TXT_complete"

# Ensure output directories exist
mkdir -p "$OUTPUT1" "$OUTPUT2" "$OUTPUT3"

# Index or Create a BLAST database from concatenated MAGs
echo "Creating BLAST database..."
makeblastdb -in "$WORKDIR/merged_proteins.faa" -dbtype prot -parse_seqids -out "$DATABASE/NA_proteins_DB"

# Loop through all gene files and search for homologs
for i in "$WORKDIR/KO"/*.fna; do
    basename=$(basename "$i" .fna)
    echo "Running BLAST for $basename..."

    # Run BLAST search
    blastp -query "$i" -db "$DATABASE/NA_proteins_DB" \
    -out "$OUTPUT2/${basename}.output.txt" -evalue 1e-30 -outfmt '6 sseqid'

    # Extract matching sequences
    if [ -s "$OUTPUT2/${basename}.output.txt" ]; then
        blastdbcmd -db "$DATABASE/NA_proteins_DB" \
        -entry_batch "$OUTPUT2/${basename}.output.txt" \
        -out "$OUTPUT1/${basename}.fna" -outfmt '%f'
    else
        echo "No hits found for $basename"
    fi
done

# Loop through all gene files and create outputs with more parameters
for i in "$WORKDIR/KO"/*.fna; do
    basename=$(basename "$i" .fna)
    echo "Running BLAST for $basename..."

    # Run BLAST search
    blastp -query "$i" -db "$DATABASE/NA_proteins_DB" \
    -out "$OUTPUT3/${basename}.output.txt" -evalue 1e-30 -outfmt '6 sseqid pident length mismatch gapopen evalue bitscore qcovs'

done

echo "All BLAST searches complete."

