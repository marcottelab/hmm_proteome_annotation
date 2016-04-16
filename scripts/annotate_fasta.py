#NOT WORKING RIGHT

import sys
sys.path.append('/home1/03491/cmcwhite/bin')
sys.path[0:0] = ['/home1/03491/cmcwhite/bin']
from Bio import SeqIO

annotdict={}

annotations = sys.argv[1] 
outfilename = sys.argv[2].replace(".fasta", "") +  "_annotated.fasta"
outfile = open(outfilename, "w")


#Get protein name and annotation into a dictionary
fasta= sys.argv[2] + .fasta
annot = open(fasta, "r").readlines()
for line in annot[1:]:
    i = line.split("\t")
    annotdict[i[3]] = i[8]
 

#print annotdict
infasta = sys.argv[1] + ".fasta"
handle = open(infasta, "rU")
for record in SeqIO.parse(handle, "fasta"):
    prot = record.id.split(" ")[0] 
    #print record.description

    try:
        annotation = annotdict[prot]

    except:
        annotation = "n/a\n"
    finalheader = ">" +record.description + "|" + annotation
    outfile.write(finalheader)
    outfile.write(str(record.seq) + "\n")


outfile.close()




































