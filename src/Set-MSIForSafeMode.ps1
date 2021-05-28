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
    Enables the running of MSI files in Safe Mode.
    .DESCRIPTION
    Enables the running of MSI files in Safe Mode.
    .EXAMPLE
    PS> .\Set-MSIForSafeMode.ps1
    Enables the running of MSI files in Safe Mode.
#>

$isSafeMode = (Get-WmiObject win32_computersystem -Property BootupState).BootupState

if (!($isSafeMode.ToLower() -eq "normal boot")) {
    Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\SafeBoot\Minimal -Name MSIServer -Value "Service"
    Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\SafeBoot\Network -Name MSIServer -Value "Service"
    Invoke-Command -ScriptBlock { net start msiserver }
}
else {
    Write-Host "The computer must be in safe mode to run this script" -ForegroundColor Red
}