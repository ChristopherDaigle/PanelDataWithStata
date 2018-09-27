clear all 
cls
set matsize 5000
set maxvar 32767

///////////////////////STATA EXERCISE on Sep 26th //////////////////////////////
///////////////////////////////////////////////////////////////////////////////
* Locate the folder of the data set  
cd ~/Git/PanelDataWithStata/Wk2

* Load the data set 

*  cd P:\\Econ_Panel_Data
use nlsy3.dta

* Forming panel structure by individual (id) and time (year)
xtset id year, yearly 

* Both time-varying, time-invariant charatersitic covariates
local Covariates_all hgrade tenure age weeksue nevermarried unmarried black hispanic 

* Just time-varying covariates
local Covariates_tv hgrade tenure age weeksue nevermarried unmarried 

/////////////// For male and hispanic samples only ///////////////////////


* 1) Run Within-Estimator for time-varying covariates WITH 
* assuming Homoscedastic time-varying errors 
qui xtreg lincome `Covariates_tv' if male == 1 & hispanic == 1, fe
estimates store Within_Homo

* 2) Run Within-Estimator for time-varying covariates WITHOUT assuming 
* Homoscedastic time-varying errors 
qui xtreg lincome `Covariates_tv' if male == 1 & hispanic == 1, fe cluster(id)
estimates store Within_Hetero

* 3) Run Random-Effect Estimator for time-varying covariates WITHOUT 
* assuming Homoscedastic time-varying errors
qui xtreg lincome `Covariates_tv' if male == 1 & hispanic == 1, re cluster(id)
estimates store RE_Hetero

* 4) Run Fixed-Effect Estimator for time-varying covariates WITH 
* assuming Heteroscedastic time-varying errors 
qui reg lincome `Covariates_tv' i.(id) if male == 1 & hispanic == 1, cluster(id)
*  Interested in mathematical derivation
estimates store FE_Hetero

* 5) Run First-Differenced Estimator for time-varying covariates WITHOUT
* assuming Homoscedastic time-varying errors 
qui reg D.(lincome `Covariates_tv') if male == 1 & hispanic == 1, nocons cluster(id)
estimates store FD_Hetero

** Collect the results at the table 
estimates table RE_Hetero Within_Hetero FE_Hetero FD_Hetero, se drop(i.(id))

* 6) Run Fixed-Effect Estimator plus time dummies for time-varying covariates WITHOUT 
* assuming Homoscedastic time-varying errors 

qui reg lincome `Covariates_tv' i.(id) i.(year) if male == 1 & hispanic == 1, cluster(id)
* Diff-in-Diff regression
qui xtreg lincome `Covariates_tv' i.(year) if male == 1 & hispanic == 1, fe cluster(id)

* Run a Hausman test of checking assumption H_0: E[alpha | X] = 0 (RE)
qui xtreg lincome `Covariates_tv' if male == 1 & hispanic == 1, re
estimates store RE_Homo
* Hausman test only requires Homoscedastic assumption, so we should not have clustering
* option even though that's not correct ...
* Always perform Hausman Test with FE and RE result
hausman Within_Homo RE_Homo, sigmamore
* And the result says we reject/cannot reject the H_0
* If P-level is less than 5%, we must reject the null-hypothesis
* If P-level is greater than 5%, we fail to reject the null-hypothesis
* THIS RESULT SAYS WE MUST REJECT

* Since the data says random effect assumption is incorrect, we must fe/within/fd estimator

* Run a Mundlak Regression to check H_0: E[alpha | X] = 0
reg lincome `Covariates_tv', cluster(id)

local Covariatesm_tv hgradem tenurem agem weeksuem nevermarriedm unmarriedm

foreach var of varlist `Covariates_tv' {

bysort id: egen double `var'm = mean(`var')

}

* Run a Mundlak Regression
reg lincome `Covariates_tv' `Covariatesm_tv', cluster(id)
test `Covariatesm_tv'
* Reject if p-value is small, which it is
