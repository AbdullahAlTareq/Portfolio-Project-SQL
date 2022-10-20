--Cleaning Data in SQL Queries

Select *
From NashvileHousing

-------------------------------------------------------------------------------

--1. Standardize Data Format

Select SaleDate, CONVERT(Date,SaleDate)
From NashvileHousing


Alter Table NashvileHousing
Add SaleDateConverted Date;

Update NashvileHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

Select SaleDateConverted
From NashvileHousing

-------------------------------------------------------------------------------

--2. Populate Property Address Date

Select *
From NashvileHousing
Where PropertyAddress is NULL
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)  --ISNULL is used to replace null value with another value
From NashvileHousing a
join NashvileHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]
Where a.PropertyAddress is Null


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvileHousing a
join NashvileHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]
Where a.PropertyAddress is Null


------------------------------------------------------------------------------------------


--3. Breaking out address into Individual Columns (Address, City, State)


Select PropertyAddress
From NashvileHousing
--Where PropertyAddress is NULL
--order by ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

From NashvileHousing

Alter Table NashvileHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvileHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter Table NashvileHousing
Add PropertySplitCity Nvarchar(255);

Update NashvileHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select *
From NashvileHousing



--4. Another way for breaking out and it is more EASY


Select OwnerAddress
From NashvileHousing

Select
Parsename(Replace(OwnerAddress, ',', '.'), 3),
Parsename(Replace(OwnerAddress, ',', '.'), 2),
Parsename(Replace(OwnerAddress, ',', '.'), 1)
From NashvileHousing

Alter Table NashvileHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvileHousing
SET OwnerSplitAddress = Parsename(Replace(OwnerAddress, ',', '.'), 3)

Alter Table NashvileHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvileHousing
SET OwnerSplitCity = Parsename(Replace(OwnerAddress, ',', '.'), 2)

Alter Table NashvileHousing
Add OwnerSplitState Nvarchar(255);

Update NashvileHousing
SET OwnerSplitState = Parsename(Replace(OwnerAddress, ',', '.'), 1)

Select *
From NashvileHousing


--------------------------------------------------------------------------------------------------



--5. Change Y and N to Yes and No in 'SoldAsVacant' field



Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvileHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant,
Case When SoldAsVacant = 'Y' Then 'Yes'
	 When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End
From NashvileHousing

Update NashvileHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
	 When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End


--------------------------------------------------------------------------------------------------



--6. Remove Duplicates


With RowNumCTE AS(
Select *,
	ROW_NUMBER() Over(
	Partition by ParcelID,
				 PropertyAddress,
				 SaleDate,
				 SalePrice,
				 LegalReference
				 Order by
					UniqueID
					) row_num
From NashvileHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1




--------------------------------------------------------------------------------------------------------------



--7. Delete Unused Columns




Select *
From NashvileHousing


Alter Table NashvileHousing
Drop Column SaleDate


---------------------------------------------------That's all, Thank You--------------------------------------------------------------