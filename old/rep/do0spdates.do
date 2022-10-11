***This file selects S&P500 firms we work with.
*From S&P list, we select all firms that have been part of S&P500 index (which include currently de-listed firms).
*We consider entrants into the index until the end of 2018 where our sample ends. 

*Here, show the path to the directory you want to work in. 
cd "C:\Users\gokce\Desktop\referee report\update paper"

capture log close
clear

clear matrix
*Include time stamp in the results log file.
display "$S_DATE $S_TIME"

*Memory management. 
set mem 1000m
set matsize 500

*Don't stop when the screen fills up while running the code.
set more off

*To import a dta file, use this command.
*Downloaded from WRDS.
use "C:\Users\gokce\Desktop\referee report\update paper\veri\spcons" 

*"gvkey" is the firm identifier, gvkeyx is the index identifier. "from" and "thru" dates indicate the time interval the firm belongs to an index.

*Convert variables into numbers whereever possible.
destring, replace

*Define fromdate variable in Stata format.
gen fromdate=ym(year(from),month(from))
format fromdate %tm

gen thrudate=ym(year(thru),month(thru))
format thrudate %tm

*Sort according to gvkey.
sort gvkey
save spdates.dta, replace

*Keep only S&P 500 firms.
keep if gvkeyx==3

*Drop the firms that entered after 2019 (our sample ends in 2018).
drop if fromdate>=tm(2019,1)

*With the command below, you can see whether firms entered the same indexes more than once.
sort gvkey gvkeyx
quietly by gvkey:  gen dup = cond(_N==1,0,_n)
tabulate dup
*Remove duplicate entries (as long as they entered at least once, it does not matter).
drop if dup>1
drop dup

sort gvkeyx gvkey
keep gvkeyx gvkey fromdate thrudate

sort gvkeyx gvkey
keep gvkeyx gvkey fromdate thrudate

save spdates.dta, replace

*****

*Import CPI data.
clear
*Downloaded from FRED (2015=100).
insheet using "C:\Users\gokce\Desktop\referee report\update paper\veri\cpidata.csv", comma

*Again, construct date variables. In the excel file, "tarih" means date.

*"ddate" is our key date variable which consists of year and month.
gen ddate=ym(year, month)
format ddate %tm
drop year month tarih
sort ddate

save cpi.dta, replace

clear

*****

*Use daily data for aggregate S&P500 index to construct Figures 2 and 3.

*Downloaded from Yahoo Finance. 
import delimited "C:\Users\gokce\Desktop\referee report\update paper\veri\sp500yahoo.txt", varnames(1) 
gen fyear=regexs(0) if(regexm(date,"[0-9][0-9][0-9][0-9]"))
gen fday=regexs(0) if(regexm(date,"[0-9][0-9]$"))
gen fslashmonth=regexs(0) if(regexm(date,"[0-9][0-9][\-][0-9][0-9]$"))
gen fmonth=regexs(0) if(regexm(fslashmonth,"[0-9][0-9]"))

destring, replace

gen datedaily=mdy(fmonth,fday,fyear)
gen ddate=ym(fyear,fmonth)
format ddate %tm
format datedaily %d
tsset datedaily 

drop open high low adjclose volume
drop fyear fday fslashmonth fmonth
tsset datedaily
sort datedaily
rename close sp500
gen percsp500=log(sp500[_n])-log(sp500[_n-1])
*gen percsp500twoday=log(sp500[_n+1])-log(sp500[_n-1])

save large.dta, replace

!date
