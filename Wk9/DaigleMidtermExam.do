/*
Chris Daigle
Panel Data
Midterm 24 Oct 2018
*/

clear all
cd ~/Git/PanelDataWithStata/Midterm
use murder.dta

/* Question 11 */
describe
* Answer: 51

/* Question 12 */
describe
* Answer: 7

/* Question 13 */
sort mrdrte
list state mrdrte
list state in 17
* Answer: CT

/* Question 14 */
sum mrdrte, detail
* Answers: 7.4%. 4.7%

/* Question 15 */
* Submit do file
