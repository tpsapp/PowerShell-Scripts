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
    Pins an application on the Start menu in Windows 10.
    .DESCRIPTION
    Pins an application on the Start menu in Windows 10.  A path to the file must be supplied or the file must reside on the path.
    .PARAMETER filePath
    Specifies the file name or the full path to a file that you would like pinned.
    .EXAMPLE
    PS> .\Add-AppToStart notepad.exe
#>

Param(
    [Parameter(Mandatory = $true,
        HelpMessage = "Enter the path to a file.")]
    [string]
    $filePath
)

$shell = New-Object -ComObject "Shell.Application"
$nameSpace = $shell.NameSpace($(Split-Path -Path $filePath))
$appName = $nameSpace.ParseName($(Split-Path -Path $filePath -Leaf -Resolve))
$ItemVerbs = $appName.Verbs()

Write-Host "Attempting to pin $filePath to the Start Menu."
$pinned = $false
foreach ($ItemVerb in $ItemVerbs) {
    if ($ItemVerb.Name -eq "&Pin to Start") {
        $ItemVerb.DoIt()
        Write-Host "Successfully pinned $filePath to the Start Menu."
        $pinned = $true
    }
}

if ($pinned -eq $false) {
    Write-Host "Pinning $filePath to the Start Menu failed."
}