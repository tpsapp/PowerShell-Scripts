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
    Resumes BitLocker Encryption.
    .DESCRIPTION
    Resumes BitLocker Encryption on the specified computer or the local machine.
    .PARAMETER hostName
    The computer name to resume BitLocker Encryption on.
    .EXAMPLE
    PS> .\Invoke-BitlockerResume.ps1
    Attempts to resume the BitLocker Encryption on the local machine.
    .EXAMPLE
    PS> .\Invoke-BitlockerResume.ps1 computername
    Attempts to resume the BitLocker Encryption on the specified machine.
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

if ($hostName) {

    Write-Host "Attempting to resume BitLocker on $hostName."
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { cmd /c "Manage-bde -Protectors -Enable C:" }
    Write-Host "BiLocker resumed on $hostName."
}
else {
    Write-Host "Attempting to resume BitLocker"
    if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Resume-BitLockerVolume -ErrorAction Stop -MountPoint "c:"
    }
    else {
        Write-Host "Not running with elevated rights, attempting to run command with elevated permissions."
        Start-Process -ErrorAction Stop -Verb RunAs -ArgumentList "-NoExit -Command `"& { Resume-BitLocker -MountPoint 'c:' }`"" -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
    }
}