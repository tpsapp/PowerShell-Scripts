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
    Schedules a disk check on next boot.
    .DESCRIPTION
    Schedules a disk check on next boot of the specified computer or the local machine.
    .PARAMETER hostName
    The computer name to schedule the disk check on.
    .EXAMPLE
    PS> .\Invoke-CheckDisk.ps1
    Schedules a disk check on the new boot of the local machine.
    .EXAMPLE
    PS> .\Invoke-CheckDisk.ps1 computername
    Schedules a disk check on the new boot of the Specified machine.
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

    Write-Host "Attempting to schedule a CHKDSK on $hostName."
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { Write-Output y | chkdsk /f /r }
    Write-Host "A CHKDSK has been scheduled for next reboot on $hostName." -ForegroundColor Green
}
else {
    Write-Host "Attempting to schedule a CHKDSK on next reboot."
    Invoke-Command -ErrorAction Stop -ScriptBlock { Write-Output y | chkdsk /f /r }
    Write-Host "A CHKDSK has been scheduled for next reboot." -ForegroundColor Green
}