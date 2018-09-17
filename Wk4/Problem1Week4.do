/*
Christopher Daigle
Assignment 1 - Due Sep 28
*/
clear all
cd ~/Git/PanelDataWithStata/Wk4
use nls_woold_wide.dta

list, noobs

reshape long wage exper manuf inlf, i(id) j(year)

label variable year "year"
label variable wage "wage"
label variable exper "experience"
label variable inlf "in the labor force"
