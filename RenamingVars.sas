%Macro RenamingVars();
	Select(FM_TYPOL_NLR_2011);
		/*11-17= farm households, 18= not a family farm*/
		When (11) FMType='RT'; /*'Retirement'gross cash farm income<350k and operator retired*/
		When (12) FMType='NO'; /*'Nonfarm occupation'gross cash farm income<350k and operator primary occupation not farming*/
		When (13) FMType='LO'; /*'Low-sales'gross cash farm income<150k*/
		When (14) FMType='MO'; /*'Moderate-sales'gross cash farm income between 150k and 350k*/
		When (15) FMType='MI'; /*'Midsize'gross cash farm income between 350k and 1m*/
		When (16) FMType='LG'; /*'Large'gross cash farm income between 1m and 5m*/
		When (17) FMType='VL'; /*'Very large'gross cash farm income >5m*/
		When (18) FMType='NF';/*'Nonfamily'*/
	End;

	Select (TypeVP);
		When (2) ProdType='WT';/*Wheat*/
		When (3) ProdType='CR';/*Corn*/
		When (4) ProdType='SY';/*Soybeans*/
		When (8) ProdType='CT';/*Cotton, lint and cottonseed*/
		When (1,5,6,7,9,10) ProdType='OC';/*Other crops*/
		When (11,12,13) ProdType='SC';/*Specialty crops*/
		When (14) ProdType='CC';/*Cattle & calves*/
		When (15) ProdType='HG';/*Hogs*/
		When (17) ProdType='PG';/*Poultry and eggs*/
		When (18) ProdType='DY';/*Dairy*/
		When (19) ProdType='OL';/*Other livestock*/
	End;

	Select(State); 
		When (5) Geo='AR';
		When (6) Geo='CA';
		When (12) Geo='FL';
		When (13) Geo='GA';
		When (17) Geo='IL';
		When (18) Geo='IN';
		When (19) Geo='IA';
		When (20) Geo='KS';
		When (27) Geo='MN';
		When (29) Geo='MO';
		When (31) Geo='NE';
		When (37) Geo='NC';
		When (48) Geo='TX';
		When (53) Geo='WA';
		When (55) Geo='WI';
		When (9,10,21,23,24,25,33,
			  34,36,42,44,47,50,51,54) Geo='R1';/*Residual region 1*/
		When (1,22,28,45) Geo='R2';/*Residual region 2*/
		When (26,39) Geo='R3';/*Residual region 3*/
		When (38,40,46) Geo='R4';/*Residual region 4*/
		When (4,8,16,30,32,35,41,49,56) Geo='R5';/*Residual region 5*/
	End;

	Select(NASS5Reg); 
		When (1) Region='R1';
		When (2) Region='R2';
		When (3) Region='R3';
		When (4) Region='R4';
		When (5) Region='R5';
	End;
%Mend;