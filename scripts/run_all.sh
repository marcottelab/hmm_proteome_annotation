#BASEDIR=/work/03491/cmcwhite/plant_orthologs
BASEDIR=$( pwd )

#species codehttps://github.com/marcottelab/hmm_proteome_annotation
SPEC=$1

#euNOG, bactNOG
LVL=$2

#proteome name
PROTEOME=$3

#significant hit cutoff
CUTOFF=$4

#name of hmm output file
SCAN=${5%*.fasta}.txt

#name of eggnog annotation file
ANNOT=$6

SCRIPTLOC=$BASEDIR/scripts
ANNOTLOC=$BASEDIR/hmms


echo "Starting post hmmscan processing"
 /work/03491/cmcwhite/HMM_proteome_annotation/output_data/xentr_tk_XENTR_JGIv90pV2_prot_final.fasta_euNOG:


OUTPUTLOC=$BASEDIR/output_data/${SPEC}_${PROTEOME%.*}_${LVL}
echo $OUTPUTLOC
cd $OUTPUTLOC

BASE_OUTFILE=${SPEC}.${PROTEOME}.${LVL}
ALL_OUTFILE=${BASE_OUTFILE}_all


if [ ! -f $ALL_OUTFILE ]
    then
        echo "Rank	Level	ProteinID	GroupID	evalue	QueryRange	ProteomeID	Hitlength" >> $ALL_OUTFILE
fi

echo "All hits"
echo $( pwd )


#Instead of all these, have an argparse main script with an option for analysis type
python $SCRIPTLOC/opt_process_all.py $SCAN $ALL_OUTFILE $LVL $BASEDIR/proteomes/$SPEC/$PROTEOME $CUTOFF $SPEC

#Get top evalue hit
#Will be rerun with every scan

python $SCRIPTLOC/get_annotation.py $ALL_OUTFILE $ANNOTLOC/$ANNOT


echo "GroupID	Rank	Level	ProteinID	evalue	QueryRange	ProteomeID	Hitlength	Sequence	Annotation" > ${BASE_OUTFILE}_nonhits.txt
grep -P "\tn/a\t" ${BASE_OUTFILE}_annotated.txt >> ${BASE_OUTFILE}_nonhits.txt


echo "GroupID	Rank	Level	ProteinID	evalue	QueryRange	ProteomeID	Hitlength	Sequence	Annotation" > ${BASE_OUTFILE}_tophit.txt
grep -P "\t1\t" ${BASE_OUTFILE}_annotated.txt >> ${BASE_OUTFILE}_tophit.txt


echo "GroupID	Rank	Level	ProteinID	evalue	QueryRange	ProteomeID	Hitlength	Sequence	Annotation" > ${BASE_OUTFILE}_toptwo.txt
grep -P "\t1\t" ${BASE_OUTFILE}_annotated.txt >> ${BASE_OUTFILE}_toptwo.txt
grep -P "\t2\t" ${BASE_OUTFILE}_annotated.txt >> ${BASE_OUTFILE}_toptwo.txt

#Will be rerun with every scan
#Get fusions
#ANNOT_OUTFILE=${BASE_OUTFILE}_annotated.txt

#python $SCRIPTLOC/get_fusions.py $ANNOT_OUTFILE

#Proteome annotation not working?
python $SCRIPTLOC/annotate_fasta.py ${BASE_OUTFILE}_tophit.txt $BASEDIR/proteomes/$SPEC/${PROTEOME}.fasta










