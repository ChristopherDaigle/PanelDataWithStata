program define endogeneity
syntax, [end(real .5) piv(real .5) n(integer 100)]

clear

*quietly set seed 111

quietly set obs `n'

tempvar C e v 

// Generating Endogenous Components 

matrix `C'    = (1, `end'\ `end', 1)

capture quietly drawnorm `e' `v', corr(`C')
local rc = _rc

if `rc' {

	display "for the correlation matrix that controls endogeneity:"
	drawnorm `e' `v', corr(`C')
}

// Generating Regressors

quietly generate x1 = rnormal()
quietly generate z1 = rnormal()
quietly generate z2 = rnormal()

// Generating Model

quietly generate x2  = 1 + x1 + `piv'*z1 + `piv'*z2 + `v'
quietly generate y   = 1 + x1 - x2 + `e'

quietly regress y x1 x2, vce(robust)
quietly estimates store regress
quietly ivregress 2sls y x1 (x2 = z1 z2), vce(robust)
quietly estimates store ivregress
quietly ivregress gmm y x1 (x2 = z1 z2), vce(robust)
quietly estimates store gmm
quietly ivregress liml y x1 (x2 = z1 z2), vce(robust)
quietly estimates store liml

display _newline ///
"The True coefficient for x2 is -1, for x1 is 1, and for the constant 1"
estimates table ivregress gmm liml regress
*quietly estimates drop _all
end
