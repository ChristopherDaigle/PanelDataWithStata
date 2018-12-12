/*
Chris Daigle
Panel Data
Assignment 4
*/

clear all
cd ~/Git/PanelDataWithStata/data
use nqual.dta


/* Question 1 */
xtset id t
xtabond nqual aide, nocons two r
/* Number of Lag Instruments: 6 */

/* Question 2 */
/* .898422   .0046258
  .1104722   .0151279 */

/* Question 3 */
ivreg D.(nqual aide) (DL.nqual = L2.nqual), nocons cluster(id)
/* 0.8960 */

/* Question 4 */
xtabond nqual aide, nocons maxldep(2) two r
* 0.8986 */

/* Question 5 */
xtdpd nqual L.nqual aide, twostep vce(robust) nocons dgmmiv(nqual aide, lagrange(2 3))
* 0.8986 */
