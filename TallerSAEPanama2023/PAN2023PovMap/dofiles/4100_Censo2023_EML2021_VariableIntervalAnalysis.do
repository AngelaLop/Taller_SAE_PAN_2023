* 4100_Censo2023_EML2021_VariableIntervalAnalysis.do

* Creates a dta with the variable labels
****************************************************************************************************
use "${dta}4000_Censo2023_EML2021_readytoCensusEB.dta", clear	
	unab 	lettervars : H_* F_* C_* D_* 	// creates a global with the variables starting with letters
	global 	lettervars "`lettervars'"
	local numberwords : word count $lettervars
	display "`numberwords'"		// 46 variables

	keep in 1
	xpose, var clear
// 	bro
	keep in 54/235			// Change this line if there are more/less variables
	rename _varname Variable
	keep Variable
	gen Order  = _n
	order Order Variable
	gen minEML2021		= .
	gen maxEML2021		= .
	gen minCenso2023		= .
	gen maxCenso2023		= .
	gen meanEML2021	= .
	gen sdEML2021		= .
	gen meanCenso2023	= .
	gen sdCenso2023	= .
	gen ll99CI 		= .
	gen ul99CI 		= .
	gen CI99		= 0
	gen ll95CI 		= .
	gen ul95CI 		= .
	gen CI95		= 0
	gen ll90CI 		= .
	gen ul90CI 		= .
	gen CI90		= 0
	gen byte TR10	= 0
	gen byte TR20	= 0
	gen byte TR30	= 0
	format meanEML2021 sdEML2021 meanCenso2023 sdCenso2023 %9.4f
save "${dta}4100_VariableIntervalAnalysis_blank.dta", replace
unique Variable
*---------------------------------------------------------------------------------------------------
* To save the variable labels
use "${dta}2900_EML2021_Consolidando.dta", clear
	drop in 1/l
tempfile original
save 	`original'
use "${dta}4100_VariableIntervalAnalysis_blank.dta", clear
	keep Order Variable
	gen VariableLabel = ""
tempfile labels
save 	`labels'
use `original'
	qui {
		local i=1
		foreach v of global lettervars {
				local l`v' : variable label `v'
				use 	`labels'
				replace Variable      = "`v'" in `i'
				replace VariableLabel = "`l`v''" in `i'			
				local i=`i'+1
				save 	`labels', replace
				use `original'
		 }
	}	
use `labels'
	compress
save "${dta}4100_variablelabels.dta", replace
************************************************************************************************************************


	
	

************************************************************************************************************************
* NATIONAL DATA
use "${dta}4100_VariableIntervalAnalysis_blank.dta", clear
tempfile blank
save 	`blank'
*-------------
use "${dta}2900_EML2021_Consolidando.dta", clear
	* Loop over variables to fill EML2021 means and sd: 
	foreach v of global lettervars {
		qui sum `v' [aw=$popwt]				
		local mean	= r(mean)
		local sd 	= r(sd)
		local min	= r(min)
		local max 	= r(max)
		preserve
		qui use  `blank', clear
		qui replace meanEML2021 = `mean'  if Variable=="`v'"
		qui replace   sdEML2021 = `sd'    if Variable=="`v'"
		qui replace  minEML2021 = `min'   if Variable=="`v'"
		qui replace  maxEML2021 = `max'   if Variable=="`v'"
		qui save `blank', replace
		restore
	}	
use `blank', clear
*-------------
use "${dta}1900_Censo2023_Consolidando.dta", clear
	* Loop over variables to fill Censo2023 means and sd: 
	foreach v of global lettervars {
		qui sum `v' [aw=$popwt]
		local mean	= r(mean)
		local sd 	= r(sd)
		local min	= r(min)
		local max 	= r(max)
		preserve
		qui use  `blank', clear
		qui replace meanCenso2023 = `mean' if Variable=="`v'"
		qui replace   sdCenso2023 = `sd'   if Variable=="`v'"
		qui replace  minCenso2023 = `min'  if Variable=="`v'"
		qui replace  maxCenso2023 = `max'  if Variable=="`v'"
		qui save `blank', replace
		restore
	}
use `blank', clear
*-------------
use "${dta}2900_EML2021_Consolidando.dta", clear
	* Loop over variables to fill EML2021 intervals: 
	foreach v of global lettervars {
		qui svy: mean `v'					, level(99)
			local ll99	= r(table)[5,1]
			local ul99 	= r(table)[6,1]
		qui svy: mean `v'					, level(95)
			local ll95	= r(table)[5,1]
			local ul95 	= r(table)[6,1]
		qui svy: mean `v'					, level(90)
			local ll90	= r(table)[5,1]
			local ul90 	= r(table)[6,1]
		preserve
			qui use  `blank', clear
			qui replace ll99CI = `ll99'  if Variable=="`v'"
			qui replace ul99CI = `ul99'  if Variable=="`v'"
			qui replace ll95CI = `ll95'  if Variable=="`v'"
			qui replace ul95CI = `ul95'  if Variable=="`v'"
			qui replace ll90CI = `ll90'  if Variable=="`v'"
			qui replace ul90CI = `ul90'  if Variable=="`v'"
			qui save `blank', replace
		restore
	}
use `blank', clear
*-------------
use  `blank', clear
	replace CI99 = 1 if meanCenso2023>ll99CI  & meanCenso2023<ul99CI
	replace CI95 = 1 if meanCenso2023>ll95CI  & meanCenso2023<ul95CI
	replace CI90 = 1 if meanCenso2023>ll90CI  & meanCenso2023<ul90CI
	gen ratiomeans =meanEML2021/meanCenso2023
	gen ratiosd =  sdEML2021/sdCenso2023
	replace TR10 = 1 if (ratiomeans<1.1 & ratiomeans>0.9 & ratiosd<1.1 & ratiosd>0.9)
	replace TR20 = 1 if (ratiomeans<1.2 & ratiomeans>0.8 & ratiosd<1.2 & ratiosd>0.8)
	replace TR30 = 1 if (ratiomeans<1.3 & ratiomeans>0.7 & ratiosd<1.3 & ratiosd>0.7)
	format mean* sd* *CI  ratio* %9.4f
	format mean* sd*      ratio* %9.4f
merge 1:1 Variable using "${dta}4100_variablelabels.dta", nogen
	gsort Order
	order Order	Variable minEML2021 maxEML2021 minCenso2023 maxCenso2023 meanEML2021 sdEML2021 meanCenso2023 sdCenso2023 ll99CI ul99CI ll95CI ul95CI ll90CI ul90CI TR10 TR20 TR30 CI99 CI95 CI90 ratiomeans ratiosd VariableLabel
preserve
	collapse (sum) TR10 TR20 TR30 CI99 CI95 CI90
tempfile total
save 	`total'
restore
	append using `total'
save "${dta}4100_VariableIntervalAnalysis.dta", replace
// export excel using "${xlsx}4100_VariableIntervalAnalysis.xlsx", sheet("`National") sheetmodify firstrow(variables) nolabel keepcellfmt
****************************************************************************************************
use "${dta}4100_VariableIntervalAnalysis.dta", clear
misstable sum meanEML2021