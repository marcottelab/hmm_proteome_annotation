#!/bin/bash
#SBATCH -J dsDNA           # job name
#SBATCH -o dsDNA.o%j       # output and error file name (%j expands to jobID)
#SBATCH -n 1              # total number of mpi tasks requested
#SBATCH -p normal     # queue (partition) -- normal, development, etc.
#SBATCH -c 16 		# number of CPUs/task
#SBATCH -t 48:00:00        # run time (hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=claire.mcwhite@utexas.edu
#SBATCH --mail-type=begin  # email me when the job starts
#SBATCH --mail-type=end    # email me when the job finishes
#SBATCH -A A-cm10          # Specify allocation to charge against

module load python/2.7.9

LVL=dsDNA

outfile=${LVL}_pressed

echo $LVL

cd /home1/03491/cmcwhite/plant_orthologs
mkdir input_data/${LVL}_pressed

cat input_data/${LVL}_hmm/*.hmm > input_data/${LVL}_pressed/${LVL}_hmms


echo "start hmm scan"
/home1/03491/cmcwhite/bin/hmmer/hmmpress input_data/${LVL}_pressed/${LVL}_hmms

