***This file imports and merges firm-level stock prices.
*This version uses CRSP-Compustat merged database.
*These are divided into smaller batches, processed individually, and put together.

cd "C:\Users\gokce\Desktop\referee report\update paper"

clear
clear all

use "C:\Users\gokce\Desktop\TEZ\REFET TEZ\final900\hedge - ippolito\20012004ccm.dta", clear

rename datadate datest
destring gvkey, replace
compress

*Generate date variables.
gen datedaily=mdy(month(datest),day(datest),year(datest)) 
format datedaily %d
gen ddate=ym(year(datest), month(datest))
format ddate %tm

*Keep only S&P500 firms (requires "spdates" from do0spdates)
merge m:1 gvkey using spdates, force
keep if _merge==3
drop _merge
sort gvkey datedaily
save datstockwithpathone.dta, replace

clear
clear all

use "C:\Users\gokce\Desktop\TEZ\REFET TEZ\final900\hedge - ippolito\20052008ccm.dta", clear

rename datadate datest
destring gvkey, replace
compress

gen datedaily=mdy(month(datest),day(datest),year(datest)) 
format datedaily %d
gen ddate=ym(year(datest), month(datest))
format ddate %tm

merge m:1 gvkey using spdates, force
keep if _merge==3
drop _merge
sort gvkey datedaily
save datstockwithpathtwo.dta, replace

clear
clear all

use "C:\Users\gokce\Desktop\TEZ\REFET TEZ\final900\hedge - ippolito\20092012ccm.dta", clear

rename datadate datest
destring gvkey, replace
compress

gen datedaily=mdy(month(datest),day(datest),year(datest)) 
format datedaily %d
gen ddate=ym(year(datest),month(datest))
format ddate %tm

merge m:1 gvkey using spdates, force
keep if _merge==3
drop _merge
sort gvkey datedaily
save datstockwithpaththr.dta, replace

clear
clear all

use "C:\Users\gokce\Desktop\TEZ\REFET TEZ\final900\hedge - ippolito\20132017ccm.dta", clear

rename datadate datest
destring gvkey, replace
compress

gen datedaily=mdy(month(datest),day(datest),year(datest)) 
format datedaily %d
gen ddate=ym(year(datest),month(datest))
format ddate %tm

merge m:1 gvkey using spdates, force
keep if _merge==3
drop _merge
sort gvkey datedaily
save datstockwithpathfour.dta, replace

*2018 data were added later to complete the revision (2018stockdataxx; see below). 

*Combine.
clear 
clear all
use datstockwithpathone
append using datstockwithpathtwo, force
append using datstockwithpaththr, force
append using datstockwithpathfour, force
append using 2018stockdataxx, force
sort gvkey datedaily
save datstockwithpathnew.dta, replace
