#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov  9 12:36:23 2022

@author: chriskyee
"""

import pandas as pd


df1 = pd.DataFrame({'key': ['foo','bar', 'baz', 'faz'],
                    'fp': [1, 2, 3, 4]})
df2 = pd.DataFrame({'key': ['bar', 'foo', 'faz'],
                    'p': [5, 6, 7]})

df3 = df1.merge(df2, how='outer', on = 'key')
print(df3)