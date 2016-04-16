#!/bin/bash
#SBATCH -J level           # job name
#SBATCH -o level.o%j       # output and error file name (%j expands to jobID)
#SBATCH -n 1              # total number of mpi tasks requested
#SBATCH -p normal     # queue (partition) -- normal, development, etc.
#SBATCH -c 16 		# number of CPUs/task
#SBATCH -t 48:00:00        # run time (hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=claire.mcwhite@utexas.edu
#SBATCH --mail-type=begin  # email me when the job starts
#SBATCH --mail-type=end    # email me when the job finishes
#SBATCH -A A-cm10          # Specify allocation to charge against

module load python/2.7.9

LVL=level

outfile=${LVL}_pressed

echo $LVL

BASEDIR=$( pwd )
cd $BASEDIR/hmms
echo $BASEDIR
#cd /home1/03491/cmcwhite/hmm_proteome_annotation

tar -xvf ${LVL}_hmm.tar.gz
gunzip ${LVL}.annotations.tsv.gz

mkdir ${LVL}_pressed

cat ${LVL}_hmm/*.hmm > ${LVL}_pressed/${LVL}_hmms

echo "start hmm scan"
/home1/03491/cmcwhite/bin/hmmer/hmmpress ${LVL}_pressed/${LVL}_hmms


