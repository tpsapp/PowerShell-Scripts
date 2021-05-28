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
    Establishes a remote PowerShell session.
    .DESCRIPTION
    Establishes a remote PowerShell session with the specified computer.
    .PARAMETER hostName
    The computer name to connect to the PowerShell session on.
    .EXAMPLE
    PS> .\Invoke-EPS.ps1 computername
    Connects to the remote PowerShell session on the specified computer.
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


Write-Host "Connecting to PowerShell on $hostName."
Enter-PSSession -ComputerName $hostname