/*
Chris Daigle
Panel Data
Homework 2
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

/* QUESTION 23-25 */

clear all 
use AKAM91.dta

/* QUESTION 23 */
global controls AGEQ AGEQSQ MARRIED ENOCENT ESOCENT MIDATL MT NEWENG SOATL WNOCENT WSOCENT SMSA YR20-YR29

ivregress 2sls LWKLYWGE $controls (EDUC = QTR*), robust
estimates store TSLS

/*
Instrumental variables (2SLS) regression          Number of obs   =     20,287
                                                  Wald chi2(22)   =    3598.99
                                                  Prob > chi2     =     0.0000
                                                  R-squared       =     0.1993
                                                  Root MSE        =     .62314

------------------------------------------------------------------------------
             |               Robust
    LWKLYWGE |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
        EDUC |   .0329078    .046503     0.71   0.479    -.0582365     .124052
        AGEQ |   .7281373   .2436568     2.99   0.003     .2505788    1.205696
      AGEQSQ |  -.0081057   .0026803    -3.02   0.002    -.0133591   -.0028524
     MARRIED |    .229956   .0202035    11.38   0.000     .1903579    .2695542
     ENOCENT |    .056168   .0457531     1.23   0.220    -.0335065    .1458426
     ESOCENT |  -.4385438   .1278192    -3.43   0.001    -.6890647   -.1880229
      MIDATL |  -.0046947   .0413368    -0.11   0.910    -.0857133    .0763239
          MT |  -.1597856    .044517    -3.59   0.000    -.2470373    -.072534
      NEWENG |   .0062602   .0497946     0.13   0.900    -.0913354    .1038559
       SOATL |  -.2850775   .1088158    -2.62   0.009    -.4983524   -.0718025
     WNOCENT |  -.1636264   .0470053    -3.48   0.000    -.2557551   -.0714977
     WSOCENT |  -.3442084   .1038618    -3.31   0.001    -.5477738    -.140643
        SMSA |  -.1707901   .0515439    -3.31   0.001    -.2718143   -.0697659
        YR20 |   .0107567    .200223     0.05   0.957    -.3816733    .4031867
        YR21 |  -.0438572   .1828945    -0.24   0.810    -.4023238    .3146094
        YR22 |  -.0940019   .1572613    -0.60   0.550    -.4022285    .2142246
        YR23 |  -.1375326   .1399172    -0.98   0.326    -.4117652       .1367
        YR24 |  -.1536809   .1237526    -1.24   0.214    -.3962316    .0888698
        YR25 |  -.1470972   .1023063    -1.44   0.150    -.3476139    .0534194
        YR26 |  -.1170838   .0828769    -1.41   0.158    -.2795195    .0453519
        YR27 |  -.0919283   .0552381    -1.66   0.096     -.200193    .0163364
        YR28 |  -.0454552   .0354541    -1.28   0.200    -.1149438    .0240335
        YR29 |          0  (omitted)
       _cons |  -11.80571   5.652482    -2.09   0.037    -22.88437   -.7270477
------------------------------------------------------------------------------
Instrumented:  EDUC
Instruments:   AGEQ AGEQSQ MARRIED ENOCENT ESOCENT MIDATL MT NEWENG SOATL
               WNOCENT WSOCENT SMSA YR20 YR21 YR22 YR23 YR24 YR25 YR26 YR27
               YR28 QTR1 QTR2 QTR120 QTR121 QTR122 QTR123 QTR124 QTR125
               QTR126 QTR127 QTR128 QTR220 QTR221 QTR222 QTR223 QTR224
               QTR225 QTR226 QTR227 QTR228 QTR320 QTR321 QTR322 QTR323
               QTR324 QTR325 QTR326 QTR328
*/

global iv QTR1 QTR2 QTR120 QTR121 QTR122 QTR123 QTR124 QTR125 QTR126 QTR127 QTR128 QTR220 QTR221 QTR222 QTR223 QTR224 QTR225 QTR226 QTR227 QTR228 QTR320 QTR321 QTR322 QTR323 QTR324 QTR325 QTR326 QTR328

/* QUESTION 24 */
estat first

regress EDUC $iv $controls, r
test $iv
* Check that the F-stat is about 0.54 like shown in the previous command (not p-value). This number is smaller than 10 which indicates an issue of weak IVs

/* QUESTION 25 */
estimates restore TSLS
estat overid
* From the result of overidentification test (J/Sargan Test), we read the p-value as 0.178 > 0.05 or 0.10 (size of the tests). So, I cannot reject the null hypothesis of exogenous and my data suggests that IVs are (endogenous or exogenous)

ereturn list
return list
scalar dOver = r(df) // Degrees of Over Identification

* Manually computing First-stage F-stat
predict ehatQtr, residual
regress ehatQtr $iv $controls, r

* F-test on IVs checking for validity
test $iv
* You should check the p-value of your F-stat. One issue is Stata report the degree of freedom of F (Chi-sq) dist. as 28, which is incorrect.

* Instead, ask Stata to compute the P-Value based on the correct DoF (27).
display Ftail(dOver, _N, r(F))
