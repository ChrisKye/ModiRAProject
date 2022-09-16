***This file prepares quarterly firm data for balance sheet regressions.

cd "C:\Users\gokce\Desktop\referee report\update paper"

clear
clear all

*Don't stop when the screen fills up while running the code.
set more off

use rawdatbalancexx

gen fiscalmonth=month(dofm(ddate))

*As Ippolito et al. do, we work with 3,6,9,12 (the majority of all firms).
keep if fiscalmonth==3 | fiscalmonth==6 | fiscalmonth==9 | fiscalmonth==12

*Merge CIQ data and Compustat data.
*This is not organized according to the FOMC meeting dates; it matches balance sheet periods instead.
sort gvkey ddate

foreach var of varlist atq xsgaq saleq cogsq dpq xintq niq cheq {
by gvkey (ddate): gen `var'lag=`var'[_n-1] 
}

gen ebitda=saleqlag-xsgaqlag-cogsqlag
gen ebit=ebitda-dpqlag
 
*Financial constraint index.
gen sizefcplag=log(atqlag)
gen fcpindex=-0.123*sizefcplag-0.024*(ebit/xintqlag)-4.404*(niqlag/atqlag)-1.716*(cheqlag/atqlag)

foreach var of varlist fcpindex {
by gvkey (ddate): gen `var'lag=`var'[_n-1] 
}

foreach var of varlist atq fcpindex {
by gvkey (ddate): gen `var'twolag=`var'[_n-2] 
}

foreach var of varlist atq fcpindex {
by gvkey (ddate): gen `var'threelag=`var'[_n-3] 
}

foreach var of varlist atq fcpindex {
by gvkey (ddate): gen `var'fourlag=`var'[_n-4] 
}

gen laggedaveragefcp=(fcpindexlag+fcpindextwolag+fcpindexthreelag+fcpindexfourlag)/4

merge 1:1 gvkey ddate using datmatmergedhedgecheck

drop if _merge==1
drop _merge
drop if mi(fiscalmonth)
order gvkey ddate
sort gvkey ddate

*The main data set we use for the balance sheet regressions.
save quarterlyfirmlevel.dta, replace
