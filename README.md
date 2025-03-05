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
Before analysis, we performed the following data-cleaning steps:

### Checking for Duplicates
```sql
SELECT Respondent_ID, COUNT(*) 
FROM dim_respondents
GROUP BY Respondent_ID
HAVING COUNT(*) > 1;
```
**Insight:** No duplicate Respondent_IDs were found.

### Identifying Missing Values
```sql
SELECT 
    SUM(CASE WHEN City_ID IS NULL THEN 1 ELSE 0 END) AS Null_City_ID,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS Null_City,
    SUM(CASE WHEN Tier IS NULL THEN 1 ELSE 0 END) AS Null_Tier
FROM dim_cities;
```
**Insight:** A few missing values in `City_ID`, but they were handled appropriately.

### Sense Check
Ensured logical consistency by verifying responses for cases where consumers claimed they never heard or tried the product but still provided a taste experience rating.
```sql
UPDATE fact_survey_responses
SET Taste_experience = NULL
WHERE Heard_before = 'No' 
  AND Tried_before = 'No';
```

---

## Demographic Insights

### Who prefers energy drinks more? (Male/Female/Non-binary)
```sql
SELECT Gender, COUNT(*) AS Count 
FROM dim_respondents 
GROUP BY Gender 
ORDER BY Count DESC;
```
**Insight:** Males (6038) are the largest consumer group, followed by females (3455) and non-binary respondents (507).

### Which age group prefers energy drinks more?
```sql
SELECT Age, COUNT(*) AS Count 
FROM dim_respondents 
GROUP BY Age 
ORDER BY Count DESC;
```
**Insight:** The 19-30 age group (5520) is the biggest consumer segment, followed by 31-45 (2376) and 15-18 (1488).

### Which type of marketing reaches the most Youth (15-30)?
```sql
SELECT Marketing_channels, COUNT(*) AS Youth_Count
FROM fact_survey_responses frs
JOIN dim_respondents dr ON dr.Respondent_ID = frs.Respondent_ID
WHERE dr.Age BETWEEN 15 AND 30
GROUP BY Marketing_channels
ORDER BY Youth_Count DESC;
```
**Insight:** Online ads (3373) are the most effective marketing channel for the youth segment.

---

## Consumer Preferences

### What are the preferred ingredients of energy drinks?
```sql
SELECT Ingredients_expected, COUNT(Response_ID) AS Count
FROM fact_survey_responses
GROUP BY Ingredients_expected
ORDER BY Count DESC;
```
**Insight:** Caffeine (3896) and vitamins (2534) are the most preferred ingredients.

### What packaging preferences do respondents have?
```sql
SELECT Packaging_preference, COUNT(Response_ID) AS Count
FROM fact_survey_responses
GROUP BY Packaging_preference
ORDER BY Count DESC;
```
**Insight:** Compact and portable cans (3984) are the top choice.

---

## Competition Analysis

### Who are the current market leaders?
```sql
SELECT Current_brands, COUNT(Response_ID) AS Count
FROM fact_survey_responses
GROUP BY Current_brands
ORDER BY Count DESC;
```
**Insight:** Cola-Coka (2538) and Bepsi (2112) are the top competitors.

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
**Insight:** Brand reputation is the top reason why consumers prefer competitors.

---

## Marketing Channels and Brand Awareness

### Which marketing channel can be used to reach more customers?
```sql
SELECT Marketing_channels, COUNT(Response_ID) AS Count
FROM fact_survey_responses
GROUP BY Marketing_channels
ORDER BY Count DESC;
```
**Insight:** Online ads (4020) have the highest reach potential.

### What do people think about our brand?
```sql
SELECT Brand_perception, COUNT(*) AS Count
FROM fact_survey_responses
GROUP BY Brand_perception
ORDER BY Count DESC;
```
**Insight:** Most respondents (5974) have a neutral perception of CodeX.

---

## Purchase Behavior

### Where do respondents prefer to purchase energy drinks?
```sql
SELECT Purchase_location, COUNT(Response_ID) AS Count
FROM fact_survey_responses
GROUP BY Purchase_location
ORDER BY Count DESC;
```
**Insight:** Supermarkets (4494) and online retailers (2550) are the preferred purchase locations.

### What factors influence purchase decisions (price & limited edition packaging)?
```sql
SELECT Price_range, COUNT(Response_ID) AS Count, ROUND(100 * COUNT(Response_ID) / SUM(COUNT(Response_ID)) OVER(), 2) AS Percentage
FROM fact_survey_responses
GROUP BY Price_range;
```
**Insight:** Price sensitivity is a significant factor in consumer decisions.

---

## Secondary Insights (Sample Sections / Questions)

**Note:** Additional market research is required.

### Recommendations for CodeX:
1. **Improve Product Formula:** Consumers prefer caffeine and vitamins in energy drinks. CodeX should emphasize these ingredients in its branding.
2. **Adjust Pricing Strategy:** Since price is a key decision factor, CodeX should offer a mid-tier price similar to competitors while providing occasional discounts.
3. **Leverage Digital Marketing:** With online ads being the most effective channel, CodeX should prioritize social media campaigns, influencer collaborations, and targeted ads.
4. **Identify Brand Ambassadors:** Given the youth audience, partnering with fitness influencers, athletes, or eSports gamers could enhance brand visibility.
5. **Expand Distribution Channels:** Consumers prefer buying from supermarkets and online stores. Ensuring strong availability in these channels can drive sales growth.

---

## Conclusion
The analysis highlights key consumer behaviors, brand perception, and marketing insights that can help CodeX refine its strategies to gain a competitive edge in the energy drink market.

