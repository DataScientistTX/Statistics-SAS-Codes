data auto; input obs company_sales industry_sales;
cards;
1 20.96  127.3
2 21.40  130.0
3 21.96  132.7
4 21.52  129.4
5  22.39  135.0
6  22.76  137.1
7  23.48  141.2
8  23.66  142.8
9  24.10  145.5
10  24.01  145.3
11 24.54  148.3
12  24.30  146.4
13  25.00  150.2
14  25.64  153.1
15  26.36  157.3
16  26.98  160.7
17  27.52  164.2
18  27.78  165.6
19 28.24  168.7
20  28.78  171.7
21  .    175.3
;
run;

/* We first run ordinary least squares to get residuals to plot*/


proc reg data=auto ;
 model company_sales =industry_sales; 
OUTPUT OUT=results  p=predicted_company_sales r=residuals ;
 run;
quit;




/* To plot the  residuals, we plot the residuals by obs.  Note, we need to have a variable in our data that indexes
the observation number, such as obs, trial number, or subject number.  This is what we plot the residuals by.
 It might help to connect the dots by using the i=join option*/

symbol1 v=dot i=join;
proc gplot data=results;
plot  residuals*obs;
run;

/* To get the Durbin-Watson test statistic, we add the dw command after a "/" in the model statemet.  Note, here
we still need to use a table to determine if the test is significant or not.*/

proc reg data=auto ;
 model company_sales =industry_sales/dw; 
OUTPUT OUT=results  p=predicted_company_sales r=residuals ;
 run;
quit;


/* We can also get the Durbin-Watson test statistic using proc autoreg.  Proc autoreg also allows 
us to get the p-value for the tests for both poitive (rho > 0)  and negative (rho < 0) autocorrelation.

The command "dw=number" states how many orders to calculate D for.  We typically have just been using the first-order
model, but we can test both the first order and second order autocorrelation by using dw=2.
The command dwprob tells SAS to include the p-values,
*/

   	proc autoreg data=auto ;
 model company_sales =industry_sales/ dw = 2 dwprob   ; 
;
 run;
quit; 
/* Note that Pr < DW is the p-value for testing positive autocorrelation (rho > 0) 
 and Pr > DW is the p-value for testing negative (rho < 0) autocorrelation.*/






/* To do remediation, we include the command "nlag=1".  This will produce the  Yule-Walker
estimates of b_0 and b_1, as well as their standard errors and corresponding p-values.  The  
Yule-Walker procedure is very similiar to the Corchran-Orcutt procedure except that it retains
information from the first observation.


*/

	proc autoreg data=auto ;
 model company_sales =industry_sales/ nlag=1  ; 
;
 run;
quit; 

/* We can use other methods by including the command "method=  method_type".  Here, we will use
maximum likelihood by using "method=ml".  
*/

proc autoreg data=auto ;
 model company_sales =industry_sales/ nlag=1  method=ml; 
;
 run;
quit; 


/* Other method types are ITYW and ULS.  You can read about the various methods at the link below.
http://support.sas.com/documentation/cdl/en/etsug/60372/HTML/default/viewer.htm#etsug_autoreg_sect021.htm
*/
