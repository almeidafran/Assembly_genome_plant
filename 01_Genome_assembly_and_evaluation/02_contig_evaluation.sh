#!/usr/bin/env bash


#############################################
# Assembly evaluation: QUAST, BUSCO, Merqury
#############################################

# Input FASTA files from hifiasm
PRIMARY="output.asm.bp.p_ctg.fa"
HAP1="output.asm.bp.hap1.p_ctg.fa"
HAP2="output.asm.bp.hap2.p_ctg.fa"

# PacBio HiFi reads for Merqury
HIFI_READS="ccs.filt.fastq.gz"

# Threads
THREADS=24

#############################################
# QUAST
#############################################

mkdir -p quast_results

for ASM in "$PRIMARY" "$HAP1" "$HAP2"; do
    NAME=$(basename "$ASM" .fa)

    quast.py \
        "$ASM" \
        --split-scaffolds \
        -t "$THREADS" \
        -o "quast_results/${NAME}"
done

#############################################
# BUSCO
#############################################

mkdir -p busco_results

for ASM in "$PRIMARY" "$HAP1" "$HAP2"; do
    NAME=$(basename "$ASM" .fa)

    busco \
        -i "$ASM" \
        -o "${NAME}_embryophyta_odb10" \
        -m genome \
        -l embryophyta_odb10 \
        -c "$THREADS" \
        --out_path busco_results
done

#############################################
# Merqury
#############################################

# Count k-mers from HiFi reads
meryl count \
    k=31 \
    "$HIFI_READS" \
    output hifi.meryl

# Evaluate haplotype-resolved assembly
merqury.sh \
    hifi.meryl \
    "$HAP1" \
    "$HAP2" \
    merqury_out
