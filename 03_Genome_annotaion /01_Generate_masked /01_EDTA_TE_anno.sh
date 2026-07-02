#!/bin/bash

###############################################################################
# Script: run_annotep.sh
#
# Description:
# Run AnnoTEP for transposable element annotation.
#
# Usage:
#   bash run_annotep.sh <genome.fasta> <threads> <output_dir>
#
# Example:
#   bash run_annotep.sh genome.fasta 32 annotep_results
###############################################################################

set -euo pipefail

#############################
# Check input parameters
#############################

if [ "$#" -ne 3 ]; then
    echo ""
    echo "Usage:"
    echo "  bash run_annotep.sh <genome.fasta> <threads> <output_dir>"
    echo ""
    echo "Example:"
    echo "  bash run_annotep.sh genome.fasta 32 annotep_results"
    exit 1
fi

GENOME=$1
THREADS=$2
OUTDIR=$3

#############################
# Check genome file
#############################

if [ ! -f "$GENOME" ]; then
    echo "ERROR: Genome file not found:"
    echo "  $GENOME"
    exit 1
fi

mkdir -p "$OUTDIR"

echo "========================================"
echo "Running AnnoTEP"
echo "Genome  : $GENOME"
echo "Threads : $THREADS"
echo "Output  : $OUTDIR"
echo "========================================"

annotep \
    --genome "$GENOME" \
    --species others \
    --step all \
    --threads "$THREADS" \
    --sensitive 1 \
    --anno 1 \
    --output "$OUTDIR"

echo ""
echo "========================================"
echo "AnnoTEP completed successfully!"
echo "Results saved in: $OUTDIR"
echo "========================================"
