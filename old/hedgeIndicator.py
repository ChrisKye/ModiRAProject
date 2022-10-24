# -*- coding: utf-8 -*-
"""
Hedge Indicator (Master)

This script runs queries across a list of gvkeys to check text matches for interest rate hedges.

"""

import pandas as pd
import pyreadstat
import numpy as np
from sec_api import FullTextSearchApi

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
cikmap['cik'] = cikmap['cik'].astype(int)
cikmap.set_index(keys = cikmap['gvkey'], inplace=True) ##gvkeys as indices
cikmap['cik']=cikmap['cik'].fillna(-1)
cikmap.head(10)

########################  Positive Matches First  ########################
positive_df = pd.DataFrame(columns=['CIK','Company_Name','Filing','Date','Hedge_Positive', 'Hedge_FalsePositive'])
positive_df.head()

## Create list to track unmatched gvkeys
missingcik = []

queryApi = FullTextSearchApi(api_key="86712fa19f2b64be72ace0aa5aef5c749db89848915282aeaff562be7fb018fb")

##for each entry in gv_list
for index in range(11):              ## loop over gvkey list
    
    ##Find first company CIK
    key = gv_list['gvkey'].iloc[index]
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
    for cikk in cik: 
        ##check if CIK is in list
        if (cikk == '-1'):
            missingcik.append(key)
            print("ERROR: CIK not found")
        else:
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
                "ciks": [cik],
                "startDate": "1900-01-01",
                "endDate": "2022-09-18"
            }
            filings = queryApi.get_filings(query)
            total = filings['total']['value']
            print("Total for CIK" + str(cikk) + ": " + str(total))
            
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
            
        ##print size of positive_df
    print("Total Entries: " + str(len(positive_df)) + "\n")
    
##Clean up data and write to csv
positive_df = positive_df.reset_index().drop(columns=['index'])
positive_df['Date'] = positive_df['Date'].dt.date

positive_df.to_csv("positive.csv")