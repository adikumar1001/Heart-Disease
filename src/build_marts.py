"""Run SQL scripts to build fact + marts."""
import argparse
from pathlib import Path
from sqlalchemy import create_engine, text

SQL_ORDER = [
    "00_schema.sql",
    "02_transform_star.sql",
    "03_marts_prevalence.sql",
    "04_marts_risk_drivers.sql",
    "05_marts_equity_access.sql",
]

def main():
    p = argparse.ArgumentParser()
    p.add_argument("--db-url", required=True)
    p.add_argument("--sql-dir", default="sql")
    args = p.parse_args()

    engine = create_engine(args.db_url)
    sql_dir = Path(args.sql_dir)

    for fname in SQL_ORDER:
        sql = (sql_dir / fname).read_text(encoding="utf-8")
        with engine.begin() as conn:
            conn.execute(text(sql))
        print(f"Ran {fname}")

    print("Built fact + marts successfully.")

if __name__ == "__main__":
    main()
