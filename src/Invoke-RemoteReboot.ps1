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
    Remotely reboots the specified computer.
    .DESCRIPTION
    Remotely reboots the specified computer, allows you to suspend bitlocker before reboot.
    .PARAMETER hostName
    The computer name to remotely reboot.
    .PARAMETER suspend
    -suspend to indicate that bitlocker needs to be suspended until next reboot.
    .EXAMPLE
    PS> .\Invoke-RemoteReboot.ps1 computername
    Remotely reboots the specified computer.
    .EXAMPLE
    PS> .\Invoke-RemoteReboot.ps1 computername -suspend
    Remotely suspends bitlocker and reboots the specified computer.
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
Write-Host "Attempting to reboot $hostName."
Restart-Computer -ComputerName $hostName -ErrorAction Stop -Force
Write-Host "$hostName accepted the reboot request." -ForegroundColor Green