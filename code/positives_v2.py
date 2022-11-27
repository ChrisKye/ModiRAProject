# -*- coding: utf-8 -*-
"""
Name: positives.py

This script runs queries across a list of gvkeys to check text matches for false positives

"""

import pandas as pd
import pyreadstat
from sec_api import FullTextSearchApi

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

##Load in new reference map
keys = pd.read_csv('../data/updated_keys.csv')
keys.set_index(keys = keys['gvkey'], inplace=True)
unique_keys = pd.unique(keys['gvkey'])
keys['cik'] = keys['cik'].astype(str)

##load in master
final = pd.read_csv("../data/hedgeIndicator.csv")
final_cik = pd.unique(final['CIK'])

##Create empty df to populate with matches
positive_df = pd.DataFrame(columns=['CIK','Company_Name','Filing','Date','Hedge_Positive', 'Hedge_FalsePositive'])
positive_df.head()

## Create lists to track errors
missingcik = []
random_error = []

queryApi = FullTextSearchApi(api_key="924e625c185d49e08371c3d2291c83ec2f9403289cd73d576da7071a693b147d")

count = 0
##for each entry in gv_list
for key in unique_keys:              ## loop over gvkey list
    count += 1
    #Find first company CIK
    cik = []
    here = keys['cik'].loc[key]

    ##separate into 2 cases in case there are multiple CIK's
    if(type(here) == pd.core.series.Series):
        cik.extend(here.tolist())
    else:
        cik.append(here)

    cik = list(set(cik))

    ##Unique CIK's only
    print("Total Number of CIK's for Company " + str(count) + ": " + str(len(cik)))

    ##Query across all CIK's
    for cikk in cik:
        if (int(cikk) in final_cik):
            print("CIK already exists")
            continue
        #check if CIK is in list
        print("CIK found: " + str(cikk))
        ##Download
        query = {
            "query": "\"interest rate swap\" OR \
                \"hedging against interest rate\" OR \
                \"hedge interest rate\" OR \
                \"hedges interest rate\" OR \
                \"hedging interest rate\" OR \
                \"hedge for interest rate\" OR \
                \"hedges for interest rate\" OR \
                \"hedging for interest rate\" OR \
                \"hedging of interest rate\" OR \
                \"interest rate hedge\" OR \
                \"interest rate hedging\" OR \
                \"interest rate risk hedge\" OR \
                \"interest rate risk hedging\" OR \
                \"interest rate derivative\" OR \
                \"interest rate swap\" OR \
                \"interest rate contract\" OR \
                \"interest rate agreement\" OR \
                \"interest rate collar\" OR \
                \"interest rate cap\"",
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
        else:
            print("    Query complete.")
        ##total number of filings
        total = filings['total']['value']
        print("    Total: " + str(total))

        ##check if it has matches
        if (total > 0):

            ##create entries for given firm
            entries = []
            for i in range(len(filings['filings'])):
                cik = filings['filings'][i]['cik']
                name = filings['filings'][i]['companyNameLong']
                form = filings['filings'][i]['formType']
                date = filings['filings'][i]['filedAt']
                hedge_p = 1

                entry = [cik,name,form,date,hedge_p]
                entries.append(entry)

            comp_df = pd.DataFrame(entries, columns=['CIK','Company_Name','Filing','Date','Hedge_Positive'])
            comp_df['Date'] = pd.to_datetime(comp_df['Date'])
            comp_df = comp_df.sort_values(by=['Date'])
            comp_df['Hedge_FalsePositive'] = ''

            ##concat to positive_df
            positive_df = pd.concat([positive_df,comp_df])

    ##print size of positive_df for each iteration
    print("Total Entries: " + str(len(positive_df)) + "\n")

##Finishing Up
print("Queries Complete.")
print("Total number of entries: " + str(len(positive_df)))

##Clean up data and write to csv
positive_df = positive_df.reset_index().drop(columns=['index'])
positive_df['Date'] = positive_df['Date'].dt.date
positive_df.to_csv("../data/positive_v2.csv")

print("Complete.")
