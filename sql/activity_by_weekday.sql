-- Analyzing how user activity levels varies across different weekdays

SELECT DATENAME(dw, ActivityDate) DayOfTheWeek,
	AVG(TotalSteps) AvgSteps,
	AVG(VeryActiveMinutes) AvgVeryActiveMinutes,
	AVG(FairlyActiveMinutes) AvgFairlyActiveMinutes,
	AVG(LightlyActiveMinutes) AvgLightlyActiveMinutes,
	AVG(SedentaryMinutes) AvgSedentaryMinutes
FROM dbo.daily_activity
GROUP BY DATENAME(dw, ActivityDate)
ORDER BY
	CASE DATENAME(dw, ActivityDate)
        WHEN 'Monday' THEN 1
        WHEN 'Tuesday' THEN 2
        WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4
        WHEN 'Friday' THEN 5
        WHEN 'Saturday' THEN 6
		WHEN 'Sunday' THEN 7
    END;