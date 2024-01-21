# This script removes all the windows and web credentials from credential manager
# It has to be run as the user as windows security will not allow removal of credentials
# by anyone other than the user
#
cmdkey /list | ForEach-Object{if($_ -like "*Target:*"){cmdkey /del:($_ -replace " ","" -replace "Target:","")}}
