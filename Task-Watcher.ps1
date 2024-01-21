#----------------------------------------------
# Script: TaskWatcher.ps1
# Author: Motox80 on Microsoft Technet Forums
# Version: 1.1 - Watch TOD clock
#          1.2 - Accept parameter task name
#          1.3 - Bugfix with date.  
#----------------------------------------------
param($TaskName = 'test')                                    # The task name to monitor

# not useful    schtasks.exe /query /xml /tn $TaskName 

""
Function Spacer{
    Param ([string]$pt,$pl)
    return ("{0}{1}" -f $pt,  (" " * 30)).Substring(0,$pl)        # Try to align column headers
}

$state = $null
"  Day           Time            Task{0}State    Last Run Time          Next Run Time" -f (Spacer "" $TaskName.length)
 while ($true) {   
    $lasttime = Get-Date
    Get-ScheduledTask  -TaskName $TaskName -ErrorAction stop | foreach {
        $sti =  Get-ScheduledTaskInfo $_
        $alert = $false                                         # Alert when something changes   
        if ($_.State -ne $state) {$alert = $true}
        if ($sti.LastRunTime -ne $lrt) {$alert = $true}
        if ($sti.NextRunTime -ne $nrt) {$alert = $true}
        if ($alert) {
            "{0} {1} {2}    {3} {4} {5}" -f (Spacer (Get-Date).DayOfWeek 10), (Spacer (get-date) 20), $_.taskname, (Spacer $_.State 8),  (Spacer $sti.LastRunTime 22), (Spacer $sti.NextRunTime 22)
            $state = $_.State 
            $lrt = $sti.LastRunTime                            # Save values for next loop 
            $nrt = $sti.NextRunTime
        }
    }
    start-sleep 10                                              # delay for n seconds
    $thistime = Get-Date
    $dd = NEW-TIMESPAN –Start $lasttime –End $thistime
    if (($dd.TotalSeconds -lt 0) -or ($dd.TotalSeconds -gt 20)) {
        "{0}   Time of day clock has changed more than expected. " -f (get-date) 
        "{0}   Time difference in seconds = {1}   " -f (get-date), $dd.TotalSeconds 
        "{0}   Last seen time = {1}   " -f (get-date), $lasttime   
    }
}
