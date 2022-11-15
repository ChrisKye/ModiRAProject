#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Name: merge.py

This script merges master, positives, and false positives into one dataset
"""

import pandas as pd

##Load in 3 datasets
positives = pd.read_csv('../data/positive.csv')
fpositives = pd.read_csv('../data/fpositive.csv')
master = pd.read_csv('../data/master_v3.csv')

##Clean up data
positives = positives.drop(columns = ['Unnamed: 0','Hedge_FalsePositive'])
fpositives = fpositives.drop(columns = ['Unnamed: 0'])
master = master.drop(columns = ['Unnamed: 0'])
master['CIK'] = pd.to_numeric(master['CIK'])

##Fill missing Company Names for positives
missing = positives['Company_Name'].isna()
missing = pd.DataFrame(missing[missing == True])

for index in missing.index:
    if positives['CIK'][index] == positives['CIK'][index-1]:
        positives['Company_Name'].iloc[index] = positives['Company_Name'].iloc[index-1]
    elif positives['CIK'][index] == positives['CIK'][index+1]:
        positives['Company_Name'].iloc[index] = positives['Company_Name'].iloc[index+1]

##Fill missing Company Names for false positives
missing = fpositives['Company_Name'].isna()
missing = pd.DataFrame(missing[missing == True])

for index in missing.index:
    if fpositives['CIK'][index] == fpositives['CIK'][index-1]:
        fpositives['Company_Name'].iloc[index] = fpositives['Company_Name'].iloc[index-1]
    elif fpositives['CIK'][index] == fpositives['CIK'][index+1]:
        fpositives['Company_Name'].iloc[index] = fpositives['Company_Name'].iloc[index+1]

##Fill missing Company Names for master
missing = master['Company_Name'].isna()
missing = pd.DataFrame(missing[missing == True])

for index in missing.index:
    if master['CIK'][index] == master['CIK'][index-1]:
        master['Company_Name'].iloc[index] = master['Company_Name'].iloc[index-1]
    elif master['CIK'][index] == master['CIK'][index+1]:
        master['Company_Name'].iloc[index] = master['Company_Name'].iloc[index+1]

## Drop duplicates
positives = positives.drop_duplicates().reset_index(drop=True)
fpositives = fpositives.drop_duplicates().reset_index(drop=True)
master = master.drop_duplicates().reset_index(drop=True)

## Merge
## We don't merge on Company_Name, because they may be different
final = master.merge(positives, how = 'left', on = ['CIK','Filing', 'Date'])
final = final.merge(fpositives, how = 'left', on = ['CIK','Filing', 'Date'])

## Clean up
final = final[['CIK','Company_Name_x','Company_Name_y','Filing','Date','Hedge_Positive','Hedge_FalsePositive']]
final.rename(columns={'Company_Name_x': 'Company_Name_Master','Company_Name_y': 'Company_Name_Query'}, inplace=True)
final['Hedge_Positive'] = final['Hedge_Positive'].fillna(0)
final['Hedge_FalsePositive'] = final['Hedge_FalsePositive'].fillna(0)

## Save to file
final.to_csv('../data/hedgeIndicator.csv')

