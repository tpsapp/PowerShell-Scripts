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
    Gets the IPv4 address from Active Directory.
    .DESCRIPTION
    Gets the IPv4 address from Active Directory for the specified computer name.
    .PARAMETER hostName
    The computer name to get the IPv4 address for.
    .EXAMPLE
    PS> .\Get-IPv4FromAD.ps1 computername
    Retrieves the IPv4 address from Active Directory for the specified computer.
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

Write-Host "Retrieving the IPv4 address from Active Directory for $hostName."
Get-ADComputer $hostName -ErrorAction Stop -Properties IPv4Address
Write-Host "IPv4 address for $hostName retrieved." -ForegroundColor Green