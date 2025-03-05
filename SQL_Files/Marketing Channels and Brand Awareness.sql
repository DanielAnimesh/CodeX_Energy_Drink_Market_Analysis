-- Which marketing channel can be used to reach more customers?

SELECT 
	DISTINCT Marketing_channels,
    COUNT(Response_ID) as Count
FROM fact_survey_responses
GROUP BY  Marketing_channels
ORDER BY Count DESC;


-- How effective are different marketing strategies and channels in reaching our customers?

SELECT 
    Marketing_channels,
    COUNT(Response_ID) AS Total_Reach,
    SUM(CASE WHEN Age BETWEEN 15 AND 30 THEN 1 ELSE 0 END) AS Youth_Reach,
    SUM(CASE WHEN Age > 30 THEN 1 ELSE 0 END) AS Adult_Reach,
    SUM(CASE WHEN Consume_frequency IN ('Daily', '2-3 times a week') THEN 1 ELSE 0 END) AS Frequent_Consumers,
    SUM(CASE WHEN Consume_frequency = 'Rarely' THEN 1 ELSE 0 END) AS Infrequent_Consumers
FROM fact_survey_responses frs
JOIN dim_respondents dr 
	ON frs.Respondent_ID = dr.Respondent_ID
GROUP BY Marketing_channels
ORDER BY Total_Reach DESC;

