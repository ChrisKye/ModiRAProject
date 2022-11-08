# -*- coding: utf-8 -*-
"""
Hedge Indicator (Master)

This script runs queries across a list of gvkeys to check text matches for interest rate hedges.

"""

import pandas as pd
import pyreadstat
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

queryApi = FullTextSearchApi(api_key="924e625c185d49e08371c3d2291c83ec2f9403289cd73d576da7071a693b147d")

##for each entry in gv_list
for index in range(3):              ## loop over gvkey list
    ##Find first company CIK
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
    for cikk in cik: 
        ##check if CIK is in list
        if (cikk == '-1'):
            missingcik.append(key)
            print("CIK Error: missing value")
        else:
            print("CIK found: " + str(cikk))
            ##Download
            query = {
                "query": "\"not used any interest rate\" OR \
                        \"not use any interest rate\" OR \
                        \"not using any interest rate\" OR \
                        \"not used interest rate\" OR \
                        \"not use interest rate\" OR \
                        \"not using interest rate\" OR \
                        \"not used an interest rate\" OR \
                        \"not use an interest rate\" OR \
                        \"not using an interest rate\" OR \
                        \"not currently use any interest rate\" OR \
                        \"not currently using any interest rate\" OR \
                        \"not currently use interest rate\" OR \
                        \"not currently using interest rate\" OR \
                        \"not currently use an interest rate\" OR \
                        \"not currently using an interest rate\" OR \
                        \"currently no interest rate\" OR \
                        \"not hedged against any interest rate\" OR \
                        \"not hedge against any interest rate\" OR \
                        \"not hedging against any interest rate\" OR \
                        \"not hedged against interest rate\" OR \
                        \"not hedge against interest rate\" OR \
                        \"not hedging against interest rate\" OR \
                        \"not hedged any interest rate\" OR \
                        \"not hedge any interest rate\" OR \
                        \"not hedging any interest rate\" OR \
                        \"not hedged interest rate\" OR \
                        \"not hedge interest rate\" OR \
                        \"not hedging interest rate\" OR \
                        \"not enter into any interest rate\" OR \
                        \"not enter into interest rate\" OR \
                        \"not enter into an interest rate\" OR \
                        \"not engaged in any interest rate\" OR \
                        \"not engage in any interest rate\" OR \
                        \"not engaged in interest rate\" OR \
                        \"not engage in interest rate\" OR \
                        \"not use derivative financial instruments as a hedge against interest rate\" OR \
                        \"termination of interest rate\" OR \
                        \"fixed to variable interest rate\" OR \
                        \"fixed to floating interest rate\" OR \
                        \"fixed rate debt to variable rate\" OR \
                        \"fixed rate debt to floating rate\" OR \
                        \"fixed to variable rate interest rate\" OR \
                        \"fixed to floating rate interest rate\" OR \
                        \"fixed rate to variable rate\" OR \
                        \"fixed rate to floating rate\" OR \
                        \"fixed rates to variable rates\" OR \
                        \"fixed rates to floating rates\" OR \
                        \"fixed rate into variable rate\" OR \
                        \"fixed rate into floating rate\" OR \
                        \"fixed rates into variable rates\" OR \
                        \"fixed rates into floating rates\" OR \
                        \"fixed rate obligations to variable rate obligations\" OR \
                        \"fixed rate obligations to floating rate obligations\" OR \
                        \"a fixed rate to a variable rate\" OR \
                        \"a fixed rate to a floating rate\" OR \
                        \"fixed to floating swap\" OR \
                        \"not engaged in hedge transactions such as interest rate futures contracts or interest rate swap\" OR \
                        \"not enter into derivative transactions or speculate on the future direction of interest rate\" OR \
                        \"not use derivative financial instruments such as interest rate swap\" OR \
                        \"not entered into any swap agreement\" OR \
                        \"not have any interest rate swap\" OR \
                        \"not have interest rate swap\" OR \
                        \"not have an interest rate swap\" OR \
                        \"had no interest rate swap\" OR \
                        \"not currently hedge or otherwise use derivative instruments to manage interest rate\" OR \
                        \"not attempt to reduce or eliminate our exposure to interest rate risk through the use of derivative financial instrument\" OR \
                        \"enter into variable interest rate swaps effectively converting fixed rate borrowings to variable rate\" OR \
                        \"not designate the interest rate swap as a cash flow hedge and the interest rate swap will not qualify for hedge accounting\" OR \
                        \"not participate in hedging programs interest rate swaps or other activities involving the use of derivative financial instruments to manage interest rate risk\" OR \
                        \"may use interest rate swaps to balance exposure to interest rate\" OR \
                        \"in the future we may enter into interest rate swap\" OR \
                        \"may also enter into derivative financial instruments such as interest rate swap\" OR \
                        \"may enter into interest rate hedging agreements in the future to mitigate our exposure to interest rate risk\" OR \
                        \"may enter into interest rate swaps involving the exchange of floating for fixed rate interest payments\" OR \
                        \"swap agreements to hedge a portion of the consolidated interest rate risk associated with issuances of fixed rate\" OR \
                        \"fixed rate receipts in exchange for making floating rate payments\" OR \
                        \"fixed rate amounts in exchange for making floating rate payments\" OR \
                        \"manage interest rate risk related to fixed rate borrowing\" OR \
                        \"not have any derivative instruments outstanding\" OR \
                        \"swaps changed the fixed rate exposure on the debt to variable\" OR \
                        \"terminated all of its interest rate swap agreements\" OR \
                        \"swap long term borrowings at fixed rates into variable rates\" OR \
                        \"we pay variable rates and we receive a fixed rate\" OR \
                        \"exchange an obligation to make fixed debt payments for an obligation to make floating rate payments',...\" OR \
                        \"were no interest rate swap agreements\" OR \
                        \"were no interest rate swaps outstanding\" OR \
                        \"receives fixed interest rate payments and makes variable interest rate payments\" OR \
                        \"receive fixed pay variable interest rate\" OR \
                        \"receive fixed pay floating interest rate\" OR \
                        \"swapped the fixed rate to a variable rate\" OR \
                        \"will receive fixed interest rate payments and will make variable interest rate payments\" OR \
                        \"not use derivative financial instruments to manage interest rate risk\" OR \
                        \"not currently use derivative financial instruments to manage interest rate risk\"",
                "formTypes": ["10-K","10-Q"],
                "ciks": [cikk],
                "startDate": "1900-01-01",
                "endDate": "2022-11-30"
            }
            filings = queryApi.get_filings(query)
            
            ##check for random error
            if (len(filings['total']) == 0):
                random_error.append(index)
                print("Error occurred")
                continue
            
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
print("Total number of unmatched gvkeys: " + str(len(missingcik)))
print("Total number of missing CIK's: " + str(len(missinggvkey)))
print("Total number of entries: " + str(len(fpositive_df)))

##Clean up data and write to csv
fpositive_df = fpositive_df.reset_index().drop(columns=['index'])
fpositive_df['Date'] = fpositive_df['Date'].dt.date

fpositive_df.to_csv("fpositive.csv")

print("Complete.")