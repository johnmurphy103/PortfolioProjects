Select *
From Game_Sales..sales
order by 1

-- Delete data rows of year 2020 and 2017 because they both only contain one point of data 

Delete From Sales
Where year = 2017

Delete From Sales
Where year = 2020


-- This query finds the games with the highest global sales on a platform

Select Name, Platform, Genre, Global_Sales
From Game_Sales..sales
Where Platform = 'Wii'
order by 4 Desc

-- This query calcualtes the sales of each platform globally and in each region 

Select Platform, SUM(Global_Sales) as Total_Global_Sales, SUM(NA_Sales) as Total_NA_Sales, 
SUM(EU_Sales) as Total_EU_Sales, SUM(JP_Sales) as Total_JP_Sales, SUM(Other_Sales) as Total_Other_Sales
From Game_Sales..sales
Where year is not null
Group by Platform
Order by 2 Desc

-- This query is like the last but breaks down the sales of each platform per year

Select Platform, year, SUM(Global_Sales) as Total_Global_Sales, SUM(NA_Sales) as Total_NA_Sales, 
SUM(EU_Sales) as Total_EU_Sales, SUM(JP_Sales) as Total_JP_Sales, SUM(Other_Sales) as Total_Other_Sales
From Game_Sales..sales
Where year is not null
Group by Platform, Year
Order by 2 Desc

-- This query calcualtes the total sales of each Publisher in each region per year

Select Publisher, SUM(Global_Sales) as Total_Global_Sales, SUM(NA_Sales) as Total_NA_Sales, 
SUM(EU_Sales) as Total_EU_Sales, SUM(JP_Sales) as Total_JP_Sales, SUM(Other_Sales) as Total_Other_Sales
From Game_Sales..sales
Group by Publisher
Order by 2 Desc

-- This query is like the last but breaks down the sales of each publisher per year

Select Publisher, Year, SUM(Global_Sales) as Total_Global_Sales, SUM(NA_Sales) as Total_NA_Sales, 
SUM(EU_Sales) as Total_EU_Sales, SUM(JP_Sales) as Total_JP_Sales, SUM(Other_Sales) as Total_Other_Sales
From Game_Sales..sales
Where year is not null
Group by Publisher, Year
Order by 2 Desc

-- This query breaks down sales into different genres

Select Genre, SUM(Global_Sales) as Total_Global_Sales, SUM(NA_Sales) as Total_NA_Sales, 
SUM(EU_Sales) as Total_EU_Sales, SUM(JP_Sales) as Total_JP_Sales, SUM(Other_Sales) as Total_Other_Sales
From Game_Sales..sales
Group by Genre
Order by 2 Desc

-- This query breaks down sales into different genres per year

Select Genre, year, SUM(Global_Sales) as Total_Global_Sales, SUM(NA_Sales) as Total_NA_Sales, 
SUM(EU_Sales) as Total_EU_Sales, SUM(JP_Sales) as Total_JP_Sales, SUM(Other_Sales) as Total_Other_Sales
From Game_Sales..sales
Group by Genre, Year
Order by 2 Desc

-- This query breaks down total sales per year and how many games where released that year

Select year, SUM(Global_Sales) as Total_Global_Sales, COUNT(Name) as ReleasedGames
From Game_Sales..sales
Where year is not null
Group by Year
order by 2 Desc


-- This query uses a CTE in order to calculate the average sales of each game per year

With YearlySalesVsGames (year, Total_Global_Sales, Released_Games)
as
(
Select year, SUM(Global_Sales) as Total_Global_Sales, COUNT(Name) as Released_Games
From Game_Sales..sales
Where year is not null
Group by Year
-- order by 2 Desc
)
Select *, (Total_Global_Sales/Released_Games) as average_sales_revenue
From YearlySalesVsGames
Order by 1




