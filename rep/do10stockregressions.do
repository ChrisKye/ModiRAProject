***This file runs all stock regressions in the paper.
*This requires access to CRSP, Compustat, and CIQ to work.

cd "C:\Users\gokce\Desktop\referee report\update paper"

*Table 2:
*With only bank debt leverage.
clear
use pprepdata
qui areg twodaypercprccd c.transfact1##c.newbankratiolag##1.hedgeindlag c.transfact1##c.sizelag##1.hedgeindlag c.transfact1##c.booklevlag##1.hedgeindlag c.transfact1##c.profitabilitylag##1.hedgeindlag c.transfact1##c.markettobooklag##1.hedgeindlag c.transfact1##c.assetmat##1.hedgeindlag, absorb(gvkey) vce(cluster numstock)
outreg2 using table2, tex replace label dec(2)

clear
use baselineprezlb

*With only exposure.
qui areg twodaypercprccd  c.transfact1##c.matvarasslag##1.hedgeindlag c.transfact2##c.matvarasslag##1.hedgeindlag  c.transfact1##c.sizelag##1.hedgeindlag  c.transfact2##c.sizelag##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.hedgeindlag   c.transfact1##c.booklevlag##1.hedgeindlag c.transfact2##c.booklevlag##1.hedgeindlag  c.transfact1##c.markettobooklag##1.hedgeindlag c.transfact2##c.markettobooklag##1.hedgeindlag c.transfact1##c.cashtoaslag##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.hedgeindlag c.transfact1##c.assetmat##1.hedgeindlag  c.transfact2##c.assetmat##1.hedgeindlag c.transfact1##c.reqtoaslag##1.hedgeindlag c.transfact2##c.reqtoaslag##1.hedgeindlag c.transfact1##c.divpersharelag##1.hedgeindlag c.transfact2##c.divpersharelag##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using table2, tex append label dec(2)

*With both bank debt leverage and exposure.
qui areg twodaypercprccd c.transfact1##c.newbankratiolag##1.hedgeindlag c.transfact2##c.newbankratiolag##1.hedgeindlag   c.transfact1##c.matvarasslag##1.hedgeindlag c.transfact2##c.matvarasslag##1.hedgeindlag  c.transfact1##c.sizelag##1.hedgeindlag  c.transfact2##c.sizelag##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.hedgeindlag   c.transfact1##c.booklevlag##1.hedgeindlag c.transfact2##c.booklevlag##1.hedgeindlag  c.transfact1##c.markettobooklag##1.hedgeindlag c.transfact2##c.markettobooklag##1.hedgeindlag c.transfact1##c.cashtoaslag##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.hedgeindlag c.transfact1##c.assetmat##1.hedgeindlag  c.transfact2##c.assetmat##1.hedgeindlag c.transfact1##c.reqtoaslag##1.hedgeindlag c.transfact2##c.reqtoaslag##1.hedgeindlag c.transfact1##c.divpersharelag##1.hedgeindlag c.transfact2##c.divpersharelag##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using table2, tex append label dec(2)

*Only time fixed effects.
qui areg twodaypercprccd c.transfact1##c.newbankratiolag##1.hedgeindlag c.transfact2##c.newbankratiolag##1.hedgeindlag   c.transfact1##c.matvarasslag##1.hedgeindlag c.transfact2##c.matvarasslag##1.hedgeindlag  c.transfact1##c.sizelag##1.hedgeindlag  c.transfact2##c.sizelag##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.hedgeindlag   c.transfact1##c.booklevlag##1.hedgeindlag c.transfact2##c.booklevlag##1.hedgeindlag  c.transfact1##c.markettobooklag##1.hedgeindlag c.transfact2##c.markettobooklag##1.hedgeindlag c.transfact1##c.cashtoaslag##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.hedgeindlag c.transfact1##c.assetmat##1.hedgeindlag  c.transfact2##c.assetmat##1.hedgeindlag c.transfact1##c.reqtoaslag##1.hedgeindlag c.transfact2##c.reqtoaslag##1.hedgeindlag c.transfact1##c.divpersharelag##1.hedgeindlag c.transfact2##c.divpersharelag##1.hedgeindlag, absorb(numstock) vce(cluster numstock) 
outreg2 using table2, tex append label dec(2)

*Both firm and time fixed effects.
qui areg twodaypercprccd i.numstock c.transfact1##c.newbankratiolag##1.hedgeindlag c.transfact2##c.newbankratiolag##1.hedgeindlag   c.transfact1##c.matvarasslag##1.hedgeindlag c.transfact2##c.matvarasslag##1.hedgeindlag  c.transfact1##c.sizelag##1.hedgeindlag  c.transfact2##c.sizelag##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.hedgeindlag   c.transfact1##c.booklevlag##1.hedgeindlag c.transfact2##c.booklevlag##1.hedgeindlag  c.transfact1##c.markettobooklag##1.hedgeindlag c.transfact2##c.markettobooklag##1.hedgeindlag c.transfact1##c.cashtoaslag##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.hedgeindlag c.transfact1##c.assetmat##1.hedgeindlag  c.transfact2##c.assetmat##1.hedgeindlag c.transfact1##c.reqtoaslag##1.hedgeindlag c.transfact2##c.reqtoaslag##1.hedgeindlag c.transfact1##c.divpersharelag##1.hedgeindlag c.transfact2##c.divpersharelag##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using table2, tex append label dec(2)

*With bank debt leverage and Fama-French adjustments.
qui areg famadjret c.transfact1##c.newbankratiolag##1.hedgeindlag c.transfact2##c.newbankratiolag##1.hedgeindlag c.transfact1##c.matvarasslag##1.hedgeindlag c.transfact2##c.matvarasslag##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using table2, tex append label dec(2)

*With bank debt leverage, Fama-French adjustments, and other controls
qui areg famadjret c.transfact1##c.newbankratiolag##1.hedgeindlag c.transfact2##c.newbankratiolag##1.hedgeindlag   c.transfact1##c.matvarasslag##1.hedgeindlag c.transfact2##c.matvarasslag##1.hedgeindlag  c.transfact1##c.sizelag##1.hedgeindlag  c.transfact2##c.sizelag##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.hedgeindlag   c.transfact1##c.booklevlag##1.hedgeindlag c.transfact2##c.booklevlag##1.hedgeindlag  c.transfact1##c.markettobooklag##1.hedgeindlag c.transfact2##c.markettobooklag##1.hedgeindlag c.transfact1##c.cashtoaslag##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.hedgeindlag c.transfact1##c.assetmat##1.hedgeindlag  c.transfact2##c.assetmat##1.hedgeindlag c.transfact1##c.reqtoaslag##1.hedgeindlag c.transfact2##c.reqtoaslag##1.hedgeindlag c.transfact1##c.divpersharelag##1.hedgeindlag c.transfact2##c.divpersharelag##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using table2, tex append label dec(2)

*Table 3:
clear
use baselinezlb

*Only firm fixed effects.
qui areg twodaypercprccd c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact1##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.transfact2##c.newbankratiolag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.transfact1##c.booklevlag##1.zlbdummy##1.hedgeindlag c.transfact2##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact2##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact1##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.transfact1##c.assetmat##1.zlbdummy##1.hedgeindlag  c.transfact2##c.assetmat##1.zlbdummy##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using table3, tex replace label dec(2)

*Only time fixed effects.
qui areg twodaypercprccd c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact1##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.transfact2##c.newbankratiolag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.transfact1##c.booklevlag##1.zlbdummy##1.hedgeindlag c.transfact2##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact2##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact1##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.transfact1##c.assetmat##1.zlbdummy##1.hedgeindlag  c.transfact2##c.assetmat##1.zlbdummy##1.hedgeindlag, absorb(numstock) vce(cluster numstock) 
outreg2 using table3, tex append label dec(2)

*Both firm and time fixed effects.
qui areg twodaypercprccd i.numstock c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact1##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.transfact2##c.newbankratiolag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.transfact1##c.booklevlag##1.zlbdummy##1.hedgeindlag c.transfact2##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact2##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact1##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.transfact1##c.assetmat##1.zlbdummy##1.hedgeindlag  c.transfact2##c.assetmat##1.zlbdummy##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using table3, tex append label dec(2)

*Marginal effects.
su matvarasslag,d
su reqtoaslag divpersharelag newbankratiolag sizelag profitabilitylag booklevlag markettobooklag cashtoaslag assetmat transfact1,d

qui areg twodaypercprccd c.transfact1##c.reqtoaslag##i.hedgeindlag##i.zlbdummy c.transfact2##c.reqtoaslag##i.hedgeindlag##i.zlbdummy c.transfact1##c.divpersharelag##i.hedgeindlag##i.zlbdummy c.transfact2##c.divpersharelag##i.hedgeindlag##i.zlbdummy c.transfact1##c.newbankratiolag##i.hedgeindlag##i.zlbdummy c.transfact2##c.newbankratiolag##i.hedgeindlag##i.zlbdummy   c.transfact1##c.matvarasslag##i.hedgeindlag##i.zlbdummy c.transfact2##c.matvarasslag##i.hedgeindlag##i.zlbdummy  c.transfact1##c.sizelag##i.zlbdummy##i.hedgeindlag  c.transfact2##c.sizelag##i.zlbdummy##i.hedgeindlag  c.transfact1##c.profitabilitylag##i.zlbdummy##i.hedgeindlag  c.transfact2##c.profitabilitylag##i.zlbdummy##i.hedgeindlag   c.transfact1##c.booklevlag##i.zlbdummy##i.hedgeindlag c.transfact2##c.booklevlag##i.zlbdummy##i.hedgeindlag  c.transfact1##c.markettobooklag##i.zlbdummy##i.hedgeindlag c.transfact2##c.markettobooklag##i.zlbdummy##i.hedgeindlag c.transfact1##c.cashtoaslag##i.zlbdummy##i.hedgeindlag  c.transfact2##c.cashtoaslag##i.zlbdummy##i.hedgeindlag c.transfact1##c.assetmat##i.zlbdummy##i.hedgeindlag  c.transfact2##c.assetmat##i.zlbdummy##i.hedgeindlag, absorb(gvkey) vce(cluster numstock)

*Set everything to the mean value.
margins, dydx(transfact2) over(hedgeindlag zlbdummy) atmeans at(reqtoaslag=0.2057264 divpersharelag=0.1628614 newbankratiolag=0.1404685 sizelag=4.354918 profitabilitylag=0.0370467 booklevlag=0.4112751 markettobooklag=1.700086 cashtoaslag=0.1284165 assetmat=0.4752314 transfact1=0.0091434 matvarasslag=1.68) at(reqtoaslag=0.2057264 divpersharelag=0.1628614 newbankratiolag=0.1404685 sizelag=4.354918 profitabilitylag=0.0370467 booklevlag=0.4112751 markettobooklag=1.700086 cashtoaslag=0.1284165 assetmat=0.4752314 transfact1=0.0091434 matvarasslag=2.24) at(reqtoaslag=0.2057264 divpersharelag=0.1628614 newbankratiolag=0.1404685 sizelag=4.354918 profitabilitylag=0.0370467 booklevlag=0.4112751 markettobooklag=1.700086 cashtoaslag=0.1284165 assetmat=0.4752314 transfact1=0.0091434 matvarasslag=3.28) post noestimcheck

*Table 4:
clear
clear all
use baselinezlb

*We need to recalculate the change in exposure by FOMC announcement dates.

*Compute the change in exposure between FOMC announcements.
gen changeexposure=.
bysort gvkey (datedaily): replace changeexposure=(matvarasslag-matvarasslag[_n-1])
*If there is no change, record as missing entries.
replace changeexposure=. if changeexposure==0

*Variables for positive and negative changes.
gen poschangeexposure=changeexposure if changeexposure>0
gen negchangeexposure=changeexposure if changeexposure<0

*Divide them into quantiles to point out large changes.
xtile poschexpxtiles=poschangeexposure if !mi(poschangeexposure), n(5)
xtile negchexpxtiles=negchangeexposure if !mi(negchangeexposure), n(5)

*Largest positives.
gen dumchexppos=0
replace dumchexppos=1 if poschexpxtiles==5 
*Largest negatives.
gen dumchexpneg=0
replace dumchexpneg=1 if negchexpxtiles==1

gen agedum=0
replace agedum=1 if age<=2

*Age dummy.
qui areg twodaypercprccd i.numstock c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy##1.agedum c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy##1.agedum c.transfact1##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.transfact2##c.newbankratiolag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.sizelag##1.hedgeindlag##1.zlbdummy  c.transfact2##c.sizelag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.profitabilitylag##1.hedgeindlag##1.zlbdummy  c.transfact2##c.profitabilitylag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.booklevlag##1.hedgeindlag##1.zlbdummy c.transfact2##c.booklevlag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.markettobooklag##1.hedgeindlag##1.zlbdummy c.transfact2##c.markettobooklag##1.hedgeindlag##1.zlbdummy c.transfact1##c.cashtoaslag##1.hedgeindlag##1.zlbdummy  c.transfact2##c.cashtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.assetmat##1.hedgeindlag##1.zlbdummy  c.transfact2##c.assetmat##1.hedgeindlag##1.zlbdummy c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy, absorb(gvkey) vce(cluster numstock) 
outreg2 using table4, tex replace label dec(2)

*Large changes in exposure.
qui areg twodaypercprccd i.numstock c.transfact2##c.matvarasslag##1.dumchexppos##1.hedgeindlag##1.zlbdummy c.transfact1##c.matvarasslag##1.dumchexppos##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.dumchexpneg##1.hedgeindlag##1.zlbdummy c.transfact1##c.matvarasslag##1.dumchexpneg##1.hedgeindlag##1.zlbdummy c.transfact1##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.transfact2##c.newbankratiolag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.sizelag##1.hedgeindlag##1.zlbdummy  c.transfact2##c.sizelag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.profitabilitylag##1.hedgeindlag##1.zlbdummy  c.transfact2##c.profitabilitylag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.booklevlag##1.hedgeindlag##1.zlbdummy c.transfact2##c.booklevlag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.markettobooklag##1.hedgeindlag##1.zlbdummy c.transfact2##c.markettobooklag##1.hedgeindlag##1.zlbdummy c.transfact1##c.cashtoaslag##1.hedgeindlag##1.zlbdummy  c.transfact2##c.cashtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.assetmat##1.hedgeindlag##1.zlbdummy  c.transfact2##c.assetmat##1.hedgeindlag##1.zlbdummy c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy, absorb(gvkey) vce(cluster numstock) 
outreg2 using table4, tex append label dec(2)

*Current and lagged exposure.
qui areg twodaypercprccd i.numstock c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.matvarasslag15##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag15##1.hedgeindlag##1.zlbdummy c.transfact1##c.newbankratiolag##1.hedgeindlag##1.zlbdummy##1.hedgeindlag##1.zlbdummy c.transfact2##c.newbankratiolag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.sizelag##1.hedgeindlag##1.zlbdummy  c.transfact2##c.sizelag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.profitabilitylag##1.hedgeindlag##1.zlbdummy  c.transfact2##c.profitabilitylag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.booklevlag##1.hedgeindlag##1.zlbdummy c.transfact2##c.booklevlag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.markettobooklag##1.hedgeindlag##1.zlbdummy c.transfact2##c.markettobooklag##1.hedgeindlag##1.zlbdummy c.transfact1##c.cashtoaslag##1.hedgeindlag##1.zlbdummy  c.transfact2##c.cashtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.assetmat##1.hedgeindlag##1.zlbdummy  c.transfact2##c.assetmat##1.hedgeindlag##1.zlbdummy c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy, absorb(gvkey) vce(cluster numstock) 
outreg2 using table4, tex append label dec(2)

*Tables 5 and 6 are produced in do11_balancesheetregressions.
 
*Table 7 is produced in do1policysurprises_infoeffect.

*Table 8:
clear
use baselineresiduals
drop if ddate>tm(2013,12)

*Only firm fixed effects.
qui areg twodaypercprccd c.targetres##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.pathres##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.targetres##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.pathres##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.targetres##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.pathres##c.newbankratiolag##1.hedgeindlag##1.zlbdummy   c.targetres##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.pathres##c.matvarasslag##1.hedgeindlag##1.zlbdummy  c.targetres##c.sizelag##1.zlbdummy##1.hedgeindlag  c.pathres##c.sizelag##1.zlbdummy##1.hedgeindlag  c.targetres##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.pathres##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.targetres##c.booklevlag##1.zlbdummy##1.hedgeindlag c.pathres##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.targetres##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.pathres##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.targetres##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.pathres##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.targetres##c.assetmat##1.zlbdummy##1.hedgeindlag  c.pathres##c.assetmat##1.zlbdummy##1.hedgeindlag, absorb(gvkey) vce(cluster numstock)
outreg2 using table8, tex replace label dec(2)

*Both firm and time fixed effects.
qui areg twodaypercprccd i.numstock c.targetres##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.pathres##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.targetres##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.pathres##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.targetres##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.pathres##c.newbankratiolag##1.hedgeindlag##1.zlbdummy   c.targetres##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.pathres##c.matvarasslag##1.hedgeindlag##1.zlbdummy  c.targetres##c.sizelag##1.zlbdummy##1.hedgeindlag  c.pathres##c.sizelag##1.zlbdummy##1.hedgeindlag  c.targetres##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.pathres##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.targetres##c.booklevlag##1.zlbdummy##1.hedgeindlag c.pathres##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.targetres##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.pathres##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.targetres##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.pathres##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.targetres##c.assetmat##1.zlbdummy##1.hedgeindlag  c.pathres##c.assetmat##1.zlbdummy##1.hedgeindlag, absorb(gvkey) vce(cluster numstock)
outreg2 using table8, tex append label dec(2)
 
*Table B-6:
clear
use pprepdata
*With bank debt leverage.
qui areg twodaypercprccd c.transfact1##c.newbankratiolag##1.hedgeindlag c.transfact1##c.sizelag##1.hedgeindlag c.transfact1##c.booklevlag##1.hedgeindlag c.transfact1##c.profitabilitylag##1.hedgeindlag c.transfact1##c.markettobooklag##1.hedgeindlag c.transfact1##c.assetmat##1.hedgeindlag, absorb(gvkey) vce(cluster numstock)
outreg2 using tableb6, tex replace label dec(2)

*With floating rate debt leverage.
qui areg twodaypercprccd c.transfact1##c.varlevorlag##1.hedgeindlag c.transfact1##c.sizelag##1.hedgeindlag c.transfact1##c.booklevlag##1.hedgeindlag c.transfact1##c.profitabilitylag##1.hedgeindlag c.transfact1##c.markettobooklag##1.hedgeindlag c.transfact1##c.assetmat##1.hedgeindlag, absorb(gvkey) vce(cluster numstock)
outreg2 using tableb6, tex append label dec(2)

*Table B-7 is identical to Table 3.

*Table B-8: 
clear
use baselineprezlb

*With floating rate debt leverage.
qui areg twodaypercprccd  c.transfact1##c.varlevorlag##1.hedgeindlag c.transfact2##c.varlevorlag##1.hedgeindlag   c.transfact1##c.matvarasslag##1.hedgeindlag c.transfact2##c.matvarasslag##1.hedgeindlag   c.transfact1##c.sizelag##1.hedgeindlag  c.transfact2##c.sizelag##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.hedgeindlag   c.transfact1##c.booklevlag##1.hedgeindlag c.transfact2##c.booklevlag##1.hedgeindlag  c.transfact1##c.markettobooklag##1.hedgeindlag c.transfact2##c.markettobooklag##1.hedgeindlag c.transfact1##c.cashtoaslag##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.hedgeindlag c.transfact1##c.assetmat##1.hedgeindlag  c.transfact2##c.assetmat##1.hedgeindlag c.transfact1##c.reqtoaslag##1.hedgeindlag c.transfact2##c.reqtoaslag##1.hedgeindlag c.transfact1##c.divpersharelag##1.hedgeindlag c.transfact2##c.divpersharelag##1.hedgeindlag c.transfact1##c.cashtoaslag##1.hedgeindlag c.transfact2##c.cashtoaslag##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb8, tex replace  label dec(2)

*With bank debt leverage and excess return.
qui areg twodaypercprccd c.transfact1##c.newbankratiolag##1.hedgeindlag c.transfact2##c.newbankratiolag##1.hedgeindlag  c.transfact1##c.matvarasslag##1.hedgeindlag c.transfact2##c.matvarasslag##1.hedgeindlag  c.transfact1##c.matvarasslag##1.hedgeindlag c.transfact2##c.matvarasslag##1.hedgeindlag   c.transfact1##c.sizelag##1.hedgeindlag  c.transfact2##c.sizelag##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.hedgeindlag   c.transfact1##c.booklevlag##1.hedgeindlag c.transfact2##c.booklevlag##1.hedgeindlag  c.transfact1##c.markettobooklag##1.hedgeindlag c.transfact2##c.markettobooklag##1.hedgeindlag c.transfact1##c.cashtoaslag##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.hedgeindlag c.transfact1##c.assetmat##1.hedgeindlag  c.transfact2##c.assetmat##1.hedgeindlag c.transfact1##c.reqtoaslag##1.hedgeindlag c.transfact2##c.reqtoaslag##1.hedgeindlag c.transfact1##c.divpersharelag##1.hedgeindlag c.transfact2##c.divpersharelag##1.hedgeindlag c.transfact1##c.cashtoaslag##1.hedgeindlag c.transfact2##c.cashtoaslag##1.hedgeindlag twowinmkt, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb8, tex append label dec(2)

*With floating rate debt leverage and excess return.
qui areg twodaypercprccd c.transfact1##c.varlevorlag##1.hedgeindlag c.transfact2##c.varlevorlag##1.hedgeindlag  c.transfact1##c.matvarasslag##1.hedgeindlag c.transfact2##c.matvarasslag##1.hedgeindlag  c.transfact1##c.matvarasslag##1.hedgeindlag c.transfact2##c.matvarasslag##1.hedgeindlag   c.transfact1##c.sizelag##1.hedgeindlag  c.transfact2##c.sizelag##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.hedgeindlag   c.transfact1##c.booklevlag##1.hedgeindlag c.transfact2##c.booklevlag##1.hedgeindlag  c.transfact1##c.markettobooklag##1.hedgeindlag c.transfact2##c.markettobooklag##1.hedgeindlag c.transfact1##c.cashtoaslag##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.hedgeindlag c.transfact1##c.assetmat##1.hedgeindlag  c.transfact2##c.assetmat##1.hedgeindlag c.transfact1##c.reqtoaslag##1.hedgeindlag c.transfact2##c.reqtoaslag##1.hedgeindlag c.transfact1##c.divpersharelag##1.hedgeindlag c.transfact2##c.divpersharelag##1.hedgeindlag c.transfact1##c.cashtoaslag##1.hedgeindlag c.transfact2##c.cashtoaslag##1.hedgeindlag twowinmkt, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb8, tex append label dec(2)

*With floating rate debt leverage and Fama-French adjustments.
qui areg famadjret c.transfact1##c.varlevorlag##1.hedgeindlag c.transfact2##c.varlevorlag##1.hedgeindlag c.transfact1##c.matvarasslag##1.hedgeindlag c.transfact2##c.matvarasslag##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb8, tex append label dec(2)

*Table B-9:
clear
use baselinezlb

*Floating rate debt leverage.
qui areg twodaypercprccd c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact1##c.varlevorlag##1.hedgeindlag##1.zlbdummy c.transfact2##c.varlevorlag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.transfact1##c.booklevlag##1.zlbdummy##1.hedgeindlag c.transfact2##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact2##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact1##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.transfact1##c.assetmat##1.zlbdummy##1.hedgeindlag  c.transfact2##c.assetmat##1.zlbdummy##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb9, tex replace label dec(2)

*Bank debt leverage and excess return.
qui areg twodaypercprccd c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact1##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.transfact2##c.newbankratiolag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.transfact1##c.booklevlag##1.zlbdummy##1.hedgeindlag c.transfact2##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact2##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact1##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.transfact1##c.assetmat##1.zlbdummy##1.hedgeindlag  c.transfact2##c.assetmat##1.zlbdummy##1.hedgeindlag twowinmkt, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb9, tex append label dec(2)

*Floating rate debt leverage and excess return.
qui areg twodaypercprccd c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact1##c.varlevorlag##1.hedgeindlag##1.zlbdummy c.transfact2##c.varlevorlag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.transfact1##c.booklevlag##1.zlbdummy##1.hedgeindlag c.transfact2##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact2##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact1##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.transfact1##c.assetmat##1.zlbdummy##1.hedgeindlag  c.transfact2##c.assetmat##1.zlbdummy##1.hedgeindlag twowinmkt, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb9, tex append label dec(2)

*Bank debt leverage and Fama-French adjustments.
qui areg famadjret c.transfact1##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.transfact2##c.newbankratiolag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb9, tex append label dec(2)

*Bank debt leverage and Fama-French adjustments, with controls.
qui areg famadjret c.transfact1##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.transfact2##c.newbankratiolag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.transfact1##c.booklevlag##1.zlbdummy##1.hedgeindlag c.transfact2##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact2##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact1##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.transfact1##c.assetmat##1.zlbdummy##1.hedgeindlag  c.transfact2##c.assetmat##1.zlbdummy##1.hedgeindlag c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb9, tex append label dec(2)

*Floating rate debt and Fama-French adjustments, without controls.
qui areg famadjret c.transfact1##c.varlevorlag##1.hedgeindlag##1.zlbdummy c.transfact2##c.varlevorlag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy , absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb9, tex append label dec(2)

clear
use baselineWEzlb
*Quarterly exposure and quarterly leverage.
qui areg twodaypercprccd c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact1##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.transfact2##c.newbankratiolag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.transfact1##c.booklevlag##1.zlbdummy##1.hedgeindlag c.transfact2##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact2##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact1##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.transfact1##c.assetmat##1.zlbdummy##1.hedgeindlag  c.transfact2##c.assetmat##1.zlbdummy##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb9, tex append label dec(2)

*Table B-10:
clear
use baselinezlb

*One-day window.
qui areg percprccd c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact1##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.transfact2##c.newbankratiolag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.transfact1##c.booklevlag##1.zlbdummy##1.hedgeindlag c.transfact2##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact2##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact1##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.transfact1##c.assetmat##1.zlbdummy##1.hedgeindlag  c.transfact2##c.assetmat##1.zlbdummy##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb10, tex replace label dec(2)

*With S&P credit rating.
qui areg twodaypercprccd c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact1##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.transfact2##c.newbankratiolag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.transfact1##c.booklevlag##1.zlbdummy##1.hedgeindlag c.transfact2##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact2##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact1##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.transfact1##c.assetmat##1.zlbdummy##1.hedgeindlag  c.transfact2##c.assetmat##1.zlbdummy##1.hedgeindlag c.transfact1##i.sprating##1.hedgeindlag c.transfact2##i.sprating##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb10, tex append label dec(2)

*Fixed rate debt exposure.
qui areg twodaypercprccd c.transfact1##c.matfixasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matfixasslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact1##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.transfact2##c.newbankratiolag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.transfact1##c.booklevlag##1.zlbdummy##1.hedgeindlag c.transfact2##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact2##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact1##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.transfact1##c.assetmat##1.zlbdummy##1.hedgeindlag  c.transfact2##c.assetmat##1.zlbdummy##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb10, tex append label dec(2)

*Only scheduled FOMC meetings.
drop if intermeetdummy==1
qui areg twodaypercprccd c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact1##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.transfact2##c.newbankratiolag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.transfact1##c.booklevlag##1.zlbdummy##1.hedgeindlag c.transfact2##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact2##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact1##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.transfact1##c.assetmat##1.zlbdummy##1.hedgeindlag  c.transfact2##c.assetmat##1.zlbdummy##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb10, tex append label dec(2)

*Truncated debt maturity.
clear
use trunczlb
qui areg twodaypercprccd c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact1##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.transfact2##c.newbankratiolag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.transfact1##c.booklevlag##1.zlbdummy##1.hedgeindlag c.transfact2##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact2##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact1##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.transfact1##c.assetmat##1.zlbdummy##1.hedgeindlag  c.transfact2##c.assetmat##1.zlbdummy##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb10, tex append label dec(2)

*Longer path surprises.
clear
use longerpathzlb
qui areg twodaypercprccd c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact1##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.transfact2##c.newbankratiolag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.transfact1##c.booklevlag##1.zlbdummy##1.hedgeindlag c.transfact2##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact2##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact1##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.transfact1##c.assetmat##1.zlbdummy##1.hedgeindlag  c.transfact2##c.assetmat##1.zlbdummy##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb10, tex append label dec(2)

*Using only bank debt for constructing exposure.
clear
use onlybankzlb
qui areg twodaypercprccd c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact1##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.transfact2##c.newbankratiolag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.transfact1##c.booklevlag##1.zlbdummy##1.hedgeindlag c.transfact2##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact2##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact1##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.transfact1##c.assetmat##1.zlbdummy##1.hedgeindlag  c.transfact2##c.assetmat##1.zlbdummy##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb10, tex append  label dec(2)

*Table B-11:
clear
use baselinezlb

*Maturity based on known debt types.
qui areg twodaypercprccd c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact1##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.transfact2##c.newbankratiolag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact1##1.hedgeindlag##1.zlbdummy##c.matallassknowlag c.transfact2##1.hedgeindlag##1.zlbdummy##c.matallassknowlag c.transfact1##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.transfact1##c.booklevlag##1.zlbdummy##1.hedgeindlag c.transfact2##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact2##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact1##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.transfact1##c.assetmat##1.zlbdummy##1.hedgeindlag  c.transfact2##c.assetmat##1.zlbdummy##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb11, tex replace label dec(2)

*Maturity based on known debt types, with time fixed effects.
qui areg twodaypercprccd i.numstock c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact1##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.transfact2##c.newbankratiolag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact1##1.hedgeindlag##1.zlbdummy##c.matallassknowlag c.transfact2##1.hedgeindlag##1.zlbdummy##c.matallassknowlag c.transfact1##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.transfact1##c.booklevlag##1.zlbdummy##1.hedgeindlag c.transfact2##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact2##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact1##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.transfact1##c.assetmat##1.zlbdummy##1.hedgeindlag  c.transfact2##c.assetmat##1.zlbdummy##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb11, tex append label dec(2)

*Maturity based on all debt types.
qui areg twodaypercprccd  c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact1##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.transfact2##c.newbankratiolag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact1##1.hedgeindlag##1.zlbdummy##c.matallasslag c.transfact2##1.hedgeindlag##1.zlbdummy##c.matallasslag c.transfact1##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.transfact1##c.booklevlag##1.zlbdummy##1.hedgeindlag c.transfact2##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact2##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact1##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.transfact1##c.assetmat##1.zlbdummy##1.hedgeindlag  c.transfact2##c.assetmat##1.zlbdummy##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb11, tex append label dec(2)

*Maturity based on all debt types, with time fixed effects.
qui areg twodaypercprccd i.numstock c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact1##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.transfact2##c.newbankratiolag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact1##1.hedgeindlag##1.zlbdummy##c.matallasslag c.transfact2##1.hedgeindlag##1.zlbdummy##c.matallasslag c.transfact1##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.transfact1##c.booklevlag##1.zlbdummy##1.hedgeindlag c.transfact2##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact2##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact1##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.transfact1##c.assetmat##1.zlbdummy##1.hedgeindlag  c.transfact2##c.assetmat##1.zlbdummy##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb11, tex append label dec(2)

*Simple average maturity.
qui areg twodaypercprccd c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact1##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.transfact2##c.newbankratiolag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact1##1.hedgeindlag##1.zlbdummy##c.avrmatlag c.transfact2##1.hedgeindlag##1.zlbdummy##c.avrmatlag c.transfact1##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.transfact1##c.booklevlag##1.zlbdummy##1.hedgeindlag c.transfact2##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact2##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact1##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.transfact1##c.assetmat##1.zlbdummy##1.hedgeindlag  c.transfact2##c.assetmat##1.zlbdummy##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb11, tex append label dec(2)

*Simple average maturity, with time fixed effects.
qui areg twodaypercprccd i.numstock c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact1##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.transfact2##c.newbankratiolag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact1##1.hedgeindlag##1.zlbdummy##c.avrmatlag c.transfact2##1.hedgeindlag##1.zlbdummy##c.avrmatlag c.transfact1##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.transfact1##c.booklevlag##1.zlbdummy##1.hedgeindlag c.transfact2##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact2##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact1##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.transfact1##c.assetmat##1.zlbdummy##1.hedgeindlag  c.transfact2##c.assetmat##1.zlbdummy##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb11, tex append label dec(2)

*Table B-12:
clear
use baselinezlb

*IV regression.
ivreghdfe twodaypercprccd transfact1 transfact2  c.transfact1#c.assetmat c.transfact2#c.assetmat assetmat c.transfact1#c.sizelag  c.transfact2#c.sizelag sizelag c.transfact1#c.profitabilitylag  c.transfact2#c.profitabilitylag profitabilitylag   c.transfact1#c.booklevlag c.transfact2#c.booklevlag booklevlag c.transfact1#c.markettobooklag c.transfact2#c.markettobooklag markettobooklag c.transfact1#c.cashtoaslag  c.transfact2#c.cashtoaslag cashtoaslag c.transfact1#c.reqtoaslag c.transfact2#c.reqtoaslag reqtoaslag c.transfact1#c.divpersharelag c.transfact2#c.divpersharelag divpersharelag (matvarasslag c.transfact1#c.matvarasslag c.transfact2#c.matvarasslag = matvarasslag15 c.transfact1#c.matvarasslag15 c.transfact2#c.matvarasslag15) , absorb(gvkey)
outreg2 using tableb12, tex replace label dec(2)

*The first stage of the IV regression above.
gen tarexp=transfact1*matvarasslag 
gen pathexp=transfact2*matvarasslag
gen tarexplag=transfact1*matvarasslag15 
gen pathexplag=transfact2*matvarasslag15
ivreghdfe twodaypercprccd transfact1 transfact2  c.transfact1#c.assetmat c.transfact2#c.assetmat assetmat c.transfact1#c.sizelag  c.transfact2#c.sizelag sizelag c.transfact1#c.profitabilitylag  c.transfact2#c.profitabilitylag profitabilitylag   c.transfact1#c.booklevlag c.transfact2#c.booklevlag booklevlag c.transfact1#c.markettobooklag c.transfact2#c.markettobooklag markettobooklag c.transfact1#c.cashtoaslag  c.transfact2#c.cashtoaslag cashtoaslag c.transfact1#c.reqtoaslag c.transfact2#c.reqtoaslag reqtoaslag c.transfact1#c.divpersharelag c.transfact2#c.divpersharelag divpersharelag (matvarasslag tarexp pathexp = matvarasslag15 tarexplag pathexplag), first absorb(gvkey)

*Table B-13:
clear 
use placeboprezlb

*Pre-ZLB, bank debt leverage.
qui areg twodaypercprccd c.transfact1##c.newbankratiolag##1.hedgeindlag c.transfact2##c.newbankratiolag##1.hedgeindlag   c.transfact1##c.matvarasslag##1.hedgeindlag c.transfact2##c.matvarasslag##1.hedgeindlag  c.transfact1##c.sizelag##1.hedgeindlag  c.transfact2##c.sizelag##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.hedgeindlag   c.transfact1##c.booklevlag##1.hedgeindlag c.transfact2##c.booklevlag##1.hedgeindlag  c.transfact1##c.markettobooklag##1.hedgeindlag c.transfact2##c.markettobooklag##1.hedgeindlag c.transfact1##c.cashtoaslag##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.hedgeindlag c.transfact1##c.assetmat##1.hedgeindlag  c.transfact2##c.assetmat##1.hedgeindlag c.transfact1##c.reqtoaslag##1.hedgeindlag c.transfact2##c.reqtoaslag##1.hedgeindlag c.transfact1##c.divpersharelag##1.hedgeindlag c.transfact2##c.divpersharelag##1.hedgeindlag c.transfact1##c.cashtoaslag##1.hedgeindlag c.transfact2##c.cashtoaslag##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb13, tex replace label dec(2)

*Pre-ZLB, floating rate debt leverage.
qui areg twodaypercprccd  c.transfact1##c.varlevorlag##1.hedgeindlag c.transfact2##c.varlevorlag##1.hedgeindlag   c.transfact1##c.matvarasslag##1.hedgeindlag c.transfact2##c.matvarasslag##1.hedgeindlag   c.transfact1##c.sizelag##1.hedgeindlag  c.transfact2##c.sizelag##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.hedgeindlag   c.transfact1##c.booklevlag##1.hedgeindlag c.transfact2##c.booklevlag##1.hedgeindlag  c.transfact1##c.markettobooklag##1.hedgeindlag c.transfact2##c.markettobooklag##1.hedgeindlag c.transfact1##c.cashtoaslag##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.hedgeindlag c.transfact1##c.assetmat##1.hedgeindlag  c.transfact2##c.assetmat##1.hedgeindlag c.transfact1##c.reqtoaslag##1.hedgeindlag c.transfact2##c.reqtoaslag##1.hedgeindlag c.transfact1##c.divpersharelag##1.hedgeindlag c.transfact2##c.divpersharelag##1.hedgeindlag c.transfact1##c.cashtoaslag##1.hedgeindlag c.transfact2##c.cashtoaslag##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb13, tex append label dec(2)

clear 
use placebozlb

*Full sample, bank debt leverage.
qui areg twodaypercprccd  c.transfact1##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.transfact2##c.newbankratiolag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.transfact1##c.booklevlag##1.zlbdummy##1.hedgeindlag c.transfact2##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact2##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact1##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.transfact1##c.assetmat##1.zlbdummy##1.hedgeindlag  c.transfact2##c.assetmat##1.zlbdummy##1.hedgeindlag c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb13, tex append label dec(2)

*Full sample, floating rate debt leverage.
qui areg twodaypercprccd  c.transfact1##c.varlevorlag##1.hedgeindlag##1.zlbdummy c.transfact2##c.varlevorlag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.transfact1##c.booklevlag##1.zlbdummy##1.hedgeindlag c.transfact2##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact2##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact1##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.transfact1##c.assetmat##1.zlbdummy##1.hedgeindlag  c.transfact2##c.assetmat##1.zlbdummy##1.hedgeindlag c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy, absorb(gvkey) vce(cluster numstock) 
outreg2 using tableb13, tex append label dec(2)
