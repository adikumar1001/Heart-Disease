-- 05_marts_equity_access.sql 
DROP TABLE IF EXISTS mart.equity_gaps;
CREATE TABLE mart.equity_gaps AS
WITH seg AS (
  SELECT load_date, income, education,
         COUNT(*) AS n,
         AVG(heart_disease)::NUMERIC(6,4) AS hd_rate
  FROM brfss.fact_health_indicators
  GROUP BY load_date, income, education
),
income_bounds AS (
  SELECT load_date, MIN(income) AS min_income, MAX(income) AS max_income
  FROM seg
  GROUP BY load_date
)
SELECT
  b.load_date,
  s_low.hd_rate AS low_income_hd,
  s_high.hd_rate AS high_income_hd,
  (s_low.hd_rate - s_high.hd_rate) AS income_prevalence_gap
FROM income_bounds b
JOIN seg s_low  ON s_low.load_date=b.load_date AND s_low.income=b.min_income
JOIN seg s_high ON s_high.load_date=b.load_date AND s_high.income=b.max_income;

DROP TABLE IF EXISTS mart.access_barriers;
CREATE TABLE mart.access_barriers AS
SELECT
  load_date,
  any_healthcare,
  no_docbc_cost,
  COUNT(*) AS respondents,
  AVG(heart_disease)::NUMERIC(6,4) AS heart_disease_rate,
  AVG(gen_hlth)::NUMERIC(6,4) AS avg_gen_hlth,
  AVG(phys_hlth)::NUMERIC(6,4) AS avg_phys_hlth,
  AVG(ment_hlth)::NUMERIC(6,4) AS avg_ment_hlth
FROM brfss.fact_health_indicators
GROUP BY load_date, any_healthcare, no_docbc_cost;

