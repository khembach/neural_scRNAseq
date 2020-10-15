#/bin/bash

## This script quantifies the expression of the TDP-43-HA plasmid in all samples of the TDP-43 experiment. 
## We use alevin for plasmid quantification. To compare the expression of the endogenous TDP-43 with the TDP-43-HA, we quantify both transcripts together: all endogenous TDP-43 transcripts and the transcript sequence of the plasmid.

## Download latest version of salmon
wget https://github.com/COMBINE-lab/salmon/releases/download/v1.3.0/salmon-1.3.0_linux_x86_64.tar.gz -P ~/software
tar -xvzf ~/software/salmon-1.3.0_linux_x86_64.tar.gz
# add ~/software/salmon-latest_linux_x86_64/bin to the PATH variable

## prepare transcript sequences and transcript to gene mapping
## filter all TDP-43 transcripts from the cDNA fasta file
## /home/Shared_taupo/data/annotation/Human/Ensembl_GRCh38.98/cdna/Homo_sapiens.GRCh38.cdna.all.fa.gz


## https://stackoverflow.com/questions/38972736/how-to-print-lines-between-two-patterns-inclusive-or-exclusive-in-sed-awk-or
zcat /home/Shared_taupo/data/annotation/Human/Ensembl_GRCh38.98/cdna/Homo_sapiens.GRCh38.cdna.all.fa.gz | sed -n '/gene:ENSG00000120948.17/,/^>ENST/p' > ../data/reference/TDP43_transcripts1.fa

## The transcript fasta file was processed with /scripts/prepare_salmon_transcript.R and includes the transcript encoded by the plasmid which contains the TDP-43-HA

##---------------
## Indexing
## -------------
salmon index -i ../data/reference/index -k 31 --gencode -p 4 -t ../data/reference/TDP43_transcripts_all.fa


##----------------
## quantification 
##----------------
## we quantify the TDP-43 transcripts using the raw 10X reads and the identified barcodes as whitelist
## we remove the "-1" suffix from the barcodes because they are added by CellRanger to indicate the library

for f in no1_Neural_cuture_d_96_TDP-43-HA_4w_DOXoff no2_Neural_cuture_d_96_TDP-43-HA_2w_DOXON no3_Neural_cuture_d_96_TDP-43-HA_4w_DOXONa no4_Neural_cuture_d_96_TDP-43-HA_4w_DOXONb
  do
    ## input fastq files
    f1a=$(ls ../data/Sep2020/NovaSeq_20200918_NOV469_o7451_DataDelivery/${f}/${f}_S*_L001_R1_001.fastq.gz)
    f1b=$(ls ../data/Sep2020/NovaSeq_20200918_NOV469_o7451_DataDelivery/${f}/${f}_S*_L001_R1_001.fastq.gz)
    f2a=$(ls ../data/Sep2020/NovaSeq_20200918_NOV469_o7451_DataDelivery/${f}/${f}_S*_L001_R2_001.fastq.gz)
    f2b=$(ls ../data/Sep2020/NovaSeq_20200918_NOV469_o7451_DataDelivery/${f}/${f}_S*_L002_R2_001.fastq.gz)
    ## remove -1 suffix from barcodes
    zcat ../data/Sep2020/CellRangerCount_50076_2020-09-22--15-40-54/${f}/filtered_feature_bc_matrix/barcodes.tsv.gz | sed 's/..$//' > ../data/Sep2020/CellRangerCount_50076_2020-09-22--15-40-54/${f}/filtered_feature_bc_matrix/barcodes_noSuffix.txt
    nice -n 10 salmon alevin -lISR -1 ${f1a} ${f1b} -2 ${f2a} ${f2b} --chromiumV3 -i ../data/reference/index -p 10 -o ../data/Sep2020/alevin_TDP43/${f} --tgMap ../data/reference/t2g.txt --whitelist ../data/Sep2020/CellRangerCount_50076_2020-09-22--15-40-54/${f}/filtered_feature_bc_matrix/barcodes_noSuffix.txt
  done


