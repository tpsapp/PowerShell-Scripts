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
    Fixes issues with the Windows Update cache.
    .DESCRIPTION
    Fixes issues with the Windows Update cache by stopping the update services and deleting the Software Distribution folder.
    .PARAMETER hostName
    The computer name to perform the fix on.
    .EXAMPLE
    PS> .\Invoke-WindowsUpdateFix.ps1
    Performs a Windows Update fix on the local machine.
    .EXAMPLE
    PS> .\Invoke-WindowsUpdateFix.ps1 computername
    Performs a Windows Update fix on the specified machine.
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

    Write-Host "Clearing the Windows Update cache on $hostName."
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { Stop-Service -Name "wuauserv" -Force }
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { Stop-Service -Name "cryptSvc" -Force }
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { Stop-Service -Name "bits" -Force }
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { Stop-Service -Name "msiserver" -Force }
    Rename-Item -path "\\$hostName\c$\Windows\SoftwareDistribution" -NewName "\\$hostName\c$\Windows\SoftwareDistribution.bak" -ErrorAction Stop
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { Start-Service -Name "wuauserv" }
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { Start-Service -Name "cryptSvc" }
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { Start-Service -Name "bits" }
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { Start-Service -Name "msiserver" }
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { cmd /c c:\Windows\System32\wuauclt.exe /resetauthorization /detectnow }
    Remove-Item -path "\\$hostName\c$\Windows\SoftwareDistribution.bak" -Recurse -Force -ErrorAction Stop
    Write-Host "Windows Update cache cleared on $hostName." -ForegroundColor Green
}
else {
    Write-Host "Clearing the Windows Update cache."
    Stop-Service -ErrorAction Stop -Name "wuauserv" -Force
    Stop-Service -ErrorAction Stop -Name "cryptSvc" -Force
    Stop-Service -ErrorAction Stop -Name "bits" -Force
    Stop-Service -ErrorAction Stop -Name "msiserver" -Force
    Remove-Item -path "c:\Windows\SoftwareDistribution" -Recurse -Force -ErrorAction Stop
    Remove-Item -path "c:\Windows\System32\catroot2" -Recurse -Force -ErrorAction Stop
    Start-Service -ErrorAction Stop -Name "wuauserv"
    Start-Service -ErrorAction Stop -Name "cryptSvc"
    Start-Service -ErrorAction Stop -Name "bits"
    Start-Service -ErrorAction Stop -Name "msiserver"
    Invoke-Command -ErrorAction Stop -ScriptBlock { "cmd /c c:\Windows\System32\wuauclt.exe /resetauthorization /detectnow" }
    Write-Host "Windows Update cache cleared." -ForegroundColor Green
}
