# !/bin/bash
hic=/files_path/hic/

##### activate conda environment #####
conda activate yahs

##### simple statistics of FASTA/Q files #####
seqkit stats -a -j 2 $hic/hic.R1.fq.gz $hic/hic.R2.fq.gz > hic_stats.txt
