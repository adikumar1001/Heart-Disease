from __future__ import annotations
import argparse
import pandas as pd
from sqlalchemy import create_engine, text

STAGING_SCHEMA = "brfss"
STAGING_TABLE = "stg_heart_raw"

# lowercase expected columns (matches how Postgres stored your table)
EXPECTED_COLS = [
    "heartdiseaseorattack","highbp","highchol","cholcheck","bmi","smoker","stroke",
    "diabetes","physactivity","fruits","veggies","hvyalcoholconsump","anyhealthcare",
    "nodocbccost","genhlth","menthlth","physhlth","diffwalk","sex","age","education","income"
]

def main():
    p = argparse.ArgumentParser()
    p.add_argument("--db-url", required=True)
    p.add_argument("--csv", required=True)
    p.add_argument("--read-chunksize", type=int, default=50000)
    p.add_argument("--insert-chunksize", type=int, default=1000)  # keeps INSERT small
    args = p.parse_args()

    engine = create_engine(args.db_url)

    with engine.begin() as conn:
        conn.execute(text(f"TRUNCATE TABLE {STAGING_SCHEMA}.{STAGING_TABLE};"))

    total = 0
    first = True

    for chunk in pd.read_csv(args.csv, chunksize=args.read_chunksize):
        # Lowercase CSV column names to match Postgres table columns
        chunk.columns = [c.strip().lower() for c in chunk.columns]

        if first:
            print("CSV PATH:", args.csv)
            print("CSV COLS (lowercased):", chunk.columns.tolist())
            first = False

        missing = [c for c in EXPECTED_COLS if c not in chunk.columns]
        if missing:
            raise ValueError(f"CSV missing required columns: {missing}")

        chunk = chunk[EXPECTED_COLS]

        # staging is TEXT => send strings, replace NaN with empty string
        chunk = chunk.astype("object").where(pd.notnull(chunk), "")
        chunk = chunk.astype(str)

        chunk.to_sql(
            name=STAGING_TABLE,
            con=engine,
            schema=STAGING_SCHEMA,
            if_exists="append",
            index=False,
            method="multi",
            chunksize=args.insert_chunksize,
        )

        total += len(chunk)
        print(f"Loaded {total} rows...")

    print(f"✅ Loaded staging successfully. Total rows: {total}")

if __name__ == "__main__":
    main()
