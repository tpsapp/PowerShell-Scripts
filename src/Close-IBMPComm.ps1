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
    Closes all IBM Personal Communications processes.
    .DESCRIPTION
    Closes all IBM Personal Communications processes on the specified computer or the local machine.
    .PARAMETER hostName
    The computer name to close the processes on.
    .EXAMPLE
    PS> .\Close-IBMPComm.ps1
    Closes all processes on the local machine.
    .EXAMPLE
    PS> .\Close-IBMPComm.ps1 computername
    Closes all processes on the specified machine.
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

    Write-Host "Attempting to close all IBM Personal Communications processes on $hostname."
    Write-Progress -Activity "Close-IBMPComm.ps1" -CurrentOperation "Closing pcsws.exe on $hostName" -PercentComplete 0
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { pskill.exe -accepteula -nobanner pcsws.exe }
    Write-Progress -Activity "Close-IBMPComm.ps1" -CurrentOperation "Closing pcscm.exe on $hostName" -PercentComplete 33
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { pskill.exe -accepteula -nobanner pcscm.exe }
    Write-Progress -Activity "Close-IBMPComm.ps1" -CurrentOperation "Closing pcs_agnt.exe on $hostName" -PercentComplete 66
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { pskill.exe -accepteula -nobanner pcs_agnt.exe }
    Write-Host "All processes closed on $hostName."

}
else {
    Write-Host "Attempting to close all IBM Personal Communications processes."
    Write-Progress -Activity "Close-IBMPComm.ps1" -CurrentOperation "Closing pcsws.exe." -PercentComplete 0
    Invoke-Command -ErrorAction Stop -ScriptBlock { pskill.exe -accepteula -nobanner pcsws.exe }
    Write-Progress -Activity "Close-IBMPComm.ps1" -CurrentOperation "Closing pcscm.exe." -PercentComplete 33
    Invoke-Command -ErrorAction Stop -ScriptBlock { pskill.exe -accepteula -nobanner pcscm.exe }
    Write-Progress -Activity "Close-IBMPComm.ps1" -CurrentOperation "Closing pcs_agnt.exe." -PercentComplete 66
    Invoke-Command -ErrorAction Stop -ScriptBlock { pskill.exe -accepteula -nobanner pcs_agnt.exe }
    Write-Progress -Activity "Close-IBMPComm.ps1" -CurrentOperation "All processes closed." -PercentComplete 100
    Write-Host "All processes closed."
}