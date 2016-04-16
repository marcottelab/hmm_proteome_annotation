import pandas as pd
import numpy as np
import sys
import scan_proc_functions as spf
import os
import glob
def compareGroups(eggnog, SPEC):
    pwd = os.getcwd()
    filepath1 = "/project/plant_orthologs/output_data/euNOG_" + SPEC + "/" + SPEC + "*.txt"
    print filepath1
    datafiles = glob.glob(filepath1)
    

    
    eggnogdf = pd.read_table(eggnog, sep="\t")
    eggnogdf.columns = ['ACC', 'EGGNOGGROUP']
    eggnogdf = eggnogdf.set_index(['ACC'])
    count = 0
    #print testdf
    for test in datafiles:
        if "nonhit" in test:
            continue
        if "_tot" in test:
            continue
        if "onlyhits" in test:
            continue
        print test
        condition = test.split("/")[-1]
        condition = condition.split(".")[0]
        count = count + 1

          
        testdf = pd.read_table(test, sep=" ")

        testdf['ACC'] = pd.DataFrame(testdf.ProteinID.str.split('|').tolist()).ix[:,1]
        testdf[condition] = pd.DataFrame(testdf.GroupID.str.split('.').tolist()).ix[:,1]
        testdfcols = [condition, 'ACC']
        testdf = testdf[testdfcols]
        testdf = testdf.set_index(['ACC'])
        #print testdf 

        #alignment = testdf.join(eggnogdf, how="left")
        if count == 1:
              holder = testdf
        else:
              print holder
              print testdf 
              holder = holder.join(testdf, how = "outer")
    print holder
    print eggnogdf

    alignment = holder.join(eggnogdf, how = "left")
    print alignment


    outfilename = "groupalignment_" +SPEC +".txt"
    alignment.to_csv(outfilename, sep=" ")
    return alignment
if len(sys.argv)==3:
    compareGroups(sys.argv[1], sys.argv[2])


else:
    print "need infiles path/to/uniprot-Eggnog-mapping and .txt"













