awk -F'\t' -v OFS='\t' '{print $1, $2, $2, $2, $2, $3}' Viruses.tmp.annotations.tsv |awk '{if(NR>1)print}'  > Viruses.annotations.tsv
awk -F'\t' -v OFS='\t' '{print $1, $2, $2, $2, $2, $3}' dsDNA.tmp.annotations.tsv |awk '{if(NR>1)print}'  > dsDNA.annotations.tsv

