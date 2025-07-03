# leaver.ps1
# Purpose: Securely disable Entra ID users marked as "Leavers" using Microsoft Graph

# Load user data from CSV
$users = Import-Csv -Path ".\users.csv"
$tenantDomain = "grantpierce94gmail.onmicrosoft.com"

# Ensure log directory exists
$logPath = "logs\leaver_log.txt"
if (-not (Test-Path -Path "logs")) {
    New-Item -ItemType Directory -Path "logs" | Out-Null
}

foreach ($user in $users) {
    if ($user.status -ne "Leave") {
        continue
    }

    $userPrincipalName = "$($user.username)@$tenantDomain"

    try {
        # Validate user exists
        Get-MgUser -UserId $userPrincipalName -ErrorAction Stop

        # Disable account and reassign metadata
        Update-MgUser -UserId $userPrincipalName `
            -AccountEnabled $false `
            -Department "Ex-Employees" `
            -JobTitle "Former Employee"

        $logEntry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | LEAVER | Disabled and moved ${userPrincipalName} to Ex-Employees"
        Write-Host "Processed leaver: ${userPrincipalName}"
    }
    catch {
        $logEntry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | LEAVER | Error processing ${userPrincipalName}: $_"
        Write-Host "Error disabling user ${userPrincipalName}"
    }

    Add-Content -Path $logPath -Value $logEntry
}