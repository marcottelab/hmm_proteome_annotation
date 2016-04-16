#proteome_breaker.py
# argv[1]: fasta file containing proteome
# argv[2]: number of sequences per output file
# argv[3]: directory to store output files
# Returns a group of fasta file with specified number of sequences each (except for the last file which will likely be short).

import sys

#Need to get Biopython from /home
sys.path.append('/home1/03491/cmcwhite/bin')
sys.path[0:0]=['/home1/03491/cmcwhite/bin']

from Bio import SeqIO

def proteome_breaker():
        print "Breaking proteome into {0} sequences".format(sys.argv[2])
	#read in proteome
	proteome = SeqIO.parse(sys.argv[1], "fasta")
	#get the name of the proteome
	pid = sys.argv[1].replace(".fasta", "")
	pid = pid.split('/')
	pid = pid[len(pid)-1] 
	
	#build up batches
	n = 0
	entry = True
	while entry:
                print n
		batch = []	
		while len(batch) < int(sys.argv[2]):
			try:
				entry = proteome.next()
			except StopIteration:
				entry = None
			if entry is None:
				#End of file
				break
			batch.append(entry)
		if batch:
			#SeqIO.write(batch, sys.argv[3]+pid+".scan"+str(n+1)+".fasta", "fasta")
			SeqIO.write(batch, sys.argv[3]+"." +pid+".scan"+str(n+1)+".fasta", "fasta")
	        n+=1	
	
#check for correct number of inputs
if len(sys.argv) !=4:
	print("Incorrect inputs, needs proteome.fasta, desired number of sequences per files, species ID")
else:
	proteome_breaker()
