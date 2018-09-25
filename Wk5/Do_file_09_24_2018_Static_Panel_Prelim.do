clear all
cls
cd ~/Git/PanelDataWithStata/Wk2
///////////////////////STATA EXERCISE on Sep 12th //////////////////////////////
///////////////////////////////////////////////////////////////////////////////
set matsize 5000
set maxvar 32767
* Locate the folder of the data set  

* Load the data set 
use nlsy3.dta

* Forming panel structure by individual (id) and time (year)
xtset id year, yearly 

* Both time-varying, time invariant characteristic covariates
local Covariates_all hgrade tenure age weeksue nevermarried unmarried black hispanic 

* Only time-varying covariates
local Covariates_tv hgrade tenure age weeksue

/*
* Run within-estimator for time-varying covariates assuming Homosked. time varying errors
xtreg lincome `Covariates_tv', fe

* Run within-estimator for time-varying covariates without assuming Homosked. time varying errors
xtreg lincome `Covariates_tv', fe cluster(id)
estimates store FE_cl

* Run fixed-effect estimator for time-varying covariates without assuming Homosked. time varying errors
reg lincome `Covariates_tv' i.(id), cluster(id)
*/

* Run within-estimator for time-varying covariates without assuming Homosked. time varying errors
quietly xtreg lincome `Covariates_tv' if male == 1 & hispanic == 1 & married == 1, fe cluster(id)
estimates store Within_Sub_Cl

* Run fixed-effect estimator for time-varying covariates without assuming Homosked. time varying errors
quietly reg lincome `Covariates_tv' i.(id) if male == 1 & hispanic == 1 & married == 1, cluster(id)
estimates store FE_Sub_Cl

* Run First-Difference estimator for time-varying covariates without assuming Homosked. time varying errors
reg D.(lincome `Covariates_tv') if male == 1 & hispanic == 1 & married == 1, cluster(id) nocons
estimates store FD_Sub_Cl

* Compare the results of all three estimators, but do not show the estimations for Dummies (Fixed effect terms)
estimates table Within_Sub_Cl FE_Sub_Cl FD_Sub_Cl, keep(hgrade) se
