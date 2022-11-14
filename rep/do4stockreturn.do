 ***This file reads CRSP-Compustat data and merges it with what we produce in do3. 

cd "C:\Users\gokce\Desktop\referee report\update paper"
capture log close

clear
clear matrix

*Memory management.
set mem 1000m
set matsize 500

*Don't stop when the screen fills up while running the code.
set more off

clear
clear all
use datstockwithpathnew

*Calculate "age" variable in years by deducting IPO date from data date.
gen year=year(datest)
gen ipoyear=year(ipodate)
gen age=year-ipoyear
replace age=. if age<0

*Drop irrelevant observations to reduce the size.
drop if ddate<tm(2004,1)

*Check whether there are duplicates.
sort gvkey datedaily
quietly by gvkey datedaily:  gen dup=cond(_N==1,0,_n)
tabulate dup
*Only primary issue stock prices, which are identified by linkprim = P or C, are kept.
by gvkey datedaily, sort: drop if linkprim!="P" & linkprim!="C" & dup>=1 
drop dup

*Calculate stock returns.

*One-day window:
gen percprccd=.
bysort gvkey (datedaily): replace percprccd=(prccd/prccd[_n-1])-1

*Two-day window:
gen twodaypercprccd=.
bysort gvkey (datedaily): replace twodaypercprccd=(prccd[_n+1]/prccd[_n-1])-1

/*
*For falsification tests, close above and open this:
gen twodaypercprccd=.
bysort gvkey (datedaily): replace twodaypercprccd=(prccd[_n-8]/prccd[_n-6])-1
*/

*One-day window using the second day:
gen percprccdipp=.
bysort gvkey (datedaily): replace percprccdipp=(prccd[_n+1]/prccd[_n])-1
  
sort gvkey datedaily 
save datstockwithpath.dta, replace

***

drop if ddate<tm(2004,1)
drop if ddate>=tm(2019,1)

*Merge with Fama-French regression coefficients.
merge m:1 gvkey using coefficients
drop _merge
save tightmergeddatawithpath.dta, replace

*Merge with daily Fama-French factors.
sort gvkey datedaily
merge m:1 datedaily using famafrench, force
drop _merge

*Construct Fama-French adjusted stock returns.
bysort gvkey (datedaily): gen abnormaldayone=percprccd-(rf+_b_cons+(_b_mktrf*mktrf)+(_b_smb*smb)+(_b_hml*hml))
bysort gvkey (datedaily): gen abnormaldaytwo=percprccdipp-(rf[_n+1]+_b_cons+(_b_mktrf*mktrf[_n+1])+(_b_smb*smb[_n+1])+(_b_hml*hml[_n+1]))

gen famadjret=abnormaldayone+abnormaldaytwo

save tightmergeddatawithpath.dta, replace

***

*Merge with monetary policy surprises data.
merge m:1 datedaily using datsurprisewithpath
keep if _merge==3
drop _merge

save tightmergeddatawithpath.dta, replace

***

*Now, we merge stock returns with balance sheet information.
*These are pre-processed (see do0 to do3) to be compatible with FOMC announcement dates.

clear
clear all
use tightmergeddatawithpath

merge 1:1 gvkey datedaily using datbalancemergedhedgefomc, force
drop if _merge==1
drop if _merge==2
drop _merge

order gvkey ddate datedaily
sort gvkey ddate datedaily
drop if ddate<tm(2004,1)
drop if ddate>=tm(2019,1)

*Assign integers to dates.
egen numstock=group(datedaily)
sort gvkey ddate
order gvkey ddate datedaily numstock

*Define as panel data.
xtset gvkey numstock
sort gvkey numstock 

*Reorder variables.
order gvkey ddate  numstock datest transfact1 transfact2 percprccd twodaypercprccd
sort gvkey numstock

*Final data set.
save tightdatfinalwithpathhedgefomc, replace
