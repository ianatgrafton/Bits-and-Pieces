# Ping a list of hosts and return the status only 

$Timeout = 1000
$Ping = New-Object System.Net.NetworkInformation.Ping
$Names= <insert hostnames as a list of strings>
foreach($name in $Names){
    Resolve-DnsName -Name $Name
    If(Resolve-DnsName -Name $Name){
        $Response = $Ping.Send($Name,$Timeout)
        write-host $name $Response.Status
    }
    else{
        write-host "DNS Lookup Failed for $name"
    }

}
