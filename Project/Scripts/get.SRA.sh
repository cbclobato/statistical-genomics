#!/bin/bash

DATA_PATH=$1

export PATH=$PATH:$HOME/BioInfoTools/sratoolkit.2.10.8/bin

while read line; do
	OUTPUT=$(echo "$line" | sed "s/$/_1\.fastq\.gz/" | sed "s|^|$DATA_PATH\/|") 
        if  [[ ! -f $OUTPUT ]]; then
		touch $OUTPUT
		echo $OUTPUT
                #prefetch $line
                fastq-dump --outdir $DATA_PATH --gzip --split-files $line 
        fi
done < $DATA_PATH/SRR_Acc_List.txt

