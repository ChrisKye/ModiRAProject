*** The construction of the hedging indicator ***

We downloaded 10-K and 10-Q filings for our sample firms from the US Securities and Exchange Commission website (https://www.sec.gov/edgar/searchedgar/companysearch.html; at times we turned to other sources due to technical reasons, including company websites). We verified manually that each filing is correctly downloaded. 

We read through a lot of these filings to come up with the phrases for constructing a binary hedging indicator (equal to 1 if a firm hedges against interest rate risks of floating rate obligations; more on this below). The resulting data is provided in "hedgedata.xls." 

a. The first column contains gvkeys for our sample firms.

b. The second column includes the initial company name, and the third column the latest company name if the name changed during our sample period. 

c. The entry under the fourth column is equal to 1 if there is a need to check the company filings more carefully, for instance due to split-ups, mergers and acquisitions, delisting, etc. during our sample period.

d. The fifth column contains the filing date and the sixth column the filing type (10-K or 10-Q; if one were interested in constructing an annual hedging indicator, one may use only 10-K filings; our quarterly hedging indicator uses both filing types). 

e. The seventh column provides a hedging indicator that is equal to 1 if a filing contains phrases related to interest rate risk hedging. This checks only for positives.  

f. The last column gives a hedging indicator that additionally controls for false positives (a hedging indicator is equal to 0 if a filing contains these phrases). This is used for our empirical analysis.


Now, we turn to the list of positive and false positive phrases: 

* Positive phrases: 
'hedge against interest rate'
'hedges against interest rate'
'hedging against interest rate'
'hedge interest rate'
'hedges interest rate'
'hedging interest rate'
'hedge for interest rate'
'hedges for interest rate'
'hedging for interest rate'
'hedging of interest rate'
'interest rate hedge'
'interest rate hedging'
'interest rate risk hedge'
'interest rate risk hedging'
'interest rate derivative'
'interest rate swap'
'interest rate contract'
'interest rate agreement'
'interest rate collar'
'interest rate cap'

* False positive phrases: 
'not used any interest rate'
'not use any interest rate'
'not using any interest rate'
'not used interest rate'
'not use interest rate'
'not using interest rate'
'not used an interest rate'
'not use an interest rate'
'not using an interest rate'
'not currently use any interest rate'
'not currently using any interest rate'
'not currently use interest rate'
'not currently using interest rate'
'not currently use an interest rate'
'not currently using an interest rate'
'currently no interest rate'
'not hedged against any interest rate'
'not hedge against any interest rate'
'not hedging against any interest rate'
'not hedged against interest rate'
'not hedge against interest rate'
'not hedging against interest rate'
'not hedged any interest rate'
'not hedge any interest rate'
'not hedging any interest rate'
'not hedged interest rate'
'not hedge interest rate'
'not hedging interest rate'
'not enter into any interest rate'
'not enter into interest rate'
'not enter into an interest rate'
'not engaged in any interest rate'
'not engage in any interest rate'
'not engaged in interest rate'
'not engage in interest rate'
'not use derivative financial instruments as a hedge against interest rate'
'termination of interest rate'
'fixed to variable interest rate'
'fixed to floating interest rate'
'fixed rate debt to variable rate'
'fixed rate debt to floating rate'
'fixed to variable rate interest rate'
'fixed to floating rate interest rate'
'fixed rate to variable rate'
'fixed rate to floating rate'
'fixed rates to variable rates'
'fixed rates to floating rates'
'fixed rate into variable rate'
'fixed rate into floating rate'
'fixed rates into variable rates'
'fixed rates into floating rates'
'fixed rate obligations to variable rate obligations'
'fixed rate obligations to floating rate obligations'
'a fixed rate to a variable rate'
'a fixed rate to a floating rate'
'fixed to floating swap'
'not engaged in hedge transactions such as interest rate futures contracts or interest rate swap'
'not enter into derivative transactions or speculate on the future direction of interest rate'
'not use derivative financial instruments such as interest rate swap'
'not entered into any swap agreement'
'not have any interest rate swap'
'not have interest rate swap'
'not have an interest rate swap'
'had no interest rate swap'
'not currently hedge or otherwise use derivative instruments to manage interest rate'
'not attempt to reduce or eliminate our exposure to interest rate risk through the use of derivative financial instrument'
'enter into variable interest rate swaps effectively converting fixed rate borrowings to variable rate'
'not designate the interest rate swap as a cash flow hedge and the interest rate swap will not qualify for hedge accounting'
'not participate in hedging programs interest rate swaps or other activities involving the use of derivative financial instruments to manage interest rate risk'
'may use interest rate swaps to balance exposure to interest rate'
'in the future we may enter into interest rate swap'
'may also enter into derivative financial instruments such as interest rate swap'
'may enter into interest rate hedging agreements in the future to mitigate our exposure to interest rate risk'
'may enter into interest rate swaps involving the exchange of floating for fixed rate interest payments'
'swap agreements to hedge a portion of the consolidated interest rate risk associated with issuances of fixed rate'
'fixed rate receipts in exchange for making floating rate payments'
'fixed rate amounts in exchange for making floating rate payments'
'manage interest rate risk related to fixed rate borrowing'
'not have any derivative instruments outstanding'
'swaps changed the fixed rate exposure on the debt to variable'
'terminated all of its interest rate swap agreements'
'swap long term borrowings at fixed rates into variable rates'
'we pay variable rates and we receive a fixed rate'
'exchange an obligation to make fixed debt payments for an obligation to make floating rate payments',...
'were no interest rate swap agreements'
'were no interest rate swaps outstanding'
'receives fixed interest rate payments and makes variable interest rate payments'
'receive fixed pay variable interest rate'
'receive fixed pay floating interest rate'
'swapped the fixed rate to a variable rate'
'will receive fixed interest rate payments and will make variable interest rate payments'
'not use derivative financial instruments to manage interest rate risk'
'not currently use derivative financial instruments to manage interest rate risk'


It is possible to introduce further enhancements to the procedure above such as additionally controlling for cross currency swaps, but our empirical results do not change under this more complicated construction. And this increases the risk of misclassification (which we tested by comparing our judgment from reading the filings to the outcomes of various procedures).
