###########################################################
# Author: Thomas Sapp
# Created: 01/01/2019
#
# Updates:
#   04/28/2021 - TPS - Changed script name to use approved
#                PowerShell verbs.
###########################################################

<#
    .SYNOPSIS
    Logs off the specified user.
    .DESCRIPTION
    Gets a list of users logged in to the specified machine and allows them to be logged off.
    .PARAMETER hostName
    The computer name to log off the users from.
    .EXAMPLE
    PS> .\Invoke-RemoteLogoff.ps1 computername
    example description.
#>

Param(
    [Parameter(Mandatory = $true,
        Position = 0,
        ValueFromPipeline = $true,
        HelpMessage = "Enter a computer name."
    )]
    [string]
    $hostName
)

$scriptBlock = {
    $ErrorActionPreference = "Stop"

    try {
        Write-Host "Getting list of logged on users for $using:hostName."
        Write-Host

        $sessions = quser.exe | Out-String
        # $sessions = $sessions.Insert(75, "`n");
        # $sessionIds = ($sessions -split " +")[2]
        
        Write-Host "The following sessions were found on $using:hostName"
        Write-Host $sessions
        Write-Host
        Write-Host "Which session ID would you like to log off?"
        $userinput = Read-Host

        if ($userinput) {
            Write-Host "Attempting to log off session $userinput..."
            logoff.exe $userinput
            Write-Host "User successfully logged off" -ForegroundColor Green
        }
    }
    catch {
        if ($_.Exception.Message -match 'No user exists') {
            Write-Host "No users logged in." -ForegroundColor Red
        }
        else {
            throw $_.Exception.Message
        }
    }
}


$stop = $true
do {
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock $scriptBlock
    Write-Host
    Write-Host "Would you like to log off other users? (y/n)"
    $userInput = Read-Host
    $userInput = $userInput.ToLower()

    if (($userInput -eq "y") -OR ($userInput -eq "yes")) {
        $stop = $false
    }
    else {
        $stop = $true
    }

} until ($stop)
