* 1010_Censo2023_CodigosUnicos.do


*---------------------------------------------------------------------------------------------------
use "${censo2023}stata/CEN2023_VIVIENDA.dta", clear
	unique LLAVEVIV		//	1595492
	codebook PROVINCIA DISTRITO CORREG AREA LUGAR_POB BARRIADA	// no missing 
	tab PROVINCIA, m	// No missings, 1 to 13		--->	2 digits
	tab DISTRITO, m		// No missings, 1 to 14		--->	2 digits
	tab CORREG, m		// No missings, 1 to 26		--->	2 digits
	tab AREA, m			// No missing,  1 and 2		--->	1 digit
	tab LUGAR_POB, m	// No missing,  1 and 278	--->	3 digits
	tab BARRIADA, m		// No missing,  1 and 162	--->	3 digits
	unique PROVINCIA 													// 13
	unique PROVINCIA DISTRITO											// 82
	unique PROVINCIA DISTRITO CORREG									// 699
	unique PROVINCIA DISTRITO CORREG AREA								// 834
	tab AREA, m
	* Creating the 
	gen codeP 		= PROVINCIA
	gen codePD 		= PROVINCIA + DISTRITO
	gen codePDC 	= PROVINCIA + DISTRITO + CORREG
	gen codePDCA 	= PROVINCIA + DISTRITO + CORREG + AREA
	gsort  codePDCA LUGAR_POB BARRIADA LLAVEVIV
	bysort codePDCA: gen corviv = _n
	sum corviv	// max 32582
	gen  PDCAV	= strofreal(corviv ,"%05.0f")
	gen codePDCAV = codePDCA + PDCAV
	keep LLAVEVIV codeP codePD codePDC codePDCA codePDCAV
save "${dta}Vivienda_PDCAV.dta", replace
*---------------------------------------------------------------------------------------------------	
use "${censo2023}stata/CEN2023_HOGAR.dta", clear
	unique LLAVEVIV HOGAR  	//	1230757
	tab HOGAR, m	// No missing,  1 to 9		--->	1
merge m:1 LLAVEVIV using "${dta}Vivienda_PDCAV.dta"
	keep if _m==3
	gen codePDCAVH = codePDCAV + HOGAR
	keep LLAVEVIV HOGAR codeP codePD codePDC codePDCA codePDCAV codePDCAVH 
save "${dta}Hogar_PDCAVH.dta", replace
*---------------------------------------------------------------------------------------------------	
use "${censo2023}stata/CEN2023_PERSONA.dta", clear
	unique LLAVEVIV HOGAR  NPERSONA	//	4064780 ok
merge m:1 LLAVEVIV HOGAR using "${dta}Hogar_PDCAVH.dta"
	tab NPERSONA, m		//	 no missing 1 to 98
	gen  P	= strofreal(NPERSONA ,"%02.0f")
	gen codePDCAVHP = codePDCAVH + P
	keep LLAVEVIV HOGAR NPERSONA codeP codePD codePDC codePDCA codePDCAV codePDCAVH codePDCAVHP
save "${dta}Persona_PDCAVHP.dta", replace
*---------------------------------------------------------------------------------------------------
use "${dta}Persona_PDCAVHP.dta", clear
	destring codeP codePD codePDC codePDCA codePDCAV codePDCAVH codePDCAVHP, replace
	format codePDCAV	%12.0f
	format codePDCAVH	%13.0f
	format codePDCAVHP	%15.0f
	unique codePDCAVHP
save "${dta}1010_Persona_PDCAVHP.dta", replace
*---------------------------------------------------------------------------------------------------
use "${dta}Hogar_PDCAVH.dta", clear
	destring codeP codePD codePDC codePDCA codePDCAV codePDCAVH , replace
	format codePDCAV	%11.0f
	format codePDCAVH	%12.0f
	unique codePDCAVH
save "${dta}1010_Hogar_PDCAVH.dta", replace
*---------------------------------------------------------------------------------------------------
use "${dta}Vivienda_PDCAV.dta", clear
	destring codeP codePD codePDC codePDCA codePDCAV , replace
	format codePDCAV	%11.0f
	unique codePDCAV
save "${dta}1010_Vivienda_PDCAV.dta", replace
*---------------------------------------------------------------------------------------------------
erase "${dta}Vivienda_PDCAV.dta"
erase "${dta}Hogar_PDCAVH.dta"
erase "${dta}Persona_PDCAVHP.dta"
*---------------------------------------------------------------------------------------------------
* Checking all is ok:
use "${dta}1010_Persona_PDCAVHP.dta", clear
	unique codePDCAVHP	//	4064780 of 4064780
	unique codePDCAVH	//	1230757 of 4064780
	unique codePDCAV	//	1208283 of 4064780
	unique codePDCA		//	    832 of 4064780
	unique codePDC		//	    699 of 4064780
	unique codePD		//	     82 of 4064780
	unique codeP		//	     13 of 4064780

use "${dta}1010_Hogar_PDCAVH.dta", clear
	unique codePDCAVH	//	1230757 of 1230757
	unique codePDCAV	//	1208283 of 1230757
	unique codePDCA		//	    832 of 1230757
	unique codePDC		//	    699 of 1230757
	unique codePD		//	     82 of 1230757
	unique codeP		//	     13 of 1230757
	
use "${dta}1010_Vivienda_PDCAV.dta", clear
	unique codePDCAV	//	1208283 of 1208283
	unique codePDCA		//	    832 of 1208283
	unique codePDC		//	    699 of 1208283
	unique codePD		//	     82 of 1208283
	unique codeP		//	     13 of 1208283
*---------------------------------------------------------------------------------------------------

