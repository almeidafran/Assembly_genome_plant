#!/bin/bash

#############################################
# K-mer analysis with Jellyfish and GenomeScope
#############################################

# Determine the optimal k-mer size for Merqury
# Script available at:
# https://github.com/marbl/merqury/blob/master/best_k.sh

./best_k.sh <genome_size>

#############################################
# Count k-mers from PacBio HiFi reads
#############################################
bestk=19 #Replace with the optimal k-mer size estimated by best_k.sh, or to your preference.
jellyfish count \
    -C \
    -m $bestk \
    -s 1000000000 \
    -t 24 \
    hifi_reads.fq \
    -o hifi_reads.jf

#############################################
# Generate k-mer frequency histogram
#############################################

jellyfish histo \
    -t 24 \
    hifi_reads.jf \
    > hifi_reads.histo

#############################################
# GenomeScope analysis
#############################################
genomescope2 --input jellyfish.histo --output . --kmer_length $bestk 

#or
# Upload the histogram file (hifi_reads.histo)
# to GenomeScope:
#
# http://genomescope.org
#
# GenomeScope estimates:
#   - Genome size
#   - Heterozygosity
#   - Repeat content
#   - Sequencing error rate
#
# based on the k-mer frequency distribution.
