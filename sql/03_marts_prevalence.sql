-- 03_marts_prevalence.sql (OK)
DROP TABLE IF EXISTS mart.prevalence_overview;
CREATE TABLE mart.prevalence_overview AS
SELECT
  load_date,
  COUNT(*) AS respondents,
  AVG(heart_disease)::NUMERIC(6,4) AS heart_disease_rate,
  AVG(high_bp)::NUMERIC(6,4) AS high_bp_rate,
  AVG(high_chol)::NUMERIC(6,4) AS high_chol_rate,
  AVG(diabetes)::NUMERIC(6,4) AS diabetes_rate,
  AVG(smoker)::NUMERIC(6,4) AS smoker_rate,
  AVG(phys_activity)::NUMERIC(6,4) AS phys_activity_rate
FROM brfss.fact_health_indicators
GROUP BY load_date;

DROP TABLE IF EXISTS mart.prevalence_by_segment;
CREATE TABLE mart.prevalence_by_segment AS
SELECT
  load_date,
  age_group,
  sex,
  income,
  education,
  bmi_band,
  risk_tier,
  COUNT(*) AS respondents,
  AVG(heart_disease)::NUMERIC(6,4) AS heart_disease_rate
FROM brfss.fact_health_indicators
GROUP BY load_date, age_group, sex, income, education, bmi_band, risk_tier;

