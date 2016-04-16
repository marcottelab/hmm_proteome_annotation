#process_tot.py
# argv[1]: fasta file containing proteome
# argv[2]: name and path of hmmerscan results
# argv[3]: level of hmms scanned against (ie eukaryotes)
# argv[4]: name and path for output (can make new file or add to existing)
# Returns a space seperated text file with rank, level, proteinID, orthogroupID, evalue, QueryRange, and proteomeID (from proteome file name). Rank 0 orthogroup is proteinID when a protein has no significant hits (evalue>0.01). All hits with an e-value<=0.01 yield an entry, rank is based on order in hmmer results.

import os.path
import sys
from Bio import SearchIO
if os.path.isfile(sys.argv[4]): #if an existing file was provided append entries to that file
	output = open(sys.argv[4], "a")
else: #else make a new file and add a header
	output = open(sys.argv[4], "a")
	output.write("Rank Level ProteinID GroupID evalue QueryRange ProteomeID \n")

def process_tot():
        print "beginning process_tot"
	#level name
	level = sys.argv[3]+" "
	#get the name of the proteome from the file name
	omeid = sys.argv[1].replace(".fasta", "")
	omeid = omeid.split('/')
	omeid = omeid[len(omeid)-1] 
	#read in results
	results = SearchIO.parse(sys.argv[2], "hmmer3-text")
	
	#build up list of entries
	#processed = [] #intialize list to add entries to
        count = 0

        scans=len(results)
        cutoff=1.0/scans
        print scans
        print cutoff

	for protein in results: 
                processed = []
                if count % 100 ==0:
                     print count
                count = count + 1
		pid = protein.id+" "
		if len(protein) == 0: #if a protein has no hits groupid=proteinid and rank=0
			rank = "0 "
			OGid = protein.id+" "
			e = "n/a "
                        qr= "n/a "
			processed.append((rank, level, pid, OGid, e, qr, omeid))			
		elif protein[0].evalue > cutoff: #proteins with hits that do not meet the threshold are treated as those without any hits
			rank = "0 "
			OGid = protein.id+" "
			e = "n/a "
                        qr= "n/a "
			processed.append((rank, level, pid, OGid, e, qr, omeid))			
		else:
			i = 0
			while i<len(protein) and protein[i].evalue <= cutoff:
				rank = str(i+1)+" "
				OGid = protein[i].id.split('.')
				OGid = OGid[0]+"."+OGid[1]+" "
				e = str(protein[i].evalue)+" "
				qr = [] #empty list for domain ranges of this hit
				for d in protein[i]:
					qr.append(d.query_range)
				processed.append((rank, level, pid, OGid, e, str(qr).replace(" ", "")," ", omeid))
				i += 1
		#Write to file
	 	for i in processed:
			output.write("".join(str(s) for s in i) + "\n")

	output.close()	
print "checking entries"
#check for correct number of inputs
if len(sys.argv) !=5:
	print("Incorrect inputs, needs proteome.fasta, path/to/hmmer results, level, and output name.")
else:
	process_tot()


