* 1700_Censo2023_Jefe.do





****************************************************************************************************
use "${dta}1400_Censo2023_Persona.dta", clear
*---------------------------------------------------------------------------------------------------

	unique LLAVEVIV
	keep if jefe==1
	unique LLAVEVIV
	
	gen C_jefemujer 	= jefe==1 & mujer		==1
	gen C_jefejoven 	= jefe==1 & edad>=15 & edad<=29
	gen C_jefemedia 	= jefe==1 & edad>=30 & edad<=64
	gen C_jefemayor 	= jefe==1 & edad>=65 & edad<=125
	gen C_indigena  	= jefe==1 & indigena	==1
	gen C_kuna  		= jefe==1 & kuna		==1
	gen C_ngabe  		= jefe==1 & ngabe		==1
	gen C_embera  		= jefe==1 & embera		==1
	gen C_afro  		= jefe==1 & afro		==1
	gen C_afropan  		= jefe==1 & afropan		==1
	gen C_moreno  		= jefe==1 & moreno		==1
	gen C_otroafro 	 	= jefe==1 & otroafro	==1

	gen C_casado  		= jefe==1 & casado		==1
	gen C_unido  		= jefe==1 & unido		==1
	gen C_soltero  		= jefe==1 & soltero		==1
	gen C_sepdiv  		= jefe==1 & sepdiv		==1
	gen C_viudo  		= jefe==1 & viudo		==1
	gen C_casunido  	= jefe==1 & casunido	==1
	
	gen C_asegurado		= jefe==1 & asegurado	==1
	gen C_beneficia		= jefe==1 & beneficia	==1
	gen C_jubilado		= jefe==1 & jubilado	==1
	gen C_noseguro		= jefe==1 & noseguro	==1
	
	gen C_leeescribe	= jefe==1 & leeescribe	==1
	gen C_estudia		= jefe==1 & estudia		==1
	gen C_asistepubl	= jefe==1 & asistepubl	==1
	gen C_asistepriv	= jefe==1 & asistepriv	==1
	gen C_asistio		= jefe==1 & asistio		==1
	gen C_nuncasist		= jefe==1 & nuncasist	==1
	gen C_eningun		= jefe==1 & eningun		==1
	gen C_eprimplus		= jefe==1 & eprimplus	==1
	gen C_esecplus		= jefe==1 & esecplus	==1
	gen C_esupplus		= jefe==1 & esupplus	==1
	
	gen C_ocupado		= jefe==1 & ocupado		==1
	gen C_desocupado	= jefe==1 & desocupado	==1
	gen C_inactivo		= jefe==1 & inactivo	==1
	gen C_redoportu		= jefe==1 & redoportu	==1
	gen C_angelguard	= jefe==1 & angelguard	==1
*---------------------------------------------------------------------------------------------------
	keep LLAVEVIV HOGAR C_*
	compress
	sum
save "${dta}1700_Censo2023_Jefe.dta", replace
****************************************************************************************************