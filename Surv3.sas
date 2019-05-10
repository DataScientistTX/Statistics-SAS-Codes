/* This is code to import a dataset.  To use it, the location of the dataset needs to be changed
to where the dataset you want to import is located. 

The out= command is where we give the dataset the name we will use in SAS.  The name we give it
does not have to be the same as the name that it is saved as.  For example, we could
have a dataset called "data1" and name it "Sasdata" to be used in SAS>

*/

proc import datafile="C:\Documents and Settings\mhersh\My Documents\SM2_2012\Survival\whas100.xls"                                           
out=whasdata                                                                                                                                
DBMS=EXCEL REPLACE;                                                                                                                     
getnames=yes;                                                                                                                           
run;



proc import datafile="E:\SM2_2012\Survival\whas100.xls"                                           
out=whasdata                                                                                                                                
DBMS=EXCEL REPLACE;                                                                                                                     
getnames=yes;                                                                                                                           
run;


/* note, we want the units of the time variable to be in years.  However,
the variable measuring time, lenfol, is in days.  We will create a new dataset
that has a variable measuring time in years.  To do this, we make "years" equal
to the number of days divided by 365.25. 

The set statement is used to modify an existing SAS data set.  */

data whasdata2; 
set whasdata;
 years = lenfol/365.25;
 run;


proc lifetest data=whasdata2 plot=(s) ;
time years*fstat(0);
strata gender;
run;

