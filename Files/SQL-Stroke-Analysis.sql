USE  stroke_analysis;
SELECT * FROM health_data;

/*1. Find which gender combined with smoking status has the highest stroke rate */
SELECT 
    Gender,
    `Smoking Status`,
    COUNT(CASE WHEN Stroke = 1 THEN 1 END) * 100.0 / COUNT(*) AS Stroke_Rate
FROM 
    health_data
GROUP BY 
    Gender, `Smoking Status`
ORDER BY 
    Stroke_Rate DESC;

-- 2. Average Glucose Level and BMI Among Smokers and Non-Smokers (Regardless of Stroke)
/* Compare health metrics between smokers and non-smokers */

SELECT 
    `Smoking Status`,
    ROUND(AVG(`Average Glucose Level`), 2) AS `Avg_Glucose_Level`,
    ROUND(AVG(`Body Mass Index`), 2) AS `Avg_BMI`
FROM 
    health_data
WHERE 
    `Smoking Status` != 'Unknown'
GROUP BY 
    `Smoking Status`;

-- 3. Stroke Risk Based on Combined Factors
/* Stroke rate among patients with hypertension, heart disease, and smoking combined */
SELECT 
    `Hypertension`, 
    `Heart Disease`, 
    `Smoking Status`, 
    ROUND(100.0 * SUM(CASE WHEN `Stroke` = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS `Stroke_Rate`
FROM health_data
WHERE `Smoking Status` != 'Unknown'
GROUP BY `Hypertension`, `Heart Disease`, `Smoking Status`
ORDER BY `Stroke_Rate` DESC;

-- 4. Stroke Rate Based on BMI Ranges
/* Stroke rate by BMI categories */
SELECT 
    CASE 
        WHEN `Body Mass Index` < 18.5 THEN 'Underweight'
        WHEN `Body Mass Index` BETWEEN 18.5 AND 24.9 THEN 'Normal'
        WHEN `Body Mass Index` BETWEEN 25 AND 29.9 THEN 'Overweight'
        ELSE 'Obese'
    END AS `BMI_Category`,
    ROUND(100.0 * SUM(CASE WHEN `Stroke` = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS `Stroke_Rate`
FROM health_data
GROUP BY 
    CASE 
        WHEN `Body Mass Index` < 18.5 THEN 'Underweight'
        WHEN `Body Mass Index` BETWEEN 18.5 AND 24.9 THEN 'Normal'
        WHEN `Body Mass Index` BETWEEN 25 AND 29.9 THEN 'Overweight'
        ELSE 'Obese'
    END
ORDER BY `Stroke_Rate` DESC;

-- 5. Stroke Rate Among Different Work Types and Residence Types Combined
/* Stroke rate based on work and residence type */
SELECT 
    `Work Type`, 
    `Residence Type`, 
    ROUND(100.0 * SUM(CASE WHEN `Stroke` = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS `Stroke_Rate`
FROM health_data
GROUP BY `Work Type`, `Residence Type`
ORDER BY `Stroke_Rate` DESC;


-- 6. Impact of Combined Risk Factors on Stroke
/* Stroke rate for combinations of smoking status, hypertension, and heart disease */
SELECT 
    `Smoking Status`,
    `Hypertension`,
    `Heart Disease`,
    ROUND(AVG(CASE WHEN `Stroke` = 1 THEN 1 ELSE 0 END) * 100, 2) AS `stroke_rate`
FROM 
    health_data
GROUP BY 
    `Smoking Status`, `Hypertension`, `Heart Disease`

ORDER BY stroke_rate desc ;
