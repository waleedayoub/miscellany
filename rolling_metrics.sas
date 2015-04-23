/* roll_num is the period for which you calculate rolling sums */
%let roll_num = 28
%put &roll_num;

data new;
	set base;
	/*create array with specific number of elements*/
	/*if the array is a _TEMPORARY_ array, the elements are automatically retained*/
	array sum_spend_M[&roll_num] _temporary_;
	array sum_spend_C[&roll_num] _temporary_;

	/*if using a non-temporary array it must be retained:*/
	/*array summed[&roll_num];*/
	/*retain summed;*/

	/*E represents the element of the array to assign a sales value*/
	/*Increment it by one unless it is equal to &roll_num, at which point*/
	/*start over and assign it a value of 1. This causes the oldest period to*/
	/*be replaced by the newest period once &roll_num periods have been read.*/
	if E = &roll_num then E = 1;
	else E + 1;

	/*assign value to proper element of the array*/
	sum_spend_M[E] = spend_M;
	sum_spend_C[E] = spend_C;

	/*start summing once &roll_num values have been read from the data set*/
	if _N_ >= &roll_num then do;
	  roll_spend_M = sum(of sum_spend_M[*]);
	  roll_spend_C = sum(of sum_spend_C[*]);
	  **roll_avg = mean(of summed[*]);
	end;
	
	format roll_spend_M roll_spend_C comma10.2;
run;
