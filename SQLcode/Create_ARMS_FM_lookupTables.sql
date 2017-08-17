use FarmIncomeInternal
go

--Insert If statement here

IF OBJECT_ID('WorkArea.ARMS_FM_VariableLookup', 'U')  IS NOT NULL
drop Table WorkArea.ARMS_FM_VariableLookup;

IF OBJECT_ID('WorkArea.ARMS_FM_StatisticLookup','U') IS NOT NULL
drop table WorkArea.ARMS_FM_StatisticLookup;

IF OBJECT_ID('WorkArea.ARMS_FM_ClassVariableLookup','U') IS NOT NULL
drop table WorkArea.ARMS_FM_ClassVariableLookup;

IF OBJECT_ID('WorkArea.ARMS_FM_ClassCategoryLookup','U') IS NOT NULL
drop table WorkArea.ARMS_FM_ClassCategoryLookup;

--Create the lookup tables for WorkArea.HH_data

--Create the variablelookup table
Create Table WorkArea.ARMS_FM_VariableLookup(VariableName Varchar(50),Variable Varchar(30),VariableDescription VarChar(250),VariableNotes VarChar(250));

--populate the HH_VariableLookup table
Insert into WorkArea.ARMS_FM_VariableLookup(VariableName ,Variable ,VariableDescription,VariableNotes)
Values 
('Total Debt','DTOT','Total current & non-current liabilities on Dec. 31st',NULL),
('Total Assets','ATOT','Value of total farm financial assets',NULL),
('Total Equity','Equity','Value of total farm financial equity',NULL),
('Debt-to-asset ratio','Debt_to_asset_ratio','Debt-to-asset ratio','This is a solvency ratio'),
('Equity-to-asset ratio','Equity_to_asset_ratio','Equity-to-asset ratio','This is a solvency ratio'),
('Debt-to-equity ratio','Debt_to_equity_ratio','Debt-to-equity ratio','This is a solvency ratio'),
('Total Current Debt','LCTOT','Total Current Debt',NULL),
('Debt Repayment Capacity at 10%','Debt_Repayment1','Debt Repayment Capacity at 10%',NULL),
('Debt Repayment Capacity at 7.5%','Debt_Repayment2','Debt Repayment Capacity at 7.5%',NULL),
('Total Current Assets','ACTOT','Total Current Assets',NULL),
('Value of Production','Value_of_Production','Value of Production',NULL),
('Current ratio','Current_ratio','Current ratio','This is a liquidity ratio'),
('Working Capital','Working_Capital','Working Capital','This is a liquidity ratio'),
('Working Capital to Gross Revenues Ratio','WC_to_Gross_Revenues','Working Capital to Gross Revenues Ratio','This is a liquidity ratio'),
('Debt Service Ratio','Debt_Service_Ratio','Debt Service Ratio','This is a liquidity ratio'),
('Operating Profit Margin Ratio','OpProfit_Margin_Ratio','Operating Profit Margin Ratio','This is a profitability ratio'),
('Total Rate of Return on Farm Equity','TotRate_of_Return_on_Equity','Total Rate of Return on Farm Equity','This is a profitability ratio'),
('Total Rate of Return on Farm Assets','TotRate_of_Return_on_Assets','Total Rate of Return on Farm Assets','This is a profitability ratio'),
('Asset Turnover Ratio','Asset_Turnover_Ratio','Asset Turnover Ratio','This is an efficiency ratio'),
('Operating Expense Ratio','OpExpense_Ratio','Operating Expense Ratio','This is an efficiency ratio'),
('Term Debt Coverage','Term_Debt_Coverage','Term Debt Coverage',NULL),
('Economic Cost to Output Ratio','Economic_Cost_to_Output','Economic Cost to Output Ratio',NULL),
('Working Capital to Expense Ratio','Working_Capital_to_Expense','Working Capital to Expense Ratio',NULL);

--Create the statistic lookup table
Create Table WorkArea.ARMS_FM_StatisticLookup(StatisticName Varchar(50),Statistic Varchar(3),StatisticDescription VarChar(250),StatisticNotes VarChar(250));

--populate the HH_StatisticLookup table
Insert into WorkArea.ARMS_FM_StatisticLookup(StatisticName,Statistic,StatisticDescription,StatisticNotes)
Values 
('Average','Avg','Average value',null),
('Median','Med','Median value',NULL),
('Total','Sum','Total value',NULL),
('Standard Deviation','STD','Standard Deviation Value',NULL),
('Variance','Var','Variance value',NULL),
('75th Percential','p75','75th Percential value',NULL),
('25th Percential','p25','25th Percential value',NULL);


--Create the ClassVariable lookup table
Create Table WorkArea.ARMS_FM_ClassVariableLookup(SortOrder int,ClassVariableName Varchar(50),ClassCategory Varchar(8),ClassVariable Varchar(2),ClassVariableDescription VarChar(250),ClassVariableNotes VarChar(250));
 
--populate the HH_ClassVariableLookup table
Insert into WorkArea.ARMS_FM_ClassVariableLookup(SortOrder,ClassVariableName,ClassCategory,ClassVariable,ClassVariableDescription)
Values
(101,'All','FMType','AF',null),
(107,'Large','FMType','LG','with gross cash farm income between $1,000,000 and $5,000,000'),
(104,'Low-sales','FMType','LO','with gross cash farm income less than $150,000'),
(106,'Midsize','FMType','MI','with gross cash farm income between $350,000 and $1,000,000'),
(105,'Moderate-sales','FMType','MO','with gross cash farm income between $150,000 and $350,000'),
(103,'Nonfarm Occupation','FMType','NO','with gross cash farm income less than $350,000 and primary farm operator declares occupation as something other than retired or farming'),
(102,'Retirement','FMType','RT','with gross cash farm income less than $350,000 and primary farm operator declares occupation as retired'),
(108,'Very Large','FMType','VL','with gross cash farm income greater than $5,000,000'),
(109,'Nonfamily','FMType','NF',null),
(201,'All','Geo','AF','includes all states except AK and HI'),
(202,'Arkansas','Geo','AR',null),
(203,'California','Geo','CA',null),
(204,'Florida','Geo','FL',null),
(205,'Georgia','Geo','GA',null),
(206,'Iowa','Geo','IA',null),
(207,'Illinois','Geo','IL',null),
(208,'Indiana','Geo','IN',null),
(209,'Kansas','Geo','KS',null),
(210,'Minnesota','Geo','MN',null),
(211,'Missouri','Geo','MO',null),
(212,'North Carolina','Geo','NC',null),
(213,'Nebraska','Geo','NE',null),
(217,'Residual Atlantic','Geo','R1',null),
(218,'Residual South','Geo','R2',null),
(219,'Residual Midwest','Geo','R3',null),
(220,'Residual Plains','Geo','R4',null),
(221,'Residual West','Geo','R5',null),
(214,'Texas','Geo','TX',null),
(215,'Washington','Geo','WA',null),
(216,'Wisconsin','Geo','WI',null),
(301,'All','ProdType','AF',null),
(308,'Cattle & Calve','ProdType','CC','at least 50 percent of the value of production from cattle and calves'),
(302,'Corn','ProdType','CR','at least 50 percent of the value of production from corn'),
(305,'Cotton','ProdType','CT','at least 50 percent of the value of production from cotton'),
(309,'Dairy','ProdType','DY','at least 50 percent of the value of production from dairy'),
(310,'Hog','ProdType','HG','at least 50 percent of the value of production from hogs'),
(307,'Other Crop','ProdType','OC','at least 50 percent of the value of production from crops, but no particular crop has more than 50 percent'),
(312,'Other Livestock','ProdType','OL','at least 50 percent of the value of production from livestock, but no particular commodity has more than 50 percent'),
(311,'Poultry & Egg','ProdType','PG','at least 50 percent of the value of production from poultry and eggs'),
(306,'Specialty Crop','ProdType','SC','at least 50 percent of the value of production from specialty crops including fruits, nuts, vegetables, melons, greenhouse, and nursery'),
(303,'Soybean','ProdType','SY','at least 50 percent of the value of production from soybeans'),
(304,'Wheat','ProdType','WT','at least 50 percent of the value of production from wheat'),
(401,'All','Region','AF','includes all states except AK and HI'),
(402,'Atlantic','Region','R1','includes CT, DE, KY, MA, MD, ME, NC, NH, NJ, NY, PA, RI, TN, VA, VT, WV'),
(403,'South','Region','R2','includes AL, AR, FL, GA, LA, MS, SC'),
(404,'Midwest','Region','R3','includes IA, IL, IN, MI, MN, MO, OH, WI'),
(405,'Plains','Region','R4','includes KS, ND, NE, OK, SD, TX'),
(406,'West','Region','R5','includes AZ, CA, CO, ID, MT, NM, NV, OR, UT, WA, WY'),
(501,'All','Gender','AF',NULL),
(502,'Male','Gender','Ma','the gender of the farms principle oporator'),
(503,'Female','Gender','Fe','the gender of the farms principle oporator');


--Create the ClassCategory lookup table
Create Table WorkArea.ARMS_FM_ClassCategoryLookup(ClassCategoryName Varchar(50),ClassCategory Varchar(8),ClassCategoryDescription VarChar(250),ClassCategoryNotes VarChar(250));

--populate the HH_ClassCategoryLookup table
Insert into WorkArea.ARMS_FM_ClassCategoryLookup(ClassCategoryName,ClassCategory)
Select distinct		Case ClassCategory
						When 'Geo'		Then 'States'
						When 'Region'	Then 'Regions'
						When 'ProdType' Then 'Commodity Specialty'
						When 'FmType'	Then 'Farm Typology'
						When 'Gender'	Then 'Operator Gender'
						else 'Error'
					End As ClassCategoryName,
			ClassCategory
From WorkArea.ARMS_FM_ClassVariableLookup;