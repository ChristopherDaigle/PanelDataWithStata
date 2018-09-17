clear 
cls
///////////////////////STATA EXERCISE on Sep 12th //////////////////////////////
///////////////////////////////////////////////////////////////////////////////

* Locate the folder of the data set  
clear all
cd ~/Git/PanelDataWithStata/Wk4

* Load the data set 

use nlsy3.dta

* Forming panel structure by individual (id) and time (year)
xtset id year, yearly 

local Covariates hgrade tenure age weeksue nevermarried unmarried black hispanic 
local Covariates_1 hgrade tenure age weeksue nevermarried unmarried black hispanic 
local Covariates_2 hgrade tenure age weeksue nevermarried unmarried black 

* Linear regression for the male population only 
quietly regress lincome `Covariates_1' if male == 1, robust 
estimates store POLS_male


* Linear regression for the male and hispanic population only 
local Covariates_2 hgrade tenure age weeksue nevermarried unmarried black 
regress lincome `Covariates_2' if male == 1 & hispanic == 1  , robust 
estimates store POLS_male_hispanic

* Linear regression for the female and hispanic population only 
quietly regress lincome `Covariates_1' if male == 0, robust 
estimates store POLS_female

* Linear regression for the female and hispanic population only 
quietly regress lincome `Covariates_1' if male == 0 & hispanic == 1, robust 
estimates store POLS_female_hispanic

* Compare the regression results for different set of (sub) samples 
estimates table POLS_male POLS_male_hispanic POLS_female POLS_female_hispanic

////////////////////////////////////////////////////////////////////////////
* Comparison between Pooled OLS and Random Effect Estimation 

quietly reg lincome `Covariates', robust
estimates store POLS_robust 

quietly xtreg lincome `Covariates', re 
estimates store RE

estimates table POLS_robust RE, se

