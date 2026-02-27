-- 00_schema.sql
CREATE SCHEMA IF NOT EXISTS brfss;
CREATE SCHEMA IF NOT EXISTS mart;

DROP TABLE IF EXISTS brfss.stg_heart_raw;
CREATE TABLE brfss.stg_heart_raw (
  heartdiseaseorattack TEXT,
  highbp TEXT,
  highchol TEXT,
  cholcheck TEXT,
  bmi TEXT,
  smoker TEXT,
  stroke TEXT,
  diabetes TEXT,
  physactivity TEXT,
  fruits TEXT,
  veggies TEXT,
  hvyalcoholconsump TEXT,
  anyhealthcare TEXT,
  nodocbccost TEXT,
  genhlth TEXT,
  menthlth TEXT,
  physhlth TEXT,
  diffwalk TEXT,
  sex TEXT,
  age TEXT,
  education TEXT,
  income TEXT
);

DROP TABLE IF EXISTS brfss.fact_health_indicators;
CREATE TABLE brfss.fact_health_indicators (
  person_id BIGSERIAL PRIMARY KEY,
  load_date DATE NOT NULL DEFAULT CURRENT_DATE,

  heart_disease SMALLINT NOT NULL,
  high_bp SMALLINT NOT NULL,
  high_chol SMALLINT NOT NULL,
  chol_check SMALLINT NOT NULL,
  bmi NUMERIC(5,2),

  smoker SMALLINT NOT NULL,
  stroke SMALLINT NOT NULL,
  diabetes SMALLINT NOT NULL,
  phys_activity SMALLINT NOT NULL,
  fruits SMALLINT NOT NULL,
  veggies SMALLINT NOT NULL,
  hvy_alcohol SMALLINT NOT NULL,
  any_healthcare SMALLINT NOT NULL,
  no_docbc_cost SMALLINT NOT NULL,

  gen_hlth SMALLINT,
  ment_hlth SMALLINT,
  phys_hlth SMALLINT,

  diff_walk SMALLINT NOT NULL,
  sex SMALLINT NOT NULL,
  age_group SMALLINT NOT NULL,
  education SMALLINT NOT NULL,
  income SMALLINT NOT NULL,

  bmi_band TEXT,
  risk_score SMALLINT,
  risk_tier TEXT
);

CREATE INDEX IF NOT EXISTS idx_fact_age_sex ON brfss.fact_health_indicators (age_group, sex);
CREATE INDEX IF NOT EXISTS idx_fact_income_edu ON brfss.fact_health_indicators (income, education);
CREATE INDEX IF NOT EXISTS idx_fact_hd ON brfss.fact_health_indicators (heart_disease);

