proc means data=work.arms;
/*	var Debt_to_asset_ratio;*/
run;

proc freq data=work.arms;
	tables Debt_to_asset_ratio;
run;
/*Histogram of Debt-to_Asset Ratio*/
proc sgplot data=work.arms;
	histogram Debt_to_asset_ratio;
Run;

proc sgplot data=work.arms;
	scatter y=debt_to_asset_ratio x=TOTHHI / jitter;
Run;

/*----- Data Viz code to Calculate Debt to Asset Ratio by Geographic Location -----*/
Proc Sql;
	Create Table D_A_x_Region as
		Select Region,avg(Debt_to_asset_ratio) as AvgD_A
		From ARMS
		Group by Region
		Order by Region;

Quit;

proc sgplot data=work.D_A_x_Region;
	Hbar Region / Response=AvgD_A stat=percent barwidth=.5 transparency=.6 datalabel
	datalabelattrs=(family='Times' size=12pt color=black weight=Bold)
	fillattrs=(Color=Aqua) filltype=gradient dataskin=gloss
	baseline=0.0 baselineattrs=(color=red);
/*	categoryorder=respdesc; /* can also use the following vv */
/*	xaxis discreteorder=data;*/
/*	yaxis display=none;*/
	Title "Debt-to-Asset Ratio by Region";
run;

/*----- Data Viz process to calculate Debt-to-Asset Ratio by Product Type ----- */
Proc Sql;
	Create Table D_A_x_ProdType as
		Select ProdType,avg(Debt_to_asset_ratio) as AvgD_A
		From ARMS
		Group by ProdType
		Order by AvgD_A DESC;

Quit;

/*Proc Sort data=work.D_A_x_ProdType;*/
/*	by AvgD_A;*/
/*Run;*/

proc sgplot data=work.D_A_x_ProdType;
	Vbar ProdType / Response=AvgD_A stat=percent barwidth=.5 transparency=.6 datalabel
	datalabelattrs=(family='Times' size=12pt color=black weight=Bold)
	fillattrs=(Color=Aqua) filltype=gradient dataskin=gloss
	baseline=0.0 baselineattrs=(color=red)
	categoryorder=respdesc; /* can also use the following vv */
/*	xaxis discreteorder=data;*/
	yaxis display=none;
	Title "Debt-to-Asset Ratio by Product Type";
run;

/*proc sgplot data=work.D_A_x_ProdType;*/
/*	where Sum_All = sum(AvgD_A);*/
/*	hbar AvgD_A / response=Sum_All group=ProdType stat=percent barwidth=.5 transparency=.5 datalabel;*/
/*	Title "Debt-to-Asset Ratio by Product Type";*/
/*run;*/

/*----- Data Viz code to Calculate Debt-to-Asset Ratio by Farm Type -----*/
Proc Sql;
	Create Table D_A_x_Farm_Type as
		Select FMType,avg(Debt_to_asset_ratio) as AvgD_A
		From ARMS
		Group by FMType
		Order by FMType;

Quit;

proc sgplot data=work.D_A_x_Farm_Type;
	Hbar FMType / Response=AvgD_A stat=percent barwidth=.5 transparency=.6 datalabel
	datalabelattrs=(family='Times' size=12pt color=black weight=Bold)
	fillattrs=(Color=Aqua) filltype=gradient dataskin=gloss
	baseline=0.0 baselineattrs=(color=red)
	categoryorder=respdesc; /* can also use the following vv 
/*	xaxis discreteorder=data;*/
/*	yaxis display=none;*/
	Title "Debt-to-Asset Ratio by Farm Type";
run;


/*----- Data Viz code to Calculate Debt-to-Asset Ratio by Total HH Income -----*/
Proc Sql;
	Create Table D_A_x_HHInc_HHOff as
		Select TOTHHI, TOTOFI, avg(Debt_to_asset_ratio) as AvgD_A
		From ARMS
		Group by TOTHHI
		Order by TOTHHI;

Quit;

proc sgplot data=work.D_A_x_HHInc_HHOff;
	scatter x=TOTHHI y=AvgD_A / transparency=.6 datalabel
	datalabelattrs=(family='Times' size=12pt color=black weight=Bold);
/*	fillattrs=(Color=Aqua) filltype=gradient dataskin=gloss*/
/*	baseline=0.0 baselineattrs=(color=red)*/
/*	categoryorder=respdesc; /* can also use the following vv */
/*	xaxis discreteorder=data;*/
/*	yaxis display=none;*/
	Title "Debt-to-Asset Ratio by HH Farm Income";
run;

/*----- Data Viz code to Calculate Debt-to-Asset Ratio by Year -----*/
Proc Sql;
	Create Table D_A_x_Year as
		Select Year, avg(Debt_to_asset_ratio) as AvgD_A 
		From ARMS
		Group by year
		Order by year;

Quit;

Proc sgplot data=work.D_A_x_Year;
	vbar year / response=AvgD_A
	 fillattrs=(color=aquamarine) barwidth=.5 transparency=.6 datalabel datalabelattrs=(family='Times' size=12pt color=black weight=Bold)
	filltype=gradient dataskin=gloss
	baseline=0.0 baselineattrs=(color=red);
/*/*	categoryorder=respdesc; /* can also use the following vv */*/
/*	xaxis discreteorder=data;*/
	yaxis display=none;
	Title "Debt-to-Asset Ratio by Year";
run;

Proc Sql;
	Create Table D_A_x_Region_Year as
		Select Year, Region
		From ARMS
		Group by Region;
/*		Order by AvgD_A;*/
Quit;
Run;