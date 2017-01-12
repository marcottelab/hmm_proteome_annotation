#This script takes a species id (i.e. arath, human, drome), a proteome, and a level of HMMs to scan against.
#It breaks the proteome into 20000 sequences, the seeds one sbatch file
#per scan with values
#
#Put input files in the following locations:
#proteome location: hmms/[speciescode]/[proteome]
#pressed hmm location: hmms/[level]_pressed
#annotation location: hmms/[level].annotation.tsv
#Ex. to scan orysj again virNOG_pressed 
#bash masterscripts/startHmmscan.sh orysj uniprot-proteome%3AUP000000763.fasta virNOG

#CDM 2/25/2015




if [[ $# -eq 0 ]] ; then
    echo 'argument 1: species code ex. ARATH'
    echo 'argument 2: input FASTA ex. uniprot-proteome%3AUP000006548.fasta'
    echo 'argument 3: EggNOG HMM level code ex. euNOG'
    exit 1
fi

if [ "$#" -ne 4 ]; then
    echo "You must enter exactly 4 command line arguments"
    echo 'argument 1: species code ex. arath'
    echo 'argument 2: input FASTA ex. $BASEDIR/HMM_sorting/proteomes/arath/uniprot-proteome%3AUP000006548.fasta'
    echo 'argument 4: Name of annotation file stored in /hmms ex all_annotations.csv'


    exit 1
fi


#BASEDIR=/work/03491/cmcwhite/HMM_proteome_annotation
BASEDIR=$( pwd )
echo $BASEDIR
SPEC=$1
echo $SPEC
PROTEOMEPATH=$2
LVL=$3
ANNOT=$4

echo $PROTEOMEPATH

echo $LVL


dirname $PROTEOMEPATH
basename $PROTEOMEPATH
PROTEOMEDIR=`dirname $PROTEOMEPATH`
echo $PROTEOMEDIR
cd $PROTEOMEDIR

PROTEOMENAME=`basename $PROTEOMEPATH`
echo $PROTEOMENAME

OUTPUTLOC=$BASEDIR/output_data/${SPEC}_${PROTEOMENAME%.*}_${LVL}

echo output location $OUTPUTLOC




#cd $BASEDIR/proteomes/$SPEC


cd $OUTPUTLOC


outfile=formatting_${LVL}_${PROTEOMENAME}.sbatch 

echo $outfile

sed "s@speciescode@$SPEC@g" $BASEDIR/master_scripts/templateFormatting.sbatch > $BASEDIR/master_scripts/$outfile
sed -i "s@phylolevel@$LVL@g" $BASEDIR/master_scripts/$outfile
#sed -i "s@scanID@${i%.fasta}@g" $BASEDIR/master_scripts/$outfile
sed -i "s@proteomelength@$PROTEOMELENGTH@g" $BASEDIR/master_scripts/$outfile  
sed -i "s@proteomename@$PROTEOMENAME@g" $BASEDIR/master_scripts/$outfile
sed -i "s@proteomepath@$PROTEOMEPATH@g" $BASEDIR/master_scripts/$outfile
sed -i "s@proteomedir@$PROTEOMEDIR@g" $BASEDIR/master_scripts/$outfile
sed -i "s@outputloc@$OUTPUTLOC@g" $BASEDIR/master_scripts/$outfile
sed -i "s@annotations@$ANNOT@g" $BASEDIR/master_scripts/$outfile

  
cd $BASEDIR
sbatch $BASEDIR/master_scripts/$outfile
cd $BASEDIR/proteomes/$SPEC


