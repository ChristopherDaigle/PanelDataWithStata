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
global T = 6
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
bysort id: generate time = _n 
xtset id time 
bysort id: generate y = 0.5 * alpha + e

* Generate the dynamics of panel data model 
generate eps = rnormal()
bysort id: replace y = $rho * y[_n-1] + alpha + eps if time > 1

// Estimate the model by 
*1) Pooled OLS estimator 
qui reg y L.y, //cluster(id) r
return scalar b_pols = _b[L.y]
*2) Fixed effect
qui xtreg y L.y, fe cluster(id)
return scalar  b_fe = _b[L.y]
*3) First difference: OLS for the differenced model 
qui reg D.(y L.y), cluster(id)
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
      b_pols |      1,000    .9021763    .0120841   .8533485   .9410971
        b_fe |      1,000    .2450674    .0205401   .1820275   .3096856
        b_fd |      1,000   -.1704858    .0202851  -.2349048  -.0904886
        b_ah |      1,000    .5009628    .1307242   .1065145   .9799218
        b_ab |      1,000    .4571104    .1098145   .0995787   .8836421
*/

/* Question 8 */
/* Based on the numerical results in the previous question , we can conclude the
following theoretical results of the following dynamic panel models:
The Areallano Bond (AB) estimator uses more IVs than Anderson-Hsiao (AH)
estimator, so the AB method has a ___ standard error, but the cost of using more
IVs turns out to produce ___ bias.
Amswers: smaller, more
