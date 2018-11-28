/*
Chris Daigle
Panel Data
Simulation Exercise Pt2
*/

/* Question 7 */
/* Now, repeat the simulation in Question 1, 1000 times and calculate the finite
sample bias, standard error (se) and root mean squared error (rmse) of each
estimator. Let rho with hat on top subscript left parenthesis r right
parenthesis end subscript be the estimate for the r-th replication, then the
finite sample bias, standard error and root mean squared error are computed as
follows: */

clear all
cls
set seed 333

// This .do file simulates AR(1) dynamic panel model 
//      y_it = rho* y_i(t-1) + alpha_i + eps_it


global rho = 0.5
global obs_id = 500 
global T = 7
global rep = 1000

program simulate_dpd, rclass 

* Generate the individual index 
set obs $obs_id 
generate id = _n

* Generate the fixed effect of alpha_i 's and errors for initial observations e_i's from N(0,1)
generate alpha = rnormal()
generate e = rnormal() 

* Generate a panel of T observations for each individual 
expand $T 
bysort id: generate time = _n - 1
xtset id time 
bysort id: generate y = 0.5 * alpha + e

* Generate the dynamics of panel data model 
generate eps = rnormal()
bysort id: replace y = $rho * y[_n-1] + alpha + eps if time > 0
drop if time == 0

// Estimate the model by 
*1) Pooled OLS estimator 
qui reg y L.y, cluster(id)
return scalar b_pols = _b[L.y]
*2) Fixed effect
qui xtreg y L.y, fe cluster(id)
return scalar  b_fe = _b[L.y]
*3) First difference: OLS for the differenced model 
qui reg D.(y L.y), nocons cluster(id)
return scalar b_fd = _b[DL.y]
*4) First difference with IV methods (Andreson-Hsiao Estimtes with IV y_(t-2) 
qui ivreg D.y (DL.y = L2.y), nocons cluster(id)
return scalar b_ah = _b[DL.y]
*5) Areallano Bond Methods (Two-step GMM methods)
qui xtabond y, nocons two r
return scalar b_ab = _b[L.y]

qui drop _all 

end

simulate_dpd

simulate b_pols = r(b_pols) b_fe = r(b_fe) b_fd = r(b_fd) b_ah = r(b_ah) b_ab = r(b_ab), rep($rep): simulate_dpd

summarize

/*
    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
      b_pols |      1,000    .8968111    .0107359   .8627055   .9283356
        b_fe |      1,000    .1907395    .0218731   .1130948   .2522013
        b_fd |      1,000   -.2287472    .0202032  -.2967897  -.1595695
        b_ah |      1,000    .5012026    .1026346   .2000815   .8812708
        b_ab |      1,000    .4798724    .0880996   .2117248   .8116813
*/

/* Question 7 */
summarize b_fe
gen mean_fe = r(mean)
gen bias_fe = mean_fe - $rho
gen error_fe_sq = (b_fe - mean_fe)^2
summarize error_fe_sq
gen se_fe = (r(mean))^(1/2)
gen rmse_fe = (bias_fe^2 + se_fe^2)^(1/2)

summarize b_fd
gen mean_fd = r(mean)
gen bias_fd = mean_fd - $rho
gen error_fd_sq = (b_fd - mean_fd)^2
summarize error_fd_sq
gen se_fd = (r(mean))^(1/2)
gen rmse_fd = (bias_fd^2 + se_fd^2)^(1/2)

summarize b_ah
gen mean_ah = r(mean)
gen bias_ah = mean_ah - $rho
gen error_ah_sq = (b_ah - mean_ah)^2
summarize error_ah_sq
gen se_ah = (r(mean))^(1/2)
gen rmse_ah = (bias_ah^2 + se_ah^2)^(1/2)

summarize b_ab
gen mean_ab = r(mean)
gen bias_ab = mean_ab - $rho
gen error_ab_sq = (b_ab - mean_ab)^2
summarize error_ab_sq
gen se_ab = (r(mean))^(1/2)
gen rmse_ab = (bias_ab^2 + se_ab^2)^(1/2)

dis bias_fe, bias_fd, bias_ah, bias_ab
dis se_fe, se_fd, se_ah, se_ab
dis rmse_fe, rmse_fd, rmse_ah, rmse_ab

/*

bias_fe, bias_fd, bias_ah, bias_ab
-0.30926049, -0.72874725, 0.00120258, -0.02012765

se_fe, se_fd, se_ah, se_ab
0.02186212, 0.02019305, 0.10258329, 0.08805554

rmse_fe, rmse_fd, rmse_ah, rmse_ab
0.31003225, 0.72902697, 0.10259034, 0.09032664


/* Question 8 */
/* Based on the numerical results in the previous question , we can conclude the
following theoretical results of the following dynamic panel models:
The Areallano Bond (AB) estimator uses more IVs than Anderson-Hsiao (AH)
estimator, so the AB method has a ___ standard error, but the cost of using more
IVs turns out to produce ___ bias.
Amswers: smaller, more
