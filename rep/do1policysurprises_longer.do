***This file produces monetary policy target and path surprises.
*Originally written by Gurkaynak, Sack and Swanson (2005). 
*Some of commands they use are not available in later versions of Stata.
*For this reason, we use version 8 here.

version 8

cd "C:\Users\gokce\Desktop\referee report\update paper"
capture log close

clear
clear matrix

import excel "C:\Users\gokce\Desktop\referee report\update paper\veri\GSSrawdata", firstrow

save datsurprisewithpath.dta, replace

*Turn string variables into numerics whereever possible.
destring, replace

*Using month, day, and year variables, construct "datedaily" variable that shows FOMC meeting date.
gen datedaily=mdy(month,day,year)
gen ddate=ym(year,month)
format ddate %tm
format datedaily %d
drop month day year
sort datedaily 
save datsurprisewithpath.dta, replace

**********************************************
*  Do principal components on five variables  *
***********************************************
pca MP1 MP2 ED2 ED3 ED4 ED5 ED6 ED7 ED8
*Keep the first two factors, f1 and f2.

score f1 f2 
*Do the rotation.
matrix evec=get(Ld)
scalar a1=evec[1,1]/(evec[1,1]+evec[1,2])
scalar a2=evec[1,2]/(evec[1,1]+evec[1,2])
sum f1
scalar vf1=r(sd)^2
sum f2
scalar vf2=r(sd)^2
scalar b1=-1*a2*vf2/(a1*vf1-a2*vf2)
scalar b2=a1*vf1/(a1*vf1-a2*vf2)
*Display the weights.
disp a1 a2 b1 b2
*Generate rotated factors.
gen transfact1=a1*f1+a2*f2
gen transfact2=b1*f1+b2*f2
*Normalize the factors so that transfact1 has coefficient 1 on mp1tight IN SAMPLE.
reg MP1 transfact1 
replace transfact1=transfact1*_b[transfact1]
*And transfact2 moves ed4 as much as transfact1 does.
reg ED8 transfact1 transfact2 
replace transfact2=transfact2*_b[transfact2]/_b[transfact1]

drop if datedaily < td(2,1,1994)

label variable transfact1 "target factor"
label variable transfact2 "path factor"
label variable ddate "policy date"

*To see the surprises:
scatter transfact1 transfact2 ddate, xlabel(minmax)
twoway (scatter transfact1 ddate, yaxis(1)) (scatter transfact2 ddate, yaxis(2)), xlabel(minmax)
*This data set will be merged with firm-level variables.
save datsurprisewithpath.dta, replace

******
*Below, we create a small data set that indicates FOMC meeting dates, which will be useful later.
******

clear
use datsurprisewithpath

order date datedaily ddate
keep datedaily ddate
gen fomcdum=1

save fomcdates.dta, replace

set more on

!date
