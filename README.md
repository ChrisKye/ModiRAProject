# Construction of HedgeIndicator.csv and HedgeIndicator_v2.csv

### HedgeIndicator (Version 1)
We downloaded all available 10-K and 10-Q filings from the SEC website using the sec-api Python package (https://pypi.org/project/sec-api). In order to construct the hedgeIndicator dataset, we downloaded the data in 3 parts: the positive matches (positives.py), the false positive matches (fpositivess.py), and all filings (master.py). The basic structure of the three scripts are the same; the most notable difference is the search terms used in the query. In order to ensure consistency in format across the outputs, we used the FullTextSearchApi (https://sec-api.io/docs/full-text-search-api) for all queries, which returns filings from 2000-01-01 up to present day. The list of query strings for positives and false positives can be found in the data folder. After the three datasets were downloaded, they were merged into hedgeIndicator.csv.

### HedgeIndicator (Version 2)
We repeated the process for a new set of gvkeys and CIK's. We downloaded filings for all firms in updated_keys.csv that were not already included in the original hedgeIndicator.csv. The queries were then merged through the same process described above. Finally, we extracted entries from the original hedgeIndicator.csv that were included in the new list (updated_keys.csv), then merged the two datasets together. All files relevant to v2 are labelled with the suffix "_v2".

### Code
*positives.py*: this code downloads all filings that include a string match in positives.txt  
*fpositivess.py*: this code downloads all filings that include a string match in fpositives.txt  
*master.py*: this code downloads all filings of each firm, if they exist.  
*merge.py*: this code performs final cleaning steps and merges positives.csv, fpositives.csv, master_v3.csv into hedgeIndicator.csv  
*text_editing.ipynb*:  
In order to circumvent the max. character count of each query specified by sec-api, false positive matches were downloaded in 3 separate queries. text_editing.ipynb splits the list of false positive query strings and formats each into non-delimited text files that can be read in as Python strings.

### Data
gvkey_list.dta: list of gvkeys used to perform searches on
fpositive_v2.csv	
master_v3.csv 
f_positive.txt		
master_v3_v2.csv
f_positive_clean.txt	
hedgeIndicator.csv	
positive.csv
f_positive_clean_1.txt	
hedgeIndicator_v2.csv	
positive.txt
f_positive_clean_2.txt	
index.csv		
positive_v2.csv
f_positive_clean_3.txt	
master.csv
updated_keys.csv
fpositive.csv		
master_v2.csv
error_CIK.csv

