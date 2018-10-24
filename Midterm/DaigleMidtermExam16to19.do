/*
Chris Daigle
Panel Data
Midterm 24 Oct 2018
*/

clear all
cd ~/Git/PanelDataWithStata/Midterm
use nlswork4.dta
xtset idcode year, yearly

/* Question 16 */
xtreg ln_wage age msp ttl_exp, re
estimates store RE
* Answer: 0.001

/* Question 17 */
xtreg ln_wage age msp ttl_exp, fe
estimates store FE
* Answer:  -0.005

/* Question 18 */
reg D.(ln_wage age msp ttl_exp), nocons
estimates store FD

estimates table FE FD, se stats(r2)
* Answer: larger

/* Question 19 */
hausman FE RE, sigmamore
* Reject the null - the null fails to hold that there is not a systemic difference
* based on the idiosyncratic error (alphi_{i}) being endogenous, P-value is 0

* Answers: isn't, exogenous, 0.0000, can
