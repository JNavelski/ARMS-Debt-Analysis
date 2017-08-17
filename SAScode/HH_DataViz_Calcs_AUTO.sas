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
%Let BalanceSheetVars=DTOT ATOT;
%Let FinancialRatioVars=FRDADEN FRDANUM;
%Let CategoricalVars=YEAR KOUNT vallwt0 typevp STATE FM_TYPOL_NLR_2011 HHCLS NASS5Reg;
%Let KEEP=KEEP=&IncomeVars &BalanceSheetVars &FinancialRatioVars &CategoricalVars;
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
			Debt_to_asset_ratio = FRDANUM/FRDADEN;
		Run;
	%End;
%Mend;
%GrabArmsData

proc means data=work.arms;
	BY YEAR;
run;

/*proc contents data=ARMS;*/
/*run;*/

Proc Sql;
	Create Table DA_Ratio_By_Comodity_Type as 
		Select ProdType as Product_Type
			,avg(Debt_to_asset_ratio) as AvgD_A
		From ARMS
		Group by ProdType;
			
Quit;

/*proc sort data=work.da_ratio_by_comodity_type;*/
/*	by AvgD_A;*/
/*run;*/
/**/
/*Proc Print data=work.da_ratio_by_comodity_type(pw=green) noobs;*/
/*	Title "Average Debt to Asset Ratio by Comodity Type";*/
/*Run;*/

proc sgplot data=work.da_ratio_by_comodity_type;
	vbar Product_Type / response=AvgD_A
		group = Product_Type;
	Title "Average Debt to Asset Ratio by Comodity Type";
	/*	band x=Product_Type y=avg_D_A;*/
run;

/*proc gmap data=work.da_ratio_by_comodity_type;*/
/*run;*/

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
		Proc Sql;
			Insert into loadWork.HH_data (year,ClassCategory ,ClassVariable,Statistic ,Variable ,Amount,DataPoints, RepresentingHouseholds)
			Select year,ClassCategory ,ClassVariable,Statistic ,Variable ,Amount,DataPoints, RepresentingHouseholds
			From HH_data;
		Quit;
	%End;
%Mend;
%Loaddata