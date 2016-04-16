#!/bin/bash
#SBATCH -J 0eu_traesproc           # job name
#SBATCH -o 0eu_traesproc.o%j       # output and error file name (%j expands to jobID)
#SBATCH -n 1              # total number of mpi tasks requested
#SBATCH -p normal     # queue (partition) -- normal, development, etc.
#SBATCH -c 1 		# number of CPUs/task
#SBATCH -t 48:00:00        # run time (hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=claire.mcwhite@utexas.edu
#SBATCH --mail-type=begin  # email me when the job starts
#SBATCH --mail-type=end    # email me when the job finishes
#SBATCH -A A-cm10          # Specify allocation to charge against

cd output_data/euNOG_traes/

rm -f traes_tot.txt

for f in scan*
do
python ../../scripts/process_tot.py ta_IWGSC_MIPSv2.2_HighConf_REPR_UNMAPPED_PROTEIN_2014Jul18.fasta $f eukaryotes traes_tot.txt   
done

python ../../scripts/get_subsets.py traes_tot.txt
python ../../scripts/get_fusions traes_closerange.txt

