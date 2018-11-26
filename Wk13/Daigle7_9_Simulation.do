/*
Chris Daigle
Panel Data
Simulation Exercise Pt2
*/

clear all
cls
set seed 333

// This .do file simulates AR(1) dynamic panel model 
//      y_it = rho* y_i(t-1) + alpha_i + eps_it


global rho = 0.50
global obs_id = 500
global T = 6
global rep = 1000

program simulate_dpd, rclass 

* Generate the individual index 
set obs $obs_id 
generate id = _n 


* Generate the fixed effect of alpha_i 's and errors for initial observations e_i's from N(0,1)
generate alpha rnormal()
generate eps = rnormal() 

* Generate a panel of T observations for each individual 
expand $T 
bysort id: generate time = _n 
xtset id time 
bysort id: generate y = 0.5 * alpha + eps

* Generate the dynamics of panel data model 
generate eps 
bysort id: replace y = $rho * y[_n-1] + alpha + eps if time > 1


// Estimate the model by 
*1) Pooled OLS estimator 
qui reg y L.y
return scalar b_pols 

*2) Fixed effect
qui xtreg 
return scalar 

*3) First difference: OLS for the differenced model 
qui reg 
return scalar 

*4) First difference with IV methods (Andreson-Hsiao Estimtes with IV y_(t-2) 
qui ivreg D.y 
return scalar 

*5) Areallano Bond Methods (Two-step GMM methods)
qui xtabond y , nocons two r



end

simulate_dpd

simulate b_pols = r(b_pols) , rep($rep): simulate_dpd 

