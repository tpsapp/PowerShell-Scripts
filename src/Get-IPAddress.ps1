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
    Gets the IP address of the specified machine.
    .DESCRIPTION
    Gets the IP address of the specified machine.
    .PARAMETER hostName
    The computer name to get the IP address from.
    .EXAMPLE
    PS> .\Get-IPAddress.ps1 computername
    Gets the IP address from the specified computer using ipconfig /all.
#>

Param(
    [Parameter(Mandatory = $true,
        Position = 0,
        ValueFromPipeline = $true,
        HelpMessage = "Enter a computer name."
    )]
    [string]
    $hostName
)


Write-Progress -Activity "Get-IPAddress.ps1" -CurrentOperation "Attempting to verify the IP address of $hostName." -PercentComplete -1
Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { ipconfig }