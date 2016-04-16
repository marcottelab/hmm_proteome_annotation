#This script takes and speciescode.hmm.tar.gz from eggnog, unzips it, and presses the hmms into a format for hmmscan
#Ex. to press bactNOG.hmm.tar.gz
#bash masterscripts/startPress.sh bactNOG

#CDM 2/25/2015


#BASEDIR=/work/03491/cmcwhite/hmm_proteome_annotation.git
BASEDIR=$( pwd )
LVL=$1


outfile=${LVL}_press.sbatch


sed "s@level@$LVL@g" $BASEDIR/master_scripts/templatePress.sbatch > $BASEDIR/master_scripts/$outfile
sbatch $BASEDIR/master_scripts/$outfile

