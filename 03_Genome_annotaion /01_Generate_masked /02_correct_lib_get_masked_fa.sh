#!/bin/bash

###############################################################################
# Script: run_repeatmasker_reclassification.sh
#
# Description:
# Reclassify the AnnoTEP TE library and rerun RepeatMasker using the updated
# library to improve TE subclassification.
#
# Usage:
#   bash run_repeatmasker_reclassification.sh \
#       <annotep_library.fa> <genome.fasta> <threads> <output_dir>
#
# Example:
#   bash run_repeatmasker_reclassification.sh \
#       library.fasta.mod.EDTA.TElib.fa \
#       Genome.v1.unmasked.fasta \
#       50 \
#       repeatmasker_results
###############################################################################

set -euo pipefail

if [ "$#" -ne 4 ]; then
    echo ""
    echo "Usage:"
    echo "  bash run_repeatmasker_reclassification.sh <annotep_library.fa> <genome.fasta> <threads> <output_dir>"
    echo ""
    echo "Example:"
    echo "  bash run_repeatmasker_reclassification.sh biblioteca_ANNOTEP.fa genome.fasta 50 repeatmasker_results"
    exit 1
fi

LIBRARY=$1
GENOME=$2
THREADS=$3
OUTDIR=$4

if [ ! -f "$LIBRARY" ]; then
    echo "ERROR: Library file not found: $LIBRARY"
    exit 1
fi

if [ ! -f "$GENOME" ]; then
    echo "ERROR: Genome file not found: $GENOME"
    exit 1
fi

mkdir -p "$OUTDIR"

UPDATED_LIBRARY="${OUTDIR}/$(basename "${LIBRARY%.fa}").repeatmasker.fa"

echo "========================================"
echo "Updating TE classifications..."
echo "========================================"

awk '
/^>/{
    split($0,a,"#");
    cls=a[2];

    if(cls ~ /^LTR\/Gypsy\//) cls="LTR/Gypsy";
    else if(cls ~ /^LTR\/Copia\//) cls="LTR/Copia";
    else if(cls ~ /^RC\/Helitron/) cls="DNA/Helitron";
    else if(cls ~ /^TR_GAG\/(Ogre|Retand)/) cls="LTR/Gypsy";
    else if(cls=="LARD") cls="LTR/LARD";
    else if(cls=="TRIM-like") cls="LTR/TRIM";
    else if(cls=="MITE") cls="MITE/unknown";
    else if(cls=="TIR/Unknown") cls="DNA/unknown";
    else if(cls=="TIR/EnSpm_CACTA") cls="DNA/En-Spm";

    print a[1]"#"cls;
    next
}
1
' "$LIBRARY" > "$UPDATED_LIBRARY"

echo "Updated library:"
echo "  $UPDATED_LIBRARY"

echo ""
echo "========================================"
echo "Running RepeatMasker..."
echo "========================================"

RepeatMasker \
    -pa "$THREADS" \
    -lib "$UPDATED_LIBRARY" \
    -dir "$OUTDIR" \
    -a \
    -noisy \
    -xsmall \
    -gff \
    "$GENOME"

echo ""
echo "========================================"
echo "RepeatMasker completed successfully!"
echo "Results saved in:"
echo "  $OUTDIR"
echo "========================================"
