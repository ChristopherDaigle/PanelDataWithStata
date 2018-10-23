/*
Chris Daigle
Panel Data
Homework 2
23-25
*/

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

* Answers: 0.033, 0.047, 0.479

global iv QTR1 QTR2 QTR120 QTR121 QTR122 QTR123 QTR124 QTR125 QTR126 QTR127 QTR128 QTR220 QTR221 QTR222 QTR223 QTR224 QTR225 QTR226 QTR227 QTR228 QTR320 QTR321 QTR322 QTR323 QTR324 QTR325 QTR326 QTR328

/* QUESTION 24 */
estat first

regress EDUC $iv $controls, r
test $iv
* Check that the F-stat is about 0.54 like shown in the previous command (not p-value).
* This number is smaller than 10 which indicates an issue of weak IVs.
* Answers: 0.536, weak

/* QUESTION 25 */
estimates restore TSLS
estat overid
* From the result of overidentification test (J/Sargan Test),
* we read the p-value as 0.178 > 0.05 or 0.10 (size of the tests).
* So, I cannot reject the null hypothesis of exogenous and my data suggests that
* IVs are (endogenous or exogenous).

* Answers: 0.178, insignificant, exogenous

ereturn list
return list
scalar dOver = r(df) // Degrees of Over Identification

* Manually computing First-stage F-stat
predict ehatQtr, residual
regress ehatQtr $iv $controls, r

* F-test on IVs checking for validity
test $iv
* You should check the p-value of your F-stat. One issue is Stata report the
* degree of freedom of F (Chi-sq) dist. as 28, which is incorrect.

* Instead, ask Stata to compute the P-Value based on the correct DoF (27).
display Ftail(dOver, _N, r(F))
