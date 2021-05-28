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
    Cancels the shutdown timer.
    .DESCRIPTION
    Cancels the shutdown timer on the specified machine or the local machine.
    .PARAMETER hostName
    The computer name to cancel the shutdown on.
    .EXAMPLE
    PS> .\Invote-ShutdownCancel.ps1
    Cancels the shut down timer on the local machine.
    .EXAMPLE
    PS> .\Invote-ShutdownCancel.ps1 computername
    Cancels the shut down timer on the specified machine.
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

    Write-Host "Cancelling shutdown on $hostName."
    Invoke-Command -ErrorAction Stop -ScriptBlock { shutdown /a /m "\\$hostName" }
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { Stop-Service -Force -Name "CcmExec" }
    
    Write-Host "Shutdown cancelled on $hostName." -ForegroundColor Green
}
else {
    Write-Host "Cancelling shutdown."
    Invoke-Command -ErrorAction Stop -ScriptBlock { shutdown /a }
    Stop-Service -ErrorAction Stop -Force -Name "CcmExec"
    Write-Host "Shutdown cancelled." -ForegroundColor Green
}
