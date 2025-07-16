-- Categorizing users by the number of average daily steps taken and counting them

SELECT UserType, 
	COUNT(UserType) NumberOfUsers
FROM
(
SELECT Id,
	AVG(TotalSteps) AverageSteps,
	CASE
		WHEN AVG(TotalSteps) < 5000 THEN 'Inactive'
		WHEN AVG(TotalSteps) BETWEEN 5000 AND 7499 THEN 'Low Active'
		WHEN AVG(TotalSteps) BETWEEN 7500 AND 9999 THEN 'Moderately Active'
		WHEN AVG(TotalSteps) BETWEEN 10000 AND 12499 THEN 'Active'
		WHEN AVG(TotalSteps) >= 12500 THEN 'Very Active'
	END UserType
FROM dbo.daily_activity
GROUP BY Id
) types_of_users
GROUP BY UserType
ORDER BY NumberOfUsers ASC