* Chris Daigle
* Practice Exercise
clear all
use ~/Git/PanelDataWithStata/Wk2/country_happiness.dta

/* Question 1 & 2 */
describe

/* Question 3 */
describe happins

/* Question 4 */
sort happins
list country_name happins in 15

/* Question 5 */
list country_name happins in 1
list country_name happins in 75

/* Question 6 */
*scalar UShap = happins if country_name == "United States"
count if happins > UShap & country_name == "United States"

/* Question 7 */
sum area, detail

/* Question 8 */
sum physicians, detail

/* Question 9 */
sum milspending
sum energyuse_pc

/* Question 10 */
corr happins gdp2002

/* Question 11 */
hist lifesat, bin(7)

/* Question 12 */
twoway scatter happins free_fr_corrupt, mlabel(country_name)
* graph save Graph "/Users/mbair/Git/PanelDataWithStata/Wk2/DaigleGraph.gph"

/* Question 13 */
* Nigeria
