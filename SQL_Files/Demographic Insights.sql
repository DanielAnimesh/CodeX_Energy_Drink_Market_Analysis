-- Demographic Insights


--  Who prefers energy drink more? (male/female/non-binary?)

SELECT
	DISTINCT Gender, 
    count(Gender) as Count
FROM dim_respondents
GROUP BY Gender
ORDER BY Count desc;

-- Which age group prefers energy drinks more

SELECT
	DISTINCT Age, 
    count(Age) as Count
FROM dim_respondents
GROUP BY Age
ORDER BY Count desc;



-- Which type of marketing reaches the most Youth (15-30)?

SELECT
	Marketing_channels,
    COUNT(*) as Youth_Count
FROM fact_survey_responses frs
JOIN dim_respondents dr
	ON dr.Respondent_ID = frs.Respondent_ID
WHERE dr.Age between 15 AND 30
GROUP BY Marketing_channels
ORDER BY Youth_Count DESC;



