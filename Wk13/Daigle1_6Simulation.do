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
global T = 7      // Counting on the zero period, the actual time period will be between 1,...,T-1 periods. 

* Generate the individual index
set obs $obs_id 
generate id = _n 

* Generate the fixed effect of alpha_i 's and errors for initial observations e_i's from N(0,1)
generate alpha = rnormal()
generate e  = rnormal()
bysort id: generate y = 0.5 * alpha + e

* Generate a panel of T observations for each individual 
expand  $T
bysort id: generate time = _n - 1
xtset id time 
* Generate the dynamics of panel data model 
generate eps = rnormal()
bysort id: replace y = $rho * y[_n-1] + alpha + eps if time > 0
drop if time == 0

// Estimate the model by 
*1) Pooled OLS estimator 
qui reg y L.y, cluster(id)
estimates store POLS 
*2) Fixed effect
qui xtreg y L.y, fe cluster(id)
estimates store FE
*3) First difference: OLS for the differenced model 
qui reg D.(y L.y), nocons cluster(id) 
estimates store FD_OLS 
*4) First difference with IV methods (Andreson-Hsiao Estimtes with IV y_(t-2) 
qui ivreg D.y (DL.y = L2.y), nocons cluster(id)
estimates store AH
*4) Areallano Bond Methods (Two-step GMM methods)
qui xtabond y, nocons two r
estimates store AB

*  Display coefficients and standard errors to 4 decimal places
estimates table POLS FE FD_OLS AH AB, b(%7.4f) keep(L.y DL.y) se
/* Question 1 */
/*
----------------------------------------------------------------
    Variable |  POLS       FE      FD_OLS      AH        AB     
-------------+--------------------------------------------------
           y |
         L1. |  0.9045    0.2072                        0.6030  
             |  0.0105    0.0213                        0.0987  
         LD. |                     -0.2196    0.5678            
             |                      0.0183    0.1105            
----------------------------------------------------------------
                                                    legend: b/se
*/

/* Question 2 */
/* Based on the numerical results of question 1, we can conclude the following
theoretical results of the following dynamic panel models: When large N and
small T, _____ methods yield consistent estimators of rho-hat. */
* Answer: Anderson-Hsiao(AH) and Areallano-Bond(AB)

/* Question 3 */
/* Based on the numerical results of question 1, we can conclude the following
theoretical results of the following dynamic panel models: The Arellano-Bond
method is [more/less] efficient than AH method because it uses all available lag
instruments. */
* Answer: More


/* Question 4 */
/*
Repeat the simulation work in Question 1 with T = 20. Fill out the tables below. 
----------------------------------------------------------------
    Variable |  POLS       FE      FD_OLS      AH        AB     
-------------+--------------------------------------------------
           y |
         L1. |  0.8870    0.4141                        0.5027  
             |  0.0068    0.0094                        0.0154  
         LD. |                     -0.2404    0.5161            
             |                      0.0090    0.0237            
----------------------------------------------------------------
                                                    legend: b/se
*/
clear all
cls
set seed 333

// This .do file simulates AR(1) dynamic panel model 
//      y_it = rho* y_i(t-1) + alpha_i + eps_it


global rho = 0.50
global obs_id = 500
global T = 21      // Couting on the zero period, the actual time period will be betweeb 1,...,T-1 periods. 

* Generate the individual index
set obs $obs_id 
generate id = _n

* Generate the fixed effect of alpha_i 's and errors for initial observations e_i's from N(0,1)
generate alpha = rnormal()
generate e  = rnormal()
bysort id: generate y = 0.5 * alpha + e

* Generate a panel of T observations for each individual 
expand  $T
bysort id: generate time = _n - 1
xtset id time 
* Generate the dynamics of panel data model 
generate eps = rnormal()
bysort id: replace y = $rho * y[_n-1] + alpha + eps if time > 0
drop if time == 0


// Estimate the model by 
*1) Pooled OLS estimator 
qui reg y L.y, cluster(id) r
estimates store POLS 
*2) Fixed effect
qui xtreg y L.y, fe cluster(id)
estimates store FE
*3) First difference: OLS for the differenced model 
qui reg D.(y L.y), nocons cluster(id)
estimates store FD_OLS 
*4) First difference with IV methods (Andreson-Hsiao Estimtes with IV y_(t-2) 
qui ivreg D.y (DL.y = L2.y), nocons cluster(id)
estimates store AH
*4) Areallano Bond Methods (Two-step GMM methods)
qui xtabond y, nocons two r
estimates store AB

*  Display coefficients and standard errors to 4 decimal places
estimates table POLS FE FD_OLS AH AB, b(%7.4f) keep(L.y DL.y) se

/* Question 5 */
/* Based on the numerical results of question 1, we can conclude the following
theoretical results of the following dynamic panel models: When the number of
time period  T increases, _____________ method also yields consistent estimators
of  rho with hat on top, which is different from its inconsistency with small T
period. */
* Answer: Fixed Effect
