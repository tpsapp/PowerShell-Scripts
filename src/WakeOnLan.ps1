###########################################################
# This script attempts to send a Wake On Lan request to the
# specified computer using its MAC address.  This script
# must be run on a machine that is on the same subnet as
# the target machine.
#
# Author: Thomas Sapp
# Created: 01/01/2019
#
# Updates:
#   04/28/2021 - TPS - Changed script name to use approved
#                PowerShell verbs.
#
###########################################################

param([Parameter(Mandatory = $true)][string]$macAddress)

if ($macAddress -eq "/?") {
    Write-Host "Sends a Wake-On-Lan request to the specified MAC address."
    Write-Host ""
    Write-Host "Use of this script requires a MAC address to be supplied."
    Write-Host "Example: $($MyInvocation.MyCommand.Name) macaddress"
    Write-Host ""
    Write-Host "    macaddress = The MAC address of the machine to wake up."
    Write-Host "                 The MAC address should use the format ##:##:##:##:##:## or ##-##-##-##-##-##"
    Write-Host ""
    Read-Host "Press ENTER to continue..."
}
else {
    Write-Host "Attempting to send a Wake-On-Lan to $macAddress."
    $MacByteArray = $macAddress -split "[:-]" | ForEach-Object { [Byte] "0x$_" }
    [Byte[]] $MagicPacket = (, 0xFF * 6) + ($MacByteArray * 16)
    $UdpClient = New-Object System.Net.Sockets.UdpClient
    $UdpClient.Connect(([System.Net.IPAddress]::Broadcast), 7)
    $UdpClient.Send($MagicPacket, $MagicPacket.Length)
    $UdpClient.Close()
    Write-Host "Successfully sent a Wake-On-Lan to $macAddress." -ForegroundColor Green
}

