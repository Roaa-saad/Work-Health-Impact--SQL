-- Explore The Data 
SELECT * FROM remote_work

-- Q1 How is the workforce distributed across regions and work modes?

SELECT Region,
       Work_Arrangement,
       COUNT(*) AS employee_count
FROM remote_work
GROUP BY Region, Work_Arrangement
ORDER BY Region, employee_count DESC;

-- Minmum and Maximum work hours
SELECT MIN(Hours_Per_Week) AS MIN_Work_Hours, 
MAX(Hours_Per_Week) AS MAX_Work_Hour
FROM remote_work;

-- Q2 Which work arrangement shows the best average work-life balance?

SELECT Work_Arrangement ,
	  Sum (Work_Life_Balance_Score) / COUNT(*) AS  Avg_life_Balance
FROM remote_work 
GROUP BY Work_Arrangement
ORDER BY  Avg_life_Balance DESC

--- Q3 Which work arrangement shows the Highest BurnOut?

SELECT Work_Arrangement,
       SUM(CASE WHEN Burnout_Level='High' THEN 1 ELSE 0 END) AS High_Burnout,
       COUNT(*) AS Total,
       ROUND(100.0*SUM(CASE WHEN Burnout_Level='High' THEN 1 ELSE 0 END)/COUNT(*),2) AS Pct_High_Burnout
FROM remote_work
GROUP BY Work_Arrangement;

--Q4  What is the most common burnout level?

SELECT Burnout_Level,
       COUNT(*) AS Total_Employees
FROM remote_work
GROUP BY Burnout_Level
ORDER BY Total_Employees DESC

-- Q5 Among those experiencing Medium burnout (the most common level), which work arrangement do they follow?
SELECT Work_Arrangement, Burnout_Level,
    COUNT(*) AS Total_Employees
FROM remote_work
WHERE  Burnout_Level = 'Medium'
GROUP BY Work_Arrangement, Burnout_Level
ORDER BY
    Total_Employees DESC

-- Q6 Which industries report the Most burnout, most resilient sectors?
SELECT 
    Industry,
    SUM(CASE WHEN Burnout_Level='Low' THEN 1 ELSE 0 END)    AS Low_Count,
    SUM(CASE WHEN Burnout_Level='Medium' THEN 1 ELSE 0 END) AS Medium_Count,
    SUM(CASE WHEN Burnout_Level='High' THEN 1 ELSE 0 END)   AS High_Count,
    COUNT(*)                                               AS Total_Employees
FROM remote_work
GROUP BY Industry
ORDER BY High_Count DESC;

-- Q7 Which age group experiences the highest rate of High burnout?

SELECT 
    CASE 
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 45 THEN '30–45'
        WHEN Age BETWEEN 46 AND 60 THEN '46–60'
        ELSE '61+'
    END AS Age_Group,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Burnout_Level = 'High' THEN 1 ELSE 0 END) AS High_Burnout_Count
FROM remote_work
GROUP BY 
    CASE 
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 45 THEN '30–45'
        WHEN Age BETWEEN 46 AND 60 THEN '46–60'
        ELSE '61+'
    END
ORDER BY High_Burnout_Count DESC;


-- Q8 Top Physical & Mental Issue Pairs
SELECT 
       Mental_Health_Status, 
	   COUNT(*) AS Employee_Count
FROM remote_work
WHERE Physical_Health_Issues <> 'None' AND Mental_Health_Status <> 'None'
GROUP BY  Mental_Health_Status
ORDER BY Employee_Count DESC;

-- Q9 Is there a relationship between salary range and work-life balance?
SELECT Salary_Range,
       AVG (Work_Life_Balance_Score) AS AVG_Life_Balance 
FROM remote_work
GROUP BY Salary_Range
ORDER BY AVG_Life_Balance DESC

-- Q10 Average social isolation score by work arrangement 
SELECT Work_Arrangement,
       AVG (Social_Isolation_Score) AS AVG_Social_Isolation_Score
FROM remote_work
GROUP BY Work_Arrangement
ORDER BY AVG_Social_Isolation_Score DESC

-- Q11 Which gender experiences the highest level of burnout?
SELECT Gender,
       Burnout_Level,
	   COUNT (*) AS Total_Employee
FROM remote_work
WHERE  
    Gender NOT IN ('Prefer not to say' ,'Non-binary')
GROUP BY Gender, Burnout_Level
ORDER BY Total_Employee DESC

-- Q11 Which region has the highest proportion of employees reporting a mental health issue?
SELECT 
    Region,
    SUM(CASE WHEN Mental_Health_Status <> 'None' THEN 1 ELSE 0 END) AS With_Issue,
    COUNT(*) AS Total_Employees,
    ROUND(
        100.0 * SUM(CASE WHEN Mental_Health_Status <> 'None' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS Percent_With_Issue
FROM remote_work
GROUP BY Region
ORDER BY Percent_With_Issue DESC;

-- Q13 How many employees report more than one physical health issue?
SELECT 
    COUNT(*) AS Employees_With_Multiple_Issues
FROM remote_work
WHERE 
    Physical_Health_Issues!= 'None'
    AND Physical_Health_Issues LIKE '%;%' ;

-- Q14 Is higher social isolation linked to high burnout?
SELECT 
    CASE WHEN Social_Isolation_Score >=3 THEN 'High Isolation' ELSE 'Low/Medium Isolation' END AS Isolation_Group,
    SUM(CASE WHEN Burnout_Level='High' THEN 1 ELSE 0 END) AS High_Burnout_Count,
    COUNT(*) AS Total_Employees,
    ROUND(100.0 * SUM(CASE WHEN Burnout_Level='High' THEN 1 ELSE 0 END) / COUNT(*),2) AS High_Burnout_Percent
FROM remote_work
GROUP BY CASE WHEN Social_Isolation_Score >=3 THEN 'High Isolation' ELSE 'Low/Medium Isolation' END;

-- Q15 Do employees working >40 hours/week report more physical and mental health issues than others?
SELECT 
    CASE WHEN Hours_Per_Week > 40 THEN 'Over 40 hrs' ELSE '40 or Less' END AS Hour_Group,
    SUM(CASE WHEN Physical_Health_Issues <> 'None' THEN 1 ELSE 0 END) AS With_Physical_Issue,
	 SUM(CASE WHEN Mental_Health_Status <> 'None' THEN 1 ELSE 0 END) AS With_Mental_Issue,
    COUNT(*) AS Total_Employees
FROM remote_work
GROUP BY CASE WHEN Hours_Per_Week > 40 THEN 'Over 40 hrs' ELSE '40 or Less' END
ORDER BY With_Mental_Issue DESC


