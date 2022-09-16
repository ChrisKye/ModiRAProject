 ***This file finalizes the data set for all stock return regressions.

clear
clear matrix

capture log close

cd "C:\Users\gokce\Desktop\referee report\update paper"

clear
clear all

use tightdatfinalwithpathhedgefomc

***

*Balance sheet variables, one quarter lagged. We use these in regressions.
gen sizelag=log(atq_deflag)
gen booklevlag=(dlcqlag+dlttqlag)/(dlcqlag+dlttqlag+ceqqlag)
gen profitabilitylag=oibdpqlag/atqlag
gen markettobooklag=((prccqlag*cshoqlag)+(dlttqlag+dlcqlag))/atqlag
*cash to assets ratio (financial slacks in the paper)
gen cashtoaslag=cheqlag/atqlag
*retained earnings to assets
gen reqtoaslag=reqlag/atqlag
gen divpersharelag=dvpspqlag
*asset maturity
gen assetmat=((ppegtqlag/atqlag)*(ppegtqlag/dpqlag))+((actqlag/atqlag)*(actqlag/cogsqlag)) 
*rescale asset mat
replace assetmat=assetmat/100

*Generate zlb dummy.
gen zlbdummy=0
replace zlbdummy=1 if ddate>=tm(2009,1) & ddate<=tm(2015,12)

*Stock returns in percentages.
replace percprccd=percprccd*100
replace twodaypercprccd=twodaypercprccd*100
replace famadjret=famadjret*100

*S&P credit ratings
encode spcsrc, gen(sprating)

rename hedge2lag hedgeindlag
rename hedge2lag15 hedgeindlag15

save handson2hedge2.dta, replace

*** Full sample 

clear
clear all
use handson2hedge2

drop if varlevorlag<0.01 & hedgeindlag==1
drop if 6000<=siclag & siclag<=6799
*drop if 4900<=siclag & siclag<=4949 // Drops utility additionally.

*Trim the rhs variables.
foreach var of varlist varlevorlag matvarasslag newbankratiolag  assetmat reqtoaslag divpersharelag cashtoaslag markettobooklag profitabilitylag booklevlag sizelag matallassknowlag matallasslag avrmatlag  matfixasslag {
foreach obs of numlist 1/127{
local ob = `obs'
pctrim `var' if numstock==`ob', p(1 99) gen(tr_) recode(miss)

qui replace `var'=tr_`var' if numstock==`ob'
drop tr_`var'
}
}

*Restrict to our sample period of 2004-2018.
keep if ddate>=tm(2004,1) & ddate<tm(2019,1)

save baselinezlb.dta, replace

/*
*The below are for robustness data sets.
save longerpathzlb.dta, replace 
save onlybankzlb.dta, replace 
save trunczlb.dta, replace 
save placebozlb.dta, replace 
save baselineWEzlb, replace
save baselineresiduals.dta, replace
*/

*** Pre-ZLB sample 

clear all
use handson2hedge2

keep if ddate>=tm(2004,1) & ddate<tm(2009,1)
drop if varlevorlag<0.01 & hedgeindlag==1

*Drop financials.
drop if 6000<=siclag & siclag<=6799
*drop if 4900<=siclag & siclag<=4949

foreach var of varlist varlevorlag matvarasslag newbankratiolag  assetmat cashtoaslag reqtoaslag divpersharelag markettobooklag profitabilitylag booklevlag sizelag  {
foreach obs of numlist 1/47{
local ob = `obs'
pctrim `var' if  numstock==`ob', p(1 99) gen(tr_) recode(miss)

qui replace `var'=tr_`var' if numstock==`ob'
drop tr_`var'
}
}

save baselineprezlb.dta, replace

/*
For robustness checks.
save placeboprezlb.dta, replace
*/

*** Ippolito et al. replication sample

*Note: This one should use annual hedging indicator.

clear all
use handson2hedge2

keep if ddate>=tm(2004,1) & ddate<tm(2009,1)
*Drop financials &utilities.
drop if 6000<=siclag & siclag<=6799
drop if 4900<=siclag & siclag<=4949

drop if varlevorlag<0.01 & hedgeindlag==1

foreach var of varlist varlevorlag matvarasslag newbankratiolag markettobooklag profitabilitylag booklevlag sizelag assetmat{
foreach obs of numlist 1/47{
local ob = `obs'
winsor2 `var' if numstock==`ob', cuts(1 99)
qui replace `var'=`var'_w if numstock==`ob'
drop `var'_w 
}
}

save pprepdata.dta, replace
