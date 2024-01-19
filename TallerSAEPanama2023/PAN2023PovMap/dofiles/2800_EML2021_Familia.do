* 2800_EML2021_Familia.do


****************************************************************************************************
use "${dta}2400_EML2021_Persona.dta", clear
*---------------------------------------------------------------------------------------------------
	gen F_nmiembros		= 1
	gen F_nnoparien		= noparie
	gen F_nservdom		= servdom
	gen F_nmujer 		= mujer			==1
	
	gen F_ncasado 		= casado		==1
	gen F_nunido 		= unido			==1
	gen F_nsoltero 		= soltero		==1
	gen F_nsepdiv 		= sepdiv		==1
	gen F_nviudo 		= viudo			==1
	gen F_ncasunido 	= casunido		==1
	
	gen F_mayor			= mayor			==1
	gen F_adulto		= adulto		==1	
	gen F_joven			= joven			==1
	gen F_menor			= menor			==1
	
	gen F_asegurado		= asegurado		==1
	gen F_beneficia		= beneficia		==1
	gen F_jubilado		= jubilado		==1
	gen F_noseguro		= noseguro		==1
	
	gen F_leeescribe	= leeescribe	==1
	gen F_estudia		= estudia		==1
	gen F_asistepubl	= asistepubl	==1
	gen F_asistepriv	= asistepriv	==1
	gen F_asistio		= asistio		==1
	gen F_nuncasist		= nuncasist		==1
	gen F_eningun		= eningun		==1
	gen F_eprimplus		= eprimplus		==1
	gen F_esecplus		= esecplus		==1
	gen F_esupplus		= esupplus		==1
	
	gen F_ocupado		= ocupado		==1
	gen F_desocupado	= desocupado	==1
	gen F_inactivo		= inactivo		==1
	
	gen F_redoportu		= redoportu		==1
	gen F_angelguard	= angelguard	==1
	gen F_programa		= (F_redoportu==1 | F_angelguard==1)
	*-------------------------------------------------
	collapse (sum) F_*, by(llave_sec hogar)
	gen F_hnoparien 	= F_nnoparien	>=1
	gen F_hservdom 		= F_nservdom	>=1
	gen F_solomujer 	= F_nmujer		==F_nmiembros
	
	gen F_hmayor		= F_mayor		>=1
	gen F_hjoven		= F_joven		>=1
	gen F_hmenor		= F_menor		>=1	
   egen F_dependent		= rowtotal(F_mayor F_menor)
	
	gen F_hcasado		= F_ncasado		>=1
	gen F_hunido		= F_nunido		>=1
	gen F_hsoltero		= F_nsoltero	>=1
	gen F_hsepdiv		= F_nsepdiv		>=1
	gen F_hviudo		= F_nviudo		>=1
	gen F_hcasunido		= F_ncasunido	>=1
	drop  F_ncasado F_nunido F_nsoltero F_nsepdiv F_nviudo F_ncasunido
	
	gen F_hasegurado	= F_asegurado	>=1
	gen F_hbeneficia	= F_beneficia	>=1
	gen F_hjubilado		= F_jubilado	>=1
	gen F_hnoseguro		= F_noseguro	>=1
	
	gen F_hleeescribe	= F_leeescribe	>=1
	gen F_hestudia		= F_estudia		>=1
	gen F_hasistepubl	= F_asistepubl	>=1
	gen F_hasistepriv	= F_asistepriv	>=1
	gen F_hasistio		= F_asistio		>=1
	gen F_hnuncasist	= F_nuncasist	>=1
	gen F_heningun		= F_eningun		>=1
	gen F_heprimplus	= F_eprimplus	>=1
	gen F_hesecplus		= F_esecplus	>=1
	gen F_hesupplus		= F_esupplus	>=1
	
	gen F_hocupado		= F_ocupado		>=1
	gen F_hdesocupado	= F_desocupado	>=1
	gen F_hinactivo		= F_inactivo	>=1
	
	gen F_hredoportu	= F_redoportu	>=1
	gen F_hangelguard	= F_angelguard	>=1
	gen F_hprograma		= F_programa	>=1
	*-------------------------------------------------
	gen F_lnmiemb   	= ln(F_nmiembros)
	gen F_rmujtot 		= F_nmujer/F_nmiembros
	gen F_rdepende  	= F_dependent/F_nmiembros
	gen F_rleeescri 	= F_leeescribe/F_nmiembros
	gen F_rocupado  	= F_ocupado/F_nmiembros
	gen F_rprograma 	= F_programa/F_nmiembros
*---------------------------------------------------------------------------------------------------
	keep llave_sec hogar F_*
	compress
	sum
save "${dta}2800_EML2021_Familia.dta", replace
****************************************************************************************************