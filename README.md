## Powershell_Whos-Logged-In-Where
- Gets a list of AD Computers, pings each of these once, if successful runs Get-WmiObject to get a list of logged on users, appends {NetBios Name}, {IP Address}, {Logged on Users} to a CSV file named {todays_date}.csv
- Prints current Computer, IP Address, Logged on users to the console.
- Test-Connection + Get-WmiObject takes ~5-20 seconds per machine, if your network has 1000+ seats, good luck.

![alt tag](https://raw.github.com/nojeffrey/Powershell_Whos-Logged-In-Where/master/who-logged-in-where.png)
