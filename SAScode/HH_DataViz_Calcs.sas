/*This program calculates the data for the farm household tableau data visualization*/

/*Location where you cloned the git repository(always clone the reusable-code repository as well!)*/

%Let GitLocation=C:\Users\joseph.navelski\Desktop\;
%Let GrabArmsData=Yes;
%Let RunCalculations=Yes;
%Let LoadData=Yes;

%Include "&GitLocation.Reusable-code\SAScode\Libname.SAS";
%Include "&GitLocation.ARMS---Debt-Analysis\SAScode\RenamingVars.sas";

/*Read in just the needed ARMS data*/
%Let IncomeVars=;
%Let BalanceSheetVars=DTOT ATOT ACTOT LCTOT INFI;
%Let FinancialRatioVars=FRDADEN FRDANUM FRATNUM FRATDEN FRCRNUM FRCRDEN FROENUM FROEDEN FROPMNUM FROPMDEN FRROANUM FRROADEN FRROENUM FRROEDEN 
						FRDCNUM FRDCDEN FRECONUM FRECODEN FRWCNUM FRWCDEN;
%Let CategoricalVars=	YEAR Kount vallwt0 typevp STATE FM_TYPOL_NLR_2011 OP_GEN HHCLS NASS5Reg TOTHHI TOTOFI P799 EFINT APRINC R1242 R1243 ANYOPBEG 
						ANYOPEST BELOW1 V45_NFM V45N V45R V45S R1259 R1246 R1227 OP_HISPNW ERSREGN NETW VPRODTOT DRMAXD10 DRMAXD75;

%Let KEEP=KEEP=&IncomeVars &BalanceSheetVars &FinancialRatioVars &CategoricalVars;
%macro GrabArmsData();
	%if %Upcase(&GrabArmsData)=YES %Then %Do;
		DATA ARMS;
			length FMType $ 18. ProdType $ 15. GEO $ 17.  Region $ 8.;
			SET	ARMS.ar11fbhh (&KEEP)
				ARMS.ar12fbhh (&KEEP)
			   	ARMS.ar13fbhh (&KEEP)
			   	ARMS.ar14fbhh (&KEEP)
			   	ARMS.ar15fbhh (&KEEP);
			%RenamingVars;	
		Run;
	%End;
%Mend;
%GrabArmsData


proc contents data=work.arms;
run;


/*This is a macro coded to conduct a preliminary analysis on the Debt to Asset Ratio*/

/*%Include "&GitLocation.ARMS---Debt-Analysis\SAScode\DebtRiskPlots.SAS";*/

/*			Macro Code Used to Calcualte Statistics		;*/

%Include "&GitLocation.ARMS---Debt-Analysis\SAScode\Testing Proc Means.sas";


/*Load to Database*/
%Macro Loaddata();
	%if %Upcase(&LoadData)=YES %Then %Do;
/*		first, clear out the old data so you dont get duplicates*/
		proc datasets lib=WorkArea NOLIST;
	  		append base=ARMS_FM_data_temp data=ARMS_FM_data(obs=0);
	  		exchange ARMS_FM_data = ARMS_FM_data_temp;
	  		delete ARMS_FM_data_temp;
		run;quit; 
/*			Second, Insert all of the data*/
		Proc Sql;
			Insert into WorkArea.ARMS_FM_data (year,ClassCategory ,ClassVariable,Statistic ,Variable ,Amount,DataPoints, RepresentingHouseholds)
			Select year,ClassCategory ,ClassVariable,Statistic ,Variable ,Amount,DataPoints, RepresentingHouseholds
			From ARMS_FM_data;
		Quit;
	%End;
%Mend;
%Loaddata

