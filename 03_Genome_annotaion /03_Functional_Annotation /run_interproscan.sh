#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 3 ]; then
    echo "Usage: bash run_interproscan.sh <proteins.fa> <threads> <outdir>"
    exit 1
fi

PROTEINS=$1
THREADS=$2
OUTDIR=$3

mkdir -p "$OUTDIR"/interproscan

interproscan.sh \
    -i "$PROTEINS" \
    -cpu "$THREADS" \
    -dp \
    -f tsv,gff3 \
    -appl CDD,Gene3D,Hamap,NCBIfam,PANTHER,Pfam,PIRSF,PRINTS,ProSiteProfiles,ProSitePatterns,SMART,SUPERFAMILY,TIGRFAM \
    -b "$OUTDIR/interproscan/interpro"

echo "InterProScan finished:"
echo "$OUTDIR/interproscan/interpro.tsv"
echo "$OUTDIR/interproscan/interpro.gff3"
