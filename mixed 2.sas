/* 	Two-factor mixed example.  

Instructor is a random effect, method is fixed.  Within each teacher/method combo, we have have n=4 repititions (trials).
So each of the 5 instructors  uses (teaches) each of the 4 methods 4 times.
These are NOT the same data as in the training example in the slides */

DATA training;
INPUT method instructor improvement;
cards;
1 1 54.93
1 2 46.29
1 3 47.14
1 4 39.72
1 5 49.32
1 1 40.33
1 2 56.33
1 3 48.54
1 4 60.89
1 5 50.25
1 1 54.08
1 2 48.51
1 3 52.40
1 4 54.98
1 5 48.96
1 1 45.39
1 2 52.42
1 3 56.59
1 4 44.13
1 5 46.37
2 1 19.07
2 2 30.74
2 3 30.35
2 4 29.85
2 5 30.92
2 1 32.22
2 2 24.23
2 3 32.54
2 4 23.99
2 5 25.04
2 1 27.12
2 2 14.19
2 3 28.28
2 4 24.67
2 5 27.54
2 1 29.18
2 2 35.32
2 3 23.51
2 4 29.06
2 5 25.14
3 1 32.92
3 2 20.99
3 3 28.65
3 4 32.25
3 5 21.21
3 1 29.83
3 2 36.29
3 3 31.35
3 4 26.93
3 5 34.68
3 1 35.59
3 2 27.31
3 3 21.22
3 4 28.29
3 5 36.33
3 1 18.53
3 2 23.54
3 3 31.12
3 4 33.22
3 5 30.59
4 1 27.18
4 2 22.07
4 3 36.81
4 4 28.11
4 5 26.4
4 1 36.45
4 2 29.66
4 3 26.21
4 4 38.15
4 5 43.22
4 1 44.9
4 2 33.57
4 3 25.49
4 4 23.67
4 5 32.52
4 1 29.13
4 2 26.42
4 3 22.8
4 4 45.81
4 5 31.36
;
run;

/* To test the two-factor mixed model with n>1, we can use proc glm with a test statement.  

We will later see that for n=1, we can use proc mixed with a random statement. 
We can also treat it as a block design and use a repeated statement
as well as a multivariate setup.



For glm, we are simply running this as a fixed effects model but 
telling sas what to use as the denominator when testing for the fixed effect.

Recall, method is a fixed factor.  The F that is used is MSA/MSAB or here MSmethod/MSmethod*instructor.
We use the test command to generate our own tests.  The h= command tells SAS what factor we are testing, here
we use "h=method" (which mean square goes in the numerator of the F statistic).  

The e= command tells SAS what the error term is (which mean square goes in
the denominator of the F statistic).  Here that is e=method*instructor.



*/


PROC GLM data=training ;
CLASS method instructor;
MODEL improvement = method instructor method*instructor;
TEST h=method e=method*instructor;
run;

/* Note, the test for method that is produced automatically is different than the one we generated.
The one done automatically uses the MSE in the denominator of the F test.  We used MSAB.

The tests for the interaction and the random factor B effects use the MSE as the denomiator.  Thus, they are the same
as the tests produced automatically by SAS.
*/


