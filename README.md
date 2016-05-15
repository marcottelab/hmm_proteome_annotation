This is a process for sorting a whole proteome into Hmm profiles using hmmscan. 
outputs:
1. A flat file of the best hit protein - HMM profile matches with annotations (tophit)
2. A flat file of all protein - HMM profile matches with annotations (annotated)
3. A flat file of all protein - HMM matches (all)
4. A flat file of proteins with no HMM hit (nohit)
4. The input fasta annotated with the EggNOG hmm group annotations. This is output to the proteomes/[species] folder


Instructions
1.Place the annotation and hmm files for a phylogenetic level in hmms/

ex. 
euNOG_hmm.tar.gz 
euNOG.annotations.tsv.gz

HMM profiles come from http://eggnogdb.embl.de/#/app/downloads

2.From the main directory run:
bash masterscripts/startPress.sh [level]

ex. bash masterscripts/startPress.sh euNOG

This step takes about 10 TACC minutes

3. Make a directory for the species that you want to run in proteomes/
ex.
mkdir proteomes/arath

4. Place the species' fasta in its folder in proteomes/
ex.
proteomes/arath/uniprot-proteome%3AUP000006548.fasta

5. After the hmms are pressed, from the main directory run:
bash masterscripts/startHmmscan.sh [species] [proteome] [level]

ex.
bash master_scripts/startHmmscan.sh arath proteomes/arath/uniprot-proteome%3AUP000006548.fasta euNOG

This step takes up to 20 TACC hours depending on proteome/hmm profile count


tophit + nonhits are combined to create look ups for the othology mass spec analysis


