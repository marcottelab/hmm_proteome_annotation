BASEDIR=/project/plant_orthologs
SPEC=$1
OUTLOC=$BASEDIR/statistics

cd $OUTLOC
awk '!/^ |  |  $/' groupalignment_${SPEC}.txt | awk '!a[$0]++' > groupalignment_${SPEC}_noblanks.txt

f=groupalignment_${SPEC}_noblanks.txt
g=prec_recall${f}

rm -rf $g

awk '{print $1, $7}' $f | sort -u | sed 1d > eggnog.tmp
head -1 $f >> $g
for num in {2..6}
do
    echo $num >> $g
    outfile=column_${num}.tmp
    awk -v var="$num" '{print $1, $var}' $f | sort -u | sed 1d > $outfile
    #diff -U 0 eggnog.tmp $outfile | grep ^@ | wc -l
    comm -1 -2 eggnog.tmp $outfile | wc -l >> $g
    wc -l $outfile >> $g
    wc -l eggnog.tmp >>$g

done






































