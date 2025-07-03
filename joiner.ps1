# joiner.ps1
# Purpose: Provision new Entra ID users from CSV input using Microsoft Graph API

# Load user data
$users = Import-Csv -Path ".\users.csv"
$tenantDomain = "grantpierce94gmail.onmicrosoft.com"

# Create log folder if needed
$logPath = "logs\joiner_log.txt"
if (-not (Test-Path -Path "logs")) {
    New-Item -ItemType Directory -Path "logs" | Out-Null
}

foreach ($user in $users) {
    $userPrincipalName = "$($user.username)@$tenantDomain"

    # Check if user exists
    $existingUser = Get-MgUser -Filter "userPrincipalName eq '$userPrincipalName'" -ErrorAction SilentlyContinue
    if ($existingUser) {
        Write-Host "User $userPrincipalName already exists. Skipping."
        continue
    }

    # Create user object
    $passwordProfile = @{
        ForceChangePasswordNextSignIn = $true
        Password = "P@ssw0rd123!"
    }

    $userParams = @{
        AccountEnabled    = $true
        DisplayName       = $user.display_name
        MailNickname      = $user.username
        UserPrincipalName = $userPrincipalName
        Department        = $user.department
        JobTitle          = $user.jobTitle
        PasswordProfile   = $passwordProfile
    }

    try {
        New-MgUser @userParams
        $logEntry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | JOINER | Created user $userPrincipalName in department: $($user.department)"
        Write-Host "Created user $userPrincipalName"
    } catch {
        $logEntry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | JOINER | Error creating $userPrincipalName - $_"
        Write-Host "Failed to create user $userPrincipalName"
    }

    Add-Content -Path $logPath -Value $logEntry
}
