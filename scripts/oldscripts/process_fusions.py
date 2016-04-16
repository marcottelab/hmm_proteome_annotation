# process_fusions.py
# Takes in hmmscan output table and returns potential novel fusion proteins.
# Returns a text file with level, proteinID, orthogroupIDs, and proteome.
# argv[1]: fasta file containing proteome
# argv[2]: path and name of hmmer_scan.sh results
# argv[3]: level
# argv[4]: path and name for new text or existing file to add to

import os.path
import sys
from Bio import SearchIO

def getOverlap(a, b):
	overlap = 0
	for i in a:
		for j in b:
			overlap += max(0, min(i[1], j[1]) - max(i[0], j[0]))
	return overlap

def process_fusions():
	#level name
	level = sys.argv[3]+" "

	#get the name of the proteome from the file name
	omeid = sys.argv[1].replace(".fasta", "")
	omeid = omeid.split("/")
	omeid = omeid[len(omeid)-1]
	
	#read in scan results
	results = SearchIO.parse(sys.argv[2], "hmmer3-text")
	
	#build up list of potential fusion proteins
	fusion = [] 
	for protein in results:
		if len(protein) > 1: #only look at proteins with more than one hit
			pid = protein.id+" "
			ids = () #empty set for groupids of non overlapping hits
			qrs = [] #empty list for domain alignments ranges
			i = 0
			#look at all hits with an evalue under 0.01
			while i < len(protein) and protein[i].evalue <= 0.01:
				pid = protein.id+" "
				qri = [] #empty list for domain ranges of this hit
				for d in protein[i]: 
					qri.append(d.query_range)
				if getOverlap(qrs, qri) == 0: #if hit is non overlapping at to list
					qrs = qrs + qri
					OGid = protein[i].id.split(".")
					OGid = OGid[0]+"."+OGid[1]+" "
					ids += (OGid,)
				i += 1
			if len(ids) > 1: #once all non overlapping hits collected at line to fusion
				line = (pid,) + ids + (level, omeid)
				fusion.append(line)	
			 	
	#if no entries, output statement letting the user know
	if fusion == []:
		fusion.append("No fusion proteins found.")	
	
	#write entries to file
	if os.path.isfile(sys.argv[4]): #if an existing file was provided append entries to that file
		output = open(sys.argv[4], "a")
	else: #else make a new file and add a header
		output = open(sys.argv[4], "w")
		output.write("ProteinID GroupID Level ProteomeID \n")
	for i in fusion:
		output.write("".join(str(s) for s in i) + "\n")
	output.close()				

#check for correct number of inputs
if len(sys.argv) !=5:
	print("Incorrect inputs, needs proteome.fasta, path/to/hmmer results, level, and output name.")
else:
	process_fusions()
