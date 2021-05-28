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
    Creates a CSV list of the files in a directory.
    .DESCRIPTION
    Creates a CSV file on your desktop with the list of files from the specified path and its subdirectories.
    .PARAMETER dirName
    The path to the directory to get the file list from.
    .EXAMPLE
    PS> .\New-CSVFromDir.ps1 c:\Windows
    Creates Windows_File_List.csv on your desktop with the list of files from c:\Windows and its subdirectories.
#>

Param(
    [Parameter(Mandatory = $true,
        Position = 0,
        ValueFromPipeline = $true,
        HelpMessage = "Enter a directory path."
    )]
    [string]
    $dirName
)

Write-Host "Generating a list of files at $dirName."
$dirArray = $dirName.Split("\")
$dir = $dirArray[$pathName.Length - 1]
$csv = "c:\Users\${Env:\USERNAME}\Desktop\" + $dir + "_File_List.csv"
Get-ChildItem -Path $dirName -Recurse | Select-Object FullName, CreationTime, LastWriteTime | Export-Csv -Path $csv -Encoding ASCII -NoTypeInformation
Write-Host "File list saved to $csv" -ForegroundColor Green
Invoke-Item $csv
