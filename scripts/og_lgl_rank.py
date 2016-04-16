#og_lg_rank.py
#takes master file (output of og_lgl_master.py)
#makes .ncol and color files for plotting the top two hits
#color rank: rank 1 = red, rank 2 = blue, need to remove quotations (vim replace) around color before using
#color file: arath = red, orysj = blue, traes = green, need to remove quotations around color before using 
#sys.argv[1]: directory for input and outputs
#sys.argv[2]: master file
#sys.argv[3]: name for .ncol

import sys
import pandas as pd

def og_lgl_rank():
	#read master file in as dataframe
	master = pd.read_table(sys.argv[1]+sys.argv[2], sep=' ')

	#make .ncol file, two columns of vertices(groupid, proteinid)
	ncol = master[['GroupID', 'ProteinID']]
	ncol.to_csv(sys.argv[1]+sys.argv[3], sep=' ', index=False, header=None)

	#make color by rank file
	colrank = master[['GroupID', 'ProteinID', 'Rank']]
	rbg = []
	for r in colrank['Rank']:
		if r == 1:
			rbg.append('1.0 0.0 0.0')
		elif r == 2:
			rbg.append('0.0 0.0 1.0')
	colrank['RankColor'] = rbg
	colrank = colrank[['GroupID', 'ProteinID', 'RankColor']]	
	colrank.to_csv(sys.argv[1]+'color_rank', sep=' ', index=False, header=None)
	
	#make color by species file
	colspecies = master[['GroupID', 'ProteinID', 'Species']]
	rbg2 = []
	for s in colspecies['Species']:
		if s == 'arath':
			rbg2.append('1.0 0.0 0.0')
		elif s == 'orysj':
			rbg2.append('0.0 0.0 1.0')
		elif s == 'traes':
			rbg2.append('0.0 1.0 0.0')		
	colspecies['SpeciesColor'] = rbg2
	colspecies = colspecies[['GroupID', 'ProteinID', 'SpeciesColor']]
	colspecies.to_csv(sys.argv[1]+'color_file', sep=' ', index=False, header=None)

#check for correct number of inputs
if len(sys.argv) != 3:
	print('Incorrect number of inputs')
else:
	og_lgl_rank()

