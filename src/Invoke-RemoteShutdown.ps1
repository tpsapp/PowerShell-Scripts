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
    Remotely shuts down the specified computer.
    .DESCRIPTION
    Remotely shuts down the specified computer, allows you to suspend bitlocker before shutdown.
    .PARAMETER hostName
    The computer name to remotely shut down.
    .PARAMETER suspend
    -suspend to indicate that bitlocker needs to be suspended until next boot.
    .EXAMPLE
    PS> .\Invoke-RemoteShutdown.ps1 computername
    Remotely shuts down the specified computer.
    .EXAMPLE
    PS> .\Invoke-RemoteShutdown.ps1 computername -suspend
    Remotely suspends bitlocker and shuts down the specified computer.
#>

Param(
    [Parameter(Mandatory = $true,
        Position = 0,
        ValueFromPipeline = $true,
        HelpMessage = "Enter a computer name."
    )]
    [string]
    $hostName,
    [switch]
    $suspendBitLocker
)


if ($suspendBitLocker.IsPresent) {
    Write-Host "Attempting to suspend BitLocker on $hostName."
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { cmd /c "Manage-bde -Protectors -Disable C: -RebootCount 1" }
    Write-Host "BiLocker suspended until next boot on $hostName."
}
Write-Host "Attempting to shutdown $hostName."
Stop-Computer -ComputerName $hostName -Force
Write-Host "$hostName accepted the shutdown request." -ForegroundColor Green