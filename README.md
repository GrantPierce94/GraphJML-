# GraphJML – Entra ID Joiner-Mover-Leaver Lifecycle Automation with Python & PowerShell

**GraphJML** is a modular, script-driven identity lifecycle engine that automates Joiner, Mover, and Leaver (JML) workflows for Microsoft Entra ID (formerly Azure AD). Built using Python and PowerShell, this project simulates real-world IAM practices like user provisioning, department transfers, and secure offboarding using Microsoft Graph API.

It reflects the core identity governance principles expected in enterprise environments — automating the most critical access control checkpoints throughout the user lifecycle.

## Identity Lifecycle Scope

- **Joiner Automation**  
  Creates Entra ID user accounts based on structured HR data input (CSV), assigns licenses, groups, and manager metadata.

- **Mover Automation**  
  Updates existing users based on department or role changes. Automatically reassigns groups and updates directory attributes.

- **Leaver Automation**  
  Disables accounts, removes group memberships, and logs termination events for offboarding compliance.

- **Audit-Ready Event Logging**  
  Python-based log monitor tracks script execution events and results for audit and troubleshooting purposes.

## Project Features

- **CSV-Driven Lifecycle Input**  
  Uses mock HR export (CSV format) as the source-of-truth for users and lifecycle stage (Join, Move, Leave).

- **Microsoft Graph API Integration**  
  All user changes are made securely using Microsoft Graph with scoped application permissions.

- **Modular Scripts**  
  Each phase (Joiner, Mover, Leaver) is its own script for clean isolation and independent testing.

- **Audit Logging**  
  Python service logs outputs for each lifecycle stage to simulate enterprise-level tracking.

## Architecture Overview

### Languages & Structure

- **PowerShell**: For direct Graph API calls and user management commands  
- **Python**: For log monitoring and future stateful JML orchestration  
- **Microsoft Graph API**: For secure identity operations

## Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/graphjml.git
   cd graphjml

Install dependencies:
```
pip install -r requirements.txt
```

Prepare your credentials.ps1 or environment-based token loader with:

Tenant ID

App ID

Secret or certificate

Permissions: User.ReadWrite.All, Group.ReadWrite.All, Directory.AccessAsUser.All

Prepare your CSV input (e.g., users.csv):
```
firstName,lastName,userPrincipalName,department,jobTitle,status
Jane,Doe,jane.doe@yourdomain.com,Engineering,Developer,Join
John,Smith,john.smith@yourdomain.com,Marketing,Manager,Leave
```

## Usage

Joiner: Create new users and assign metadata
```
./joiner.ps1
```
Mover: Update department, title, or group memberships
```
./mover.ps1
```
Leaver: Disable accounts and remove group access
```
./leaver.ps1
```
Monitor Logs:
```
python log_monitor.py
```

## Repository Structure
```
graphjml/
├── joiner.ps1            # Creates new users in Entra ID
├── mover.ps1             # Modifies department/job title of existing users
├── leaver.ps1            # Disables accounts and strips access
├── validate_csv.py       # Verifies structure and values of the users.csv file
├── send_report.py        # Summarizes and prints out the log reports
├── users.csv             # Input file with mock HR data
├── logs/                 # Output directory for audit logs
├── requirements.txt      # Python dependencies
└── README.md             # Full explanation
```

## Tools & Technologies
PowerShell 7+

Python 3.10+

Microsoft Graph API (v1.0)

Microsoft Entra ID

CSV as HR system simulation

## Contributors
Grant Pierce (GitHub: @GrantPierce94) – Developer

Designed modular JML lifecycle logic based on enterprise IAM frameworks

Implemented Joiner, Mover, and Leaver automation using Microsoft Graph

Built Python logging to simulate SIEM/event pipeline integration

Focused on identity lifecycle control, offboarding compliance, and automation maturity

