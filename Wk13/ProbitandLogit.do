/*
Chris Daigle
Panel Data
Week 13
*/

clear all
cls

cd ~/Git/PanelDataWithStata/
use data/accidents.dta

describe
sum //,detail
inspect crash

/*We will analyze the ffect of gender, carvalues, number of tickets, and traffic
on the outcome of crash (whether there was an accident in the last year*/

* Logistic Regression: logit y x
logit crash tickets traffic i.male, r nolog
* nolog: Do not show the log-likelihood value
predict crash_hat_logit //Predicted probability of a crash in the data set
count if crash_hat_logit <= 3.52e-09
* Logit coefficients can be interpretted, 'tickets have 4.33 marginal effect'

* Probit Regression: probit y x
probit crash tickets traffic i.male, r nolog
* nolog: Do not show the log-likelihood value
predict crash_hat_probit //Predicted probability of a crash in the data set
/* Note: '516 failures and 13 successes completely determined.' means that we
have predicted 516 'zeroes' and only 13 'ones' */

* Compare the prediction between the two models
scatter crash_hat_probit crash_hat_logit
count if crash_hat_probit <= 3.52e-09

* Marginal effect at the mean: manual command
estat summarize // estat = statistics after you summarize

return list

matrix R = r(stats)
* Save the matrix of statistics after the summarize command
matrix list R

* Using the matrix R, we will compute the marginal effect of tickets and traffic at the mean
local f = normalden(_b[_cons] + _b[tickets] * R[2,1] + _b[traffic] * R[3,1] + _b[1.male] * R[4,1])
*scalar f = normalden(_b[_cons] + _b[tickets] * R[2,1] + _b[traffic] * R[3,1] + _b[1.male] * R[4,1])

* Marginal effect of tickets at the mean
dis `f'*_b[tickets]
*dis f*_b[tickets] // when you use scalar instead of local
* Marginal effect of traffic at the mean
dis `f'*_b[traffic]
*dis f*_b[traffic]

* Marginal effect at the mean: automatic command
margins, dydx(traffic tickets) atmeans

* Marginal effect at the mean for Male: manual command

local xb0 = _b[_cons] + _b[tickets] * R[2,1] + _b[traffic] * R[3,1]
display normal(`xb0' + _b[1.male]) - normal(`xb0')

///Homework: compute manually and automatically the above marginal effects of logit
/// model
