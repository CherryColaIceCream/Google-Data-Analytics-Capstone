# Case Study: Bellabeat - How Can a Wellness Technology Company Play It Smart?
##### Author: Kacper "Tabit" Gąsieniec

##### Date: 16/07/2025
#

The dashboard with all the relevant data visualization is posted on Tableau Public, click [here](https://public.tableau.com/views/BellabeatUserActivityGoogleCapstoneProject/Dashboard1?:language=en-GB&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link) to open the dashboard.

## 1. Introduction
This repository contains the capstone project for the **Google Data Analytics Professional Certificate**. The analysis follows the six-step data analysis process: **Ask, Prepare, Process, Analyze, Share, and Act**. The objective is to explore smart device usage data to uncover trends and generate actionable insights that can inform Bellabeat’s marketing strategy.

## 2. Scenario
Bellabeat is a high-tech company that develops smart wellness products designed to support women's health. Their devices track data on activity, sleep, stress, hydration, and reproductive health, providing users with insights into their habits and overall well-being.

This case study focuses on analyzing non-Bellabeat smart fitness device data to identify trends that can inform Bellabeat’s marketing decisions. The analysis specifically centers on the **Bellabeat app**, which integrates with their product line to help users monitor their health through features like activity tracking, sleep analysis, stress levels, menstrual cycle monitoring, and mindfulness practices.

## 3. Ask Phase
The first step in the data analysis process is to define the **business problem** and identify how data can help address it.
### 3.1 Business Task
Analyze usage data from **non-Bellabeat smart fitness devices** to identify trends in consumer behavior. These insights will then be applied to one Bellabeat product - the Bellabeat app - to generate high-level marketing recommendations aimed at increasing product engagement and market share.
### 3.2 Key Stakeholders
- Urška Sršen – Cofounder and Chief Creative Officer at Bellabeat. She initiated the project and is looking for insights to drive strategic marketing decisions.
- Sando Mur – Cofounder and key member of the Bellabeat executive team. Likely involved in evaluating the business impact of proposed strategies.
- Bellabeat Marketing Analytics Team - Responsible for collecting, analyzing, and reporting data to support marketing initiatives. The team will implement findings and develop campaigns based on the insights.

## 4. Prepare Phase
In the Prepare phase of the data analysis process, the focus shifts to identifying, collecting, and understanding the data sources relevant to the business problem.
### 4.1 Data Source
The data source used for this case study is [**FitBit Fitness Tracker Data**](https://www.kaggle.com/datasets/arashnic/fitbit) hosted on Kaggle. The dataset was published by Möbius under the CC0: Public Domain License, which means all rights to the work have been waived. This allows the dataset to be copied, modified, distributed, and used freely without the need for permission.
### 4.2 Data Structure
The dataset includes 18 CSV files each representing different health metrics. The data is stored in both long and wide formats. The datasets chosen for analysis below included a user count of 30 participants over a 31 day period of time, between 12/04/2016 and 12/05/2016. Not all of the CSV files were used for later analysis.
### 4.3 Data Credibility
| Aspect            | Evaluation                                                                                       |
| ----------------- | ------------------------------------------------------------------------------------------------ |
| **Reliable**      | Data is collected from actual users and device-generated, which adds reliability.                |
| **Original**      | Provided by Fitbit users via Kaggle; appears original for intended use.                          |
| **Comprehensive** | Limited by number of users (30) and time period; not fully representative of broader population. |
| **Current**       | May not reflect current Fitbit models or modern user behavior patterns.                          |
| **Cited**         | Public domain dataset, with clear origin from Kaggle and Möbius.                                 |
While the **FitBit Fitness Tracker Data** offers a reliable snapshot of user activity, its limitations are notable. The data is outdated (collected in 2016) and spans only one month, reducing its relevance for identifying current trends. It provides a small sample size of 30 users which, although statistically usable under the Central Limit Theorem, is not broadly representative. Additionally, the absence of demographic data - such as gender, location, age, and employment status - restricts the ability to tailor recommendations for specific target audiences or marketing channels. Since Bellabeat’s products are primarily designed for women and individuals who menstruate, having access to demographic details would have significantly strengthened the insights and recommendations generated from the analysis.

## 5. Process Phase
In the Process phase, raw data is cleaned, transformed, and prepared for analysis to ensure it is accurate, complete, and usable.
### 5.1 Datasets Used
The following datasets were chosen:
- dailyActivity_merged.csv
- dailyCalories_merged.csv
- dailyIntensities_merged.csv
- dailySteps_merged.csv
- hourlyCalories_merged.csv
- hourlyIntensities_merged.csv
- hourlySteps_merged.csv
- sleepDay_merged.csv
- weightLogInfo_merged.csv
### 5.2 Cleaning in Excel
Each dataset was cleaned using Excel. The following steps were:
- Sorting and filtering the data
- Using COUNTA and UNIQUE functions to determine the number of unique users in each dataset
- Formatting date data to DD/MM/YYYY for consistency
- Splitting Date and Time data into two separate columns if needed using Text to Columns function
- Formatting all numerical data properly
- Checking for duplicate data and removing it

The cleaning process has shown that most datasets have not 30, but 33 unique users. The exceptions to that are files *sleepDay_merged.csv* and *weightLogInfo_merged.csv* which had only 24 and 8 unique user IDs, respectively. Because of that these datasets will be dropped from further analysis, as they are unlikely to yield any statistically meaningful insights.

## 6. Analyze Phase
In the Analyze phase of the data analysis process, the focus is on examining the cleaned data to uncover patterns, trends, and insights.
### 6.1 Uploading to MSSQL
All of the cleaned datasets were uploaded into MSSQL for further analysis. After that, the following queries were ran, to confirm whether or not the data was the same in the *daily* tables:

```sql
SELECT dActivity.LightActiveDistance,
	dIntensities.LightActiveDistance
FROM dbo.daily_activity dActivity
INNER JOIN dbo.daily_intensities dIntensities
ON dActivity.Id = dIntensities.Id
AND dActivity.ActivityDate = dIntensities.ActivityDay
```

```sql
SELECT dActivity.Calories,
	dCalories.Calories
FROM dbo.daily_activity dActivity
INNER JOIN dbo.daily_calories dCalories
ON dActivity.Id = dCalories.Id
AND dActivity.ActivityDate = dCalories.ActivityDay
```

```sql
SELECT dActivity.TotalSteps,
	dSteps.StepTotal
FROM dbo.daily_activity dActivity
INNER JOIN dbo.daily_steps dSteps
ON dActivity.Id = dSteps.Id
AND dActivity.ActivityDate = dSteps.ActivityDay
```

After running these queries it was confirmed, that the daily_activity table had all of the same data as the other *daily* tables. Those tables were dropped, and so we're left with:
- daily_activity
- hourly_calories
- hourly_intensities
- hourly_steps
### 6.2 Device Usage
Next, I wanted to know how often users used their FitBit devices. This was done by checking how many times each ID shows up in the table, meaning how many days the users wore their FitBit watches during a one month period.

```sql
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
```

| total_id | number_of_users |
|----------|-----------------|
| 31       | 21              |
| 30       | 3               |
| 29       | 2               |
| 28       | 1               |
| 26       | 2               |
| 20       | 1               |
| 19       | 1               |
| 18       | 1               |
| 4        | 1               |
The results show that most active users decided to wear their devices for the entire month, while the least active user only used it for 4 days. I've decided to sort the users into 3 different categories: Active, Moderate, and Light users.

```sql
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
```

| user_type    | number_of_types |
|--------------|-----------------|
| Active User  | 29              |
| Moderate User| 3               |
| Light User   | 1               |
This shows us 29 users labelled as Active Users (used the device for more than 25 days), 3 users labelled as Moderate Users (used the device between 15 to 25 days), and 1 user labelled as Light User (used the device for less than 15 days).
### 6.3 Activity by Day of the Week
The next step was to analyze how user activity levels varied across different days of the week. This can potentially uncover behavioral patters among users, which could be helpful in creating recommendations for Bellabeat in later stages. 

Still working on the daily_activity table, I used the `DATENAME()` function to extract the name of the weekday from the ActivityDate column. Then, I calculated average number of minutes spent in different activity levels as well as the average number of steps.

```sql
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
```

| DayOfTheWeek | AvgSteps | AvgVeryActiveMinutes | AvgFairlyActiveMinutes | AvgLightlyActiveMinutes | AvgSedentaryMinutes |
| ------------ | -------- | -------------------- | ---------------------- | ----------------------- | ------------------- |
| Monday       | 7780     | 23                   | 14                     | 192                     | 1027                |
| Tuesday      | 8125     | 22                   | 14                     | 197                     | 1007                |
| Wednesday    | 7559     | 20                   | 13                     | 189                     | 989                 |
| Thursday     | 7405     | 19                   | 11                     | 185                     | 961                 |
| Friday       | 7448     | 20                   | 12                     | 204                     | 1000                |
| Saturday     | 8152     | 21                   | 15                     | 207                     | 964                 |
| Sunday       | 6933     | 19                   | 14                     | 173                     | 990                 |

The results indicated that there was little variation in physical activity types and number of steps across weekdays. However, one notable trend was the consistently high number of sedentary minutes throughout the week. This suggests that while users may engage in similar levels of movement each day, a significant portion of their time is still spent inactive.
### 6.4 User Types by Average Total Steps
To gain deeper insight into user behavior, individuals were grouped into categories based on their average daily step count. Using standard physical activity guidelines, users were classified as _Inactive_, _Low Active_, _Moderately Active_, _Active_, or _Very Active_.

```sql
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
```

| UserType          | NumberOfUsers |
|-------------------|---------------|
| Very Active       | 2             |
| Active            | 5             |
| Inactive          | 8             |
| Low Active        | 9             |
| Moderately Active | 9             |
Considering that most health recommendations suggest a daily step count of at least 7,500 to be considered active, we can group _Inactive_ and _Low Active_ users as less active, while the remaining users fall into the active range. That way, 17 users are little to non-active and 16 are considered somewhat or very active - almost an even split. This insight suggests that nearly half of Bellabeat users may benefit from additional motivation or features that promote daily movement.
### 6.5 Average Steps by Hour
Next I wanted to make use of the hourly_steps table to gain information about patterns in movement throughout the day. Understanding when users are most and least active can shed light on daily habits and help identify optimal times for engagement.

```sql
SELECT 
    CAST(ActivityTime AS TIME(0)) AS TimeFormatted,
    AVG(StepTotal) AS AverageSteps
FROM dbo.hourly_steps
GROUP BY CAST(ActivityTime AS TIME(0))
ORDER BY TimeFormatted;
```

| Time     | Average Steps |
| -------- | ------------- |
| 00:00:00 | 42            |
| 01:00:00 | 23            |
| 02:00:00 | 17            |
| 03:00:00 | 6             |
| 04:00:00 | 12            |
| 05:00:00 | 43            |
| 06:00:00 | 178           |
| 07:00:00 | 306           |
| 08:00:00 | 427           |
| 09:00:00 | 433           |
| 10:00:00 | 481           |
| 11:00:00 | 456           |
| 12:00:00 | 548           |
| 13:00:00 | 537           |
| 14:00:00 | 540           |
| 15:00:00 | 406           |
| 16:00:00 | 496           |
| 17:00:00 | 550           |
| 18:00:00 | 599           |
| 19:00:00 | 583           |
| 20:00:00 | 353           |
| 21:00:00 | 308           |
| 22:00:00 | 237           |
| 23:00:00 | 122           |
The data shows very low activity during the early morning hours, gradually increasing after 5 AM. Step counts peak between noon and 7 PM, with the highest average around 6 PM (599 steps), before declining again into the late evening. These results align with typical daily routines, reflecting periods of rest overnight and higher movement during daytime hours.

## 7. Share Phase
To present the insights from this analysis in a clear way, I created a dashboard using Tableau Public. It brings together the key findings from each phase of the project, including user engagement patterns, activity levels, and hourly/weekly behavior trends.

The dashboard is designed to be accessible and visual-first, helping both technical and non-technical stakeholders quickly grasp the most important takeaways. While this version keeps things simple, future iterations may include interactivity, tooltips, and advanced visuals.

[📖 Click here to view the Tableau Dashboard](https://public.tableau.com/views/BellabeatUserActivityGoogleCapstoneProject/Dashboard1?:language=en-GB&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

## 8. Act Phase
Given the brand’s emphasis on a female demographic, it would be valuable for Bellabeat to leverage its internal marketing and user data to uncover deeper behavioral trends. Additionally, using a larger and more diverse sample size would improve the reliability of insights by increasing statistical confidence. Since the dataset used in this case lacked demographic details, the analysis was limited in its ability to offer targeted recommendations or rule out potential sampling bias.

That being said, here are some insights that emerged during the analysis of the Fitbit dataset:

- Nearly half of users fall below recommended activity levels, suggesting a strong opportunity for personalized goal setting and motivational nudges within the Bellabeat app.
- User activity consistently peaks between 12 PM and 7 PM, making this the ideal window for scheduling reminders, sending challenges, or releasing new wellness content.
- Despite fluctuations in activity intensity throughout the week, sedentary time remains high across all days - opening the door for stress-relief tools or movement break reminders.
- Most users wore their devices consistently, indicating strong engagement and a good foundation for building long-term habits.

These insights could inform both product design and marketing strategy. Bellabeat might consider:

- Adding in-app rewards for meeting activity goals
- Introducing smart notifications during low-activity hours such as movement reminders
- Marketing the products to customers most likely living around this particular routine (fitting most of their activity between 12 PM and 7PM) 

#### Thank You
