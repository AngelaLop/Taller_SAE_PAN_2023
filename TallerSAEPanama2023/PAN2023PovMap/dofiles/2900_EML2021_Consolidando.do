* 2900_EML2021_Consolidando.do

****************************************************************************************************
use "${dta}2010_Hogar_PDCAVH.dta", clear
merge 1:1 codePDCAVH using "${dta}2010_EML2021_CodigosUnicos.dta", nogen
merge m:1 llave_sec using "${dta}2100_EML2021_Vivienda.dta"
	keep if _m==3
	drop _m
merge m:1 llave_sec hogar using "${dta}2200_EML2021_Durables.dta"
	keep if _m==3
	drop _m
merge m:1 llave_sec hogar using "${dta}2700_EML2021_Jefe.dta"		
	keep if _m==3
	drop _m	
merge m:1 llave_sec hogar using "${dta}2800_EML2021_Familia.dta"	
	keep if _m==3
	drop _m
*----------------------------------------------------
	gen popwt = pondera*miembros
	gen  R= codePDCA-10*codePDC ==2
	tab R [aw=popwt]
	mdesc *
*---------------------------------------------------------------------------------------------------
	* Declaring the sample design
	svyset psu [pw=popwt], strata(estra)
*---------------------------------------------------------------------------------------------------
save "${dta}2900_EML2021_Consolidando.dta", replace	
****************************************************************************************************