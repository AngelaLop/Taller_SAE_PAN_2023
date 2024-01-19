
* 8150_GraficoBarrasDistritos.do

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
	gen 	RegEcon = .
	replace RegEcon = 1 if PROV_NOMBRE=="PANAMÁ"|PROV_NOMBRE=="COLÓN"|PROV_NOMBRE=="PANAMÁ OESTE"
	replace RegEcon = 2 if PROV_NOMBRE=="DARIÉN"|PROV_NOMBRE=="COMARCA EMBERÁ"|PROV_NOMBRE=="COMARCA KUNA YALA"
	replace RegEcon = 3 if PROV_NOMBRE=="CHIRIQUÍ"|PROV_NOMBRE=="BOCAS DEL TORO"|PROV_NOMBRE=="COMARCA NGÄBE BUGLÉ"
	replace RegEcon = 4 if PROV_NOMBRE=="COCLÉ"|PROV_NOMBRE=="VERAGUAS"|PROV_NOMBRE=="LOS SANTOS"|PROV_NOMBRE=="HERRERA"
	lab def RegEcon 1 "Región Metropolitana" 2 "Región Oriental" 3 "Región Occidental" 4 "Región Central" 
	sum Pop1000			//	 .042 to 89.192
preserve
collapse (sum) Pop1000, by(PROV_NOMBRE DIST_NOMBRE RegEcon)
tempfile suma
save 	`suma'
restore
collapse (mean) PovRat2023 [iw=Pop1000], by(PROV_NOMBRE PROV_ID DIST_NOMBRE RegEcon)
merge 1:1 PROV_NOMBRE DIST_NOMBRE RegEcon using `suma', nogen	
	merge 1:1 PROV_NOMBRE DIST_NOMBRE using "${dta}8100_Comparing_2015_2023_distmapa.dta", keepusing(PovRat2015) nogen
	
	gsort -PovRat2023
	gen P01  = PovRat2023 if PROV_ID=="01"
	gen P02  = PovRat2023 if PROV_ID=="02"
	gen P03  = PovRat2023 if PROV_ID=="03"
	gen P04  = PovRat2023 if PROV_ID=="04"
	gen P05  = PovRat2023 if PROV_ID=="05"
	gen P06  = PovRat2023 if PROV_ID=="06"
	gen P07  = PovRat2023 if PROV_ID=="07"
	gen P08  = PovRat2023 if PROV_ID=="08"
	gen P09  = PovRat2023 if PROV_ID=="09"
	gen P10  = PovRat2023 if PROV_ID=="10"
	gen P11  = PovRat2023 if PROV_ID=="11"
	gen P12  = PovRat2023 if PROV_ID=="12"
	gen P13  = PovRat2023 if PROV_ID=="13"
	gen order =_n
	
	
#d ;
lab def order 
1 "BESIKO"
2 "MIRONÓ"
3 "MÜNA"
4 "NOLE DUIMA"
5 "KANKINTÚ"
6 "JIRONDAI"
7 "SANTA CATALINA"
8 "KUSAPÍN"
9 "ÑÜRÜM"
10 "COMARCA KUNA YALA"
11 "CÉMACO"
12 "SAMBÚ"
13 "DONOSO"
14 "SANTA FE"
15 "ALMIRANTE"
16 "CAÑAZAS"
17 "LAS PALMAS"
18 "CHIMÁN"
19 "CHIRIQUÍ GRANDE"
20 "TOLÉ"
21 "CHEPIGANA"
22 "CHANGUINOLA"
23 "LAS MINAS"
24 "OLÁ"
25 "PINOGANA"
26 "OMAR TORRIJOS HERRERA"
27 "LA PINTADA"
28 "BOCAS DEL TORO"
29 "SAN FRANCISCO"
30 "SANTA FE"
31 "ANTÓN"
32 "LOS POZOS"
33 "LA MESA"
34 "BARÚ"
35 "RENACIMIENTO"
36 "CHEPO"
37 "CALOBRE"
38 "SONÁ"
39 "SAN LORENZO"
40 "PENONOMÉ"
41 "ALANJE"
42 "CHAGRES"
43 "CAPIRA"
44 "REMEDIOS"
45 "OCÚ"
46 "SAN FÉLIX"
47 "NATÁ"
48 "SANTA MARÍA"
49 "PARITA"
50 "PESÉ"
51 "BALBOA"
52 "GUALACA"
53 "TIERRAS ALTAS"
54 "MARIATO"
55 "SANTA ISABEL"
56 "RÍO DE JESÚS"
57 "MACARACAS"
58 "BUGABA"
59 "CHAME"
60 "SAN CARLOS"
61 "TONOSÍ"
62 "BOQUERÓN"
63 "COLÓN"
64 "MONTIJO"
65 "PEDASÍ"
66 "AGUADULCE"
67 "PORTOBELO"
68 "DAVID"
69 "POCRÍ"
70 "LA CHORRERA"
71 "GUARARÉ"
72 "ARRAIJÁN"
73 "PANAMÁ"
74 "SAN MIGUELITO"
75 "TABOGA"
76 "LOS SANTOS"
77 "BOQUETE"
78 "DOLEGA"
79 "CHITRÉ"
80 "LAS TABLAS"
81 "SANTIAGO"
82 "ATALAYA"
;
lab val order order;
#d cr
save "${dta}8150_GraficoBarrasDistritos.dta", replace
	
#d ;
 twoway 
(bar P01 order, fcolor(brown%100) 		lcolor(brown%80) 			lwidth(vthin)) 
(bar P02 order, fcolor(dkgreen%100) 	lcolor(dkgreen%60) 			lwidth(vthin)) 
(bar P03 order, fcolor(blue%40) 		lcolor(purple%40) 			lwidth(vthin)) 
(bar P04 order, fcolor(khaki%80) 		lcolor(khaki%40) 			lwidth(vthin))  
(bar P05 order, fcolor(midblue%90) 		lcolor(midblue%40) 			lwidth(vthin)) 
(bar P06 order, fcolor(forest_green%80) lcolor(forest_green%60) 	lwidth(vthin)) 
(bar P07 order, fcolor(mint%80) 	lcolor(mint%40) 		lwidth(vthin)) 
(bar P08 order, fcolor(ebblue%60) 		lcolor(ebblue%40) 			lwidth(vthin)) 
(bar P09 order, fcolor(green%80) 		lcolor(green%40) 			lwidth(vthin)) 
(bar P10 order, fcolor(cranberry%80) 	lcolor(cranberry%40) 		lwidth(vthin))
(bar P11 order, fcolor(orange%80) 			lcolor(orange%80) 				lwidth(vthin))
(bar P12 order, fcolor(red%80) 			lcolor(red%40) 				lwidth(vthin))   
(bar P13 order, fcolor(navy%80) 		lcolor(navy%40) 			lwidth(vthin)) 
(bar PovRat2015 order, fcolor(navy%0) 		lcolor(gs5) 			lwidth(vthin))  
 , 
 ytitle(`"Tasas de pobreza en porcentaje"')
xtitle("") xlabel(1(1)82, labsize(relative1p2) angle(forty_five) valuelabel)
 ylabel(, glwidth(vthin)) xlabel(, glwidth(vvthin))
 ylabel(0(10)100, labsize(small) angle(horizontal))
 xsize(14) ysize(8) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
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
	10	"COMARCA KUNA YALA"
	11	"COMARCA EMBERA"
	12	"COMARCA NGOBE BUGLE"
	13	"PANAMA OESTE"
) rows(3) size(tiny) region(margin(zero)) bmargin(zero) position(6)) 
title("Tasa de Pobreza 2023 por Distrito (Preliminar)") subtitle("En negro la tasa de pobreza 2015")
note("Nota: Estimación del Banco Mundial utilizando el Censo de Población y Vivienda de 2023 y la Encuesta de Propósitos Múltiples de 2021.",size(vsmall))
;
gr_edit note.DragBy -1 0.1 ;
#d cr
graph export "${graphs}8150_GraficobarrasDistritos.jpg", as(jpg) name("Graph") replace quality(100)
graph export "${graphs}8150_GraficobarrasDistritos.svg", as(svg) name("Graph") replace


