#Install-Module -Name PowerLumber
#Import-Module -Name PowerLumber

Write-Warning "Setting the RunLogLevel Variable controls the level of logs written to the logfile."
Write-Warning "All Message will print to the console unless 'OFF' is specified."
$script:RunLogLevel = "ERROR"
$logfile = "c:\temp\testing.log"

$Msg1 = "This is a TRACE Message"
$Msg2 = "This is a DEBUG Message"
$Msg3 = "This is a INFO Message"
$Msg4 = "This is a WARN Message"
$Msg5 = "This is a ERROR Message"
$Msg6 = "This is a FATAL Message"
$Msg7 = "This is a CONSOLEONLY Message"
$Msg8 = "This message has a hardcoded value for -RunLogLevel of ALL"

write-Warning "You could force a message to appear, by specifying all as the -RunLogLevel"
Write-LogLevel -Message $Msg8 -Logfile $logfile -RunLogLevel ALL -MsgLevel TRACE

function Invoke-DemoLogLevel {
	write-Warning "See which items write to the log file as you change -RunLogLevel"
	Write-LogLevel -Message $Msg1 -Logfile $logfile -RunLogLevel $script:RunLogLevel -MsgLevel TRACE
	Write-LogLevel -Message $Msg2 -Logfile $logfile -RunLogLevel $script:RunLogLevel -MsgLevel DEBUG
	Write-LogLevel -Message $Msg3 -Logfile $logfile -RunLogLevel $script:RunLogLevel -MsgLevel INFO
	Write-LogLevel -Message $Msg4 -Logfile $logfile -RunLogLevel $script:RunLogLevel -MsgLevel WARN
	Write-LogLevel -Message $Msg5 -Logfile $logfile -RunLogLevel $script:RunLogLevel -MsgLevel ERROR
	Write-LogLevel -Message $Msg6 -Logfile $logfile -RunLogLevel $script:RunLogLevel -MsgLevel FATAL
	Write-LogLevel -Message $Msg7 -Logfile $logfile -RunLogLevel $script:RunLogLevel -MsgLevel CONSOLEONLY
}
Invoke-DemoLogLevel

$script:RunLogLevel = "WARN"
write-Warning "You could force a message to appear, by specifying all as the -RunLogLevel"
Write-LogLevel -Message $Msg8 -Logfile $logfile -RunLogLevel ALL -MsgLevel TRACE

Invoke-DemoLogLevel

$script:RunLogLevel = "FATAL"
write-Warning "You could force a message to appear, by specifying all as the -RunLogLevel"
Write-LogLevel -Message $Msg8 -Logfile $logfile -RunLogLevel ALL -MsgLevel TRACE

Invoke-DemoLogLevel
