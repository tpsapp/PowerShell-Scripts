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
    Unpins an application on the Start menu in Windows 10.
    .DESCRIPTION
    Unpins an application on the Start menu in Windows 10.  A path to the file must be supplied or the file must reside on the path.
    .PARAMETER filePath
    Specifies the file name or the full path to a file that you would like unpinned.
    .EXAMPLE
    PS> .\Remove-AppFromStart notepad.exe
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

Write-Host "Attempting to unpin $filePath from the Start Menu."
$unpinned = $false
foreach ($ItemVerb in $ItemVerbs) {
    if ($ItemVerb.Name -eq "Un&Pin to Start") {
        $ItemVerb.DoIt()
        Write-Host "Successfully unpinned $filePath from the Start Menu." -ForegroundColor Green
        $unpinned = $true
    }
}

if ($unpinned -eq $false) {
    Write-Host "Unpinning $filePath from the Start Menu failed." -ForegroundColor Red
}