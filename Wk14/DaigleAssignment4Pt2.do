/*
Chris Daigle
Panel Data
Assignment 4
*/
cls
clear all
cd ~/Git/PanelDataWithStata/data
use fpcross.dta


/* Question 7 */
probit fp income grade, r nolog
estat summarize
return list
matrix R = r(stats)
matrix list R

scalar fAtMean = normal(_b[_cons] + _b[income] * R[2,1] + _b[grade] * R[3,1])
dis fAtMean
/* 0.8424 */

/* Question 8 */
dis fAtMean*_b[income]
/* 0.0106 */

/* Question 9 */
margins, dydx(income)
/* 0.0125 */

/* Question 10 */
gen fp_g12 = normal(_b[_cons] + _b[income] * income + _b[grade] * 12)
gen fp_g13 = normal(_b[_cons] + _b[income] * income + _b[grade] * 13)
gen dfp_g13 = fp_g13 - fp_g12
summarize dfp_g13
/* 0.0792  */

/* Question 11 */
logit fp income grade, r nolog
estat summarize
return list
matrix R = r(stats)
matrix list R

scalar fLogit = 1 / (1 + exp((-1)* (_b[_cons] + _b[income] * R[2,1] + _b[grade] * R[3,1])))
dis fLogit
/* 0.8616 */

/* Question 12 */
margins, dydx(income)
/* 0.0127 */
