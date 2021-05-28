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
    Associates PDF files with Adobe Acrobat 11.
    .DESCRIPTION
    Associates PDF files with Adobe Acrobat 11 on the specified computer or the local machine.
    .PARAMETER hostName
    The computer name to associate PDF files on.
    .EXAMPLE
    PS> .\Set-PDFAssociation.ps1
    Associates PDF files with Adobe Acrobat 11 on the local machine.
    .EXAMPLE
    PS> .\Set-PDFAssociation.ps1 computername
    Associates PDF files with Adobe Acrobat 11 on the specified machine.
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

    Write-Host "Associating PDF files with Adobe Acrobat 11 on $hostName."
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { cmd /c assoc .pdf=Acrobat.Document.11 }
    Write-Host "Associating PDF files with Adobe Acrobat 11 on $hostName." -ForegroundColor Green
}
else {
    Write-Host "Associating PDF files with Adobe Acrobat 11."
    Invoke-Command -ErrorAction Stop -ScriptBlock { cmd /c assoc .pdf=Acrobat.Document.11 }
    Write-Host "Associating PDF files with Adobe Acrobat 11." -ForegroundColor Green
}