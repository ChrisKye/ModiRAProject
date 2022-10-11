***This file finalizes the data set for all balance sheet regressions.

clear
clear all

cd "C:\Users\gokce\Desktop\referee report\update paper"

*First, import cpi data which is available at monthly frequency.
use cpi
sort ddate
*Merge this with quarterly balance sheet data.
merge 1:m ddate using quarterlyfirmlevel
keep if _merge==3
drop _merge

rename hedge2 hedgeind

sort gvkey ddate

*Now, we construct RHS variables that are deflated by CPI.
foreach var of varlist atq {
gen `var'_def=(`var'/cpi)
}

*For the ratios in the same period, it is okay to use undeflated variables.

*size
gen size=log(atq_def)
*book leverage
gen booklev=(dlcq+dlttq)/(dlcq+dlttq+ceqq)
*profitability
gen profitability=oibdpq/atq
*market to book ratio
gen markettobook=((prccq*cshoq)+(dlttq+dlcq))/atq
*short term liabilities over total assets
gen solfin=(dlcq)/(atq)
*cash to assets ratio
gen cashtoas=cheq/atq
*asset maturity
gen assetmat=((ppegtq/atq)*(ppegtq/dpq))+((actq/atq)*(actq/cogsq)) 
*retained earnings to assets
gen reqtoas=req/atq
*dividend payments
gen divpershare=dvpspq
*net worth=total assets-total liabilities
gen networth=atq-ltq

sort gvkey ddate

*Generate lags.
foreach var of varlist  varlevor newbankratio matvarass size-networth sic hedgeind{ 
by gvkey (ddate): gen `var'lag=`var'[_n-1] 
}

******************
*net worth
******************
bysort gvkey (ddate): gen chnetworthfix1=100*(networth[_n+1]-networth[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen chnetworthfix2=100*(networth[_n+2]-networth[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen chnetworthfix3=100*(networth[_n+3]-networth[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen chnetworthfix4=100*(networth[_n+4]-networth[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen chnetworthfix5=100*(networth[_n+5]-networth[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen chnetworthfix6=100*(networth[_n+6]-networth[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen chnetworthfix7=100*(networth[_n+7]-networth[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen chnetworthfix8=100*(networth[_n+8]-networth[_n-1])/atq[_n-1]

******************
*cash holdings
******************
*change in cash divided by the initial period total assets.
bysort gvkey (ddate): gen chcashfix1=100*(cheq[_n+1]-cheq[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen chcashfix2=100*(cheq[_n+2]-cheq[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen chcashfix3=100*(cheq[_n+3]-cheq[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen chcashfix4=100*(cheq[_n+4]-cheq[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen chcashfix5=100*(cheq[_n+5]-cheq[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen chcashfix6=100*(cheq[_n+6]-cheq[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen chcashfix7=100*(cheq[_n+7]-cheq[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen chcashfix8=100*(cheq[_n+8]-cheq[_n-1])/atq[_n-1]

************************
*capital investment
************************
bysort gvkey (ddate): gen chcapfix1=100*(ppegtq[_n+1]-ppegtq[_n-1])/atq[_n-1]  
bysort gvkey (ddate): gen chcapfix2=100*(ppegtq[_n+2]-ppegtq[_n-1])/atq[_n-1] 
bysort gvkey (ddate): gen chcapfix3=100*(ppegtq[_n+3]-ppegtq[_n-1])/atq[_n-1] 
bysort gvkey (ddate): gen chcapfix4=100*(ppegtq[_n+4]-ppegtq[_n-1])/atq[_n-1] 
bysort gvkey (ddate): gen chcapfix5=100*(ppegtq[_n+5]-ppegtq[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen chcapfix6=100*(ppegtq[_n+6]-ppegtq[_n-1])/atq[_n-1] 
bysort gvkey (ddate): gen chcapfix7=100*(ppegtq[_n+7]-ppegtq[_n-1])/atq[_n-1] 
bysort gvkey (ddate): gen chcapfix8=100*(ppegtq[_n+8]-ppegtq[_n-1])/atq[_n-1] 

******************
*total assets
******************
bysort gvkey (ddate): gen changetotass1=100*(atq[_n+1]-atq[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen changetotass2=100*(atq[_n+2]-atq[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen changetotass3=100*(atq[_n+3]-atq[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen changetotass4=100*(atq[_n+4]-atq[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen changetotass5=100*(atq[_n+5]-atq[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen changetotass6=100*(atq[_n+6]-atq[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen changetotass7=100*(atq[_n+7]-atq[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen changetotass8=100*(atq[_n+8]-atq[_n-1])/atq[_n-1]

******************
*total liabilities
******************
gen sumdebt=lcoq+dlttq
bysort gvkey (ddate): gen chsumdebtfix1=100*(sumdebt[_n+1]-sumdebt[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen chsumdebtfix2=100*(sumdebt[_n+2]-sumdebt[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen chsumdebtfix3=100*(sumdebt[_n+3]-sumdebt[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen chsumdebtfix4=100*(sumdebt[_n+4]-sumdebt[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen chsumdebtfix5=100*(sumdebt[_n+5]-sumdebt[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen chsumdebtfix6=100*(sumdebt[_n+6]-sumdebt[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen chsumdebtfix7=100*(sumdebt[_n+7]-sumdebt[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen chsumdebtfix8=100*(sumdebt[_n+8]-sumdebt[_n-1])/atq[_n-1]

******************
*inventory
******************
bysort gvkey (ddate): gen chinvfix1=100*(invtq[_n+1]-invtq[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen chinvfix2=100*(invtq[_n+2]-invtq[_n-1])/atq[_n-1] 
bysort gvkey (ddate): gen chinvfix3=100*(invtq[_n+3]-invtq[_n-1])/atq[_n-1] 
bysort gvkey (ddate): gen chinvfix4=100*(invtq[_n+4]-invtq[_n-1])/atq[_n-1] 
bysort gvkey (ddate): gen chinvfix5=100*(invtq[_n+5]-invtq[_n-1])/atq[_n-1]
bysort gvkey (ddate): gen chinvfix6=100*(invtq[_n+6]-invtq[_n-1])/atq[_n-1] 
bysort gvkey (ddate): gen chinvfix7=100*(invtq[_n+7]-invtq[_n-1])/atq[_n-1] 
bysort gvkey (ddate): gen chinvfix8=100*(invtq[_n+8]-invtq[_n-1])/atq[_n-1] 

*Save this firm-level data, which will be matched to change in interest rate.
save forfirmlevels.dta, replace

***

*Merge monetary policy surprise data and quarterly balance sheet data.
clear
clear all
use quarterlytargetpath
merge 1:m ddate using forfirmlevels, force
keep if _merge==3
drop _merge
save readyfirmlevels.dta, replace
 
clear
clear all

use readyfirmlevels
*Make sure that the sample period is between 2004 and 2014.
keep if ddate>=tm(2004,1) & ddate<tm(2019,1)
*Drop the ones with floating rate debt<0.01 and do hedging.
drop if varlevorlag<0.01 & hedgeindlag==1
*Drop financial sector.
drop if 6000<=siclag & siclag<=6799

*ZLB dummy.
gen zlbdummy=0
replace zlbdummy=1 if ddate>=tm(2009,1) & ddate<=tm(2015,12)

egen period=group(ddate)

xtset gvkey period

save basequarterly.dta,replace
