/*
Chris Daigle
Panel Data
Week 11
*/

/* clear all
cls

cd ~/Git/PanelDataWithStata/
*use data/xtcrime.dta

// This .do file simulates AR(1) dynamic panel model 
//      y_it = rho* y_i(t-1) x_1it + x_2it  + alpha_i + eps_it
// (x_1it, x_2it) are strongly exogenous to eps_it
set seed 333

global rho = 0.50
global obs_id = 500 // N = 500
global T = 5

global rep = 200 // Number of simulations

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
gen x_1 = rnormal()
gen x_2 = rnormal()
bysort id: generate y = 0 

* Generate the dynamics of panel data model 
bysort id: replace y = $rho * y[_n-1] + x_1 + x_2 + alpha + eps if time > 1


// Estimate the model by 
*1) Fixed effect
qui xtreg y L.y x_1 x_2, fe cluster(id)
return scalar b_fe = _b[L.y]

*2) First difference: OLS for the differenced model 
qui reg D.(y L.y x_1 x_2), cluster(id) 
return scalar b_fd = _b[DL.y]

*3) AH estimates: uses all the past available lags of L2.yit, L3.yit, ... , y_i0
* (Estimates using GMM)
* More IVs than AH estimate -> we expect an efficient estimation
*1) Use L2.y_i(t-2) as IV 
qui ivreg D.y D.x_1 D.x_2 (DL.y = L2.y), nocons cluster(id)
return scalar b_ah = _b[DL.y]

*4) AB estimates 
qui xtabond y x_1 x_2, nocons robust
return scalar b_ab = _b[L.y]
qui drop _all 

end

simulate_dpd

simulate b_fe = r(b_fe) b_fd = r(b_fd) b_ah = r(b_ah) b_ab = r(b_ab), rep($rep): simulate_dpd 
* b_fe and b_fd try to estimate the true value of rho = 0.75 
summarize 
/*
    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
        b_fe |        100    .3449218    .0159863   .2968766   .3753192
        b_fd |        100    .1641096    .0180135   .1214866   .2055021
        b_ah |        100    .5012884    .0672934   .3797333    .654436
        b_ab |        100     .496263    .0684342   .3495813   .6599644
*/

* 1) Both b_fe and b_fd are biased which means the mean of these two estimates
* are different from the true parameter of rho = 0.50.
* 2) Especially, b_fd has a larger bias than b_fe.
* 3) In fact, you can check if you increase the time period from T = 5 to T = 10
* you will see that b_fe will be closer to the true paramater of rho = 0.50
* However, what about b_fd? 
* 4) The last two AH and AB methods correctly estimate (no bias asymptotically),
* no matter T is smaller or large.
* And theoretically, AB estimation uses more IVs than AH estimates, so it is
* supposed to have smaller s.e. than AH.


/*
Chris Daigle
Panel Data
Week 11
*/

*/
/*
clear all
cls

cd ~/Git/PanelDataWithStata/
use data/xtcrime.dta

ivregress 2sls D.(crime legalwage policepc) ///
				(DL.crime = L2.crime), nocons r

* Run AB estimator
xtabond crime legalwage policepc, two nocons r
* the number of IVs is counted by :(T-2) + (T-3) + ... + 1
* = (T-2)(T-1)/2 with T =5, so (T-2)*(T-1) /2 = 6, and add two more exogenous
* variables, so we get 6 + 2 = 8 IVs
* But how many parameters are estimated? 3 !
* That means, this model is over-identified with 8-5 = 5 degrees of freedom
* So, we can test the validity of IVs in AB method!

* To test Sargan, must remove robust
xtabond crime legalwage policepc, two nocons
estat sargan
* According to the Sargan test, the p-value is 45% and larger than 5%,
* so we cannot reject the null of valid IVs (or correctly specified model)

*/
clear all
cls

cd ~/Git/PanelDataWithStata/
*use data/xtcrime.dta

// This .do file simulates AR(1) dynamic panel model 
//      y_it = rho* y_i(t-1) x_1it + x_2it  + alpha_i + eps_it
// (x_1it, x_2it) are strongly exogenous to eps_it
set seed 333

global rho = 0.50
global rho_2 = 0.10
global obs_id = 500 // N = 500
global T = 5

global rep = 200 // Number of simulations

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
gen x_1 = rnormal()
gen x_2 = rnormal()
bysort id: generate y = 0 

* Generate the dynamics of panel data model 
bysort id: replace y = $rho * y[_n-1] + $rho_2 * y[_n-2] + x_1 + x_2 + alpha + eps if time > 2


// Estimate the model by 
*1) Fixed effect
qui xtreg y L.y x_1 x_2, fe cluster(id)
return scalar b_fe = _b[L.y]

*2) First difference: OLS for the differenced model 
qui reg D.(y L.y x_1 x_2), cluster(id) 
return scalar b_fd = _b[DL.y]

*** All the methods below are wrong because it is based on not having rho2
* y = $rho * y[_n-1] + $rho_2 * y[_n-2] + x_1 + x_2 + alpha + eps

*3) AH estimates: uses all the past available lags of L2.yit, L3.yit, ... , y_i0
* (Estimates using GMM)
* More IVs than AH estimate -> we expect an efficient estimation
*1) Use L2.y_i(t-2) as IV 
qui ivreg D.y D.x_1 D.x_2 (DL.y = L2.y), nocons cluster(id)
return scalar b_ah = _b[DL.y]

*4) AB estimates 
qui xtabond y x_1 x_2, nocons two
return scalar b_ab = _b[L.y]
*qui drop _all 


end

simulate_dpd
estat sargan
/*
simulate b_fe = r(b_fe) b_fd = r(b_fd) b_ah = r(b_ah) b_ab = r(b_ab), rep($rep): simulate_dpd 

summarize
/*
    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
        b_fe |        200    .4639793     .022077   .3819777   .5136257
        b_fd |        200    .0840548      .02457   .0210249   .1393986
        b_ah |        200    .1172169    .1225364   -.205351    .511571
        b_ab |        200    .1172169    .1225364   -.205351    .511571
*/
*/
