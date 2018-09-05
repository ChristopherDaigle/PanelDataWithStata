/* Week 1 Day 1 */
clear all
sysuse auto
list make price mpg trunk headroom foreign in 1/10, noobs
list make price mpg trunk headroom foreign in 1/10
list make price mpg trunk headroom foreign, noobs
list make price mpg trunk headroom foreign
* browse

/* Week 2 Day 1 & 2 */
clear all
sysuse auto

* regress without robust standard errors
regress price mpg trunk headroom
* regress with robust standard errors
regress price mpg trunk headroom, robust

* cls clears the results window
cls
/* Getting started with panel/longitudinal data */
clear all
cd ~/Git/PanelDataWithStata/Wk2
use nlsy3.dta

describe
*browse
* We must set the data by the individuals and the year

xtset id year, yearly
* sort id year

xtsum tincome
* Understanding this: the first is the overall, it is self explanatort
* - I treat each data point as a single piece of data
* The second is between, variation between individuals, it's a cross sections
* of the variation between incomes
* Within is the measurement for each i over time

codebook married

notes: NLSY sample practiced in class on 09/05

/* USING ANOTHER DATA SET */
clear all
cls
use wide.dta

list, noobs

* Change wide format to long format
reshape long inc ue, i(id) j(year)
list, noobs
