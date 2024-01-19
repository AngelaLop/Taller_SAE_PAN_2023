* 1400_Censo2023_Persona.do


****************************************************************************************************
use "${censo2023}stata/CEN2023_PERSONA.dta", clear
*---------------------------------------------------------------------------------------------------
	des P01_RELA		//	byte    %27.0f     RELACION   1. RELACION DE PARENTESCO
	lab lis RELACION
		//    1 1 Jefe(a)
		//    2 2 Cónyuge del jefe o jefa
		//    3 3 Hijo(a)
		//    4 4 Hijastro(a)
		//    5 5 Nieto(a) o bisnieto(a)
		//    6 6 Padre o madre del jefe(a)
		//    7 7 Hermano(a)
		//    8 8 Sobrino(a)
		//    9 9 Suegro(a)
		//   10 10 Yerno o nuera
		//   11 11 Cuñado(a)
		//   12 12 Otro pariente
		//   13 13 No pariente
		//   14 14 Servicio doméstico
	tab P01_RELA, m		//	no missing
	gen jefe 	= P01_RELA==1
	gen conyuge	= P01_RELA==2
	gen hij		= P01_RELA==3
// 	gen hijastr	= P01_RELA==4
// 	gen nietbis	= P01_RELA==5
// 	gen padrmad	= P01_RELA==6
// 	gen herman	= P01_RELA==7
// 	gen sobrin	= P01_RELA==8
// 	gen suegr	= P01_RELA==9
// 	gen yernuer	= P01_RELA==10
// 	gen cunad	= P01_RELA==11
// 	gen otropar	= P01_RELA==12
	gen noparie	= P01_RELA==13
	gen servdom	= P01_RELA==14
	
// 	gen nuclear = jefe==1 | conyuge==1 | hij==1 
// 	gen collate = herman==1 | sobrin==1 | hijastr==1 | cunad==1
// 	gen multgen = nietbis==1 | (padrmad==1 & (hij==1|sobrin==1)) | (suegr==1 & (hij==1|hijastr==1))
	*-------------------------------------------------
	des P02_SEXO		//	byte    %8.0f      SEXO       2. SEXO
	lab list SEXO
	tab P02_SEXO, m		//	no missing
	gen mujer =  P02_SEXO == 2
	tab mujer, m
	*-------------------------------------------------
	des P03_EDAD	//	NODEC999   3. EDAD
	tab P03_EDAD, m
	gen edad =  P03_EDAD if P03_EDAD!=999
	tab edad, m	
	gen mayor	= edad>=65 & edad<=125
	gen adulto	= edad>=30 & edad<= 64
	gen joven	= edad>=15 & edad<= 29
	gen menor	= edad>= 0 & edad<= 14
	*-------------------------------------------------
	des P08_INDIG 	//	byte    %23.0f     INDIG      8. GRUPO INDÍGENA
	lab lis INDIG
	tab P08_INDIG, m
	gen indigena = P08_INDIG!=11
	gen kuna 	 = P08_INDIG== 1
	gen ngabe 	 = P08_INDIG== 2
	gen embera 	 = P08_INDIG== 7
	*-------------------------------------------------
	des P09_AFROD	//	byte    %86.0f     AFROD      9. GRUPO AFRODESCENDIENTE
	lab lis AFROD
	tab P09_AFROD, m
	gen afro     = P09_AFROD!=8
	gen afropan	 = P09_AFROD==2
	gen moreno 	 = P09_AFROD==3
	gen otroafro = P09_AFROD==7
	*-------------------------------------------------
	des P04_ESTC	//	byte    %27.0f     ESTCONYU   4. ESTADO CONYUGAL
	lab lis ESTCONYU
	tab P04_ESTC, m
	gen casado	= P04_ESTC==4
	gen unido	= P04_ESTC==1
	gen soltero	= P04_ESTC==7
	gen sepdiv  = P04_ESTC==2|P04_ESTC==3|P04_ESTC==6
	gen viudo	= P04_ESTC==5
	gen casunido= casado==1|unido==1
	*-------------------------------------------------
	des P10_SEGSOC	//	byte    %39.0f     SEGSOCIA   10. SEGURO SOCIAL
	tab P10_SEGSOC, m
		//                       10. SEGURO SOCIAL |      Freq.     Percent        Cum.
		// ----------------------------------------+-----------------------------------
		//                     1 Asegurado directo |    827,820       20.37       20.37
		//                          2 Beneficiario |    837,125       20.59       40.96
		//       3 Jubilado o pensionado por vejez |    230,558        5.67       46.63
		// 4 Pensionado por enfermedad o accidente |     16,451        0.40       47.04
		//    5 Jubilado o pensionado de otro país |      9,799        0.24       47.28
		//                              6 No tiene |  2,142,321       52.70       99.98
		//                          9 No declarado |        706        0.02      100.00
		// ----------------------------------------+-----------------------------------
		//                                   Total |  4,064,780      100.00
	gen asegurado = P10_SEGSOC==1
	gen beneficia = P10_SEGSOC==2
	gen jubilado  = P10_SEGSOC==3
	gen noseguro  = P10_SEGSOC==6	
	*-------------------------------------------------
	* Sabe leer y escribir (Para personas 10 o mas):
	des P13_SLYE	//	byte    %12.0f     SINOND9    13. SABE LEER Y ESCRIBIR
	tab P13_SLYE, m
	tab P13_SLYE if edad>=10, m
		//     13. SABE |
		//       LEER Y |
		//     ESCRIBIR |      Freq.     Percent        Cum.
		// -------------+-----------------------------------
		//           Sí |  3,259,835       96.32       96.32
		//           No |    123,674        3.65       99.97
		// No declarado |        942        0.03      100.00
		// -------------+-----------------------------------
		//        Total |  3,384,451      100.00
	gen leeescribe=P13_SLYE==1 & edad>=10
	*-------------------------------------------------
	* (Para personas 4 o mas):
	des P14_ESCU 	//	byte    %12.0f     SINOND9    14. ACTUALMENTE ESTUDIA EN UN CENTRO EDUCATIVO, COLEGIO O UNIVERSIDAD
	tab P14_ESCU if edad>=4, m
		//          14. |
		//  ACTUALMENTE |
		//   ESTUDIA EN |
		//    UN CENTRO |
		//   EDUCATIVO, |
		//    COLEGIO O |
		//  UNIVERSIDAD |      Freq.     Percent        Cum.
		// -------------+-----------------------------------
		//           Sí |  1,173,783       30.79       30.79
		//           No |  2,638,467       69.21      100.00
		// No declarado |        117        0.00      100.00
		// -------------+-----------------------------------
		//        Total |  3,812,367      100.00
	gen estudia = P14_ESCU==1
	*-------------------------------------------------
	des P14_TIPO 	//	byte    %22.0f     TIPOEDUC   14. ¿PÚBLICA (OFICIAL) O PRIVADA (PARTICULAR)?
	tab P14_TIPO if edad>=4, m
		//           14. ¿PÚBLICA |
		//    (OFICIAL) O PRIVADA |
		//          (PARTICULAR)? |      Freq.     Percent        Cum.
		// -----------------------+-----------------------------------
		//    3 Pública (Oficial) |    924,441       24.25       24.25
		// 4 Privada (Particular) |    249,342        6.54       30.79
		//                      . |  2,638,584       69.21      100.00
		// -----------------------+-----------------------------------
		//                  Total |  3,812,367      100.00
	gen asistepubl = P14_TIPO==3 & edad>=4
	gen asistepriv = P14_TIPO==4 & edad>=4
	*-------------------------------------------------
	des P14_ASISTIO	//	byte    %19.0f     ASISTIO    14. ¿ALGUNA VEZ ASISTIÓ A UN CENTRO EDUCATIVO?	
	tab P14_ASISTIO if edad>=4, m
		//     14. ¿ALGUNA VEZ |
		//        ASISTIÓ A UN |
		//   CENTRO EDUCATIVO? |      Freq.     Percent        Cum.
		// --------------------+-----------------------------------
		//    5 Sí, alguna vez |  2,436,124       63.90       63.90
		// 6 Nunca ha asistido |    201,491        5.29       69.19
		//      9 No declarado |        852        0.02       69.21
		//                   . |  1,173,900       30.79      100.00
		// --------------------+-----------------------------------
		//               Total |  3,812,367      100.00
	gen asistio   = P14_ASISTIO==5 & edad>=4
	gen nuncasist = P14_ASISTIO==6 & edad>=4
	*-------------------------------------------------
	des P15_GRADO	//	byte    %27.0f     GRADO      15. GRADO O AÑO MAS ALTO
	tab P15_GRADO if edad<4, m 	// ok
	tab P15_GRADO if edad>=4, m 
	gen eningun   = P15_GRADO==1
	gen eprimplus = P15_GRADO==16 | P15_GRADO>=31
	gen esecplus  = P15_GRADO>=36
	gen esupplus  = P15_GRADO>=56
	*-------------------------------------------------
	des P21_CATEG		//	
	tab P21_CATEG, m	//
		//             21. CATEGORIA DE OCUPACIÓN |      Freq.     Percent        Cum.
		// ---------------------------------------+-----------------------------------
		//                1 Empleado del gobierno |    291,121        7.16        7.16
		//      2 Empleado de una empresa privada |    790,650       19.45       26.61
		//      3 Empleado del servicio doméstico |     60,149        1.48       28.09
		//    4 Por cuenta propia o independiente |    467,522       11.50       39.59
		//                      5 Patrono o dueño |     29,258        0.72       40.31
		// 6 Miembro de cooperativa de producción |        760        0.02       40.33
		//                  7 Trabajador familiar |     47,502        1.17       41.50
		//                         9 No declarado |      7,477        0.18       41.69
		//                                      . |  2,370,341       58.31      100.00
		// ---------------------------------------+-----------------------------------
		//                                  Total |  4,064,780      100.00
	gen empgobier = P21_CATEG==1
	gen empprivad = P21_CATEG==2
	gen empdomest = P21_CATEG==3
	gen empindepe = P21_CATEG==4
	gen emppatron = P21_CATEG==5
	gen empfamili = P21_CATEG==7
	*-------------------------------------------------
	des PEA_NEA		//	byte    %27.0f     CONDACTI   CONDICIÓN DE ACTIVIDAD
	tab PEA_NEA, m
	tab edad PEA_NEA, m	// debe ser solo para mayores de 10
	tab PEA_NEA if edad>=10, m
		//     CONDICIÓN DE ACTIVIDAD |      Freq.     Percent        Cum.
		// ---------------------------+-----------------------------------
		//                  1 Ocupada |  1,571,105       46.42       46.42
		//               2 Desocupada |    153,535        4.54       50.96
		// 3 No económicamente activa |  1,659,416       49.03       99.99
		//             9 No declarado |        395        0.01      100.00
		// ---------------------------+-----------------------------------
		//                      Total |  3,384,451      100.00
	gen ocupado    = PEA_NEA==1 & edad>=10
	gen desocupado = PEA_NEA==2 & edad>=10
	gen inactivo   = PEA_NEA==3 & edad>=10
	*-------------------------------------------------
	des P225A_REDOPOR	 	//	byte    %22.0f     REDOPOR    22.5A. RED DE OPORTUNIDADES
	tab P225A_REDOPOR, m	//	1
	gen redoportu = P225A_REDOPOR==1
	*-------------------------------------------------
	des P225B_120A65 	 	//	byte    %14.0f     L120A65    22.5B. 120 A LOS 65
	tab P225B_120A65, m		//	2
	gen ciento20a65 = P225B_120A65==1
	*-------------------------------------------------
	des P225C_ANGELG	 	//	byte    %17.0f     ANGELGUA   22.5C. ÁNGEL GUARDIÁN
	tab P225C_ANGELG, m		//	3
	gen angelguard = P225C_ANGELG==3
	*-------------------------------------------------
	
	*-------------------------------------------------
	*-----------------------------------------------------------------------------------------------
	keep  LLAVEVIV HOGAR NPERSONA  jefe conyuge hij noparie servdom mujer edad mayor adulto joven menor indigena kuna ngabe embera afro afropan moreno otroafro casado unido soltero sepdiv viudo casunido  asegurado beneficia jubilado noseguro leeescribe estudia asistepubl asistepriv asistio nuncasist eningun eprimplus esecplus esupplus ocupado desocupado inactivo redoportu ciento20a65 angelguard
	
	compress
save "${dta}1400_Censo2023_Persona.dta", replace
****************************************************************************************************	




* Hay hogares que no tienen jefe
// use "${censo2023}stata/CEN2023_PERSONA.dta", clear
// 	keep if P01_RELA==1
// 	gen one=1
// 	collapse (sum) one,by(LLAVEVIV)
// tempfile conjefe
// save 	`conjefe'
// use "${censo2023}stata/CEN2023_PERSONA.dta", clear
// merge m:1 LLAVEVIV using `conjefe'
// 	keep if _m==1
// 	tab P01_RELA
// 	unique LLAVEVIV	//	2999 hogares
	
	
	
	
	
	
	
	