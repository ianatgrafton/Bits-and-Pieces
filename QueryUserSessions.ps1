# query all sessions on a list of remote hosts

$hosts = import-csv filepath
foreach ($server in $hosts) { 
    query session /server:$server
    }
