* Week 6

clear all
cd ~/Git/PanelDataWithStata/Wk2

/*
use nlsy3.dta

* Define Covariates macro using global variables
global Covariates hgrade tenure age weeksue nevermarried unmarried black hispanic

**** y_it = x_it * beta + alpha_i +e_it
xtset id year, yearly
* RE model: it is basically a Generalized Least Square (GLS) Estimator
xtreg lincome $Covariates, re  cluster(id)
estimates store RE_GLS

* RE model: can be thought as a Maximum Likelihood Estimator (MLE)
	* Assume e_it is normally distributed and independent over i and t
xtgee lincome $Covariates, family(Gaussian) link(identity) corr(exchangeable) vce(robust)
estimates store RE_GEE

* RE model: as a population average model
xtreg lincome $Covariates, pa robust
estimates store RE_PA

estimates table RE_GLS RE_GEE RE_PA

*/

clear all
webuse union

desc

* Ignoring a nonlinear feature of the model:
	* just stick with the linear RE-GLS estimation
xtreg union age grade i.not_smsa south##c.year, re cluster(id)
estimates store UNION_RE
predict Union_hat_RE

* Nonlinear panel model estimated by logistic regression
xtgee union age grade i.not_smsa south##c.year, family(binomial) link(logit) corr(exchangeable)
estimates store UNION_GEE
predict Union_hat_GEE

estimates table UNION_RE UNION_GEE
