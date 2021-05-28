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
    Sends a Wake-On-Lan packet.
    .DESCRIPTION
    Sends a Wake-On-Lan packet to the specified mac address.  Must be used from the same subnet as the specified machine.
    .PARAMETER MacAddress
    The MAC address to send the wake-on-lan packet to.
    .EXAMPLE
    PS> .\script-name 00:00:00:00:00
    Sends a Wake-On-Lan Magic Packet to the specified MAC address.
    .EXAMPLE
    PS> .\script-name 00-00-00-00-00
    Sends a Wake-On-Lan Magic Packet to the specified MAC address.
#>

param
(
    [Parameter(Mandatory = $true,
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true)]
    [ValidatePattern('^([0-9A-F]{2}[:-]){5}([0-9A-F]{2})$')]
    [string[]]
    $MacAddress 
)
 
begin {
    # instantiate a UDP client:
    $UDPclient = [System.Net.Sockets.UdpClient]::new()
}
process {
    foreach ($_ in $MacAddress) {
        try {
            $currentMacAddress = $_
        
            # get byte array from mac address:
            $mac = $currentMacAddress -split '[:-]' |
            # convert the hex number into byte:
            ForEach-Object {
                [System.Convert]::ToByte($_, 16)
            }
 
            #region compose the "magic packet"
        
            # create a byte array with 102 bytes initialized to 255 each:
            $packet = [byte[]](, 0xFF * 102)
        
            # leave the first 6 bytes untouched, and
            # repeat the target mac address bytes in bytes 7 through 102:
            6..101 | Foreach-Object { 
                # $_ is indexing in the byte array,
                # $_ % 6 produces repeating indices between 0 and 5
                # (modulo operator)
                $packet[$_] = $mac[($_ % 6)]
            }
        
            #endregion
        
            # connect to port 400 on broadcast address:
            $UDPclient.Connect(([System.Net.IPAddress]::Broadcast), 4000)
        
            # send the magic packet to the broadcast address:
            $null = $UDPclient.Send($packet, $packet.Length)
            Write-Verbose "sent magic packet to $currentMacAddress..."
        }
        catch {
            Write-Warning "Unable to send ${mac}: $_"
        }
    }
}
end {
    # release the UDF client and free its memory:
    $UDPclient.Close()
    $UDPclient.Dispose()
}