#iTakes a [spec_code]_tot.txt file and filters for top hit generated by process_tot.py
#arg 1 = [spec]_tot.txt
#outputs:
# [spec]_onlyhits.txt: removes proteins which do not have a hit 
# [spec]_tophit.txt: Only top hit and hitless proteins
# [spec]_onlyhits_tophit.txt: Only top hit
# [spec]_top2hits.txt: Only top 2 hits and hitless proteins
# [spec]_onlyhits_top2hits.txt: Only top 2 hits
#CDM 2-16-16
    
import sys
import pandas as pd
import numpy as np
import ast    
import scan_proc_functions as spf

if len(sys.argv)==2:
    filename=sys.argv[1]
    df = spf.processdf(filename)
    print len(df), "initial hits" 
    species = filename.split("_")[0]

    print "Get proteins without an HMM profile hit"
    outfile = species +"_nonhits.txt"
    print df
    non_hits= spf.nonhits(df)
    print non_hits
    print len(non_hits), "non hits"
    non_hits.to_csv(outfile, sep=" ", na_rep="n/a", index=False)

  

    print "Get only hits about the threshold as well as hitlength"
    outfile = species + "_onlyhits.txt"
#    print df
    only_hitstmp=spf.onlyhits(df)
#    print only_hitstmp
    only_hits = spf.hitlength(only_hitstmp)
#    print len(only_hits), "hits"
    only_hits.to_csv(outfile, sep=" ", index=False)    

    if not only_hits.empty:
        print "Get just the top hit"
        outfile = species + "_tophit.txt"
        top1 = spf.tophits(only_hits, 1)
        print len(top1), "hits"
        top1.to_csv(outfile, sep=" ", index=False)    


        print "Get the top two hits"
        outfile = species + "_top2hits.txt"
        top2 = spf.tophits(only_hits, 2)
        print len(top2), "hits"
        top2.to_csv(outfile, sep=" ", index=False)    

        print "Get just the longest hit"
        outfile = species + "_longesthit.txt"
        long1 = spf.longesthits(only_hits, 1)
        print len(long1), "hits"
        long1.to_csv(outfile, sep=" ", index=False)    


        print "Get the top 2 longest hits"
        outfile = species + "_longest2hits.txt"
        long2 = spf.longesthits(only_hits, 2)
        print len(long2), "hits"
        long2.to_csv(outfile, sep=" ", index=False)    

        if not top2.empty:
            print "Get all hits within tenfold of the top hit"
            outfile = species + "_closerange.txt"
            closerange = spf.toptenfold(top2)
            print len(closerange), "hits"
            closerange.to_csv(outfile, sep=" ", index=False)    
   

else:
    print "need infile  [species name]_tot.txt"