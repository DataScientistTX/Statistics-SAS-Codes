
data apex; input rating officer$ candidate$;
cards;
76  1  1
  65  1  2
  85  1  3
  74  1  4
  59  2  1
  75  2  2
  81  2  3
  67  2  4
  49  3  1
  63  3  2
  61  3  3
  46  3  4
  74  4  1
  71  4  2
  85  4  3
  89  4  4
  66  5  1
  84  5  2
  80  5  3
  79  5  4
  run;



/* To run mixed models, we will mostly use proc mixed.  First, we run the model not taking into account
  the random effects and treat officers as fixed effects.  For a fixed effects model, the null is all the factor 
  level means (officer means) are the same.

 For a random effects model, the null is that 
sigma_squared_mu = 0.  This implies all the factor level means (officer means) are the same and we can
  use the exact same F test and the exact same results for the fixed effects model.
  */

proc mixed data=apex;
class officer;
model rating=officer;
run;





/* Now we will run the model with officer as a random effect in proc mixed.  To do so, we include the random command,
followed by the factor that is random.  Here that is officer, so we include "random officer".  

Note, we only include fixed effects in the model statement for proc mixed.  
Thus we remove officer from the model statement and just leave it as "rating=".  
For this, no p-value is given for testing the null that sigma_squared_mu = 0 

*/

proc mixed data=apex ;
class officer;
model rating=;
random officer;
run;




/*


When using mixed, we also get estimates of the variance terms.  Here sigma_squared is labeled as residual
and sigma_squared_mu is labeled as officer.

We can also generate confidence intervals.  The CL after the mixed statement tells SAS to give the CIs for sigma^2 
and sigma^2 mu.  The alpha=.1 tells SAS to make it a 90% CI. The cl after the model statement tells SAS to produce 
the CI for mu-dot.  Mu-dot is labeled as the intercept. We could use the alpha= option here as well. 



The cl after the random statement tells SAS to produce the CI's for the tau_i.
Here, tau_i measures by how much the mean rating of all potential employees by the ith 
officer (mu_i) differs from the overall rating by all officers (mu_.).  We will learn this in class next.





*/



proc mixed data=apex CL alpha=.1 covtest ;
class officer;
model rating=/alpha=.1 cl;
random officer/ cl ;
run;

