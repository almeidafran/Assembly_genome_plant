#!/usr/bin/env bash

set -euo pipefail

#############################################
# K-mer analysis with Jellyfish and GenomeScope2
# Tests k = best_k, 21, and 31
#############################################

#############################################
# User settings
#############################################

# Expected genome size in bp
# Example: 650 Mb = 650000000
GENOME_SIZE=650000000

# PacBio HiFi reads
READS="hifi_reads.fq.gz"

# Number of threads
THREADS=24

# Jellyfish hash size
# Adjust according to genome size and sequencing depth.
HASH_SIZE=1000000000

# Path to Merqury best_k.sh script
BEST_K_SCRIPT="./best_k.sh"

# Output directory
OUTDIR="kmer_jellyfish_genomescope"

mkdir -p "${OUTDIR}"

#############################################
# 1. Determine the optimal k-mer size
#############################################

echo "Running best_k.sh for genome size = ${GENOME_SIZE}..."

"${BEST_K_SCRIPT}" "${GENOME_SIZE}" | tee "${OUTDIR}/best_k.log"

# Try to automatically extract the recommended k value.
# The output format may vary depending on the best_k.sh version.
BESTK=$(grep -Eo 'k[[:space:]]*=?[[:space:]]*[0-9]+' "${OUTDIR}/best_k.log" \
    | grep -Eo '[0-9]+' \
    | tail -n 1 || true)

# If the pattern above fails, try to capture the last plausible k value.
if [[ -z "${BESTK}" ]]; then
    BESTK=$(grep -Eo '[0-9]+' "${OUTDIR}/best_k.log" \
        | awk '$1 >= 15 && $1 <= 101' \
        | tail -n 1 || true)
fi

# Stop if best_k could not be detected.
if [[ -z "${BESTK}" ]]; then
    echo "ERROR: Could not automatically detect the best k value from ${OUTDIR}/best_k.log"
    echo "Please check the log file and define BESTK manually in the script."
    exit 1
fi

echo "Detected best k: ${BESTK}"

#############################################
# 2. Define k-mer sizes to test
#############################################

# Include best_k, 21, and 31, removing duplicates.
K_LIST=$(printf "%s\n21\n31\n" "${BESTK}" | sort -n -u)

echo "The following k-mer sizes will be tested:"
echo "${K_LIST}"

#############################################
# 3. Run Jellyfish and GenomeScope2 for each k
#############################################

for K in ${K_LIST}; do

    echo "============================================="
    echo "Starting analysis for k=${K}"
    echo "============================================="

    KDIR="${OUTDIR}/k${K}"
    mkdir -p "${KDIR}"

    PREFIX="${KDIR}/hifi_reads.k${K}"

    #############################################
    # Count k-mers from PacBio HiFi reads
    #############################################

    echo "Counting k-mers with Jellyfish for k=${K}..."

    jellyfish count \
        -C \
        -m "${K}" \
        -s "${HASH_SIZE}" \
        -t "${THREADS}" \
        "${READS}" \
        -o "${PREFIX}.jf"

    #############################################
    # Generate k-mer frequency histogram
    #############################################

    echo "Generating k-mer frequency histogram for k=${K}..."

    jellyfish histo \
        -t "${THREADS}" \
        "${PREFIX}.jf" \
        > "${PREFIX}.histo"

    #############################################
    # GenomeScope2 analysis
    #############################################

    echo "Running GenomeScope2 for k=${K}..."

    mkdir -p "${KDIR}/genomescope2"

    genomescope2 \
        --input "${PREFIX}.histo" \
        --output "${KDIR}/genomescope2" \
        --kmer_length "${K}"

    echo "Analysis completed for k=${K}"
    echo "Results are available in: ${KDIR}"

done

echo "============================================="
echo "All analyses completed successfully."
echo "Final output directory: ${OUTDIR}"
echo "============================================="
