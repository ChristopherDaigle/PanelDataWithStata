// Monte Carlo Simulation of Weak Identification in Linear IV model 

clear all

set seed 333 

global nobs = 100
global rep = 500
global endo = 0.5
global strong = 1
global weak = 0.005


program simulate_weak, rclass

/* x1 : Exogeneous regressor 
   x2  = 1 + x1 + `weak'*z1 + `weak'*z2 + v: Endogeneous regressor
   y   = 1 + x1 - x2 + e 
   Due to the endogeneity e and v are correlated where the value of correlation is
   set as `endo'.   */
   

/* x1 : Exogeneous regressor 
   x2  = 1 + x1 + `strong'*z1 + `strong'*z2 + v: Endogeneous regressor
   y   = 1 + x1 - x2 + e 
   Due to the endogeneity e and v are correlated where the value of correlation is
   set as `endo'.   */


   
end

* Simulate (or Run) the program $replication times 


kdensity b_2SLS_strong, name(Beta_hat_strong_iv) title(Beta_hat_strong_iv)
kdensity b_2SLS_weak if b_2SLS_weak >= -2.5 & b_2SLS_weak <= 1, name(Beta_hat_weak_iv) title(Beta_hat_weak_iv)
