#GET - this works to get info from the basic API.php
$RestReturn = Invoke-WebRequest -Method Get -Uri "http://localhost/xesterui/private/api/api.php/systems" -UseBasicParsing
$UseableData = ConvertFrom-Json $RestReturn
$UseableData

##############################################################
#API.php v2

#GET Not happy with return format, but I can make it work
$RestReturn2 = Invoke-RestMethod -Method Get -Uri "http://localhost/xesterui/public/api/api.php/systems"
$UseableData2 = $RestReturn2

$columns = $UseableData2.systems.columns
$records = $UseableData2.systems.records

foreach ($record in $records)
{
    $ID = $record[0]
    $System_Name = $record[1]
    $Config_File = $record[2]
    $Status_ID = $record[3]
    $date_Modified = $record[4]

    write-host "ID: $ID"
    write-host "System Name: $System_Name"
    write-host "Config File: $Config_File"
    write-host "Status_ID: $Status_ID"
    write-host "Date_Modified: $date_Modified"
    write-host "-----------"

}

#UPDATE - either of these work to update
$body = @{STATUS_ID = "12"} | convertto-json
$RestReturn3 = Invoke-RestMethod -Method Put -Uri "http://localhost/xesterui/public/api/api.php/systems/1" -body $body
$UseableData3 = ConvertFrom-Json $RestReturn3
$UseableData3


#Inserting information
$body = @{ID = "7"; SYSTEM_Name = "HomeLab6"; Config_File = "c:\Program Files\WindowsPowerShell\Modules\Vester\1.1.0\Configs\Confisgs.json"; STATUS_ID = "11"} | convertto-json
$RestReturn4 = Invoke-RestMethod -Method Post -Uri "http://localhost/xesterui/public/api/api.php/systems" -Body $body 
$UseableData4 = ConvertFrom-Json $RestReturn4
$UseableData4

#Delete row
$RestReturn5 = Invoke-RestMethod -Method Delete -Uri "http://localhost/xesterui/public/api/api.php/systems/6"
$UseableData5 = ConvertFrom-Json $RestReturn5
$UseableData5

##############################################################
$RestReturn22 = Invoke-RestMethod -Method Get -Uri "http://localhost/xesterui/public/api/api.php/testrun?filter=STATUS_ID,eq,9"
$UseableData2 = $RestReturn22 

$records = $UseableData2.testrun.records
$records

#############################################################