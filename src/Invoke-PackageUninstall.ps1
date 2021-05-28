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
    Uninstalls a software package using the CVS_Installer.exe.
    .DESCRIPTION
    Uninstalls a software package using the CVS_Installer.exe from the specified machine.
    .PARAMETER hostName
    The computer name to uninstall the software package from.
    .PARAMETER package
    The exact name of the software package according to SCCM to be uninstalled.
    .EXAMPLE
    PS> .\Invoke-PackageUninstall.ps1 computername MICROSOFT_SQLNC2012X64_11.4.7001.0_B01
    Uninstalls MICROSOFT_SQLNC2012X64_11.4.7001.0_B01 from the specified machine.
#>

Param(
    [Parameter(Mandatory = $true,
        Position = 0,
        ValueFromPipeline = $true,
        HelpMessage = "Enter a computer name."
    )]
    [string]
    $hostName,
    [Parameter(Mandatory = $true)]
    [string]
    $package
)


Write-Host "Attempting to uninstall $package on $hostName."
Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { param($package) cmd /c "C:\PkgLocalCache\$package\CVS_Installer.exe /s /x" } -ArgumentList $package
Write-Host "$package uninstalled from $hostName." -ForegroundColor Green