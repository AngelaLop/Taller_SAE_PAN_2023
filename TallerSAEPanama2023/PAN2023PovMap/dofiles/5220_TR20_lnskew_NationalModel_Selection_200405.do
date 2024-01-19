* 5220_TR20_lnskew_NationalModel_Selection_2021.do

* 5 for modeling
* 2 for TR20 (1:TR10 2:TR20 3:TR30)
* 2 for lnskew (1:ln 2:lnskew 3:bcox)
* 0 for National (1:KP 2:Punjab 3:Sindh 4:Balochistan)
log using "${logs}5220_TR20_lnskew_NationalModel_Selection_2021", replace
****************************************************************************************************
* Uploading the list of variables
use  "${dta}4100_VariableIntervalAnalysis.dta", clear
	keep if TR20==1
	levelsof Variable, clean
    global    varlist "`r(levels)'"	// we save in this global the list of variables
	display "$varlist"
*--------------------------------------------------------
* Uploading the data set
use "${dta}4000_Censo2023_EML2021_readytoCensusEB.dta", clear
	global depvar "lnskewy"
	keep if censo==0
	keep  llave_sec hogar codeP codePD codePDC codePDCA codePDCAV codePDCAVH pondera dist corre estra unidad cuest psu miembros ipcf iea ilea_m ieb iec ied iee provincia hogar_inec popwt censo LLAVEVIV HOGAR P1 P2 P3 P4 P5 P6 P7 P8 P9 P10 P11 P12 P13 lnskewy bcy lnipcf plinevar zeroes R $varlist
*--------------------------------------------------------
* Eliminating extreme values (the )	
	sum $depvar 
	gen todrop= !(inrange($depvar,r(mean)-4*r(sd),r(mean)+4*r(sd)))
	drop if todrop==1		//	33 observations deleted
*-------------------------------------------------------------------------------
* Ordering descending to drop redundant variables (omitted because of estimability)
timer clear 1
timer on    1
	set seed $rndseed
	local depvar $depvar
	local rhside "$varlist"
	include "${dofiles}0301_DescendingOrderingCorrelation.do"
	display "$orderednames"
	stepwise, pr(0.999999): reg $depvar $orderednames  [aw=popwt]
	local vars_swb : colfullnames e(b)
	global firstfilter : subinstr local vars_swb "_cons" "", word	// drops "constant"
	local numberwords : word count $firstfilter
	display "`numberwords'"					//	13
	keep  llave_sec hogar codeP codePD codePDC codePDCA codePDCAV codePDCAVH pondera dist corre estra unidad cuest psu miembros ipcf iea ilea_m ieb iec ied iee provincia hogar_inec popwt censo LLAVEVIV HOGAR P1 P2 P3 P4 P5 P6 P7 P8 P9 P10 P11 P12 P13 lnskewy bcy lnipcf plinevar zeroes R $firstfilter
timer off  1
timer list 1	//	0.6850
*--------------------------------------------------------	
* Lasso selection per group of variables.
* 	Note: 	Lasso works well dropping the variables that MUST NOT BE in the model.
* 		  	We can do it by group of variables to make the algorithm faster
* 		  	Then we can do a lasso for all the variables that pass that stage.
* 			H_* W_* D_* K_* A_* C_* F_* E_* J_* N_* V_* S_* M_*
timer clear 2
timer on    2
	set seed $rndseed
	*-----------------------------------------------------
	unab 	lista : H_* 	// creates a global with the variables starting with letters
	global 	lista "`lista'"
	foreach x of global lista  {
		gen  R`x' =  R*`x'
	}
	lassoregress $depvar R P* H_* RH_* [aw=$popwt], lambda1se epsilon(1e-10) numfolds(10)
	local hhvars = e(varlist_nonzero)
	local hhvars : list sort hhvars
	global plH `hhvars'
	display   "$plH"
	*-----------------------------------------------------
	unab 	lista : C_* 	// creates a global with the variables starting with letters
	global 	lista "`lista'"
	foreach x of global lista  {
		gen  R`x' =  R*`x'
	}
	lassoregress $depvar R P* C_* RC_* [aw=$popwt], lambda1se epsilon(1e-10) numfolds(10)
	local hhvars = e(varlist_nonzero)
	local hhvars : list sort hhvars
	global plC `hhvars'
	display   "$plC"
	*-----------------------------------------------------
	unab 	lista : F_* 	// creates a global with the variables starting with letters
	global 	lista "`lista'"
	foreach x of global lista  {
		gen  R`x' =  R*`x'
	}
	lassoregress $depvar R P* F_* RF_* [aw=$popwt], lambda1se epsilon(1e-10) numfolds(10)
	local hhvars = e(varlist_nonzero)
	local hhvars : list sort hhvars
	global plF `hhvars'
	display   "$plF"
	*-----------------------------------------------------
	unab 	lista : D_* 	// creates a global with the variables starting with letters
	global 	lista "`lista'"
	foreach x of global lista  {
		gen  R`x' =  R*`x'
	}
	lassoregress $depvar R P* D_* RD_* [aw=$popwt], lambda1se epsilon(1e-10) numfolds(10)
	local hhvars = e(varlist_nonzero)
	local hhvars : list sort hhvars
	global plD `hhvars'
	display   "$plD"
	*-----------------------------------------------------
	lassoregress $depvar R $plH $plC $plF $plD  [aw=$popwt], lambda1se epsilon(1e-10) numfolds(10)
	local hhvars = e(varlist_nonzero)
	local hhvars : list sort hhvars
	global postlasso `hhvars'
	display   "$postlasso"
	local numberwords : word count $postlasso
	display "`numberwords'"		// 13
timer off  2
timer list 2	//	6.7100
	*-----------------------------------------------------
	regress $depvar $postlasso [aw=popwt], notable 	// Adj R-squared    =    0.7103
	sae model h3 $depvar $postlasso  [pw= $popwt] , area($area)	 //  		 0.71015436
*---------------------------------------------------------------------------------------------------
	local depvar $depvar
	local rhside $postlasso
	include "${dofiles}0301_DescendingOrderingCorrelation.do"
	display "$orderednames"
	
* Recursive elimination
	set seed $rndseed
	timer clear 4
	timer on    4
	version 14
	local hhvars = "$orderednames"
	local step = 1
	forval z= 0.5000(-0.1000)0.1000 {
		display "Step number `step'"
		local step = `step' + 1
		qui:sae model h3 $depvar `hhvars' [pw=$popwt], area($area)
		mata: bb	= st_matrix("e(b_gls)")
		mata: se	= sqrt(diagonal(st_matrix("e(V_gls)")))
		mata: zvals = bb':/se
		mata: st_matrix("min",min(abs(zvals)))
		local zv = (-min[1,1])
		if (2*normal(`zv')<`z') exit
		
		foreach x of varlist `hhvars' {
			local hhvars1
			qui: sae model h3 $depvar `hhvars' [pw=$popwt], area($area)
			qui: test `x'
			if (r(p)>`z') {
				local hhvars1
				foreach yy of local hhvars {
				if ("`yy'"=="`x'") dis "."
				else local hhvars1 `hhvars1' `yy'
				}
			}
			else local hhvars1 `hhvars' 
			local hhvars `hhvars1' 
			display "x"
		}
	}
	global    postsign `hhvars'
	display "$postsign"
	timer off  4
	timer list 4	//	42.7420
	
	local     numberwords : word count $postsign
	display "`numberwords'"										//   40
	
	capture drop  __hsyk0_0 __mz1_000 __myh_000 __myh2_000 _est_bGLS
	sae model h3 $depvar $postsign [pw=$popwt], area($area) 	//	0.70954314
*-------------------------------------------------------------------------------
* STEP 3: REMOVING HIGHY COLLINEAR REGRESORS WITH VARIANCE INFLATION FACTOR 
* Henderson III GLS - model post removal of non-significant

	* Check for multicollinearity, and remove highly collinear (VIF>3)
	set seed $rndseed
	reg $depvar $postsign [pw=$popwt], vce(cluster $area)
	cap drop touse //remove vector if it is present to avoid error in next step
	gen touse = e(sample) //Indicates the observations used
	vif //Variance inflation factor
	local hhvars $postsign

	* Remove covariates with VIF greater than 7
	mata: ds = _f_stepvif("`hhvars'","$popwt",7,"touse")
	global postvif `vifvar'
	
	* VIF check
	reg $depvar $postvif [pw=$popwt], r
	vif
	
	local numberwords : word count $postvif
	display "`numberwords'"											// words: 
	
	//Henderson III GLS - model post removal of non-significant
	sae model h3 $depvar $postvif [pw=$popwt], area($area)			//	0	
*---------------------------------------------------------------------------------------------------
	local depvar $depvar
	local rhside $postvif
	include "${dofiles}0301_DescendingOrderingCorrelation.do"
	display "$orderednames"
	
* Recursive elimination
	set seed $rndseed
	timer clear 5
	timer on    5
	version 14
	local hhvars = "$orderednames"
	local step = 1
	forval z= 0.1000(-0.0100)0.0100 {
		display "Step number `step'"
		local step = `step' + 1
		qui:sae model h3 $depvar `hhvars' [pw=$popwt], area($area)
		mata: bb	= st_matrix("e(b_gls)")
		mata: se	= sqrt(diagonal(st_matrix("e(V_gls)")))
		mata: zvals = bb':/se
		mata: st_matrix("min",min(abs(zvals)))
		local zv = (-min[1,1])
		if (2*normal(`zv')<`z') exit
		
		foreach x of varlist `hhvars' {
			local hhvars1
			qui: sae model h3 $depvar `hhvars' [pw=$popwt], area($area)
			qui: test `x'
			if (r(p)>`z') {
				local hhvars1
				foreach yy of local hhvars {
				if ("`yy'"=="`x'") dis "."
				else local hhvars1 `hhvars1' `yy'
				}
			}
			else local hhvars1 `hhvars' 
			local hhvars `hhvars1' 
			display "x"
		}
	}
	global    postsign2 `hhvars'
	display "$postsign2"
	timer off  5
	timer list 5	//	
	
	local     numberwords : word count $postsign2
	display "`numberwords'"										//  
	
	capture drop  __hsyk0_0 __mz1_000 __myh_000 __myh2_000 _est_bGLS
	sae model h3 $depvar $postsign2 [pw=$popwt], area($area) 	//	0
*-------------------------------------------------------------------------------
* STEP 3: REMOVING HIGHY COLLINEAR REGRESORS WITH VARIANCE INFLATION FACTOR 
* Henderson III GLS - model post removal of non-significant

	* Check for multicollinearity, and remove highly collinear (VIF>3)
	set seed $rndseed
	reg $depvar $postsign2 [pw=$popwt], vce(cluster $area)
	cap drop touse //remove vector if it is present to avoid error in next step
	gen touse = e(sample) //Indicates the observations used
	vif //Variance inflation factor
	local hhvars $postsign2

	* Remove covariates with VIF greater than 5
	mata: ds = _f_stepvif("`hhvars'","$popwt",5,"touse")
	global postvif2 `vifvar'
	
	* VIF check
	reg $depvar $postvif2 [pw=$popwt], r
	vif
	
	local numberwords : word count $postvif2
	display "`numberwords'"											// words: 
	
	//Henderson III GLS - model post removal of non-significant
	sae model h3 $depvar $postvif2 [pw=$popwt], area($area)			//	0
*---------------------------------------------------------------------------------------------------
	local depvar $depvar
	local rhside $postvif2
	include "${dofiles}0301_DescendingOrderingCorrelation.do"
	display "$orderednames"
	
* Recursive elimination
	set seed $rndseed
	timer clear 6
	timer on    6
	version 14
	local hhvars = "$orderednames"
	local step = 1
	forval z= 0.0100(-0.0010)0.0010 {
		display "Step number `step'"
		local step = `step' + 1
		qui:sae model h3 $depvar `hhvars' [pw=$popwt], area($area)
		mata: bb	= st_matrix("e(b_gls)")
		mata: se	= sqrt(diagonal(st_matrix("e(V_gls)")))
		mata: zvals = bb':/se
		mata: st_matrix("min",min(abs(zvals)))
		local zv = (-min[1,1])
		if (2*normal(`zv')<`z') exit
		
		foreach x of varlist `hhvars' {
			local hhvars1
			qui: sae model h3 $depvar `hhvars' [pw=$popwt], area($area)
			qui: test `x'
			if (r(p)>`z') {
				local hhvars1
				foreach yy of local hhvars {
				if ("`yy'"=="`x'") dis "."
				else local hhvars1 `hhvars1' `yy'
				}
			}
			else local hhvars1 `hhvars' 
			local hhvars `hhvars1' 
			display "x"
		}
	}
	global    postsign3 `hhvars'
	display "$postsign3"
	timer off  6
	timer list 6	//	
	
	local     numberwords : word count $postsign3
	display "`numberwords'"										//  
	
	capture drop  __hsyk0_0 __mz1_000 __myh_000 __myh2_000 _est_bGLS
	sae model h3 $depvar $postsign3 [pw=$popwt], area($area) 	//	0
*-------------------------------------------------------------------------------
* STEP 3: REMOVING HIGHY COLLINEAR REGRESORS WITH VARIANCE INFLATION FACTOR 
* Henderson III GLS - model post removal of non-significant

	* Check for multicollinearity, and remove highly collinear (VIF>3)
	set seed $rndseed
	reg $depvar $postsign3 [pw=$popwt], vce(cluster $area)
	cap drop touse //remove vector if it is present to avoid error in next step
	gen touse = e(sample) //Indicates the observations used
	vif //Variance inflation factor
	local hhvars $postsign3

	* Remove covariates with VIF greater than 3
	mata: ds = _f_stepvif("`hhvars'","$popwt",3,"touse")
	global postvif3 `vifvar'
	
	* VIF check
	reg $depvar $postvif3 [pw=$popwt], r
	vif
	
	local numberwords : word count $postvif3
	display "`numberwords'"											// words: 
	
	//Henderson III GLS - model post removal of non-significant
	sae model h3 $depvar $postvif3 [pw=$popwt], area($area)			//	.4634366	

	display "$postvif3"
// F_hnoseguro C_esecplus H_fmosaico C_noseguro F_hasegurado F_rleeescri D_icompu H_pladrillo D_icable F_hasistepubl H_clena RH_aalldia C_esupplus H_ncuartos C_ngabe C_unido F_jubilado P8 P11 RF_menor RC_jefemujer RF_hbeneficia F_nservdom F_desocupado H_tmetal F_hocupado F_ocupado P2 RH_alquilada P6

*---------------------------------------------------------------------------------------------------	



*---------------------------------------------------------------------------------------------------
* STEP 4: MODEL CHECKS
*===============================================================================
* Residual Analysis
*===============================================================================
* Normality
	set seed $rndseed
	reg $depvar $postvif3 [aw=$popwt],r
	predict resid, resid
	* Kernel density plot for residuals with a normal density overlaid
	kdensity resid, normal `graphs' graphregion(fcolor(white) lcolor(white))
	graph export "${graphs}5220_kdensity_resid_20212023.png", as(png) replace
	* Standardized normal probability
	pnorm resid , `graphs' graphregion(fcolor(white) lcolor(white)) msize(small) mfcolor(%01) mlcolor(%0) rlopts(lcolor(red))
	graph export "${graphs}5220_pnorm_20212023.png", as(png) replace
	* Quantiles of a variable against the quantiles of a normal distribution
	qnorm resid , `graphs' graphregion(fcolor(white) lcolor(white)) msize(small) mfcolor(%15) mlcolor(%0) rlopts(lcolor(red)) 
	graph export "${graphs}5220_qnorm_20212023.png", as(png) replace
	* Numerical Test: Shapiro-Wilk W test for normal data
	swilk resid
	
* Heteroscedasticity
	reg $depvar $postvif
	* Residuals vs fitted values with a reference line at y=0
	rvfplot , yline(0) `graphs' graphregion(fcolor(white) lcolor(white)) msize(small) mfcolor(%15) mlcolor(%0)
	graph export "${graphs}5220_rvfplot_1_20212023.png", as(png) replace
	* Cameron & Trivedi´s decomposition of IM-test / White test
// 	estat imtest
	* Breusch-Pagan / Cook-Weisberg test for heteroskedasticity
// 	estat hettest
*===============================================================================
* Influence Analysis
*===============================================================================
* Graphic method < before >
	reg $depvar $postsign [aw=$popwt]
	* residuals vs fitted vals
	rvfplot , yline(0) `graphs' msize(small) mfcolor(%15) mlcolor(%0) graphregion(fcolor(white) lcolor(white))
	graph export "${graphs}5220_rvfplot_2_20212023.png", as(png) replace
	* normalized residual squared vs leverage
	lvr2plot , `graphs' msize(small) mfcolor(%15) mlcolor(%0) graphregion(fcolor(white) lcolor(white))
	graph export "${graphs}5220_lvr2plot_20212023.png", as(png) replace

* Numerical method
	* Step 1
	reg $depvar $postsign
	* After regression without weights...
	* Calculate measures to identify influential observations
	predict cdist, cooksd // calculates the Cook´s D influence statistic
	predict rstud, rstudent // calculates the Studentized (jackknifed) residuals
	
	* Step 2
	reg $depvar $postsign [aw=$popwt]
	* Predict leverage and residuals
	predict lev, leverage // calculates the diagonal elements of the
	* projection ("hat") matrix
	predict r, resid // calculates the residuals
	* Save useful locals
	local myN=e(N) // # observations
	local myK=e(rank) // rank or k
	local KK =e(df_m) // degrees of freedom (k-1)
	sum cdist, d
	* return list
	local max = r(max) // max value
	local p99 = r(p99) // percentile 99

	* Step 3
	* For ilustration...
	* We have influential data points...
// 	gen lnexpM=ln($varlevel)
	reg $logdep $postsign if cdist<4/`myN' 	[aw=$popwt]
	reg $logdep $postsign if cdist<`p99' 	[aw=$popwt]
	reg $logdep $postsign if cdist<`max' 	[aw=$popwt]
	* Identified influential / outliers observations
	gen nogo = abs(rstud)>2 & cdist>4/`myN' & lev>(2*`myK'+2)/`myN'
	
	count if nogo==1 // these are the obs that we want to eliminate
	* Graphic method < after >
	reg $depvar $postsign [aw=$popwt] if nogo==0
	* residuals vs fitted vals
	rvfplot , yline(0) `graphs' msize(small) mfcolor(%15) mlcolor(%0) graphregion(fcolor(white) lcolor(white))
	graph export "${graphs}5220_rvfplot_2_after_20212023.png", as(png) replace
	* normalized residual squared vs leverage
	lvr2plot , `graphs' msize(small) mfcolor(%15) mlcolor(%0) graphregion(fcolor(white) lcolor(white))
	graph export "${graphs}5220_lvr2plot_after_20212023.png", as(png) replace
*---------------------------------------------------------------------------------------------------
* STEP 5: SELECTING THE ALPHA MODEL

* Henderson III GLS - add alfa model
	cap gen zeroes=0
	sae model h3 $depvar $postvif3 if nogo==0 [pw=$popwt], area($area) alfatest(residual) zvar(zeroes)
	des residual_alfa 	// The dependent variable for the alfa model
*-----------------------------------------------------------------
* Macro with current variables
	local postvif $postvif
	local allvars $firstfilter 
	des `allvars'
	
* We want to only use variables not used
	foreach x of local allvars {
		local in = 0
		foreach y of local postvif {
			if ("`x'"=="`y'") local in=1
		}
		if (`in'==0) local A `A' `x'
	}
	global A `A'  // macro holding eligible variables for alpha model
	dis "$A"
*-----------------------------------------------------------------
	local depvar $depvar
	local rhside $A 
	include "${dofiles}0301_DescendingOrderingCorrelation.do"
	display "$orderednames"

	lasso linear residual_alfa $orderednames if nogo==0 [iw=$popwt], rseed(1234) 
	global    linearalfa "`e(allvars_sel)'"
	display "$linearalfa"		

// 	lassoknots, alllambdas
*-----------------------------------------------------------------
	reg residual_alfa $linearalfa if nogo==0 [pw=$popwt], r
	cap drop tousealfa
	gen tousealfa = e(sample)

	//Remove vif vars
	mata: ds = _f_stepvif("$linearalfa","$popwt",5,"tousealfa")
	global    linearalfa `vifvar'
	display "$linearalfa"
*-----------------------------------------------------------------
	set seed $rndseed
	version 14
	local hhvars $linearalfa 
	forval z= 0.90(-0.05)0.05 {
		foreach x of varlist `hhvars' {
			local hhvars1
			qui: reg residual_alfa `hhvars' [pw=$popwt], r
			qui: test `x'
			if (r(p)>`z') {
				local hhvars1
				foreach yy of local hhvars {
					if ("`yy'"=="`x'") dis ""
					else local hhvars1 `hhvars1' `yy'
				}
			}
			else local hhvars1 `hhvars'
			local hhvars `hhvars1'
		}
	}
	global    linearalfa `hhvars'
	display "$linearalfa"
	
	version 14
	local hhvars $linearalfa
	forval z= 0.050(-0.001)0.001 {
		foreach x of varlist `hhvars' {
			local hhvars1
			qui: reg residual_alfa `hhvars' [pw=$popwt], r
			qui: test `x'
			if (r(p)>`z') {
				local hhvars1
				foreach yy of local hhvars {
					if ("`yy'"=="`x'") dis ""
					else local hhvars1 `hhvars1' `yy'
				}
			}
			else local hhvars1 `hhvars'
			local hhvars `hhvars1'
		}
	}
	global    alfavars `hhvars'
	display "$alfavars"

	sae model h3 $depvar $postvif3 if nogo==0 [pw=$popwt], area($area) zvar($alfavars)	 // 0
*---------------------------------------------------------------------------------------------------
* STEP 6: GLS MODEL, FINAL REMOVAL OF NON-SIGNIFICANT VARIABLES
timer clear 8
timer on    8
	set seed $rndseed
	local depvar $depvar
	local rhside $postvif3
	include "${dofiles}0301_DescendingOrderingCorrelation.do"
	display "$orderednames"
	
	local hhvars $orderednames
	version 14
	forval z= 0.0010(-0.0001)0.0001 {
		
		qui : sae model h3 $depvar `hhvars' if nogo==0 [pw=$popwt], area($area) zvar($alfavars)
		mata: bb=st_matrix("e(b_gls)")
		mata: se=sqrt(diagonal(st_matrix("e(V_gls)")))
		mata: zvals = bb':/se
		mata: st_matrix("min",min(abs(zvals)))
		local zv = (-min[1,1])
		
		if (2*normal(`zv')<`z') exit
			foreach x of varlist `hhvars'{
			local hhvars1
			qui:sae model h3 $depvar `hhvars' if nogo==0 [pw=$popwt], area($area) zvar($alfavars)
			qui: test `x'
			
			if (r(p)>`z'){
			local hhvars1
			foreach yy of local hhvars{
					if ("`yy'"=="`x'") dis ""
					else local hhvars1 `hhvars1' `yy'
				}
			}
		else local hhvars1 `hhvars'
		local hhvars `hhvars1'
		display "."
		}
	display "x"
	}
	global postalfa `hhvars'
	display "$postalfa"
timer off  8
timer list 8	//	



	version 14
	local hhvars $linearalfa
	forval z= 0.0010(-0.0001)0.0001 {
		foreach x of varlist `hhvars' {
			local hhvars1
			qui: reg residual_alfa `hhvars' [pw=$popwt], r
			qui: test `x'
			if (r(p)>`z') {
				local hhvars1
				foreach yy of local hhvars {
					if ("`yy'"=="`x'") dis ""
					else local hhvars1 `hhvars1' `yy'
				}
			}
			else local hhvars1 `hhvars'
			local hhvars `hhvars1'
		}
	}
	global    alfavars `hhvars'
	display "$alfavars"	
	
* STEP 6: GLS MODEL, FINAL REMOVAL OF NON-SIGNIFICANT VARIABLES
timer clear 9
timer on    9
	set seed $rndseed
	local depvar $depvar
	local rhside $postvif3
	include "${dofiles}0301_DescendingOrderingCorrelation.do"
	display "$orderednames"
	
	local hhvars $orderednames
	version 14
	forval z= 0.00010(-0.00001)0.00001 {
		
		qui : sae model h3 $depvar `hhvars' if nogo==0 [pw=$popwt], area($area) zvar($alfavars)
		mata: bb=st_matrix("e(b_gls)")
		mata: se=sqrt(diagonal(st_matrix("e(V_gls)")))
		mata: zvals = bb':/se
		mata: st_matrix("min",min(abs(zvals)))
		local zv = (-min[1,1])
		
		if (2*normal(`zv')<`z') exit
			foreach x of varlist `hhvars'{
			local hhvars1
			qui:sae model h3 $depvar `hhvars' if nogo==0 [pw=$popwt], area($area) zvar($alfavars)
			qui: test `x'
			
			if (r(p)>`z'){
			local hhvars1
			foreach yy of local hhvars{
					if ("`yy'"=="`x'") dis ""
					else local hhvars1 `hhvars1' `yy'
				}
			}
		else local hhvars1 `hhvars'
		local hhvars `hhvars1'
		display "."
		}
	display "x"
	}
	global postalfa `hhvars'
	display "$postalfa"
timer off  9
timer list 9	//	

	local 	  numberwords : word count $postalfa
	display "`numberwords'"															// 
	
sae model h3 $depvar $postalfa if nogo==0 [pw=$popwt], area($area) zvar($alfavars)	 // 0

keep codePDCAVH nogo censo
save "${dta}5220_TR20_lnskew_NationalModel_NOGO_20212023.dta", replace
****************************************************************************************************
log close


****************************************************************************************************
display "$postalfa"
// global postalfa "F_hnoseguro C_esecplus H_fmosaico F_hasegurado F_rleeescri D_icompu H_pladrillo D_icable F_hasistepubl RH_clena F_rocupado C_esupplus H_ncuartos F_joven P12 C_unido F_jubilado F_asistio H_tmetal P2 H_alquilada RH_stansept C_jefemujer P6"


display "$alfavars"
// global alfavars "C_asegurado H_tconcreto F_hsoltero"
*-------------------------------------------------------------------------------
use "${dta}4000_Censo2023_EML2021_readytoCensusEB.dta", clear
	keep  llave_sec hogar codeP codePD codePDC codePDCA codePDCAV codePDCAVH pondera dist corre estra unidad cuest psu miembros ipcf iea ilea_m ieb iec ied iee provincia hogar_inec popwt censo extplvar LLAVEVIV HOGAR P1 P2 P3 P4 P5 P6 P7 P8 P9 P10 P11 P12 P13 lnskewy bcy lnipcf plinevar zeroes R $firstfilter 
*-------------------------------------------------------------------------------
* Creating Interactions by Province
	unab 	lista : $firstfilter 	// creates a global with the variables 
	global 	lista "`lista'"
	display "$lista"
	foreach x of global lista {
		gen  R`x' =  R*`x'	
	}
	keep  llave_sec hogar codeP codePD codePDC codePDCA codePDCAV codePDCAVH pondera dist corre estra unidad cuest psu miembros ipcf iea ilea_m ieb iec ied iee provincia hogar_inec popwt censo extplvar LLAVEVIV HOGAR P1 P2 P3 P4 P5 P6 P7 P8 P9 P10 P11 P12 P13 lnskewy bcy lnipcf plinevar zeroes R $postalfa $alfavars
	des $postalfa $alfavars
merge 1:1 codePDCAVH censo using "${dta}5220_TR20_lnskew_NationalModel_NOGO_20212023.dta", gen(nogomerge)
save "${dta}5220_TR20_lnskew_NationalModel_Selection_20212023.dta", replace
unique codePDCAVH if censo==1	//	1224279 ok!
unique codePDCAVH if censo==0	//	11148 ok!
*-------------------------------------------------------------------------------
sae model h3 $depvar $postalfa  [pw=$popwt], area($area) zvar($alfavars)	 // 0.64199825
	sum $depvar 
	gen todrop= !(inrange($depvar,r(mean)-4*r(sd),r(mean)+4*r(sd)))
	drop if censo==1
	drop if todrop==1		//	35 observations deleted
	drop if nogo==1
sae model h3 $depvar $postalfa [pw=$popwt], area($area) zvar($alfavars)	 	// 0.68676115
****************************************************************************************************







****************************************************************************************************
log using "${logs}5220_TR20_lnskew_NationalModel", replace
	display "$postalfa"
	display "$alfavars"
	
*---------------------------------------------------------------------------------------------------
* IMPORTING eml21:
use "${dta}5220_TR20_lnskew_NationalModel_Selection_20212023.dta", clear
	keep if censo==0
	keep $varlevel $postalfa $alfavars $popwt $area $plinevar $uniquehh  
save "${mymata}/5220eml21.dta", replace							

* import command :
sae data import, datain($mymata/5220eml21.dta) 										///
	varlist($varlevel $postalfa $alfavars $popwt $area $plinevar $uniquehh  )  		///
	area($area) uniqid($uniquehh) dataout($mymata/5220eml21) 	
*---------------------------------------------------------------------------------------------------
* UPLOADING eml21: 
use "${dta}5220_TR20_lnskew_NationalModel_Selection_20212023.dta", clear
	gen todrop= !(inrange($depvar,r(mean)-4*r(sd),r(mean)+4*r(sd)))
	drop if todrop==1		//	34 observations deleted and will not consider in the model 
// 	drop if nogo==1
	keep if censo==0
	keep $varlevel $postalfa $alfavars $popwt $area $plinevar $uniquehh  
	
* SAE command for Census EB :
	sae sim h3  $varlevel $postalfa  [aw=$popwt], area($area) uniqid($uniquehh) 		///
		mcrep(500) bsrep(0) matin($mymata/5220eml21)									///
		indicators(fgt0) aggids(0) pwcensus($popwt)   								///
		zvar($alfavars) 															///
		seed($rndseed) plinevar($plinevar) lnskew_w 		//	.64194541
		
save "${output}5220_TR20_lnskew_NationalModel_resultseml21ineml21_200405.dta", replace
*--------------------------------------------------
use  "${output}5220_TR20_lnskew_NationalModel_resultseml21ineml21_200405.dta", clear
	collapse (mean) avg_fgt0_plinevar [pw=nIndividuals]		
	list , clean		//	0.24440708  vs benchmark 	0.24
	
use  "${output}5220_TR20_lnskew_NationalModel_resultseml21ineml21_200405.dta", clear
	gen dist=floor(Unit/100)
	collapse (mean) avg_fgt0_plinevar [pw=nIndividuals]	, by(dist)	
	format avg_fgt0_plinevar %9.6f
	list , clean	
*---------------------------------------------------------------------------------------------------


*---------------------------------------------------------------------------------------------------
* IMPORTING censo:
use "${dta}5220_TR20_lnskew_NationalModel_Selection_20212023.dta", clear
	keep if censo==1
	keep $varlevel $postalfa $alfavars $popwt $area $plinevar $uniquehh  
save "${mymata}/5220censo.dta", replace							

* import command :
sae data import, datain($mymata/5220censo.dta) 										///
	varlist($varlevel $postalfa $alfavars $popwt $area $plinevar $uniquehh  )  		///
	area($area) uniqid($uniquehh) dataout($mymata/5220censo) 	

*---------------------------------------------------------------------------------------------------
	timer clear 10
	timer on    10
	
* UPLOADING eml21: 
use "${dta}5220_TR20_lnskew_NationalModel_Selection_20212023.dta", clear
	keep if censo==0
	merge m:1 $area using "${dta}4000_paraborrar.dta"
	drop if paraborrar==1
	drop paraborrar _merge
	gen todrop= !(inrange($depvar,r(mean)-4*r(sd),r(mean)+4*r(sd)))
	drop if todrop==1		//	34 observations deleted and will not consider in the model 
// 	drop if nogo==1
	keep $varlevel $postalfa $alfavars $popwt $area $plinevar $uniquehh  
	
* SAE command for censo EB :
	sae sim h3  $varlevel $postalfa  [aw=$popwt], area($area) uniqid($uniquehh) 		///
		mcrep(500) bsrep(0) matin($mymata/5220censo)								///
		indicators(fgt0 fgt1 fgt2) aggids(0) pwcensus($popwt)   					///
		zvar($alfavars) 															///
		seed($rndseed) plinevar($plinevar) lnskew_w  ydump($mymata/5220ydump)	// 0.51188188
		
save "${output}5220_TR20_lnskew_NationalModel_resultseml21incenso_200405.dta", replace
*--------------------------------------------------
use  "${output}5220_TR20_lnskew_NationalModel_resultseml21incenso_200405.dta", clear
	collapse (mean) avg_fgt0_plinevar [pw=nIndividuals]		
	list , clean		//	.2693596

use  "${output}5220_TR20_lnskew_NationalModel_resultseml21incenso_200405.dta", clear
	gen codePD=floor(Unit/100)
	collapse (mean) avg_fgt0_plinevar [pw=nIndividuals]	, by(codePD)
	format avg_fgt0_plinevar %9.6f
	list , clean
 *---------------------------------------------------------------------------------------------------
	timer off  10
	timer list 10	//	
log close
****************************************************************************************************






****************************************************************************************************
log using "${logs}5220_TR20_lnskew_NationalModel_Extreme", replace
	display "$postalfa"
	display "$alfavars"
	
*---------------------------------------------------------------------------------------------------
* IMPORTING eml21:
use "${dta}5220_TR20_lnskew_NationalModel_Selection_20212023.dta", clear
	keep if censo==0
	keep $varlevel $postalfa $alfavars $popwt $area $plinevar $uniquehh  extplvar
save "${mymata}/5220eml21.dta", replace							

* import command :
sae data import, datain($mymata/5220eml21.dta) 										///
	varlist($varlevel $postalfa $alfavars $popwt $area $plinevar $uniquehh extplvar )  		///
	area($area) uniqid($uniquehh) dataout($mymata/5220eml21) 	
*---------------------------------------------------------------------------------------------------
* UPLOADING eml21: 
use "${dta}5220_TR20_lnskew_NationalModel_Selection_20212023.dta", clear
	gen todrop= !(inrange($depvar,r(mean)-4*r(sd),r(mean)+4*r(sd)))
	drop if todrop==1		//	34 observations deleted and will not consider in the model 
// 	drop if nogo==1
	keep if censo==0
	keep $varlevel $postalfa $alfavars $popwt $area $plinevar $uniquehh extplvar 
	
* SAE command for Census EB :
	sae sim h3  $varlevel $postalfa  [aw=$popwt], area($area) uniqid($uniquehh) 		///
		mcrep(500) bsrep(0) matin($mymata/5220eml21)									///
		indicators(fgt0) aggids(0) pwcensus($popwt)   								///
		zvar($alfavars) 															///
		seed($rndseed) plinevar(extplvar) lnskew_w 		//	
		
save "${output}5220_ExtremeStS.dta", replace
*--------------------------------------------------
use  "${output}5220_ExtremeStS.dta", clear
	collapse (mean) avg_fgt0_extplvar [pw=nIndividuals]		
	list , clean		//	0.24440708  vs benchmark 	0.24
	
use  "${output}5220_ExtremeStS.dta", clear
	gen dist=floor(Unit/100)
	collapse (mean) avg_fgt0_extplvar [pw=nIndividuals]	, by(dist)	
	format avg_fgt0_extplvar %9.6f
	list , clean	
*---------------------------------------------------------------------------------------------------


*---------------------------------------------------------------------------------------------------
* IMPORTING censo:
use "${dta}5220_TR20_lnskew_NationalModel_Selection_20212023.dta", clear
	keep if censo==1
	keep $varlevel $postalfa $alfavars $popwt $area $plinevar $uniquehh  extplvar
save "${mymata}/5220censo.dta", replace							

* import command :
sae data import, datain($mymata/5220censo.dta) 										///
	varlist($varlevel $postalfa $alfavars $popwt $area $plinevar $uniquehh extplvar )  		///
	area($area) uniqid($uniquehh) dataout($mymata/5220censo) 	

*---------------------------------------------------------------------------------------------------
	timer clear 10
	timer on    10
	
* UPLOADING eml21: 
use "${dta}5220_TR20_lnskew_NationalModel_Selection_20212023.dta", clear
	keep if censo==0
	merge m:1 $area using "${dta}4000_paraborrar.dta"
	drop if paraborrar==1
	drop paraborrar _merge
	gen todrop= !(inrange($depvar,r(mean)-4*r(sd),r(mean)+4*r(sd)))
	drop if todrop==1		//	34 observations deleted and will not consider in the model 
// 	drop if nogo==1
	keep $varlevel $postalfa $alfavars $popwt $area $plinevar $uniquehh  extplvar
	
* SAE command for censo EB :
	sae sim h3  $varlevel $postalfa  [aw=$popwt], area($area) uniqid($uniquehh) 		///
		mcrep(500) bsrep(0) matin($mymata/5220censo)								///
		indicators(fgt0 fgt1 fgt2) aggids(0) pwcensus($popwt)   					///
		zvar($alfavars) 															///
		seed($rndseed) plinevar(extplvar) lnskew_w  ydump($mymata/5220ydump)	// 0.51188188
		
save "${output}5220_ExtremeStC.dta", replace
*--------------------------------------------------
use  "${output}5220_ExtremeStC.dta", clear
	collapse (mean) avg_fgt0_extplvar [pw=nIndividuals]		
	list , clean		//	.2693596

use  "${output}5220_ExtremeStC.dta", clear
	gen codePD=floor(Unit/100)
	collapse (mean) avg_fgt0_extplvar [pw=nIndividuals]	, by(codePD)
	format avg_fgt0_extplvar %9.6f
	list , clean
 *---------------------------------------------------------------------------------------------------
	timer off  10
	timer list 10	//	
log close
****************************************************************************************************