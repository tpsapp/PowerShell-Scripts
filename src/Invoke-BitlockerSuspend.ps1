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
    Suspends BitLocker Encryption.
    .DESCRIPTION
    Suspends BitLocker Encryption on the specified computer or the local machine.
    .PARAMETER hostName
    The computer name to suspend BitLocker Encryption on.
    .EXAMPLE
    PS> .\Invoke-BitlockerSuspend.ps1
    Attempts to suspend the BitLocker Encryption on the local machine.
    .EXAMPLE
    PS> .\Invoke-BitlockerSuspend.ps1 computername
    Attempts to suspend the BitLocker Encryption on the specified machine.
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

    Write-Host "Attempting to suspend BitLocker on $hostName."
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { cmd /c "Manage-bde -Protectors -Disable C: -RebootCount 1" }
    Write-Host "BiLocker suspended until next boot on $hostName."
}
else {
    Write-Host "Attempting to suspend BitLocker"
    if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Suspend-BitLockerVolume -ErrorAction Stop -MountPoint "c:"
    }
    else {
        Write-Host "Not running with elevated rights, attempting to run command with elevated permissions."
        Start-Process -Verb RunAs -ArgumentList "-NoExit -Command `"& { Suspend-BitLocker -MountPoint 'c:' -RebootCount 1 }`"" -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
    }
}