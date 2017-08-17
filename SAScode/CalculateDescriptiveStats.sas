/*Macro program to calculate the descriptive stats*/
%Macro CalculateDescriptiveStats();
	/*Delete the final table if it exists to avoid creating duplicates if you run the program multiple times.*/
	PROC DATASETS NOLIST;
		DELETE HH_data;
	Run;quit;
	/*Create an empty table to put all the descriptive stats*/
	Proc Sql;
		Create Table HH_data (year int,ClassCategory Varchar(8),ClassVariable Varchar(20),Statistic Varchar(3),Variable Varchar(20),Amount decimal(23,5));
	Quit;
/*	Loop over the class variables and calculate various descriptive stats*/
	%Let ClassVars=FMType ProdType Geo Region;
	%Let ClassVarCount=%sysfunc(countW(&ClassVars));
		%DO c=1 %To &ClassVarCount;
			%LET ClassVar=%scan(&ClassVars,&C);

			Proc means DATA=ARMS noprint;
				BY Year; 
				CLASS &ClassVar;
				VAR kount 
					&IncomeVars
					&BalanceSheetVars;
				WEIGHT VALLWT0;
				OUTPUT OUT = ARMS_&ClassVar (drop = _type_) 
						Sum=	Sum_kount %WriteLists(&IncomeVars,Pre=Sum_) %WriteLists(&BalanceSheetVars,Pre=Sum_) 
						Mean=	Avg_kount %WriteLists(&IncomeVars,Pre=Avg_) %WriteLists(&BalanceSheetVars,Pre=Avg_) 
						median=	Med_kount %WriteLists(&IncomeVars,Pre=Med_) %WriteLists(&BalanceSheetVars,Pre=Med_);
			RUN;
			Proc Sort data=ARMS_&ClassVar;
				by year &ClassVar;
			Run;
			Proc Transpose 	data=ARMS_&ClassVar
							out=ARMS_&ClassVar._wide (rename=(col1=AMOUNT));
				by year &ClassVar;
			Run;
			Proc Sql;
				Create Table ARMS_&ClassVar._wide as
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
								When '_FREQ_' Then 'kount'
								Else substr(_NAME_,5) 
							End as Variable,
							Amount
					From ARMS_&ClassVar._wide;

			Quit;
			PROC APPEND 
				Base=HH_data 
				Data=ARMS_&ClassVar._wide force;
			Run;

/*			Delete the intermediate datasets that are no longer needed*/
			PROC DATASETS NOLIST;
				DELETE ARMS_&ClassVar ARMS_&ClassVar._wide ;
			Run;quit;
	%End;
/*	create columns for the sample size(datapoints) and population estimate(representinghouseholds)*/
	Proc Sql;
		Create Table HH_data as
			Select a.year,a.ClassCategory ,a.ClassVariable,a.Statistic ,a.Variable ,a.Amount,b.amount as DataPoints, c.Amount as RepresentingHouseholds
			From (Select * From HH_data where Variable not eq 'kount') a
			Left Join (select * From HH_data where Variable eq 'kount' and Statistic='Frq') b
				on a.Year=b.Year and a.ClassCategory=b.ClassCategory and a.ClassVariable=b.ClassVariable
			Left Join (select * From HH_data where Variable eq 'kount' and Statistic='Sum') c
				on a.Year=c.Year and a.ClassCategory=c.ClassCategory and a.ClassVariable=c.ClassVariable;
	Quit;
%Mend;