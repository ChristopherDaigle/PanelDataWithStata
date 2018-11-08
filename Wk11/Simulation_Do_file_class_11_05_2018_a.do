clear all
cls

// This .do file simulates AR(1) dynamic panel model 
//      y_it = rho* y_i(t-1) + alpha_i + eps_it
    
set seed 333

global rho = 0.75
global obs_id = 200 // N = 200
global T = 5

global rep = 100 // Number of simulations

program simulate_dpd, rclass 

* Generate the individual index 
set obs $obs_id 
generate id = _n 

* Generate the fixed effect of alpha_i 's from N(0,1)
generate alpha = rnormal()

* Generate a panel of T observations for each individual 
expand $T 
bysort id: generate time = _n 
xtset id time 
generate eps = rnormal() 
bysort id: generate y = 0 

* Generate the dynamics of panel data model 
bysort id: replace y = $rho * y[_n-1] + alpha + eps if time > 1


// Estimate the model by 
*1) Fixed effect
qui xtreg y L.y, fe cluster(id)
return scalar b_fe = _b[L.y]

*2) First difference: OLS for the differenced model 
qui reg D.(y L.y), cluster(id) 
return scalar b_fd = _b[DL.y]

*3) AH estimates
*1) Use L2.y_it as IV 
qui ivreg D.y (DL.y = L2.y), nocons cluster(id)
return scalar b_ah = _b[DL.y]

*4) AB estimates 

qui drop _all 

end

simulate_dpd

simulate b_fe = r(b_fe) b_fd = r(b_fd) b_ah = r(b_ah), rep($rep): simulate_dpd 
* b_fe and b_fd try to estimate the true value of rho = 0.75 
summarize 
/*
   Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
        b_fe |        100    .5006683    .0309912   .4294272   .5699018
        b_fd |        100    .1513722    .0372557   .0386379    .236982
		b_ah |        100    .8096551    .3805692    .242991   3.762319

*/
