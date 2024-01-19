* 4000_Censo2023_EML2021_readytoCensusEB.do


****************************************************************************************************
* Checking no missings in the relevant variables
use "${dta}1900_Censo2023_Consolidando.dta", clear
	count	//	1,230,757
	misstable summarize H_* C_* F_* D_*
	unique codePDCAVH		//	1,230,757 ok!
	
use "${dta}2900_EML2021_Consolidando.dta", clear
	count	// 11,148
	misstable summarize  H_* C_* F_* D_*
	unique codePDCAVH		//	11148 ok!
****************************************************************************************************

	
	


****************************************************************************************************
* APPENDING THE HIES AND CENSUS
use "${dta}2900_EML2021_Consolidando.dta", clear

	lnskew0w 	double   lnskewy =    ipcf , weight($popwt)
	bcskew0 	double   bcy     =    ipcf

	regress lnskewy 				 
	regress lnskewy H_* F_* C_* D_*  [aw=popwt], notable 							// 	R2A = 0.6796

*---------------------------------------------------------------------------------------------------
use 			"${dta}2900_EML2021_Consolidando.dta", clear	
append using 	"${dta}1900_Censo2023_Consolidando.dta", gen (censo)
	drop if H_ncuartos==.

	lab def censo 0 "EML2021" 1 "Censo2023" 
	lab val censo censo
	tab censo
		//     Dataset |
		//      source |      Freq.     Percent        Cum.
		// ------------+-----------------------------------
		//     EML2021 |     11,148        0.90        0.90
		//   Censo2023 |  1,230,757       99.10      100.00
		// ------------+-----------------------------------
		//       Total |  1,241,905      100.00
	tab codeP, gen(P)
	lnskew0w 	double   lnskewy =    ipcf , weight($popwt)
	bcskew0 	double   bcy     =    ipcf
	gen 		double 	lnipcf	=  ln(ipcf)
	
// 	gen 	plinevar = 6.85
// 	replace plinevar = 6.85*22.7495

	gen 	plinevar = .
	* Matching urban poverty
	replace plinevar = 144.22*1.093*1.005  	if R==0
	povdeco	ipcf [aw=popwt]          		if R==0, varpline(plinevar)		//	0.13918
	replace plinevar = 108.24*1.382*1.005	if R==1
	povdeco	ipcf [aw=popwt]          		if R==1, varpline(plinevar)		//	0.40792
	povdeco	ipcf [aw=popwt], varpline(plinevar)								//	0.21671
	
	
	gen 	extplvar =  .
	replace extplvar =  70.49*1.175 if R==0
	povdeco	ipcf [aw=popwt]          		if R==0, varpline(extplvar)		//	0.03207
	replace extplvar =  60.17*1.598 if R==1
	povdeco	ipcf [aw=popwt]          		if R==1, varpline(extplvar)		//	0.24210
	povdeco	ipcf [aw=popwt], varpline(extplvar)								//	0.09266
	
	gen zeroes = 0
	order 			H_* F_* C_* D_* , last
	misstable sum 	H_* F_* C_* D_*  
	sum   			H_* F_* C_* D_* 
	
save "${dta}4000_Censo2023_EML2021_readytoCensusEB.dta", replace		// This is the data set before filtering
*---------------------------------------------------------------------------------------------------
use "${dta}4000_Censo2023_EML2021_readytoCensusEB.dta", clear	
codebook	plinevar
unique codePDCAVH if censo==1	//	1230757 ok!
unique codePDCAVH if censo==0	//	  11148 ok!

use "${dta}4000_Censo2023_EML2021_readytoCensusEB.dta", clear
unique codePDC if censo==1	//	699
unique codePDC if censo==0	//	493



use "${dta}4000_Censo2023_EML2021_readytoCensusEB.dta", clear
	keep if censo==0
	gen one=1
	collapse (sum) one,by(codePDC)
	gen censo=0
tempfile encuesta
save 	`encuesta'
use "${dta}4000_Censo2023_EML2021_readytoCensusEB.dta", clear
	keep if censo==1
	gen one=1
	collapse (sum) one,by(codePDC)
	gen censo=1
merge 1:1 codePDC using `encuesta'
	keep if _m==2
	keep codePDC
	gen paraborrar=1
save "${dta}4000_paraborrar.dta", replace

dir 	"${censo2023}stata/"
use "${censo2023}stata/CEN2023_PROVINCIA.dta", clear
use "${censo2023}stata/CEN2023_DISTRITO.dta", clear
use "${censo2023}stata/CEN2023_CORREG.dta", clear






