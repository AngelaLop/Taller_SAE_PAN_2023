* 2100_EML2021_Vivienda.do

	  
****************************************************************************************************
use "${EML2021}vivienda.dta", clear
*---------------------------------------------------------------------------------------------------
	des v1a_tipo_d	//	v1a_tipo_d      str1    %9s                   V1A_TIPO_D
	tab v1a_tipo_d	
		//  V1A_TIPO_D |      Freq.     Percent        Cum.
		// ------------+-----------------------------------
		//           1 |      9,878       89.36       89.36
		//           2 |        516        4.67       94.03
		//           3 |         58        0.52       94.55
		//           4 |        553        5.00       99.56
		//           5 |         49        0.44      100.00
		// ------------+-----------------------------------
		//       Total |     11,054      100.00

	gen H_individual = v1a_tipo_d=="1" | v1a_tipo_d=="2"
	gen H_improvisad = v1a_tipo_d=="3"
	gen H_apartament = v1a_tipo_d=="4"
	gen H_vecindadcu = v1a_tipo_d=="5"
	*-------------------------------------------------
	des v1b_tenenc	//	str2    %9s                   V1B_TENENC
	tab v1b_tenenc, m
	gen H_hipotecada = v1b_tenenc=="02"
	gen H_alquilada  = v1b_tenenc=="01"
	gen H_propia	 = v1b_tenenc=="03"
	gen H_cedida     = v1b_tenenc=="04"
	gen H_vivivotra  = v1b_tenenc=="05"|v1b_tenenc=="06"	
	*-------------------------------------------------
	des v1b_pago_m	//	str5    %9s                   V1B_PAGO_M
	tab v1b_pago_m, m
	destring v1b_pago_m, gen(H_pagoviv)
	replace H_pagoviv = . if v1b_pago_m=="99998"|v1b_pago_m=="99999"
	codebook H_pagoviv
	replace H_pagoviv = 0 if H_pagoviv==.
	*-------------------------------------------------
	des v1d_materi
	tab v1d_materi, m
	gen H_pladrillo = v1d_materi=="1"
	gen H_pmadera   = v1d_materi=="2"
	gen H_pmetal    = v1d_materi=="4"
	gen H_pbambu    = v1d_materi=="5"
	gen H_paredotr  = v1d_materi=="3"|v1d_materi=="6"|v1d_materi=="7"
	*-------------------------------------------------
	des v1e_materi
	tab v1e_materi, m
	gen H_tmetal 	= v1e_materi=="4"
	gen H_tteja 	= v1e_materi=="2"
	gen H_ttejaotr 	= v1e_materi=="3"
	gen H_tconcreto = v1e_materi=="1"
	gen H_tpalma 	= v1e_materi=="6"
	*-------------------------------------------------
	des v1f_materi
	tab v1f_materi, m
	gen H_fmosaico 	= v1f_materi=="1"
	gen H_fpavimen 	= v1f_materi=="2"
	gen H_ftierra 	= v1f_materi=="5"
	gen H_fmadera 	= v1f_materi=="4"
	*-------------------------------------------------
	des v1g_cuarto
	tab v1g_cuarto, m		//	no missing
	destring v1g_cuarto, gen(H_ncuartos)
	*-------------------------------------------------
	des v1h_dormit
	tab v1h_dormit, m		//	no missing
	destring v1h_dormit, gen(H_ndormit)
	*-------------------------------------------------
	des v1i_agua_b			//	str2    %9s                   V1I_AGUA_B
	tab v1i_agua_b, m		//	no missing
	gen H_aacuepub = v1i_agua_b=="01"
	gen H_aacuecom = v1i_agua_b=="02"
	gen H_aacuepar = v1i_agua_b=="03"
	gen H_apozopro = v1i_agua_b=="04"
	gen H_arioqueb = v1i_agua_b=="08"
	gen H_aaguabot = v1i_agua_b=="10"
	gen H_aotro    = v1i_agua_b=="06" | v1i_agua_b=="07" | v1i_agua_b=="09" | v1i_agua_b=="11" 
	gen H_aacueduc = (H_aacuepub==1|H_aacuecom==1|H_aacuepar==1)
	gen H_asegura  = (H_aacueduc==1|H_apozopro==1|H_aaguabot==1)	
	*-------------------------------------------------
	des 		v1i_pago_a	//	 str4    %9s                   V1I_PAGO_A
	codebook 	v1i_pago_a
	tab 		v1i_pago_a, m	//	1169 missing: ""
	destring 	v1i_pago_a, gen(H_apago)
	tab 		H_apago, m
	replace H_apago = 0  if H_apago==9997 | H_apago==9998
	replace H_apago = 0  if H_apago==.
	gen 	H_anopaga =    (v1i_pago_a=="")
	lab var H_apago   "Pago mensual por agua"
	lab var H_anopaga "No paga por agua o no declara"
	*-------------------------------------------------
	des v1j_ubicac		//	str1    %9s                   V1J_UBICAC
	tab v1j_ubicac, m
		//  V1J_UBICAC |      Freq.     Percent        Cum.
		// ------------+-----------------------------------
		//             |        992        8.97        8.97
		//           1 |      8,736       79.03       88.00
		//           2 |      1,269       11.48       99.48
		//           3 |         31        0.28       99.76
		//           4 |         26        0.24      100.00
		// ------------+-----------------------------------
		//       Total |     11,054      100.00
	gen 	H_adentro = v1j_ubicac=="1"
	lab var H_adentro "Agua para beber dentro de la casa"
	*-------------------------------------------------
	des 	 v1j1a_dias 	//	str1    %9s                   V1J1A_DIAS
	tab 	 v1j1a_dias, m	//	993 missing
	destring v1j1a_dias,    gen(H_andiasseca)
	replace H_andiasseca = 0 if H_andiasseca==.
	tab 	H_andiasseca, m
	lab var H_andiasseca "Días a la semana con agua en estación seca"
	*-----------------------
	des 	 v1j1a_hora 	//	%9s                   V1J1A_HORA
	tab 	 v1j1a_hora, m	//	993 missing
		//  V1J1A_HORA |      Freq.     Percent        Cum.
		// ------------+-----------------------------------
		//             |        993        8.98        8.98
		//           0 |      1,505       13.61       22.60
		//           1 |        927        8.39       30.98
		//           2 |      7,629       69.02      100.00
		// ------------+-----------------------------------
		//       Total |     11,054      100.00
	destring v1j1a_hora,    gen(H_anhoraseca)
	replace H_anhoraseca = 0 if H_anhoraseca==.
	tab 	H_anhoraseca, m
	lab var H_anhoraseca "Horas al día con agua en estación seca"	
	*-----------------------
	des 	 v1j1b_dias 	//	str1    %9s                   V1J1B_DIAS
	tab 	 v1j1b_dias, m	//	993 missing
	destring v1j1b_dias,    gen(H_andiaslluv)
	replace H_andiaslluv = 0 if H_andiaslluv==.
	tab 	H_andiaslluv, m
	lab var H_andiaslluv "Días a la semana con agua en estación seca"
	*-----------------------
	des 	 v1j1b_hora		//	str2    %9s                   V1J1B_HORA
	tab 	 v1j1b_hora, m	//	993 missing  llega a 24
	destring v1j1b_hora,    gen(H_anhoralluv)
	replace H_anhoralluv = 0 if H_anhoralluv==.
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
	des v1k_servic		//	%9s                   V1K_SERVIC
	tab v1k_servic, m
		//  V1K_SERVIC |      Freq.     Percent        Cum.
		// ------------+-----------------------------------
		//           1 |      2,160       19.54       19.54
		//           2 |      3,072       27.79       47.33
		//           3 |      5,381       48.68       96.01
		//           4 |        441        3.99      100.00
		// ------------+-----------------------------------
		//       Total |     11,054      100.00
	gen H_salcanta = v1k_servic=="2"
	gen H_stansept = v1k_servic=="3"
	gen H_sletrina = v1k_servic=="1"
	gen H_snotiene = v1k_servic=="4"
	lab var H_salcanta "Vivienda conectada a alcantarillado"
	lab var H_stansept "Vivienda conectada a tanque séptico"
	lab var H_sletrina "Vivienda usa hueco o letrina"
	lab var H_snotiene "Vivienda no tiene servicio sanitario"
	*-------------------------------------------------
	des v1l_uso_sa		//	str1    %9s                   V1L_USO_SA
	tab v1l_uso_sa, m
		//             |        441        3.99        3.99
		//           1 |     10,321       93.37       97.36
		//           2 |        292        2.64      100.00
		// ------------+-----------------------------------
		//       Total |     11,054      100.00

	gen H_sexclusivo = v1l_uso_sa=="1"
	gen H_scompartid = v1l_uso_sa=="2"
	lab var H_sexclusivo "Vivienda con servicio sanitario exclusivo"
	lab var H_scompartid "Vivienda con servicio sanitario compartido"
	*-------------------------------------------------
	des v1k1_excre		//	byte    %1.0f                 V1K1_EXCRE
	tab v1k1_excre
		//  V1K1_EXCRE |      Freq.     Percent        Cum.
		// ------------+-----------------------------------
		//           1 |         69       15.65       15.65
		//           2 |         85       19.27       34.92
		//           3 |        216       48.98       83.90
		//           4 |         65       14.74       98.64
		//           5 |          6        1.36      100.00
		// ------------+-----------------------------------
		//       Total |        441      100.00
	gen H_sdepmonte 	= v1k1_excre==1
	gen H_sdeprio 		= v1k1_excre==2
	gen H_sdepmar 		= v1k1_excre==3
	gen H_sdepvecino 	= v1k1_excre==4
	gen H_sdepotro	 	= v1k1_excre==5
	lab var H_sdepmonte 	"Vivienda deposita excretas en el monte"
	lab var H_sdeprio 		"Vivienda deposita excretas en el río"
	lab var H_sdepmar 		"Vivienda deposita excretas en el mar"
	lab var H_sdepvecino 	"Vivienda deposita excretas en donde el vecino"
	lab var H_sdepotro 		"Vivienda deposita excretas en otro lugar"
	*-------------------------------------------------
	des v1o_luz			//	LUZ        14. TIPO DE ALUMBRADO
	tab v1o_luz, m
		//     V1O_LUZ |      Freq.     Percent        Cum.
		// ------------+-----------------------------------
		//          01 |      9,697       87.72       87.72
		//          02 |         55        0.50       88.22
		//          03 |         45        0.41       88.63
		//          04 |         94        0.85       89.48
		//          05 |          3        0.03       89.51
		//          06 |         91        0.82       90.33
		//          07 |        649        5.87       96.20
		//          08 |        420        3.80      100.00
		// ------------+-----------------------------------
		//       Total |     11,054      100.00
	gen H_lcompania = v1o_luz=="01"
	gen H_lpanelsol = v1o_luz=="07"
	gen H_llamparap = v1o_luz=="04"
	gen H_lelectric = v1o_luz=="01"| v1o_luz=="02" | v1o_luz=="03" 
	gen H_lotro     = v1o_luz=="05"| v1o_luz== "06"| v1o_luz== "08"
	lab var H_lcompania "Alumbrado compañía eléctrica"
	lab var H_lpanelsol "Alumbrado por panel solar"
	lab var H_llamparap "Alumbrado por linterna o lámpara portatil"
	lab var H_lelectric "Alumbrado eléctrico"
	lab var H_lotro 	"Alumbrado por otro medio"
	*-------------------------------------------------
	des v1m_basura		//	str2    %9s                   V1M_BASURA
	tab v1m_basura, m
		//  V1M_BASURA |      Freq.     Percent        Cum.
		// ------------+-----------------------------------
		//          01 |      6,470       58.53       58.53
		//          02 |      1,456       13.17       71.70
		//          03 |      2,424       21.93       93.63
		//          04 |        214        1.94       95.57
		//          05 |        273        2.47       98.04
		//          06 |        162        1.47       99.50
		//          07 |         55        0.50      100.00
		// ------------+-----------------------------------
		//       Total |     11,054      100.00

	gen H_bpublico = v1m_basura=="01"
	gen H_bprivado = v1m_basura=="02"
	gen H_bquema   = v1m_basura=="03"
	gen H_btbaldio = v1m_basura=="04"
	gen H_bentierr = v1m_basura=="05"
	gen H_botro    = v1m_basura=="06" | v1m_basura=="07"
	lab var H_bpublico "Basura: servicio público"
	lab var H_bprivado "Basura: servicio privado"
	lab var H_bquema   "Basura: quema"
	lab var H_btbaldio "Basura: terreno baldío"
	lab var H_bentierr "Basura: entierro"
	lab var H_botro    "Basura: otro método de eliminación de basura"
	*-------------------------------------------------
	des v1n_cocina		//	byte    %1.0f                 V1N_COCINA
	tab v1n_cocina, m
		//  V1N_COCINA |      Freq.     Percent        Cum.
		// ------------+-----------------------------------
		//           1 |     10,076       91.15       91.15
		//           2 |        890        8.05       99.20
		//           3 |         37        0.33       99.54
		//           4 |          2        0.02       99.56
		//           6 |         49        0.44      100.00
		// ------------+-----------------------------------
		//       Total |     11,054      100.00
	gen H_cgas      = v1n_cocina==1
	gen H_clena     = v1n_cocina==2
	gen H_celectri  = v1n_cocina==3
	gen H_cnococina = v1n_cocina==6
	gen H_cmoderna  = v1n_cocina==1 | v1n_cocina==3
	lab var H_cgas      "Cocina: gas"
	lab var H_clena     "Cocina: leña"
	lab var H_celectri  "Cocina: eléctrica"
	lab var H_cnococina "Cocina: No cocina"
	lab var H_cmoderna  "Cocina: moderna: gas o eléctrica"
	*-------------------------------------------------
	des cuantos_ho		//	str1    %9s                   CUANTOS_HO
	tab cuantos_ho, m
	destring cuantos_ho, gen(H_numhogares)
	lab var H_numhogares "Número de hogares en la vivienda"
	*-------------------------------------------------
	lab var H_individual 	"Vivienda individual"
	lab var H_improvisad 	"Vivienda improvisada"
	lab var H_apartament 	"Vivienda es apartamento"
	lab var H_vecindadcu 	"Vivienda es cuarto en vecindad"
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
	keep llave_sec H_*
	compress
	order llave_sec H_individual H_improvisad H_apartament H_vecindadcu H_hipotecada H_alquilada H_propia H_cedida H_vivivotra H_pagoviv H_pladrillo H_pmadera H_pmetal H_pbambu H_paredotr H_tmetal H_tteja H_ttejaotr H_tconcreto H_tpalma H_fmosaico H_fpavimen H_ftierra H_fmadera H_ncuartos H_ndormit H_aacuepub H_aacuecom H_aacuepar H_apozopro H_arioqueb H_aaguabot H_aotro H_aacueduc H_asegura H_apago H_anopaga H_adentro H_andiasseca H_anhoraseca H_andiaslluv H_anhoralluv H_aalldia H_aallhora H_asiempre H_amindias H_aminhora H_salcanta H_stansept H_sletrina H_snotiene H_sexclusivo H_scompartid H_sdepmonte H_sdeprio H_sdepmar H_sdepvecino H_sdepotro H_lcompania H_lpanelsol H_llamparap H_lelectric H_lotro H_bpublico H_bprivado H_bquema H_btbaldio H_bentierr H_botro H_cgas H_clena H_celectri H_cnococina H_cmoderna H_numhogares
	sum
	drop H_anhoraseca H_aallhora H_asiempre H_aminhora
	sum
save "${dta}2100_EML2021_Vivienda.dta", replace
****************************************************************************************************	  
	  
	  