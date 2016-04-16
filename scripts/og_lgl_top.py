#og_lgl_top.py
#takes master file (output of og_lgl_master.py)
#makes .ncol and color files for plotting the top hits colored by species
#color file: arath = red, orysj = blue, traes = green, need to remove quotations around color before using
#sys.argv[1]: directory for input and outputs
#sys.argv[2]: master file
#sys.argv[3]: name for .ncol

import sys
import pandas as pd

def og_lgl_top():
	#read master file in as dataframe
	master = pd.read_table(sys.argv[1]+sys.argv[2], sep=' ')

	#make a new column of rbg values by species
	rbg = []
	for s in master['Species']:
		if s == 'arath':
			rbg.append('1.0 0.0 0.0')
		elif s == 'orysj':
			rbg.append('0.0 0.0 1.0')
		elif s == 'traes':
			rbg.append('0.0 1.0 0.0')
	master['SpeciesColor'] = rbg

	#make a new dataframe for just the top hits
	top = master[master['Rank'] < 2]

	#make .ncol file, two columns of vertices(groupid, proteinid)
	ncol = top[['GroupID', 'ProteinID']]
	ncol.to_csv(sys.argv[1]+sys.argv[3], sep=' ', index=False, header=None)

	#make color file
	color = top[['GroupID', 'ProteinID', 'Species', 'SpeciesColor']]
	color.to_csv(sys.argv[1]+'color_file', sep=' ', index=False, header=None)	

#check for correct number of inputs
if len(sys.argv) != 4:
	print('Incorrect number of inputs')
else:
	og_lgl_top()

