#!/bin/bash
#SBATCH -J corum.allComplexesCore_acc_ids_uniprot.scan1      # job name
#SBATCH -o corum.allComplexesCore_acc_ids_uniprot.scan1.o%j       # output and error file name (%j expands to jobID)
#SBATCH -n 1              # total number of mpi tasks requested
#SBATCH -p normal     # queue (partition) -- normal, development, etc.
#SBATCH -c 16 		# number of CPUs/task
#SBATCH -t 48:00:00        # run time (hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=claire.mcwhite@utexas.edu
#SBATCH --mail-type=begin  # email me when the job starts
#SBATCH --mail-type=end    # email me when the job finishes
#SBATCH -A A-cm10          # Specify allocation to charge against

module load python/2.7.9


#

#ex human
SPEC="corum"

#ex euNOG
LVL="euNOG"

#ex arath_uniprot-proteom%3AUP0000006548scan1.fasta
SCAN="corum.allComplexesCore_acc_ids_uniprot.scan1.fasta"

#ex uniprot-proteome%3AUP000006548.fasta
PROTEOME="allComplexesCore_acc_ids_uniprot.fasta"

NUMPROT="2285"

ANNOT=${LVL}.annotations.tsv


echo $SPEC
echo $LVL
echo $SCAN
echo $PROTEOME

BASEDIR=$( pwd )

OUTPUTLOC=$BASEDIR/output_data/${SPEC}_${PROTEOME%.*}_${LVL}

#mkdir output_data/${SPEC}_${PROTEOME}_${LVL}
mkdir $OUTPUTLOC

#One false positive per proteome
CUTOFF=0.01
echo $NUMPROT
echo $CUTOFF


echo "start hmm scan"
#/home1/03491/cmcwhite/bin/hmmer/hmmscan -Z $NUMPROT --cpu 16 -o output_data/${SPEC}_${PROTEOME}_${LVL}/${SCAN}.txt hmms/${LVL}_pressed/${LVL}_hmms proteomes/${SPEC}/${SCAN}.fasta 
/home1/03491/cmcwhite/bin/hmmer/hmmscan -Z $NUMPROT --cpu 16 -o $OUTPUTLOC/${SCAN%.*}.txt hmms/${LVL}_pressed/${LVL}_hmms proteomes/${SPEC}/${SCAN} 

echo "start processing"
#bash scripts/run_all.sh $SPEC $LVL $PROTEOME $CUTOFF $SCAN $ANNOT


SCRIPTLOC=$BASEDIR/scripts
ANNOTLOC=$BASEDIR/hmms


cd $OUTPUTLOC

BASE_OUTFILE=${SPEC}.${LVL}
ALL_OUTFILE=${BASE_OUTFILE}_all.txt

if [ ! -f $ALL_OUTFILE ]
    then
        echo "Rank      Level   ProteinID       GroupID evalue  QueryRange      ProteomeID      Hitlength" >> $ALL_OUTFILE
fi

echo "All hits"
echo $( pwd )


#Instead of all these, have an argparse main script with an option for analysis type
python $SCRIPTLOC/opt_process_all.py $SCAN $ALL_OUTFILE $LVL $PROTEOME $CUTOFF

#Get top evalue hit
#Will be rerun with every scan

python $SCRIPTLOC/get_annotation.py $ALL_OUTFILE $ANNOTLOC/$ANNOT


echo "GroupID   Rank    Level   ProteinID       evalue  QueryRange      ProteomeID      Hitlength       Sequence        Annotation" > ${BASE_OUTFILE}_nonhits.txt
grep -P "\tn/a\t" ${BASE_OUTFILE}_annotated.txt >> ${BASE_OUTFILE}_nonhits.txt


echo "GroupID   Rank    Level   ProteinID       evalue  QueryRange      ProteomeID      Hitlength       Sequence        Annotation" > ${BASE_OUTFILE}_tophit.txt
grep -P "\t1\t" ${BASE_OUTFILE}_annotated.txt >> ${BASE_OUTFILE}_tophit.txt


echo "GroupID   Rank    Level   ProteinID       evalue  QueryRange      ProteomeID      Hitlength       Sequence        Annotation" > ${BASE_OUTFILE}_toptwo.txt
grep -P "\t1\t" ${BASE_OUTFILE}_annotated.txt >> ${BASE_OUTFILE}_toptwo.txt
grep -P "\t2\t" ${BASE_OUTFILE}_annotated.txt >> ${BASE_OUTFILE}_toptwo.txt

python $SCRIPTLOC/annotate_fasta.py ${BASE_OUTFILE}_tophit.txt $BASEDIR/proteomes/$SPEC/${PROTEOME}.fasta
###############################
#Will be rerun with every scan
#Get fusions
#ANNOT_OUTFILE=${BASE_OUTFILE}_annotated.txt
#
#python $SCRIPTLOC/get_fusions.py $ANNOT_OUTFILE
#
#Proteome annotation not working?
################################























