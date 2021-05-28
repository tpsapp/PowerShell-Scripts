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
    Gets a Wireless Network Report.
    .DESCRIPTION
    Gets a Wireless Network Report using the netsh command on the specified computer or the local machine.
    .PARAMETER hostName
    The computer name to get the Wireless Network Report for.
    .EXAMPLE
    PS> .\Get-WirelessNetworkReport.ps1
    Gets a Wireless Network Report for the local machine.
    .EXAMPLE
    PS> .\Get-WirelessNetworkReport.ps1 computername
    Gets a Wireless Network Report for the specified machine.
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

    Write-Host "Generating Wireless report on $hostName."
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { netsh wlan show wlanreport }
    Write-Host "Successfully generated Wireless report on $hostName." -ForegroundColor Green
    Write-Host "Openning Wireless report from $hostName."
    Invoke-Command -ErrorAction Stop -ScriptBlock { cmd /c start \\$hostName\c$\ProgramData\Microsoft\Windows\WlanReport\wlan-report-latest.html }
}
else {
    Write-Host "Generating Wireless report."
    Invoke-Command -ErrorAction Stop -ScriptBlock { netsh wlan show wlanreport }
    Write-Host "Successfully generated Wireless report." -ForegroundColor Green
    Write-Host "Openning Wireless report."
    Invoke-Command -ErrorAction Stop -ScriptBlock { c:\\ProgramData\\Microsoft\\Windows\\WlanReport\\wlan-report-latest.html }
}
