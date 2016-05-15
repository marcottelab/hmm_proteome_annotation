#!/bin/bash
#SBATCH -J orysj.uniprot-proteome%3AUP000000763.scan1.euNOG      # job name
#SBATCH -o orysj.uniprot-proteome%3AUP000000763.scan1.euNOG.o%j       # output and error file name (%j expands to jobID)
#SBATCH -n 1              # total number of mpi tasks requested
#SBATCH -p normal     # queue (partition) -- normal, development, etc.
#SBATCH -c 16 		# number of CPUs/task
#SBATCH -t 48:00:00        # run time (hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=claire.mcwhite@utexas.edu
#SBATCH --mail-type=begin  # email me when the job starts
#SBATCH --mail-type=end    # email me when the job finishes
#SBATCH -A A-cm10          # Specify allocation to charge against

module load python/2.7.9



#ex human
SPEC="orysj"

#ex euNOG
LVL="euNOG"

#ex arath_uniprot-proteom%3AUP0000006548scan1.txt
SCAN="orysj.uniprot-proteome%3AUP000000763.scan1"

#ex uniprot-proteome%3AUP000006548.fasta
PROTEOMENAME="uniprot-proteome%3AUP000000763.fasta"

PROTEOMEPATH="proteomes/orysj/uniprot-proteome%3AUP000000763.fasta"

PROTEOMEDIR="proteomes/orysj"


NUMPROT="63029"

ANNOT=${LVL}.annotations.tsv





echo species $SPEC
echo level $LVL
echo scan identifier  $SCAN
echo proteome used $PROTEOMENAME
echo proteome location $PROTEOMEPATH



BASEDIR=$( pwd )

OUTPUTLOC=$BASEDIR/output_data/${SPEC}_${PROTEOMENAME%.*}_${LVL}

echo output location $OUTPUTLOC

mkdir $OUTPUTLOC

#One false positive per proteome
CUTOFF=0.01
echo number of proteins $NUMPROT
echo false positive cutoff $CUTOFF


echo "start hmm scan"
#/home1/03491/cmcwhite/bin/hmmer/hmmscan -Z $NUMPROT --cpu 16 -o output_data/${SPEC}_${PROTEOME}_${LVL}/${SCAN}.txt hmms/${LVL}_pressed/${LVL}_hmms proteomes/${SPEC}/${SCAN}.fasta
#/home1/03491/cmcwhite/bin/hmmer/hmmscan -Z $NUMPROT --cpu 16 -o $OUTPUTLOC/${SCAN%.*}.txt hmms/${LVL}_pressed/${LVL}_hmms proteomes/${SPEC}/${SCAN}
#/home1/03491/cmcwhite/bin/hmmer/hmmscan -Z $NUMPROT --cpu 16 -o $OUTPUTLOC/${SCAN%.*}.txt hmms/${LVL}_pressed/${LVL}_hmms $PROTEOMEDIR/${SCAN}

echo "start processing"


SCRIPTLOC=$BASEDIR/scripts
ANNOTLOC=$BASEDIR/hmms


cd $OUTPUTLOC

BASE_OUTFILE=${SPEC}.${LVL}
ALL_OUTFILE=${BASE_OUTFILE}_all.txt
TMP_OUTFILE=${BASE_OUTFILE}_temporary_orysj.uniprot-proteome%3AUP000000763.scan1.txt


echo "All hits"
echo $( pwd )


#Instead of all these, have an argparse main script with an option for analysis type
python $SCRIPTLOC/opt_process_all.py $OUTPUTLOC/${SCAN}.txt $TMP_OUTFILE $LVL $BASEDIR/$PROTEOMEPATH $CUTOFF $SPEC

if [ ! -f $ALL_OUTFILE ]
    then
        echo "Rank	Level	Species	ProteinID	GroupID	evalue	QueryRange	ProteomeID	Hitlength	Sequence" >> $ALL_OUTFILE
fi


cat $ALL_OUTFILE $TMP_OUTFILE > temporary_outfile.txt
mv temporary_outfile.txt $ALL_OUTFILE
rm temporary_outfile.txt 
rm $TMP_OUTFILE 

echo Parsing scan files finished


#Get top evalue hit



echo Starting getting annotations
python $SCRIPTLOC/get_annotation.py $ALL_OUTFILE $ANNOTLOC/$ANNOT 



echo Getting top hits etc. 

echo "GroupID	Rank	Level	Species	ProteinID	evalue	QueryRange	ProteomeID	Hitlength	Sequence	Annotation" > ${BASE_OUTFILE}_nonhits.txt
grep -P "\tn/a\t" ${BASE_OUTFILE}_annotated.txt >> ${BASE_OUTFILE}_nonhits.txt


echo "GroupID	Rank	Level	Species	ProteinID	evalue	QueryRange	ProteomeID	Hitlength	Sequence	Annotation" > ${BASE_OUTFILE}_tophit.txt
grep -P "\t1\t" ${BASE_OUTFILE}_annotated.txt >> ${BASE_OUTFILE}_tophit.txt


#echo "GroupID	Rank	Level	Species	ProteinID	evalue	QueryRange	ProteomeID	Hitlength	Sequence	Annotation" > ${BASE_OUTFILE}_toptwo.txt
#grep -P "\t1\t" ${BASE_OUTFILE}_annotated.txt >> ${BASE_OUTFILE}_toptwo.txt
#grep -P "\t2\t" ${BASE_OUTFILE}_annotated.txt >> ${BASE_OUTFILE}_toptwo.txt

echo Annotating original FASTA

python $SCRIPTLOC/annotate_fasta.py ${BASE_OUTFILE}_tophit.txt $BASEDIR/$PROTEOMEPATH $LVL
###############################
#Will be rerun with every scan
#Get fusions
#ANNOT_OUTFILE=${BASE_OUTFILE}_annotated.txt
#
#python $SCRIPTLOC/get_fusions.py $ANNOT_OUTFILE
#
#Proteome annotation not working?
################################
