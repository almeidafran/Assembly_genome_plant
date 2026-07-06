# !/bin/bash
hic=/files_path/hic/

##### activate conda environment #####
conda activate yahs

##### simple statistics of FASTA/Q files #####
seqkit stats -a -j 2 $hic/hic.R1.fq.gz $hic/hic.R2.fq.gz > hic_stats.txt

####### Hi-C or Omni-C read QC #####
fastqc \
  -t 16 \
  -o 00_raw_qc \
  $hic/HiC_R1.fastq.gz $hic/HiC_R2.fastq.gz

multiqc 00_raw_qc -o 00_raw_qc/multiqc_hic

###### Trimming of Hi-C or Omni-C reads (if necessary) #####
fastp \
  -i $hic/HiC_R1.fastq.gz \
  -I $hic/HiC_R2.fastq.gz \
  -o HiC_R1.trim.fastq.gz \
  -O HiC_R2.trim.fastq.gz \
  --detect_adapter_for_pe \
  --thread 16 \
  --html 00_raw_qc/fastp_hic.html \
  --json 00_raw_qc/fastp_hic.json

  #HiC-Pro can also be used for QC.

