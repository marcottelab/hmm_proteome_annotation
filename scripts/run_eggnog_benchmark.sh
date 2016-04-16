BASEDIR=/project/plant_orthologs
SPEC=$1
OUTLOC=$BASEDIR/statistics
EGGNOG_LOC=/project/plant_orthologs/input_data/uniprot-15-May-2015.Eukaryota.tsv

cd $OUTLOC

python $BASEDIR/scripts/eggnog_benchmark.py $EGGNOG_LOC $SPEC
bash $BASEDIR/scripts/test_concordance.sh $SPEC


