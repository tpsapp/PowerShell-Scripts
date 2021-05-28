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
    Gets the system up time.
    .DESCRIPTION
    Gets the system up time for the specified computer or the local machine.
    .PARAMETER hostName
    The computer name to get the system up time from.
    .EXAMPLE
    PS> .\Get-UpTime.ps1
    Gets the system up time from the local machine.
    .EXAMPLE
    PS> .\Get-UpTime.ps1 computername
    Gets the system up time from the specified machine.
#>

Param(
    [Parameter(Position = 0,
        ValueFromPipeline = $true,
        HelpMessage = "Enter a computer name."
    )]
    [string]
    $hostName
)

if ($hostName) {

    Write-Host "Attempting to get the Uptime from $hostName.`n"
    ((Get-Date) - (gcim -ComputerName $hostName Win32_OperatingSystem).LastBootUpTime).ToString("dd' days 'hh' hours 'mm' minutes 'ss' seconds'")
    # Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { cmd /c "powershell -nologo (Get-Date) - (gcim Win32_OperatingSystem).LastBootUpTime" }
}
else {
    Write-Host "Attempting to get the Uptime.`n"
    ((Get-Date) - (gcim Win32_OperatingSystem).LastBootUpTime).ToString("dd' days 'hh' hours 'mm' minutes 'ss' seconds'")
}