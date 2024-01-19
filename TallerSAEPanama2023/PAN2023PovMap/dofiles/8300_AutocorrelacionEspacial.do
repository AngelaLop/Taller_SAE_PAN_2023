* 8300_AutocorrelacionEspacial.do

*---------------------------------------------------------------------------------------------------
use  "${output}5220_TR20_lnskew_NationalModel_resultseml21incenso_200405.dta", clear
	gen codePD =floor(Unit/100)
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
keep codePD PovRate PovGap PovSev PROV_ID DIST_ID  DIST_NOMB
tempfile poverty2
save	`poverty2'
use "C:\Users\wb546376\WBG\Knowledge ELCPV - WB Group - panama\PAN_YYYY_POVMAP_PPPP_vNN_s_YYYY_SSSS_b_YYYY_BBBB\06_Indicators\LVL2_Distrito\a location IDs\tolink2023_ADM2_ES_dist_nom.dta", clear
	keep PROV_ID DIST_ID prov_nom dist_nom
merge 1:1 PROV_ID DIST_ID using `poverty2', nogen
	drop DIST_NOMB
// 	duplicates tag prov_nom dist_nom , generate(newvar)
	collapse (first) PovRate PovGap PovSev, by(prov_nom dist_nom)
tempfile poverty3
save	`poverty3'


use "${shapefiles2023}PAN2021dist.dta", clear
gen prov_nom = ustrupper( ustrregexra( ustrnormalize( ADM1_ES, "nfd" ) , "\p{Mark}", "" ) )
gen dist_nom = ustrupper( ustrregexra( ustrnormalize( ADM2_ES, "nfd" ) , "\p{Mark}", "" ) )
	replace prov_nom = "COMARCA EMBERA" if prov_nom=="EMBERA"
	replace prov_nom = "COMARCA KUNA YALA" if prov_nom=="KUNA YALA"
	replace prov_nom = "COMARCA NGOBE BUGLE" if prov_nom=="NGOBE BUGLE"
	replace dist_nom = "COMARCA KUNA YALA" if dist_nom=="KUNA YALA"
	replace dist_nom = "MINA" if dist_nom=="MUNA"
	replace dist_nom = "ÑURUM" if dist_nom=="NURUM"
	replace dist_nom = "CAÑAZAS" if dist_nom=="CANAZAS"
tempfile shape21
save	`shape21'
use `poverty3, clear'
merge 1:1 prov_nom dist_nom using `shape21', nogen
save "${dta}8300_AutocorrelacionEspacial.dta", replace

*-------------------------------------------------
use "${dta}8300_AutocorrelacionEspacial.dta", clear
getisord PovRate, lat(_CY) lon(_CX) swm(bin) dist(150) dunit(km) detail approx
gen hpcluster=1 if go_z_PovRate_b<-2.576
gen lpcluster=1 if go_z_PovRate_b> 2.576 & PovRate!=.
tempfile pov
save 	`pov'
use `pov'
	keep if hpcluster==1
	drop go_z_PovRate_b go_p_PovRate_b
	getisord PovRate, lat(_CY) lon(_CX) swm(bin) dist(30) dunit(km) detail
	gsort go_z_PovRate_b
	gen hlpcluster=1 if go_z_PovRate_b>2.576
	keep _ID hlpcluster
tempfile hlpcluster
save 	`hlpcluster'
use `pov'
	keep if lpcluster==1
	drop go_z_PovRate_b go_p_PovRate_b
	getisord PovRate, lat(_CY) lon(_CX) swm(bin) dist(50) dunit(km) detail
	gsort go_z_PovRate_b
	gen lhpcluster=1 if go_z_PovRate_b<-1.5
	keep _ID lhpcluster
tempfile lhpcluster
save 	`lhpcluster'
use 	`pov'
merge 1:1 _ID using `hlpcluster', nogen
merge 1:1 _ID using `lhpcluster', nogen
gen 	cluster = .
replace cluster =  0 if go_z_PovRate_b>-2.576 & go_z_PovRate_b< 2.576
replace cluster = -2 if go_z_PovRate_b>-100   & go_z_PovRate_b<-2.576
replace cluster = -1 if hlpcluster==1

replace cluster =  2 if go_z_PovRate_b> 2.576 & go_z_PovRate_b< 100
replace cluster =  1 if lhpcluster==1
replace cluster =  . if PovRate==.
tab cluster, m

spmap cluster using "${shapefiles2023}PAN2021dist_shp.dta" , id(_ID) clm(custom) clb(-100 -1.5 -0.5 0.5 1.5 100)    fcolor(ebblue orange  white  eltblue red) legend(ring(1) position(6) lab(1 "No data") lab(2 "Low poverty cluster") lab(3 "High poverty cluster in low poverty cluster") lab(4 "No significant clustering") lab(5 "Low poverty cluster in high poverty cluster")  lab(6 "High poverty cluster")) title("", size(medsmall))   osize(vthin ..)  ndocolor(gs4 ..) ndsize(vvthin ..)   xsize(50cm) ysize(30cm)   ndfcolor(gs8)  ocolor(gs5 ..) title("Autocorrelación Espacial de la Pobreza", size(large)) 

graph save "Graph" "${graphs}8300_AutocorrelacionEspacial.gph", replace
graph export       "${graphs}8300_AutocorrelacionEspacial.png", as(png) name("Graph") replace
graph export       "${graphs}8300_AutocorrelacionEspacial.svg", as(svg) name("Graph") replace
graph export       "${graphs}8300_AutocorrelacionEspacial.jpg", as(jpg) name("Graph") replace quality(100)

