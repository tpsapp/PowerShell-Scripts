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
    Creates a ZIP file from the specified path.
    .DESCRIPTION
    Creates a ZIP file containing all files from the specified path and its subdirectories.  The ZIP file is saved to the specified destination using the source directory name.
    .PARAMETER source
    The source directory to create the ZIP from.
    .PARAMETER dest
    The destination directory to save the ZIP to.
    .EXAMPLE
    PS> .\New-ZIPFromDir.ps1 c:\Windows c:\backup
    Creates a zip containing all files in c:Windows and saves it to c:\Backup\windows.zip.
#>

Param([Parameter(Mandatory = $true,
        Position = 0,
        ValueFromPipeline = $true,
        HelpMessage = "Enter the source path."
    )]
    [string]
    $source,
    [Parameter(Mandatory = $true,
        Position = 1,
        ValueFromPipeline = $true,
        HelpMessage = "Enter the destination path."
    )]
    [string]
    $dest)

Write-Progress -Activity "New-ZIPFromDir.ps1" -CurrentOperation "Zipping all directories at $source." -PercentComplete -1
Set-Alias sz "$env:ProgramFiles\7-Zip\7z.exe"

Get-ChildItem -Path $source -Directory -Force -ErrorAction SilentlyContinue | Select-Object * | ForEach-Object { 
    $FullName = $_.FullName
    $BaseName = $_.BaseName
    $zip = $BaseName + ".zip"
    $zipPath = $dest + "\" + $zip
    sz a -tzip "$zipPath" "$FullName" >> C:\temp\zip.log 2>&1
}

Write-Host "All directories zipped in $source.  Log can be found at c:\Temp\zip.log."