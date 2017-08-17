Use FarmIncomeInternal
Go
--Create the data table for the household data viz
Create Table WorkArea.ARMS_FM_data (Year int,ClassCategory Varchar(8),ClassVariable Varchar(2),
									Statistic Varchar(3),Variable Varchar(30),Amount decimal(23,5),
									Datapoints decimal(23,5),RepresentingHouseholds decimal(23,5));



--Create the view that combines the ARMS_FM_data and all the lookup tables
Create View WorkArea.ARMS_FM_Data_View as
	Select	year, 
			a.ClassCategory, e.ClassCategoryName, e.ClassCategoryDescription, e.ClassCategoryNotes,
			a.ClassVariable,d.SortOrder, d.ClassVariableName, d.ClassVariableDescription, d.ClassVariableNotes,
			a.Statistic, c.StatisticName, c.StatisticDescription, c.StatisticNotes, 
			a.Variable, b.VariableName, b.VariableDescription, b.VariableNotes, 
			a.Amount, a.Datapoints, a.RepresentingHouseholds
	From WorkArea.ARMS_FM_data a
	Left Join WorkArea.ARMS_FM_VariableLookup b
		on a.Variable=b.Variable
	Left Join WorkArea.ARMS_FM_StatisticLookup c
		on a.Statistic=c.Statistic
	Left Join WorkArea.ARMS_FM_ClassVariableLookup d
		on a.ClassCategory=d.ClassCategory and a.ClassVariable=d.ClassVariable
	Left Join WorkArea.ARMS_FM_ClassCategoryLookup e
		on a.classCategory=e.ClassCategory
	where not (a.ClassCategory='Geo' and a.ClassVariable in ('R1','R2','R3','R4','R5'));