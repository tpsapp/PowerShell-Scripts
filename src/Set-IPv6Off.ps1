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
    Disables IPv6 on all interfaces.
    .DESCRIPTION
    Disables IPv6 on all interfaces.
    .PARAMETER hostName
    The computer name to disable IPv6 on.
    .EXAMPLE
    PS> .\Set-IPv6Off.ps1
    Disables IPv6 on the local machine.
    .EXAMPLE
    PS> .\Set-IPv6Off.ps1 computername
    Disables IPv6 on the specified machine.
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

    Write-Host "Attempting to disable IPv6 for all adapters on $hostName."
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { Disable-NetAdapterBinding -Name * -ComponentID ms_tcpip6 }
    Write-Host "IPv6 disabled for all adapters on $hostName." -ForegroundColor Green
}
else {
    Write-Host "Attempting to disable IPv6 for all adapters."
    Invoke-Command -ErrorAction Stop -ScriptBlock { Disable-NetAdapterBinding -Name * -ComponentID ms_tcpip6 }
    Write-Host "IPv6 disabled for all adapters." -ForegroundColor Green
}
