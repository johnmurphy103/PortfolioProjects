/**

Cleaning Data in SQL queries

**//

Select *
From Nashville_Housing..Housing

-- Standardize date format

Select SaleDateConverted, Convert(Date,SaleDate)
From Nashville_Housing..Housing

Update Nashville_Housing..Housing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE Nashville_Housing..Housing
ADD SaleDateConverted Date;

Update Nashville_Housing..Housing
SET SaleDateConverted = CONVERT(Date,SaleDate)

-- Populate Property Address

SELECT *
From Nashville_Housing..Housing
-- Where PropertyAddress is null
order by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Nashville_Housing..Housing a
JOIN Nashville_Housing..Housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Nashville_Housing..Housing a
JOIN Nashville_Housing..Housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Seperating Address into individual columns (Address, City, State)

SELECT PropertyAddress
From Nashville_Housing..Housing
-- Where PropertyAddress is null
-- order by ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress)) as Address
From Nashville_Housing..Housing

ALTER TABLE Nashville_Housing..Housing
ADD PropertySplitAddress NVARCHAR(255);

Update Nashville_Housing..Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE Nashville_Housing..Housing
ADD PropertySplitCity NVARCHAR(255);

Update Nashville_Housing..Housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress))

SELECT *
From Nashville_Housing..Housing


SELECT OwnerAddress
From Nashville_Housing..Housing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From Nashville_Housing..Housing

ALTER TABLE Nashville_Housing..Housing
ADD OwnerSplitAddress NVARCHAR(255);

Update Nashville_Housing..Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

ALTER TABLE Nashville_Housing..Housing
ADD OwnerSplitCity NVARCHAR(255);

Update Nashville_Housing..Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE Nashville_Housing..Housing
ADD OwnerSplitState NVARCHAR(255);

Update Nashville_Housing..Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

SELECT Distinct(SoldAsVacant), Count(SoldasVacant)
From Nashville_Housing..Housing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'Yes'
	 When SoldAsVacant = 'N' Then 'No'
	 ELSE SoldAsVacant
	 END
From Nashville_Housing..Housing

Update Nashville_Housing..Housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	 When SoldAsVacant = 'N' Then 'No'
	 ELSE SoldAsVacant
	 END



-- Remove Duplicates
