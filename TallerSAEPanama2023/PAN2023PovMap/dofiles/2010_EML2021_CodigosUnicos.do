* 2010_EML2021_CodigosUnicos.do

*---------------------------------------------------------------------------------------------------
* Exploring the original EML2021 and finding the variables to identify each observation: 
use "${EML2021}vivienda.dta", clear
	unique llave_sec	//	11054 ok
	unique provincia	//	13		---> 2
	unique prov			//	12	provincia==8 includes prov==8 & prov==13
	unique dist			//	13
	tab    dist, m		//	01 to 13 ---> 2
	unique corre		//	23
	tab    corre, m		//	01 to 23 ---> 2
	unique estra		//	10
	tab    estra, m		//	01 to 20
	unique unidad		//	250
	tab    unidad, m	//	001 to 252
	unique cuest 		//	16
	tab    cuest, m		//	01 to 16
	
	unique provincia				//	13
	unique provincia dist			//  76 districts
	unique provincia dist corre 	//	493 corregimientos
	unique provincia dist corre estra unidad cuest 	//	11054 vivienda
	
use "${EML2021}vivienda.dta", clear
	* llave_sec es equivalente {provincia dist corre estra unidad cuest}
	unique  provincia dist corre estra unidad cuest     			//	11054 of 11054
	unique  provincia dist corre estra unidad cuest llave_sec    	//	11054 of 11054
	unique                                          llave_sec    	//	11054 of 11054
	
use "${EML2021}hogar.dta", clear
	unique  provincia dist corre estra unidad cuest hogar     		//	11148 of 11148
	
use "${EML2021}persona.dta", clear
	unique  provincia dist corre estra unidad cuest hogar nper		//	38644 of 38644
*---------------------------------------------------------------------------------------------------
* Exploring the armonizing data set and finding the variables to identify each observation: 
use "${harmonized}EML2021.dta", clear
	unique provincia dist corre estra unidad cuest 					//	11054
	unique provincia dist corre estra unidad cuest urban			//	11054
	unique provincia dist corre estra unidad cuest urban factor17	//	11054
	tab urban [aw=factor17]		// 52% urban
	tab urban [aw=factorppp17]	// 52% urban
	tab urban [aw=fac15_e]		// 69% urban
	gen one = 1
	collapse (first) one, by(provincia dist corre estra unidad cuest urban factor17)
	tab urban [aw=factor17]		// urban 55%
	drop factor17 one
	
	gen provincia2 	= strofreal(provincia ,"%02.0f") 
	gen  estra2 	= strofreal(estra     ,"%02.0f")
	gen  unidad2 	= strofreal(unidad    ,"%03.0f")
	gen 	AREA = "1" if urban ==1
	replace AREA = "2" if urban ==0

	gen codeP 		= provincia2
	gen codePD		= provincia2 + dist
	gen codePDC		= provincia2 + dist + corre
	gen codePDCA	= provincia2 + dist + corre + AREA
	unique codePDCA estra unidad cuest	//	11054 ok
	gsort codePDCA
	bysort codePDCA: gen corviv = _n
	sum corviv
	gen  V = strofreal(corviv ,"%05.0f")
	gen codePDCAV = codeP + dist + corre + AREA + V
	keep  codeP codePD codePDC codePDCA codePDCAV provincia estra unidad cuest dist corre provincia2 estra2 unidad2
	order codeP codePD codePDC codePDCA codePDCAV provincia estra unidad cuest dist corre provincia2 estra2 unidad2
save "${dta}2010_EML2021_tolink.dta", replace
	
* To link to harmonized data set 
use "${harmonized}EML2021_.dta", clear
merge m:1 provincia dist corre estra unidad cuest using "${dta}2010_EML2021_tolink.dta", nogen 
	gen codePDCAVH =codePDCAV + hogar_inec
	unique codePDCAVH	// 11148 ok!
	keep if jefe==1
	count 				// 11148 ok!
	keep provincia dist corre psu estra unidad cuest hogar_inec hogar_inec codeP codePD codePDC codePDCA codePDCAV codePDCAVH ipcf pondera miembros  iea ilea_m ieb iec ied iee llave_sec region_est1* region_est2* 
	destring codeP codePD codePDC codePDCA codePDCAV codePDCAVH, replace
	format codePDCAV	%12.0f
	format codePDCAVH	%13.0f
	unique codePDCAVH	//	11148 of 11148
	unique codePDCAV	//	11054 of 11148
	unique codePDCA		//	  571 of 11148
	unique codePDC		//	  493 of 11148
	unique codePD		//	   76 of 11148
	unique codeP		//	   13 of 11148
save "${dta}2010_EML2021_CodigosUnicos.dta", replace
*---------------------------------------------------------------------------------------------------	

use "${harmonized}EML2021.dta", clear	
	gen plinevar = 6.85
	apoverty ipcf [ w=pondera], varpl(plinevar)	//	0.251%
	
use "${harmonized}EML2021.dta", clear	
	gen plinevar = 6.85*(30.42)
	apoverty ipcf [ w=pondera], varpl(plinevar)	//	33.690%
	
use "${harmonized}EML2021.dta", clear	
	gen plinevar = 144
	apoverty ipcf [ w=pondera], varpl(plinevar)	//	20.612%

use "${harmonized}EML2021.dta", clear	
	gen plinevar = 6.85
	gen popwt = pondera*miembros
	keep if jefe==1
	apoverty ipcf [ w=popwt], varpl(plinevar)	//	0.257%
	
// 	gen popwt = pondera*miembros
// 	svyset psu [pw=popwt], strata(estra)
// 	* National Poverty
// 	replace plinevar =11*plinevar
// 	povdeco	ipcf [aw=popwt], varpline(plinevar)			//	0.00169
// 	povdeco	ipcf [aw=pondera], varpline(plinevar)		//	0.00251
// 	gen plinevar = 5.5
	

// 	* Regional Poverty
// 	povdeco	ipcf [aw=popwt], varpline(plinevar)	bygroup(provincia)	// no good



*---------------------------------------------------------------------------------------------------
use "${dta}2010_EML2021_tolink.dta", clear
	drop provincia estra unidad
	rename provincia2 	provincia
	rename estra2		estra
	rename unidad2		unidad
tempfile linking
save 	`linking'	
use "${EML2021}vivienda.dta", clear
merge 1:1  provincia dist corre estra unidad cuest using `linking', nogen
	keep provincia dist corre estra unidad cuest llave_sec codeP codePD codePDC codePDCA codePDCAV
save "${dta}2010_EML2021_linkviv.dta", replace

use "${EML2021}hogar.dta", clear
	keep llave_sec hogar
merge m:1 llave_sec using "${dta}2010_EML2021_linkviv.dta", nogen
	gen codePDCAVH = codePDCAV + hogar
save "${dta}2010_EML2021_linkhog.dta", replace

use "${EML2021}persona.dta", clear
	keep llave_sec hogar nper
merge m:1 llave_sec hogar using "${dta}2010_EML2021_linkhog.dta", nogen
	gen codePDCAVHP = codePDCAVH + nper
save "${dta}2010_EML2021_linkper.dta", replace	

use "${dta}2010_EML2021_linkviv.dta", clear
	keep llave_sec code*
	destring code*, replace
	format codePDCAV	%12.0f
save "${dta}2010_Vivienda_PDCAV.dta", replace

use "${dta}2010_EML2021_linkhog.dta", clear
	keep llave_sec hogar code*
	destring code*, replace
	format codePDCAV	%12.0f
	format codePDCAVH	%13.0f
save "${dta}2010_Hogar_PDCAVH.dta", replace

use "${dta}2010_EML2021_linkper.dta", clear
	keep llave_sec hogar code*
	destring code*, replace
	format codePDCAV	%12.0f
	format codePDCAVH	%13.0f
	format codePDCAVHP	%15.0f
save "${dta}2010_Persona_PDCAVHP.dta", replace
*---------------------------------------------------------------------------------------------------	
* Checking all is ok:
use "${dta}2010_Vivienda_PDCAV.dta", clear
	unique codePDCAV	//	11054 of 11054
	unique codePDCA		//	  571 of 11054
	unique codePDC		//	  493 of 11054
	unique codePD		//	   76 of 11054
	unique codeP		//	   13 of 11054

use "${dta}2010_Hogar_PDCAVH.dta", clear
	unique codePDCAVH	//	11148 of 11148
	unique codePDCAV	//	11054 of 11148
	unique codePDCA		//	  571 of 11148
	unique codePDC		//	  493 of 11148
	unique codePD		//	   76 of 11148
	unique codeP		//	   13 of 11148
	
use "${dta}2010_Persona_PDCAVHP.dta", clear
	unique codePDCAVHP	//	38644 of 38644
	unique codePDCAVH	//	11148 of 38644
	unique codePDCAV	//	11054 of 38644
	unique codePDCA		//	  571 of 38644
	unique codePDC		//	  493 of 38644
	unique codePD		//	   76 of 38644
	unique codeP		//	   13 of 38644
*---------------------------------------------------------------------------------------------------


use "${dta}2010_EML2021_CodigosUnicos.dta", clear
gen one=1
collapse (sum) one,by(codeP region_est1 region_est2)	
// region_est2
// 1 - Bocas del Toro
// 2 - Cocle
// 3 - Colon
// 4 - Chiriqui
// 5 - Darien
// 6 - Herrera
// 7 - Los Santos
// 8 - Panama
// 9 - Veraguas
// 10 - Comarca Kuna Yala
// 11 - Comarca Embera
// 12 - Comarca Ngobe-Bugle
// 13 - Panama-Oeste


