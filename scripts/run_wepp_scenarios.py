"""Command-line entry point for WEPP batch runs."""

from __future__ import annotations

import argparse
import logging

from wepp_climate import WeppRunner, load_config


def main() -> int:
    parser = argparse.ArgumentParser(description="Run a WEPP management × climate experiment.")
    parser.add_argument("--config", required=True, help="YAML configuration file.")
    parser.add_argument("--stop-on-error", action="store_true")
    args = parser.parse_args()

    logging.basicConfig(level=logging.INFO, format="%(levelname)s %(message)s")
    runner = WeppRunner(load_config(args.config))
    results = runner.run_all(stop_on_error=args.stop_on_error)

    failed = [result for result in results if result.returncode != 0]
    print(f"Completed {len(results)} WEPP runs; failures: {len(failed)}")
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
