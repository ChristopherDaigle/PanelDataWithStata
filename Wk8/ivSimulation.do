clear all /* clear the existing file or variable in the memory */
capture postclose temp
version 9.0

postfile temp beta_iv using iv_estimate, replace
/* declare the variable names (beta_iv) and the filenames (iv_estimate) of the 
	(new) Stata dataset where the results are to be stored */

/* Simple IV-model
	- IV: Z~N(0,1) which is exogenous
	- Endogenous variable X: X = pi * z (pi is something I can control/regressors)
	- y = beta_0 + beta_1 * X + (0.1*X + eps) (creates endogeneity)
*/

local pi = 0.03
/* If pi = 0 the IV is irrelevant */
	
forvalues i = 1(1)2000 { /* Perform the experiment 1000 times */
drop _all
quietly set obs 200 /* Set up the number of observations as 200 */

generate z = rnormal()

/* Generate the endogenous variable */
generate v_x = rnormal()
generate x = `pi' * z + v_x

generate eps = rnormal()
qui replace eps = 0.1*x + eps

/* Generate the ourcome variable from the structural relationship in line 12 */
generate y = 0 + 1*x + eps /* calibrate model with true value */

* IV regression y on x using z as instruments
quietly ivregress 2sls y (x = z)
post temp (_b[x]) /* Post beta_IV and its standard error (se) for my data*/
display "i = `i' "
}

clear
use iv_estimate /* my data contains the result from the computer
				experiments above*/
histogram beta_iv, normal title("sampling distribution of beta_iv when pi = 0.03")


