///// Monte Carlo Simulation of R.E. model for Economic Panel Data
cls
clear all
set seed 333


program simulate_re, rclass

drop _all

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
qui reg income education, cluster(id)
*estimates store POLS
return scalar beta_pols = _b[education]

// Run a Random Effect estimator for income on education
qui xtreg income education, re
*estimates store RE
return scalar beta_re = _b[education]

*estimates table POLS RE, se p

// Standard effect on RE is smaller than POLS and that indicates that the RE estimator is more efficient than POLS estimator
end

simulate_re
return list

* Simulate (or Run) 500 times
simulate beta_pols = r(beta_pols) beta_re = r(beta_re), reps(500): simulate_re

twoway kdensity beta_pols || kdensity beta_re
