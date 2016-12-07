#Functions for processing output scans from hmmer-3

import sys
import pandas as pd
import numpy as np
import ast



def nonhits(df):
    print df
    #Get only orphan proteins
    #Might be added back into analysis in the future
#    df_nonhits = df[df['evalue'].isnull()]
    df_nonhits= df[df['Rank'] == 0]
    df_nonhits['hitlength']= "n/a"
    df_nonhits['evalue']= "n/a"
    df_nonhits['QueryRange']= "n/a"
    df_nonhits['Annotation']= "n/a"
    return df_nonhits


def onlyhits(df):
    #Get only hits, no orphan proteins
    print "enter onlyhits"
    print df
    df_onlyhits = df[df['evalue'] <= 0.01]
    print df_onlyhits
    return df_onlyhits

def toptenfold(df): 
    grouped = df.groupby('ProteinID').apply(lambda g: g[g['evalue'] <= 10* g['evalue'].min()])
    return grouped 

def tophit2(df): 
    grouped = df.groupby('ProteinID').apply(lambda g: g[g['evalue'] == g['evalue'].min()])
    return grouped 

def tophits(df, num):
    #This function is not working
    grouped = df.groupby('ProteinID').apply(lambda g: g[g['Rank'] <= num])
    return grouped

def tophit(df):
    df_tophit=df[df['Rank']== 1]
    return df_tophit

def eToFloat(x):
    try:
        return x.astype('float64')
    except:
        return x
   
 
def processdf(filename):
    print filename
    df = pd.read_table(filename, sep="\t", index_col=False)
    print df
    #df = df[['Rank', 'Level', 'ProteinID', 'GroupID', 'evalue', 'QueryRange', 'ProteomeID']]
    #df = df.convert_objects(convert_numeric=True)
    #df['evalue']=pd.to_numeric(df['evalue'], errors='coerce')
    df['evalue']= df['evalue'].apply(eToFloat)
    #df['evalue']= df['evalue'].astype('float64')
    #df['evalue']=df['evalue'].astype('float64')
    df.dtypes



    print df['QueryRange'].dtype
    print df['evalue'].dtype #make sure E value is a float
    return df

#only hits
def getlen(row):
     qi = ast.literal_eval(row['QueryRange'])
     #print qi
     totlen = 0
     for i in range(len(qi)):
         #print qi[i]
         hitlen = qi[i][1] - qi[i][0]
         totlen = totlen + hitlen
     #print totlen
     return totlen

def hitlength(df):
    #print df

    df['hitlength'] = df.apply(getlen, axis=1)     
    return df   


def annotate(df, annotationtbl):
    print df
    print annotationtbl
    anntbl = pd.read_table(annotationtbl, sep=",", index_col=False)
    print anntbl
    #anntbl.columns = ['level', 'GroupID', 'x', 'y', 'z', 'Annotation']
    print anntbl
    anntbl = anntbl[['GroupID', 'Annotation']]
    anntbl = anntbl.set_index(['GroupID']) 
    print anntbl 
    df = df.set_index(['GroupID'])
    print df
    final = df.join(anntbl)
    final = final.reset_index()
    return final

def get_sequence(df, fasta):
    #http://stackoverflow.com/questions/19436789/biopython-seqio-to-pandas-dataframe
    with open('sequences.fasta') as fasta_file:  # Will close handle cleanly
        identifiers = []
        sequences = []
        for seq_record in SeqIO.parse(fasta_file, 'fasta'):  # (generator)
            identifiers.append(seq_record.id)
            sequences.append(seq_record.seq)
        s1 = Series(identifiers, name='ID')
        s2 = Series(sequences, name='Sequence')
        #Gathering Series into a pandas DataFrame and rename index as ID column
        df_fasta = DataFrame(dict(ID=s1, sequence=s2)).set_index(['ID'])
    print df_fasta

    print df
    #print annotationtbl
    #anntbl = pd.read_table(annotationtbl, sep="\t", header=None, index_col=False)
    #print anntbl
    #anntbl.columns = ['level', 'GroupID', 'x', 'y', 'z', 'Annotation']
    #print anntbl
    #anntbl = anntbl[['GroupID', 'Annotation']]
    df_fasta = df_fasta.set_index(['ProteinID']) 
    print anntbl 
    df = df.set_index(['ProteinID'])
    print df
    final = df.join(df_fasta)
    final = final.reset_index()
    print final
    return final





"""

def longesthits(df, num):
    f = df.sort_values(by='hitlength', ascending=False)
    g = f.groupby('ProteinID').head(num)

    return g
"""

def fusions(df):
    """
    Make more efficient?
    """
    print "input df"
    print df
    #grouped = df.groupby('ProteinID').apply(lambda g: g[g['QueryRange'] > ['QueryRange']])
    count = 0
    #Ignore groups with only one hit
    pregrouped = df.groupby('ProteinID').filter(lambda x: len(x) > 1)
    print "pregrouped"
    print pregrouped
    grouped = pregrouped.groupby('ProteinID')
    holder =  pd.DataFrame()

    for i in grouped:
        #Only want the first hit
        found = 0
        q = pd.DataFrame(i[1])
        #Make [(x,y)] be evaluated literally as a duple
        q0 = ast.literal_eval(q['QueryRange'].iloc[0])
        q0set =  set(range(q0[0][0], q0[-1][1]))
        if len(range(q0[0][0], q0[-1][1]))< 300:
            continue

        for i in range(1, len(q)):
            if found == 1:
                break
            qi = ast.literal_eval(q['QueryRange'].iloc[i])
            print qi
            
            try:
                qirange = range(qi[0][0], qi[-1][1])
            except IndexError:
               continue

            if len(qirange)< 300:
                continue
            if bool(q0set.intersection(qirange)) == False:
         
                  holder= holder.append(q.iloc[0])
                  holder = holder.append(q.iloc[i])
                  #If potential fusion found, don't look for more
                  found = 1


    print holder
    return holder
"""
Old functions

def longesthits(df):
    count = 0
    if count % 100 == 0:
        print count
    count = count +1
    pregrouped = df.groupby('ProteinID').filter(lambda x: len(x) > 1)
   # print pregrouped
    grouped = pregrouped.groupby('ProteinID')
    holder =  pd.DataFrame()
    for i in grouped:
        q = pd.DataFrame(i[1])
       # print q
       # print q.iloc[0]
       # print q.iloc[1]
        q0 = ast.literal_eval(q['QueryRange'].iloc[0])
        maxlen =  q0[-1][1] - q0[0][0]
        maxrec = 0
        seclen = 0
        #print q
        for i in range(1, len(q)):
            qi = ast.literal_eval(q['QueryRange'].iloc[i])
            #print qi
            if qi == []:
                 continue
            testlen = qi[-1][1] - qi[0][0]
            if testlen > maxlen:
                 if maxlen > seclen:
                     secrec = maxrec
                     seclen = maxlen
                 maxrec = i
                 maxlen = testlen

                
            elif testlen > seclen:
                secrec = i        
                seclen = testlen
            #print maxlen, maxrec
            #print seclen, secrec
        #print maxrec, maxlen
        #print q.iloc[maxrec]
        holder = holder.append(q.iloc[maxrec])
        if seclen > 0:
            #print q.iloc[secrec]
            holder = holder.append(q.iloc[secrec])
    return holder

def getstart(row):
    qi = ast.literal_eval(row['QueryRange'])
    startpos = qi[0][0]
    return startpos

def getend(row):
    qi = ast.literal_eval(row['QueryRange'])
    endpos = qi[-1][1]
    return endpos

def starthit(df):
    df['startpos'] = df.apply(getstart, axis=1)     
    return df


def endhit (df):
    df['endpos'] = df.apply(getend, axis=1)     
    return df
    
def top2hits(df):
    grouped = df.groupby('ProteinID').apply(lambda g: g[g['Rank'] <= 2])
    return grouped 
"""

