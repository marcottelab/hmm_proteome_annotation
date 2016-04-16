#og_lg_rank.py
# sys.argv[1]: directory for input and outputs
# sys.argv[2]: master file (output of og_lgl_master.py)
# sys.argv[3]: name for .ncol
# Returns .ncol file that can be fed into LGL to plot the top two hits. Orthogroup will be the central node with proteins that belong to that orthogroup connected to it. 
# Returns color_rank for coloring by rank. Rank 1 is red and rank 2 is blue, need to remove quotations (vim replace) around color before using.
# Returns color_file for coloring by species. Need to replace species names with RBG codes. 
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
	colspecies.to_csv(sys.argv[1]+'color_file', sep=' ', index=False, header=None)

#check for correct number of inputs
if len(sys.argv) != 3:
	print('Incorrect number of inputs')
else:
	og_lgl_rank()

