*8200_CoberturaProgramas.do


****************************************************************************************************
use "${censo2023}stata/CEN2023_PERSONA.dta", clear
*---------------------------------------------------------------------------------------------------
	des P225A_REDOPOR P225B_120A65 P225C_ANGELG
		// P225A_REDOPOR   byte    %22.0f     REDOPOR    22.5A. RED DE OPORTUNIDADES
		// P225B_120A65    byte    %14.0f     L120A65    22.5B. 120 A LOS 65
		// P225C_ANGELG    byte    %17.0f     ANGELGUA   22.5C. ÁNGEL GUARDIÁN
	lab lis REDOPOR		//	1 1 Red de oportunidades
	lab lis L120A65		//	2 2 120 a los 65
	lab lis ANGELGUA	//	3 3 Angel Guardián
	
	gen recibered = P225A_REDOPOR==1
	gen recibe120 = P225B_120A65 ==2
	gen recibeang = P225C_ANGELG ==3
	
	gen recibealgun = recibered==1 | recibe120==1 | recibeang==1

	collapse (sum) recibe* , by(LLAVEVIV HOGAR)
	tab1 recibe*,m
	
	replace recibered  =1 if recibered>1
	replace recibe120  =1 if recibe120>1
	replace recibeang  =1 if recibeang>1
	replace recibealgun=1 if recibealgun>1
	tab1 recibe*,m
	
merge 1:1 LLAVEVIV HOGAR using "${dta}1010_Hogar_PDCAVH.dta", nogen
merge 1:1 codePDCAVH using "${dta}6220_vulnerability.dta", keepusing(poor popwt)
	keep if _m==3
	drop _m
	gen recibepobre = poor==1 & recibealgun==1
	tab poor recibealgun [aw=popwt], m nofreq cell
	//            |   (sum) recibealgun
	//       poor |         0          1 |     Total
	// -----------+----------------------+----------
	//          0 |     72.25       5.93 |     78.18 
	//          1 |     15.86       5.96 |     21.82 
	// -----------+----------------------+----------
	//      Total |     88.11      11.89 |    100.00

// tempfile programas	
// save	`programas'
// use "${dta}1010_Hogar_PDCAVH.dta", clear	
// merge 1:1 LLAVEVIV HOGAR using `programas', nogen
	collapse (mean) recibe* poor [pw=popwt], by(codeP codePD codePDC)
	format recibe* %9.0f
	replace recibered   = 100*recibered
	replace recibe120   = 100*recibe120	
	replace recibeang   = 100*recibeang
	replace recibealgun = 100*recibealgun
	replace recibepobre = 100*recibepobre
	replace poor=100*poor
tempfile input
save 	`input'


use "${censo2023}stata/CEN2023_CORREG.dta", clear
	gen 	 codePDC = PROV_ID + DIST_ID + CORR_ID
	destring codePDC, replace
	keep codePDC PROV_NOMBRE DIST_NOMBRE CORR_NOMBRE PROV_ID
tempfile codePDC
save 	`codePDC'
use "${output}5220_TR20_lnskew_NationalModel_resultseml21incenso_200405.dta", clear
	rename Unit codePDC
	gen PovRat2023 = 100*avg_fgt0_plinevar
	gen NumPob = nIndividuals*avg_fgt0_plinevar
	keep codePDC PovRat2023 NumPob
	format PovRat2023 %9.0f
merge 1:1 codePDC using `codePDC'	, nogen
merge m:1 codePDC using `input', nogen
	sum NumPob

set obs 736
	replace recibered 	=   0 in 700
	replace recibered 	= 100 in 701
	replace recibe120 	=   0 in 700
	replace recibe120 	= 100 in 701
	replace recibeang 	=   0 in 700
	replace recibeang 	= 100 in 701
	replace recibealgun =   0 in 700
	replace recibealgun = 100 in 701
	replace recibepobre =   0 in 700
	replace recibepobre = 100 in 701	
	replace PovRat2023  =   0 in 700
	replace PovRat2023  = 100 in 701
	replace poor  		=   0 in 700
	replace poor  		= 100 in 701
	
	replace NumPob  =      5 in 711/736
	replace NumPob  = 500000 in 712
	replace NumPob  = 500000 in 714
	replace NumPob  = 500000 in 716
	replace NumPob  = 500000 in 718
	replace NumPob  = 500000 in 720
	replace NumPob  = 500000 in 722
	replace NumPob  = 500000 in 724
	replace NumPob  = 500000 in 726
	replace NumPob  = 500000 in 728
	replace NumPob  = 500000 in 730
	replace NumPob  = 500000 in 732
	replace NumPob  = 500000 in 734
	replace NumPob  = 500000 in 736
	replace codeP   =      1 in 711/712
	replace codeP   =      2 in 713/714
	replace codeP   =      3 in 715/716
	replace codeP   =      4 in 717/718
	replace codeP   =      5 in 719/720
	replace codeP   =      6 in 721/722
	replace codeP   =      7 in 723/724
	replace codeP   =      8 in 725/726
	replace codeP   =      9 in 727/728
	replace codeP   =     10 in 729/730
	replace codeP   =     11 in 731/732
	replace codeP   =     12 in 733/734
	replace codeP   =     13 in 735/736


	
	
#d ;
twoway 
(scatter recibered PovRat2023  if codeP==1  [pweight = NumPob], mfcolor(brown%50) 			mlcolor(%0)) 
(scatter recibered PovRat2023  if codeP==2  [pweight = NumPob], mfcolor(dkgreen%50) 		mlcolor(%0)) 
(scatter recibered PovRat2023  if codeP==3  [pweight = NumPob], mfcolor(purple%50) 			mlcolor(%0)) 
(scatter recibered PovRat2023  if codeP==4  [pweight = NumPob], mfcolor(khaki%50) 			mlcolor(%0))
(scatter recibered PovRat2023  if codeP==5  [pweight = NumPob], mfcolor(midblue%50) 		mlcolor(%0))
(scatter recibered PovRat2023  if codeP==6  [pweight = NumPob], mfcolor(forest_green%50) 	mlcolor(%0))
(scatter recibered PovRat2023  if codeP==7  [pweight = NumPob], mfcolor(mint%50) 			mlcolor(%0))
(scatter recibered PovRat2023  if codeP==8  [pweight = NumPob], mfcolor(ebblue%50) 			mlcolor(%0))
(scatter recibered PovRat2023  if codeP==9  [pweight = NumPob], mfcolor(green%50) 			mlcolor(%0))
(scatter recibered PovRat2023  if codeP==10 [pweight = NumPob], mfcolor(cranberry%50) 		mlcolor(%0))
(scatter recibered PovRat2023  if codeP==11 [pweight = NumPob], mfcolor(orange%50) 			mlcolor(%0))
(scatter recibered PovRat2023  if codeP==12 [pweight = NumPob], mfcolor(red%50) 			mlcolor(%0))
(scatter recibered PovRat2023  if codeP==13 [pweight = NumPob], mfcolor(navy%50) 			mlcolor(%0)) 
(line    recibered PovRat2023  in 700/701, sort lcolor(gs5) lwidth(thin) lpattern(dash)) 
, 
ytitle("Porcentaje de la poblacion en hogares que se benefician de Red de Oportunidades") 
ytitle(, size(small)) ylabel(0(10)100, labsize(small) angle(horizontal)) 
xtitle(`"Tasa de pobreza 2023 (en porcentaje)"') 
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
) rows(3) size(tiny) region(margin(zero)) bmargin(zero) position(6)) 
xsize(20) ysize(24) aspectratio(1) 
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
title(Cobertura en el Censo 2023 del Programa Red de Oportunidades, size(small))
subtitle(Ponderado por poblacion, size(small))
note("Nota: Estimación preliminar del Banco Mundial utilizando el CPV 2023 y la EPM  2021.", size(vsmall))
;
#d cr
graph export "${graphs}8200_RedOportunidades.png", as(png) name("Graph") replace
graph export "${graphs}8200_RedOportunidades.svg", as(svg) name("Graph") replace	
graph export "${graphs}8200_RedOportunidades.jpg", as(jpg) name("Graph") replace quality(100)
	
#d ;
twoway 
(scatter recibe120 PovRat2023  if codeP==1  [pweight = NumPob], mfcolor(brown%30) 			mlcolor(%0)) 
(scatter recibe120 PovRat2023  if codeP==2  [pweight = NumPob], mfcolor(dkgreen%30) 		mlcolor(%0)) 
(scatter recibe120 PovRat2023  if codeP==3  [pweight = NumPob], mfcolor(purple%30) 			mlcolor(%0)) 
(scatter recibe120 PovRat2023  if codeP==4  [pweight = NumPob], mfcolor(khaki%30) 			mlcolor(%0))
(scatter recibe120 PovRat2023  if codeP==5  [pweight = NumPob], mfcolor(midblue%30) 		mlcolor(%0))
(scatter recibe120 PovRat2023  if codeP==6  [pweight = NumPob], mfcolor(forest_green%30) 	mlcolor(%0))
(scatter recibe120 PovRat2023  if codeP==7  [pweight = NumPob], mfcolor(mint%30) 			mlcolor(%0))
(scatter recibe120 PovRat2023  if codeP==8  [pweight = NumPob], mfcolor(ebblue%30) 			mlcolor(%0))
(scatter recibe120 PovRat2023  if codeP==9  [pweight = NumPob], mfcolor(green%30) 			mlcolor(%0))
(scatter recibe120 PovRat2023  if codeP==10 [pweight = NumPob], mfcolor(cranberry%30) 		mlcolor(%0))
(scatter recibe120 PovRat2023  if codeP==11 [pweight = NumPob], mfcolor(orange%30) 			mlcolor(%0))
(scatter recibe120 PovRat2023  if codeP==12 [pweight = NumPob], mfcolor(red%30) 			mlcolor(%0))
(scatter recibe120 PovRat2023  if codeP==13 [pweight = NumPob], mfcolor(navy%30) 			mlcolor(%0)) 
(line    recibe120 PovRat2023  in 700/701, sort lcolor(gs5) lwidth(thin) lpattern(dash)) 
, 
ytitle("Porcentaje de la poblacion en hogares que se benefician de 120 a los 65") 
ytitle(, size(small)) ylabel(0(10)100, labsize(small) angle(horizontal)) 
xtitle(`"Tasa de pobreza 2023 (en porcentaje)"') 
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
) rows(3) size(tiny) region(margin(zero)) bmargin(zero) position(6)) 
xsize(20) ysize(24) aspectratio(1) 
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
title(Cobertura en el Censo 2023 del Programa 120 a los 65, size(small))
subtitle(Ponderado por poblacion, size(small))
note("Nota: Estimación preliminar del Banco Mundial utilizando el CPV 2023 y la EPM  2021.", size(vsmall))
;
#d cr
graph export "${graphs}8200_120 A LOS 65.png", as(png) name("Graph") replace
graph export "${graphs}8200_120 A LOS 65.svg", as(svg) name("Graph") replace	
graph export "${graphs}8200_120 A LOS 65.jpg", as(jpg) name("Graph") replace quality(100)

	
#d ;
twoway 
(scatter recibeang PovRat2023  if codeP==1  [pweight = NumPob], mfcolor(brown%30) 		mlcolor(%0)) 
(scatter recibeang PovRat2023  if codeP==2  [pweight = NumPob], mfcolor(dkgreen%30) 		mlcolor(%0)) 
(scatter recibeang PovRat2023  if codeP==3  [pweight = NumPob], mfcolor(purple%30) 		mlcolor(%0)) 
(scatter recibeang PovRat2023  if codeP==4  [pweight = NumPob], mfcolor(khaki%30) 		mlcolor(%0))
(scatter recibeang PovRat2023  if codeP==5  [pweight = NumPob], mfcolor(midblue%30) 		mlcolor(%0))
(scatter recibeang PovRat2023  if codeP==6  [pweight = NumPob], mfcolor(forest_green%30) 	mlcolor(%0))
(scatter recibeang PovRat2023  if codeP==7  [pweight = NumPob], mfcolor(mint%30) 			mlcolor(%0))
(scatter recibeang PovRat2023  if codeP==8  [pweight = NumPob], mfcolor(ebblue%30) 		mlcolor(%0))
(scatter recibeang PovRat2023  if codeP==9  [pweight = NumPob], mfcolor(green%30) 		mlcolor(%0))
(scatter recibeang PovRat2023  if codeP==10 [pweight = NumPob], mfcolor(cranberry%30) 	mlcolor(%0))
(scatter recibeang PovRat2023  if codeP==11 [pweight = NumPob], mfcolor(orange%30) 		mlcolor(%0))
(scatter recibeang PovRat2023  if codeP==12 [pweight = NumPob], mfcolor(red%30) 			mlcolor(%0))
(scatter recibeang PovRat2023  if codeP==13 [pweight = NumPob], mfcolor(navy%30) 			mlcolor(%0)) 
(line    recibeang PovRat2023  in 700/701, sort lcolor(gs5) lwidth(thin) lpattern(dash)) 
, 
ytitle("Porcentaje de la poblacion en hogares que se benefician de Angel Guardian") 
ytitle(, size(small)) ylabel(0(10)100, labsize(small) angle(horizontal)) 
xtitle(`"Tasa de pobreza 2023 (en porcentaje)"') 
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
) rows(3) size(tiny) region(margin(zero)) bmargin(zero) position(6)) 
xsize(20) ysize(24) aspectratio(1) 
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
title(Cobertura en el Censo 2023 del Programa Angel Guardian, size(small))
subtitle(Ponderado por poblacion, size(small))
note("Nota: Estimación preliminar del Banco Mundial utilizando el CPV 2023 y la EPM  2021.", size(vsmall))
;
#d cr
graph export "${graphs}8200_AngelGuardian.png", as(png) name("Graph") replace	
graph export "${graphs}8200_AngelGuardian.svg", as(svg) name("Graph") replace
graph export "${graphs}8200_AngelGuardian.jpg", as(jpg) name("Graph") replace quality(100)


preserve
replace PovRat2023=poor
#d ;
twoway 
(scatter recibealgun PovRat2023  if codeP==1  [pweight = NumPob], mfcolor(brown%30) 			mlcolor(%0)) 
(scatter recibealgun PovRat2023  if codeP==2  [pweight = NumPob], mfcolor(dkgreen%30) 		mlcolor(%0)) 
(scatter recibealgun PovRat2023  if codeP==3  [pweight = NumPob], mfcolor(purple%30) 			mlcolor(%0)) 
(scatter recibealgun PovRat2023  if codeP==4  [pweight = NumPob], mfcolor(khaki%30) 			mlcolor(%0))
(scatter recibealgun PovRat2023  if codeP==5  [pweight = NumPob], mfcolor(midblue%30) 		mlcolor(%0))
(scatter recibealgun PovRat2023  if codeP==6  [pweight = NumPob], mfcolor(forest_green%30) 	mlcolor(%0))
(scatter recibealgun PovRat2023  if codeP==7  [pweight = NumPob], mfcolor(mint%30) 			mlcolor(%0))
(scatter recibealgun PovRat2023  if codeP==8  [pweight = NumPob], mfcolor(ebblue%30) 			mlcolor(%0))
(scatter recibealgun PovRat2023  if codeP==9  [pweight = NumPob], mfcolor(green%30) 			mlcolor(%0))
(scatter recibealgun PovRat2023  if codeP==10 [pweight = NumPob], mfcolor(cranberry%30) 		mlcolor(%0))
(scatter recibealgun PovRat2023  if codeP==11 [pweight = NumPob], mfcolor(orange%30) 			mlcolor(%0))
(scatter recibealgun PovRat2023  if codeP==12 [pweight = NumPob], mfcolor(red%30) 			mlcolor(%0))
(scatter recibealgun PovRat2023  if codeP==13 [pweight = NumPob], mfcolor(navy%30) 			mlcolor(%0)) 
(line    recibealgun PovRat2023  in 700/701, sort lcolor(gs5) lwidth(thin) lpattern(dash)) 
, 
ytitle("Porcentaje de la poblacion en hogares que se benefician de al menos un programa") 
ytitle(, size(small)) ylabel(0(10)100, labsize(small) angle(horizontal)) 
xtitle(`"Tasa de pobreza 2023 (en porcentaje)"') 
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
) rows(3) size(tiny) region(margin(zero)) bmargin(zero) position(6)) 
xsize(20) ysize(24) aspectratio(1) 
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
title(Cobertura Total en el Censo 2023 por alguno de los tres programas, size(small))
subtitle(Ponderado por poblacion, size(small))
note("Nota: Estimación preliminar del Banco Mundial utilizando el CPV 2023 y la EPM  2021.", size(vsmall))

;
#d cr
graph export "${graphs}8200_Algunodelosprogramas.png", as(png) name("Graph") replace
graph export "${graphs}8200_Algunodelosprogramas.svg", as(svg) name("Graph") replace
graph export "${graphs}8200_Algunodelosprogramas.jpg", as(jpg) name("Graph") replace quality(100)

restore


preserve
replace PovRat2023=poor
#d ;
twoway 
(scatter recibepobre PovRat2023  if codeP==1  [pweight = NumPob], mfcolor(brown%30) 			mlcolor(%0)) 
(scatter recibepobre PovRat2023  if codeP==2  [pweight = NumPob], mfcolor(dkgreen%30) 		mlcolor(%0)) 
(scatter recibepobre PovRat2023  if codeP==3  [pweight = NumPob], mfcolor(purple%30) 			mlcolor(%0)) 
(scatter recibepobre PovRat2023  if codeP==4  [pweight = NumPob], mfcolor(khaki%30) 			mlcolor(%0))
(scatter recibepobre PovRat2023  if codeP==5  [pweight = NumPob], mfcolor(midblue%30) 		mlcolor(%0))
(scatter recibepobre PovRat2023  if codeP==6  [pweight = NumPob], mfcolor(forest_green%30) 	mlcolor(%0))
(scatter recibepobre PovRat2023  if codeP==7  [pweight = NumPob], mfcolor(mint%30) 			mlcolor(%0))
(scatter recibepobre PovRat2023  if codeP==8  [pweight = NumPob], mfcolor(ebblue%30) 			mlcolor(%0))
(scatter recibepobre PovRat2023  if codeP==9  [pweight = NumPob], mfcolor(green%30) 			mlcolor(%0))
(scatter recibepobre PovRat2023  if codeP==10 [pweight = NumPob], mfcolor(cranberry%30) 		mlcolor(%0))
(scatter recibepobre PovRat2023  if codeP==11 [pweight = NumPob], mfcolor(orange%30) 			mlcolor(%0))
(scatter recibepobre PovRat2023  if codeP==12 [pweight = NumPob], mfcolor(red%30) 			mlcolor(%0))
(scatter recibepobre PovRat2023  if codeP==13 [pweight = NumPob], mfcolor(navy%30) 			mlcolor(%0)) 
, 
ytitle("Porcentaje de la poblacion en hogares pobres que se benefician de al menos un programa") 
ytitle(, size(small)) ylabel(0(10)100, labsize(small) angle(horizontal)) 
xtitle(`"Tasa de pobreza 2023 (en porcentaje)"') 
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
) rows(3) size(tiny) region(margin(zero)) bmargin(zero) position(6)) 
xsize(20) ysize(23) aspectratio(1) 
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
title(Cobertura en los pobres el Censo 2023 por alguno de los programas, size(small))
subtitle(Ponderado por poblacion, size(small))
note("Nota: Estimación preliminar del Banco Mundial utilizando el CPV 2023 y la EPM  2021.", size(vsmall));
gr_edit yaxis1.title.DragBy -6 0 ;
#d cr
graph export "${graphs}8200_CoberturanelosPobres.png", as(png) name("Graph") replace
graph export "${graphs}8200_CoberturanelosPobres.svg", as(svg) name("Graph") replace
graph export "${graphs}8200_CoberturanelosPobres.jpg", as(jpg) name("Graph") replace quality(100)
restore






-4.154851693588935 0

