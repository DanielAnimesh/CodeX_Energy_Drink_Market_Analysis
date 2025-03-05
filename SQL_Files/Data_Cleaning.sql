-- Data Cleaning


SELECT Respondent_ID, COUNT(*) 
FROM dim_respondents
GROUP BY Respondent_ID
HAVING COUNT(*) > 1;


SELECT 
    SUM(CASE WHEN City_ID IS NULL THEN 1 ELSE 0 END) AS Null_City_ID,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS Null_City,
    SUM(CASE WHEN Tier IS NULL THEN 1 ELSE 0 END) AS Null_Tier
FROM dim_cities;


SELECT 
    SUM(CASE WHEN Respondent_ID IS NULL THEN 1 ELSE 0 END) AS Null_Respondent_ID,
    SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS Null_Name,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Null_Age,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Null_Gender,
    SUM(CASE WHEN City_ID IS NULL THEN 1 ELSE 0 END) AS Null_City_ID
FROM dim_respondents;


SELECT 
    SUM(CASE WHEN Response_ID IS NULL THEN 1 ELSE 0 END) AS Null_Response_ID,
    SUM(CASE WHEN Respondent_ID IS NULL THEN 1 ELSE 0 END) AS Null_Respondent_ID,
    SUM(CASE WHEN Consume_frequency IS NULL THEN 1 ELSE 0 END) AS Null_Consume_frequency,
    SUM(CASE WHEN Price_range IS NULL THEN 1 ELSE 0 END) AS Null_Price_range
FROM fact_survey_responses;


SELECT * 
FROM fact_survey_responses
WHERE Heard_before = 'No' 
  AND Tried_before = 'No' 
  AND Taste_experience IS NOT NULL;
  
UPDATE fact_survey_responses
SET Taste_experience = NULL
WHERE Heard_before = 'No' 
  AND Tried_before = 'No';











