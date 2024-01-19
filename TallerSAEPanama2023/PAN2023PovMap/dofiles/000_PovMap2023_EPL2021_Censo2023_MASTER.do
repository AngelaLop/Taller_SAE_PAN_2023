****************************************************************************************************
* 000_PovMap2023_EPL2021_Censo2023_MASTER.do
****************************************************************************************************
* POVERTY MAPS
*---------------------------------------------------------------------------------------------------
// Programed by: 	Ramiro Malaga 
// Date: 				20230910
// 	last modification	20231003
*---------------------------------------------------------------------------------------------------
* Instructions: the following DoFile has ten sections
*	I   ) SECTION A: 0000 SETTINGS AND MAIN PATHS. 
*   II  ) SECTION B: 1000 PREPARING CENSUS  
*	III ) SECTION C: 2000 PREPARING SURVEY 
* 	IV  ) SECTION D: 3000 PREPARING MAPS
*	I   ) SECTION E: 4000 CONSOLIDATING DATA SET AND DIAGNOSTICS
*   VI  ) SECTION F: 5000 MODELING
*   VII ) SECTION G: 6000 ESTIMATES
*   VIII) SECTION H: 7000 POSTESTIMATES
*   IX  ) SECTION I: 8000 MAPS AND FIGURES
*   X   ) SECTION J: 9000 PUBLICATION READY
*---------------------------------------------------------------------------------------------------
* Notes: 

****************************************************************************************************

cap net install unique
cap net install mdesc
cap net install geo2xy
cap net install elasticregress
sysdir

* Sometimes SAE.ado does not work after instalation. Try the following:
run "c:/ado/plus/l/lsae_povmap.mata"		// change PLUS directory accordingly 

****************************************************************************************************
* SECTION A. SETTINGS AND MAIN PATHS

*---------------------------------------------------------------------------------------------------
* A.1. SETTINGS AND VERSION CONTROL
	clear all							// Starts with a clean memory
	version 14.1 						// Run the program as of Stata 14.1
	set more off 						// Disable partitioned output
	set linesize 130					// Stata output size limited for readability
	macro drop all 						// Clear any macros in memory
	cls
	pause off
	set maxvar 120000
*---------------------------------------------------------------------------------------------------
* A.2. MAIN PATHS

* Set the user:
	global user 		"C:/Users/`c(username)'/"
	dir  				"${user}"
	
* Set main paths in WBG laptop
	global root			"${user}WBG/Javier Romero - Panama/"
	global data			"${root}data/"
	global povmap2023	"${root}Poverty maps/PovertyMap2023/"
	
* Checking folders:
	dir  "${root}"
	dir  "${data}"
	dir  "${povmap2023}"
*---------------------------------------------------------------------------------------------------
* A.3. INPUT INFORMATION
		
* Folders with raw HIES and PSLM data
	global harmonized 		"${root}Poverty Assessment/Analysis/Rawdata/"		// EMP harmonized
	global EML2021			"${data}Encuestas Sociales/EML 2021/2021/"
	global censo2023 		"${data}Censo 2023/rawdata/"
	
* Folder with consumption and income aggregate
	global povertydata		"${povmap2023}input/povertydata/" 		// here copied from poverty folders!
	
* Folder with UNOCHA shapefiles 2022
	global shapefiles2023	"${povmap2023}input/shapefiles2023/"
	
* Checking folders:
	dir 	"${harmonized}"
	dir 	"${EML2021}"
	dir 	"${censo2023}"
	dir  	"${povertydata}"
	dir  	"${shapefiles2023}"

*---------------------------------------------------------------------------------------------------			
* A.4. DO FILES AND ADO FILES
	global adofiles     "${povmap2023}adofiles/"
	global dofiles      "${povmap2023}dofiles/"
	
* Checking folders:
	dir  "${adofiles}"
	dir  "${dofiles}"	
*---------------------------------------------------------------------------------------------------	
* A.5. OUTPUT AND INTERMEDIATE FILES
	global docx     "${povmap2023}output/docx/"
	global graphs   "${povmap2023}output/graphs/"
	global logs     "${povmap2023}output/logs/"
	global xlsx     "${povmap2023}output/xlsx/"
	global output	"${povmap2023}output/dta/"
	
	global dta     	"${povmap2023}temp/dta/"
	global mymata   "${povmap2023}temp/mymata/"
	
	
* Checking folders:
	dir "${docx}"	
	dir "${graphs}"
	dir "${logs}"	
	dir "${xlsx}"
	dir "${output}"
	
	dir "${dta}"	
	dir "${mymata}"
*---------------------------------------------------------------------------------------------------
* A.5. GLOBAL PARAMETERS
//
	global mcreps	"600"			// number of Monte Carlo repetitions
	global bsreps	"0"				// number of Bootsptrap repetitions
	global rndseed 	"680148"
	global plinevar	"plinevar"

	global logdep	= "lnipcf"
	global varlevel = "ipcf"
	global depvar 	= "lnskewy"
	global area 	= "codePDC"		// district effects
	global uniquehh = "codePDCAVH"
	global popwt 	= "popwt"
****************************************************************************************************	
// cls




****************************************************************************************************
* Preparando Censo2023
	include "${dofiles}1010_Censo2023_CodigosUnicos.do"
	include "${dofiles}1100_Censo2023_Vivienda.do"
	include "${dofiles}1400_Censo2023_Persona.do"
	include "${dofiles}1700_Censo2023_Jefe.do"
	include "${dofiles}1800_Censo2023_Familia.do"
	include "${dofiles}1900_Censo2023_Consolidando.do"
*---------------------------------------------------------------------------------------------------	
* Preparando EML2021
	include "${dofiles}2010_EML2021_CodigosUnicos.do"
	include "${dofiles}2100_EML2021_Vivienda.do" 
	include "${dofiles}2400_EML2021_Persona.do"
	include "${dofiles}2700_EML2021_Jefe.do"
	include "${dofiles}2800_EML2021_Familia.do"
	include "${dofiles}2900_EML2021_Consolidando.do"
*---------------------------------------------------------------------------------------------------
 	include "${dofiles}3100_Matching_UNOCHA2021.do"
 	include "${dofiles}4000_Censo2023_EML2021_readytoCensusEB.do"

****************************************************************************************************
