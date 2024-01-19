* 2400_EML2021_Persona.do


****************************************************************************************************
use "${EML2021}Persona.dta", clear
*---------------------------------------------------------------------------------------------------
	des p1 p1a		
		// p1              byte    %1.0f                 P1
		// p1a             str2    %9s                   P1A
	tab p1, m		//	no missing
		//   1 |     11,148       28.85       28.85
		//   2 |      6,150       15.91       44.76
		//   3 |     14,047       36.35       81.11
		//   4 |      6,967       18.03       99.14
		//   5 |         74        0.19       99.33
		//   6 |        258        0.67      100.00
	tab p1a p1, m	//	6,967 of p1==4
		
		
	gen jefe 	= p1==1
	gen conyuge	= p1==2
	gen hij		= p1==3
// 	gen hijastr	= p3==4
// 	gen nietbis	= p3==4
// 	gen padrmad	= p3==4
// 	gen herman	= p3==4
// 	gen sobrin	= p3==4
// 	gen suegr	= p3==4
// 	gen yernuer	= p3==4
// 	gen cunad	= p3==4
// 	gen otropar	= p3==4
	gen noparie	= p1==6
	gen servdom	= p1==5
	
// 	gen nuclear = jefe==1 | conyuge==1 | hij==1 
// 	gen collate = herman==1 | sobrin==1 | hijastr==1 | cunad==1
// 	gen multgen = nietbis==1 | (padrmad==1 & (hij==1|sobrin==1)) | (suegr==1 & (hij==1|hijastr==1))
	*-------------------------------------------------
	des p2			//	str1    %9s                   P2
	tab p2, m		//	no missing
	gen mujer =  p2 == "2"
	tab mujer, m
	*-------------------------------------------------
	des p3		//	int     %3.0f                 P3
	tab p3, m	//	no missing
	gen edad =  p3 
	tab edad, m	
	gen mayor	= edad>=65 & edad<=125
	gen adulto	= edad>=30 & edad<= 64
	gen joven	= edad>=15 & edad<= 29
	gen menor	= edad>= 0 & edad<= 14
	*-------------------------------------------------
	des p4d_indige 
	tab p4d_indige, m
	gen indigena = p4d_indige!="11"
	gen kuna 	 = p4d_indige=="01"
	gen ngabe 	 = p4d_indige=="02"
	gen embera 	 = p4d_indige=="07"
	*-------------------------------------------------
	des p4f_afrod
	tab p4f_afrod, m
	gen afro	 = p4f_afrod!="8"
	gen afropan	 = p4f_afrod=="2"
	gen moreno 	 = p4f_afrod=="3"
	gen otroafro = p4f_afrod=="7"
	*-------------------------------------------------
	des p5_conyuga
	tab p5_conyuga, m
	gen casado	= p5_conyuga=="4"
	gen unido	= p5_conyuga=="1"
	gen soltero	= p5_conyuga=="7"
	gen sepdiv  = p5_conyuga=="2"|p5_conyuga=="3"|p5_conyuga=="5"
	gen viudo	= p5_conyuga=="6"	
	gen casunido= casado==1|unido==1
	*-------------------------------------------------
	des p4	//	byte    %39.0f     SEGSOCIA   10. SEGURO SOCIAL
	tab p4, m
		//          P4 |      Freq.     Percent        Cum.
		// ------------+-----------------------------------
		//           1 |      6,174       15.98       15.98
		//           2 |         91        0.24       16.21
		//           3 |      7,691       19.90       36.11
		//           4 |      2,094        5.42       41.53
		//           5 |        483        1.25       42.78
		//           6 |         87        0.23       43.01
		//           7 |     22,024       56.99      100.00
		// ------------+-----------------------------------
		//       Total |     38,644      100.00
	gen asegurado = p4==1 | p4==2
	gen beneficia = p4==3
	gen jubilado  = p4==4
	gen noseguro  = p4==7	
	*-------------------------------------------------
	* Sabe leer y escribir (Para personas 10 o mas):
	des p8a	//	byte    %2.0f                 P8
	tab p8a, m
	tab p8a if edad>=10, m	
	gen leeescribe=p8a==1 & edad>=10
	*-------------------------------------------------
	* (Para personas 4 o mas):
	des  p7 	//	byte    %1.0f                 P7
	tab  p7 if edad <4, 	//	 no observations
	tab  p7 if edad>=4, m
		//          P7 |      Freq.     Percent        Cum.
		// ------------+-----------------------------------
		//           1 |     10,841       29.72       29.72
		//           2 |     25,639       70.28      100.00
		// ------------+-----------------------------------
		//       Total |     36,480      100.00
	gen estudia = p7==1
	*-------------------------------------------------
	des p7_tipo 	//	str1    %9s                   P7_TIPO
	tab p7_tipo if edad>=4, m
		//     P7_TIPO |      Freq.     Percent        Cum.
		// ------------+-----------------------------------
		//             |     25,639       70.28       70.28
		//           3 |      9,342       25.61       95.89
		//           4 |      1,499        4.11      100.00
		// ------------+-----------------------------------
		//       Total |     36,480      100.00
	gen asistepubl = p7_tipo=="3" & edad>=4
	gen asistepriv = p7_tipo=="4" & edad>=4
	*-------------------------------------------------
	des p7_asistio	//	str1    %9s                   P7_ASISTIO
	tab p7_asistio if edad>=4, m
		//  P7_ASISTIO |      Freq.     Percent        Cum.
		// ------------+-----------------------------------
		//             |     10,840       29.71       29.71
		//           5 |     23,654       64.84       94.56
		//           6 |      1,986        5.44      100.00
		// ------------+-----------------------------------
		//       Total |     36,480      100.00
	gen asistio   = p7_asistio=="5" & edad>=4
	gen nuncasist = p7_asistio=="6" & edad>=4
	*-------------------------------------------------
	des p8	//	byte    %2.0f                 P8
	tab p8 if edad< 4, m 	// no obs
	tab p8 if edad>=4, m 
	gen eningun   = p8==1
	gen eprimplus = p8==16 | p8>=31
	gen esecplus  = p8>=36
	gen esupplus  = p8>=56
	*-------------------------------------------------
	des p33		//	byte    %2.0f                 P33
	tab p33, m
		//         P33 |      Freq.     Percent        Cum.
		// ------------+-----------------------------------
		//           1 |      2,861        7.40        7.40
		//           2 |         86        0.22        7.63
		//           3 |         31        0.08        7.71
		//           4 |      6,611       17.11       24.81
		//           5 |        740        1.91       26.73
		//           7 |      6,472       16.75       43.48
		//           8 |        432        1.12       44.59
		//           9 |          1        0.00       44.60
		//          10 |      1,381        3.57       48.17
		//           . |     20,029       51.83      100.00
		// ------------+-----------------------------------
		//       Total |     38,644      100.00
	gen empgobier = p33==1
	gen empprivad = p33==4
	gen empdomest = p33==5
	gen empindepe = p33==7
	gen emppatron = p33==8
	gen empfamili = p33==10
	*-------------------------------------------------
	des p27a_cond		//	str1    %9s                   P27A_COND
	tab p27a_cond, m
	tab edad p27a_cond, m	// debe ser solo para mayores de 10
	tab p27a_cond if edad>=10, m
		//   P27A_COND |      Freq.     Percent        Cum.
		// ------------+-----------------------------------
		//             |     14,041       42.99       42.99
		//           1 |     16,718       51.19       94.18
		//           2 |      1,257        3.85       98.03
		//           3 |        643        1.97      100.00
		// ------------+-----------------------------------
		//       Total |     32,659      100.00
	gen ocupado    = p27a_cond=="1" & edad>=10
	gen desocupado = p27a_cond=="2" & edad>=10
	gen inactivo   = p27a_cond=="3" & edad>=10
	*-------------------------------------------------
	des p56_g1	 	//	byte    %5.0f                 P56_G1
	tab p56_g1, m	//	50
	gen redoportu = p56_g1==50
	*-------------------------------------------------
	des p56_g5 	 	//	int     %5.0f                 P56_G5
	tab p56_g5, m	//	120
	gen ciento20a65 = p56_g5==120
	*-------------------------------------------------
	des p56_g6	 	//	byte    %5.0f                 P56_G6
	tab p56_g6, m	//	80
	gen angelguard = p56_g6==80
	*-------------------------------------------------
	*-------------------------------------------------
	*-------------------------------------------------
	*-------------------------------------------------
	*-------------------------------------------------
	*-------------------------------------------------	
	
	
	*-----------------------------------------------------------------------------------------------
	keep  llave_sec hogar nper jefe conyuge hij noparie servdom mujer edad mayor adulto joven menor indigena kuna ngabe embera afro afropan moreno otroafro casado unido soltero sepdiv viudo casunido asegurado beneficia jubilado noseguro leeescribe estudia asistepubl asistepriv asistio nuncasist eningun eprimplus esecplus esupplus ocupado desocupado inactivo redoportu ciento20a65 angelguard
	compress
save "${dta}2400_EML2021_Persona.dta", replace
****************************************************************************************************	