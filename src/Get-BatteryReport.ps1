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
    Generates a battery report using powercfg.exe.
    .DESCRIPTION
    Generates a battery report using powercfg.exe on the specified machine or local machine.  The generated report will automatically be opened on the machine that the script is ran from.
    .PARAMETER hostName
    The computer name to generate the battery report for.
    .EXAMPLE
    PS> .\Get-BatteryReport.ps1
    Generates the battery report for the local machine.
    .EXAMPLE
    PS> .\Get-BatteryReport.ps1 computername
    Generates the battery report for the specified machine.
#>

Param(
    [Parameter(Position = 0,
        ValueFromPipeline = $true,
        HelpMessage = "Enter a computer name."
    )]
    [string]
    $hostName
)

if ($hostName -ne "") {

    Write-Host "Generating Battery report on $hostName."
    $result = Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { powercfg /batteryreport }
    Write-Host $result
    $filePath = $result.substring(39).tolower()
    if ($filePath.startswith("c:")) {
        $filePath = "\\$hostname\c$" + $filePath.substring(2)
    }
    Write-Host "Successfully generated Battery report on $hostName." -ForegroundColor Green
    Write-Host "Openning Battery report from $hostName."
    Invoke-Command -ErrorAction Stop -ScriptBlock { cmd /c start $filePath }
}
else {
    Write-Host "Generating Battery report."
    $result = Invoke-Command -ErrorAction Stop -ScriptBlock { powercfg /batteryreport }
    Write-Host $result
    $filePath = $result.substring(39)
    Write-Host "Successfully generated Battery report." -ForegroundColor Green
    Write-Host "Openning Battery report."
    Invoke-Command -ErrorAction Stop -ScriptBlock { cmd /c start $filePath }
}