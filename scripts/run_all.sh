#BASEDIR=/work/03491/cmcwhite/plant_orthologs
BASEDIR=$( pwd )
SPEC=$1
LVL=$2
PROTEOME=$3
CUTOFF=$4
SCAN=$5
ANNOT=$6

SCRIPTLOC=$BASEDIR/scripts
ANNOTLOC=$BASEDIR/hmms

echo "Starting post hmmscan processing"


OUTPUTLOC=$BASEDIR/output_data/${SPEC}_${PROTEOME}_${LVL}
echo $OUTPUTLOC
cd $OUTPUTLOC

BASE_OUTFILE=${SPEC}.${PROTEOME}.${LVL}
ALL_OUTFILE=${BASE_OUTFILE}_all.txt


if [ ! -f $ALL_OUTFILE ]
    then
        echo "Rank	Level	ProteinID	GroupID	evalue	QueryRange	ProteomeID	Hitlength" >> $ALL_OUTFILE
fi

echo "All hits"
echo $( pwd )

python $SCRIPTLOC/opt_process_all.py $SCAN.txt $ALL_OUTFILE $LVL $PROTEOME $CUTOFF

#Get top evalue hit
#Will be rerun with every scan

python $SCRIPTLOC/get_annotation.py $ALL_OUTFILE $ANNOTLOC/$ANNOT

grep -P "\tn/a\t" ${BASE_OUTFILE}_annotated.txt > ${BASE_OUTFILE}_nonhits.txt

grep -P "\t1\t" ${BASE_OUTFILE}_annotated.txt > ${BASE_OUTFILE}_tophit.txt


#Will be rerun with every scan
#Get fusions
#ANNOT_OUTFILE=${BASE_OUTFILE}_annotated.txt

#python $SCRIPTLOC/get_fusions.py $ANNOT_OUTFILE

#Proteome annotation not running?
python $SCRIPTLOC/annotate_fasta.py $ANNOT $BASEDIR/proteomes/$SPEC/$PROTEOME










