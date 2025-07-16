-- Checking how often users used their devices

SELECT total_id,
	COUNT(total_id) number_of_users
FROM
(
	SELECT Id,
		COUNT(id) total_id
	FROM dbo.daily_activity
	GROUP BY id
) counts
GROUP BY total_id
ORDER BY total_id DESC