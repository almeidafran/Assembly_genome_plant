# !/bin/bash

# Generate PacBio CCS (HiFi) reads from raw subreads
# Input: PacBio subreads BAM file
# Output: Compressed FASTQ file containing high-fidelity (HiFi) consensus reads
#
# The CCS algorithm combines multiple passes of the same DNA molecule
# to generate highly accurate consensus sequences. In this example,
# only reads with at least three passes are retained.

##### activate conda environment #####
conda activate yahs

##### extract ccs reads #####
nohup ccs raw.subreads.bam ccs.fastq.gz --min-passes 3 \
--report-file ccs_report.txt --log-file ccs.log -j 32 &

