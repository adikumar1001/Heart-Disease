"""Data quality checks."""
import argparse
from pathlib import Path
from sqlalchemy import create_engine, text
import datetime as dt

CHECKS = [
    ("row_count", "SELECT COUNT(*) AS n FROM brfss.fact_health_indicators"),
    ("invalid_target", "SELECT COUNT(*) AS n_invalid FROM brfss.fact_health_indicators WHERE heart_disease NOT IN (0,1)"),
    ("null_bmi_pct", "SELECT ROUND(100.0*AVG(CASE WHEN bmi IS NULL THEN 1 ELSE 0 END), 3) AS pct FROM brfss.fact_health_indicators"),
    ("bmi_out_of_range", "SELECT COUNT(*) AS n_bad FROM brfss.fact_health_indicators WHERE bmi IS NOT NULL AND (bmi < 10 OR bmi > 80)")
]

def main():
    p = argparse.ArgumentParser()
    p.add_argument("--db-url", required=True)
    p.add_argument("--out", required=True)
    args = p.parse_args()

    engine = create_engine(args.db_url)
    results = {}
    with engine.connect() as conn:
        for name, q in CHECKS:
            results[name] = dict(conn.execute(text(q)).mappings().first())

    lines = [
        "# Data Quality Report — BRFSS Heart Disease",
        "",
        f"Generated: {dt.datetime.now().isoformat(timespec='seconds')}",
        "",
        "## Checks",
    ]
    for k,v in results.items():
        lines.append(f"- **{k}**: `{v}`")

    out_path = Path(args.out)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text("\n".join(lines), encoding="utf-8")
    print(f"Wrote {out_path}")

if __name__ == "__main__":
    main()
