-- Analyzing the average steps taken by users depending on time of day

SELECT 
    CAST(ActivityTime AS TIME(0)) AS TimeFormatted,
    AVG(StepTotal) AS AverageSteps
FROM dbo.hourly_steps
GROUP BY CAST(ActivityTime AS TIME(0))
ORDER BY TimeFormatted;