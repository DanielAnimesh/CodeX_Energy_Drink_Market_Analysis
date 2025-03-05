# **Consumer Insights SQL Analysis**

## **📌 Project Overview**

This project analyzes consumer survey responses related to energy drink preferences, purchase behavior, and brand perception using SQL queries. The goal is to derive insights into consumer preferences, effective marketing channels, and product development strategies.

## **📂 Dataset Description**

The project utilizes three key tables:

- ``: Contains demographic details of respondents.
- ``: Lists city details and tier classifications.
- ``: Contains survey responses, including purchase behavior, marketing influence, and brand perception.

## **📊 Key Business Questions & SQL Queries**

### **1️⃣ Who prefers energy drinks more (Male/Female/Non-Binary)?**

```sql
SELECT Gender, COUNT(*) AS Count
FROM dim_respondents
GROUP BY Gender
ORDER BY Count DESC;
```

📌 **Insight:** Identifies the dominant consumer gender.

---

### **2️⃣ Which marketing channel reaches the most youth (15-30)?**

```sql
SELECT Marketing_channels, COUNT(*) AS Youth_Count
FROM fact_survey_responses frs
JOIN dim_respondents dr ON dr.Respondent_ID = frs.Respondent_ID
WHERE dr.Age BETWEEN 15 AND 30
GROUP BY Marketing_channels
ORDER BY Youth_Count DESC;
```

📌 **Insight:** Helps optimize marketing spend by focusing on high-reach channels.

---

### **3️⃣ What are the key factors influencing purchase decisions (Price & Packaging)?**

```sql
SELECT Price_range, COUNT(Response_ID) AS Response_Count,
ROUND(100 * COUNT(Response_ID) / SUM(COUNT(Response_ID)) OVER(), 2) AS Percentage
FROM fact_survey_responses
GROUP BY Price_range
ORDER BY Response_Count DESC;
```

📌 **Insight:** Determines the most popular price ranges among consumers.

---

### **4️⃣ What do people think about our brand? (Overall Perception & Taste Experience)**

```sql
SELECT Brand_perception, COUNT(Response_ID) AS Count,
ROUND(100 * COUNT(Response_ID) / SUM(COUNT(Response_ID)) OVER(), 2) AS Percentage
FROM fact_survey_responses
GROUP BY Brand_perception
ORDER BY Count DESC;
```

📌 **Insight:** Assesses brand image and potential improvement areas.

---

### **5️⃣ Who are the current market leaders?**

```sql
SELECT Current_brands, COUNT(Response_ID) AS Count
FROM fact_survey_responses
GROUP BY Current_brands
ORDER BY Count DESC;
```

📌 **Insight:** Identifies dominant competitors in the market.

---

### **6️⃣ What are the primary reasons consumers prefer competitors?**

```sql
WITH RankedReasons AS (
    SELECT Current_brands, Reasons_for_choosing_brands, COUNT(Response_ID) AS Count,
    ROW_NUMBER() OVER (PARTITION BY Current_brands ORDER BY COUNT(Response_ID) DESC) AS Rank
    FROM fact_survey_responses
    WHERE Current_brands != 'CodeX'
    GROUP BY Current_brands, Reasons_for_choosing_brands
)
SELECT Current_brands, Reasons_for_choosing_brands AS Best_Reason, Count
FROM RankedReasons WHERE Rank = 1
ORDER BY Count DESC;
```

📌 **Insight:** Helps in competitive analysis to improve our product positioning.

---

### **7️⃣ Where do respondents prefer to purchase energy drinks?**

```sql
SELECT Purchase_location, COUNT(Response_ID) AS Count
FROM fact_survey_responses
GROUP BY Purchase_location
ORDER BY Count DESC;
```

📌 **Insight:** Guides distribution strategy based on consumer preferences.

---

### **8️⃣ Which cities should we focus on for expansion?**

```sql
SELECT dc.City, dc.Tier, COUNT(dr.Respondent_ID) AS Count
FROM dim_respondents dr
JOIN dim_cities dc ON dc.City_ID = dr.City_ID
GROUP BY dc.City, dc.Tier
ORDER BY Count DESC;
```

📌 **Insight:** Identifies key cities with high potential for growth.

---

## **📊 Visualization & Reporting**

For better insights, the SQL results can be visualized using:

- **Power BI** 📊 (Dashboards for brand perception, sales trends, and customer segmentation)
- **Excel Pivot Tables & Charts** 📈 (Trend analysis and segmentation reports)

---

## **📝 Key Takeaways & Business Recommendations**

✅ **Target younger consumers (15-30) via social media & influencer marketing.**\
✅ **Focus on ₹50-₹99 price range, as it's the most preferred.**\
✅ **Enhance taste and availability to compete with market leaders.**\
✅ **Expand to high-response cities for maximum brand penetration.**

---

## **📌 How to Use the Queries**

1️⃣ Clone this repository.\
2️⃣ Load the dataset into your SQL environment.\
3️⃣ Run the queries to generate insights.\
4️⃣ Use Power BI/Excel to visualize the data for presentations.

📢 Feel free to contribute and suggest improvements! 🚀

---

## **📞 Contact**

📧 **Email:** [your\_email@example.com](mailto\:your_email@example.com)\
💼 **LinkedIn:** [Your Profile](https://linkedin.com/in/yourprofile)

