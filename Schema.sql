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
    Interest_in_natural_or_organic ENUM('Yes', 'No') NOT NULL,  
    Marketing_channels TEXT,  
    Packaging_preference TEXT,  
    Limited_edition_packaging ENUM('Yes', 'No') NOT NULL,  
    Price_range VARCHAR(50),  
    Purchase_location TEXT,  
    Typical_consumption_situations TEXT,  
    FOREIGN KEY (Respondent_ID) REFERENCES dim_respondents(Respondent_ID) ON DELETE CASCADE
);

ALTER TABLE fact_survey_responses  
MODIFY Interest_in_natural_or_organic ENUM('Yes', 'No', 'Not sure');

ALTER TABLE fact_survey_responses  
MODIFY Limited_edition_packaging ENUM('Yes', 'No', 'Not sure');

TRUNCATE TABLE fact_survey_responses;


