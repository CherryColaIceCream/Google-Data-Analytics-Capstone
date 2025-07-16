-- Categorizing users into different types based on frequency of device usage and counting them

SELECT user_type,
	COUNT(user_type) number_of_types
FROM
(
	SELECT id,
		COUNT(id) total_id,
		CASE
			WHEN COUNT(Id) BETWEEN 25 AND 31 THEN 'Active User'
			WHEN COUNT(Id) BETWEEN 15 AND 25 THEN 'Moderate User'
			WHEN COUNT(Id) BETWEEN 1 AND 14 THEN 'Light User'
		END user_type
	FROM dbo.daily_activity
	GROUP BY id
) types
GROUP BY user_type
ORDER BY number_of_types DESC