use project;
select * from hrdata;
CREATE TABLE newhrdata AS
SELECT
    Employee_ID,
    Age,
    CASE
        WHEN Age <= 30 THEN '>30'
        ELSE '<30'
    END AS AgeGroup,
    REPLACE(REPLACE(Gender, 'Male', 'M'), 'Female', 'F') AS Gender,
    Department,
    REPLACE(REPLACE(Position, 'DataScientist', 'Data Scientist'), 'Marketinganalyst', 'Marketing Analyst') AS Position,
    Years_of_Service,
    Salary ,
    CASE
        WHEN Salary >= 90000 THEN '90K-100K'
        WHEN Salary >= 80000 THEN '80K-90K'
        WHEN Salary >= 70000 THEN '70K-80K'
        WHEN Salary >= 60000 THEN '60K-70K'
        ELSE '50K-60K'
    END AS SalaryGroup,
    Performance_Rating,
    Work_hours,
    Attrition,
    Promotion,
    Training_Hours,
    Satisfaction_Score,
    Last_Promotion_Date
FROM hrdata;

-- data cleaning and prepration

UPDATE newhrdata
SET Salary = NULL
WHERE Salary = '';

ALTER TABLE newhrdata
MODIFY COLUMN Salary INT;

SELECT Salary
FROM newhrdata
WHERE Salary IS NOT NULL
GROUP BY Salary
ORDER BY COUNT(*) DESC
LIMIT 1 INTO @mode_value;

UPDATE newhrdata
SET Salary = @mode_value
WHERE Salary IS NULL;

UPDATE newhrdata
SET work_hours = NULL
WHERE work_hours = '';

UPDATE newhrdata
SET work_hours = round((select avg(work_hours) from hrdata where work_hours is not null))
WHERE work_hours IS NULL;

UPDATE newhrdata
SET attrition = NULL
WHERE attrition = '';

UPDATE newhrdata
SET attrition='No'
WHERE attrition IS NULL;

UPDATE newhrdata
SET promotion = NULL
WHERE promotion = '';

UPDATE newhrdata
SET promotion='No'
WHERE promotion IS NULL;

UPDATE newhrdata
SET performance_rating = NULL
WHERE performance_rating = '';

UPDATE newhrdata
SET performance_rating = ROUND((SELECT AVG(performance_rating) FROM hrdata WHERE performance_rating IS NOT NULL))
WHERE performance_rating IS NULL;

UPDATE newhrdata
SET training_hours = NULL
WHERE training_hours = '';

UPDATE newhrdata
SET training_hours = round((select avg(training_hours) from hrdata where training_hours is not null))
WHERE training_hours IS NULL;

SELECT
    Position,
    COUNT(*) AS TotalEmp,
    Sum(case when attrition='Yes' then 1 else 0 end) as Attrition_Yes,
    Sum(case when attrition='No' then 1 else 0 end) as Attrition_No,
    (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS AttritionRate_yes,
    (SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS AttritionRate_No
from newhrdata
Group by Position
	
SELECT
     Department,
    COUNT(*) AS DepartmentEmployeeCount,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS DepartmentAttritionCount,
    (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS AttritionRate
FROM newhrdata
GROUP BY Department;

SELECT
    Performance_rating,
    COUNT(*) AS TotalEmp,
    Sum(case when attrition='Yes' then 1 else 0 end) as Attrition_Yes,
    Sum(case when attrition='No' then 1 else 0 end) as Attrition_No,
    (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS AttritionRate_yes,
    (SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS AttritionRate_No
from newhrdata
Group by Performance_rating;

SELECT
    years_of_service,
    COUNT(*) AS TotalEmp,
    Sum(case when attrition='Yes' then 1 else 0 end) as Attrition_Yes,
    Sum(case when attrition='No' then 1 else 0 end) as Attrition_No,
    (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS AttritionRate_yes,
    (SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS AttritionRate_No
from newhrdata
Group by years_of_service;
 
 SELECT
    satisfaction_score,
    COUNT(*) AS TotalEmp,
    Sum(case when attrition='Yes' then 1 else 0 end) as Attrition_Yes,
    Sum(case when attrition='No' then 1 else 0 end) as Attrition_No,
    (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS AttritionRate_yes,
    (SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS AttritionRate_No
from newhrdata
Group by satisfaction_score;

 SELECT
    SalaryGroup,
    COUNT(*) AS TotalEmp,
    Sum(case when attrition='Yes' then 1 else 0 end) as Attrition_Yes,
    Sum(case when attrition='No' then 1 else 0 end) as Attrition_No,
    (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS AttritionRate_yes,
    (SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS AttritionRate_No
from newhrdata
Group by SalaryGroup;

SELECT
    years_of_service,
    sum(case when attrition='Yes' then 1 else 0 end )as Attrition,
    Sum(case when promotion='Yes' then 1 else 0 end) as Promotion,
    Sum(case when promotion='No' then 1 else 0 end) as NoPromotion
from newhrdata
group by years_of_service;

SELECT
    CASE WHEN Attrition = 'Yes' THEN 'Attrition' ELSE 'No Attrition' END AS AttritionStatus,
    count(*) as TotalEmp,
    round(AVG(Age)) AS AvgAge,
    round(AVG(satisfaction_score)) as AvgSatisfactioScore,
    round(Avg(Years_of_service)) as AvgYearsofExp,
    round(Avg(salary)) as AvgSalary,
    round(Avg(Work_Hours)) as AvgWorkHours,
    round(Avg(Training_Hours)) as AvgTrainingHours
FROM newhrdata
GROUP BY AttritionStatus;

SELECT
	training_hours,
    count(*) as TotalEmp,
    round(Avg(performance_rating),3) as AVGPerformanceRating
    
from newhrdata
Group by training_hours;

SELECT
    Training_Hours,
    AVG(Satisfaction_Score) AS AvgSatisfactionScore,
    AVG(Performance_Rating) AS AvgPerformanceRating
FROM newhrdata
GROUP BY Training_Hours
ORDER BY Training_Hours;

SELECT Department, 
count(*) as TotalEmp,
round(AVG(Training_Hours),3) AS AvgTrainingHours
FROM hrdata
GROUP BY Department;

SELECT Training_Hours,count(*) as TotalEmp,
Sum(case when promotion='Yes' then 1 else 0 end) as Promotion,
    Sum(case when promotion='No' then 1 else 0 end) as NoPromotion,
    (SUM(CASE WHEN promotion = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS promotionRate_yes
FROM newhrdata
group by Training_Hours ;

SELECT Position, count(*) as TotalEmp, 
round(AVG(Training_Hours),3) AS AvgTrainingHours
FROM newhrdata
group by Position;

SELECT Years_of_service, count(*) as TotalEmp, 
round(AVG(Training_Hours),3) AS AvgTrainingHours
FROM newhrdata
group by Years_of_service;

SELECT satisfaction_score, count(*) as TotalEmp, 
round(AVG(Training_Hours),3) AS AvgTrainingHours

FROM newhrdata
group by satisfaction_score;

   SELECT Training_Hours,
    count(*) as TotalEmp,
    round(AVG(Age)) AS AvgAge,
    round(AVG(satisfaction_score)) as AvgSatisfactioScore,
    round(Avg(Years_of_service)) as AvgYearsofExp,
    round(Avg(salary)) as AvgSalary,
    round(Avg(Work_Hours)) as AvgWorkHours

FROM newhrdata
GROUP BY  Training_Hours
