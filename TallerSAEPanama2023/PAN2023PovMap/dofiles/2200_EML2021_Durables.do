* 2200_EML2021_Durables.do


****************************************************************************************************
use "${EML2021}hogar.dta", clear
*---------------------------------------------------------------------------------------------------
	des h2a1_nu_tv h2a2_cable h2b_celula h2b1_num h2c_resi h2d_pub h2e_radio h2f_refr h4_compu h4a_pc h4b_port h4c_tablet
	*-------------------------------------------------
	tab 	 h2a1_nu_tv, m
	destring h2a1_nu_tv, gen(numerotv)
	tab numerotv, m
	replace numerotv = 0 if numerotv==.
	tab numerotv, m
	gen D_itv	=	numerotv>=1
	tab D_itv, m
	*-------------------------------------------------
	tab 	 h2a2_cable, m
	destring h2a2_cable, gen(tienecable)
	tab tienecable, m
	gen D_icable	=	tienecable==1
	tab D_icable, m
	*-------------------------------------------------
	tab 	 h2b_celula, m
	destring h2b_celula, gen(tienecel)
	tab tienecel, m
	tab 	 h2c_resi, m
	destring h2c_resi, gen(tienefijo)
	tab tienefijo, m	
	gen D_icelfijo	=	tienecel==1 | tienefijo==1
	tab D_icelfijo, m
	*-------------------------------------------------
	tab 	 h2e_radio, m
	destring h2e_radio, gen(tieneradio)
	tab tieneradio, m
	gen D_iradio	=	tieneradio==1
	tab D_iradio, m
	*-------------------------------------------------
	tab 	 h2f_refr, m
	destring h2f_refr, gen(tienerefri)
	tab tienerefri, m
	gen D_irefri	=	tieneradio==1
	tab D_irefri, m
	*-------------------------------------------------
	tab 	 h4_compu, m
	destring h4_compu, gen(tienecompu)
	tab tienecompu, m	
	gen D_icompu	=	tienecompu==1
	tab D_icompu, m
	*-------------------------------------------------
	tab 	 h5_int_mov, m
	destring h5_int_mov, gen(tieneintmov)
	tab 	 h5_serv_in, m
	destring h5_serv_in, gen(tieneintin)
	gen D_iinter	=	tieneintmov==1 | tieneintin==1
	tab D_iinter, m	
*-----------------------------------------------------------------------------------------------
	keep llave_sec hogar D_*
	compress
	misstable sum 	D_* 
save "${dta}2200_EML2021_Durables.dta", replace
****************************************************************************************************