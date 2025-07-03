import csv
import sys
from collections import Counter

# Define required CSV fields
REQUIRED_COLUMNS = [
    "firstName",
    "lastName",
    "username",
    "userPrincipalName",
    "department",
    "jobTitle",
    "status"
]

# Valid values for lifecycle state
VALID_STATUSES = {"Join", "Move", "Leave"}


def validate_csv(file_path):
    errors = []
    seen_upns = Counter()

    try:
        with open(file_path, newline='') as csvfile:
            reader = csv.DictReader(csvfile)
            headers = reader.fieldnames

            # Check for missing headers
            for column in REQUIRED_COLUMNS:
                if column not in headers:
                    errors.append(f"Missing required column: '{column}'")

            # Check each row
            for i, row in enumerate(reader, start=2):  # Start at 2 due to header
                row_id = f"Row {i}"

                # Check for missing fields
                for field in REQUIRED_COLUMNS:
                    if not row.get(field):
                        errors.append(f"{row_id}: Missing value in '{field}'")

                # Check status field value
                if row.get("status") not in VALID_STATUSES:
                    errors.append(f"{row_id}: Invalid status '{row.get('status')}'")

                # Track duplicate UPNs
                upn = row.get("userPrincipalName")
                if upn:
                    seen_upns[upn] += 1

        # Report duplicate UPNs
        for upn, count in seen_upns.items():
            if count > 1:
                errors.append(f"Duplicate userPrincipalName found: {upn} (x{count})")

    except FileNotFoundError:
        errors.append(f"File not found: {file_path}")
    except Exception as e:
        errors.append(f"Unexpected error: {str(e)}")

    return errors


if __name__ == "__main__":
    file_path = sys.argv[1] if len(sys.argv) > 1 else "users.csv"
    validation_errors = validate_csv(file_path)

    if validation_errors:
        print("\n=== CSV VALIDATION FAILED ===")
        for err in validation_errors:
            print(f"- {err}")
        sys.exit(1)
    else:
        print("\nCSV is valid. No issues detected.")