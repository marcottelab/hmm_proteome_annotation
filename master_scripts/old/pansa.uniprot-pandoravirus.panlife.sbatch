#!/bin/bash
#SBATCH -J pansa.uniprot-pandoravirus.scan1.panlife           # job name
#SBATCH -o pansa.uniprot-pandoravirus.scan1.panlife.o%j       # output and error file name (%j expands to jobID)
#SBATCH -n 1              # total number of mpi tasks requested
#SBATCH -p development     # queue (partition) -- normal, development, etc.
#SBATCH -c 1 		# number of CPUs/task
#SBATCH -t 1:00:00        # run time (hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=claire.mcwhite@utexas.edu
#SBATCH --mail-type=begin  # email me when the job starts
#SBATCH --mail-type=end    # email me when the job finishes
#SBATCH -A A-cm10          # Specify allocation to charge against

module load python/2.7.9


#ex human
echo "start processing"

echo "GroupID	Rank	Level	ProteinID	evalue	QueryRange	ProteomeID	Hitlength	Annotation" > tmpheader
cat tmpheader output_data/pansa_panlife/panlife_pansa_tophits.txt > tmp

mv tmp output_data/pansa_panlife/panlife_pansa_tophits.txt
rm tmpheader

python scripts/get_panlife_tophit.py output_data/pansa_panlife/panlife_pansa_tophits.txt output_data/pansa_panlife/panlife_pansa_tophit_winner.txt

