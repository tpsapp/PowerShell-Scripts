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
    Sets the file creation, last access, or last write time on a file.
    .DESCRIPTION
    Sets the file creation, last access, or last write time on a file to the specified date and time or the current date and time if ommited.
    .PARAMETER filePath
    The path to the file or directory to change.
    .PARAMETER dateTime
    The date and time to set on the file or directory.
    .PARAMETER operation
    What property you would like to change. creation = Creation Time, access = Last Access Time, and write = Last Write Time.
    .EXAMPLE
    PS> .\Set-FileInfo.ps1 c:\Windows
    Sets the Creation Time on c:\Windows to the current date and time.
    .EXAMPLE
    PS> .\Set-FileInfo.ps1 c:\Windows "05/21/2021 08:00 AM"
    Sets the Creation Time on c:\Windows to the specified date and time.
    .EXAMPLE
    PS> .\Set-FileInfo.ps1 c:\Windows "05/21/2021 08:00 AM" access
    Sets the Last Access Time on c:\Windows to the specified date and time.
#>

<# example commands
$(Get-Item ).creationtime=$(Get-Date "mm/dd/yyyy hh:mm am/pm")
$(Get-Item ).lastaccesstime=$(Get-Date "mm/dd/yyyy hh:mm am/pm")
$(Get-Item ).lastwritetime=$(Get-Date "mm/dd/yyyy hh:mm am/pm")
#>

Param([Parameter(Mandatory = $true, Position = 0,
        ValueFromPipeline = $true,
        HelpMessage = "Enter a computer name."
    )]
    [string]
    $filePath, 
    [string]
    $dateTime = $(Get-Date -Format "MM/dd/yyyy mm:ss tt"),
    [string]
    $operation = "creation"
)

switch ($operation) {
    "creation" { $(Get-Item $filePath).CreationTime = $(Get-Date $dateTime) }
    "access" { $(Get-Item $filePath).LastAccessTime = $(Get-Date $dateTime) }
    "write" { $(Get-Item $filePath).LastWriteTime = $(Get-Date $dateTime) }
    Default { Write-Error "Invalid operation type $operation.  Must be creation, access, or write." }
}