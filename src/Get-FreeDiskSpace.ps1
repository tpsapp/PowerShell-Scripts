###########################################################
# Author: Thomas Sapp
# Created: 05/04/2021
#
# Updates:
#   05/04/2021 - TPS - Created script
###########################################################

<#
    .SYNOPSIS
    Gets the free disk space for all drives.
    .DESCRIPTION
    Gets the free disk space for all drives on the specified machine or the local machine.  The free space will be displayed in GB.
    .PARAMETER hostName
    The computer name to get the free space from.
    .EXAMPLE
    PS> .\Get-FreeDiskSpace.ps1
    Gets the free disk space for all drives on the local machine.
    .EXAMPLE
    PS> .\Get-FreeDiskSpace.ps1 computername
    Gets the free disk space for all drives on the specified machine.
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

    Write-Host "Getting free disk space from $hostName."
    Get-CimInstance -ComputerName $hostName -ClassName Win32_LogicalDisk | Select-Object -Property DeviceID, @{'Name' = 'FreeSpace (GB)'; Expression = { [int]($_.FreeSpace / 1GB) } }
    Write-Host "`nFree disk space retrieved from $hostName." -ForegroundColor Green
}
else {
    Write-Host "Getting free disk space."
    Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object -Property DeviceID, @{'Name' = 'FreeSpace (GB)'; Expression = { [int]($_.FreeSpace / 1GB) } }
    Write-Host "`nFree disk space retrieved." -ForegroundColor Green
}