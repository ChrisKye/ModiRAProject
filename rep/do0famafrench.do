***This file produces regression coefficients used for calculating Fama-French adjusted stock returns later.
*For the period 2004-2018, we first calculate monthly stock returns (from end-of-month prices, in log difference). 
*Then, we construct the left-hand-side variable: lhs=(monthly return – rf).
*Then, we run the following regression for each firm: regress lhs=alpha+beta1*mktrf+beta2*smb+beta3*hml+eps.
*We save alpha, beta1, beta2, beta3 for each firm.
*The Fama-French adjusted stock returns are computed using these in do4.

cd "C:\Users\gokce\Desktop\referee report\update paper"

*Import monthly Fama-French data.
*Downloaded from Kenneth French's website.
clear
import delimited "C:\Users\gokce\Desktop\referee report\update paper\veri\famafrenchmonthly.CSV", delimiter(comma) varnames(1) 

rename date datest

tostring datest, replace
destring  mktrf smb hml rf, replace

*Construct the date variable.
gen year=regexs(0) if(regexm(datest,"[0-9][0-9][0-9][0-9]"))
gen month=regexs(0) if(regexm(datest,"[0-9][0-9]$"))
destring, replace
gen ddate=ym(year,month)
format ddate %tm
*Declare this as time series.
tsset ddate
*Save in Stata format.
drop if ddate>=ym(2019,1)
save famafrenchmonthly.dta, replace

***

clear
clear all
*Use stock price data.
use datstockwithpathnew

*Check whether there are duplicates.
sort gvkey datedaily
quietly by gvkey datedaily: gen dup=cond(_N==1,0,_n)
tabulate dup
*Only primary issue stock prices, which are identified by linkprim = P or C, are kept.
by gvkey datedaily, sort: drop if linkprim!="P" & linkprim!="C" & dup>=1 
drop dup
save stockone.dta, replace 

sort gvkey datedaily
*"ddate" shows month, "datedaily" shows day and month. Generate a variable that counts days in months.
bysort gvkey ddate (datedaily): gen mmday=_n
*Gives the last day of the month.
bysort gvkey ddate (datedaily): egen mmlastday=max(mmday)
*Keep only the last days.
bysort gvkey ddate (datedaily): keep if mmlastday==mmday

*Log of stock prices.
gen logperc=log(prccd)

*Monthly stock return.
gen mmprccd=.
bysort gvkey (datedaily): replace mmprccd=logperc-logperc[_n-1]

*Now, merge these with monthly Fama-French factors.
sort gvkey ddate
merge m:1 ddate using famafrenchmonthly, force
keep if _merge==3
drop _merge
*Generate the left-hand-side variable as monthly_stock_return - monthly_risk_free_return.
gen lhs=mmprccd-rf
save forfam.dta, replace

clear
clear all
use forfam
*Run simple OLS of lhs on three Fama-French factors.
*Make sure that the time period is 2004-2018.
keep if ddate>=tm(2004,1) & ddate<tm(2019,1)
statsby, by(gvkey) verbose clear: reg lhs mktrf smb hml
*Save the coefficients for each firm.
save coefficients.dta, replace

*beta coefficients: _b_mktrf _b_smb _b_hml.

***

clear
*Here, we import daily Fama-French factors and save.
import excel "C:\Users\gokce\Desktop\referee report\update paper\veri\FFactors_daily.xlsx", sheet("F-F_Research_Data_Factors_daily") firstrow
tostring date, replace
gen datedaily=date(date, "YMD")
format datedaily %d
destring, replace
compress
tsset datedaily
*Two-day window excess return.
gen twowinmkt=(mktrf+mktrf[_n+1])
save famafrench.dta, replace
