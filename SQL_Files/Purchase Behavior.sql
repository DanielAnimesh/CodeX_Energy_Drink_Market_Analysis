-- Where do respondents prefer to purchase energy drinks?

SELECT 
	DISTINCT Purchase_location,
    COUNT(Response_ID) as Count
FROM fact_survey_responses
GROUP BY  Purchase_location
ORDER BY Count DESC;


-- What are the typical consumption situations for energy drinks among respondents?

SELECT 
	DISTINCT Typical_consumption_situations,
    COUNT(Response_ID) as Count
FROM fact_survey_responses
GROUP BY  Typical_consumption_situations
ORDER BY Count DESC;


-- What factors influence respondents' purchase decisions, such as price range and limited edition packaging?

SELECT 
    Price_range,
    COUNT(Response_ID) AS Response_Count,
    ROUND(100 * COUNT(Response_ID) / SUM(COUNT(Response_ID)) OVER(), 2) AS Percentage
FROM fact_survey_responses
GROUP BY Price_range, Limited_edition_packaging
ORDER BY Response_Count DESC;

SELECT 
    Limited_edition_packaging,
    COUNT(Response_ID) AS Count,
    ROUND(100 * COUNT(Response_ID) / SUM(COUNT(Response_ID)) OVER(), 2) AS Percentage
FROM fact_survey_responses
GROUP BY Limited_edition_packaging
ORDER BY Count DESC;


