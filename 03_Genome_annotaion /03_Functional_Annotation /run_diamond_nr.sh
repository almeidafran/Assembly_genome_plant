#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 4 ]; then
    echo "Usage: bash run_diamond_nr.sh <proteins.fa> <nr.dmnd> <threads> <outdir>"
    exit 1
fi

PROTEINS=$1
NR_DB=$2
THREADS=$3
OUTDIR=$4

mkdir -p "$OUTDIR"/diamond "$OUTDIR"/tmp

diamond blastp \
    --query "$PROTEINS" \
    --db "$NR_DB" \
    --threads "$THREADS" \
    --more-sensitive \
    --evalue 1e-5 \
    --max-target-seqs 1 \
    --max-hsps 1 \
    --outfmt 6 qseqid qlen sseqid slen pident length mismatch gapopen qstart qend sstart send evalue bitscore stitle \
    --tmpdir "$OUTDIR/tmp" \
    --out "$OUTDIR/diamond/nr.outfmt6.tsv"

echo "NR annotation finished: $OUTDIR/diamond/nr.outfmt6.tsv"
