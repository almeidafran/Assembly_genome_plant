# !/bin/bash
filt_hifireads=/file_path/ccs.filt.fastq.gz

#####conda activate env###
conda activate yahs

##### simple statistics of FASTA/Q files #####
seqkit stats -a -j 2 $filt_hifireads > ccs.filt.fastq.stats.txt

##Nanoplot: Although NanoPlot is specific to Nanopore data, it works well for checking HiFi read statistics.
#conda activate nanoplot
NanoPlot \
  --fastq hifi_reads.fastq.gz \
  -o nanoplot_hifi \
  --threads 24

####Check the quality and size of the reads; if necessary, apply a size and quality filter using filtlong.####
#I don't filter PacBio reads based on QV or size; HiFi reads are already CCS reads with >Q20
#https://github.com/rrwick/filtlong
filtlong \
    --min_mean_q 20 \
    $filt_hifireads > hifi.filt.q20.10kb.fastq
