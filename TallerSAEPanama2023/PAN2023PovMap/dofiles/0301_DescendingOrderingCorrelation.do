* 331_DescendingOrderingCorrelation.do
preserve
qui{
	* Saving vector of absolute value of correlations with dependent variable
	corr `depvar' `rhside'
	cap drop rownames 
	cap drop absvalues
	gen rownames  =""
	gen absvalues = .
	matrix A = r(C)
	matrix list A
	scalar r = rowsof(A)
	matrix B = A[2...`r',1]
	scalar alpha = B[1,1]
	display alpha
	matrix list B
	local grains : rownames B
	local i=1
	foreach x of local grains {
			display "`x'"
			replace rownames = "`x'" in `i'
			scalar alpha = B[`i',1]
			replace absvalues = abs(alpha) in `i'
			local i =`i'+1
	}
	display `i'
	local i=`i'-1
	keep in 1/`i'
	keep rownames absvalues
	
	*Ordering in ascending order (- for descending)
	gsort -absvalues
	
	* Global with ordered list of variables
	local ordervars
	forvalues i = 1(1)`i' {
		local uku = rownames in `i'
		local ordervars `ordervars' `uku'
	}
	global orderednames `ordervars'
restore
}
display "$orderednames"	