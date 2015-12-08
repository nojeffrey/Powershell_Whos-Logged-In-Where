#whos-logged-in-where.ps1
#v1.0
#Written by nojeffrey(https://github.com/nojeffrey)
#
#Writes a list of active(if ping successful) AD computers to a CSV file(C:\whos_logged_in_where\{todays_date}.csv), runs a Get-WmiObject(not very robust) for each active machine to get a list of logged in users
#Prints current line to console and writes to a CSV file {NetBios Name}, {IP Address}, {Logged in users}


#Test if C:\whos_logged_in_where\ directory exists, if not create it.
if((Test-Path C:\whos_logged_in_where) -eq 0){
      New-Item -ItemType Directory -Path C:\whos_logged_in_where | Out-Null
      Write-Host "Created directory C:\whos_logged_in_where"
}

#Create todays file, add CSV headers
New-Item -ItemType File "C:\whos_logged_in_where\$((Get-Date).ToString('yyyy-MM-dd')).csv" -force | Out-Null
$line = "NetBios Name" + "," + "IP Address" + "," + "Users"
Write-Output $line | Out-File "C:\whos_logged_in_where\$((Get-Date).ToString('yyyy-MM-dd')).csv" -Encoding ASCII



#Get list of AD computers, can filter on subnet
$list_of_AD_computers = Get-ADComputer -Properties Name, IPv4Address -Filter * | where {$_.ipv4address -like “10.1.*” } 

$list_of_AD_computers | ForEach-Object {
      if (Test-Connection -ComputerName $_.Name -Count 1 -BufferSize 1 -Quiet){
            # Get-WmiObject is not robust, you will get "RPC server is unavailable" errors  
            #Ping + Get-WmiObject takes ~5-20 seconds per machine, if your network has 1000+ seats, good luck.        
            $users = Get-WmiObject -Class win32_process -Computername $_.Name | Foreach {$_.GetOwner().User} | Where {$_ -ne "NETWORK SERVICE" -and $_ -ne "LOCAL SERVICE" -and $_ -ne "SYSTEM"} | sort -unique
            $line = $_.Name + "," + $_.IPv4Address + "," + $users
            Write-Output $line | Out-File "C:\whos_logged_in_where\$((Get-Date).ToString('yyyy-MM-dd')).csv" -Append -Encoding ASCII
            Write-Host $_.Name $_.IPv4Address $users -ForegroundColor Green}
      
      else{
            #Ping unsuccessful
            Write-Host $_.Name -ForegroundColor Red}
}
