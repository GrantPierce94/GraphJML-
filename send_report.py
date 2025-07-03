from datetime import datetime
import os

LOG_FILES = {
    "Joiner": "logs/joiner_log.txt",
    "Mover": "logs/mover_log.txt",
    "Leaver": "logs/leaver_log.txt"
}

def parse_log(path):
    entries = []
    if not os.path.exists(path):
        return entries

    with open(path, "r") as log_file:
        for line in log_file:
            try:
                date_str, stage, message = line.strip().split(" | ", 2)
                entries.append((datetime.strptime(date_str, "%Y-%m-%d %H:%M:%S"), stage, message))
            except ValueError:
                entries.append(("N/A", "MALFORMED", line.strip()))
    return entries

def print_report():
    print("\n=== Daily Identity Lifecycle Report ===\n")
    total_entries = 0

    for stage, path in LOG_FILES.items():
        print(f"--- {stage.upper()} LOG ---")
        entries = parse_log(path)
        if not entries:
            print("No entries found.\n")
            continue

        for entry in entries:
            print(f"{entry[0]} | {entry[1]} → {entry[2]}")
        print("")
        total_entries += len(entries)

    print(f"Total lifecycle events recorded: {total_entries}\n")

if __name__ == "__main__":
    print_report()