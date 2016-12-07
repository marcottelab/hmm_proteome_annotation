    #NOT WORKING RIGHT
    
import sys
sys.path.append('/home1/03491/cmcwhite/bin')
sys.path[0:0] = ['/home1/03491/cmcwhite/bin']
from Bio import SeqIO
import argparse
    
def annotate_a_fasta(annotationfilename, fastapath, outfilename):
    annotdict={}
    
    #annotationsfile = sys.argv[1] 
    
    #Get protein name and annotation into a dictionary
    annot = open(annotationfilename, "r").readlines()
    for raw_line in annot[1:]:
        line = raw_line.replace("\n", "")
        i = line.split("\t")
        if i[8]:
            annot_line = i[10].replace(" ", "_") + "|" +  i[0] + "|" + i[2]
        else:
            annot_line = "none" + "|" + i[0] + "|" + i[2]
        
        annotdict[i[4]] = annot_line
       
    
    #infasta = sys.argv[2]
    #level = sys.argv[3]
    outfile = open(outfilename, "w")
    
    
    handle = open(fastapath, "rU")
    for record in SeqIO.parse(handle, "fasta"):
        #prot = record.id.split(" ")[0] 
        prot = record.id
        try:
            annotation = annotdict[prot] 
    
        except:
            annotation = "None|none|none"
      
        finalheader = ">" + annotation + "|" + record.description +"\n"
        outfile.write(finalheader)
        outfile.write(str(record.seq) + "\n")
    
    
    outfile.close()
    
    
parser = argparse.ArgumentParser(description='Make group annotated fasta')
parser.add_argument('annotationfilename', action="store", type=str)
parser.add_argument('fastapath', action="store", type=str)
parser.add_argument('outfilename', action="store", type=str)
inputs = parser.parse_args()


annotate_a_fasta(inputs.annotationfilename, inputs.fastapath, inputs.outfilename)
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
