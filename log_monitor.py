# log_monitor.py
# Purpose: Parse and display formatted JML lifecycle logs from log files

from datetime import datetime

def parse_log(path):
    print(f"\n=== Parsing {path} ===\n")
    try:
        with open(path, "r") as log:
            for line in log:
                try:
                    date, stage, message = line.strip().split(" | ", 2)
                    print(f"[{stage}] {date} → {message}")
                except ValueError:
                    print(f"Malformed log entry: {line.strip()}")
    except FileNotFoundError:
        print(f"No log found at: {path}")

if __name__ == "__main__":
    parse_log("logs/joiner_log.txt")
    parse_log("logs/mover_log.txt")
    parse_log("logs/leaver_log.txt")