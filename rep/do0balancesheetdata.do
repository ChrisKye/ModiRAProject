***This file prepares Compustat data.

cd "C:\Users\gokce\Desktop\referee report\update paper"
capture log close

clear
clear matrix

*Include time stamp in the results log file.
display "$S_DATE $S_TIME"

*Memory management.
set mem 1200m
set matsize 1000

*Don't stop when the screen fills up while running the code.
set more off

clear 
clear all

/*
*Clean Compustat data.

use compustat932018

*Drop unnecessary variables (footnotes and date codes).
drop acchgq_dc-xsgay_dc acchgq_fn-xsgay_fn1

*Reduce the size of the file.
compress

*Generate date variables. "datadate" in Compustat data is the balance sheet period.
rename datadate datest
gen dailydate=mdy(month(datest),day(datest),year(datest)) 
format dailydate %d
gen ddate=ym(year(datest), month(datest))
format ddate %tm

destring, replace
save compu932018compr, replace
*/

*Downloaded from WRDS.
use "C:\Users\gokce\Desktop\referee report\update paper\compu932018compr.dta", clear

*Merge with our S&P500 firm list.
merge m:1 gvkey using spdates
keep if _merge==3
drop _merge

*There are cases where a firm has more than one observation for a given date (which is due to the change of fiscal year-end).
quietly by gvkey ddate, sort:  gen dup=cond(_N==1,0,_n)
tabulate dup

*We keep observations for which "datacqtr" is not null.
gen dumcqrtr=1 if !mi(datacqtr)
quietly by gvkey ddate, sort:  egen xx=mean(dumcqrtr)
*xx is 1 for the entries whose datacqtr is null and missing otherwise.
drop if mi(datacqtr) & dup>=1 & xx==1
drop dup
*Check the remaining entries for duplicates.
quietly by gvkey ddate, sort:  gen dup=cond(_N==1,0,_n)
tabulate dup

/*
*A routine that checks whether all remaining entries are the same:

foreach var of varlist apq-xiy {
by gvkey ddate: egen float `var'_mean=mean(`var') if dup>=1
}

foreach var of varlist apq-xiy {
gen int `var'_diff=`var'_mean-`var' if dup>=1
}

*Check whether the differences are zeros.
su apq_diff-xiy_diff
drop apq_diff-xiy_diff apq_mean-xiy_mean
*/

drop if dup>1
drop dup
drop xx dumcqrtr

*Due to the data extension during the revision, 2018 is treated separately.
drop if datest>=td(1,1,2018)
 
*Add 2018 data.
sort gvkey ddate
append using newcompustat2018xx.dta, force

save rawdatbalancexx.dta, replace
