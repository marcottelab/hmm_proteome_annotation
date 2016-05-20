#!/bin/bash
#SBATCH -J scanID.phylolevel      # job name
#SBATCH -o scanID.phylolevel.o%j       # output and error file name (%j expands to jobID)
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
SPEC="braol"

#ex euNOG
LVL="euNOG"

#ex uniprot-proteome%3AUP000006548.fasta
PROTEOMENAME="uniprot-brassica+oleracea.fasta"

PROTEOMEPATH="proteomes/braol/uniprot-brassica+oleracea.fasta"






echo species $SPEC
echo level $LVL
echo scan identifier  $SCAN
echo proteome used $PROTEOMENAME
echo proteome location $PROTEOMEPATH



BASEDIR=$( pwd )

OUTPUTLOC=$BASEDIR/output_data/${SPEC}_${PROTEOMENAME%.*}_${LVL}

echo output location $OUTPUTLOC

cd $OUTPUTLOC

BASE_OUTFILE=${SPEC}.${LVL}
#ALL_OUTFILE=${BASE_OUTFILE}_all.txt

SCRIPTLOC=$BASEDIR/scripts

echo Annotating original FASTA

python $SCRIPTLOC/annotate_fasta.py ${BASE_OUTFILE}_tophit.txt $BASEDIR/$PROTEOMEPATH $LVL
