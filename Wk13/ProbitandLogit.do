/*
Chris Daigle
Panel Data
Week 13
*/

clear all
cls

cd ~/Git/PanelDataWithStata/
use data/accidents.dta
/*
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
*/
/*
qui probit crash tickets traffic i.male, r nolog
estimates store probit_beta
/* Average marginal effect of traffic is the averaged value of each individuals'
marginal effect. Note that this is different from marginal effect at the meant, 
which is single valued marginal effect at the mean of x's*/

/* Formula of average marginal effect after running a probit regression:
(1/n)*sum_{i} [f(b_0 + b_1 x_1i + ... + b_k x_ki) *b_k
This is the average marginal effect of the k-th regressor
*/

* STATA command to get this immediately:
qui probit crash tickets traffic i.male, r nolog
margins, dydx(traffic) post
* The post option saves the result when you type the 
estimates store probit_AME

estimates table probit_beta probit_AME, se

* We want to first compute b_0 + b_1x_1i + ... + b_kx_ki taking out traffic
estimates restore probit_beta
generate xb = _b[_cons] + _b[tickets]*tickets + _b[traffic]*traffic + _b[1.male]*male
generate temp_AME = normalden(xb) * _b[traffic]
qui sum temp_AME // Compute the mean of temp_AME to get AME
return list
scalar Manual_AME = r(mean)
display "The manually computed AME is" Manual_AME*100 "%."

* Now we want to compute an average marginal effect of Male from Female
generate xb_male = _b[_cons] + _b[tickets]*tickets + _b[traffic]*traffic + _b[1.male]
generate xb_female = _b[_cons] + _b[tickets]*tickets + _b[traffic]*traffic
generate temp_AME_gender = normal(xb_male) - normal(xb_female)
qui sum temp_AME_gender // Compute the mean of temp_AME to get AME
scalar Manual_AME_gender = r(mean)
display "The manually computed AME_Gender is " Manual_AME_gender*100 "%."

margins, dydx(1.male)

* Marginal effect at specific point of x?
* We would like to get a marginal effect of tickets when a person has 0 or 1 or 
* 2 tickets
margins, at(tickets= (0 1 2))

*/
clear all
cls

cd ~/Git/PanelDataWithStata/
use data/mus10data.dta

keep if year02 == 1
// Simplify the data set with only year 2003
describe
/*
noreast         byte    %8.0g                 = 1 if Northeast
midwest         byte    %8.0g                 = 1 if Midwest
south           byte    %8.0g                 = 1 if South
*/

global location i.noreast i.midwest
