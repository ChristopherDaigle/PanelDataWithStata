* Tyler Terbrusch
* Homework Assignment 2
* Do File - Questions 23-25: Analysis of AKAM91 Dataset
clear all 

use AKAM91.dta
**********

* Question 23: 2SLS Regression

* Creating global macro for control variables: AGEQ AGEQSQ MARRIED 
* Regional dummies: ENOCENT ESOCENT MIDATL MT NEWENG SOATL WNOCENT WSOCENT SMSA; 




**********

* Question 24: Assessing First Stage Regression Results
* 1) Shortcut: postcommand estat 


* 2) Manually compute First-stage F-statistics  
* Create macro for QTR IV's (34 IV's) (QTR* would not run for "test" command)


**********

* Question 25: Assessing Results of Instrumental Validity Test  
* Restore the IV-regress with robust standard errors 

* 1) Shortcut: postcommand estat  


* 2) Manually compute First-stage F-statistics  
* Run Regression of estimated error on IV's and exogenous variables



* F-test on IV's checking for Validity









