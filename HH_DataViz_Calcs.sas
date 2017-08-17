/*This program calculates the data for the farm household tableau data visualization*/

/*Location where you cloned the git repository(always clone the reusable-code repository as well!)*/
%Let GitLocation=C:\Users\joseph.navelski\Desktop\;
%Let GrabArmsData=Yes;
%Let RunCalculations=Yes;
%Let LoadData=Yes;

%Include "&GitLocation.Reusable-code\SAScode\Libname.SAS";
%Include "&GitLocation.Household-Data-Viz\SAScode\RenamingVars.sas";

/*Read in just the needed ARMS data*/
%Let IncomeVars=tothhi farmhhi totofi earned unearned;
%Let BalanceSheetVars=hhnw fasst fdebt nfasst nfdebt;
%Let CategoricalVars=YEAR KOUNT vallwt0 typevp STATE FM_TYPOL_NLR_2011 HHCLS NASS5Reg;
%Let KEEP=KEEP=&IncomeVars &BalanceSheetVars &CategoricalVars;
%Let Where=WHERE=(HHCLS = 1);
%macro GrabArmsData();
	%if %Upcase(&GrabArmsData)=YES %Then %Do;
		DATA ARMS (&Where);
			length FMType $ 18. ProdType $ 15. GEO $ 17.  Region $ 8.;
			SET	ARMS.ar11fbhh (&KEEP)
				ARMS.ar12fbhh (&KEEP)
			   	ARMS.ar13fbhh (&KEEP)
			   	ARMS.ar14fbhh (&KEEP)
			   	ARMS.ar15fbhh (&KEEP);
			%RenamingVars
		Run;
	%End;
%Mend;
%GrabArmsData

/*Macro program that actually calculates the Descriptive stats for ARMS HH data*/
%Include "&GitLocation.Household-Data-Viz\SAScode\CalculateDescriptiveStats.sas";
%Macro RunCalculations();
		%if %Upcase(&GrabArmsData)=YES %Then %Do;
			%CalculateDescriptiveStats
		%End;
%Mend;
%RunCalculations

/*Load to Database*/
%Macro Loaddata();
	%if %Upcase(&LoadData)=YES %Then %Do;
/*		first, clear out the old data so you don't get duplicates*/
		proc datasets lib=WorkArea NOLIST;
	  		append base=HH_data_temp data=HH_data(obs=0);
	  		exchange HH_data = HH_data_temp;
	  		delete HH_data_temp;
		run;quit; 
/*			Second, Insert all of the data*/
/*		Proc Sql;*/
/*			Insert into loadWork.HH_data (year,ClassCategory ,ClassVariable,Statistic ,Variable ,Amount,DataPoints, RepresentingHouseholds)*/
/*			Select year,ClassCategory ,ClassVariable,Statistic ,Variable ,Amount,DataPoints, RepresentingHouseholds*/
/*			From HH_data;*/
		Quit;
	%End;
%Mend;
%Loaddata

proc sort data=arms
	out=work.ARMS_JOE;
	by year;
run;

proc print data=work.ARMS_JOE;
	Title 'FARM INCOME';
	id year;
	var earned farmhhi fdebt fasst;
	sum _ALL_;
Run;