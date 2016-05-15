#process_all.py
# argv[1]: name and path of hmmerscan results
# argv[2] : output file
# argv[3] : level, ie bactNOG, euNOG
# argv[4] : proteome filename
# argv[5] : e value cutoff
# argv[6] : species


# Returns a space seperated text file with rank, level, proteinID, GroupID, evalue, QueryRange, and proteomeID (from proteome file name). Rank 0 orthogroup is proteinID when a protein has no significant hits (evalue>0.01). All hits with an e-value<=0.01 yield an entry, rank is based on order in hmmer results.



import os.path
import sys
import ast
import numpy as np

import sys
sys.path.append('/home1/03491/cmcwhite/bin')
sys.path[0:0] = ['/home1/03491/cmcwhite/bin']

from Bio import SeqIO


sys.path[0:0] = ['/home1/03491/cmcwhite/bin']
from Bio import SearchIO
def process_all():
        print sys.argv
        print "beginning process_all"
        outfile = open(sys.argv[2], "a")
	#read in results
	results = SearchIO.parse(sys.argv[1], "hmmer3-text")
        #print dir(results)
        level = sys.argv[3]
        proteomepath=sys.argv[4]
        cutoff=sys.argv[5]
        species = sys.argv[6]
        fastafile = proteomepath
        fastahandle = open(fastafile, "rU")
        print fastahandle
        proteome = proteomepath.split("\t")[-1]
        fasta = SeqIO.to_dict(SeqIO.parse(fastahandle, "fasta"))

        cutoff=float(cutoff)
        #print results.gi_code
	
        count = 0


        #cutoff=0.01
        print cutoff

	for protein in results:
                processed = []
                if count % 100 ==0:
                     print count
                count = count + 1
		pid = protein.id
                print protein.id
                seq = fasta[protein.id].seq
                #print seq
                if len(protein) > 0:
                    print protein[0]
                else:
                    print "no hits"
		if len(protein) == 0: #if a protein has no hits groupid=proteinid and rank=0
			rank = "0"
			OGid = protein.id
			e = "n/a"
                        qr= "n/a"
                        hitlen="n/a"
                        seq = "n/a"
                        outlist = [rank, level, species, pid, OGid, e, str(qr).replace(" ", ""), proteome, hitlen, str(seq), "\n"]
                        #print "situation 3"
                        #print outlist
		        outstring = "\t".join(outlist)

       			outfile.write(outstring)
		        #processed.append((rank, level, pid, OGid, e, qr, proteome))			
		elif protein[0].evalue > cutoff: #proteins with hits that do not meet the threshold are treated as those without any hits
 			rank = "0"
                        #print protein.id
                        #print protein[0].evalue
			OGid = protein.id
			e = "n/a"
                        qr= "n/a"
                        hitlen="n/a"
                        outlist = [rank, level, species, pid, OGid, e, str(qr).replace(" ", ""), proteome, hitlen, str(seq), "\n"]
                        #print "situation 2"
                        #print outlist
		        outstring = "\t".join(outlist)

                   
       			outfile.write(outstring)
		        #processed.append((rank, level, pid, OGid, e, qr, proteome))			
		else:
			i = 0
			while i<len(protein) and protein[i].evalue <= cutoff:
                                #teststring = str(protein[i].evalue)+ " " + str(cutoff) + " "+ str(i) + " " + str(len(protein))+"\n"
                                #outfile.write(teststring)
				rank = str(i+1)
                                #print "enter loop"
                                #print protein[i].id
                                if "." in protein[i].id:
       
  				    OGid = protein[i].id.split('.')
				    OGid = OGid[1]
                                else:
                                    OGid=protein[i].id
				e = str(protein[i].evalue)
                                

				qr = [] #empty list for domain ranges of this hit
				for d in protein[i]:
				 	qr.append(d.query_range)
                                hitlen=0
                                for j in range(len(qr)):
                                    hitlentmp=qr[j][1] - qr[j][0]
                                    hitlen = hitlen +hitlentmp
                                hitlen=str(hitlen) 
                                if hitlen == 0:
                                    hitlen = "n/a"
                                i = i + 1
                                outlist = [rank, level, species, pid, OGid, e, str(qr).replace(" ", ""), proteome, hitlen, str(seq), "\n"]
                                #print "situation 3"
                                #print outlist
 				outstring = "\t".join(outlist)
                               
       				outfile.write(outstring)
                    
			
        outfile.close()

print "checking entries"
print sys.argv
#check for correct number of inputs
if len(sys.argv) !=7:
	print("Incorrect inputs: need path/to/hmmer result, outfile name, lvl, proteome, cutoff, species.")
else:
   process_all()
