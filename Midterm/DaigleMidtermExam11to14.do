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
* Note: Since CT and RI are tied at 16 and 17, depending on the ranking system,
* there is either no 17th and both CT and RI are 16 with AK being 18, or CT and 
* RI are both 16 and AK is 17. I emailed you about this so I'm going to stick
* with CT/RI being 17th lowest.

/* Question 14 */
sum mrdrte, detail
* Answers: 7.4%. 4.7%

/* Question 15 */
* Submit do file
