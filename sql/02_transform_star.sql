-- 02_transform_star.sql 
TRUNCATE TABLE brfss.fact_health_indicators RESTART IDENTITY;

WITH cleaned AS (
  SELECT
    -- convert "0.0" -> "0" then cast; treat blanks as NULL
    NULLIF(REGEXP_REPLACE(heartdiseaseorattack, '\.0$', ''), '')::INT AS heart_disease,
    NULLIF(REGEXP_REPLACE(highbp, '\.0$', ''), '')::INT AS high_bp,
    NULLIF(REGEXP_REPLACE(highchol, '\.0$', ''), '')::INT AS high_chol,
    NULLIF(REGEXP_REPLACE(cholcheck, '\.0$', ''), '')::INT AS chol_check,
    NULLIF(bmi, '')::NUMERIC(5,2) AS bmi,

    NULLIF(REGEXP_REPLACE(smoker, '\.0$', ''), '')::INT AS smoker,
    NULLIF(REGEXP_REPLACE(stroke, '\.0$', ''), '')::INT AS stroke,
    NULLIF(REGEXP_REPLACE(diabetes, '\.0$', ''), '')::INT AS diabetes,
    NULLIF(REGEXP_REPLACE(physactivity, '\.0$', ''), '')::INT AS phys_activity,
    NULLIF(REGEXP_REPLACE(fruits, '\.0$', ''), '')::INT AS fruits,
    NULLIF(REGEXP_REPLACE(veggies, '\.0$', ''), '')::INT AS veggies,
    NULLIF(REGEXP_REPLACE(hvyalcoholconsump, '\.0$', ''), '')::INT AS hvy_alcohol,
    NULLIF(REGEXP_REPLACE(anyhealthcare, '\.0$', ''), '')::INT AS any_healthcare,
    NULLIF(REGEXP_REPLACE(nodocbccost, '\.0$', ''), '')::INT AS no_docbc_cost,

    NULLIF(REGEXP_REPLACE(genhlth, '\.0$', ''), '')::INT AS gen_hlth,
    NULLIF(REGEXP_REPLACE(menthlth, '\.0$', ''), '')::INT AS ment_hlth,
    NULLIF(REGEXP_REPLACE(physhlth, '\.0$', ''), '')::INT AS phys_hlth,

    NULLIF(REGEXP_REPLACE(diffwalk, '\.0$', ''), '')::INT AS diff_walk,
    NULLIF(REGEXP_REPLACE(sex, '\.0$', ''), '')::INT AS sex,
    NULLIF(REGEXP_REPLACE(age, '\.0$', ''), '')::INT AS age_group,
    NULLIF(REGEXP_REPLACE(education, '\.0$', ''), '')::INT AS education,
    NULLIF(REGEXP_REPLACE(income, '\.0$', ''), '')::INT AS income
  FROM brfss.stg_heart_raw
),
scored AS (
  SELECT
    *,
    CASE
      WHEN bmi IS NULL THEN 'Unknown'
      WHEN bmi < 18.5 THEN 'Underweight'
      WHEN bmi < 25 THEN 'Normal'
      WHEN bmi < 30 THEN 'Overweight'
      ELSE 'Obese'
    END AS bmi_band,

    (
      (CASE WHEN high_bp = 1 THEN 2 ELSE 0 END) +
      (CASE WHEN high_chol = 1 THEN 1 ELSE 0 END) +
      (CASE WHEN diabetes = 1 THEN 2 ELSE 0 END) +
      (CASE WHEN smoker = 1 THEN 1 ELSE 0 END) +
      (CASE WHEN stroke = 1 THEN 2 ELSE 0 END) +
      (CASE WHEN diff_walk = 1 THEN 1 ELSE 0 END) +
      (CASE WHEN bmi IS NOT NULL AND bmi >= 30 THEN 1 ELSE 0 END)
    ) AS risk_score
  FROM cleaned
)
INSERT INTO brfss.fact_health_indicators (
  heart_disease, high_bp, high_chol, chol_check, bmi,
  smoker, stroke, diabetes, phys_activity, fruits, veggies, hvy_alcohol,
  any_healthcare, no_docbc_cost,
  gen_hlth, ment_hlth, phys_hlth,
  diff_walk, sex, age_group, education, income,
  bmi_band, risk_score, risk_tier
)
SELECT
  heart_disease::SMALLINT,
  high_bp::SMALLINT,
  high_chol::SMALLINT,
  chol_check::SMALLINT,
  bmi,

  smoker::SMALLINT,
  stroke::SMALLINT,
  diabetes::SMALLINT,
  phys_activity::SMALLINT,
  fruits::SMALLINT,
  veggies::SMALLINT,
  hvy_alcohol::SMALLINT,
  any_healthcare::SMALLINT,
  no_docbc_cost::SMALLINT,

  gen_hlth::SMALLINT,
  ment_hlth::SMALLINT,
  phys_hlth::SMALLINT,

  diff_walk::SMALLINT,
  sex::SMALLINT,
  age_group::SMALLINT,
  education::SMALLINT,
  income::SMALLINT,

  bmi_band,
  risk_score::SMALLINT,
  CASE
    WHEN risk_score >= 6 THEN 'High'
    WHEN risk_score >= 3 THEN 'Medium'
    ELSE 'Low'
  END AS risk_tier
FROM scored;
