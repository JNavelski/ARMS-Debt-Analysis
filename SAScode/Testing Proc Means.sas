
/*Macro made up of Class Variables*/
%Let ClassVars=Region FMType ProdType Geo Gender;
/*Macro that counts the number of words in the macro function (SYSFUNC allows you to do this by using countW and the counting the number of words in
the macro variable &ClassVars)..... this macro is a number*/
%Let ClassVarCount=%sysfunc(countW(&ClassVars));
/* This %put function makes the &ClassVarCount macro into a number, as in it will now be used as a number for a 
DO LOOP to recognize how many times the loop needs to turn over */
%put classvar count is : &ClassVarCount;

/*Macro made up of Variables*/
%Let Vars= Kount DTOT ATOT LCTOT ACTOT Value_of_Production Equity Debt_to_asset_ratio Equity_to_asset_ratio Debt_to_equity_ratio Current_Ratio Working_Capital
			WC_to_Gross_Revenues Debt_Service_Ratio Asset_Turnover_Ratio OpExpense_Ratio OpProfit_Margin_Ratio
			TotRate_of_Return_on_Assets TotRate_of_Return_on_Equity Term_Debt_Coverage
			Economic_Cost_to_Output Working_Capital_to_Expense Debt_Repayment1 Debt_Repayment2;

%Macro Macroprocmeans;
	/*Delete the final table if it exists to avoid creating duplicates if you run the program multiple times.*/
	/*NOLIST - supressess output	*/
	PROC DATASETS NOLIST;
		DELETE ARMS_FM_data;
	Run;quit;
	/*Create an empty table to put all the descriptive stats*/
	/*Varchar() - Specifices the character length in each cell*/
	/*decimal(,) - Specifies numeric length and decimal length in each cell*/

	Proc Sql;
		Create Table ARMS_FM_data (year int,ClassCategory Varchar(8),ClassVariable Varchar(20),Statistic Varchar(3),Variable Varchar(50),Amount decimal(23,5));
	Quit;


/* Start of DO LOOP */
	%DO c=1 %To &ClassVarCount;
/*		Makes a New Macro variable that tells the function to scan for the macro variables, 
	assigned within the &ClassVars macro, and to do it "c" times, which is N number of variables. */
		%LET ClassVar=%scan(&ClassVars,&C);
		%put Classvar is :&Classvar;
			Proc means DATA=ARMS noprint;
				By year;
				Class &ClassVar;
				VAR  &Vars;	
				WEIGHT VALLWT0;
				OUTPUT OUT = ARMSby&ClassVar (drop = _type_) 
						Sum= %WriteLists(&Vars,Pre=Sum_)
						Mean= %WriteLists(&Vars,Pre=Avg_)
						Median= %WriteLists(&Vars,Pre=Med_)
						STD = %WriteLists(&Vars,Pre=STD_)
						Var = %WriteLists(&Vars,Pre=Var_)
						P75= %WriteLists(&Vars,Pre=p75_)
						p25= %WriteLists(&Vars,Pre=p25_);
/*				Max(Avg) = Maximum;*/
			RUN;

			Proc Sort data=ARMSby&ClassVar;
				by year &ClassVar;
			Run;
			Proc Transpose 	data=ARMSby&ClassVar
							out=ARMSby&ClassVar._long (rename=(col1=AMOUNT));
				by year &ClassVar;
			Run;

			Proc Sql;
				Create Table ARMSby&ClassVar._long as
					Select 	Year,
							"&ClassVar" as ClassCategory,
							Case &ClassVar
								When '' Then 'AF' /*All farm households*/
								Else &ClassVar 
							End as ClassVariable,
							Case _NAME_
								When '_FREQ_' Then 'Frq'
								Else substr(_NAME_,1,3) 
							End as Statistic,
							Case _NAME_
								When '_FREQ_' Then 'Kount'
								Else substr(_NAME_,5) 
							End as Variable,
							Amount
					From ARMSby&ClassVar._long;

			PROC APPEND 
				Base=ARMS_FM_data 
				Data=ARMSby&ClassVar._long force;
			Run;

			/*			Delete the intermediate datasets that are no longer needed*/
			PROC DATASETS NOLIST;
				DELETE ARMSby&ClassVar ARMSby&ClassVar._long;
			Run;quit;

	%end;
			/*	create columns for the sample size(datapoints) and population estimate(representinghouseholds)*/
			Proc Sql;
				Create Table ARMS_FM_data as
					Select a.year,a.ClassCategory ,a.ClassVariable,a.Statistic ,a.Variable ,a.Amount,b.amount as DataPoints, c.Amount as RepresentingHouseholds
					From (Select * From ARMS_FM_data where Variable not eq 'Kount') a
					Left Join (select * From ARMS_FM_data where Variable eq 'Kount' and Statistic='Frq') b
						on a.Year=b.Year and a.ClassCategory=b.ClassCategory and a.ClassVariable=b.ClassVariable
					Left Join (select * From ARMS_FM_data where Variable eq 'Kount' and Statistic='Sum') c
						on a.Year=c.Year and a.ClassCategory=c.ClassCategory and a.ClassVariable=c.ClassVariable;
			Quit;

%Mend;	
%Macroprocmeans;