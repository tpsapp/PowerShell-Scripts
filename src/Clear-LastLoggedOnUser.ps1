###########################################################
# Author: Thomas Sapp
# Created: 05/20/2021
#
# Updates:
#   05/20/2021 - TPS - Created
###########################################################

<#
    .SYNOPSIS
    Clears the Last Logged On User entries.
    .DESCRIPTION
    Clears the LastLoggedOnUser and LastLoggedOnSamUser entries in the registry on the specified computer or local machine.
    .PARAMETER hostName
    The computer name to clear the last logged on user from.
    .EXAMPLE
    PS> .\Clear-LastLoggedOnUser.ps1
    Clears the last logged on user from the local machine.
    .EXAMPLE
    PS> .\Clear-LastLoggedOnUser.ps1 computername
    Clears the last logged on user from the specified machine.
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

    Write-Progress -CurrentOperation "Clearing the Last Logged on User value on $hostName." -Activity "Clear-LastLoggedOnUser.ps1" -PercentComplete 0
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" -Name "LastLoggedOnUser" -Value "" }
    Write-Progress -CurrentOperation "Clearing the Last Logged on User value on $hostName." -Activity "Clear-LastLoggedOnUser.ps1" -PercentComplete 50
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" -Name "LastLoggedOnSAMUser" -Value "" }
    Write-Progress "Last Logged on User value cleared on $hostName."  -Activity "Clear-LastLoggedOnUser.ps1" -PercentComplete 100
}
else {
    Write-Progress -CurrentOperation "Clearing the Last Logged on User value." -Activity "Clear-LastLoggedOnUser.ps1" -PercentComplete 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" -Name "LastLoggedOnUser" -Value ""
    Write-Progress -CurrentOperation "Clearing the Last Logged on User value." -Activity "Clear-LastLoggedOnUser.ps1" -PercentComplete 50
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" -Name "LastLoggedOnSAMUser" -Value ""
    Write-Progress -CurrentOperation "Last Logged on User value cleared."  -Activity "Clear-LastLoggedOnUser.ps1" -PercentComplete 100
}