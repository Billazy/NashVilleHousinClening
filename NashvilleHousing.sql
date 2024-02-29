/*

Cleaning Data in SQL Queries

*/

Select *
From PortfolioProject.dbo.NashvilleHousing

-----------------------------------------------------------------------------------------------

--Standardize Date Format

Select SaleDate, Convert(Date, SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
Set SaleDate = convert(Date,SaleDate)


Alter Table NashvilleHousing
add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = Convert(Date,SaleDate)


Select SaleDateConverted, Convert(Date, SaleDate)
From PortfolioProject.dbo.NashvilleHousing

---------------------------------------------------------------------------------------------------------------------------
--Populate property Address Data

Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID

--Self Join on Table 

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null




Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null


--Mise a jour des valeurs manquandes 
Update a 
SET PropertyAddress =  ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
-- Where PropertyAddress Is Null
-- Order By ParcelID

Select 
SUBSTRING(PropertyAddress, 1, Charindex(',',PropertyAddress) -1) As Address,
SUBSTRING(PropertyAddress,Charindex(',',PropertyAddress) +1, Len(PropertyAddress)) As Address
From PortfolioProject.dbo.NashvilleHousing



--As a Table
Alter Table NashvilleHousing
add PropertySplitAddress nvarchar(255);

-- As a Result
Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, Charindex(',',PropertyAddress) -1)



Alter Table NashvilleHousing
add PropertySplitCity nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress,Charindex(',',PropertyAddress) +1, Len(PropertyAddress))


Select * 
From PortfolioProject.dbo.NashvilleHousing





--------- OwnerAddrees ------------------------------------------------------------------------------------

Select --OwnerAddress
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
From PortfolioProject.dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.NashvilleHousing



Alter Table NashvilleHousing
add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

Alter Table NashvilleHousing
add OwnerSplitCity nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


Alter Table NashvilleHousing
add OwnerSplitState nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select * 
From PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2 --SoldAsVacant



Select SoldAsVacant,
	Case When SoldAsVacant ='Y' Then 'Yes'
		 When SoldAsVacant = 'N' Then 'No'
		 Else SoldasVacant
	End
From PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant =
	Case When SoldAsVacant ='Y' Then 'Yes'
		 When SoldAsVacant = 'N' Then 'No'
		 Else SoldasVacant
	End



-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From PortfolioProject.dbo.NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

-----------------Supression de tout les doublons --------------------------------------
-- Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From PortfolioProject.dbo.NashvilleHousing
)
--Select *
DELETE
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


--------------------------------------------------------------------------------------------------

-- Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From PortfolioProject.dbo.NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



-- Delete Unused Columns
Select *
From PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress,SaleDate