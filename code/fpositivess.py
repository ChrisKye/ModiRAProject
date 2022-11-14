# -*- coding: utf-8 -*-
"""
Hedge Indicator (Master)

This script runs queries across a list of gvkeys to check text matches for interest rate hedges.

"""

import pandas as pd
import pyreadstat
from sec_api import FullTextSearchApi
import time
import codecs

start_time = time.time()

##Load in gvkey List
gv_list, meta = pyreadstat.read_dta('gvkey_list.dta')
gv_list.head()

## Sort list & change to int
gv_list = gv_list.sort_values(by = 'gvkey')
gv_list = gv_list.drop(19)
gv_list['gvkey'] = gv_list['gvkey'].astype(str).astype(int)
gv_list.head()

##Load in reference map
cikmap = pd.read_csv('index.csv')
cikmap.set_index(keys = cikmap['gvkey'], inplace=True) ##gvkeys as indices
cikmap['cik']=cikmap['cik'].fillna(-1)
cikmap['cik'] = cikmap['cik'].astype(int)
cikmap.head(10)

########################  Positive Matches First  ########################
fpositive_df = pd.DataFrame(columns=['CIK','Company_Name','Filing','Date','Hedge_FalsePositive'])
fpositive_df.head()
    
## Create list to track unmatched gvkeys
missingcik = []
missinggvkey = []
random_error = []
nomatch = []

## Read in query search texts
with codecs.open("f_positive_clean_1.txt", 'r', encoding='unicode_escape') as file:
    query_1 = file.read()
with codecs.open("f_positive_clean_2.txt", 'r', encoding='unicode_escape') as file:
    query_2 = file.read()
with codecs.open("f_positive_clean_3.txt", 'r', encoding='unicode_escape') as file:
    query_3 = file.read()

queryApi = FullTextSearchApi(api_key="924e625c185d49e08371c3d2291c83ec2f9403289cd73d576da7071a693b147d")

##for each entry in gv_list
for index in range(len(gv_list)):              ## loop over gvkey list
    ##Find first company cikmap
    key = gv_list['gvkey'].iloc[index]
    if(key not in cikmap['gvkey']):
        print("gvkey for Company " + str(index+1) + " not in map. Exiting...")
        missinggvkey.append(key)
        continue
    cik = []
    here = cikmap['cik'].loc[key].astype(int).astype(str)
    
    ##separate into 2 cases in case there are multiple CIK's
    if(type(here) == pd.core.series.Series):
        cik.extend(here.tolist())
    else:
        cik.append(here)
        
    ##Unique CIK's only
    cik = list(set(cik))
    
    print("Total Number of CIK's for Company " + str(index+1) + ": " + str(len(cik)))
    ##Query across all CIK's
    cik_index = -1;
    for cikk in cik:
        cik_index = cik_index + 1
        ##check if CIK is in list
        if (cikk == '-1'):
            missingcik.append(key)
            print("CIK Error: missing value")
            continue
        
        print("CIK found: " + str(cikk))
        ## Run first query
        query = {
            "query": query_1,
            "formTypes": ["10-K","10-Q"],
            "ciks": [cikk],
            "startDate": "1900-01-01",
            "endDate": "2022-11-30"
        }
        filings_1 = queryApi.get_filings(query)
        
        ##check for random error
        if (len(filings_1['total']) == 0):    
            random_error.append(cikk)
            cik.insert(cik_index+1,cikk)        ##if we get an error, we redo request
            print("    Error occurred, retrying...")
            continue
        else:
            print("    Query 1 complete.")
        
        ## Run second query
        query = {
            "query": query_2,
            "formTypes": ["10-K","10-Q"],
            "ciks": [cikk],
            "startDate": "1900-01-01",
            "endDate": "2022-11-30"
        }
        filings_2 = queryApi.get_filings(query)
        
        ##check for random error
        if (len(filings_2['total']) == 0):    
            random_error.append(cikk)
            cik.insert(cik_index+1,cikk)        ##if we get an error, we redo request
            print("   Error occurred, retrying...")
            continue
        else:
            print("    Query 2 complete.")
        
        ## Run third query
        query = {
            "query": query_3,
            "formTypes": ["10-K","10-Q"],
            "ciks": [cikk],
            "startDate": "1900-01-01",
            "endDate": "2022-11-30"
        }
        filings_3 = queryApi.get_filings(query)
        
        ##check for random error
        if (len(filings_3['total']) == 0):    
            random_error.append(cikk)
            cik.insert(cik_index+1,cikk)        ##if we get an error, we redo request
            print("    Error occurred, retrying...")
            continue
        else:
            print("    Query 3 complete.")
        
        ##total number of filings
        total = filings_1['total']['value'] + filings_2['total']['value'] + filings_3['total']['value']
        print("    Total: " + str(total))
        filings = {'filings': filings_1['filings'] + filings_2['filings'] + filings_3['filings']}
        
        ##check if it has matches
        if (total > 0):

            ##create entries for given firm
            entries = []
            for i in range(len(filings['filings'])):
                cik = filings['filings'][i]['cik']
                name = filings['filings'][i]['companyNameLong']
                form = filings['filings'][i]['formType']
                date = filings['filings'][i]['filedAt']
                hedge_f = 1

                entry = [cik,name,form,date,hedge_f]
                entries.append(entry)

            comp_df = pd.DataFrame(entries, columns=['CIK','Company_Name','Filing','Date','Hedge_FalsePositive'])
            comp_df['Date'] = pd.to_datetime(comp_df['Date'])
            comp_df = comp_df.sort_values(by=['Date'])
            
            ##concat to fpositive_df
            fpositive_df = pd.concat([fpositive_df,comp_df])  
        else:
            nomatch.append(cikk)
    ##print size of fpositive_df
    print("Total Entries: " + str(len(fpositive_df)) + "\n")
##Finishing Up
print("Queries Complete.")
print("Total number of entries: " + str(len(fpositive_df)))
print("Total number of unmatched gvkeys: " + str(len(missingcik)))
print("Total number of missing CIK's: " + str(len(missinggvkey)))
print("Total number of 0 match cases: " + str(len(nomatch)))
print("Total number of random errors: " + str(len(random_error)))
print("Total execution time = %.2f hours" % ((time.time() - start_time)/3600))

##Clean up data and write to csv
fpositive_df = fpositive_df.reset_index().drop(columns=['index'])
fpositive_df['Date'] = fpositive_df['Date'].dt.date

fpositive_df.to_csv("fpositive.csv")

print("Complete.")