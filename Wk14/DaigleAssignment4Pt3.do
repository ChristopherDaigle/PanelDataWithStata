/*
Chris Daigle
Panel Data
Assignment 4
*/
cls
clear all
cd ~/Git/PanelDataWithStata/data
use mus10data.dta

drop if year02 == 0

/* Question 14 */
replace age = age * 10
reg docvis private chronic female age income, r
/* 0.0222, more */

/* Question 15 */
replace age2 = age * age
reg docvis private chronic female age age2 income, r
margins, dydx(age age2)
dis 2*0.0012516
/* dis -.0839313 +  0.0025032*x ???*/
/* -0.0827, less */

/* Question 16 */
margins, at(age = (30 60) age2 = (900 3600))
dis (4.636753 - 3.775349)
/* 0.8614 */

/* Question 17 */
poisson docvis private chronic female age income, r
margins, at(age = (30 60))
dis 4.448044 - 3.629872
/* 0.8182 */

/* Question 18 */
poisson docvis private chronic female age income i.noreast i.midwest i.south, r

gen xb = _b[_cons] + _b[private] * private + _b[chronic] * chronic + _b[female] * female + _b[age] * age + _b[income] * income
gen MESouth= exp(xb + _b[1.south])
gen MEMidwest = exp(xb + _b[1.midwest])

generate tempLocDiff = MEMidwest - MESouth
qui sum tempLocDiff
scalar manualLocDiff = r(mean)
display "The manually computed locational difference is " manualLocDiff "."
/* 0.6201 */

/* Question 19 */
poisson docvis private chronic female age income noreast midwest south, r
margins, at((means) _all(asobserved) south = 1 midwest = 0 noreast = 0)
margins, at((means) _all(asobserved) south = 0 midwest = 1 noreast = 0)
dis 3.237165 - 2.76136
/* 0.4758 */
