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
    Fixes WMI issues with the Windows Firewall.
    .DESCRIPTION
    Fixes an issue with the Windows firewall that prevents WMI access on the specified computer or the local machine.
    .PARAMETER hostName
    The computer name to fix the WMI issue on.
    .EXAMPLE
    PS> .\Invoke-WMIFirewallFix.ps1
    Fixes the issue with Windows Firewall blocking WMI on the local machine.
    .EXAMPLE
    PS> .\Invoke-WMIFirewallFix.ps1 computername
    Fixes the issue with Windows Firewall blocking WMI on the specified machine.
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

    Write-Host "Attempting to apply the firewall fix to $hostName."
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { netsh.exe firewall set service RemoteAdmin }
    Write-Host "Successfull applied the firewall fix to $hostName." -ForegroundColor Green
}
else {
    Write-Host "Attempting to apply the firewall fix."
    Invoke-Command -ErrorAction Stop -ScriptBlock { netsh.exe firewall set service RemoteAdmin }
    Write-Host "Successfull applied the firewall fix." -ForegroundColor Green
}