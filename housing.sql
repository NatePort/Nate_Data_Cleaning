SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [HOUSING].[dbo].['Nashville Housing Data for Data$']



  ------------------------------------------------------------------------------------------------------------
  --Cleaning Data set--

  select *
  from [HOUSING].[dbo].[Nashvill_housing]


  ------------------------------------------------------------------------------------------------------------
  --Standardise Data--

   select saledate, 
                   CONVERT (Date,saledate)
  from [HOUSING].[dbo].[Nashvill_housing]


  Update Nashvill_housing 
  Set Saledate = CONVERT (Date,saledate)  --<------------DIDN'T WORK

  ALTER TABLE Nashvill_housing
  Add  Date

    Update Nashvill_housing 
  Set Saledate_Converted = CONVERT (Date,saledate)


     select saledate_CONVERTED, 
                   CONVERT (Date,saledate)
  from [HOUSING].[dbo].[Nashvill_housing]


  ----------------------------------------------------------------------------------------------------------------
  --Populate Property Address Date--


       select *                                  --
  from [HOUSING].[dbo].[Nashvill_housing]           --
  where propertyaddress is null                         --
                                                             --so i found the first set of null values i would like to populate but before i can do that i have to do a self join
															 --in order to tell the table to look at its self and compare columns in an (if) statment!
         select *
  from [HOUSING].[dbo].[Nashvill_housing]               --
 -- where propertyaddress is null                   --
 order by parcelID                               --


  select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress
  from [HOUSING].[dbo].[Nashvill_housing] a
  join [HOUSING].[dbo].[Nashvill_housing] b
       on a.parcelID = b.parcelID
	   and a.[uniqueID] <> b.[uniqueID]
	   where a.propertyaddress is null

	     select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, isnull (a.propertyaddress, b.propertyaddress)
  from [HOUSING].[dbo].[Nashvill_housing] a
  join [HOUSING].[dbo].[Nashvill_housing] b
       on a.parcelID = b.parcelID
	   and a.[uniqueID] <> b.[uniqueID]
	   where a.propertyaddress is null

Update a                                                                                                                                      
set propertyaddress = isnull (a.propertyaddress, b.propertyaddress)                            
  from [HOUSING].[dbo].[Nashvill_housing] a                                                        
  join [HOUSING].[dbo].[Nashvill_housing] b                                                                    
       on a.parcelID = b.parcelID                                                            
	   and a.[uniqueID] <> b.[uniqueID]                                                                       
	     where a.propertyaddress is null                                                            
		                                                                                        

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Breaking down address into individual columns (address, City, State)--

  select propertyaddress
  from [HOUSING].[dbo].[Nashvill_housing]               

  select 
         SUBSTRING (propertyaddress, 1, Charindex (',',Propertyaddress)) as address,
		 Charindex (',',Propertyaddress)                                                  --<-----Didn't want the comma (',') so i was seeying how i could remove it!
		  from [HOUSING].[dbo].[Nashvill_housing]


		    select 
         SUBSTRING (propertyaddress, 1, Charindex (',',Propertyaddress)-1) as address                                       
		  from [HOUSING].[dbo].[Nashvill_housing]
select 
       SUBSTRING (propertyaddress, 1, Charindex (',',Propertyaddress)-1) as address,
	   SUBSTRING (propertyaddress, Charindex (',',Propertyaddress)+1, LEN (Propertyaddress)) as address

	   from [HOUSING].[dbo].[Nashvill_housing]


	     ALTER TABLE Nashvill_housing
  Add propertysplitaddress Nvarchar(260)

    Update Nashvill_housing 
  Set propertysplitaddress = SUBSTRING (propertyaddress, 1, Charindex (',',Propertyaddress)-1)


    ALTER TABLE Nashvill_housing
  Add propertysplitCityt Nvarchar(260)

    Update Nashvill_housing 
  Set propertysplitCityt = SUBSTRING (propertyaddress, Charindex (',',Propertyaddress)+1, LEN (Propertyaddress))

    select *
  from [HOUSING].[dbo].[Nashvill_housing]  



      select owneraddress
  from [HOUSING].[dbo].[Nashvill_housing]



  select
  parsename (replace (owneraddress, ',', '.') ,3)
   ,parsename (replace (owneraddress, ',', '.') ,2)
    ,parsename (replace (owneraddress, ',', '.') ,1)

   from [HOUSING].[dbo].[Nashvill_housing]



   	     ALTER TABLE Nashvill_housing
  Add ownersplitaddress Nvarchar(260)

    Update Nashvill_housing 
  Set ownersplitaddress = parsename (replace (owneraddress, ',', '.') ,3)


    ALTER TABLE Nashvill_housing
  Add ownersplitCityt Nvarchar(260)

    Update Nashvill_housing 
  Set ownersplitCityt = parsename (replace (owneraddress, ',', '.') ,2)


  	     ALTER TABLE Nashvill_housing
  Add ownersplitstate Nvarchar(260)

    Update Nashvill_housing 
  Set ownersplitstate = parsename (replace (owneraddress, ',', '.') ,1)


  ------------------------------------------------------------------------------------------------------------------------------------
  --change y and n to yes and no "sold as vacant " field--

  select distinct (soldasvacant), count (soldasvacant)
     from [HOUSING].[dbo].[Nashvill_housing]
	 group by soldasvacant
	 order by 2
	

	 select * 
	    from [HOUSING].[dbo].[Nashvill_housing]




select SoldAsVacant 
       , case when SoldAsVacant  = 'Y' then 'Yes'  
	          when SoldAsVacant = 'N' then 'No'
			  else soldasvacant
			  END
from [HOUSING].[dbo].[Nashvill_housing]

Update nashvill_housing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'  
	                    when SoldAsVacant = 'N' then 'No'
			            else soldasvacant
			            END


------------------------------------------------------------------------------------------------------------------------------------------
--Remove Duplicets--


With Row_NumCTE as (
select *,
		ROW_NUMBER() OVER(PARTITION BY ParcelID,
		                               Propertyaddress,
									   SalePrice,
									   Saledate,
									   LegalReference
									   ORDER BY UniqueID
									   )
									   Row_Num

from [HOUSING].[dbo].[Nashvill_housing]
)
--(DELETE) SIDE NOTE i woulden't normaly delete data especialy this much but because this its
--just a work exercise i want to keep the final product as clean as possibe--
select *
from Row_NumCTE
where row_num > 1
order by PropertyAddress


----------------------------------------------------------------------------------------------------------------------------------------
--Delete Unused Columns--

--Agaim i would never do this to any data set unless told other --
--wise but for the purpose of showing a polished final result i will--


select *
from [HOUSING].[dbo].[Nashvill_housing]

alter table [HOUSING].[dbo].[Nashvill_housing]
drop column owneraddress, taxdistrict, propertyaddress

alter table [HOUSING].[dbo].[Nashvill_housing]
drop column	Saledate