/*
Chris Daigle
Panel Data
Simulation Exercise
*/

cls
cd ~/Git/PanelDataWithStata/
set seed 333

/* Question 1 */
/* Write a STATA program to investigate the following simple dynamic panel data 
model with N = 500, T = 6, and rho=0.50 */

global rho = 0.50
global obs_id = 500 // N = 500
global T = 6

* i)
gen alpha = rnormal()
gen eps = rnormal()
* ii)
gen y
