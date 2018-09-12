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
