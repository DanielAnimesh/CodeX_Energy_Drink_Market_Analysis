-- Competition Analysis

-- Who are the current market leaders?

SELECT 
	DISTINCT Current_brands,
    COUNT(Response_ID) as Count
FROM fact_survey_responses
GROUP BY  Current_brands
ORDER BY Count DESC;

-- What are the primary reasons consumers prefer those brands over ours?

WITH RankedReasons AS (
    SELECT 
        Current_brands,
        Reasons_for_choosing_brands,
        COUNT(Response_ID) AS Count,
        ROW_NUMBER() OVER (PARTITION BY Current_brands ORDER BY COUNT(Response_ID) DESC) AS RankedNum
    FROM fact_survey_responses
    WHERE Current_brands != 'CodeX'
    GROUP BY Current_brands, Reasons_for_choosing_brands
)
SELECT 
    Current_brands, 
    Reasons_for_choosing_brands AS Best_Reason,
    Count
FROM RankedReasons
WHERE RankedNum = 1
ORDER BY Count DESC;



