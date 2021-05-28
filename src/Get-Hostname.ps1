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
    Gets the host name of the specified computer.
    .DESCRIPTION
    Gets the host name of the specified computer.
    .PARAMETER hostName
    The computer name to get the hostname from.
    .EXAMPLE
    PS> .\Get-Hostname.ps1 computername
    This will use the hostname.exe on the specified computer to retrieve the actual hostname.  
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


Write-Progress -Activity "Get-Hostname.ps1" -CurrentOperation "Attempting to verify the hostname of $hostName." -PercentComplete -1
Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { hostname }