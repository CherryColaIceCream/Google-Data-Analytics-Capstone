-- Checking whether data in these 3 tables is already included in daily_activity table

SELECT dActivity.LightActiveDistance,
	dIntensities.LightActiveDistance
FROM dbo.daily_activity dActivity
INNER JOIN dbo.daily_intensities dIntensities
ON dActivity.Id = dIntensities.Id
AND dActivity.ActivityDate = dIntensities.ActivityDay

SELECT dActivity.Calories,
	dCalories.Calories
FROM dbo.daily_activity dActivity
INNER JOIN dbo.daily_calories dCalories
ON dActivity.Id = dCalories.Id
AND dActivity.ActivityDate = dCalories.ActivityDay

SELECT dActivity.TotalSteps,
	dSteps.StepTotal
FROM dbo.daily_activity dActivity
INNER JOIN dbo.daily_steps dSteps
ON dActivity.Id = dSteps.Id
AND dActivity.ActivityDate = dSteps.ActivityDay