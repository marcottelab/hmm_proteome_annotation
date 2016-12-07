#!/bin/bash
#SBATCH -J orysj.uniprot-proteome%3AUP000000763.scan1      # job name
#SBATCH -o orysj.uniprot-proteome%3AUP000000763.scan1.o%j       # output and error file name (%j expands to jobID)
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
SPEC="orysj"

#ex euNOG
LVL="euNOG"

#ex arath_uniprot-proteom%3AUP0000006548scan1.fasta
SCAN="orysj.uniprot-proteome%3AUP000000763.scan1.fasta"

#ex uniprot-proteome%3AUP000006548.fasta
PROTEOME="uniprot-proteome%3AUP000000763.fasta"

NUMPROT="63029"

#ANNOT=${LVL}.all_annotations.csv.tsv
ANNOT="all_annotations.csv"

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
#/home1/03491/cmcwhite/bin/hmmer/hmmscan -Z $NUMPROT --cpu 16 -o $OUTPUTLOC/${SCAN%.*}.txt hmms/${LVL}_pressed/${LVL}_hmms proteomes/${SPEC}/${SCAN} 

echo "start processing"
#bash scripts/run_all.sh $SPEC $LVL $PROTEOME $CUTOFF $SCAN $ANNOT


SCRIPTLOC=$BASEDIR/scripts
ANNOTLOC=$BASEDIR/hmms

cd $OUTPUTLOC

BASE_OUTFILE=${SPEC}.${LVL}
ALL_OUTFILE=${BASE_OUTFILE}_all.txt
ANNOT_OUTFILE=${BASE_OUTFILE}_annotated.txt
NONHITS_OUTFILE=${BASE_OUTFILE}_nonhits.txt
TOPHIT_OUTFILE=${BASE_OUTFILE}_tophit.txt
TOPTWO_OUTFILE=${BASE_OUTFILE}_toptwo.txt
ORTHOLOGY_OUTFILE=${BASE_OUTFILE}_orthology.tab

if [ ! -f $ALL_OUTFILE ]
    then
        echo -e "Rank\tLevel\tSpecies\tProteinID\tGroupID\tevalue\tQueryRange\tProteomeID\tHitlength\tSequence" >> $ALL_OUTFILE

fi

echo "All hits"
echo $( pwd )


#Instead of all these, have an argparse main script with an option for analysis type
#python $SCRIPTLOC/opt_process_all.py ${SCAN%.*}.txt $ALL_OUTFILE $LVL $BASEDIR/proteomes/$SPEC/$PROTEOME $CUTOFF $SPEC




#Get top evalue hit
#Will be rerun with every scan

python $SCRIPTLOC/get_annotation.py $ALL_OUTFILE $ANNOT_OUTFILE $ANNOTLOC/$ANNOT


echo -e "GroupID\tRank\tLevel\tSpecies\tProteinID\tevalue\tQueryRange\tProteomeID\tHitlength\tSequence\tAnnotation" > $NONHITS_OUTFILE
grep -P "\tn/a\t" $ANNOT_OUTFILE >> $NONHITS_OUTFILE

echo -e "GroupID\tRank\tLevel\tSpecies\tProteinID\tevalue\tQueryRange\tProteomeID\tHitlength\tSequence\tAnnotation" > $TOPHIT_OUTFILE
grep -P "\t1\t" $ANNOT_OUTFILE >> $TOPHIT_OUTFILE

echo -e "GroupID\tRank\tLevel\tSpecies\tProteinID\tevalue\tQueryRange\tProteomeID\tHitlength\tSequence\tAnnotation" > $TOPTWO_OUTFILE
grep -P "\t1\t" $ANNOT_OUTFILE >> $TOPTWO_OUTFILE
grep -P "\t2\t" $ANNOT_OUTFILE >> $TOPTWO_OUTFILE

echo -e "GroupID\tRank\tLevel\tSpecies\tProteinID\tevalue\tQueryRange\tProteomeID\tHitlength\tSequence\tAnnotation" > $ORTHOLOGY_OUTFILE
grep -P "\t1\t" $ANNOT_OUTFILE >> $ORTHOLOGY_OUTFILE
grep -P "\tn/a\t" $ANNOT_OUTFILE >> $ORTHOLOGY_OUTFILE


PROTEOMELOC=$BASEDIR/proteomes/$SPEC


python $SCRIPTLOC/annotate_fasta.py $TOPHIT_OUTFILE $PROTEOMELOC/${PROTEOME} $PROTEOMELOC/${PROTEOME%.*}_${LVL}_annotated.fasta






