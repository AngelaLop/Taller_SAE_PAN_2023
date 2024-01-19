* 1100_Censo2023_Vivienda.do


****************************************************************************************************
use "${censo2023}stata/CEN2023_PERSONA.dta", clear
	gen one=1
	collapse (sum) one, by(LLAVEVIV)
	unique LLAVEVIV
tempfile conpersonas
save 	`conpersonas'
use "${censo2023}stata/CEN2023_VIVIENDA.dta", clear
merge 1:1 LLAVEVIV using `conpersonas'
	keep if _m==3
	drop _m
*---------------------------------------------------------------------------------------------------
	tab V01_TIPO V02_COND	// solo los primeros 4 valores
	des V01_TIPO	//	V01_TIPO        byte    %76.0f     VIVIENDA   1. TIPO DE VIVIENDA
	tab V01_TIPO if V01_TIPO<=4, m
	keep if V01_TIPO<=4
	lab lis VIVIENDA
	gen 	H_individual = V01_TIPO==1
	gen 	H_improvisad = V01_TIPO==2
	gen 	H_apartament = V01_TIPO==3
	gen 	H_vecindadcu = V01_TIPO==4
	lab var H_individual 	"Vivienda individual"
	lab var H_improvisad 	"Vivienda improvisada"
	lab var H_apartament 	"Vivienda es apartamento"
	lab var H_vecindadcu 	"Vivienda es cuarto en vecindad"
	*-------------------------------------------------
	tab V02_COND
	*-------------------------------------------------
	tab V03_TENE, m
		//          3. TENENCIA |      Freq.     Percent        Cum.
		// ---------------------+-----------------------------------
		//         1 Hipotecada |    217,227       18.08       18.08
		//          2 Alquilada |    157,657       13.12       31.19
		//             3 Propia |    763,183       63.50       94.70
		//             4 Cedida |     50,421        4.20       98.89
		// 5 Sucesión o litigio |      3,392        0.28       99.17
		//           6 Invadida |      9,929        0.83      100.00
		// ---------------------+-----------------------------------
		//                Total |  1,201,809      100.00
	des V03_TENE	//	byte    %21.0f     TENENCIA   3. TENENCIA
	lab lis TENENCIA
		// 1 1 Hipotecada
		// 2 2 Alquilada
		// 3 3 Propia
		// 4 4 Cedida
		// 5 5 Sucesión o litigio
		// 6 6 Invadida
	gen H_hipotecada = V03_TENE==1
	gen H_alquilada  = V03_TENE==2
	gen H_propia	 = V03_TENE==3
	gen H_cedida     = V03_TENE==4
	gen H_vivivotra  = V03_TENE==5 | V03_TENE==6  
	*-------------------------------------------------
	des V03A_PAGO	//	long    %18.0f     ND99999    3. PAGO MENSUAL
	tab V03A_PAGO, m
	gen H_pagoviv =  V03A_PAGO if V03A_PAGO<99999
	codebook H_pagoviv
	replace  H_pagoviv=0 if H_pagoviv==.
	*-------------------------------------------------
	des V04_PARED  	//	byte    %45.0f     PARED      4. MATERIAL DE LAS PAREDES
	tab V04_PARED, m
		//              4. MATERIAL DE LAS PAREDES |      Freq.     Percent        Cum.
		// ----------------------------------------+-----------------------------------
		//    1 Bloque, ladrillo, piedra, concreto |  1,061,997       88.37       88.37
		//               2 Madera (tablas o troza) |     88,847        7.39       95.76
		//                       3 Quincha o adobe |      7,811        0.65       96.41
		//         4 Metal (zinc, aluminio, otros) |     21,296        1.77       98.18
		// 5 Palma, paja, penca, cañaza, bambú o p |     13,358        1.11       99.29
		//                      6 Otros materiales |      7,488        0.62       99.92
		//                           7 Sin paredes |      1,012        0.08      100.00
		// ----------------------------------------+-----------------------------------
		//                                   Total |  1,201,809      100.00
	lab lis PARED
	gen H_pladrillo = V04_PARED==1
	gen H_pmadera   = V04_PARED==2
	gen H_pmetal    = V04_PARED==4
	gen H_pbambu    = V04_PARED==5
	gen H_paredotr  = V04_PARED==3|V04_PARED==6|V04_PARED==7
	*-------------------------------------------------
	des V05_TECHO	//	byte    %62.0f     TECHO      5. MATERIAL DEL TECHO
	tab V05_TECHO, m
		//                   5. MATERIAL DEL TECHO |      Freq.     Percent        Cum.
		// ----------------------------------------+-----------------------------------
		//   1 Metal (zinc, aluminio, entre otros) |    988,541       82.25       82.25
		//                                  2 Teja |     27,061        2.25       84.51
		// 3 Otro tipo de tejas (tejalit, panalit, |     79,034        6.58       91.08
		//                      4 Losa de concreto |     90,410        7.52       98.61
		//                                5 Madera |      2,252        0.19       98.79
		//                   6 Palma, paja o penca |     13,906        1.16       99.95
		//                      7 Otros materiales |        605        0.05      100.00
		// ----------------------------------------+-----------------------------------
		//                                   Total |  1,201,809      100.00
	lab lis TECHO
	gen H_tmetal 	= V05_TECHO==1
	gen H_tteja 	= V05_TECHO==2
	gen H_ttejaotr 	= V05_TECHO==3
	gen H_tconcreto = V05_TECHO==4
	gen H_tpalma 	= V05_TECHO==6
	*-------------------------------------------------
	des V06_PISO	//	byte    %56.0f     PISO       6. MATERIAL DEL PISO
	tab V06_PISO, m
		//                    6. MATERIAL DEL PISO |      Freq.     Percent        Cum.
		// ----------------------------------------+-----------------------------------
		//    1 Mosaico o baldosa, mármol o parqué |    680,221       56.60       56.60
		//                2 Pavimentado (concreto) |    418,882       34.85       91.45
		//                              3 Ladrillo |        693        0.06       91.51
		//                                4 Tierra |     65,379        5.44       96.95
		//                                5 Madera |     35,070        2.92       99.87
		// 6 Otros materiales (caña, palos, desech |      1,564        0.13      100.00
		// ----------------------------------------+-----------------------------------
		//                                   Total |  1,201,809      100.00
	lab lis PISO
	gen H_fmosaico 	= V06_PISO==1
	gen H_fpavimen 	= V06_PISO==2
	gen H_ftierra 	= V06_PISO==4
	gen H_fmadera 	= V06_PISO==5
	*-------------------------------------------------
	des V07_CUAR
	tab V07_CUAR, m		//	393,683 missing
	*-------------------------------------------------
	des V07_CUAR
	tab V07_CUAR, m		//	393,683 missing
	gen H_ncuartos = V07_CUAR
	*-------------------------------------------------
	des V07A_DORM
	tab V07A_DORM, m		//	393,683 missing
	gen H_ndormit = V07A_DORM
	*-------------------------------------------------
	des V08_AGUA		//	AGUA       8. ABASTECIMIENTO DE AGUA
	tab V08_AGUA, m		//	no missing
	gen H_aacuepub = V08_AGUA==1
	gen H_aacuecom = V08_AGUA==2
	gen H_aacuepar = V08_AGUA==3
	gen H_apozopro = V08_AGUA==4
	gen H_arioqueb = V08_AGUA==8
	gen H_aaguabot = V08_AGUA==10
	gen H_aotro    = V08_AGUA==5 | V08_AGUA==6 | V08_AGUA==7 | V08_AGUA==9 | V08_AGUA==11 | V08_AGUA==12 
	gen H_aacueduc = (H_aacuepub==1|H_aacuecom==1|H_aacuepar==1)
	gen H_asegura  = (H_aacueduc==1|H_apozopro==1|H_aaguabot==1)
	*-------------------------------------------------
	des V08_PAGOAGUA	//	 %30.0f     PAGOAGUA   8. CUÁNTO PAGA REGULARMENTE AL MES
	codebook V08_PAGOAGUA
	gen 	H_apago = V08_PAGOAGUA
	replace H_apago = 0  if V08_PAGOAGUA==9997 | V08_PAGOAGUA==9998
	replace H_apago = 0  if V08_PAGOAGUA==9999 | V08_PAGOAGUA==.
	gen 	H_anopaga =    (V08_PAGOAGUA==9999 | V08_PAGOAGUA==.)
	*-------------------------------------------------
	des V09_INST		//	SINO       9. UBICACIÓN DE LAS INSTALACIONES PARA BEBER DENTRO DE LA VIVIENDA
	tab V09_INST, m
		//          Sí |  1,007,795       83.86       83.86
		//          No |     98,692        8.21       92.07
		//           . |     95,322        7.93      100.00
		// ------------+-----------------------------------
		//       Total |  1,201,809      100.00
	tab H_aacueduc V09_INST ,m
		// H_aacueduc |        Sí         No          . |     Total
		// -----------+---------------------------------+----------
		//          0 |         0          0     95,322 |    95,322 
		//          1 | 1,007,795     98,692          0 | 1,106,487 
		// -----------+---------------------------------+----------
		//      Total | 1,007,795     98,692     95,322 | 1,201,809
	gen 	H_adentro = V09_INST==1
	lab var H_adentro "Agua para beber dentro de la casa"
	*-------------------------------------------------
	des V10A_DIASES 	//	10. DÍAS A LA SEMANA EN ESTACIÓN SECA
	tab V10A_DIASES, m	//	95,322 missing
	gen 	H_andiasseca = 		V10A_DIASES
	replace H_andiasseca = 0 if V10A_DIASES==.
	tab 	H_andiasseca, m
	lab var H_andiasseca "Días a la semana con agua en estación seca"
	*-----------------------
	des V10A_REGES 		//	10. HORAS AL DÍA EN ESTACIÓN SECA
	tab V10A_REGES, m	//	95,322 missing
	gen 	H_anhoraseca = 		V10A_REGES
	replace H_anhoraseca = 0 if V10A_REGES==.
	tab 	H_anhoraseca, m
	lab var H_anhoraseca "Horas al día con agua en estación seca"	
	*-----------------------
	des V10B_DIASEL 	//	10. DÍAS A LA SEMANA EN ESTACIÓN LLUVIOSA
	tab V10B_DIASEL, m	//	95,322 missing
	gen 	H_andiaslluv = 		V10B_DIASEL
	replace H_andiaslluv = 0 if V10B_DIASEL==.
	tab 	H_andiaslluv, m
	lab var H_andiaslluv "Días a la semana con agua en estación seca"
	*-----------------------
	des V10B_REGEL		//	10. HORAS AL DÍA EN ESTACIÓN LLUVIOSA
	tab V10B_REGEL, m	//	95,322 missing
	gen 	H_anhoralluv = 		V10B_REGEL
	replace H_anhoralluv = 0 if V10B_REGEL==.
	tab 	H_anhoralluv, m
	lab var H_anhoralluv "Horas al día con agua en estación lluviosa"	
	
	tab H_andiasseca H_andiaslluv, m nofreq cell
	gen H_aalldia = (H_andiasseca==7 & H_andiaslluv==7)
	tab H_aalldia, m
	tab H_anhoraseca H_anhoralluv, m nofreq cell
	gen H_aallhora = (H_anhoraseca==24 & H_anhoralluv==24)	
	tab H_aallhora, m
	gen H_asiempre = (H_aalldia==1 & H_aallhora==1)
	tab H_asiempre, m
	egen H_amindias = rowmin(H_andiasseca H_andiaslluv)
	egen H_aminhora = rowmin(H_andiasseca H_andiaslluv)
	
	lab var H_aalldia  "Agua todos los días"
	lab var H_aallhora "Agua todas las horas"
	lab var H_asiempre "Agua todos los días y horas"
	lab var H_amindias "Agua: mínimo número de días"
	lab var H_aminhora "Agua: mínimo número de horas"
	*-------------------------------------------------
	des V11_SANIT		//	SANIT      11. SERVICIO SANITARIO
	tab V11_SANIT, m
		// 1 Conectado a alcantarillado |    492,998       41.02       41.02
		// 2 Conectado a tanque séptico |    503,479       41.89       82.91
		//         3 De hueco o letrina |    160,867       13.39       96.30
		//                   4 No tiene |     44,465        3.70      100.00
	gen H_salcanta = V11_SANIT==1
	gen H_stansept = V11_SANIT==2
	gen H_sletrina = V11_SANIT==3
	gen H_snotiene = V11_SANIT==4
	lab var H_salcanta "Vivienda conectada a alcantarillado"
	lab var H_stansept "Vivienda conectada a tanque séptico"
	lab var H_sletrina "Vivienda usa hueco o letrina"
	lab var H_snotiene "Vivienda no tiene servicio sanitario"
	*-------------------------------------------------
	des V12_SUSO		//	SUSO       12. USO DEL SANITARIO
	tab V12_SUSO, m
		//       1 Exclusivo de la vivienda |  1,109,908       92.35       92.35
		// 2 Compartido con otras viviendas |     47,436        3.95       96.30
		//                                . |     44,465        3.70      100.00
		// ---------------------------------+-----------------------------------
		//                            Total |  1,201,809      100.00
	gen H_sexclusivo = V12_SUSO==1
	gen H_scompartid = V12_SUSO==2
	lab var H_sexclusivo "Vivienda con servicio sanitario exclusivo"
	lab var H_scompartid "Vivienda con servicio sanitario compartido"
	*-------------------------------------------------
	des V13_EXCR		//	EXCR       13. LUGAR PARA DEPOSITAR LAS EXCRETAS
	tab V13_EXCR
		//                                1 Monte |      6,382       14.35       14.35
		//                       2 Río o quebrada |     14,022       31.53       45.89
		//                                  3 Mar |      6,403       14.40       60.29
		// 4 Usa el servicio sanitario del vecino |     15,753       35.43       95.72
		//                                 5 Otro |      1,905        4.28      100.00
		// ---------------------------------------+-----------------------------------
		//                                  Total |     44,465      100.00
	gen H_sdepmonte 	= V13_EXCR==1
	gen H_sdeprio 		= V13_EXCR==2
	gen H_sdepmar 		= V13_EXCR==3
	gen H_sdepvecino 	= V13_EXCR==4
	gen H_sdepotro	 	= V13_EXCR==5
	lab var H_sdepmonte 	"Vivienda deposita excretas en el monte"
	lab var H_sdeprio 		"Vivienda deposita excretas en el río"
	lab var H_sdepmar 		"Vivienda deposita excretas en el mar"
	lab var H_sdepvecino 	"Vivienda deposita excretas en donde el vecino"
	lab var H_sdepotro 		"Vivienda deposita excretas en otro lugar"
	*-------------------------------------------------
	des V14_LUZ			//	LUZ        14. TIPO DE ALUMBRADO
	tab V14_LUZ, m
		// 1 Eléctrico de compañía distribuidora |  1,082,313       90.06       90.06
		//           2 Eléctrico de la comunidad |      8,930        0.74       90.80
		//           3 Eléctrico propio (planta) |      3,328        0.28       91.08
		//                4 Panel solar (propio) |     49,206        4.09       95.17
		//                   5 Querosén o diésel |      2,329        0.19       95.37
		//                                6 Vela |      6,289        0.52       95.89
		//         7 Linterna o lámpara portátil |     45,598        3.79       99.68
		//                                 8 Gas |         73        0.01       99.69
		//                                9 Otro |      3,743        0.31      100.00
		// --------------------------------------+-----------------------------------
		//                                 Total |  1,201,809      100.00
	gen H_lcompania = V14_LUZ==1
	gen H_lpanelsol = V14_LUZ==4
	gen H_llamparap = V14_LUZ==7
	gen H_lelectric = V14_LUZ==1 | V14_LUZ==2 | V14_LUZ==3 
	gen H_lotro     = V14_LUZ==5 | V14_LUZ==6 | V14_LUZ==8 | V14_LUZ==9
	lab var H_lcompania "Alumbrado compañía eléctrica"
	lab var H_lpanelsol "Alumbrado por panel solar"
	lab var H_llamparap "Alumbrado por linterna o lámpara portatil"
	lab var H_lelectric "Alumbrado eléctrico"
	lab var H_lotro 	"Alumbrado por otro medio"
	*-------------------------------------------------
	des V15_BASU		//	BASU       15. ELIMINACIÓN DE LA BASURA
	tab V15_BASU, m
		// 1 Servicio de recolección público |    788,575       65.62       65.62
		// 2 Servicio de recolección privado |    123,118       10.24       75.86
		//            3 Incineración o quema |    239,023       19.89       95.75
		//                  4 Terreno baldío |     16,084        1.34       97.09
		//                        5 Entierro |     21,264        1.77       98.86
		//       6 Río, quebrada, lago o mar |      5,184        0.43       99.29
		//                      7 Otra forma |      8,561        0.71      100.00
		// ----------------------------------+-----------------------------------
		//                             Total |  1,201,809      100.00
	gen H_bpublico = V15_BASU==1
	gen H_bprivado = V15_BASU==2
	gen H_bquema   = V15_BASU==3
	gen H_btbaldio = V15_BASU==4
	gen H_bentierr = V15_BASU==5
	gen H_botro    = V15_BASU==6 | V15_BASU==7
	lab var H_bpublico "Basura: servicio público"
	lab var H_bprivado "Basura: servicio privado"
	lab var H_bquema   "Basura: quema"
	lab var H_btbaldio "Basura: terreno baldío"
	lab var H_bentierr "Basura: entierro"
	lab var H_botro    "Basura: otro método de eliminación de basura"
	*-------------------------------------------------
	des V16_COMB		//	COMB       16. COMBUSTIBLE PARA COCINAR
	tab V16_COMB, m
		//          1 Gas |  1,102,863       91.77       91.77
		//         2 Leña |     72,179        6.01       97.77
		// 3 Electricidad |     12,174        1.01       98.79
		//     4 Querosén |        106        0.01       98.79
		//       5 Carbón |         31        0.00       98.80
		//    6 No cocina |     14,456        1.20      100.00
		// ---------------+-----------------------------------
		//          Total |  1,201,809      100.00
	gen H_cgas      = V16_COMB==1
	gen H_clena     = V16_COMB==2
	gen H_celectri  = V16_COMB==3
	gen H_cnococina = V16_COMB==6
	gen H_cmoderna  = V16_COMB==1 | V16_COMB==3
	lab var H_cgas      "Cocina: gas"
	lab var H_clena     "Cocina: leña"
	lab var H_celectri  "Cocina: eléctrica"
	lab var H_cnococina "Cocina: No cocina"
	lab var H_cmoderna  "Cocina: moderna: gas o eléctrica"
	*-------------------------------------------------
	des V17_NHOG		//	17. NÚMERO DE HOGARES EN LA VIVIENDA
	tab V17_NHOG, m
	gen H_numhogares = V17_NHOG
	lab var H_numhogares "Número de hogares en la vivienda"
	*-------------------------------------------------

	lab var H_hipotecada 	"Tenencia: vivienda hipotecada"
	lab var H_alquilada  	"Tenencia: vivienda alquilada"
	lab var H_propia	 	"Tenencia: vivienda propia"
	lab var H_cedida     	"Tenencia: vivienda cedida"
	lab var H_vivivotra  	"Tenencia: vivienda otra condición"
	lab var H_pladrillo 	"Pared: Bloque, ladrillo, piedra, concreto"
	lab var H_pmadera   	"Pared: Madera (tablas o troza)"
	lab var H_pmetal    	"Pared: metal"
	lab var H_pbambu    	"Pared: Palma, paja, penca, cañaza, bambú o palos"
	lab var H_paredotr		"Pared: other"
	lab var H_tmetal 		"Techo: Metal (zinc, aluminio, entre otros)"
	lab var H_tteja 		"Techo: Teja"
	lab var H_ttejaotr 		"Techo: Otro tipo de tejas (tejalit, panalit, techolit, entre otras)"
	lab var H_tconcreto 	"Techo: Losa de concreto"
	lab var H_tpalma 		"Techo: Palma, paja o penca"	
	lab var H_fmosaico 		"Piso: Mosaico o baldosa, mármol o parqué"
	lab var H_fpavimen 		"Piso: Pavimentado (concreto)"
	lab var H_ftierra 		"Piso: Tierra"
	lab var H_fmadera 		"Piso: Madera"	
	lab var H_pagoviv	 	"Pago por vivienda"
	lab var H_ncuartos 	 	"Número de cuartos"
	lab var H_ndormit 	 	"Número de dormitorios"
	lab var H_aacuepub 		"Acueducto público del IDAAN"
	lab var H_aacuecom 		"Acueducto público de la comunidad"
	lab var H_aacuepar 		"Acueducto particular"
	lab var H_apozopro 		"Pozo brocal protegido"
	lab var H_arioqueb 		"Río, quebrada o lago"
	lab var H_aaguabot 		"Agua embotellada"
	lab var H_aotro 		"Otra fuente de agua"
	lab var H_aacueduc 		"Acueducto"
	lab var H_asegura 		"Acueducto, pozo protegido, o agua embotellada"
	lab var H_apago   		"Pago mensual por agua"
	lab var H_anopaga 		"No paga por agua o no declara"
	*-----------------------------------------------------------------------------------------------
	keep LLAVEVIV H_*
	compress
	sum
	drop H_anhoraseca H_aallhora H_asiempre H_aminhora
	sum
save "${dta}1100_Censo2023_Vivienda.dta", replace
****************************************************************************************************