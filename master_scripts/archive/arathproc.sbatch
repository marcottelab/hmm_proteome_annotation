#!/bin/bash
#SBATCH -J 0eu_arathproc           # job name
#SBATCH -o 0eu_arathproc.o%j       # output and error file name (%j expands to jobID)
#SBATCH -n 1              # total number of mpi tasks requested
#SBATCH -p normal     # queue (partition) -- normal, development, etc.
#SBATCH -c 1 		# number of CPUs/task
#SBATCH -t 48:00:00        # run time (hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=claire.mcwhite@utexas.edu
#SBATCH --mail-type=begin  # email me when the job starts
#SBATCH --mail-type=end    # email me when the job finishes
#SBATCH -A A-cm10          # Specify allocation to charge against

cd output_data/euNOG_arath/

rm -f arath_tot.txt

for f in scan*
do
python ../../scripts/process_tot.py allComplexesCore_acc.ids.uniprot.fasta $f eukaryotes arath_tot.txt   
done

python ../../scripts/get_subsets.py arath_tot.txt
python ../../scripts/get_fusions arath_closerange.txt

