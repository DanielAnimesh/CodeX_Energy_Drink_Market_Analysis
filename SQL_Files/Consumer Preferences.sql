-- What are the preferred ingredients of energy drinks among respondents?

SELECT 
	DISTINCT Ingredients_expected,
    COUNT(Response_ID) as Count
FROM fact_survey_responses
GROUP BY  Ingredients_expected
ORDER BY Count DESC;

-- What packaging preferences do respondents have for energy drinks?

SELECT 
	DISTINCT Packaging_preference,
    COUNT(Response_ID) as Count
FROM fact_survey_responses
GROUP BY  Packaging_preference
ORDER BY Count DESC;
