#!/bin/bash
#SBATCH -J cd.uniprot-proteome6630192UP000006548.scan2b           # job name
#SBATCH -o cd.uniprot-proteome6630192UP000006548.scan2b.o%j       # output and error file name (%j expands to jobID)
#SBATCH -n 1              # total number of mpi tasks requested
#SBATCH -p normal     # queue (partition) -- normal, development, etc.
#SBATCH -c 16 		# number of CPUs/task
#SBATCH -t 48:00:00        # run time (hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=claire.mcwhite@utexas.edu
#SBATCH --mail-type=begin  # email me when the job starts
#SBATCH --mail-type=end    # email me when the job finishes
#SBATCH -A A-cm10          # Specify allocation to charge against

module load python/2.7.9

#ex human
SPEC="cd"

#ex eu
LVL="euNOG"

#ex scan1
SCAN="cd.uniprot-proteome6630192UP000006548.scan2b"

#ex uniprot-proteome%3AUP000006548
PROTEOME="uniprot-proteome6630192UP000006548"

NUMPROT="1"

echo $SPEC
echo $LVL
echo $SCAN
echo $PROTEOME

mkdir output_data/${SPEC}_${PROTEOME}_${LVL}

#One false positive per proteome
CUTOFF=0.01
echo $NUMPROT
echo $CUTOFF


echo "start hmm scan"
/home1/03491/cmcwhite/bin/hmmer/hmmscan -Z $NUMPROT --cpu 16 -o output_data/${SPEC}_${PROTEOME}_${LVL}/${SCAN}.txt input_data/${LVL}_pressed/${LVL}_hmms input_data/${SPEC}/${SCAN}.fasta 

echo "start processing"
bash scripts/run_all.sh $SPEC $LVL $PROTEOME $CUTOFF $SCAN

