-- Product Development

-- Which area of business should we focus more on our product development? (Branding/taste/availability)

SELECT 
    Brand_perception,
    COUNT(Response_ID) AS Count,
    ROUND(100 * COUNT(Response_ID) / SUM(COUNT(Response_ID)) OVER(), 2) AS Percentage
FROM fact_survey_responses
GROUP BY Brand_perception
ORDER BY Count DESC;

SELECT 
    Taste_experience,
    COUNT(Response_ID) AS Count,
    ROUND(100 * COUNT(Response_ID) / SUM(COUNT(Response_ID)) OVER(), 2) AS Percentage
FROM fact_survey_responses
WHERE Taste_experience IS NOT NULL
GROUP BY Taste_experience
ORDER BY Count DESC;



SELECT 
    Reasons_for_choosing_brands,
    COUNT(Response_ID) AS Count,
    ROUND(100 * COUNT(Response_ID) / SUM(COUNT(Response_ID)) OVER(), 2) AS Percentage
FROM fact_survey_responses
GROUP BY Reasons_for_choosing_brands
ORDER BY Count DESC;






