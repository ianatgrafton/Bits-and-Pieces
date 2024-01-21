$EventList = '4723' # insert a list of event ID as a list of strings
$log = 'security' # which log do you want to check?
$data = '0x3E7' # what data are you looking for inside the event?

$DCList = Get-ADDomainController -Filter * -Server <insert domain fqdn>

foreach ($EventID in $EventList) {
    "checking for Event ID $EventID"
    foreach ($dc in $DCList) {
        write-host "Check $dc"
        Try { Get-WinEvent -ComputerName $dc.hostname -FilterHashtable @{ LogName = $log;  Data = $data } -ErrorAction silent | select @{n='DC';e={$dc.name}}, TimeCreated, ID }
        Catch { write-host " - Not Found" -ForegroundColor Red }
    }
}
