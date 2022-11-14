#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov  9 12:36:23 2022

@author: chriskyee
"""

import pandas as pd
from sec_api import QueryApi
import pyreadstat
import time

##Load in other 2 
positives = pd.read_csv('positive.csv')
fpositives = pd.read_csv('fpositive.csv')
master = pd.read_csv('master.csv')

positives = positives.drop(columns = ['Unnamed: 0','Hedge_FalsePositive'])
fpositives = fpositives.iloc[:,1:]
master = master.iloc[:,1:]
master['CIK'] = pd.to_numeric(master['CIK'])


a = positives[positives['CIK']==61478]
b = fpositives[fpositives['CIK']==61478]
c = master[master['CIK']==61478]

c = c.drop(columns = ['Company_Name'])

##merge datasets
d = c.merge(a, how = 'outer', on = ['CIK','Filing','Date'])
d = d.merge(b, how = 'outer', on = ['CIK', 'Filing','Date'])

##Fill in company names

