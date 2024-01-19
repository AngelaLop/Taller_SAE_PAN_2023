* 1200_Censo2023_Durables.do


****************************************************************************************************
use "${censo2023}stata/CEN2023_HOGAR.dta", clear
*---------------------------------------------------------------------------------------------------
	des H18A_ESTU H18B_REFR H18C_LAVA H18D_MCOS H18E_ABAN H18F_AIRE H18G_RADI H18H_TRES H18I_TCEL H18J_TV H18J_CABLE H18K_COMP H18L_INTER H18M_AUTO
	lab lis SINO
		// 1 Sí
		// 2 No
	*-------------------------------------------------	
	tab H18J_TV, m	//	3,081 missings
	gen D_itv = H18J_TV==1
	tab D_itv, m
	*-------------------------------------------------
	tab H18J_CABLE, m	//	213,134 missings
	tab H18J_CABLE H18J_TV, m	//	3,081 missings
	gen D_icable = H18J_CABLE==1
	tab D_icable, m
	*-------------------------------------------------
	tab H18I_TCEL, m	//	3,081 missings
	gen D_icelfijo = H18I_TCEL==1
	tab D_icelfijo, m
	*-------------------------------------------------
	tab H18G_RADI, m	//	3,081 missings
	gen D_iradio  =  H18G_RADI==1
	tab D_iradio, m
	*-------------------------------------------------
	tab H18B_REFR, m	//	3,081 missings
	gen D_irefri  =  H18B_REFR==1
	tab D_irefri, m
	*-------------------------------------------------	
	tab H18K_COMP, m	//	3,081 missings
	gen D_icompu  =  H18K_COMP==1
	tab D_icompu, m
	*-------------------------------------------------	
	tab H18L_INTER, m	//	3,081 missings
	gen D_iinter  =  H18L_INTER==1
	tab D_iinter, m
	*-------------------------------------------------	
*-----------------------------------------------------------------------------------------------
	keep LLAVEVIV HOGAR D_*
	compress
	misstable sum 	D_* 
save "${dta}1200_Censo2023_Durables.dta", replace
****************************************************************************************************