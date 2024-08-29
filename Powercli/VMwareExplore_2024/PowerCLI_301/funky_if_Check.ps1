$Db

$db = $null
$db = ''
$db = "test"


if (-not $db){
    write-host "I'm in side the if"
} else {
    write-Host "I'm in the else"
}