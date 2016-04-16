import pandas as pd
import ast
import numpy as np
import sys
import scan_proc_functions as spf
import csv

if len(sys.argv)==3:
    filename=sys.argv[1]
    outfilename= sys.argv[2]
    print "Get each proteins best match from different OG sets"
    print filename
    df = spf.processdf(filename)
    pan = spf.tophit2(df)
    pan.to_csv(outfilename, sep="\t", index=False, quoting=csv.QUOTE_NONE,  quotechar="")

else:
    print "need infile"













