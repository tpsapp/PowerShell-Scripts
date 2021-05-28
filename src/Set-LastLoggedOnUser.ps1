###########################################################
# This script will attempt to set the Last Logged On User
# Information in the registry to the specified information.
# *** NOTE *** This is an experimental script and may not 
# work or cause registry corruption.  Use at your own risk.
#
# Author: Thomas Sapp
# Created: 01/01/2019
#
# Updates:
#   04/28/2021 - TPS - Changed script name to use approved
#                PowerShell verbs.
#
###########################################################

<#
    .SYNOPSIS
    Sets the last logged on user on the local machine.
    .DESCRIPTION
    Sets the last logged on user on the local machine.  This script may not work and could cause registry corruption.
    .PARAMETER user
    The users domain and id (i.e. domain\userid).
    .PARAMETER userdisplay
    The users name (i.e lastname, firstname).
    .EXAMPLE
    PS> .\Set-LastLoggedOnUser.ps1 domain\userid "lastname, firstname"
    Sets the last logged on user to the specified user.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true,
        Position = 0,
        ValueFromPipeline = $true,
        HelpMessage = "Enter a User domain and ID. (i.e. domain\userid)"
    )]
    [string]
    $USER,
    [Parameter(Mandatory = $true,
        Position = 1,
        ValueFromPipeline = $true,
        HelpMessage = "Enter a User name. (i.e lastname, firstname)"
    )]
    [string]
    $USERDISPLAY
)

write-host "[INFO] Changing the last logged on user: "
$USERSID = (New-Object System.Security.Principal.NTAccount($USER)).Translate([System.Security.Principal.SecurityIdentifier]).value 
write-host "[INFO] Changing LastLoggedOnDisplayName registry key -> "
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI -Name LastLoggedOnDisplayName -Value $USERDISPLAY
# reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v LastLoggedOnDisplayName /t REG_SZ /d $USERDISPLAY /f 
write-host "[INFO] Changing LastLoggedOnSAMUser registry key -> " 
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI -Name LastLoggedOnSAMUser -Value $USER
# reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v LastLoggedOnSAMUser /t REG_SZ /d $USER /f 
write-host "[INFO] Changing LastLoggedOnUser registry key -> " 
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI -Name LastLoggedOnUser -Value $USER
# reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v LastLoggedOnUser /t REG_SZ /d $USER /f 
write-host "[INFO] Changing LastLoggedOnUserSID registry key -> " 
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI -Name LastLoggedOnUserSID -Value $USERSID
# reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v LastLoggedOnUserSID /t REG_SZ /d $USERSID /f
write-host "[INFO] Changing SelectedUserSID registry key -> " 
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI -Name SelectedUserSID -Value $USERSID
# reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v SelectedUserSID /t REG_SZ /d $USERSID /f