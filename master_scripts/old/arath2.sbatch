#!/bin/bash
#SBATCH -J 0eu_ara2           # job name
#SBATCH -o 0eu_ara2.o%j       # output and error file name (%j expands to jobID)
#SBATCH -n 1              # total number of mpi tasks requested
#SBATCH -p normal     # queue (partition) -- normal, development, etc.
#SBATCH -c 16 		# number of CPUs/task
#SBATCH -t 48:00:00        # run time (hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=claire.mcwhite@utexas.edu
#SBATCH --mail-type=begin  # email me when the job starts
#SBATCH --mail-type=end    # email me when the job finishes
#SBATCH -A A-cm10          # Specify allocation to charge against

bash scripts/hmmer_scan.sh input_data/arath/uniprot-proteome%3AUP000006548.1.fasta output_data/euNOG_arath input_data/euNOG_pressed/euNOG_hmms scan1.txt



