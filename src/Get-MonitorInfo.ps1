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
	Gets the serial number of the monitors that are attached to the system.
	.DESCRIPTION
	Gets the serial number of the monitors that are attached to the specified system or the local machine.  This script only works for Dell monitors currently.
	.PARAMETER hostName
	The computer name to get the serial numbers from.
	.EXAMPLE
	PS> .\Get-MonitorInfo.ps1
	Gets the monitor serial numbers from the local machine.
	.EXAMPLE
	PS> .\Get-MonitorInfo.ps1 computername
	Gets the monitor serial numbers from the specified machine.
#>

Param(
	[Parameter(Position = 0,
		ValueFromPipeline = $true,
		HelpMessage = "Enter a computer name."
	)]
	[string]
	$hostName
)

if ($hostname) {

	Write-Host "Attempting to get serial numbers from the monitors attached to $hostname." -ForegroundColor Green
	Write-Host 
	Write-Host "Manufacturer,Name,Serial"

	$Monitors = Get-WmiObject WmiMonitorID -Namespace root\wmi -ErrorAction Stop -ComputerName $hostname
	ForEach ($Monitor in $Monitors) {
		$Manufacturer = ($Monitor.ManufacturerName -notmatch 0 | ForEach-Object { [char]$_ }) -join ""
		$Name = ($Monitor.UserFriendlyName -notmatch 0 | ForEach-Object { [char]$_ }) -join ""
		$Serial = ($Monitor.SerialNumberID -notmatch 0 | ForEach-Object { [char]$_ }) -join ""

		Write-Host "$Manufacturer,$Name,$Serial"
	}
	Write-Host 
}
else {
	Write-Host "Attempting to get serial numbers from the attached monitors." -ForegroundColor Green
	Write-Host 
	Write-Host "Manufacturer,Name,Serial"

	$Monitors = Get-WmiObject WmiMonitorID -Namespace root\wmi -ErrorAction Stop
	ForEach ($Monitor in $Monitors) {
		$Manufacturer = ($Monitor.ManufacturerName -notmatch 0 | ForEach-Object { [char]$_ }) -join ""
		$Name = ($Monitor.UserFriendlyName -notmatch 0 | ForEach-Object { [char]$_ }) -join ""
		$Serial = ($Monitor.SerialNumberID -notmatch 0 | ForEach-Object { [char]$_ }) -join ""

		Write-Host "$Manufacturer,$Name,$Serial"
	}
	Write-Host 
}
