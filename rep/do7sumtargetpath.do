***This file aggregates monetary policy surprises within the same quarter.

cd "C:\Users\gokce\Desktop\referee report\update paper"

clear
clear all

*Using target and path surprises, sum within each quarter.

use datsurprisewithpath
sort datedaily ddate

**** To do balance sheet regressions with residuals from mardata.dta, open this part:
*drop transfact1 transfact2
*rename targetres transfact1
*rename pathres transfact2
*drop if ddate>tm(2013,12)
*****

keep datedaily ddate transfact2 transfact1 SP500 MP1
tsset datedaily

by ddate, sort: egen sumpath=sum(transfact2)
by ddate, sort: egen sumtarget=sum(transfact1)

gen month=month(datedaily)
gen year=year(datedaily)
gen day=day(datedaily)

gen quarter=0
replace quarter=1 if month==1 | month==2 | month==3
replace quarter=2 if month==4 | month==5 | month==6
replace quarter=3 if month==7 | month==8 | month==9
replace quarter=4 if month==10 | month==11 | month==12
egen yq=group(year quarter)

*Recall that transfact1 is target transfact2 is path.
by yq, sort: egen sumdailypath=sum(transfact2)
by yq, sort: egen sumdailytarget=sum(transfact1)

keep if month==3 | month==6 | month==9 | month==12 
sort ddate

quietly by ddate: gen dup=cond(_N==1,0,_n)
tabulate dup
bysort ddate: drop if dup>1
drop dup

rename sumdailypath changeavr

rename sumdailytarget changetarg

save quarterlytargetpath.dta, replace
