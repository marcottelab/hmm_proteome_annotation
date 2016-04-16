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

#BASEDIR=/work/03491/cmcwhite/plant_orthologs
BASEDIR=$( pwd )
echo $BASEDIR
SPEC=$1
echo $SPEC
PROTEOME=$2
LVL=$3
echo $PROTEOME
echo $LVL
cd $BASEDIR/proteomes/$SPEC

rm *scan*

python $BASEDIR/scripts/proteome_breaker.py $PROTEOME 20000 $SPEC

protlength=`cat *scan* | grep -c ">"`

echo $protlength proteins in $SPEC proteome

for i in *scan*
do
   echo proteome segment $i
   protname=`echo $i | awk -F'.' '{print $2}'`
   scannum=`echo $i | awk -F'.' '{print $3}'`

   echo $protname proteome
   echo $scannum scan

   outfile=$SPEC.$protname.$scannum.sbatch
   echo $outfile
   sed "s@speciescode@$SPEC@g" $BASEDIR/master_scripts/templateHmmscan.sbatch > $BASEDIR/master_scripts/$outfile
   sed -i "s@phylolevel@$LVL@g" $BASEDIR/master_scripts/$outfile
   sed -i "s@scanID@$SPEC.$protname.$scannum@g" $BASEDIR/master_scripts/$outfile
   sed -i "s@proteomename@$protname@g" $BASEDIR/master_scripts/$outfile
   sed -i "s@proteomelength@$protlength@g" $BASEDIR/master_scripts/$outfile  
  
   cd $BASEDIR
   sbatch $BASEDIR/master_scripts/$outfile
   cd $BASEDIR/proteomes/$SPEC
done


