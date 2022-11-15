#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Name: master.py

This script downloads all 10-K/10-Q filings for a list of gvkeys

"""

import pandas as pd
from sec_api import QueryApi, FullTextSearchApi
import pyreadstat
import time

start_time = time.time()

##Load in gvkey List
gv_list, meta = pyreadstat.read_dta('../data/gvkey_list.dta')
gv_list.head()

## Sort list & change to int
gv_list = gv_list.sort_values(by = 'gvkey')
gv_list = gv_list.drop(19)
gv_list['gvkey'] = gv_list['gvkey'].astype(str).astype(int)
gv_list.head()

##Load in reference map
cikmap = pd.read_csv('../data/index.csv')
cikmap.set_index(keys = cikmap['gvkey'], inplace=True) ##gvkeys as indices
cikmap['cik']=cikmap['cik'].fillna(-1)
cikmap['cik'] = cikmap['cik'].astype(int)
cikmap.head(10)

##Download all filings
master_df = pd.DataFrame(columns=['CIK','Company_Name','Filing','Date'])
master_df.head()

## Create list to track unmatched gvkeys
missingcik = []
missinggvkey = []
random_error = []
nomatch = []
many_filings = []

queryApi = QueryApi(api_key="924e625c185d49e08371c3d2291c83ec2f9403289cd73d576da7071a693b147d")
queryApi_2 = FullTextSearchApi(api_key = "924e625c185d49e08371c3d2291c83ec2f9403289cd73d576da7071a693b147d")

for index in range(50):
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
    
    ##Query for all CIK's
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
        # query = {
        #     "query":  {
        #         "query_string": {
        #             "query": "cik:" + str(cikk) + " AND (formType:\"10-K\" OR \"10-Q\")"
        #         }
        #     },
        #     "from": "0",
        #     "sort": [{"filedAt": {
        #                 "order": "asc"
        #             }}]
        # }
        
        query = {
            "query": "",
            "formTypes": ["10-K","10-Q"],
            "ciks": [cikk],
            "startDate": "1900-01-01",
            "endDate": "2022-11-30"
        }
        
        filings = queryApi_2.get_filings(query)
        
        ##check for random error
        if (len(filings['total']) == 0):    
            random_error.append(cikk)
            cik.insert(cik_index+1,cikk)        ##if we get an error, we redo request
            print("    Error occurred, retrying...")
            continue
        
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
                filings_2 = queryApi_2.get_filings(query)
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

master_df.to_csv("../data/master_v3.csv")
print("Complete.")
