# mover.ps1
# Purpose: Update department or job title for existing Entra ID users using Microsoft Graph

# Load user data from CSV
$users = Import-Csv -Path ".\users.csv"
$tenantDomain = "grantpierce94gmail.onmicrosoft.com"

# Ensure log directory exists
$logPath = "logs\mover_log.txt"
if (-not (Test-Path -Path "logs")) {
    New-Item -ItemType Directory -Path "logs" | Out-Null
}

foreach ($user in $users) {
    if ($user.status -ne "Move") {
        continue
    }

    $userPrincipalName = "$($user.username)@$tenantDomain"

    try {
        # Validate user exists
        Get-MgUser -UserId $userPrincipalName -ErrorAction Stop

        # Update department and job title
        Update-MgUser -UserId $userPrincipalName `
            -Department $user.department `
            -JobTitle $user.jobTitle

        $logEntry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | MOVER | Updated ${userPrincipalName} to department: ${($user.department)}, title: ${($user.jobTitle)}"
        Write-Host "Successfully updated user ${userPrincipalName}"
    }
    catch {
        $logEntry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | MOVER | Error updating ${userPrincipalName}: $_"
        Write-Host "Error updating user ${userPrincipalName}"
    }

    Add-Content -Path $logPath -Value $logEntry
}