data rep; input  score judge wine;
cards;
 20  1  1
  24  1  2
  28  1  3
  28  1  4
  15  2  1
  18  2  2
  23  2  3
  24  2  4
  18  3  1
  19  3  2
  24  3  3
  23  3  4
  26  4  1
  26  4  2
  30  4  3
  30  4  4
  22  5  1
  24  5  2
  28  5  3
  26  5  4
  19  6  1
  21  6  2
  27  6  3
  25  6  4
  ;
run;

/* We can analze this using the exact same code as for the random blocks model,
which is also the mixed model with n=1 replicates. */


PROC GLM data=rep;
CLASS judge wine;
MODEL score =judge wine judge*wine;
TEST h=wine e=judge*wine;
TEST h=judge e=judge*wine;
run;




PROC mixed data=rep  covtest ;
CLASS judge wine;
MODEL score =wine;
random 	judge ;
run;



proc mixed data=rep ;
CLASS judge wine;
MODEL score =wine;
repeated wine / subject=judge type=cs;
run;


data rep2; input judge wine1 wine2 wine3 wine4;
cards;
1  20 24 28 28
2 15 18 23 24
3 18 19 24 23
4 26 26 30 30
5 22 24 28 26
6 19 21 27 25
;





proc glm data=rep2;
model wine1 wine2 wine3 wine4=;
repeated wine 4 / printe;
run;



