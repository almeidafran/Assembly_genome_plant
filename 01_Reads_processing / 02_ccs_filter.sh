# !/bin/bash
hifireads=/file_path/ccs.fastq.gz

##### activate conda environment #####
#conda activate yahs

#Get script https://github.com/sheinasim-USDA/HiFiAdapterFilt/blob/master/hifiadapterfilt.sh
##### adapter filter #####
hifiadapterfilt.sh -p $hifireads -t 16 -o filter_adapter/
