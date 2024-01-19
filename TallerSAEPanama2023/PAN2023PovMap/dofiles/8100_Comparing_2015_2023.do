* 8100_Comparing_2015_2023.do

	dir "${povmap2023}input/PovMap2015/"

	
use "${povmap2023}input/PovMap2015/Panama2015_corregimiento.dta", clear
	gen PovRat2015 = 100*av_FGT0g
	keep prov_nom dist_nom corr_nom PovRat2015
tempfile figures
save 	`figures'
use "${povmap2023}input/PovMap2015/tolink2023_ADM3_ES_corr_nom.dta", clear
merge m:1 prov_nom dist_nom corr_nom using `figures', nogen
	keep  PROV_NOMBRE DIST_NOMBRE CORR_NOMBRE PovRat2015
	order PROV_NOMBRE DIST_NOMBRE CORR_NOMBRE PovRat2015
	format PovRat2015 %9.0f
tempfile PovRat2015
save 	`PovRat2015'	
use "${censo2023}stata/CEN2023_CORREG.dta", clear
	gen 	 codePDC = PROV_ID + DIST_ID + CORR_ID
	destring codePDC, replace
tempfile codePDC
save 	`codePDC'
use "${output}5220_TR20_lnskew_NationalModel_resultseml21incenso_200405.dta", clear
	rename Unit codePDC
merge 1:1 codePDC using `codePDC'	
	gen PovRat2023 = 100*avg_fgt0_plinevar
	gen Pop1000 = nIndividuals/1000
	keep  PROV_NOMBRE DIST_NOMBRE CORR_NOMBRE PovRat2023 Pop1000 PROV_ID
	order PROV_NOMBRE DIST_NOMBRE CORR_NOMBRE PovRat2023 Pop1000 PROV_ID
	format PovRat2023 %9.0f
	format Pop1000	  %9.0fc
merge m:1 PROV_NOMBRE DIST_NOMBRE CORR_NOMBRE using `PovRat2015', nogen
save "${dta}8100_Comparing_2015_2023_corregimiento.dta", replace
	gen 	RegEcon = .
	replace RegEcon = 1 if PROV_NOMBRE=="PANAMÁ"|PROV_NOMBRE=="COLÓN"|PROV_NOMBRE=="PANAMÁ OESTE"
	replace RegEcon = 2 if PROV_NOMBRE=="DARIÉN"|PROV_NOMBRE=="COMARCA EMBERÁ"|PROV_NOMBRE=="COMARCA KUNA YALA"
	replace RegEcon = 3 if PROV_NOMBRE=="CHIRIQUÍ"|PROV_NOMBRE=="BOCAS DEL TORO"|PROV_NOMBRE=="COMARCA NGÄBE BUGLÉ"
	replace RegEcon = 4 if PROV_NOMBRE=="COCLÉ"|PROV_NOMBRE=="VERAGUAS"|PROV_NOMBRE=="LOS SANTOS"|PROV_NOMBRE=="HERRERA"
	lab def RegEcon 1 "Región Metropolitana" 2 "Región Oriental" 3 "Región Occidental" 4 "Región Central"

	sum Pop1000			//	 .042 to 89.192
set obs 718
	replace PovRat2015 =   0 in 700
	replace PovRat2015 = 100 in 701
	replace PovRat2023 =   0 in 700
	replace PovRat2023 = 100 in 701
	
	replace Pop100     = 0.4 in 711
	replace Pop100     = 5000 in 712
	replace RegEcon    = 1 in 711/712
	
	replace Pop100     = 0.4 in 713
	replace Pop100     = 5000 in 714
	replace RegEcon    = 2 in 713/714
	
	replace Pop100     = 0.4 in 715
	replace Pop100     = 5000 in 716
	replace RegEcon    = 3 in 715/716
	
	replace Pop100     = 0.4 in 717
	replace Pop100     = 5000 in 718
	replace RegEcon    = 4 in 717/718
	
// #d ;
// twoway 
// (scatter PovRat2023 PovRat2015 if RegEcon==1 [pweight = Pop1000], mfcolor(midblue%50) mlcolor(%0)) 
// (scatter PovRat2023 PovRat2015 if RegEcon==2 [pweight = Pop1000], mfcolor(cranberry%50) mlcolor(%0)) 
// (scatter PovRat2023 PovRat2015 if RegEcon==3 [pweight = Pop1000], mfcolor(green%50) mlcolor(%0)) 
// (scatter PovRat2023 PovRat2015 if RegEcon==4 [pweight = Pop1000], mfcolor(%50) mlcolor(%0)) 
// (line PovRat2023 PovRat2015 in 700/701, sort lcolor(gs5) lwidth(thin) lpattern(dash)) 
// , 
// ytitle(`"Tasa de Pobreza 2023 (en porcentaje)"') 
// ytitle(, size(small)) ylabel(0(10)100, labsize(small) angle(horizontal)) 
// xtitle(`"Tasa de pobreza 2015 (en porcentaje)"') 
// xtitle(, size(small)) xlabel(0(10)100, labsize(small)) 
// legend(order(1 "Metropolitana" 2 "Oriental" 3 "Occidental" 4 "Central" ) rows(1) size(small) region(lcolor(white))) 
// xsize(20) ysize(21) aspectratio(1) graphregion(fcolor(white))
// ;
// #d cr
//
// graph export "${graphs}Comparing_2015_2023.png", as(png) name("Graph") replace



keep in 1/699
preserve
collapse (sum) Pop1000, by(PROV_NOMBRE DIST_NOMBRE PROV_ID)
tempfile suma
save 	`suma'
restore
collapse (mean) PovRat2023 PovRat2015 [iw=Pop1000], by(PROV_NOMBRE DIST_NOMBRE PROV_ID)
merge 1:1 PROV_NOMBRE DIST_NOMBRE PROV_ID using `suma', nogen
destring PROV_ID, gen(P)
save "${dta}8100_Comparing_2015_2023.dta", replace

set obs 116
	replace PovRat2015 =   0 in 83
	replace PovRat2015 = 100 in 84
	replace PovRat2023 =   0 in 83
	replace PovRat2023 = 100 in 84
	
	replace Pop100     = 0.4  in 91
	replace Pop100     = 5000 in 92
	replace P          = 1 in 91/92
	
	replace Pop100     = 0.4  in 93
	replace Pop100     = 5000 in 94
	replace P          = 2 in 93/94
	
	replace Pop100     = 0.4  in 95
	replace Pop100     = 5000 in 96
	replace P          = 3 in 95/96
	
	replace Pop100     = 0.4 in 97
	replace Pop100     = 5000 in 98
	replace P          = 4 in 97/98
	
	replace Pop100     = 0.4 in 99
	replace Pop100     = 5000 in 100
	replace P          = 5 in 99/100

	replace Pop100     = 0.4   in 101
	replace Pop100     = 5000  in 102
	replace P          = 6 in 101/102
	
	replace Pop100     = 0.4   in 103
	replace Pop100     = 5000  in 104
	replace P          = 7 in 103/104
	
	replace Pop100     = 0.4   in 105
	replace Pop100     = 5000  in 106
	replace P          = 8 in 105/106
	
	replace Pop100     = 0.4   in 107
	replace Pop100     = 5000  in 108
	replace P          = 9 in 107/108
	
	replace Pop100     = 0.4    in 109
	replace Pop100     = 5000   in 110
	replace P          = 10 in 109/110
	
	replace Pop100     = 0.4    in 111
	replace Pop100     = 5000   in 112
	replace P          = 11 in 111/112
	
	replace Pop100     = 0.4    in 113
	replace Pop100     = 5000   in 114
	replace P          = 12 in 113/114
	
	replace Pop100     = 0.4    in 115
	replace Pop100     = 5000   in 116
	replace P          = 13 in 115/116
	
#d ;
twoway 
(scatter PovRat2023 PovRat2015 if P==1  [pweight = Pop1000], mfcolor(brown%0) 			mlcolor(brown%80)) 
(scatter PovRat2023 PovRat2015 if P==2  [pweight = Pop1000], mfcolor(dkgreen%0) 		mlcolor(dkgreen%80)) 
(scatter PovRat2023 PovRat2015 if P==3  [pweight = Pop1000], mfcolor(purple%0) 			mlcolor(purple%80)) 
(scatter PovRat2023 PovRat2015 if P==4  [pweight = Pop1000], mfcolor(khaki%0) 			mlcolor(khaki%80))
(scatter PovRat2023 PovRat2015 if P==5  [pweight = Pop1000], mfcolor(midblue%0) 		mlcolor(midblue%80))
(scatter PovRat2023 PovRat2015 if P==6  [pweight = Pop1000], mfcolor(forest_green%0) 	mlcolor(forest_green%80))
(scatter PovRat2023 PovRat2015 if P==7  [pweight = Pop1000], mfcolor(mint%0) 			mlcolor(mint%80))
(scatter PovRat2023 PovRat2015 if P==8  [pweight = Pop1000], mfcolor(ebblue%0) 			mlcolor(ebblue%80))
(scatter PovRat2023 PovRat2015 if P==9  [pweight = Pop1000], mfcolor(green%0) 			mlcolor(green%80))
(scatter PovRat2023 PovRat2015 if P==10 [pweight = Pop1000], mfcolor(cranberry%0) 		mlcolor(cranberry%80))
(scatter PovRat2023 PovRat2015 if P==11 [pweight = Pop1000], mfcolor(orange%0) 			mlcolor(orange%80))
(scatter PovRat2023 PovRat2015 if P==12 [pweight = Pop1000], mfcolor(red%0) 			mlcolor(red%80))
(scatter PovRat2023 PovRat2015 if P==13 [pweight = Pop1000], mfcolor(navy%0) 			mlcolor(navy%80)) 
(line PovRat2023 PovRat2015 in 83/84, sort lcolor(gs5) lwidth(thin) lpattern(dash)) 
, 
ytitle(`"Tasa de Pobreza 2023 (en porcentaje)"') 
ytitle(, size(small)) ylabel(0(10)100, labsize(small) angle(horizontal)) 
xtitle(`"Tasa de pobreza 2015 (en porcentaje)"') 
xtitle(, size(small)) xlabel(0(10)100, labsize(small)) 
 legend(order(
	1	"BOCAS DEL TORO"
	2	"COCLE"		
	3	"COLON"
	4	"CHIRIQUI"
	5	"DARIEN"
	6	"HERRERA"		
	7	"LOS SANTOS"
	8	"PANAMA"
	9	"VERAGUAS"
	10	"COM. KUNA YALA"
	11	"COM. EMBERA"
	12	"COM. NGOBE BUGLE"
	13	"PANAMA OESTE"
) rows(3) size(tiny) position(6)) 
xsize(20) ysize(24) aspectratio(1) 
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
;
#d cr

graph export "${graphs}8100_Comparing_2015_2023_distrito.png", as(png) name("Graph") replace
graph export "${graphs}8100_Comparing_2015_2023_distrito.jpg", as(jpg) name("Graph") replace quality(100)


use 	"${censo2023}stata/CEN2023_CORREG.dta", clear
	keep  PROV_ID DIST_ID CORR_ID DIST_NOMBRE PROV_NOMBRE CORR_NOMBRE
tempfile nombres
save 	`nombres'
use "${dta}8100_Comparing_2015_2023_corregimiento.dta", clear
merge 1:1 DIST_NOMBRE PROV_NOMBRE CORR_NOMBRE using `nombres', nogen
	keep  PROV_ID DIST_ID CORR_ID PROV_NOMBRE DIST_NOMBRE CORR_NOMBRE PovRat2015 PovRat2023
	order PROV_ID DIST_ID CORR_ID PROV_NOMBRE DIST_NOMBRE CORR_NOMBRE PovRat2015 PovRat2023
tempfile comparacorr
save 	`comparacorr'
use "${shapefiles2023}PAN2023corr.dta", clear
merge 1:1 PROV_ID DIST_ID CORR_ID using `comparacorr'
	gen cambio = PovRat2023- PovRat2015
	sum cambio
	//     Variable |        Obs        Mean    Std. dev.       Min        Max
	// -------------+---------------------------------------------------------
	//       cambio |        699   -2.877838    9.727227  -42.35557   26.68906
spmap cambio using "${shapefiles2023}PAN2023corr_shp.dta" , id(_ID) fcolor(BuRd) clmethod(custom) clbreaks(-50 -40 -30 -20 -10 0 10 20 30 40 50)  ocolor(gs4 ..) osize(vvthin ..) ndfcolor(gs12 ..) ndocolor(gs4 ..) ndsize(vvthin ..)  legend(ring(1) position(2))  xsize(50cm) ysize(30cm)   title("Cambio en la Tasa de Pobreza por Corregimiento, en porcentaje") note("Nota: Estimación del Banco Mundial utilizando el Censo de Población y Vivienda de 2023 y la Encuesta de Propósitos Múltiples de 2021.",size(vsmall)) caption("Nota: En azules, menos pobreza en 2023 que en 2015; en rojos, mas pobreza", size(vsmall))
	gr_edit title.DragBy 13 4
	gr_edit note.DragBy -9 1
	gr_edit caption.DragBy -9 1
graph export       "${graphs}8100_Comparing_2015_2023_corrmapa.jpg", as(jpg) name("Graph") replace quality(100)
save "${dta}8100_Comparing_2015_2023_corrmapa.dta", replace


















dir "${censo2023}stata/"
use 	"${censo2023}stata/CEN2023_DISTRITO.dta", clear
	keep  PROV_ID DIST_ID DIST_NOMBRE PROV_NOMBRE
tempfile nombres
save 	`nombres'
use "${dta}8100_Comparing_2015_2023_corregimiento.dta", clear
	groupfunction [aw=Pop1000], mean(PovRat2023 PovRat2015) by(PROV_NOMBRE DIST_NOMBRE) rawsum(Pop1000 )
	gen cambio = PovRat2023- PovRat2015
	sum cambio
	dis (r(max)-r(min))/9  // 2.5767292  then -18 -15 -12 -9 -6 -3 0 3 6 9 
merge 1:1 DIST_NOMBRE PROV_NOMBRE using `nombres', nogen
	keep  PROV_ID DIST_ID  PROV_NOMBRE DIST_NOMBRE  PovRat2015 PovRat2023 cambio
	order PROV_ID DIST_ID  PROV_NOMBRE DIST_NOMBRE  PovRat2015 PovRat2023 cambio
tempfile comparadist
save 	`comparadist'
use "${shapefiles2023}PAN2023dist_fixed.dta", clear
merge 1:1 PROV_ID DIST_ID  using `comparadist'

spmap cambio using "${shapefiles2023}PAN2023dist_shp_fixed.dta" , id(_ID) fcolor(BuRd) clmethod(custom) clbreaks(-20 -15 -10 -5 0 5 10 15 20)  ocolor(gs4 ..) osize(vvthin ..) ndfcolor(gs12 ..) ndocolor(gs4 ..) ndsize(vvthin ..)  legend(ring(1) position(2))  xsize(50cm) ysize(30cm)   title("Cambio en la Tasa de Pobreza por Distrito, en porcentaje") note("Nota: Estimación del Banco Mundial utilizando el Censo de Población y Vivienda de 2023 y la Encuesta de Propósitos Múltiples de 2021.",size(vsmall)) caption("Nota: En azules, menos pobreza en 2023 que en 2015; en rojos, mas pobreza", size(vsmall))
	gr_edit title.DragBy 13 4
	gr_edit note.DragBy -9 1
	gr_edit caption.DragBy -9 1
graph export       "${graphs}8100_Comparing_2015_2023_distmapa.jpg", as(jpg) name("Graph") replace quality(100)
save "${dta}8100_Comparing_2015_2023_distmapa.dta", replace














