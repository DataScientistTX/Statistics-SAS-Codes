

/*  random Block effects / two-factor mixed model with n=1.

Note that the random blocks effects model is exactly the same as the two-factor mixed model with n=1.
This is also the same as a repeated model under the assumption of compound symmetry. With a repeated model,
a fixed effect is repeated within a level of a random factor (or random block).  


Recall the training example, where instructor is a random effect and method is fixed effect.   
Within each teacher/method combo, we had n=4 repititions (trials).
So each of the 5 instructors used (taught) each of the 4 methods 4 times (16 courses per instructor).


Now assume that n=1.  Now, we are considereing situations were the instructors would teach each of the 
4 classes only once.   So each of the 5 intructors teaches each of the 4 methods 1 time (4 courses per instructor).

 The instructors are the random factor levels but can also be viewed as 
random blocks.  And, the fixed levels of method are repeated within each block.	The levels of method (fixed) 
were repeated within each radom factor level (random block level), 
that is the methods were repeated within each instructor.  

 
We will create a made up dataset, pretending that n=1, by only using one trial for each method for each instructor.

*/





DATA training2;
INPUT method instructor improvement;
cards;
1 1 54.93
2 1 29.18
3 1 35.59
4 1 29.13
1 2 46.29
2 2 35.32
3 2 27.31
4 2 26.42
1 3 47.14
2 3 23.51
3 3 21.22
4 3 22.8
1 4 39.72
2 4 29.06
3 4 28.29
4 4 45.81
1 5 49.32
2 5 25.14
3 5 36.33
4 5 31.36
;


/*  We can use the same method as before in GLM to test for the fixed effect (here method) but not the
random effects.  Before, we used the "test" command to tell SAS to use the interaction for the denominator
in the F test for the fixed output. We also used the regular output to test for the interaction (method*instructor)
and random (instructor) effects. This used the MSE for the denominator in the F statistic.

However, for n=1, there is no MSE, thus we can't test for interaction or random effects.  But, we can still use the
interaction mean square to test for fixed effects.


To test for the fixed effect method, we use the interaction term in the denominator regardless if our model
has interaction or not.  So regardless if our model has interaction or not, we need to include the interaction 
in the SAS model so we can use the interaction term in the denominator.
 
To test the random effect instructor, we must use the model without interaction but again we need to run the
model with interaction to use it in the denominator when testing the random effect instructor.
*/

PROC GLM data=training2;
CLASS method instructor;
MODEL improvement = method instructor method*instructor;
TEST h=method e=method*instructor;
TEST h=instructor e=method*instructor;
run;


/* 
To use proc mixed, we include the random command.  The random effects go after
the random command and the fixed effect is in the model statement.
Here both instructor and the method*instructor interaction are random.  And note, even though they are part
of the model, random effects do not go in the model statement.


*/


PROC mixed data=training2   ;
CLASS method instructor;
MODEL improvement = method ;
random 	instructor 	method*instructor;
run;

/* For n=1, you may prefer to run the model without interaction*/

PROC mixed data=training2   ;
CLASS method instructor;
MODEL improvement = method ;
random 	instructor ;
run;


/*  This model can also be run with a repeated command.	Again, only the fixed effects go in the model statement.
We then use a "repeated" command followed by the fixed effect that is repeated within the random block 
(or random factor level). After a backslash we use a "subject =" command followed by the block that  
the repeated factor is repeated within.

For this example, methods are repeated within instructors so we use:

repeated method / subject=instructor


We also need to tell what covariance structure we are using.  We have been assuming compound symmetry but 
other structures can be used.  When compound symmetry is used, the repeated model is the same as the mixed random model.
We write "type=cs"

A full list of options can be found at the link below.

http://74.125.47.132/search?q=cache:p4ZeMj-XgiMJ:support.sas.com/documentation/cdl/en/statug/63033/HTML/default/statug_mixed_sect019.htm+typre+cs+un+sas+repeated+options&cd=2&hl=en&ct=clnk&gl=us


Again, this	only gives the test for the fixed effect unless the covtest option is used.
*/



proc mixed data=training2 ;
CLASS method instructor;
MODEL improvement = method ;
repeated method / subject=instructor type=cs;
run;


/* 
To generate the multivariate analysis, we need to recreate our dataset.  Each instructor can be viewed as a block
with 4 methods repeated in that block. Our dataset will now be generated so that we have the scores for each
of the 4 methods for one instructor listed on the same row.

So instead of:
instructor1 method_1_score
instructor1 method_2_score
instructor1 method_3_score
instructor1 method_4_score



We would list it as 
instructor1 method_1_score	method_2_score method_3_score method_4_score*/


data rep; input intructor meth1 meth2 meth3 meth4;
cards;
1  	54.93 29.18	35.59 29.13
2  46.29 35.32 27.31 26.42
3 47.14	23.51 21.22	22.8
4 39.72	29.06 28.29	45.81
5 49.32	25.14 36.33	31.36
;


;
run; 

proc print data=rep; run;

/* When running the multivariate model, we then list the repeated values as the response.  That is 
"meth1 meth2 meth3 meth4="


To tell SAS to treat the repeated values listed in the repsonse as repeated, we use a repeated command 
followed by a name that we make up to denote this factor and the number of levels of this factor.
Here, we use "method 4"


Note, this is a factor we are creating here in this command and should not
be included in a class statement. 

This generates the multivariate analysis as well as the G-G and H-F adjustments for the univariate results.
Printe tells SAS to test for speherecity. When looking at the results, we only need to consider	the tests on the 
orthogonal components.  If this test is significant, then sphericity is violated.      
Then use either the G-G and H-F adjustments for the univariate results or the multivariate results.

Note,if there were other fixed effects which are not repeated within the random block (or random factor level),
they do not need the spericity assumption to be met.  They can simply be tested as is.




*/

proc glm data=rep;
model meth1 meth2 meth3 meth4=;
repeated method 4 / printe;
run;



/* Here, sphericity is not violated	so we can use the univariate results*/




