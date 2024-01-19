* 3100_Matching_UNOCHA2021.do





dir "${shapefiles2023}"
	//  127.6k  10/30/23 20:56  PAN2023corr.dta   
	//   52.6M  10/30/23 20:56  PAN2023corr_shp.dta
	//   14.3k  10/30/23 20:56  PAN2023dist.dta   
	//   14.3k   1/11/24 12:50  PAN2023dist_fixed.dta
	//   21.6M  10/30/23 20:56  PAN2023dist_shp.dta
	//   21.6M   1/11/24 12:52  PAN2023dist_shp_fixed.dta
	//    9.2k  10/30/23 20:56  PAN2023prov.dta   
	//   19.2M  10/30/23 20:56  PAN2023prov_shp.dta
	
	*-------------------------------------------------
use "${shapefiles2023}PAN2023prov.dta", clear
	keep if _ID==6
	replace _ID=82
	replace ID1=82
	rename PROV_NOMB DIST_NOMB
	gen DIST_ID ="01"
tempfile agregar
save 	`agregar'
use "${shapefiles2023}PAN2023dist.dta", clear	
append using `agregar'
clear "${shapefiles2023}PAN2023dist_fixed.dta", replace
*-------------------------------------------------
use "${shapefiles2023}PAN2023prov_SHP.dta", clear
	keep if _ID==6
	replace _ID=82
tempfile agregar
save 	`agregar'
use "${shapefiles2023}PAN2023dist_shp.dta", clear
append using `agregar'
gsort _ID shape_order
save "${shapefiles2023}PAN2023dist_shp_fixed.dta", replace
*-------------------------------------------------
use "${shapefiles2023}PAN2023prov.dta", clear
	gen random = runiform(0,100)
	keep if _ID==6
spmap random using "${shapefiles2023}PAN2023prov_shp.dta" , id(_ID) fcolor(YlOrRd) clmethod(custom) clbreaks(0 10 20 30 40 50 60 70 80 100)  ocolor(gs4 ..) osize(vvthin ..) ndfcolor(gs12 ..) ndocolor(gs4 ..) ndsize(vvthin ..)  legend(ring(1) position(6))  xsize(50cm) ysize(50cm)  
*-------------------------------------------------
use "${shapefiles2023}PAN2023dist_fixed.dta", clear
	gen random = runiform(0,100)
spmap random using "${shapefiles2023}PAN2023dist_shp_fixed.dta" , id(_ID) fcolor(YlOrRd) clmethod(custom) clbreaks(0 10 20 30 40 50 60 70 80 100)  ocolor(gs4 ..) osize(vvthin ..) ndfcolor(gs12 ..) ndocolor(gs4 ..) ndsize(vvthin ..)  legend(ring(1) position(6))  xsize(50cm) ysize(50cm)   
*-------------------------------------------------


*-------------------------------------------------
use "${shapefiles2023}PAN2023corr.dta", clear
	gen 		codePDC = PROV_ID + DIST_ID + CORR_ID
	destring 	codePDC, replace
	keep if PROV_ID=="08" 
	keep if PROV_ID=="08" & DIST_ID=="08" | DIST_ID=="10"	
	gen label = proper(CORR_NOMB)
	bro CORR_NOMB label _ID DIST_ID codePDC if DIST_ID=="10"

replace label = "San Felipe 14.4 " if codePDC==80801
replace label = "El Chorrillo 23.1 " if codePDC==80802
replace label = "Santa Ana 22.0 " if codePDC==80803
replace label = "Calidonia 12.0 " if codePDC==80804
replace label = "Curundú 29.2 " if codePDC==80805
replace label = "Betania 2.1 " if codePDC==80806
replace label = "Bella Vista 1.8 " if codePDC==80807
replace label = "Pueblo Nuevo 3.0 " if codePDC==80808
replace label = "San Francisco 1.4 " if codePDC==80809
replace label = "Parque Lefevre 3.7 " if codePDC==80810
replace label = "Río Abajo 8.6 " if codePDC==80811
replace label = "Juan Díaz 5.4 " if codePDC==80812
replace label = "Pedregal 12.6 " if codePDC==80813
replace label = "Ancón 15.4 " if codePDC==80814
replace label = "Chilibre 29.2 " if codePDC==80815
replace label = "Las Cumbres 20.7 " if codePDC==80816
replace label = "Pacora 15.3 " if codePDC==80817
replace label = "San Martín 17.3 " if codePDC==80818
replace label = "Tocumen 14.9 " if codePDC==80819
replace label = "Las Mañanitas 19.1 " if codePDC==80820
replace label = "24 De Diciembre 15.5 " if codePDC==80821
replace label = "Alcalde Díaz 12.9 " if codePDC==80822
replace label = "E. Córdoba C. 17.2 " if codePDC==80823
replace label = "Caimitillo 15.4 " if codePDC==80824
replace label = "Las Garzas 26.9 " if codePDC==80825
replace label = "Don Bosco 3.3 " if codePDC==80826

replace label = "Arnulfo Arias " if codePDC==81006
replace label = "Mateo Iturralde  " if codePDC==81004
replace label = "Belisario Porras  " if codePDC==81002
replace label = "Belisario Frías  " if codePDC==81007
replace label = "Omar Torrijos  " if codePDC==81008
replace label = "Amelia Denis De Icaza  " if codePDC==81001
replace label = "Victoriano Lorenzo  " if codePDC==81005
replace label = "José Domingo Espinar  " if codePDC==81003
replace label = "Rufina Alfaro  " if codePDC==81009

replace label = "" if codePDC==81006
replace label = "" if codePDC==81004
replace label = "" if codePDC==81002
replace label = "" if codePDC==81007
replace label = "" if codePDC==81008
replace label = "" if codePDC==81001
replace label = "" if codePDC==81005
replace label = "" if codePDC==81003
replace label = "" if codePDC==81009


save "${shapefiles2023}PAN2023corr_Panama.dta", replace


use "${shapefiles2023}PAN2023corr_Panama.dta", clear 
	destring 	codePDC, replace
	keep _CX _CY  label codePDC 
	gen 	_NY = _CY
	gen 	_NX = _CX
	replace _NX = _NX + 2000 if codePDC==80818
	replace _NY = _NY + 4000 if codePDC==80817
	replace _NY = _NY - 1000 if codePDC==80822
	replace _NX = _NX -  500 if codePDC==80822
	replace _NY = _NY - 3500 if codePDC==80819
	replace _NX = _NX + 3500 if codePDC==80819
	replace _NX = _NX +  500 if codePDC==80816
	replace _NY = _NY +  900 if codePDC==80812
	replace _NY = _NY -  700 if codePDC==80826
	replace _NX = _NX + 1700 if codePDC==80826
	replace _NY = _NY + 3000 if codePDC==80821
	replace _NX = _NX - 1500 if codePDC==80821
	replace _NY = _NY + 1000 if codePDC==80820
	replace _NX = _NX - 7000 if codePDC==80805
	replace _NY = _NY - 3500 if codePDC==80805

	replace _NY = _NY +  500 if codePDC==80823
	replace _NY = _NY + 4500 if codePDC==80808
	replace _NX = _NX + 1000 if codePDC==80808
	replace _NX = _NX + 6000 if codePDC==80810
	replace _NY = _NY - 1500 if codePDC==80810
	replace _NX = _NX + 4000 if codePDC==80809
	replace _NY = _NY +  500 if codePDC==80809
	replace _NX = _NX -  500 if codePDC==80806
	
	replace _NX = _NX + 6200 if codePDC==80801
	replace _NX = _NX + 4500 if codePDC==80804
	replace _NX = _NX + 5700 if codePDC==80807
	
	replace _NX = _NX + 4200 if codePDC==80802
	replace _NY = _NY - 0750 if codePDC==80802
	replace _NX = _NX + 4400 if codePDC==80803
	replace _NY = _NY + 0500 if codePDC==80803
save "${shapefiles2023}PAN2023corr_Panama_labels.dta", replace

use  "${output}5220_TR20_lnskew_NationalModel_resultseml21incenso_200405.dta", clear
	rename Unit codePDC
	gen	 PovRate = 100*avg_fgt0_plinevar
	gen	 PovGap  = 100*avg_fgt1_plinevar
	gen	 PovSev  = 100*avg_fgt2_plinevar
	keep codePDC PovRate PovGap PovSev
tempfile poverty
save	`poverty'
use "${shapefiles2023}PAN2023corr_Panama.dta", clear
merge 1:1       codePDC using `poverty'
keep if _m==3
drop _m
format PovRate PovGap PovSev %9.1f
spmap PovRate using "${shapefiles2023}PAN2023corr_shp.dta" , id(_ID) fcolor(YlOrRd) clmethod(custom) clbreaks(0 5 10 15 20 25 30)  ocolor(gs14 ..) osize(vthin ..) ndfcolor(gs12 ..) ndocolor(gs1 ..) ndsize(vthin ..)  legend(ring(1) position(2))  xsize(50cm) ysize(30cm)  title("Tasa de Pobreza por Corregimiento en el distrito de Panamá") label(data("${shapefiles2023}PAN2023corr_Panama_labels.dta") x(_NX) y(_NY) label(label) size(*0.5 ..) length(25))
	gr_edit plotregion1.AddLine added_lines editor 662369.88 1000322.42 663443.48 996731.41
	gr_edit plotregion1.added_lines_new = 1
	gr_edit plotregion1.added_lines_rec = 1
	gr_edit plotregion1.added_lines[1].style.editstyle  linestyle(width(sztype(relative) val(.15))) headstyle(size( sztype(relative) val(1.53)))  editcopy
	gr_edit plotregion1.AddLine added_lines editor 667182.57 996731.41 667811.92 995324.62
		gr_edit plotregion1.added_lines[2].style.editstyle  linestyle(width(sztype(relative) val(.15))) headstyle(size( sztype(relative) val(1.53)))  editcopy
	gr_edit plotregion1.AddLine added_lines editor 660926.07 991807.65 661666.48 991844.67
	gr_edit plotregion1.added_lines[3].style.editstyle  linestyle(width(sztype(relative) val(.15))) headstyle(size( sztype(relative) val(1.53)))  editcopy
	gr_edit plotregion1.AddLine added_lines editor 660222.67 990437.89 661148.19 990771.07
	gr_edit plotregion1.added_lines[4].style.editstyle  linestyle(width(sztype(relative) val(.15))) headstyle(size( sztype(relative) val(1.53)))  editcopy
	gr_edit plotregion1.AddLine added_lines editor 659889.49 989660.45 660296.72 989031.10
	gr_edit plotregion1.added_lines[5].style.editstyle  linestyle(width(sztype(relative) val(.15))) headstyle(size( sztype(relative) val(1.53)))  editcopy
	gr_edit plotregion1.AddLine added_lines editor 655632.10 989956.62 660259.69 991992.76
	gr_edit plotregion1.added_lines[6].style.editstyle  linestyle(width(sztype(relative) val(.15))) headstyle(size( sztype(relative) val(1.53)))  editcopy



//
// dir "${shapefiles2022}*.dta"
// 	//  104.1k  10/13/23 15:53  PAN2021corr.dta   
// 	// 8443.8k  10/13/23 15:53  PAN2021corr_shp.dta
// 	//   21.9k  10/13/23 15:53  PAN2021dist.dta   
// 	// 5963.1k  10/13/23 15:53  PAN2021dist_shp.dta
// 	//   13.9k  10/13/23 15:53  PAN2021prov.dta   
// 	// 5403.4k  10/13/23 15:53  PAN2021prov_shp.dta
// 	//  132.0k  10/13/23 13:14  Panama2015_corregimiento.dta
// 	//   31.2k  10/13/23 13:14  Panama2015_distrito.dta
// 	//   11.6k  10/13/23 17:20  tolink_ADM2_ES_dist_nom.dta
// 	//   90.3k  10/16/23 14:07  tolink_ADM3_ES_corr_nom.dta
//
// use "${shapefiles2022}PAN2021corr.dta", clear
// use "${shapefiles2022}PAN2021corr_shp.dta", clear
//
// *---------------------------------------------------------------------------------------------------
// * Matching codes does not work at the corregimiento level
// use "${shapefiles2022}PAN2021corr.dta", clear
// 	gen corr_code=substr(ADM3_PCODE, 3,6)
// 	keep corr_code _ID ADM3_ES ADM3_PCODE
// save "${dta}3100_Matching_UNOCHA2021_corregimiento.dta", replace
//
// use "${censo2023}stata/CEN2023_VIVIENDA.dta", clear
// 	gen corr_code = PROVINCIA + DISTRITO + CORREG
// merge m:1 corr_code using "${dta}3100_Matching_UNOCHA2021_corregimiento.dta"
// 	// Result                      Number of obs
// 	// -----------------------------------------
// 	// Not matched                     1,147,122
// 	// 	from master                 1,146,822  (_merge==1)
// 	// 	from using                        300  (_merge==2)
// 	//
// 	// Matched                           448,670  (_merge==3)
// 	// -----------------------------------------
// *---------------------------------------------------------------------------------------------------
// * Matching codes does not work at the district level
// use "${shapefiles2022}PAN2021dist.dta", clear
// 	gen  dist_code=substr(ADM2_PCODE, 3,4)
// 	keep dist_code _ID ADM2_ES ADM2_PCODE
// save "${dta}3100_Matching_UNOCHA2021_dist.dta", replace
//
// use "${censo2023}stata/CEN2023_VIVIENDA.dta", clear
// 	gen   dist_code = PROVINCIA + DISTRITO 
// merge m:1 dist_code using "${dta}3100_Matching_UNOCHA2021_dist.dta"
// 	// Result                      Number of obs
// 	// -----------------------------------------
// 	// Not matched                     1,147,122
// 	// 	from master                 1,146,822  (_merge==1)
// 	// 	from using                        300  (_merge==2)
// 	//
// 	// Matched                           448,670  (_merge==3)
// 	// -----------------------------------------
// *---------------------------------------------------------------------------------------------------
// dir "${censo2023}stata/*.dta"
// *---------------------------------------------------------------------------------------------------
// use "${shapefiles2022}PAN2021prov.dta", clear
// keep _ID ADM1_ES
// 	gen PROV_NOMBRE = ustrupper(ADM1_ES,"sp")
// 		replace PROV_NOMBRE="COMARCA KUNA YALA" 	if PROV_NOMBRE=="KUNA YALA"
// 		replace PROV_NOMBRE="COMARCA EMBERÁ" 		if PROV_NOMBRE=="EMBERÁ"
// 		replace PROV_NOMBRE="COMARCA NGÄBE BUGLÉ" 	if PROV_NOMBRE=="NGÖBE BUGLÉ"
// tempfile provincia
// save 	`provincia'
// use "${censo2023}stata/CEN2023_PROVINCIA.dta", clear
// merge 1:1 PROV_NOMBRE using `provincia', nogen
// 	gsort PROVINCIA
// save "${dta}linkprovincia.dta", replace
// *---------------------------------------------------------------------------------------------------
// use "${shapefiles2022}PAN2021dist.dta", clear
// keep _ID ADM1_ES ADM2_ES
// 	gen PROV_NOMBRE = ustrupper(ADM1_ES,"sp")
// 		replace PROV_NOMBRE="COMARCA KUNA YALA" 	if PROV_NOMBRE=="KUNA YALA"
// 		replace PROV_NOMBRE="COMARCA EMBERÁ" 		if PROV_NOMBRE=="EMBERÁ"
// 		replace PROV_NOMBRE="COMARCA NGÄBE BUGLÉ" 	if PROV_NOMBRE=="NGÖBE BUGLÉ"
// 	gen DIST_NOMBRE = ustrupper(ADM2_ES,"sp")
// tempfile distrito
// save 	`distrito'
// use "${censo2023}stata/CEN2023_DISTRITO.dta", clear
// 	replace DIST_NOMBRE="KUNA YALA" 	if DIST_NOMBRE=="COMARCA KUNA YALA"
// merge 1:1 PROV_NOMBRE DIST_NOMBRE using `distrito'
// 	//   1.                                 ALMIRANTE        BOCAS DEL TORO  <-- CHANGINOLA
// 	//  17.                             TIERRAS ALTAS              CHIRIQUÍ  <-- BUGABA
// 	//  28.                     OMAR TORRIJOS HERRERA                 COLÓN  <-- DONOSO
// 	//  35.                                  JIRONDAI   COMARCA NGÄBE BUGLÉ  <-- KANKINTU
// 	//  41.   SANTA CATALINA O CALOVÉVORA (BLEDESHIA)   COMARCA NGÄBE BUGLÉ  <-- KUSAPIN
// 	//  45.                                  SANTA FE                DARIÉN  <-- CHEPIGANA
//
// 	gsort PROVINCIA DIST_NOMBRE
// save "${dta}linkdistrito.dta", replace
// *---------------------------------------------------------------------------------------------------	
// use "${shapefiles2022}PAN2021prov_shp.dta", clear
// 	scatter _Y _X, msize(tiny) msymbol(point)
// merge m:1 _ID using "${shapefiles2022}PAN2021prov.dta", nogen
// 	geo2xy  _Y _X, proj (web_mercator) replace
// 	scatter _Y _X, msize(tiny) msymbol(point)
// 	sort _ID
// save "${shapefiles2022}PAN2021provMercator_shp.dta", replace
// *---------------------------------------------------------------------------------------------------
// use "${shapefiles2023}PAN2021dist_shp.dta", clear
// 	scatter _Y _X, msize(tiny) msymbol(point)
// merge m:1 _ID using "${shapefiles2022}PAN2021dist.dta", nogen
// 	geo2xy  _Y _X, proj (web_mercator) replace
// 	scatter _Y _X, msize(tiny) msymbol(point)
// 	sort _ID
// save "${shapefiles2022}PAN2021distMercator_shp.dta", replace
// *---------------------------------------------------------------------------------------------------
// use "${shapefiles2022}PAN2021corr_shp.dta", clear
// 	scatter _Y _X, msize(tiny) msymbol(point)
// merge m:1 _ID using "${shapefiles2022}PAN2021corr.dta", nogen
// 	geo2xy  _Y _X, proj (web_mercator) replace
// 	scatter _Y _X, msize(tiny) msymbol(point)
// 	sort _ID
// save "${shapefiles2022}PAN2021corrMercator_shp.dta", replace
// *---------------------------------------------------------------------------------------------------
// use "${shapefiles2022}PAN2021dist.dta", clear
// 	gen random = runiform(0,100)
// spmap random using "${shapefiles2022}PAN2021distMercator_shp.dta" , id(_ID) fcolor(YlOrRd) clmethod(custom) clbreaks(0 10 20 30 40 50 60 70 80 100)  ocolor(gs4 ..) osize(vvthin ..) ndfcolor(gs12 ..) ndocolor(gs4 ..) ndsize(vvthin ..)  legend(ring(1) position(6))  xsize(50cm) ysize(50cm)  
//
// 	*---------------------------------------------------------------------------------------------------
// use "${shapefiles2022}PAN2021corr.dta", clear
// 	gen random = runiform(0,100)
// spmap random using "${shapefiles2022}PAN2021corrMercator_shp.dta" , id(_ID) fcolor(YlOrRd) clmethod(custom) clbreaks(0 10 20 30 40 50 60 70 80 100)  ocolor(gs4 ..) osize(vvthin ..) ndfcolor(gs12 ..) ndocolor(gs4 ..) ndsize(vvthin ..)  legend(ring(1) position(6))  xsize(50cm) ysize(50cm)  

	