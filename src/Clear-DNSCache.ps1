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
    Cleares the DNS, NetBIOS, and WINS Cache.
    .DESCRIPTION
    This script will attempt to clear the DNS cache, and the NetBIOS cache, and the WINS cache on the local machine to resolve DNS conflict issues.
    .PARAMETER hostName
    The name of the computer to clear the cache on.
    .EXAMPLE
    PS> .\Clear-DNSCache.ps1
    .EXAMPLE
    PS> .\Clear-DNSCache.ps1 hostname
    .EXAMPLE
    PS> .\Clear-DNSCache.ps1 hostname.domain
#>

Param(
    [Parameter(Position = 0,
        ValueFromPipeline = $true,
        HelpMessage = "Enter a computer name.")]
    [string]
    $hostName
)

if ($hostName) {
    
    Write-Progress -Activity "Clear-DNSCache.ps1" -CurrentOperation "Flushing DNS on $hostName" -PercentComplete 0
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { ipconfig /flushdns }
    Write-Progress -Activity "Clear-DNSCache.ps1" -CurrentOperation "Flushing NetBIOS Cache on $hostName" -PercentComplete 25
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { nbtstat -R }
    Write-Progress -Activity "Clear-DNSCache.ps1" -CurrentOperation "Flushing the Name Table on $hostName" -PercentComplete 50
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { nbtstat -RR }
    Write-Progress -Activity "Clear-DNSCache.ps1" -CurrentOperation "Flushing WINS Cache on $hostName" -PercentComplete 75
    Invoke-Command -ComputerName $hostName -ErrorAction Stop -ScriptBlock { Clear-DnsClientCache }
    Write-Progress -Activity "Clear-DNSCache.ps1" -CurrentOperation "Successfully flushed the caches on $hostName." -PercentComplete 100
}
else {
    Write-Progress -Activity "Clear-DNSCache.ps1" -CurrentOperation "Flushing DNS." -PercentComplete 0
    Invoke-Command -ErrorAction Stop -ScriptBlock { ipconfig /flushdns }
    Write-Progress -Activity "Clear-DNSCache.ps1" -CurrentOperation "Flushing NetBIOS Cache." -PercentComplete 0
    Invoke-Command -ErrorAction Stop -ScriptBlock { nbtstat -R }
    Write-Progress -Activity "Clear-DNSCache.ps1" -CurrentOperation "Flushing the Name Table." -PercentComplete 0
    Invoke-Command -ErrorAction Stop -ScriptBlock { nbtstat -RR }
    Write-Progress -Activity "Clear-DNSCache.ps1" -CurrentOperation "Flushing WINS Cache." -PercentComplete 0
    Invoke-Command -ErrorAction Stop -ScriptBlock { Clear-DnsClientCache }
    Write-Progress -Activity "Clear-DNSCache.ps1" -CurrentOperation "Successfully flushed the caches." -PercentComplete 100
}