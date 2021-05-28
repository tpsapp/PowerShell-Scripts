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
    Adds the Everyone group to the specified directory or file path..
    .DESCRIPTION
    Adds the Everyone group to the specified directory or file path..
    .PARAMETER path
    The full path to add the everyone permission to.
    .PARAMETER hostName
    The computer name that the path resides on.
    .EXAMPLE
    PS> .\Set-EveryonePermission.ps1 c:\IBM
    Adds the Everyone permission to the C:\IBM folder and subfolders.
    .EXAMPLE
    PS> .\Set-EveryonePermission.ps1 c:\IBM computername
    Adds the Everyone permission to the C:\IBM folder and subfolders on the specified computer.
#>

Param([Parameter(Mandatory = $true,
        Position = 0,
        ValueFromPipeline = $true,
        HelpMessage = "Enter a file or directory path."
    )]
    [string]
    $path,
    [string]
    $hostName)

if ($hostName) {

    Write-Host "Adding the Everyone group to $path on $hostName."
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { cmd /c "icacls $path /grant Everyone:(OI)(CI)F /T /C" }
    Write-Host "Successfully added the Everyone group to $path on $hostName." -ForegroundColor Green
}
else {
    Write-Host "Adding the Everyone group to $path."
    $acl = Get-Acl -Path $path
    $fsaral = "Everyone", "FullControl", "Allow"
    $fsar = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fsaral
    $acl.SetAccessRule($fsar)
    Set-Acl -Path $path -AclObject $acl

    # Invoke-Command -ErrorAction Stop -ScriptBlock { cmd /c "icacls $path /grant Everyone:(OI)(CI)F /T /C" }
    Write-Host "Successfully added the Everyone group to $path." -ForegroundColor Green
}

