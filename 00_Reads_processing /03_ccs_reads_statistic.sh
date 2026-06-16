# !/bin/bash
filt_hifireads=/file_path/ccs.filt.fastq.gz

#####conda activate env###
conda activate yahs

##### simple statistics of FASTA/Q files #####
seqkit stats -a -j 2 $filt_hifireads > ccs.filt.fastq.stats.txt
