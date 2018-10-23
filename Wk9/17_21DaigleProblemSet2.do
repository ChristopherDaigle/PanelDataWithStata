/*
Chris Daigle
Panel Data
Homework 2
17-21
*/

clear all
cd ~/Git/PanelDataWithStata/Wk9
use handguns.dta

/* QUESTION 17 */
gen lVio = log(vio)
gen lMur = log(mur)
gen lRob = log(rob)

reg lVio shall, r
estimates store lnVio

reg lMur shall, r
estimates store lnMur

reg lRob shall, r
estimates store lnRob

estimates table lnVio lnMur lnRob, se
/*
-----------------------------------------------------
    Variable |   lnVio        lnMur        lnRob     
-------------+---------------------------------------
       shall | -.44296458   -.47337245    -.7733207  
             |  .04752832      .048536     .0692623  
       _cons |  6.1349189    1.8975555    4.8730511  
             |  .01930393    .02196062    .02790933  
-----------------------------------------------------
                                         legend: b/se
										 
Respective Rsq:  0.0866, 0.0834, 0.1208

*/

/* QUESTION 18 */
* Answer: significant

/* QUESTION 19 */
reg lVio shall incarc_rate density pop pm1029 avginc, r
estimates store lnVio

reg lMur shall incarc_rate density pop pm1029 avginc, r
estimates store lnMur

reg lRob shall incarc_rate density pop pm1029 avginc, r
estimates store lnRob

estimates table lnVio lnMur lnRob, se
/*
-----------------------------------------------------
    Variable |   lnVio        lnMur        lnRob     
-------------+---------------------------------------
       shall | -.35925366   -.30911962   -.55503445  
             |  .03286292    .03662355    .05004712  
 incarc_rate |  .00186639    .00259001    .00161762  
             |  .00017468    .00016334    .00020154  
     density |  .03108782     .0545724    .12351043  
             |  .01638982    .01389502    .01905669  
         pop |  .04150649     .0400305     .0775622  
             |  .00310188    .00343524    .00552946  
      pm1029 |  .03791489    .11586394    .07580153  
             |  .00987898    .01238357    .01393819  
      avginc |  .02096172   -.04588113    .06367331  
             |   .0056076    .00740598    .00786515  
       _cons |    4.58343   -.17472261    1.9435719  
             |  .22303226    .28610915    .31553183  
-----------------------------------------------------
                                         legend: b/se
Respective Rsq:  0.5459, 0.5541, 0.5593
*/

/* Question 20 */
* Answer: decrease

/* Question 21 */
xtset stateid year, yearly

* Specification 1:
qui reg lMur shall incarc_rate density pop pm1029 avginc, r
estimates store Spec1
* Specification 2:
qui xtreg lMur shall incarc_rate density pop pm1029 avginc, fe vce(cluster stateid)
estimates store Spec2
* Specification 3:
qui xtreg lMur shall incarc_rate density pop pm1029 avginc i.year, fe vce(cluster stateid)
estimates store Spec3

estimates table Spec1 Spec2 Spec3, se
/*
-----------------------------------------------------
    Variable |   Spec1        Spec2        Spec3     
-------------+---------------------------------------
       shall | -.30911962   -.04610303   -.01743589  
             |  .03662355    .03623838    .03889528  
 incarc_rate |  .00259001   -.00033284   -.00010785  
             |  .00016334    .00035835    .00035138  
     density |   .0545724   -.61839789   -.48305309  
             |  .01389502    .21332013    .21918708  
         pop |   .0400305   -.02737177   -.02918315  
             |  .00343524    .02123796    .02092665  
      pm1029 |  .11586394    .04050526    .07004333  
             |  .01238357    .02176583    .02728217  
      avginc | -.04588113     .0267969    .05791779  
             |  .00740598    .01391106    .01627748  
       _cons | -.17472261    1.1995378    .19588593  
             |  .28610915    .56174074    .54648631  
-----------------------------------------------------
                                         legend: b/se
*/
