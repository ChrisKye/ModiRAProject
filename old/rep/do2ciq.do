***This file reads CIQ data, constructs our exposure measure, and merges it with our hedging data.

cd "C:\Users\gokce\Desktop\referee report\update paper"

capture log close

clear
clear matrix

*Include time stamp in the results log file.
display "$S_DATE $S_TIME"

*Memory management.
set mem 1000m
set matsize 500

*Don't stop when the screen fill up while running the code.
set more off

clear
clear all
*We downloaded the data from CIQ using our gvkey list.
use "C:\Users\gokce\Desktop\referee report\update paper\veri\ciq20032018spfirms.dta", clear

*To reduce the size of the file, use compress.
compress
*Convert variables into numerics whereever possible. 
destring, replace

merge m:1 gvkey using spdates, force
keep if _merge==3
drop _merge

*CIQ database consists of debt entries.
*We do not keep debt items that are (1) nonrecourse and (2) issued in non-dollar amounts or convertible.
drop if nonrecoursetypeid==2
drop if issuedcurrencyid!=160
drop if convertibletypeid==4

*unittypeid is used to record everthing in million dollars as in Compustat data.
*unittypeid "2" is in million dollars, "1" in thousand dollars, and "0" in dollars.
replace dataitemvalue= dataitemvalue/1000 if unittypeid==1
replace dataitemvalue= dataitemvalue/1000000 if unittypeid==0

*If we use annual exposure, 
keep if formtype=="10-K"

*If we use exposure and hedging both at quarterly frequency, 
*keep if formtype=="10-K" | formtype=="10-Q"

*Keep the latest info: 1. As First Reported, 3. Only available
keep if filingflag_company==1 | filingflag_company==3

*There are two time indictors in CIQ: filing date and period date. Period date is the fiscal period that the data belong to.
*We construct Stata date indicators for both.

*Filing date:
rename filingdate fillingdate
gen year=year(fillingdate)
gen day=day(fillingdate)
gen month=month(fillingdate)

gen ddatefil=ym(year, month)
format ddatefil %tm

*Period date:
gen yearprd=year(periodenddate)
gen dayprd=day(periodenddate)
gen monthprd=month(periodenddate)

*"ddate" is the date variable that will be merged with others.
gen ddate=ym(yearprd,monthprd)
format ddate %tm

*Conversion into real variables. This part is useful for generating summary statistics.
*Here, we merge the data with CPI.
*Notice that we merge them using "ddate."
*We deflate the data using CPI and save them for the summary tables in the appendix.
merge m:1 ddate using cpi
keep if _merge==3
drop _merge
*Deflate dataitemvalue using CPI.
gen dataitemvalue_def=(dataitemvalue/cpi)

*Drop if defaulted.
drop if maturityyearhigh==7777 

sort gvkey ddate ddatefil

*The maturity information of debt entries is in maturitylow and maturityhigh. 
*If maturitylow is missing, maturityhigh shows due date. If not missing, they give a payment interval (i.e., variable maturity).
*We need ym format to calculate maturities in months. So, generate new variables:
gen datematuritylow=ym(year(maturitylow),month(maturitylow)) if !mi(maturitylow)
gen datematurityhigh=ym(year(maturityhigh),month(maturityhigh)) 
format datematuritylow %tm
format datematurityhigh %tm

*Calculate the time left to maturitylow first. To do that, we need to use ddate.
*If variable maturity, call this leftlow.
gen leftlow=datematuritylow-ddate
*If fixed maturity (maturitylow is missing), compute the time left to maturityhigh and call it lefthigh. 
gen lefthigh=datematurityhigh-ddate if datematuritylow==.
*There are a few perpetuities, only for these gvkeys: 2698, 5786,7267, 7647, 8245, 9061, 13440, 30128 260774. Replace them with 100 years (1200 months).
replace lefthigh=1200 if maturityyearhigh==8888 
*Calculate average maturity for variable maturity. 
gen lefthighfloat=((datematurityhigh-datematuritylow)/2)+datematuritylow-ddate if !mi(datematuritylow)

*Now, create a single maturity indicator.
gen mat=lefthigh
replace mat=lefthighfloat if mi(lefthigh)

*Discretize to see the distribution of maturities. This part will be useful for generating summary tables.
gen mat1gr=0 
replace mat1gr=1 if 0<mat & mat<=12 
gen mat2gr=0 
replace mat2gr=2 if 12<mat & mat<=60
gen mat3gr=0 
replace mat3gr=3 if 60<mat & mat<=120
gen mat4gr=0
replace mat4gr=4 if 120<mat & mat<=240
gen mat5gr=0 
replace mat5gr=5 if 240<mat & mat<=360
gen mat6gr=0 
replace mat6gr=6 if 360<mat
 
gen matstr=mat1gr+mat2gr+mat3gr+mat4gr+mat5gr+mat6gr 
*If matstr is 0, the debt item has matured.

label define matx 0 "Due date passed" 1 "0-1 year" 2 "1-5 year" 3 "5-10 year"  4  "10-20 year" 5 "20-30 year" 6 "more than 30 years" 
label values matstr matx

*Maturity is calculated in months.
*Convert them into years.
replace mat=mat/12

*Drop negatives (happens very rarely).
drop if mat<=0
drop if dataitemvalue<=0

******Truncate maturity********
*As a robustness check, construct data with debt items that have less than five years until maturity.
*replace mat=. if mat>=5 & interestratetypeid==2
*replace dataitemvalue=. if mat>=5 & interestratetypeid==2
*******************************

*This dummy helps identifying bank debt which is defined as revolving credit or term loans.
gen newbankdummy=0
replace newbankdummy=1 if capitalstructuresubtypeid==2 | capitalstructuresubtypeid==3

*Label interest rate and debt types.
label define intx  1 "NA" 2 "Variable" 3 "Fixed"  4  "Zero Coupon"
label values interestratetypeid intx

*Debt types are given by decsriotiontext.
egen debttype= group(descriptiontext)

label define debtx 1 "Bank Loans" 2 "Bank overdraft" 3 " Bank overdraft facility" 4 "Bills Payable Facility" 5 " Bills payable" 6 "Bonds and notes" 7 "Capital leases" 8 "Commercial paper" 9 "Commercial paper facility" 10 "Debentures" 11 "Fed Borrowings " 12 " FHLB Facility " 13 " FHLB borrowings" 14 "Federal Funds Facility" 15 "Federal Funds Purchased" 16 "Federal Reserve Facility" 17 "General borrowings" 18 "Letter of Credit Facility" 19 "Letter of Credit Outstanding" 20 " Mortgage bonds" 21 "Mortgage loans" 22 "Mortgage notes" 23 "Notes Payable Facility" 24 "Notes payable" 25 "Other borrowings" 26 "Revolving credit" 27 "Revolving credit facility" 28 "Securities loaned" 29 "Securities sold under repu" 30 "Securitization facility" 31 "Term loan" 32 "Term loan facility" 33 "Trust Preferred Securities" 34 "Unamortized Discount: Mortgage Notes"
label values debttype debtx

save datmatwegbase.dta, replace

sort gvkey fillingdate periodenddate ddate

*Fixed interest rate debt.
gen fixed=1 if interestratetypeid==3
*Variable interest rate debt.
gen variable=1 if interestratetypeid==2

*Detect variable and fixed rate debt items.
by gvkey fillingdate periodenddate variable, sort: gen itemvar=_n if !mi(variable)
by gvkey fillingdate periodenddate fixed, sort: gen itemfixed=_n if !mi(fixed)

******Construct exposure using only bank debt*********
*As a robustness check, construct data set onfly from bank debt open here.
*replace mat=. if newbankdummy==0
******************************************************

*Leverage variables.
*Total floating debt.
by gvkey fillingdate periodenddate variable, sort: egen totalvardebt=sum(dataitemvalue) if !mi(variable)
by gvkey fillingdate periodenddate, sort: egen vardebt=mean(totalvardebt) 
*Total bank debt.
by gvkey fillingdate periodenddate, sort: egen newbankdebt=sum(dataitemvalue) if newbankdummy==1
by gvkey fillingdate periodenddate, sort: egen newbank=mean(newbankdebt)


*** Exposure construction begins ***


*Total assets information is not available in CIQ.
*We take this from quarterly Compustat data and merge it with CIQ data to calculate debt/total_asset weighted maturity.
merge m:1 gvkey ddate using assettomatch, force
keep if _merge==3
drop _merge
*Rename total assets.
rename atq atqmat

*If we believe that firms with zero floating rate debt are indeed pure fixed rate debt issuers, for those firms `egpf` is 1. Doing so does not change the results.
*gen purefixed=0
*replace purefixed=1 if interestratetypeid==3
*by gvkey fillingdate periodenddate, sort: egen egpf=mean(purefixed)

*Compute debt/total_asset weighted maturity for variable debt.
gen weightvarasset=dataitemvalue/atqmat 
gen mattimeswegvarasset=mat*weightvarasset
by gvkey fillingdate periodenddate variable, sort: egen weightedmatvarasset=sum(mattimeswegvarasset) if !mi(mattimeswegvarasset)
*Return as missing if there is no floating rate debt.
replace weightedmatvarasset=. if itemvar==.

*"matvarass" is our exposure variable.
by gvkey fillingdate periodenddate, sort: egen matvarass=mean(weightedmatvarasset)

*Again, if we believe that firms with zero floating rate debt are pure fixed rate debt issures,
*replace matvarass=0 if egpf==1 &mi(matvarass)


*** Exposure construction ends ***


*For robustness checks, we calculate various maturity measures. 

*Simple average maturity for all types of debts.
by gvkey fillingdate periodenddate, sort: egen averagemat=mean(mat) 
by gvkey fillingdate periodenddate, sort: egen avrmat=mean(averagemat)

**Weighted maturity of debt items whose types are known, with dummies for fixed or variable rate debt.
gen known=0
replace known=1 if fixed==1 | variable==1
by gvkey fillingdate periodenddate, sort: egen weightedmatassetkn=sum(mattimeswegvarasset) if !mi(mattimeswegvarasset) & known==1
by gvkey fillingdate periodenddate, sort: egen matallassknow=mean(weightedmatassetkn)

*Weighted maturity for all types of debt.
by gvkey fillingdate periodenddate, sort: egen weightedmatasset=sum(mattimeswegvarasset) if !mi(mattimeswegvarasset)
by gvkey fillingdate periodenddate, sort: egen matallass=mean(weightedmatasset)

*Fixed rate exposure. 
by gvkey fillingdate periodenddate fixed, sort: egen weightedmatfixasset=sum(mattimesweg) if !mi(mattimesweg)
replace weightedmatfixasset=. if itemfixed==.
by gvkey fillingdate periodenddate, sort: egen matfixass=mean(weightedmatfixasset)

*If we believe that firms with zero floating rate debt are pure fixed rate debt isuers, set leverages to 0.
*replace vardebt=0 if mi(vardebt) & egpf==1
*replace newbank=0 if mi(newbank) & egpf==1

sort gvkey ddate ddatefil 

save datmatwegbase.dta, replace


***


*To make this compatible with the rest of the data set, we need a single value for each quarter.
sort gvkey fillingdate periodenddate
quietly by gvkey periodenddate fillingdate, sort:  gen dup=cond(_N==1,0,_n)

*Since we have generated all variables of interest using egen, we can reduce the number of observations for each balance sheet date to one.
bysort gvkey fillingdate periodenddate: drop if dup>1
drop dup

*Bank debt leverage. This is our main floating rate leverage variable.
gen newbankratio=newbank/atqmat
*Variable debt leverage (also referred to as floating rate debt leverage).
gen varlevor=vardebt/atqmat


*** Duplicate checks

* We first check by ddatefil, and then by ddate, and then using daily frequency information.

*Check if firms file more than one 10-K or 10-Q forms for a given filing period.
quietly by gvkey ddatefil, sort :  gen dup=cond(_N==1,0,_n)
tab dup
drop dup
gen diffx=ddatefil-ddate
*If you tab diffx, you can see that for the vast majority of firms this is <= 3 months.
*We make sure that we get the most recent information:
by gvkey ddatefil, sort: egen closestx=min(diffx)
by gvkey ddatefil, sort: keep if diffx==closestx
drop diffx closestx

sort gvkey ddate ddatefil
*Now check whether there are duplicates for the same period.
quietly by gvkey ddate, sort: gen dup=cond(_N==1,0,_n)
tabulate dup
gen diffxx=ddatefil-ddate
by gvkey ddate, sort: egen closestxx=min(diffxx)
by gvkey ddate, sort: keep if diffxx==closestxx
drop dup diffxx closestxx

sort gvkey ddate ddatefil
quietly by gvkey ddate ddatefil, sort: gen dup=cond(_N==1,0,_n)
tabulate dup
gen diffxy=fillingdate-periodenddate 
by gvkey ddate, sort: egen closestxy=min(diffxy)
by gvkey ddate, sort: keep if diffxy==closestxy
drop dup diffxy closestxy

*Now, we have a panel data set.
save datmatwegannual.dta, replace


***


*Next, merge CIQ data with hedging data.

clear
clear all
*Hedging data is included as part of the replication package. 
import excel "C:\Users\gokce\Desktop\referee report\update paper\veri\hedgedata.xls", sheet("Sheet1") firstrow

drop if filingdate<td(1,1,2003)

*Fist check for duplicates by filingtype.
*We checked manually that hedging information is the same across these duplicates.
by gvkey filingdate filingtype, sort: gen dup=cond(_N==1,0,_n)
by gvkey filingdate filingtype, sort: egen lastob=max(dup)
by gvkey filingdate filingtype, sort: keep if dup==lastob
drop dup lastob

*Now check if there are duplicates for a given filing date.
by gvkey filingdate, sort: gen dup=cond(_N==1,0,_n)
*Now keep 10-Ks (these are cases when 10-qs and 10-ks are filed on the same date).
drop if dup>=1 & filingtype!="10-K"

*Rename filingdate to make it compatible with CIQ data.
gen month=month(filingdate)
gen year=year(filingdate)
gen ddatefil=ym(year,month)
format ddatefil %tm
sort gvkey ddatefil
drop year month dup

destring, replace
sort gvkey ddatefil 
*There are cases where a firm filed more than one report of the same type within the same month.
by gvkey ddatefil, sort: gen dup=cond(_N==1,0,_n)
*Check their types and keep the latest ones.
by gvkey ddatefil filingtype, sort: egen lastob=max(filingdate)
by gvkey ddatefil filingtype, sort: keep if lastob==filingdate
drop lastob dup

sort gvkey ddatefil
*There are still duplicates. These are the cases where a firm filed 10-Qs and 10-Ks on different days within the same month.
by gvkey ddatefil, sort: gen dup=cond(_N==1,0,_n)
drop if dup>=1 & filingtype!="10-K"
drop dup 
save webhedgedatatouse12set, replace

/*
*If using annual hedging indicator instead, 
clear
clear all
use hedge2017
rename hedging hedgeind
drop if filingdate<td(1,1,2003)

*Again, check for duplicates. 
by gvkey filingdate, sort: gen dup=cond(_N==1,0,_n)
drop if dup>1
drop dup

*Rename filingdate.
gen month=month(filingdate)
gen year=year(filingdate)
gen ddatefil=ym(year,month)
format ddatefil %tm
sort gvkey ddatefil
destring, replace
sort cik ddatefil 

drop year month

save webhedgedatatouse12set, replace
*/

*Merging CIQ and hedging data.
clear
clear all
use datmatwegannual
sort gvkey ddate ddatefil 
*In hedging data set, we do not have balance sheet period date. That's why we are merging using ddatefil.
merge 1:1 gvkey ddatefil using webhedgedatatouse12set
drop if _merge==1
*We want to keep both 10-Q and 10-K info, thats why we keep _merge==2 & _merge==3.

drop _merge

*Generate ddatexx.
gen matvarxx=matvarass
gen ddatexx=ddate
format ddatexx %tm
sort gvkey ddatefil ddate ddatexx

*Fill in ddatexx.
foreach var of varlist ddatexx {
replace `var'=`var'[_n-1]+3 if gvkey==gvkey[_n-1] & mi(ddate) & mi(`var')
}

drop if mi(ddatexx)

save datmatmergedhedge.dta, replace


***


*Converting the data to be monthly for merging with moneatary policy data later.

clear
use datmatmergedhedge
sort gvkey ddate ddatexx ddatefil fillingdate

*Diagnostics.
quietly by gvkey ddatexx, sort: gen dup=cond(_N==1,0,_n)
tab dup
drop if mi(ddate) & dup>=1
drop dup
 
quietly by gvkey ddatexx, sort: gen dup=cond(_N==1,0,_n)
tab dup
drop dup

gen ddatecontrol=ddate
rename ddate ddateold
rename ddatexx ddate

format ddatecontrol %tm

*Define gvkey as the panel firm identifier and ddate as the time identifier.
xtset gvkey ddate

*Our time convention is monthly. Since CIQ is yearly and Compustat is quarterly, we will use tsfill for merging.
tsfill, full

sort gvkey ddate ddatefil

*Now, replace missing observations for the following months, until the next balance sheet information becomes available. 
*We do this for all variables.

*Baseline with annual exposure and quarterly hedging:
gen matvarcop=matvarass
gen vardebtcop=vardebt
gen hedge2cop=hedge2
gen dum=.
replace dum=1 if !mi(ddateold)
sort gvkey ddate ddatefil  

foreach var of varlist leftlow-varlevor {
by gvkey (ddate), sort: replace `var'=`var'[_n-1] if  gvkey==gvkey[_n-1] & mi(`var') & mi(ddateold) & dum[_n-1]==1
by gvkey (ddate), sort: replace `var'=`var'[_n-2] if  gvkey==gvkey[_n-2] & mi(`var') & mi(ddateold) & dum[_n-2]==1
by gvkey (ddate), sort: replace `var'=`var'[_n-3] if  gvkey==gvkey[_n-3] & mi(`var') & mi(ddateold) & dum[_n-3]==1
by gvkey (ddate), sort: replace `var'=`var'[_n-4] if  gvkey==gvkey[_n-4] & mi(`var') & mi(ddateold) & dum[_n-4]==1
by gvkey (ddate), sort: replace `var'=`var'[_n-5] if  gvkey==gvkey[_n-5] & mi(`var') & mi(ddateold) & dum[_n-5]==1
by gvkey (ddate), sort: replace `var'=`var'[_n-6] if  gvkey==gvkey[_n-6] & mi(`var') & mi(ddateold) & dum[_n-6]==1
by gvkey (ddate), sort: replace `var'=`var'[_n-7] if  gvkey==gvkey[_n-7] & mi(`var') & mi(ddateold) & dum[_n-7]==1
by gvkey (ddate), sort: replace `var'=`var'[_n-8] if  gvkey==gvkey[_n-8] & mi(`var') & mi(ddateold) & dum[_n-8]==1
by gvkey (ddate), sort: replace `var'=`var'[_n-9] if  gvkey==gvkey[_n-9] & mi(`var') & mi(ddateold) & dum[_n-9]==1
by gvkey (ddate), sort: replace `var'=`var'[_n-10] if gvkey==gvkey[_n-10] & mi(`var') & mi(ddateold) & dum[_n-10]==1
by gvkey (ddate), sort: replace `var'=`var'[_n-11] if gvkey==gvkey[_n-11] & mi(`var') & mi(ddateold) & dum[_n-11]==1
}

drop dum

*For hedging data, this must be done using ddatefil.
gen dum=.
replace dum=1 if !mi(ddatefil)
sort gvkey ddate ddatefil  

foreach var of varlist hedge1 hedge2 hedge3 {
by gvkey (ddate), sort: replace `var'=`var'[_n-1] if  gvkey==gvkey[_n-1] & mi(`var') & mi(ddateold) & mi(ddatefil) & dum[_n-1]==1
by gvkey (ddate), sort: replace `var'=`var'[_n-2] if  gvkey==gvkey[_n-2] & mi(`var') & mi(ddateold) & mi(ddatefil) & dum[_n-2]==1
}

drop dum 

/*
*If using quarterly exposure and quarterly hedging,

gen matvarcop=matvarass
gen vardebtcop=vardebt
gen hedge2cop=hedge2
gen dum=.
replace dum=1 if !mi(periodenddate)
sort gvkey ddatefil ddate 

foreach var of varlist  leftlow-varlevor{
by gvkey (ddate), sort: replace `var'=`var'[_n-1] if  gvkey==gvkey[_n-1] & mi(`var') & mi(periodenddate) & dum[_n-1]==1
by gvkey (ddate), sort: replace `var'=`var'[_n-2] if  gvkey==gvkey[_n-2] & mi(`var') & mi(periodenddate) & dum[_n-2]==1
}

drop dum

gen dum=.
replace dum=1 if !mi(ddatefil)
sort gvkey ddatefil ddate 

foreach var of varlist hedge1 hedge2 hedge3 {
by gvkey (ddate), sort: replace `var'=`var'[_n-1] if  gvkey==gvkey[_n-1] & mi(`var') & mi(ddateold) & mi(ddatefil) & dum[_n-1]==1
by gvkey (ddate), sort: replace `var'=`var'[_n-2] if  gvkey==gvkey[_n-2] & mi(`var') & mi(ddateold) & mi(ddatefil) & dum[_n-2]==1
}
*/

*If using annual exposure and annual hedging,
/*
sort gvkey ddate ddatefil
gen dum=.
replace dum=1 if !mi(ddatefil)

gen hedgeindcop=hedgeind
rename filingdate filingtime

foreach var of varlist cik file hedgeind {
replace `var'=`var'[_n-1] if dum[_n-1]==1 & gvkey==gvkey[_n-1] & mi(filingtime) & mi(`var')
replace `var'=`var'[_n-2] if dum[_n-2]==1 & gvkey==gvkey[_n-2] & mi(filingtime) & mi(`var')
replace `var'=`var'[_n-3] if dum[_n-3]==1 & gvkey==gvkey[_n-3] & mi(filingtime) & mi(`var')
replace `var'=`var'[_n-4] if dum[_n-4]==1 & gvkey==gvkey[_n-4] & mi(filingtime) & mi(`var')
replace `var'=`var'[_n-5] if dum[_n-5]==1 & gvkey==gvkey[_n-5] & mi(filingtime) & mi(`var')
replace `var'=`var'[_n-6] if dum[_n-6]==1 & gvkey==gvkey[_n-6] & mi(filingtime) & mi(`var')
replace `var'=`var'[_n-7] if dum[_n-7]==1 & gvkey==gvkey[_n-7] & mi(filingtime) & mi(`var')
replace `var'=`var'[_n-8] if dum[_n-8]==1 & gvkey==gvkey[_n-8] & mi(filingtime) & mi(`var')
replace `var'=`var'[_n-9] if dum[_n-9]==1 & gvkey==gvkey[_n-9] & mi(filingtime) & mi(`var')
replace `var'=`var'[_n-10] if dum[_n-10]==1 & gvkey==gvkey[_n-10] & mi(filingtime) & mi(`var')
replace `var'=`var'[_n-11] if dum[_n-11]==1 & gvkey==gvkey[_n-11] & mi(filingtime) & mi(`var')
}

gen matvarcop=matvarass
gen vardebtcop=vardebt

foreach var of varlist leftlow-varlevor {
replace `var'=`var'[_n-1] if dum[_n-1]==1 & gvkey==gvkey[_n-1] & mi(ddatefil) & mi(`var')
replace `var'=`var'[_n-2] if dum[_n-2]==1 & gvkey==gvkey[_n-2] & mi(ddatefil) & mi(`var')
replace `var'=`var'[_n-3] if dum[_n-3]==1 & gvkey==gvkey[_n-3] & mi(ddatefil) & mi(`var') 
replace `var'=`var'[_n-4] if dum[_n-4]==1 & gvkey==gvkey[_n-4] & mi(ddatefil) & mi(`var') 
replace `var'=`var'[_n-5] if dum[_n-5]==1 & gvkey==gvkey[_n-5] & mi(ddatefil) & mi(`var') 
replace `var'=`var'[_n-6] if dum[_n-6]==1 & gvkey==gvkey[_n-6] & mi(ddatefil) & mi(`var') 
replace `var'=`var'[_n-7] if dum[_n-7]==1 & gvkey==gvkey[_n-7] & mi(ddatefil) & mi(`var') 
replace `var'=`var'[_n-8] if dum[_n-8]==1 & gvkey==gvkey[_n-8] & mi(ddatefil) & mi(`var') 
replace `var'=`var'[_n-9] if dum[_n-9]==1 & gvkey==gvkey[_n-9] & mi(ddatefil) & mi(`var') 
replace `var'=`var'[_n-10] if dum[_n-10]==1 & gvkey==gvkey[_n-10] & mi(ddatefil) & mi(`var') 
replace `var'=`var'[_n-11] if dum[_n-11]==1 & gvkey==gvkey[_n-11] & mi(ddatefil) & mi(`var') 

}

drop dum 
*/

save datmatmergedhedgecheck.dta, replace


***


*Date frequency conversion.

sort gvkey ddate
*Generate one quarter lagged variables by taking three months lag.
foreach var of varlist leftlow-vardebtcop {
by gvkey (ddate), sort: gen `var'lag=`var'[_n-3] 
}

*Generate one year + one quarter lagged variables (used for sophistication tests and IV regressions).
foreach var of varlist leftlow-vardebtcop {
by gvkey (ddate), sort: gen `var'lag15=`var'[_n-15] 
}
   
*In the end, we want to have the most recent CIQ info for each firm at each FOMC announcement.
*Create an auxiliary date variable.
gen monthf=1
gen dayf=30
gen yearf=1950
gen datedaily=mdy(monthf,dayf,yearf)
format datedaily %d

*Now, replace this date variable with FOMC announcement dates if there is a meeting.
replace datedaily=mdy(2,4,1994)	    if	ddate==tm(1994,2)
replace datedaily=mdy(3,22,1994)	if	ddate==tm(1994,3)
replace datedaily=mdy(4,18,1994)	if	ddate==tm(1994,4)
replace datedaily=mdy(5,17,1994)	if	ddate==tm(1994,5)
replace datedaily=mdy(7,6,1994)	    if	ddate==tm(1994,7)
replace datedaily=mdy(8,16,1994)	if	ddate==tm(1994,8)
replace datedaily=mdy(9,27,1994)	if	ddate==tm(1994,9)
replace datedaily=mdy(11,15,1994)	if	ddate==tm(1994,11)
replace datedaily=mdy(12,20,1994)	if	ddate==tm(1994,12)
replace datedaily=mdy(2,1,1995)	    if	ddate==tm(1995,2)
replace datedaily=mdy(3,28,1995)	if	ddate==tm(1995,3)
replace datedaily=mdy(5,23,1995)	if	ddate==tm(1995,5)
replace datedaily=mdy(7,6,1995)	    if	ddate==tm(1995,7)
replace datedaily=mdy(8,22,1995)	if	ddate==tm(1995,8)
replace datedaily=mdy(9,26,1995)	if	ddate==tm(1995,9)
replace datedaily=mdy(11,15,1995)	if	ddate==tm(1995,11)
replace datedaily=mdy(12,19,1995)	if	ddate==tm(1995,12)
replace datedaily=mdy(1,31,1996)	if	ddate==tm(1996,1)
replace datedaily=mdy(3,26,1996)	if	ddate==tm(1996,3)
replace datedaily=mdy(5,21,1996)	if	ddate==tm(1996,5)
replace datedaily=mdy(7,3,1996)	    if	ddate==tm(1996,7)
replace datedaily=mdy(8,20,1996)	if	ddate==tm(1996,8)
replace datedaily=mdy(9,24,1996)	if	ddate==tm(1996,9)
replace datedaily=mdy(11,13,1996)	if	ddate==tm(1996,11)
replace datedaily=mdy(12,17,1996)	if	ddate==tm(1996,12)
replace datedaily=mdy(2,5,1997)	    if	ddate==tm(1997,2)
replace datedaily=mdy(3,25,1997)	if	ddate==tm(1997,3)
replace datedaily=mdy(5,20,1997)	if	ddate==tm(1997,5)
replace datedaily=mdy(7,2,1997)	    if	ddate==tm(1997,7)
replace datedaily=mdy(8,19,1997)	if	ddate==tm(1997,8)
replace datedaily=mdy(9,30,1997)	if	ddate==tm(1997,9)
replace datedaily=mdy(11,12,1997)	if	ddate==tm(1997,11)
replace datedaily=mdy(12,16,1997)	if	ddate==tm(1997,12)
replace datedaily=mdy(2,4,1998)	    if	ddate==tm(1998,2)
replace datedaily=mdy(3,31,1998)	if	ddate==tm(1998,3)
replace datedaily=mdy(5,19,1998)	if	ddate==tm(1998,5)
replace datedaily=mdy(7,1,1998)	    if	ddate==tm(1998,7)
replace datedaily=mdy(8,18,1998)	if	ddate==tm(1998,8)
replace datedaily=mdy(9,29,1998)	if	ddate==tm(1998,9)
replace datedaily=mdy(10,15,1998)	if	ddate==tm(1998,10)
replace datedaily=mdy(11,17,1998)	if	ddate==tm(1998,11)
replace datedaily=mdy(12,22,1998)	if	ddate==tm(1998,12)
replace datedaily=mdy(2,3,1999)	    if	ddate==tm(1999,2)
replace datedaily=mdy(3,30,1999)	if	ddate==tm(1999,3)
replace datedaily=mdy(5,18,1999)	if	ddate==tm(1999,5)
replace datedaily=mdy(6,30,1999)	if	ddate==tm(1999,6)
replace datedaily=mdy(8,24,1999)	if	ddate==tm(1999,8)
replace datedaily=mdy(10,5,1999)	if	ddate==tm(1999,10)
replace datedaily=mdy(11,16,1999)	if	ddate==tm(1999,11)
replace datedaily=mdy(12,21,1999)	if	ddate==tm(1999,12)
replace datedaily=mdy(2,2,2000)	    if	ddate==tm(2000,2)
replace datedaily=mdy(3,21,2000)	if	ddate==tm(2000,3)
replace datedaily=mdy(5,16,2000)	if	ddate==tm(2000,5)
replace datedaily=mdy(6,28,2000)	if	ddate==tm(2000,6)
replace datedaily=mdy(8,22,2000)	if	ddate==tm(2000,8)
replace datedaily=mdy(10,3,2000)	if	ddate==tm(2000,10)
replace datedaily=mdy(11,15,2000)	if	ddate==tm(2000,11)
replace datedaily=mdy(12,19,2000)	if	ddate==tm(2000,12)
replace datedaily=mdy(3,20,2001)	if	ddate==tm(2001,3)
replace datedaily=mdy(4,18,2001)	if	ddate==tm(2001,4)
replace datedaily=mdy(5,15,2001)	if	ddate==tm(2001,5)
replace datedaily=mdy(6,27,2001)	if	ddate==tm(2001,6)
replace datedaily=mdy(8,21,2001)	if	ddate==tm(2001,8)
replace datedaily=mdy(9,17,2001)	if	ddate==tm(2001,9)
replace datedaily=mdy(10,2,2001)	if	ddate==tm(2001,10)
replace datedaily=mdy(11,6,2001)	if	ddate==tm(2001,11)
replace datedaily=mdy(12,11,2001)	if	ddate==tm(2001,12)
replace datedaily=mdy(1,30,2002)	if	ddate==tm(2002,1)
replace datedaily=mdy(3,19,2002)	if	ddate==tm(2002,3)
replace datedaily=mdy(5,7,2002)	    if	ddate==tm(2002,5)
replace datedaily=mdy(6,26,2002)	if	ddate==tm(2002,6)
replace datedaily=mdy(8,13,2002)	if	ddate==tm(2002,8)
replace datedaily=mdy(9,24,2002)	if	ddate==tm(2002,9)
replace datedaily=mdy(11,6,2002)	if	ddate==tm(2002,11)
replace datedaily=mdy(12,10,2002)	if	ddate==tm(2002,12)
replace datedaily=mdy(1,29,2003)	if	ddate==tm(2003,1)
replace datedaily=mdy(3,18,2003)	if	ddate==tm(2003,3)
replace datedaily=mdy(5,6,2003)	    if	ddate==tm(2003,5)
replace datedaily=mdy(6,25,2003)	if	ddate==tm(2003,6)
replace datedaily=mdy(8,12,2003)	if	ddate==tm(2003,8)
replace datedaily=mdy(9,16,2003)	if	ddate==tm(2003,9)
replace datedaily=mdy(10,28,2003)	if	ddate==tm(2003,10)
replace datedaily=mdy(12,9,2003)	if	ddate==tm(2003,12)
replace datedaily=mdy(1,28,2004)	if	ddate==tm(2004,1)
replace datedaily=mdy(3,16,2004)	if	ddate==tm(2004,3)
replace datedaily=mdy(5,4,2004)	    if	ddate==tm(2004,5)
replace datedaily=mdy(6,30,2004)	if	ddate==tm(2004,6)
replace datedaily=mdy(8,10,2004)	if	ddate==tm(2004,8)
replace datedaily=mdy(9,21,2004)	if	ddate==tm(2004,9)
replace datedaily=mdy(11,10,2004)	if	ddate==tm(2004,11)
replace datedaily=mdy(12,14,2004)	if	ddate==tm(2004,12)
replace datedaily=mdy(2,2,2005)	    if	ddate==tm(2005,2)
replace datedaily=mdy(3,22,2005)	if	ddate==tm(2005,3)
replace datedaily=mdy(5,3,2005)	    if	ddate==tm(2005,5)
replace datedaily=mdy(6,30,2005)	if	ddate==tm(2005,6)
replace datedaily=mdy(8,9,2005)	    if	ddate==tm(2005,8)
replace datedaily=mdy(9,20,2005)	if	ddate==tm(2005,9)
replace datedaily=mdy(11,1,2005)	if	ddate==tm(2005,11)
replace datedaily=mdy(12,13,2005)	if	ddate==tm(2005,12)
replace datedaily=mdy(1,31,2006)	if	ddate==tm(2006,1)
replace datedaily=mdy(3,28,2006)	if	ddate==tm(2006,3)
replace datedaily=mdy(5,10,2006)	if	ddate==tm(2006,5)
replace datedaily=mdy(6,29,2006)	if	ddate==tm(2006,6)
replace datedaily=mdy(8,8,2006)	    if	ddate==tm(2006,8)
replace datedaily=mdy(9,20,2006)	if	ddate==tm(2006,9)
replace datedaily=mdy(10,25,2006)	if	ddate==tm(2006,10)
replace datedaily=mdy(12,12,2006)	if	ddate==tm(2006,12)
replace datedaily=mdy(1,31,2007)	if	ddate==tm(2007,1)
replace datedaily=mdy(3,21,2007)	if	ddate==tm(2007,3)
replace datedaily=mdy(5,9,2007)	    if	ddate==tm(2007,5)
replace datedaily=mdy(6,28,2007)	if	ddate==tm(2007,6)
replace datedaily=mdy(9,18,2007)	if	ddate==tm(2007,9)
replace datedaily=mdy(10,31,2007)	if	ddate==tm(2007,10)
replace datedaily=mdy(12,11,2007)	if	ddate==tm(2007,12)
replace datedaily=mdy(4,30,2008)	if	ddate==tm(2008,4)
replace datedaily=mdy(6,25,2008)	if	ddate==tm(2008,6)
replace datedaily=mdy(8,5,2008)	    if	ddate==tm(2008,8)
replace datedaily=mdy(9,16,2008)	if	ddate==tm(2008,9)
replace datedaily=mdy(11,25,2008)	if	ddate==tm(2008,11)
replace datedaily=mdy(1,28,2009)	if	ddate==tm(2009,1)
replace datedaily=mdy(3,18,2009)	if	ddate==tm(2009,3)
replace datedaily=mdy(4,29,2009)	if	ddate==tm(2009,4)
replace datedaily=mdy(6,24,2009)	if	ddate==tm(2009,6)
replace datedaily=mdy(8,12,2009)	if	ddate==tm(2009,8)
replace datedaily=mdy(9,23,2009)	if	ddate==tm(2009,9)
replace datedaily=mdy(11,4,2009)	if	ddate==tm(2009,11)
replace datedaily=mdy(12,16,2009)	if	ddate==tm(2009,12)
replace datedaily=mdy(1,27,2010)	if	ddate==tm(2010,1)
replace datedaily=mdy(3,16,2010)	if	ddate==tm(2010,3)
replace datedaily=mdy(4,28,2010)	if	ddate==tm(2010,4)
replace datedaily=mdy(6,23,2010)	if	ddate==tm(2010,6)
replace datedaily=mdy(8,10,2010)	if	ddate==tm(2010,8)
replace datedaily=mdy(9,21,2010)	if	ddate==tm(2010,9)
replace datedaily=mdy(11,3,2010)	if	ddate==tm(2010,11)
replace datedaily=mdy(12,14,2010)	if	ddate==tm(2010,12)
replace datedaily=mdy(1,26,2011)	if	ddate==tm(2011,1)
replace datedaily=mdy(3,15,2011)	if	ddate==tm(2011,3)
replace datedaily=mdy(4,27,2011)	if	ddate==tm(2011,4)
replace datedaily=mdy(6,22,2011)	if	ddate==tm(2011,6)
replace datedaily=mdy(8,9,2011)	    if	ddate==tm(2011,8)
replace datedaily=mdy(9,21,2011)	if	ddate==tm(2011,9)
replace datedaily=mdy(11,2,2011)	if	ddate==tm(2011,11)
replace datedaily=mdy(12,13,2011)	if	ddate==tm(2011,12)
replace datedaily=mdy(1,25,2012)	if	ddate==tm(2012,1)
replace datedaily=mdy(3,13,2012)	if	ddate==tm(2012,3)
replace datedaily=mdy(4,25,2012)	if	ddate==tm(2012,4)
replace datedaily=mdy(6,20,2012)	if	ddate==tm(2012,6)
replace datedaily=mdy(8,1,2012)	    if	ddate==tm(2012,8)
replace datedaily=mdy(9,13,2012)	if	ddate==tm(2012,9)
replace datedaily=mdy(10,24,2012)	if	ddate==tm(2012,10)
replace datedaily=mdy(12,12,2012)	if	ddate==tm(2012,12)
replace datedaily=mdy(1,30,2013)	if	ddate==tm(2013,1)
replace datedaily=mdy(3,20,2013)	if	ddate==tm(2013,3)
replace datedaily=mdy(5,1,2013)	    if	ddate==tm(2013,5)
replace datedaily=mdy(6,19,2013)	if	ddate==tm(2013,6)
replace datedaily=mdy(7,31,2013)	if	ddate==tm(2013,7)
replace datedaily=mdy(9,18,2013)	if	ddate==tm(2013,9)
replace datedaily=mdy(10,30,2013)	if	ddate==tm(2013,10)
replace datedaily=mdy(12,18,2013)	if	ddate==tm(2013,12)
replace datedaily=mdy(1,29,2014)	if	ddate==tm(2014,1)
replace datedaily=mdy(3,19,2014)	if	ddate==tm(2014,3)
replace datedaily=mdy(4,30,2014)	if	ddate==tm(2014,4)
replace datedaily=mdy(6,18,2014)	if	ddate==tm(2014,6)
replace datedaily=mdy(7,30,2014)	if	ddate==tm(2014,7)
replace datedaily=mdy(9,17,2014)	if	ddate==tm(2014,9)
replace datedaily=mdy(10,29,2014)	if	ddate==tm(2014,10)
replace datedaily=mdy(12,17,2014)	if	ddate==tm(2014,12)
replace datedaily=mdy(1,28,2015)	if	ddate==tm(2015,1)
replace datedaily=mdy(3,18,2015)	if	ddate==tm(2015,3)
replace datedaily=mdy(4,29,2015)	if	ddate==tm(2015,4)
replace datedaily=mdy(6,17,2015)	if	ddate==tm(2015,6)
replace datedaily=mdy(7,29,2015)	if	ddate==tm(2015,7)
replace datedaily=mdy(9,17,2015)	if	ddate==tm(2015,9)
replace datedaily=mdy(10,28,2015)   if	ddate==tm(2015,10)
replace datedaily=mdy(12,16,2015)   if	ddate==tm(2015,12)
replace datedaily=mdy(1,27,2016)    if	ddate==tm(2016,1)
replace datedaily=mdy(3,16,2016)    if	ddate==tm(2016,3)
replace datedaily=mdy(4,27,2016)    if	ddate==tm(2016,4)
replace datedaily=mdy(6,15,2016)    if	ddate==tm(2016,6)
replace datedaily=mdy(7,27,2016)    if	ddate==tm(2016,7)
replace datedaily=mdy(9,21,2016)    if	ddate==tm(2016,9)
replace datedaily=mdy(11,2,2016)    if	ddate==tm(2016,11)
replace datedaily=mdy(12,14,2016)   if	ddate==tm(2016,12)
replace datedaily=mdy(2,1,2017)     if	ddate==tm(2017,2)
replace datedaily=mdy(3,15,2017)    if	ddate==tm(2017,3)
replace datedaily=mdy(5,3,2017)     if	ddate==tm(2017,5)
replace datedaily=mdy(6,14,2017)    if	ddate==tm(2017,6)
replace datedaily=mdy(7,26,2017)    if	ddate==tm(2017,7)
replace datedaily=mdy(9,20,2017)    if	ddate==tm(2017,9)
replace datedaily=mdy(11,1,2017)    if	ddate==tm(2017,11)
replace datedaily=mdy(12,13,2017)   if	ddate==tm(2017,12)
replace datedaily=mdy(1,31,2018)    if	ddate==tm(2018,1)
replace datedaily=mdy(3,21,2018)    if	ddate==tm(2018,3)
replace datedaily=mdy(5,2,2018)     if	ddate==tm(2018,5)
replace datedaily=mdy(6,13,2018)    if	ddate==tm(2018,6)
replace datedaily=mdy(8,1,2018)     if	ddate==tm(2018,8)
replace datedaily=mdy(9,26,2018)    if	ddate==tm(2018,9)
replace datedaily=mdy(11,8,2018)    if	ddate==tm(2018,11)
replace datedaily=mdy(12,19,2018)   if	ddate==tm(2018,12)

*Expand if there are more than one meeting within the same month.
sort gvkey ddate
expand 3 if ddate==tm(2007,8)
expand 2 if ddate==tm(2008,1)
expand 2 if ddate==tm(2008,3)
expand 2 if ddate==tm(2008,10)
expand 2 if ddate==tm(2008,12)
expand 2 if ddate==tm(2001,1)

*Clear auxiliary dates.
replace datedaily=. if datedaily==mdy(1,30,1950)

quietly by gvkey ddate, sort:  gen dup=cond(_N==1,0,_n)
tabulate dup

*Using dup, replace datedaily with proper dates.
replace datedaily=mdy(1,22,2008)	if	ddate==tm(2008,1) & dup==1
replace datedaily=mdy(1,30,2008)	if	ddate==tm(2008,1) & dup==2

replace datedaily=mdy(3,11,2008)	if	ddate==tm(2008,3) & dup==1
replace datedaily=mdy(3,18,2008)	if	ddate==tm(2008,3) & dup==2

replace datedaily=mdy(10,8,2008)	if	ddate==tm(2008,10) & dup==1
replace datedaily=mdy(10,29,2008)	if	ddate==tm(2008,10) & dup==2

replace datedaily=mdy(12,1,2008)	if	ddate==tm(2008,12) & dup==1
replace datedaily=mdy(12,16,2008)	if	ddate==tm(2008,12) & dup==2

replace datedaily=mdy(8,7,2007)	    if	ddate==tm(2007,8) & dup==1
replace datedaily=mdy(8,10,2007)	if	ddate==tm(2007,8) & dup==2
replace datedaily=mdy(8,17,2007)	if	ddate==tm(2007,8) & dup==3

replace datedaily=mdy(1,3,2001)	    if	ddate==tm(2001,1) & dup==1
replace datedaily=mdy(1,31,2001)	if	ddate==tm(2001,1) & dup==2

drop dup

merge m:1 datedaily using fomcdates

*If you write "edi if _merge==2" you can see the dates for which CIQ data is not available.
keep if _merge==3
drop _merge

sort gvkey gvkey ddate datedaily
order gvkey gvkey ddate datedaily

drop monthf-yearf

*Now, we have exposure and hedging information for each FOMC announcement.

*Drop atq's. This is done for safety (because we merge this with Compustat data later).
drop atq* 

save datmatmergedhedgefomc.dta, replace

set more on

!date
