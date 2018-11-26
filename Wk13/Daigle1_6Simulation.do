/*
Chris Daigle
Panel Data
Simulation Exercise Pt1
*/

clear all
cls
set seed 333

// This .do file simulates AR(1) dynamic panel model 
//      y_it = rho* y_i(t-1) + alpha_i + eps_it


global rho = 0.50
global obs_id = 500
global T = 6      // Counting on the zero period, the actual time period will be between 1,...,T-1 periods. 

* Generate the individual index
set obs $obs_id 
generate id = _n 

* Generate the fixed effect of alpha_i 's and errors for initial observations e_i's from N(0,1)
generate alpha = rnormal()
generate e  = rnormal()
bysort id: generate y = 0.5 * alpha + e

* Generate a panel of T observations for each individual 
expand  $T
bysort id: generate time = _n
xtset id time 
* Generate the dynamics of panel data model 
generate eps = rnormal()
bysort id: replace y = $rho * y[_n-1] + alpha + eps if time > 1


// Estimate the model by 
*1) Pooled OLS estimator 
qui reg y L.y, r
estimates store POLS 

*2) Fixed effect
qui xtreg y L.y, fe cluster(id)
estimates store FE

*3) First difference: OLS for the differenced model 
qui reg D.(y L.y), cluster(id) 
estimates store FD_OLS 

*4) First difference with IV methods (Andreson-Hsiao Estimtes with IV y_(t-2) 
qui ivreg D.y (DL.y = L2.y), nocons cluster(id)
estimates store AH
*4) Areallano Bond Methods (Two-step GMM methods)
qui xtabond y, nocons robust
estimates store AB 

*  Display coefficients and standard errors to 4 decimal places
estimates table POLS FE FD_OLS AH AB, b(%7.4f) keep(L.y DL.y) se

/* Question 1 */
/*
----------------------------------------------------------------
    Variable |  POLS       FE      FD_OLS      AH        AB     
-------------+--------------------------------------------------
           y |
         L1. |  0.9144    0.2393                        0.4838  
             |  0.0125    0.0205                        0.1135  
         LD. |                     -0.1649    0.4859            
             |                      0.0208    0.1441            
----------------------------------------------------------------
                                                    legend: b/se

*/

/* Question 2 */
* Answer: AH, AB

clear all
cls
set seed 333

// This .do file simulates AR(1) dynamic panel model 
//      y_it = rho* y_i(t-1) + alpha_i + eps_it


global rho = 0.50
global obs_id = 500
global T = 20      // Couting on the zero period, the actual time period will be betweeb 1,...,T-1 periods. 

* Generate the individual index
set obs $obs_id 
generate id = _n 

* Generate the fixed effect of alpha_i 's and errors for initial observations e_i's from N(0,1)
generate alpha = rnormal()
generate e  = rnormal()
bysort id: generate y = 0.5 * alpha + e

* Generate a panel of T observations for each individual 
expand  $T
bysort id: generate time = _n
xtset id time 
* Generate the dynamics of panel data model 
generate eps = rnormal()
bysort id: replace y = $rho * y[_n-1] + alpha + eps if time > 1


// Estimate the model by 
*1) Pooled OLS estimator 
qui reg y L.y, r
estimates store POLS 
*2) Fixed effect
qui xtreg y L.y, fe cluster(id)
estimates store FE
*3) First difference: OLS for the differenced model 
qui reg D.(y L.y), cluster(id) 
estimates store FD_OLS 
*4) First difference with IV methods (Andreson-Hsiao Estimtes with IV y_(t-2) 
qui ivreg D.y (DL.y = L2.y), nocons cluster(id)
estimates store AH
*4) Areallano Bond Methods (Two-step GMM methods)
qui xtabond y, nocons robust
estimates store AB

*  Display coefficients and standard errors to 4 decimal places
estimates table POLS FE FD_OLS AH AB, b(%7.4f) keep(L.y DL.y) se

/* Question 3 */
* Answer: More

/* Question 4 */
/*
----------------------------------------------------------------
    Variable |  POLS       FE      FD_OLS      AH        AB     
-------------+--------------------------------------------------
           y |
         L1. |  0.8850    0.4253                        0.4848  
             |  0.0051    0.0095                        0.0154  
         LD. |                     -0.2305    0.4994            
             |                      0.0083    0.0235            
----------------------------------------------------------------
                                                    legend: b/se
*/

/* Question 5 */
* Answer: Fixed Effect
