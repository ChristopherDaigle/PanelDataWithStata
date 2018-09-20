/* Week 3 */
*cls
/* Getting started with panel/longitudinal data */
clear all
cd ~/Git/PanelDataWithStata/Wk2
use nlsy3.dta

*xtset id year, yearly

xtreg lincome hgrade tenure age weeksue nevermarried unmarried black hispanic male, fe
clear all
use nlsy3.dta
reg lincome hgrade tenure age weeksue nevermarried unmarried black hispanic male, robust

/* Wrap lines without the view option */
xtreg lincome hgrade tenure age weeksue nevermarried ///
unmarried black hispanic male, fe

quietly reg lincome hgrade tenure age weeksue nevermarried ///
unmarried black hispanic male, robust

estimates store POLS

xtset id year, yearly
quietly xtreg lincome hgrade tenure age weeksue nevermarried ///
unmarried black hispanic male, re

estimates store RE

estimates table POLS RE, se p

* Macro
** Two kinds: Global and Local Macro
///LOCAL MACRO
cls
clear all
cd ~/Git/PanelDataWithStata/Wk2
use nlsy3.dta
*can be any name, doesnt need to be covariates
local Covariates hgrade tenure age weeksue nevermarried unmarried black hispanic male


quietly reg lincome `Covariates', robust
estimates store POLS

quietly xtreg lincome `Covariates', re
estimates store RE

estimates table POLS RE

/* Week 3 D2 */

cls
clear all
cd ~/Git/PanelDataWithStata/Wk2
use nlsy3.dta

local Covariates hgrade tenure age weeksue nevermarried unmarried black hispanic male

local Covariates_1 hgrade tenure age weeksue nevermarried unmarried black hispanic

* Linear regression for the male population only
quietly reg lincome `Covariates_1' if male == 1, robust
estimates store POLS_male

quietly reg lincome `Covariates_1' if male == 0, robust
estimates store POLS_female

estimates table POLS_male POLS_female, p se

local Covariates_2 hgrade tenure age weeksue nevermarried unmarried black

* Linear regression for the male and hispanic only
quietly reg lincome `Covariates_2' if male == 1 & hispanic == 1, robust
estimates store POLS_male_hisp
* Linear regression for the female and nonhispanic only
quietly reg lincome `Covariates_2' if male == 0 & hispanic == 0, robust
estimates store POLS_female_hisp

estimates table POLS_male POLS_male_hisp POLS_female POLS_female_hisp, p

* Estimate the RE effect model with covariates
xtreg lincome `Covariates', re
* Overall is like OLS R-squared
* Between R-2 is the variation over individuals 
* Within R-2 measure power of X on explaining Y over time dimensions
* Rho is the intrapanel correlation
estimates store RE

quietly reg lincome `Covariates', robust
estimates store POLS

estimates table POLS RE, se


/* WEEK 4 */
////////////////////////////////////////////////////////////////////////////
* Comparison between Pooled OLS and Random Effect Estimation 
* NOTE: the pooled OLS with robust standard error: Incorrect method because it assumes the data is independent within each panel (idiosyncratic error, alpha, is in each time period and doesnt change)

quietly reg lincome `Covariates', robust
estimates store POLS_robust 

quietly xtreg lincome `Covariates', re 
estimates store RE

estimates table POLS_robust RE, se

////////////////////////////////////////////////////////////////////////////
* Clustered standard error at individual cluster 
/*
quietly reg lincome `Covariates', cluster(id)
estimates store POLS_robust 

quietly xtreg lincome `Covariates', re 
estimates store RE

estimates table POLS_robust RE, se
*/

///// Monte Carlo Simulation of R.E. model for Economic Panel Data
cls
clear all
set seed 333

/*
program simulate_re, rclass

// Specify the number of N (individuals) in panel data set - make a population of 500 members
set obs 500

// Set the index up to 500
generate id = _n

// Generate data set of income_{it} = education_{it} * 10 + alpha_{i} + e_{it}
// education_{it} ~ N(0,1), aplha_{i} ~ N(0,1), e_{it} ~ N(0,1) All follow a normal distribution

generate alpha = rnormal()
* Make 10 observations of each
expand 10
sort id
* assign each individual a time value
bysort id: generate time = _n

generate education = rnormal() // Generate education variable
generate e = rnormal() // Generate error of e
generate income = education * 10 + alpha + e // generate income variable

xtset id time

// Run a pooled OLS estimator for income on education
reg income education, cluster(id)
estimates store POLS

// Run a Random Effect estimator for income on education
xtreg income education, re
estimates store RE

estimates table POLS RE, se p

// Standard effect on RE is smaller than POLS and that indicates that the RE estimator is more efficient than POLS estimator
end
*/

