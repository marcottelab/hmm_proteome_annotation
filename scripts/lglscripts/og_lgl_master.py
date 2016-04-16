#og_lgl_master.py
#takes ranks 1 and 2 from my orthology tables and outputs file with
#OG name, protein name, rank, and species, for creating lgl .ncol and .colors files.
#sys.argv[1]: name and path of orthogroup table
#sys.argv[2]: name and path for output (can make new file or add to existing)
# Returns a space seperated text file with orthogroupID, proteinID, rank and species. Entries of ranks 1 and 2 are included. File is sorted by orthogroupID.
# Master file for creating lgl images. 

import os.path
import sys
import pandas as pd

def og_lgl_master():
	#get species five letter abbreviation from file name
	#this follows the convention I've been using: species_processtype.txt 
	species = sys.argv[1].split('/')
	species = species[len(species)-1]
	species = species.split('_')
	species = species[0]

	#read file in as dataframe
	og = pd.read_table(sys.argv[1], sep=' ')
	
	#make new dataframe with just top two hits, groupID, proteinID and rank for each
	top = og[['GroupID', 'ProteinID', 'Rank']]
	top = top[top['Rank'] < 3]
	top = top[top['Rank'] > 0]

	#add a new column with species name
	top['Species'] = species
	
	#if output file exists append top 
	if os.path.isfile(sys.argv[2]):
		top2 = pd.read_table(sys.argv[2], sep=' ')
		tops = [top2, top]
		top = pd.concat(tops)
	
	#sort by GroupID	
	top = top.sort(['GroupID'])
	#output to file
	top.to_csv(sys.argv[2], sep=' ', index=False)

#check for correct number of inputs
if len(sys.argv) != 3:
	print("Incorrect input, needs OG table and output file.")
else:
	og_lgl_master()
