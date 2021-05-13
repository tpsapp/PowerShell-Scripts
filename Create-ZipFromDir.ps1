<#
    Author: Thomas Sapp
    Email: tpsapp@hotmail.com
    Version: 1.0
    Created: 05/12/2021
    
    .SYNOPSIS
    Creates a ZIP archive of the contents of a directory.
    .DESCRIPTION
    Creates a ZIP archive of the contents of a directory using 7-Zip.
    .PARAMETER source
    The path of the directory to create the archive with.
    .PARAMETER dest
    The path to save the archive file to.
    .INPUTS
    None.
    .OUTPUTS
    None.
    .EXAMPLE
    PS> Create-ZipFromDir.ps1 c:\temp c:\backup
    Creates a ZIP file named temp.zip from c:\temp and its subdirectories and saves it in c:\backup
#>

param(
    [Parameter(Mandatory=true, Position=0, ValueFromPipeline=true, HelpMessage="Enter the source directory")]
    [string]
    $source,
    [Parameter(Mandatory=truePosition=1, ValueFromPipeline=true, HelpMessage="Enter to path to save the zip file")]
    [string]
    $dest
)

Set-Alias sz "$env:ProgramFiles\7-Zip\7z.exe"

Write-Progress -Activity "Create-ZipFromDir.ps1" -CurrentOperation "Creating ZIP from $source." -PercentComplete -1

Get-ChildItem -Path $source -Directory -Force -ErrorAction SilentlyContinue | Select-Object \* | ForEach-Object {
    $FullName = $\_.FullName
    $BaseName = $\_.BaseName
    $zip = $BaseName + ".zip"
    $zipPath = $dest + "" + $zip sz a -tzip "$zipPath" "$FullName" >> C:\\temp\\zip.log 2>&1 
}