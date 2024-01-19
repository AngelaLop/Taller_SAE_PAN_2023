* 1900_Censo2023_Consolidando.do

****************************************************************************************************
use "${dta}1010_Persona_PDCAVHP.dta", clear
	gen miembros = 1
	collapse (sum) miembros, by(codePDCAVH)
tempfile miembros
save 	`miembros'
use "${dta}1010_Hogar_PDCAVH.dta", clear
merge 1:1 codePDCAVH     using `miembros', nogen
merge m:1 LLAVEVIV       using "${dta}1100_Censo2023_Vivienda.dta", nogen
merge m:1 LLAVEVIV HOGAR using "${dta}1200_Censo2023_Durables.dta", nogen
merge m:1 LLAVEVIV HOGAR using "${dta}1700_Censo2023_Jefe.dta"		
	keep if _m==3	//	2999 hogares sin jefe
	drop _m		
merge m:1 LLAVEVIV HOGAR using "${dta}1800_Censo2023_Familia.dta"	
	keep if _m==3	//	2999 hogares sin jefe
	drop _m
*----------------------------------------------------
	gen popwt = miembros
	mdesc *
	drop if H_ncuartos==.
	*------------------------------------------------
	mdesc *
	unab 	lista : H_* D_* C_* F_*
	display "`lista'"
	foreach x of local lista {
		replace `x'=0 if `x'==.
	}
	mdesc *
	*------------------------------------------------
	gen  R= codePDCA-10*codePDC ==2
	tab R [aw=popwt] 
*---------------------------------------------------------------------------------------------------
save "${dta}1900_Censo2023_Consolidando.dta", replace	
****************************************************************************************************




