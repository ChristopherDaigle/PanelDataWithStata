clear
cls

cd "P:\Class_2018_Fall\Econ_Panel_Data"

use mus10data.dta 

keep if year02 == 1
// Simplify the data set with only year 2003. 
describe 
/*
noreast         byte    %8.0g                 = 1 if Northeast
midwest         byte    %8.0g                 = 1 if Midwest
south           byte    %8.0g                 = 1 if South

*/

global location i.noreast i.midwest i.south 
* We want to run Poisson regression of the number of doctor visits
* on the location (where one lives), health insurance status (private/public)
* chronical deases, gender, and income. 
regress docvis $location private chronic female income, robust 
estimates store OLS
poisson docvis $location private chronic female income, robust 
estimates store Poisson 
estimates table OLS Poisson 

* We want to compute the marignal effect of income on the number of
* doctor visit.
* For simplification, let's take out $location 
poisson docvis private chronic female income, robust 
* Compute the mean of covariates of private chronic female income 
qui sum private
scalar m_private = r(mean)

qui sum chronic
scalar m_chronic = r(mean)

qui sum female
scalar m_female = r(mean)

qui sum income
scalar m_income = r(mean)

scalar xb = _b[_cons] + _b[private] * m_private ///
+ _b[chronic] * m_chronic + _b[female] * m_female + _b[income] * m_income

scalar ME_income = exp(xb) * _b[income] 
display ME_income 

* Compute the same quantity using margins 
margins, dydx(income) atmean




 