#NOT WORKING RIGHT

import sys
sys.path.append('/home1/03491/cmcwhite/bin')
sys.path[0:0] = ['/home1/03491/cmcwhite/bin']
from Bio import SeqIO

annotdict={}

annotationsfile = sys.argv[1] 

#Get protein name and annotation into a dictionary
annot = open(annotationsfile, "r").readlines()
for raw_line in annot[1:]:
    line = raw_line.replace("\n", "")
    i = line.split("\t")
    if i[8]:
        annot_line = i[8].replace(" ", "_") + "|" +  i[0] + "|" + i[2]
    else:
        annot_line = "none" + "|" + i[0] + "|" + i[2]
    
    annotdict[i[3]] = annot_line
    level = i[2]

infasta = sys.argv[2]
outfilename = sys.argv[2].replace(".fasta", "") + "_"+ level + "_annotated.fasta"
outfile = open(outfilename, "w")


handle = open(infasta, "rU")
for record in SeqIO.parse(handle, "fasta"):
    #prot = record.id.split(" ")[0] 
    prot = record.id


    try:
        annotation = annotdict[prot] 

    except:
        annotation = "None|none"
  
    finalheader = ">" + annotation + "|" + record.description +"\n"
    outfile.write(finalheader)
    outfile.write(str(record.seq) + "\n")


outfile.close()




































