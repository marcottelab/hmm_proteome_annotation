import pandas as pd
import ast
import numpy as np
import sys
import scan_proc_functions as spf
import csv

if len(sys.argv)==2:
    filename=sys.argv[1]
    onlyhits = spf.processdf(filename)
    print len(onlyhits), "hits to process"
    species = filename.replace("_annotated.txt", "")   
    if not onlyhits.empty:

            print "Get candidate fusion proteins"
            outfile8 = species + "_fusions.txt"
            fus = spf.fusions(onlyhits)
            fus.to_csv(outfile8, sep="\t", index=False, quoting=csv.QUOTE_NONE,  quotechar="")

else:
    print "need infile  [species name]_annotated.txt"













