# 📊 Energy Drink Consumer Analysis - SQL Project

## 📌 Project Overview
This project analyzes consumer preferences, marketing effectiveness, and brand perception in the energy drink market using SQL. The dataset contains survey responses related to brand awareness, purchasing behavior, and product preferences.

---

## 🗄️ Dataset
The dataset consists of three tables:
1. **dim_respondents** - Contains demographic details of respondents.
2. **dim_cities** - Includes information about cities and their tiers.
3. **fact_survey_responses** - Stores responses to survey questions.

---

## 🧹 Data Cleaning
### 🔍 Checking for Duplicates
```sql
SELECT Respondent_ID, COUNT(*) 
FROM dim_respondents
GROUP BY Respondent_ID
HAVING COUNT(*) > 1;
```

### 🛠 Handling NULL Values
```sql
SELECT 
    SUM(CASE WHEN City_ID IS NULL THEN 1 ELSE 0 END) AS Null_City_ID,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS Null_City,
    SUM(CASE WHEN Tier IS NULL THEN 1 ELSE 0 END) AS Null_Tier
FROM dim_cities;
```

```sql
SELECT 
    SUM(CASE WHEN Respondent_ID IS NULL THEN 1 ELSE 0 END) AS Null_Respondent_ID,
    SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS Null_Name,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Null_Age,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Null_Gender,
    SUM(CASE WHEN City_ID IS NULL THEN 1 ELSE 0 END) AS Null_City_ID
FROM dim_respondents;
```

### 🤔 Sense Check for Logical Consistency
- Some respondents reported **never hearing about the drink but still provided a taste experience rating**.
- To fix this, we set inconsistent responses to NULL:
```sql
UPDATE fact_survey_responses
SET Taste_experience = NULL
WHERE Heard_before = 'No' 
  AND Tried_before = 'No';
```

---

## 📊 Insights & Analysis

### 🎯 **Demographics Insights**
#### Who prefers energy drinks more? (Male/Female/Non-binary)
```sql
SELECT Gender, COUNT(Gender) AS Count
FROM dim_respondents
GROUP BY Gender
ORDER BY Count DESC;
```

#### Which age group prefers energy drinks more?
```sql
SELECT Age, COUNT(Age) AS Count
FROM dim_respondents
GROUP BY Age
ORDER BY Count DESC;
```

#### Which type of marketing reaches the most youth (15-30)?
```sql
SELECT Marketing_channels, COUNT(*) AS Youth_Count
FROM fact_survey_responses frs
JOIN dim_respondents dr ON dr.Respondent_ID = frs.Respondent_ID
WHERE dr.Age BETWEEN 15 AND 30
GROUP BY Marketing_channels
ORDER BY Youth_Count DESC;
```

---

### 🏆 **Consumer Preferences**
#### What are the preferred ingredients of energy drinks among respondents?
```sql
SELECT Ingredients_expected, COUNT(Response_ID) AS Count
FROM fact_survey_responses
GROUP BY Ingredients_expected
ORDER BY Count DESC;
```

#### What packaging preferences do respondents have?
```sql
SELECT Packaging_preference, COUNT(Response_ID) AS Count
FROM fact_survey_responses
GROUP BY Packaging_preference
ORDER BY Count DESC;
```

---

### 📈 **Competition Analysis**
#### Who are the current market leaders?
```sql
SELECT Current_brands, COUNT(Response_ID) AS Count
FROM fact_survey_responses
GROUP BY Current_brands
ORDER BY Count DESC;
```

#### What are the primary reasons consumers prefer those brands over ours?
```sql
WITH RankedReasons AS (
    SELECT Current_brands, Reasons_for_choosing_brands,
        COUNT(Response_ID) AS Count,
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

---

### 📢 **Marketing & Brand Awareness**
#### Which marketing channel can be used to reach more customers?
```sql
SELECT Marketing_channels, COUNT(Response_ID) AS Count
FROM fact_survey_responses
GROUP BY Marketing_channels
ORDER BY Count DESC;
```

#### How effective are different marketing strategies and channels in reaching our customers?
```sql
SELECT Marketing_channels, COUNT(Response_ID) AS Total_Reach,
    SUM(CASE WHEN Age BETWEEN 15 AND 30 THEN 1 ELSE 0 END) AS Youth_Reach,
    SUM(CASE WHEN Age > 30 THEN 1 ELSE 0 END) AS Adult_Reach
FROM fact_survey_responses frs
JOIN dim_respondents dr ON frs.Respondent_ID = dr.Respondent_ID
GROUP BY Marketing_channels
ORDER BY Total_Reach DESC;
```

---

### 🌎 **Brand Penetration**
#### What do people think about our brand?
```sql
SELECT Brand_perception, COUNT(*) AS Count
FROM fact_survey_responses
GROUP BY Brand_perception
ORDER BY Count DESC;
```

#### Which cities should we focus on?
```sql
SELECT dc.City, dc.Tier, COUNT(Respondent_ID) AS Count
FROM dim_respondents dr
JOIN dim_cities dc ON dc.City_ID = dr.City_ID
GROUP BY dc.City, dc.Tier
ORDER BY Count DESC;
```

---

### 🛒 **Purchase Behavior**
#### Where do respondents prefer to purchase energy drinks?
```sql
SELECT Purchase_location, COUNT(Response_ID) AS Count
FROM fact_survey_responses
GROUP BY Purchase_location
ORDER BY Count DESC;
```

#### What factors influence purchase decisions (Price/Packaging)?
```sql
SELECT Price_range, COUNT(Response_ID) AS Response_Count,
    ROUND(100 * COUNT(Response_ID) / SUM(COUNT(Response_ID)) OVER(), 2) AS Percentage
FROM fact_survey_responses
GROUP BY Price_range
ORDER BY Response_Count DESC;
```

```sql
SELECT Limited_edition_packaging, COUNT(Response_ID) AS Count,
    ROUND(100 * COUNT(Response_ID) / SUM(COUNT(Response_ID)) OVER(), 2) AS Percentage
FROM fact_survey_responses
GROUP BY Limited_edition_packaging
ORDER BY Count DESC;
```

---

### 🚀 **Product Development**
#### What should we focus on for product development (Branding, Taste, Availability)?
```sql
SELECT Brand_perception, COUNT(Response_ID) AS Count
FROM fact_survey_responses
GROUP BY Brand_perception
ORDER BY Count DESC;
```

```sql
SELECT Taste_experience, COUNT(Response_ID) AS Count
FROM fact_survey_responses
WHERE Taste_experience IS NOT NULL
GROUP BY Taste_experience
ORDER BY Count DESC;
```

---

## 📌 Conclusion
This project provides actionable insights on consumer preferences, marketing effectiveness, and product development strategies for energy drink brands.

---

## 🔗 Connect
- **Author**: Animesh Daniel
- **LinkedIn**: [Your Profile]
- **GitHub**: [Your Repository]

