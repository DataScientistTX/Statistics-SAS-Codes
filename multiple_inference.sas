
data stays; input stay age gender;
cards;
10  10 1
14  15 1
20 20 1
26 25 1
30 30 1
35 35 1
31 10 0
36 14 0
42 21 0
46 27 0
51 30 0
57 34 0
;
run;

/* To do a multiple regression, we run the model the same as before, listing both variables in the model statement. */


proc reg data=stays;
model stay=age gender;
run;


proc reg data=stays;
model stay=age;
run;

/* The MSR term is given by the model mean square and the MSE is given by the error mean square.

The overall F statistic is MSR/MSE.  Here the MSR is 1136.55073	and the MSE is 1.17391.  Thus 
F = 1136.55073/1.17391	=  21.52.  Note this F value is given as the model F.  It is the F test
to see if the model has any effect on the mean response.  That is, this is testing if all the Betas
are 0.  

The numerator df are p-1, which here is 2. Note, p is the total number of Betas, which includes the intercept. 
Thus p-1 is the number of predictors.  The denominator df are n-p.  The are 12 subjects, so n-p=12-3=9.

The p-value is < .0001.




/* The t-tests for each Beta are part of the output and	to obtain the CI's of the Betas,
we use the clb command like before. 
*/


proc reg data=stays;
model stay=age gender/ clb alpha = 0.1;
run;


