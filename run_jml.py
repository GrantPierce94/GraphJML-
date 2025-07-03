import os
import subprocess
from validate_csv import validate_csv

# Validate CSV first
errors = validate_csv("users.csv")
if errors:
    print("CSV Validation failed:")
    for e in errors:
        print(f"- {e}")
    exit(1)

# Run each script
print("Running Joiner...")
subprocess.run(["powershell.exe", "./joiner.ps1"])

print("Running Mover...")
subprocess.run(["powershell.exe", "./mover.ps1"])

print("Running Leaver...")
subprocess.run(["powershell.exe", "./leaver.ps1"])