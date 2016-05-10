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


echo "change this to take full paths to the proteome"


if [[ $# -eq 0 ]] ; then
    echo 'argument 1: species code ex. ARATH'
    echo 'argument 2: input FASTA ex. uniprot-proteome%3AUP000006548.fasta'
    echo 'argument 3: EggNOG HMM level code ex. euNOG'
    exit 1
fi

if [ "$#" -ne 3 ]; then
    echo "You must enter exactly 2 command line arguments"
    echo 'argument 1: species code ex. arath'
    echo 'argument 2: input FASTA ex. $BASEDIR/HMM_sorting/proteomes/arath/uniprot-proteome%3AUP000006548.fasta'
    echo 'argument 3: EggNOG HMM level code ex. euNOG'
    exit 1
fi


#BASEDIR=/work/03491/cmcwhite/HMM_proteome_annotation
BASEDIR=$( pwd )
echo $BASEDIR
SPEC=$1
echo $SPEC
PROTEOMEPATH=$2
LVL=$3
echo $PROTEOMEPATH

echo $LVL


dirname $PROTEOMEPATH
basename $PROTEOMEPATH
PROTEOMEDIR=`dirname $PROTEOMEPATH`
echo $PROTEOMEDIR
cd $PROTEOMEDIR

PROTEOMENAME=`basename $PROTEOMEPATH`
echo $PROTEOMENAME




#cd $BASEDIR/proteomes/$SPEC



rm *scan*

python $BASEDIR/scripts/proteome_breaker.py $PROTEOMENAME 20000 $SPEC

proteomelength=`cat *scan* | grep -c ">"`

echo $proteomelength proteins in $SPEC proteome

for i in *scan*
do
   echo proteome segment $i
#   protname=`echo $i | awk -F'.' '{print $2}'`  #Splitting on a "." is a bad idea
#   scannum=`echo $i | awk -F'.' '{print $3}'`  #Likewise

   echo $protname proteome
#   echo $scannum scan

   outfile=${i%.*}.sbatch 

#   outfile=$SPEC.$protname.$scannum.sbatch
   echo $outfile

   sed "s@speciescode@$SPEC@g" $BASEDIR/master_scripts/templateHmmscan.sbatch > $BASEDIR/master_scripts/$outfile
   sed -i "s@phylolevel@$LVL@g" $BASEDIR/master_scripts/$outfile
#  sed -i "s@scanID@$SPEC.$protname.$scannum@g" $BASEDIR/master_scripts/$outfile
   sed -i "s@scanID@${i%.*}@g" $BASEDIR/master_scripts/$outfile
#   sed -i "s@proteomename@$protname@g" $BASEDIR/master_scripts/$outfile
   sed -i "s@protlength@$proteomelength@g" $BASEDIR/master_scripts/$outfile  
   sed -i "s@proteomename@$PROTEOMENAME@g" $BASEDIR/master_scripts/$outfile


  
   cd $BASEDIR
   sbatch $BASEDIR/master_scripts/$outfile
   cd $BASEDIR/proteomes/$SPEC
done


