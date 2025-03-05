[![freepik-the-style-is-candid-image-photography-with-natural-59745.jpg](https://i.postimg.cc/sDpdNWNR/freepik-the-style-is-candid-image-photography-with-natural-59745.jpg)](https://postimg.cc/KRvHK1b9)


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

## 🔢 Database Schema

```sql
-- Create Database
CREATE DATABASE survey_db;
USE survey_db;

-- Table: dim_cities
CREATE TABLE dim_cities (
    City_ID VARCHAR(10) PRIMARY KEY,  -- 'CT111' is alphanumeric, so use VARCHAR
    City VARCHAR(255) NOT NULL,
    Tier ENUM('Tier 1', 'Tier 2', 'Tier 3') NOT NULL  -- Restrict values to valid tiers
);

-- Table: dim_respondents
CREATE TABLE dim_respondents (
    Respondent_ID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Age VARCHAR(10) NOT NULL,  -- Values like '15-18' need VARCHAR, not INT
    Gender ENUM('Male', 'Female', 'Non-binary') NOT NULL,  -- Restrict to valid gender options
    City_ID VARCHAR(10) NOT NULL,  
    FOREIGN KEY (City_ID) REFERENCES dim_cities(City_ID) ON DELETE CASCADE
);

-- Table: fact_survey_responses
CREATE TABLE fact_survey_responses (
    Response_ID INT PRIMARY KEY,
    Respondent_ID INT NOT NULL,
    Consume_frequency VARCHAR(50),  -- Example: '2-3 times a week'
    Consume_time VARCHAR(255),  
    Consume_reason TEXT,  
    Heard_before ENUM('Yes', 'No') NOT NULL,  
    Brand_perception TEXT,  
    General_perception TEXT,  
    Tried_before ENUM('Yes', 'No') NOT NULL,  
    Taste_experience INT CHECK (Taste_experience BETWEEN 1 AND 5),  -- Rating scale (1-5)
    Reasons_preventing_trying TEXT,  
    Current_brands TEXT,  
    Reasons_for_choosing_brands TEXT,  
    Improvements_desired TEXT,  
    Ingredients_expected TEXT,  
    Health_concerns TEXT,  
    Interest_in_natural_or_organic ENUM('Yes', 'No', 'Not sure') NOT NULL,  
    Marketing_channels TEXT,  
    Packaging_preference TEXT,  
    Limited_edition_packaging ENUM('Yes', 'No', 'Not sure') NOT NULL,  
    Price_range VARCHAR(50),  
    Purchase_location TEXT,  
    Typical_consumption_situations TEXT,  
    FOREIGN KEY (Respondent_ID) REFERENCES dim_respondents(Respondent_ID) ON DELETE CASCADE
);
```

## 🧹 Data Cleaning
Before analysis, we performed the following data-cleaning steps:

### 🔍 Checking for Duplicates

```sql
SELECT Respondent_ID, COUNT(*) 
FROM dim_respondents
GROUP BY Respondent_ID
HAVING COUNT(*) > 1;
```
**Insight:** No duplicate Respondent_IDs were found.

### 🛠 Handling NULL Values

```sql
SELECT 
    SUM(CASE WHEN City_ID IS NULL THEN 1 ELSE 0 END) AS Null_City_ID,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS Null_City,
    SUM(CASE WHEN Tier IS NULL THEN 1 ELSE 0 END) AS Null_Tier
FROM dim_cities;
```
**Insight:** No null values in `City_ID`


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
**Insight:**
Energy drinks are significantly more popular among males (6038 respondents), followed by females (3455) and non-binary individuals (507). Marketing campaigns should prioritize engaging male audiences while exploring strategies to increase appeal among female and non-binary consumers.

#### Which age group prefers energy drinks more?

```sql
SELECT Age, COUNT(Age) AS Count
FROM dim_respondents
GROUP BY Age
ORDER BY Count DESC;
```
**Insight:**
The highest consumption is observed in the 19-30 age group (5520 respondents), followed by 31-45 (2376) and 15-18 (1488). This suggests that marketing should target young professionals and students, with a secondary focus on middle-aged consumers.

#### Which type of marketing reaches the most youth (15-30)?

```sql
SELECT Marketing_channels, COUNT(*) AS Youth_Count
FROM fact_survey_responses frs
JOIN dim_respondents dr ON dr.Respondent_ID = frs.Respondent_ID
WHERE dr.Age BETWEEN 15 AND 30
GROUP BY Marketing_channels
ORDER BY Youth_Count DESC;
```
**Insight:**
Online ads (3373) and TV commercials (1785) are the most effective channels for reaching younger audiences. Brands should prioritize digital advertising while maintaining TV presence to maximize engagement.

---

### 🏆 **Consumer Preferences**

#### What are the preferred ingredients of energy drinks among respondents?

```sql
SELECT Ingredients_expected, COUNT(Response_ID) AS Count
FROM fact_survey_responses
GROUP BY Ingredients_expected
ORDER BY Count DESC;
```
**Insight:**
Caffeine (3896) is the most sought-after ingredient, followed by vitamins (2534) and sugar (2017). This suggests that consumers prioritize energy-boosting components, so product formulations should emphasize these while offering low-sugar alternatives.

#### What packaging preferences do respondents have?

```sql
SELECT Packaging_preference, COUNT(Response_ID) AS Count
FROM fact_survey_responses
GROUP BY Packaging_preference
ORDER BY Count DESC;
```
**Insight:**
Compact and portable cans (3984) are the most preferred, followed by innovative bottle designs (3047). Limited-edition or collectible packaging (1501) also has appeal. A mix of standard and special-edition packaging may enhance brand engagement.

---

### 📈 **Competition Analysis**

#### Who are the current market leaders?

```sql
SELECT Current_brands, COUNT(Response_ID) AS Count
FROM fact_survey_responses
GROUP BY Current_brands
ORDER BY Count DESC;
```
**Insight:**
Cola-Coka (2538), Bepsi (2112), and Gangster (1854) are leading brands, indicating strong consumer loyalty. Competing effectively may require differentiation through taste, branding, and targeted promotions.

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
**Insight:**
Brand reputation is the dominant factor influencing consumer choices (Cola-Coka: 616, Bepsi: 577, Gangster: 511). Enhancing CodeX's reputation through branding and quality improvements is crucial to gaining market share.

---

### 📢 **Marketing & Brand Awareness**

#### Which marketing channel can be used to reach more customers?

```sql
SELECT Marketing_channels, COUNT(Response_ID) AS Count
FROM fact_survey_responses
GROUP BY Marketing_channels
ORDER BY Count DESC;
```
**Insight:**
Online ads (4020) and TV commercials (2688) are the top-performing channels. Investing in digital advertising while maintaining traditional media visibility can help expand brand reach.

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
**Insight:**
Online ads dominate among youth (3373), while TV commercials have a balanced reach across age groups. Outdoor billboards and print media are less effective, indicating a digital-first strategy may yield better results.

---

### 🌎 **Brand Penetration**

#### What do people think about our brand?

```sql
SELECT Brand_perception, COUNT(*) AS Count
FROM fact_survey_responses
GROUP BY Brand_perception
ORDER BY Count DESC;
```
**Insight:**
A majority of respondents have a neutral perception (5974), suggesting low engagement. Increasing positive sentiment through improved taste, marketing, and availability is key.

#### Which cities should we focus on?

```sql
SELECT dc.City, dc.Tier, COUNT(Respondent_ID) AS Count
FROM dim_respondents dr
JOIN dim_cities dc ON dc.City_ID = dr.City_ID
GROUP BY dc.City, dc.Tier
ORDER BY Count DESC;
```
**Insight:**
Tier 1 cities like Bangalore (2828), Hyderabad (1833), and Mumbai (1510) have the highest demand, making them priority markets. Expanding in Tier 2 cities like Pune and Kolkata could provide growth opportunities.

---

### 🛒 **Purchase Behavior**

#### Where do respondents prefer to purchase energy drinks?

```sql
SELECT Purchase_location, COUNT(Response_ID) AS Count
FROM fact_survey_responses
GROUP BY Purchase_location
ORDER BY Count DESC;
```
**Insight:**
Supermarkets (4494) and online retailers (2550) are the most common purchase points. Strengthening availability in these channels should be a priority.

#### What factors influence purchase decisions (Price/Packaging)?

```sql
SELECT Price_range, COUNT(Response_ID) AS Response_Count,
    ROUND(100 * COUNT(Response_ID) / SUM(COUNT(Response_ID)) OVER(), 2) AS Percentage
FROM fact_survey_responses
GROUP BY Price_range
ORDER BY Response_Count DESC;
```
**Insight:**
A significant portion of respondents (40.23%) are not influenced by limited edition packaging, while 39.46% consider it. This suggests that while unique packaging can attract buyers, core factors like taste and price play a more dominant role.

---

### 🚀 **Product Development**

#### What should we focus on for product development (Branding, Taste, Availability)?

```sql
SELECT Brand_perception, COUNT(Response_ID) AS Count
FROM fact_survey_responses
GROUP BY Brand_perception
ORDER BY Count DESC;
```
**Insight:**
A majority of respondents (59.74%) are neutral towards the brand, indicating room for improvement in branding and marketing. 

```sql
SELECT Taste_experience, COUNT(Response_ID) AS Count
FROM fact_survey_responses
WHERE Taste_experience IS NOT NULL
GROUP BY Taste_experience
ORDER BY Count DESC;
```
**Insight:**
Taste ratings are mixed, with 29.87% rating it a 3/5. Improving flavor profiles based on consumer preferences could enhance customer loyalty.
---

## 🌟 Secondary Insights 

### Recommendations for CodeX:
1. **Improve Product Formula:** Consumers prefer caffeine and vitamins in energy drinks. CodeX should emphasize these ingredients in its branding.
2. **Adjust Pricing Strategy:** Since price is a key decision factor, CodeX should offer a mid-tier price similar to competitors while providing occasional discounts.
3. **Leverage Digital Marketing:** With online ads being the most effective channel, CodeX should prioritize social media campaigns, influencer collaborations, and targeted ads.
4. **Identify Brand Ambassadors:** Given the youth audience, partnering with fitness influencers, athletes, or eSports gamers could enhance brand visibility.
5. **Expand Distribution Channels:** Consumers prefer buying from supermarkets and online stores. Ensuring strong availability in these channels can drive sales growth.

---

## 📌 Conclusion

This project provides actionable insights on consumer preferences, marketing effectiveness, and product development strategies for energy drink brands.

---

## 🔗 Connect

- **Author**: Animesh Daniel
- **LinkedIn**: [Your Profile]
- **GitHub**: [Your Repository]
