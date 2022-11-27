#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Name: master.py

This script downloads all 10-K/10-Q filings for a list of gvkeys

"""

import pandas as pd
from sec_api import FullTextSearchApi
import time

start_time = time.time()

##Load in keys
keys = pd.read_csv('../data/updated_keys.csv')
keys.set_index(keys = keys['gvkey'], inplace=True)
unique_keys = pd.unique(keys['gvkey'])
keys['cik'] = keys['cik'].astype(str)

## load in master
final = pd.read_csv('../data/hedgeIndicator.csv')
final_cik = pd.unique(final['CIK'])

##Download all filings
master_df = pd.DataFrame(columns=['CIK','Company_Name','Filing','Date'])
master_df.head()

## Create list to track unmatched gvkeys
missingcik = []
missinggvkey = []
random_error = []
nomatch = []
many_filings = []

queryApi = FullTextSearchApi(api_key = "924e625c185d49e08371c3d2291c83ec2f9403289cd73d576da7071a693b147d")

count = 0
##for each entry in gv_list
for key in unique_keys:              ## loop over gvkey list
    count += 1
    ##Find first company cikmap
    cik = []
    here = keys['cik'].loc[key]
    
    ##separate into 2 cases in case there are multiple CIK's
    if(type(here) == pd.core.series.Series):
        cik.extend(here.tolist())
    else:
        cik.append(here)
        
    ##Unique CIK's only
    cik = list(set(cik))
    print("Total Number of CIK's for Company " + str(count) + ": " + str(len(cik)))
    
    ##Query for all CIK's
    cik_index = -1;
    for cikk in cik:
        cik_index = cik_index + 1
        ##check if CIK is in list
        if (cikk == '-1'):
            missingcik.append(key)
            print("CIK Error: missing value")
            continue
        if (int(cikk) in final_cik):
            print("CIK already exists")
            continue
        
        print("CIK found: " + str(cikk))
        
        query = {
            "query": "",
            "formTypes": ["10-K","10-Q"],
            "ciks": [cikk],
            "startDate": "1900-01-01",
            "endDate": "2022-11-30"
        }
        
        filings = queryApi.get_filings(query)
        
        ##check for random error
        if (len(filings['total']) == 0):    
            random_error.append(cikk)
            cik.insert(cik_index+1,cikk)        ##if we get an error, we redo request
            print("    Error occurred, retrying...")
            continue
        
        ##API only returns the first 100 filings -> check the rest
        elif(filings['total']['value'] > 100):
            many_filings.append(filings['total']['value'])
            leftover = filings['total']['value'] - 100
            page = 1
            
            while(leftover > 0):
                page += 1
                print("    Querying page " + str(page) + " ...")
                query = {
                    "query": "",
                    "formTypes": ["10-K","10-Q"],
                    "ciks": [cikk],
                    "startDate": "1900-01-01",
                    "endDate": "2022-11-30",
                    "page": str(page)
                }
                filings_2 = queryApi.get_filings(query)
                filings['filings'] = filings['filings'] + filings_2['filings']
                print("    filings length: " + str(len(filings['filings'])))
                leftover -= 100

        total = filings['total']['value']
        print("    Total: " + str(total))
        print("    Query complete.")
        
        ##check matches
        if (total > 0):
            
            ##create entries for given firm
            entries = []
            for i in range(len(filings['filings'])):
                cik = filings['filings'][i]['cik']
                name = filings['filings'][i]['companyNameLong']
                form = filings['filings'][i]['formType']
                date = filings['filings'][i]['filedAt'][:10]

                entry = [cik,name,form,date]
                entries.append(entry)

            comp_df = pd.DataFrame(entries, columns=['CIK','Company_Name','Filing','Date'])
            # comp_df['Date'] = pd.to_datetime(comp_df['Date'])
            # comp_df = comp_df.sort_values(by=['Date'])
            
            ##concat to fpositive_df
            master_df = pd.concat([master_df,comp_df])  
        else:
            nomatch.append(cikk)
    ##print size of fpositive_df
    print("Total Entries: " + str(len(master_df)) + "\n")
##Finishing Up
print("Queries Complete.")
print("Total number of entries: " + str(len(master_df)))
print("Total number of unmatched gvkeys: " + str(len(missingcik)))
print("Total number of missing CIK's: " + str(len(missinggvkey)))
print("Total number of 0 match cases: " + str(len(nomatch)))
print("Total number of random errors: " + str(len(random_error)))
print("Total execution time = %.2f hours" % ((time.time() - start_time)/3600))

##Clean up data and write to csv
master_df = master_df.reset_index().drop(columns=['index'])
master_df['Date'] = pd.to_datetime(master_df['Date'])
master_df['Date'] = master_df['Date'].dt.date
master_df['CIK'] = pd.to_numeric(master_df['CIK'])

master_df.to_csv("../data/master_v2.csv")
print("Complete.")
