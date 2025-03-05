-- What do people think about our brand? 


SELECT 
    Brand_perception,
    COUNT(*) AS Count
FROM fact_survey_responses
GROUP BY Brand_perception
ORDER BY Count DESC
LIMIT 1; 


-- Which cities do we need to focus more on?

SELECT 
    dc.City,
	dc.Tier,
	COUNT(Respondent_ID) as Count
FROM dim_respondents dr
join dim_cities dc
	on dc.City_ID = dr.City_ID
GROUP BY  dc.City, dc.Tier
ORDER BY Count DESC;

