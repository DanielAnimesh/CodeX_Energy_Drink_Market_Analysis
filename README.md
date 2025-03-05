# 📊 Energy Drink Consumer Analysis - SQL Project

## 📌 Project Overview

This project analyzes consumer preferences, marketing effectiveness, and brand perception in the energy drink market using SQL. The dataset contains survey responses related to brand awareness, purchasing behavior, and product preferences.

---

## 🗄️ Dataset

The dataset consists of three tables:

1. **dim\_respondents** - Contains demographic details of respondents.
2. **dim\_cities** - Includes information about cities and their tiers.
3. **fact\_survey\_responses** - Stores responses to survey questions.

---

## Data Cleaning

### Check for Duplicate Respondents
```sql
SELECT Respondent_ID, COUNT(*)
FROM dim_respondents
GROUP BY Respondent_ID
HAVING COUNT(*) > 1;
```
**Insight:** Ensuring there are no duplicate respondents in the dataset.

### Check for Missing Data in `dim_cities`
```sql
SELECT
    SUM(CASE WHEN City_ID IS NULL THEN 1 ELSE 0 END) AS Null_City_ID,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS Null_City,
    SUM(CASE WHEN Tier IS NULL THEN 1 ELSE 0 END) AS Null_Tier
FROM dim_cities;
```
**Insight:** Identifying missing values in city-related information.

### Check for Missing Data in `dim_respondents`
```sql
SELECT
    SUM(CASE WHEN Respondent_ID IS NULL THEN 1 ELSE 0 END) AS Null_Respondent_ID,
    SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS Null_Name,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Null_Age,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Null_Gender,
    SUM(CASE WHEN City_ID IS NULL THEN 1 ELSE 0 END) AS Null_City_ID
FROM dim_respondents;
```
**Insight:** Ensuring no missing demographic data.

### Sense Check - Taste Experience
```sql
SELECT *
FROM fact_survey_responses
WHERE Heard_before = 'No'
  AND Tried_before = 'No'
  AND Taste_experience IS NOT NULL;
```
```sql
UPDATE fact_survey_responses
SET Taste_experience = NULL
WHERE Heard_before = 'No'
  AND Tried_before = 'No';
```
**Insight:** Removing inconsistent taste experience ratings from respondents who haven't tried the drink.

---

## Demographics Insights

### Who prefers energy drinks more? (Male/Female/Non-binary)
```sql
SELECT Gender, COUNT(Gender) as Count
FROM dim_respondents
GROUP BY Gender
ORDER BY Count DESC;
```
**Insight:**
- Male: **6038**
- Female: **3455**
- Non-binary: **507**
- Males are the largest consumer group.

### Which age group prefers energy drinks more?
```sql
SELECT Age, COUNT(Age) as Count
FROM dim_respondents
GROUP BY Age
ORDER BY Count DESC;
```
**Insight:**
- The **19-30** age group prefers energy drinks the most (**5520 respondents**).

### Which type of marketing reaches the most youth (15-30)?
```sql
SELECT Marketing_channels, COUNT(*) as Youth_Count
FROM fact_survey_responses frs
JOIN dim_respondents dr ON dr.Respondent_ID = frs.Respondent_ID
WHERE dr.Age BETWEEN 15 AND 30
GROUP BY Marketing_channels
ORDER BY Youth_Count DESC;
```
**Insight:**
- **Online ads** reach the most youth (**3373 respondents**).

---

## Consumer Preferences

### What are the preferred ingredients of energy drinks among respondents?
```sql
SELECT Ingredients_expected, COUNT(Response_ID) as Count
FROM fact_survey_responses
GROUP BY Ingredients_expected
ORDER BY Count DESC;
```
**Insight:**
- **Caffeine** is the most preferred ingredient (**3896 respondents**).

### What packaging preferences do respondents have?
```sql
SELECT Packaging_preference, COUNT(Response_ID) as Count
FROM fact_survey_responses
GROUP BY Packaging_preference
ORDER BY Count DESC;
```
**Insight:**
- **Compact and portable cans** are the most preferred (**3984 respondents**).

---

## Competition Analysis

### Who are the current market leaders?
```sql
SELECT Current_brands, COUNT(Response_ID) as Count
FROM fact_survey_responses
GROUP BY Current_brands
ORDER BY Count DESC;
```
**Insight:**
- **Cola-Coka** is the market leader (**2538 respondents**).

### What are the primary reasons consumers prefer those brands over ours?
```sql
WITH RankedReasons AS (
    SELECT Current_brands, Reasons_for_choosing_brands, COUNT(Response_ID) AS Count,
    ROW_NUMBER() OVER (PARTITION BY Current_brands ORDER BY COUNT(Response_ID) DESC) AS RankedNum
    FROM fact_survey_responses
    WHERE Current_brands != 'CodeX'
    GROUP BY Current_brands, Reasons_for_choosing_brands
)
SELECT Current_brands, Reasons_for_choosing_brands AS Best_Reason, Count
FROM RankedReasons
WHERE RankedNum = 1
ORDER BY Count DESC;
```
**Insight:**
- **Brand reputation** is the top reason for preference across brands.

---

## Marketing Channels and Brand Awareness

### Which marketing channel can be used to reach more customers?
```sql
SELECT Marketing_channels, COUNT(Response_ID) as Count
FROM fact_survey_responses
GROUP BY Marketing_channels
ORDER BY Count DESC;
```
**Insight:**
- **Online ads** have the highest reach (**4020 respondents**).

### What do people think about our brand?
```sql
SELECT Brand_perception, COUNT(*) AS Count
FROM fact_survey_responses
GROUP BY Brand_perception
ORDER BY Count DESC LIMIT 1;
```
**Insight:**
- The majority have a **Neutral** perception (**5974 respondents**).

---

## Purchase Behavior

### Where do respondents prefer to purchase energy drinks?
```sql
SELECT Purchase_location, COUNT(Response_ID) as Count
FROM fact_survey_responses
GROUP BY Purchase_location
ORDER BY Count DESC;
```
**Insight:**
- **Supermarkets** are the most preferred location (**4494 respondents**).

### What factors influence respondents' purchase decisions?
```sql
SELECT Price_range, COUNT(Response_ID) AS Response_Count,
ROUND(100 * COUNT(Response_ID) / SUM(COUNT(Response_ID)) OVER(), 2) AS Percentage
FROM fact_survey_responses
GROUP BY Price_range
ORDER BY Response_Count DESC;
```
**Insight:**
- **40.23% of respondents are price-sensitive**.

---

## Product Development

### Which area should we focus on for product development?
```sql
SELECT Brand_perception, COUNT(Response_ID) AS Count,
ROUND(100 * COUNT(Response_ID) / SUM(COUNT(Response_ID)) OVER(), 2) AS Percentage
FROM fact_survey_responses
GROUP BY Brand_perception
ORDER BY Count DESC;
```
**Insight:**
- **59.74% of respondents are neutral** towards the brand.

### Taste Experience Ratings
```sql
SELECT Taste_experience, COUNT(Response_ID) AS Count,
ROUND(100 * COUNT(Response_ID) / SUM(COUNT(Response_ID)) OVER(), 2) AS Percentage
FROM fact_survey_responses
WHERE Taste_experience IS NOT NULL
GROUP BY Taste_experience
ORDER BY Count DESC;
```
**Insight:**
- **Majority rate taste as 3/5** (**29.87% respondents**), suggesting room for improvement.

---

## Conclusion
This project provides key insights into consumer demographics, preferences, competition, and marketing effectiveness. The recommendations can be used to optimize branding, product development, and targeted marketing campaigns.

🚀 **Next Steps:**
- Improve brand perception through strategic marketing.
- Innovate in taste and packaging.
- Focus on online marketing channels.
- Expand in Tier 1 cities like **Bangalore and Hyderabad**.

