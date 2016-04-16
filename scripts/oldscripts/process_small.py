#process_small.py 
#Takes in hmmscan output table from scan of proteome against orthogroup hmms from EggNOG, returns text file with rank, level, proteinID, ortho group, evalue, and proteome id. 
#Orthogroup rank 1 is top hit hmm. 
#Rank 0 orthogroup is protein id when a protein has no significant hits(evalue > 0.01). 
#Rank 2 orthogroup is the second hit, when the first and second evalues are within 10fold difference both orthogroup assignments are included in the table.
# argv[1]: fasta file containing proteome
# argv[2]: path and name of hmmer_scan.sh results
# argv[3]: level
# argv[4]: path and name for new text file or existing file to add to

import os.path
import sys
from Bio import SeqIO
from Bio import SearchIO
import math

def process_small():
	#get the name of the proteome from the file name
	pid = sys.argv[1].replace(".fasta", "")
	pid = pid.split('/')
	pid = pid[len(pid)-1] 
	#read in results
	results = SearchIO.parse(sys.argv[2], "hmmer3-text")

	#build up list of entries	
	processed = [] #initialize list to add entries to
	for protein in results:
		if len(protein) == 0 or protein[0].evalue > 0.01: #if a query has no significant hits groupid=proteinid and rank=0
			OGid = protein.id
			es = "n/a"
			rank = "0"
		elif len(protein) == 1: #if a query has 1 hit it is recorded with rank=1
			OG = protein[0]
			OGid = OG.id.replace(".meta_raw", "")
			es = str(OG.evalue)
			rank = "1"
		else:	#if a query has more hits the top hit is recorded with rank=1
			OG = protein[0]
			OGid = OG.id.replace(".meta_raw", "")
			e = OG.evalue
			es = str(e)
			OG2 = protein[1]
			e2 = OG2.evalue
			rank = "1"
			#if the difference between the evalues of the top 2 hits is within 10fold the 
			#second hit is also recorded with rank=2
			if e2==0:
				OG2id = OG2.id.replace(".meta_raw", "")
				processed.append(("2 ", sys.argv[3]+" ", protein.id+" ", OG2id+" ", str(e2)+" ", pid))
			elif e!=0 and math.log10(e/e2) >= -10: 
				OG2id = OG2.id.replace(".meta_raw", "")
				processed.append(("2 ", sys.argv[3]+" ", protein.id+" ", OG2id+" ", str(e2)+" ", pid))
		processed.append((rank+" ", sys.argv[3]+" ", protein.id+" ", OGid+" ", es+" ", pid))	

	#write entries to file
	if os.path.isfile(sys.argv[4]): #if an existing file was provided append entries to that file
		output = open(sys.argv[4], "a")
	else: #else make a new file and add a header
		output = open(sys.argv[4], "w")
		output.write("Rank Level ProteinID GroupID evalue ProteomeID \n")
	for i in processed:
		output.write("".join(str(s) for s in i) + "\n")
	output.close()	

#check for correct number of inputs
if len(sys.argv) !=5:
	print("Incorrect inputs, needs proteome.fasta, path/to/hmmer results, level, and output name.")
else:
	process_small()
