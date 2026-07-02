#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 4 ]; then
    echo "Usage: bash run_eggnog_mapper.sh <proteins.fa> <eggnog_data_dir> <threads> <outdir>"
    exit 1
fi

PROTEINS=$1
EGGNOG_DB=$2
THREADS=$3
OUTDIR=$4

mkdir -p "$OUTDIR"/eggnog

emapper.py \
    -i "$PROTEINS" \
    --itype proteins \
    --cpu "$THREADS" \
    --data_dir "$EGGNOG_DB" \
    -o eggnog \
    --output_dir "$OUTDIR/eggnog"

echo "eggNOG-mapper finished: $OUTDIR/eggnog"
