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
    Gets the BitLocker encryption status for all drives.
    .DESCRIPTION
    Gets the BitLocker encryption status for all drives on the specified machine or the local machine.
    .PARAMETER hostName
    The computer name to get the BitLocker encryption status from.
    .EXAMPLE
    PS> .\Get-BitlockerEncryptionStatus.ps1
    Gets the BitLocker encryption status from the local machine.
    .EXAMPLE
    PS> .\Get-BitlockerEncryptionStatus.ps1
    Gets the BitLocker encryption status from the specified machine.
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

    Write-Host "Getting the status of BitLocker from $HostName." -ForegroundColor Green
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { Get-BitLockerVolume }
}
else {
    Write-Host "Getting the status of BitLocker." -ForegroundColor Green
    if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Get-BitLockerVolume
    }
    else {
        Start-Process -Verb RunAs -ArgumentList "-NoExit -Command `"& { Get-BitLockerVolume }`"" -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
    }
}