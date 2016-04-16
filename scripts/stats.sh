BASEDIR=/project/plant_orthologs

LEVEL=euNOG

rm -rf $BASEDIR/group_counts.*
rm -rf $BASEDIR/hit_counts.*
rm -rf $BASEDIR/prot_counts.*
while read SPEC
do

    cd $BASEDIR/output_data/${LEVEL}_${SPEC}

    echo $SPEC
    for f in ${SPEC}_*
    do
        cou=`(awk '{print $4}' $f | sort -u | wc -l)`
        hits=`(wc -l $f)`

       
        echo $LEVEL $f $cou >> $BASEDIR/group_counts.tmp
        echo $LEVEL $f $hits >> $BASEDIR/hit_counts.tmp
        
    done
    numProt=`(awk '{print $3}' ${SPEC}_tot.txt | sort -u | wc -l)`
    echo $LEVEL $SPEC $numProt >> $BASEDIR/prot_counts.tmp
    cd ../




done < $BASEDIR/species_list.txt

sed -i 's/_/ /' group_counts.tmp
sed -i 's/.txt//' group_counts.tmp
sort -k2 $BASEDIR/group_counts.tmp > $BASEDIR/group_counts.txt
rm $BASEDIR/group_counts.tmp

sed -i 's/.txt//' hit_counts.tmp
sed -i 's/_/ /' hit_counts.tmp
sort -k2 $BASEDIR/hit_counts.tmp > $BASEDIR/hit_counts.txt
rm $BASEDIR/hit_counts.tmp

sed -i 's/.txt//' prot_counts.tmp
sed -i 's/_/ /' group_counts.tmp
sort -k2 $BASEDIR/prot_counts.tmp > $BASEDIR/prot_counts.txt
rm $BASEDIR/prot_counts.tmp








