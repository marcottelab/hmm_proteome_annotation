#!/bin/bash
# hmmer_scan.sh
# $1: fasta file containing proteome
# $2: path and name of directory to store results
# $3: name for hmm database, if already created include path
# $4: name for scan results file
# optional $5: directory where hmms are stored if haven't made hmm database yet
# $6: the length of the proteome
# Returns compressed hmm database if one was not provided and hmmscan text output.
# Searchs each protein sequence against an hmm database.

if [[ $# -eq 6 ]]; then
	echo $5*.hmm | xargs cat > $2$3
	hmmpress $2$3
	hmmscan -o $2$4 $2$3 $1 $6
else
	hmmscan -o $2$4 $3 $1 $6
fi
