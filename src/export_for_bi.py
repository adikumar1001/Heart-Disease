"""Export marts to CSV for Power BI/Tableau."""
import argparse
from pathlib import Path
import pandas as pd
from sqlalchemy import create_engine

MARTS = [
    "mart.prevalence_overview",
    "mart.prevalence_by_segment",
    "mart.risk_factor_impact",
    "mart.equity_gaps",
    "mart.access_barriers",
]

def main():
    p = argparse.ArgumentParser()
    p.add_argument("--db-url", required=True)
    p.add_argument("--out-dir", default="exports")
    args = p.parse_args()

    engine = create_engine(args.db_url)
    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    for t in MARTS:
        df = pd.read_sql(f"SELECT * FROM {t}", engine)
        out = out_dir / f"{t.replace('.', '__')}.csv"
        df.to_csv(out, index=False)
        print(f"Exported {t} -> {out}")

if __name__ == "__main__":
    main()
