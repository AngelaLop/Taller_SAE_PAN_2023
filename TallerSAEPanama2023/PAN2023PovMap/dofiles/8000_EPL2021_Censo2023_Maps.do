* 8000_EPL2021_Censo2023_Maps.do

dir "${shapefiles2023}*2023*.dta"	
	//  127.6k  10/30/23 20:56  PAN2023corr.dta   
	//   52.6M  10/30/23 20:56  PAN2023corr_shp.dta
	//   14.3k  10/30/23 20:56  PAN2023dist.dta   
	//   21.6M  10/30/23 20:56  PAN2023dist_shp.dta
	//    9.2k  10/30/23 20:56  PAN2023prov.dta   
	//   19.2M  10/30/23 20:56  PAN2023prov_shp.dta
*---------------------------------------------------------------------------------------------------
use  "${output}5220_TR20_lnskew_NationalModel_resultseml21incenso_200405.dta", clear
	rename Unit codePDC
	gen	 PovRate = 100*avg_fgt0_plinevar
	gen	 PovGap  = 100*avg_fgt1_plinevar
	gen	 PovSev  = 100*avg_fgt2_plinevar
	keep codePDC PovRate PovGap PovSev
tempfile poverty
save	`poverty'
*-------------------------------------------------
use "${shapefiles2023}PAN2023corr.dta", clear
	gen 		codePDC = PROV_ID + DIST_ID + CORR_ID
	destring 	codePDC, replace
merge 1:1       codePDC using `poverty', nogen
*-------------------------------------------------
spmap PovRate using "${shapefiles2023}PAN2023corr_shp.dta" , id(_ID) fcolor(YlOrRd) clmethod(custom) clbreaks(0 10 20 30 40 50 60 70 80 100)  ocolor(gs4 ..) osize(vvthin ..) ndfcolor(gs12 ..) ndocolor(gs4 ..) ndsize(vvthin ..)  legend(ring(1) position(2))  xsize(50cm) ysize(30cm)  title("Tasa de Pobreza por Corregimiento, en porcentaje") 
* correr recording
graph export "${graphs}8000_EPL2021_Censo2023_PovRate_Corregimiento2.png", as(png) name("Graph") replace

spmap PovGap using "${shapefiles2023}PAN2023corr_shp.dta" , id(_ID) fcolor(YlGnBu) clmethod(custom) clbreaks(0 10 20 30 40 50 60 70 80 100)  ocolor(gs4 ..) osize(vvthin ..) ndfcolor(gs12 ..) ndocolor(gs4 ..) ndsize(vvthin ..)  legend(ring(1) position(2))  xsize(50cm) ysize(30cm)   title("Tasa de Intensidad de la Pobreza por Corregimiento, en porcentaje")
* correr recording
graph export "${graphs}8000_EPL2021_Censo2023_PovGap_Corregimiento.png", as(png) name("Graph") replace

spmap PovSev using "${shapefiles2023}PAN2023corr_shp.dta" , id(_ID) fcolor(Greens) clmethod(custom) clbreaks(0 10 20 30 40 50 60 70 80 100)  ocolor(gs4 ..) osize(vvthin ..) ndfcolor(gs12 ..) ndocolor(gs4 ..) ndsize(vvthin ..)  legend(ring(1) position(2))  xsize(50cm) ysize(30cm)  title("Tasa de Severidad de la Pobreza por Corregimiento, en porcentaje")
* correr recording
graph export "${graphs}8000_EPL2021_Censo2023_PovSev_Corregimiento.png", as(png) name("Graph") replace
*-------------------------------------------------
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
graph save "Graph" "${graphs}8000_EPL2021_Censo2023_PovRate_PanamaPanama.gph", replace	
graph export       "${graphs}8000_EPL2021_Censo2023_PovRate_PanamaPanama.png", as(png) name("Graph") replace
graph export       "${graphs}8000_EPL2021_Censo2023_PovRate_PanamaPanama.svg", as(svg) name("Graph") replace
graph export       "${graphs}8000_EPL2021_Censo2023_PovRate_PanamaPanama.jpg", as(jpg) name("Graph") replace quality(100)
*---------------------------------------------------------------------------------------------------
use  "${output}5220_TR20_lnskew_NationalModel_resultseml21incenso_200405.dta", clear
	gen codePD = floor(Unit/100)
	gen	 PovRate = 100*avg_fgt0_plinevar
	gen	 PovGap  = 100*avg_fgt1_plinevar
	gen	 PovSev  = 100*avg_fgt2_plinevar
	groupfunction [aw=nIndividuals], mean(PovRate PovGap PovSev) by(codePD) rawsum(nIndividuals )
tempfile poverty
save	`poverty'
*-------------------------------------------------
use "${shapefiles2023}PAN2023dist_fixed.dta", clear
	gen 		codePD = PROV_ID + DIST_ID 
	destring 	codePD, replace
merge 1:1       codePD using `poverty', nogen
*-------------------------------------------------
spmap PovRate using "${shapefiles2023}PAN2023dist_shp_fixed.dta" , id(_ID) fcolor(YlOrRd) clmethod(custom) clbreaks(0 10 20 30 40 50 60 70 80 100)  ocolor(gs4 ..) osize(vvthin ..) ndfcolor(gs12 ..) ndocolor(gs4 ..) ndsize(vvthin ..)  legend(ring(1) position(2))  xsize(50cm) ysize(30cm)  title("Tasa de Pobreza (FGT0) por Distrito, en porcentaje")  
	gr_edit title.DragBy 15.02 2.82
	gr_edit AddTextBox added_text editor 90.52 55.25
	gr_edit added_text[1].text.Arrpush (Estimación Preliminar)
	gr_edit AddTextBox added_text editor 8.716 3.29
	gr_edit added_text[2].text.Arrpush "Nota: Estimación del Banco Mundial utilizando el Censo de Población y Vivienda de 2023 y la Encuesta de Propósitos Múltiples de 2021."
	gr_edit added_text[2].style.editstyle  angle(default) size( sztype(relative) val(1.3888) allow_pct(1))  editcopy
	gr_edit AddTextBox added_text editor 6.19 3.29
	gr_edit added_text[3].text.Arrpush "Se utiliza el agregado de ingreso SEDLAC (CEDLAS and World Bank) y una línea de pobreza equivalente a 158.4 (urbana) y 149.6 (rural) dólares 2017 PPP por persona al día que resulta en un nivel de pobreza nacional de 21.8 por ciento."
	gr_edit added_text[3].style.editstyle  angle(default) size( sztype(relative) val(1.3888) allow_pct(1))  editcopy
graph save "Graph" "${graphs}8000_EPL2021_Censo2023_PovRate_Distrito.gph", replace	
graph export       "${graphs}8000_EPL2021_Censo2023_PovRate_Distrito.png", as(png) name("Graph") replace
graph export       "${graphs}8000_EPL2021_Censo2023_PovRate_Distrito.svg", as(svg) name("Graph") replace
graph export       "${graphs}8000_EPL2021_Censo2023_PovRate_Distrito.jpg", as(jpg) name("Graph") replace quality(100)
*-------------------------------------------------
spmap PovGap using "${shapefiles2023}PAN2023dist_shp_fixed.dta" , id(_ID) fcolor(Reds2) clmethod(custom) clbreaks(0 5 10 15 20 25 30  40 50 60)  ocolor(gs4 ..) osize(vvthin ..) ndfcolor(gs12 ..) ndocolor(gs4 ..) ndsize(vvthin ..)  legend(ring(1) position(2))  xsize(50cm) ysize(30cm)  title("Tasa de Intensidad de la Pobreza por (FGT1) Distrito, en porcentaje")  
	gr_edit title.DragBy 15.02 2.82
	gr_edit AddTextBox added_text editor 90.52 55.25
	gr_edit added_text[1].text.Arrpush (Estimación Preliminar)
	gr_edit AddTextBox added_text editor 8.716 3.29
	gr_edit added_text[2].text.Arrpush "Nota: Estimación del Banco Mundial utilizando el Censo de Población y Vivienda de 2023 y la Encuesta de Propósitos Múltiples de 2021."
	gr_edit added_text[2].style.editstyle  angle(default) size( sztype(relative) val(1.3888) allow_pct(1))  editcopy
	gr_edit AddTextBox added_text editor 6.19 3.29
	gr_edit added_text[3].text.Arrpush "Se utiliza el agregado de ingreso SEDLAC (CEDLAS and World Bank) y una línea de pobreza equivalente a 158.4 (urbana) y 149.6 (rural) dólares 2017 PPP por persona al día que resulta en un nivel de pobreza nacional de 21.8 por ciento."
	gr_edit added_text[3].style.editstyle  angle(default) size( sztype(relative) val(1.3888) allow_pct(1))  editcopy
graph save "Graph" "${graphs}8000_EPL2021_Censo2023_PovGap_Distrito.gph", replace	
graph export       "${graphs}8000_EPL2021_Censo2023_PovGap_Distrito.png", as(png) name("Graph") replace
*-------------------------------------------------
spmap PovSev using "${shapefiles2023}PAN2023dist_shp_fixed.dta" , id(_ID) fcolor(Greys2) clmethod(custom) clbreaks(0 5 10 15 20 25 30 35 40 45)  ocolor(gs4 ..) osize(vvthin ..) ndfcolor(gs12 ..) ndocolor(gs4 ..) ndsize(vvthin ..)  legend(ring(1) position(2))  xsize(50cm) ysize(30cm)  title("Tasa de Severidad de la Pobreza (FGT2) por Distrito, en porcentaje")  
	gr_edit title.DragBy 15.02 2.82
	gr_edit AddTextBox added_text editor 90.52 55.25
	gr_edit added_text[1].text.Arrpush (Estimación Preliminar)
	gr_edit AddTextBox added_text editor 8.716 3.29
	gr_edit added_text[2].text.Arrpush "Nota: Estimación del Banco Mundial utilizando el Censo de Población y Vivienda de 2023 y la Encuesta de Propósitos Múltiples de 2021."
	gr_edit added_text[2].style.editstyle  angle(default) size( sztype(relative) val(1.3888) allow_pct(1))  editcopy
	gr_edit AddTextBox added_text editor 6.19 3.29
	gr_edit added_text[3].text.Arrpush "Se utiliza el agregado de ingreso SEDLAC (CEDLAS and World Bank) y una línea de pobreza equivalente a 158.4 (urbana) y 149.6 (rural) dólares 2017 PPP por persona al día que resulta en un nivel de pobreza nacional de 21.8 por ciento."
	gr_edit added_text[3].style.editstyle  angle(default) size( sztype(relative) val(1.3888) allow_pct(1))  editcopy
graph save "Graph" "${graphs}8000_EPL2021_Censo2023_PovSev_Distrito.gph", replace	
graph export       "${graphs}8000_EPL2021_Censo2023_PovSev_Distrito.png", as(png) name("Graph") replace
*-------------------------------------------------





dir 	"${censo2023}stata/"
use "${censo2023}stata/CEN2023_CORREG.dta", clear
	gen codePDC = PROV_ID + DIST_ID + CORR_ID
	destring codePDC, replace
	destring PROV_ID DIST_ID CORR_ID, replace
	keep  codePDC PROV_NOMBRE DIST_NOMBRE CORR_NOMBRE PROV_ID DIST_ID CORR_ID
	order codePDC PROV_NOMBRE DIST_NOMBRE CORR_NOMBRE PROV_ID DIST_ID CORR_ID
tempfile nombres
save 	`nombres'

use  "${output}5220_TR20_lnskew_NationalModel_resultseml21incenso_200405.dta", clear
rename Unit codePDC
merge 1:1 codePDC using `nombres'
order codePDC PROV_NOMBRE DIST_NOMBRE CORR_NOMBRE avg_fgt0_plinevar nIndividuals PROV_ID DIST_ID CORR_ID
keep  codePDC PROV_NOMBRE DIST_NOMBRE CORR_NOMBRE avg_fgt0_plinevar nIndividuals PROV_ID DIST_ID CORR_ID
rename avg_fgt0_plinevar PovRate
rename nIndividuals  PobTot
	format PovRate %9.4f
	format PobTot %12.0fc
save  "${output}PreliminarEstimatesEPL2021Census2021_corregimientos.dta", replace
preserve
collapse (sum)  PobTot, by(PROV_ID DIST_ID PROV_NOMBRE DIST_NOMBRE)
tempfile nomdist
save 	`nomdist'
restore
collapse (mean) PovRate  [pw=PobTot], by(PROV_ID DIST_ID PROV_NOMBRE DIST_NOMBRE)
merge 1:1 PROV_ID DIST_ID PROV_NOMBRE DIST_NOMBRE using `nomdist', nogen
save  "${output}PreliminarEstimatesEPL2021Census2021_distritos.dta", replace
preserve
collapse (sum)  PobTot, by(PROV_ID PROV_NOMBRE)
tempfile nomprov
save 	`nomprov'
restore
collapse (mean) PovRate [pw=PobTot], by(PROV_ID PROV_NOMBRE )
merge 1:1 PROV_ID PROV_NOMBRE using `nomprov', nogen
save  "${output}PreliminarEstimatesEPL2021Census2021_provincias.dta", replace
preserve
collapse (sum)  PobTot
gen Panama=1
tempfile nomnat
save 	`nomnat'
restore
collapse (mean) PovRate  [pw=PobTot]
gen Panama=1
merge 1:1 Panama using `nomnat', nogen
order Panama
save  "${output}PreliminarEstimatesEPL2021Census2021_nacional.dta", replace