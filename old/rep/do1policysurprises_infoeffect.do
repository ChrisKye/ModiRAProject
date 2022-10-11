*GSS residuals from conditioning on Greenbook data from Miranda-Agrippino and Ricco (2021)

*Table 7 in the paper is produced as part of this do file. 

*Set directory.
cd "C:\Users\gokce\Desktop\round3\MAR\IVextension2\IVextension"

clear 
use datsurprisewithpath
keep transfact1 transfact2 ddate datedaily
save policydata.dta, replace

*Load the master dataset.
clear
*Miranda-Agrippino and Ricco kindly provided us with the data.
import excel "C:\Users\gokce\Desktop\referee report\update paper\veri\masterxx.xlsx", sheet("Sheet2") firstrow

drop month year day

merge 1:1 datedaily using policydata
keep if _merge==3
drop _merge

egen meanrevgrowth=rmean(rev_gRGDPF0 rev_gRGDPF1 rev_gRGDPF2 rev_gRGDPF3)
egen meanrevprice=rmean(rev_gPGDPF0 rev_gPGDPF1 rev_gPGDPF2 rev_gPGDPF3)
egen meanrevunemp=rmean(rev_UNEMPF0 rev_UNEMPF1 rev_UNEMPF2 rev_UNEMPF3)

*Convert variables to be compatible with Karnaukh's (2020) convention.
replace meanrevgrowth=meanrevgrowth/100
replace meanrevprice=meanrevprice/100
replace meanrevunemp=meanrevunemp/100

*Karnaukh's (2020) sample period.
*target.
reg transfact1 meanrevgrowth if( datedaily <= td(18/12/2013)), robust 
outreg2 using table7, tex replace  label dec(2)
*path.
reg transfact2 meanrevgrowth if(datedaily <= td(18/12/2013)), robust 
outreg2 using table7, tex append  label dec(2)

*target: extend Karnaukh (2020).
reg transfact1 meanrevgrowth meanrevprice meanrevunemp if(datedaily <= td(18/12/2013)), robust 
outreg2 using table7, tex append  label dec(2)
*path: extend Karnaukh (2020).
reg transfact2 meanrevgrowth meanrevprice meanrevunemp  if(datedaily <= td(18/12/2013)), robust 
outreg2 using table7, tex append  label dec(2)

*Our sample period.
*target.
reg transfact1 meanrevgrowth if(datedaily >= td(1/1/2004) & datedaily <= td(18/12/2013)), robust 
outreg2 using table7, tex append label dec(2)
*path.
reg transfact2 meanrevgrowth if(datedaily >= td(1/1/2004) & datedaily <= td(18/12/2013)), robust 
outreg2 using table7, tex append label dec(2)

*target: extend Karnaukh (2020).
reg transfact1 meanrevgrowth meanrevprice meanrevunemp if(datedaily >= td(1/1/2004) & datedaily <= td(18/12/2013)), robust 
predict targetres if(datedaily >= td(1/1/2004) & datedaily <= td(18/12/2013)), res
outreg2 using table7, tex append label dec(2)
*path: extend Karnaukh (2020).
reg transfact2 meanrevgrowth meanrevprice meanrevunemp  if(datedaily >= td(1/1/2004) & datedaily <= td(18/12/2013)), robust 
predict pathres if(datedaily >= td(1/1/2004) & datedaily <= td(18/12/2013)), res
outreg2 using table7, tex append label dec(2)

*Keep only the residuals and the dates for merging with other data later.
keep datedaily targetres pathres
save mardata.dta, replace
