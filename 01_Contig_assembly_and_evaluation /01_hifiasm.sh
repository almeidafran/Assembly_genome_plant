#!/usr/bin/env bash


#############################################
# Run hifiasm with PacBio HiFi + Hi-C reads
#############################################

# Input files
HIFI="ccs.filt.fastq.gz"
HIC_R1="hic.R1.fq.gz"
HIC_R2="hic.R2.fq.gz"

# Output prefix
PREFIX="output.asm"

# Number of threads
THREADS=32

# Run hifiasm
hifiasm \
    -o "$PREFIX" \
    -t "$THREADS" \
    --h1 "$HIC_R1" \
    --h2 "$HIC_R2" \
    "$HIFI"

#############################################
# Convert GFA output files to FASTA
#############################################

# Primary contigs
awk '/^S/{print ">"$2; print $3}' "${PREFIX}.bp.p_ctg.gfa" > "${PREFIX}.bp.p_ctg.fa"

# Haplotype-resolved contigs
awk '/^S/{print ">"$2; print $3}' "${PREFIX}.bp.hap1.p_ctg.gfa" > "${PREFIX}.bp.hap1.p_ctg.fa"
awk '/^S/{print ">"$2; print $3}' "${PREFIX}.bp.hap2.p_ctg.gfa" > "${PREFIX}.bp.hap2.p_ctg.fa"
