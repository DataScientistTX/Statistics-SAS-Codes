/*SAS can be used to obtain the Kaplan-Meier Estimator of S(t).  

1)  First we create the data file:  For each observation, 
we record the survival time, “t” , and whether that observation was censored, “cen”.  
If an observation is censored, the variable “cen” = 0, otherwise it is 1.


*/


data surv_ex1;
input t cen;
 cards;
6 1
44 1
21 0
14 1
62 1
  ;
 run;


/* 
Next we run proc lifetest on our data file to 
 generate the Kaplan-Meier estimator.

We use the "plot=(s)" command in the first line to tell SAS to create the 
 plot of the survival function.

 The "time" command is where we enter the
 variable names for the time variable (here t) and the variable name for the
censoring variable (here cen).  We enter the value that we give the censored observations
in paraentheses after listing the censoring variable.  We coded censored observations with a 0.
The two variables are listed as a crossproduct. 
 So for here we use "t*cen(0)" after the "time" command. 

*/

 proc lifetest data=surv_ex1 plot=(s) ;
time t*cen(0);
run;




/* To generate 95% pointwise CI's for the KM estimate, we simply add the command “outsurv=filename”
to the first line.  This creates a SAS file with the 95% pointwise CI's for the KM estimate.
Here, we use ci for the name of the file. */

proc lifetest data=surv_ex1 plot=(s) outsurv=ci;
time t*cen(0);
 run;



/* To view this file we simply run proc print 
 and tell SAS what file to print*/
proc print data=ci;
run;

/*
Note, the table now labels the censored observations with a “1” 
even though we labeled them with a “0”
*/


/* 	To generate confidence intervals for different levels, you can use the alpha=“ ”. 
Here we generate 90% confidence intervals byy setting alpha to .1 and name the file that 
is created as ci90.
*/

proc lifetest data=surv_ex1 plot=(s) alpha=.1 outsurv=ci90;
time t*cen(0);
 run;


proc print data=ci90;
run;




/* To calculate and plot an estimate of the hazard function, you can use an "h" in place 
of the "s" and use "plot=(h)".  Note, SAS will only produce the estimated
hazard function if you use the life table method.  To do this, you must inlcude a "method=lt".
*/

proc lifetest data=surv_ex1 plot=(h) method=lt;
time t*cen(0);
run;



/* Below are other examples of KM estimators and their graphs for various situations*/


/* last one censored */


data KM_estimate2; input t cen;
cards;
6 1
44 1
21 0
14 1
62 0
;
run;



proc lifetest data=KM_estimate2 plot=(s) ;
time t*cen(0);
run;


/*  making censored and observed tied*/


data KM_estimate3; input t cen;
cards;
6 1
44 1
14 0
14 1
62 1
;
run;



proc lifetest data=KM_estimate3 plot=(s) ;
time t*cen(0);
run;





/* last two tied censored and noncensored*/


data KM_estimate4; input t cen;
cards;
6 1
44 1
21 0
14 1
62 1
62 0
;
run;



proc lifetest data=KM_estimate4 plot=(s) ;
time t*cen(0);
run;
