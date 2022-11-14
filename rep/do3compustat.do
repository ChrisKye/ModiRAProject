***This file merges Compustat data with what we produce in do0 and do2.

cd "C:\Users\gokce\Desktop\referee report\update paper"

clear
use rawdatbalancexx

sort gvkey ddate
*CPI data.
merge m:1 ddate using cpi, force
drop _merge

*Generate deflated variables.
foreach var of varlist atq {
gen `var'_def=(`var'/cpi)
}

*Generate copies to check the data set later.
gen ddatecop=ddate
gen atqcopp=atq

*Define the data set as a panel data.
xtset gvkey ddate

*Again, we need all dates.
tsfill, full

gen dum=.
*ddatecop identifies the balance sheet periods.
replace dum=1 if !mi(ddatecop)
*Now, replace all missing variables with the most recent balance sheet info. 
foreach var of varlist conm acoq-atq_def{
replace `var'=`var'[_n-1] if dum[_n-1]==1 & gvkey==gvkey[_n-1] & mi(ddatecop) & mi(`var')
replace `var'=`var'[_n-2] if dum[_n-2]==1 & gvkey==gvkey[_n-2] & mi(ddatecop) & mi(`var')
}

drop dum ddatecop

*Generate variables lagged by one quarter.
foreach var of varlist conm acoq-atq_def {
by gvkey (ddate): gen `var'lag=`var'[_n-3] 
}

***

*Construct financial constraint index.
gen ebitda=saleqlag-xsgaqlag-cogsqlag
gen ebit=ebitda-dpqlag
 
*ebit/xintqlag is interest coverage, niqlag/atqlag is ROA, cheqlag/atqlag is cash holdings.
gen sizefcplag=log(atqlag)
gen fcpindex=-0.123*sizefcplag-0.024*(ebit/xintqlag)-4.404*(niqlag/atqlag)-1.716*(cheqlag/atqlag)

*1 quarter lag.
foreach var of varlist fcpindex {
by gvkey (ddate): gen `var'lag=`var'[_n-3] 
}
*2 quarters lag.
foreach var of varlist fcpindex {
by gvkey (ddate): gen `var'twolag=`var'[_n-6] 
}
*3 quarters lag.
foreach var of varlist fcpindex {
by gvkey (ddate): gen `var'threelag=`var'[_n-9] 
}
*4 quarters lag.
foreach var of varlist fcpindex {
by gvkey (ddate): gen `var'fourlag=`var'[_n-12] 
}

gen laggedaveragefcp=(fcpindexlag+fcpindextwolag+fcpindexthreelag+fcpindexfourlag)/4

***

sort gvkey ddate 
order gvkey ddate 

*As was the case with CIQ data, convert the data set to make it compatible with FOMC announcement dates.
gen monthf=1
gen dayf=30
gen yearf=1950
gen datedaily=mdy(monthf,dayf,yearf)
format datedaily %d

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

sort gvkey ddate
expand 3 if ddate==tm(2007,8)
expand 2 if ddate==tm(2008,1)
expand 2 if ddate==tm(2008,3)
expand 2 if ddate==tm(2008,10)
expand 2 if ddate==tm(2008,12)
expand 2 if ddate==tm(2001,1)

replace datedaily=. if datedaily==mdy(1,30,1950)

quietly by gvkey ddate, sort:  gen dup=cond(_N==1,0,_n)
tabulate dup

replace datedaily=mdy(1,22,2008)	if	ddate==tm(2008,1) & dup==1
replace datedaily=mdy(1,30,2008)	if	ddate==tm(2008,1) & dup==2

replace datedaily=mdy(3,11,2008)	if	ddate==tm(2008,3) & dup==1
replace datedaily=mdy(3,18,2008)	if	ddate==tm(2008,3) & dup==2

replace datedaily=mdy(10,8,2008)	if	ddate==tm(2008,10) & dup==1
replace datedaily=mdy(10,29,2008)	if	ddate==tm(2008,10) & dup==2

replace datedaily=mdy(12,1,2008)	if	ddate==tm(2008,12) & dup==1
replace datedaily=mdy(12,16,2008)	if	ddate==tm(2008,12) & dup==2

replace datedaily=mdy(1,3,2001)	    if	ddate==tm(2001,1) & dup==1
replace datedaily=mdy(1,31,2001)    if	ddate==tm(2001,1) & dup==2

replace datedaily=mdy(8,7,2007)	    if	ddate==tm(2007,8) & dup==1
replace datedaily=mdy(8,10,2007)	if	ddate==tm(2007,8) & dup==2
replace datedaily=mdy(8,17,2007)	if	ddate==tm(2007,8) & dup==3

drop dup

*This checks whether the dates have matched correctly. No unmatched entries here.
merge m:1 datedaily using fomcdates
keep if _merge==3
drop _merge

sort gvkey gvkey ddate datedaily
order gvkey gvkey ddate datedaily

drop if ddate<tm(2001,1)
save datbalance.dta, replace

***

*Merge Compustat with CIQ and hedge.

*Now, both Compustat and CIQ data are compatible with FOMC announcement dates. We can merge them safely.
clear 
clear all
use datmatmergedhedgefomc
sort gvkey datedaily ddate
drop if ddate<tm(2001,1)
merge 1:1 gvkey datedaily ddate using datbalance
keep if _merge==3
drop _merge

order gvkey ddate
sort gvkey ddate

save datbalancemergedhedgefomc.dta, replace

*We now have merged CIQ data, hedging data, and Compustat data.

set more on

!date
