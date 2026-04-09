# Population Health Analytics: Heart Disease Risk & Equity (BRFSS 2015)

An end-to-end healthcare analytics project built on the **BRFSS 2015 Heart Disease Health Indicators** dataset to analyze **heart disease prevalence, risk drivers, and equity/access gaps**.  
The project combines **PostgreSQL, SQL, Python, and BI-ready outputs** to create a reproducible analytics workflow from raw data ingestion to reporting. :contentReference[oaicite:1]{index=1}

## Project Overview

This project was designed to answer questions such as:

- How prevalent is heart disease across different demographic groups?
- Which health and lifestyle factors are most associated with heart disease risk?
- Where do equity and healthcare access gaps appear across the population?
- How can raw public health data be transformed into decision-ready reporting outputs?

The workflow includes:

- **PostgreSQL staging tables** for raw data loading
- A **typed fact table** with cleaned and structured records
- **Derived features** such as BMI band and risk tier
- **SQL marts** for prevalence, risk factors, and equity/access analysis
- **Python automation** for load → build → QA → export
- **Dashboard-ready outputs** for Power BI or Tableau :contentReference[oaicite:2]{index=2}

---

## Tech Stack

- **Database:** PostgreSQL
- **Languages:** SQL, Python
- **Visualization:** Power BI / Tableau
- **Workflow:** ETL, QA checks, data marts, export automation

---

## Dataset

This project uses the **BRFSS 2015 Heart Disease Health Indicators** dataset, a public health dataset containing demographic, behavioral, and health-related indicators used to study heart disease patterns.

Example fields include:

- Heart disease status
- BMI
- Smoking
- Physical activity
- Diabetes
- General health
- Age group
- Income
- Healthcare access indicators

---

## Architecture

The project follows a simple analytics engineering flow:

```text
Raw Data
   ↓
Staging Tables
   ↓
Typed Fact Table
   ↓
Derived Features
   ↓
SQL Marts
   ↓
QA Checks + Exports
   ↓
BI Dashboard / Reporting
