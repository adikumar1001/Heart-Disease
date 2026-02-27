-- 04_marts_risk_drivers.sql 
DROP TABLE IF EXISTS mart.risk_factor_impact;
CREATE TABLE mart.risk_factor_impact AS
WITH base AS (
  SELECT load_date, heart_disease,
         high_bp, high_chol, smoker, diabetes, stroke, diff_walk, phys_activity,
         fruits, veggies, hvy_alcohol, no_docbc_cost, any_healthcare,
         (CASE WHEN bmi >= 30 THEN 1 ELSE 0 END) AS obese
  FROM brfss.fact_health_indicators
)
SELECT
  load_date,
  factor,
  factor_value,
  COUNT(*) AS respondents,
  AVG(heart_disease)::NUMERIC(6,4) AS heart_disease_rate
FROM (
  SELECT load_date, heart_disease, 'high_bp' AS factor, high_bp AS factor_value FROM base
  UNION ALL SELECT load_date, heart_disease, 'high_chol', high_chol FROM base
  UNION ALL SELECT load_date, heart_disease, 'smoker', smoker FROM base
  UNION ALL SELECT load_date, heart_disease, 'diabetes', diabetes FROM base
  UNION ALL SELECT load_date, heart_disease, 'stroke', stroke FROM base
  UNION ALL SELECT load_date, heart_disease, 'diff_walk', diff_walk FROM base
  UNION ALL SELECT load_date, heart_disease, 'phys_activity', phys_activity FROM base
  UNION ALL SELECT load_date, heart_disease, 'fruits', fruits FROM base
  UNION ALL SELECT load_date, heart_disease, 'veggies', veggies FROM base
  UNION ALL SELECT load_date, heart_disease, 'hvy_alcohol', hvy_alcohol FROM base
  UNION ALL SELECT load_date, heart_disease, 'no_docbc_cost', no_docbc_cost FROM base
  UNION ALL SELECT load_date, heart_disease, 'any_healthcare', any_healthcare FROM base
  UNION ALL SELECT load_date, heart_disease, 'obese', obese FROM base
) u
GROUP BY load_date, factor, factor_value;

