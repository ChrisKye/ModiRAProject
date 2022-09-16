***This file produces remaining tables and figures in the paper.
*This requires access to CRSP, Compustat, and CIQ to work.

cd "C:\Users\gokce\Desktop\referee report\update paper"

clear
clear all

*** Tables

*Table 1:
clear
use baselinezlb
gen xx=0
qui areg twodaypercprccd c.transfact1##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.reqtoaslag##1.hedgeindlag##1.zlbdummy c.transfact1##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact2##c.divpersharelag##1.hedgeindlag##1.zlbdummy c.transfact1##c.newbankratiolag##1.hedgeindlag##1.zlbdummy c.transfact2##c.newbankratiolag##1.hedgeindlag##1.zlbdummy   c.transfact1##c.matvarasslag##1.hedgeindlag##1.zlbdummy c.transfact2##c.matvarasslag##1.hedgeindlag##1.zlbdummy  c.transfact1##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.sizelag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.profitabilitylag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.profitabilitylag##1.zlbdummy##1.hedgeindlag   c.transfact1##c.booklevlag##1.zlbdummy##1.hedgeindlag c.transfact2##c.booklevlag##1.zlbdummy##1.hedgeindlag  c.transfact1##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact2##c.markettobooklag##1.zlbdummy##1.hedgeindlag c.transfact1##c.cashtoaslag##1.zlbdummy##1.hedgeindlag  c.transfact2##c.cashtoaslag##1.zlbdummy##1.hedgeindlag c.transfact1##c.assetmat##1.zlbdummy##1.hedgeindlag  c.transfact2##c.assetmat##1.zlbdummy##1.hedgeindlag, absorb(gvkey) vce(cluster numstock) 
replace xx=1 if e(sample)
keep if xx==1
gen short=(dlcq)/(atq)
eststo clear
estpost tabstat matvarasslag newbankratiolag varlevorlag sizelag booklevlag markettobooklag profitabilitylag assetmat  cashtoaslag reqtoaslag divpersharelag short hedgeindlag, statistics(mean sd) columns(statistics) by(hedgeindlag)
est store bb
esttab bb using desrint.tex, cells("mean(fmt(2)) sd(fmt(2))") unstack label varlabels(`e(labels)') replace 
eststo clear 

*Table B1:
clear
clear all
use datmatwegbase
eststo clear
estpost tab descriptiontext, sort label
est store zz
esttab zz using desr.tex, replace varlabels(`e(labels)') cells("b pct(fmt(2)) cumpct(fmt(2))")
eststo clear 

*Table B2:
eststo clear
estpost tab descriptiontext if !mi(variable), sort label
est store zz2
esttab zz2 using desrvar.tex, replace varlabels(`e(labels)') cells("b pct(fmt(2)) cumpct(fmt(2))")
esttab zz2 using desrvar.rtf, replace varlabels(`e(labels)') cells("b pct(fmt(2)) cumpct(fmt(2))")
eststo clear

*Table B3:
*We need deflated dataitemvalue for this.
estpost tabstat dataitemvalue_def if !mi(variable), statistics("mean sd") columns(statistics) by(descriptiontext)
est store dd
esttab dd using desrintmeanvar.tex, ar2 cells("mean(fmt(2)) sd(fmt(2))") unstack label varlabels(`e(labels)') replace 
esttab dd using desrintmeanvar.rtf, ar2 cells("mean(fmt(2)) sd(fmt(2))") unstack label varlabels(`e(labels)') replace 
eststo clear 

*Table B4:
latab matstr interestratetypeid
eststo clear

*Table B5:
estpost tabstat dataitemvalue_def, statistics("mean sd") columns(statistics) by(matstr)
est store dd
esttab dd using desrintmeanmat.tex, ar2 cells("mean(fmt(2)) sd(fmt(2))") unstack label varlabels(`e(labels)') replace 
esttab dd using desrintmeanmat.rtf, ar2 cells("mean(fmt(2)) sd(fmt(2))") unstack label varlabels(`e(labels)') replace 
eststo clear 

*** Figures

clear
clear all
use large
merge 1:1 datedaily using datsurprisewithpath
keep if _merge==3
replace percsp500=percsp500*100
replace kuttner=kuttner/100
*edi datedaily kuttner transfact1 transfact2 percsp500twoday percsp500 if ddate>=tm(2004,1) & ddate<tm(2015,1)
rename transfact2 path
rename transfact1 target
label var percsp500 "Change in S&P 500" 
label var kuttner "Kuttner Surprises"
label var target "Target Surprises"
label var path "Path Surprises"

*Figure 1:
twoway scatter percsp500 kuttner if ddate>=tm(2004,1) & ddate<tm(2009,1) || lfit percsp500 kuttner , ytitle("Change in S&P500") xlabel(-0.7 (0.3) 0.2) ylabel(-9.4 (3) 5.6) yla(, format(%9.1f)) xla(, format(%9.1f))

*Figures 2a and 2b:
twoway scatter percsp500 target if ddate>=tm(2004,1) & ddate<tm(2019,1) || lfit percsp500 target, ytitle("Change in S&P500") xlabel(-0.5 (0.2) 0.2) ylabel(-9.4 (3) 5.6) yla(, format(%9.1f)) xla(, format(%9.1f))

twoway scatter percsp500 path if ddate>=tm(2004,1) & ddate<tm(2019,1) || lfit percsp500 path , ytitle("Change in S&P500") xlabel(-0.7 (0.5) 1.2) ylabel(-9.4 (3) 5.6) yla(, format(%9.1f)) xla(, format(%9.1f))

clear
clear all
use quarterlyfirmlevel

label var matvarass "Floating Rate Exposure"
label var varlevor "Floating Rate Leverage"
label var newbankratio "Bank Debt Leverage"

*Figure 3:
twoway scatter varlevor newbankratio if varlevor<5 || lfit varlevor newbankratio if varlevor<5,ytitle(Floating Rate Debt Leverage) xlabel(0 (0.3) 1.5) ylabel(0 (0.3) 1.5) yla(, format(%9.1f)) xla(, format(%9.1f)) 

*Figure 4:
twoway scatter matvarass newbankratio if matvarass<10 || lfit matvarass newbankratio if matvarass<10 ,ytitle(Floating Rate Exposure) xlabel(0 (0.3) 1.5) ylabel(0 (3) 12) yla(, format(%9.1f)) xla(, format(%9.1f))

*Figure 5:
xtile bank1ratioxtiles = newbankratio , n(10)
graph bar (mean) matvarass if matvarass<10 & varlevor<5, over(bank1ratioxtiles) ytitle("Floating Rate Exposure") blabel(bar, format(%4.2f))

*For the numbers above the bars, edit them manually with the numbers you obtained from below:
su newbankratio if bank1ratioxtiles==1
su newbankratio if bank1ratioxtiles==2
su newbankratio if bank1ratioxtiles==3
su newbankratio if bank1ratioxtiles==4
su newbankratio if bank1ratioxtiles==5
su newbankratio if bank1ratioxtiles==6
su newbankratio if bank1ratioxtiles==7
su newbankratio if bank1ratioxtiles==8
su newbankratio if bank1ratioxtiles==9
su newbankratio if bank1ratioxtiles==10

*Figure 6:
clear
clear all
use handson2hedge2
*To be consistent with the figures in the earlier draft of the paper, drop S&P500 entrants after 2015.
drop if fromdate>=tm(2015,1)
su matvarasslag, d

xtile expxtiles = matvarasslag if !mi(matvarasslag), n(100)
drop if expxtiles<=33

label var matvarasslag "Floating Rate Exposure"
label var twodaypercprccd "Stock Return"

gen dumm=0
replace dumm=1 if !mi(twodaypercprccd) & !mi(matvarasslag) & !mi(newbankratiolag) & !mi(sizelag) & !mi(profitabilitylag) & !mi(booklevlag) & !mi(markettobooklag) & !mi(assetmat) & !mi(cashtoaslag) & !mi(reqtoaslag) & !mi(divpersharelag)

*3.28.2006
*For exposure.
drop if matvarasslag>4

qui reg twodaypercprccd newbankratiolag sizelag profitabilitylag booklevlag markettobooklag cashtoaslag reqtoaslag assetmat divpersharelag if dumm==1 & datedaily==mdy(3,28,2006) & hedgeindlag==0 
predict unexplained if e(sample), residuals

qui reg matvarasslag newbankratiolag sizelag profitabilitylag booklevlag markettobooklag cashtoaslag reqtoaslag assetmat divpersharelag if dumm==1 & datedaily==mdy(3,28,2006) & hedgeindlag==0 
predict exposure if e(sample), residuals

*For leverage.
qui reg twodaypercprccd matvarasslag sizelag  profitabilitylag booklevlag markettobooklag cashtoaslag reqtoaslag assetmat divpersharelag if dumm==1 & datedaily==mdy(3,28,2006) & hedgeindlag==0 
predict unexplained_two if e(sample), residuals

qui reg newbankratiolag matvarasslag sizelag profitabilitylag booklevlag markettobooklag cashtoaslag reqtoaslag assetmat divpersharelag if dumm==1 & datedaily==mdy(3,28,2006) & hedgeindlag==0 
predict leverage if e(sample), residuals

*Both on the same graph.
twoway (scatter unexplained exposure, msymbol(T) mcolor(red)) ///
       (scatter unexplained_two leverage, msymbol(S) mcolor(blue)) ///
	   (lfit unexplained exposure),  ///
	   legend(label(1 "Exposure") label(2 "Leverage")) ///
       legend(label(3 "Linear Fit"))  ///
       legend(order(1 3 2)) ytitle(Stock Return) xtitle(Floating Rate Exposure and Leverage) xlabel(,grid) xlabel(minmax) ylabel(minmax) yla(, format(%9.1f)) xla(, format(%9.1f))
    
correl unexplained exposure if dumm==1 & datedaily==mdy(3,28,2006) & hedgeindlag==0

correl unexplained_two leverage if dumm==1 & datedaily==mdy(3,28,2006) & hedgeindlag==0

clear
clear all
use handson2hedge2
drop if fromdate>=tm(2015,1)
su matvarasslag, d

xtile expxtiles = matvarasslag if !mi(matvarasslag), n(100)
drop if expxtiles<=33

label var matvarasslag "Floating Rate Exposure"
label var twodaypercprccd "Stock Return"

gen dumm=0
replace dumm=1 if !mi(twodaypercprccd) & !mi(matvarasslag) & !mi(newbankratiolag) & !mi(sizelag) & !mi(profitabilitylag) & !mi(booklevlag) & !mi(markettobooklag) & !mi(assetmat) & !mi(cashtoaslag) & !mi(reqtoaslag) & !mi(divpersharelag)

*8.8.2006
*For exposure.
qui reg twodaypercprccd newbankratiolag sizelag profitabilitylag booklevlag markettobooklag cashtoaslag reqtoaslag assetmat divpersharelag if dumm==1 & datedaily==mdy(8,8,2006) & hedgeindlag==0 
predict unexplained if e(sample), residuals

qui reg matvarasslag newbankratiolag sizelag profitabilitylag booklevlag markettobooklag cashtoaslag reqtoaslag assetmat divpersharelag if dumm==1 & datedaily==mdy(8,8,2006) & hedgeindlag==0 
predict exposure if e(sample), residuals

*For leverage.
qui reg twodaypercprccd matvarasslag sizelag profitabilitylag booklevlag markettobooklag cashtoaslag reqtoaslag assetmat divpersharelag if dumm==1 & datedaily==mdy(8,8,2006) & hedgeindlag==0 
predict unexplained_two if e(sample), residuals

qui reg newbankratiolag matvarasslag sizelag profitabilitylag booklevlag markettobooklag cashtoaslag reqtoaslag assetmat divpersharelag if dumm==1 & datedaily==mdy(8,8,2006) & hedgeindlag==0 
predict leverage if e(sample), residuals

*Both on the same graph.
twoway (scatter unexplained exposure, msymbol(T) mcolor(red)) ///
       (scatter unexplained_two leverage, msymbol(S) mcolor(blue)) ///
	   (lfit unexplained exposure),  ///
	   legend(label(1 "Exposure") label(2 "Leverage")) ///
       legend(label(3 "Linear Fit"))  ///
       legend(order(1 3 2)) ytitle(Stock Return) xtitle(Floating Rate Exposure and Leverage) xlabel(,grid) xlabel(minmax) ylabel(minmax) yla(, format(%9.1f)) xla(, format(%9.1f))
   	     
correl unexplained exposure if dumm==1 & datedaily==mdy(8,8,2006) & hedgeindlag==0

correl unexplained_two leverage if dumm==1 & datedaily==mdy(8,8,2006) & hedgeindlag==0
	