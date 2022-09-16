***This file makes asset variables in Compustat data ready-to-use for do2. 

cd "C:\Users\gokce\Desktop\referee report\update paper"

clear 
*Requires running do0balancesheetdata previously.
use rawdatbalancexx

destring, replace
compress
sort gvkey

sort gvkey ddate
keep gvkey ddate atq
gen ddatecop=ddate
gen atqcop=atq

xtset gvkey ddate

tsfill, full
sort gvkey ddate

*Fill in observations (to be able to treat the data as monthly, necessary for merging the data later).
gen dum=.
replace dum=1 if !mi(ddatecop)
foreach var of varlist atq {
replace `var'=`var'[_n-1] if dum[_n-1]==1 & gvkey==gvkey[_n-1] & mi(ddatecop) & mi(`var')
replace `var'=`var'[_n-2] if dum[_n-2]==1 & gvkey==gvkey[_n-2] & mi(ddatecop) & mi(`var')
}

drop dum ddatecop atqcop

save assettomatch.dta, replace
