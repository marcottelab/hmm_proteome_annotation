#!/bin/bash
#SBATCH -J 0eu_arath1           # job name
#SBATCH -o 0eu_arath.o%j       # output and error file name (%j expands to jobID)
#SBATCH -n 1              # total number of mpi tasks requested
#SBATCH -p normal     # queue (partition) -- normal, development, etc.
#SBATCH -c 16 		# number of CPUs/task
#SBATCH -t 48:00:00        # run time (hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=claire.mcwhite@utexas.edu
#SBATCH --mail-type=begin  # email me when the job starts
#SBATCH --mail-type=end    # email me when the job finishes
#SBATCH -A A-cm10          # Specify allocation to charge against

module load intel/13.0.2.146
module load mvapich2/1.9a2
module load hmmer/3.0
module load python/2.7.9

#ex human
SPEC="speciescode"

#ex eu
LVL="phylolevel"

#ex scan1
SCAN="scannumber"

#ex uniprot-proteome%3AUP000006548
PROTEOME="proteomename"


echo $SPEC
echo $LVL
echo $SCAN
echo $PROTEOME

rm -rf output_data/${LVL}NOG_${SPEC}
mkdir output_data/${LVL}NOG_${SPEC}

#Total number of proteins in proteome
NUMPROT=`grep -c ">" input_data/${SPEC}/${PROTEOME}.fasta`

#One false positive per proteome
CUTOFF=`echo "1/$NUMPROT | bc -l`
echo $NUMPROT
echo $CUTOFF


echo "start hmm scan"
hmmscan -E $CUTOFF -Z $NUMPROT -o --cpu 16 output_data/${LVL}NOG_${SPEC}/${SCAN}.txt input_data/${LVL}NOG_pressed/${LVL}NOG_hmms input_data/${SPEC}/${PROTEOME}.${SCAN}.fasta 

echo "start processing"
bash scripts/run_all.sh $SPEC

