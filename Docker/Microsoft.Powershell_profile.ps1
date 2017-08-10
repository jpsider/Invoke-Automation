# Generic global PowerShell profile
# Created 20160421 - Kevin Kirkpatrick (Twitter|GitHub @vScriper)
# Forked by (Twitter|GitHub @jpsider)
# Import profile configuration
$profileFunctionsPath = Join-Path $PSScriptRoot 'UpdateEnvironment.ps1'

if (Test-Path $profileFunctionsPath){
	Import-Module $profileFunctionsPath
} else {
	throw "Functions File Not Found {$profileFunctionsPath}"
} # end if

# Setup custom console colors
$hostUI                        = $host.PrivateData
$hostUI.ErrorForegroundColor   = 'White'
$hostUI.ErrorBackgroundColor   = 'Red'
$hostUI.DebugForegroundColor   = 'White'
$hostUI.DebugBackgroundColor   = 'DarkCyan'
$hostUI.VerboseBackgroundColor = 'DarkBlue'
$hostUI.VerboseForegroundColor = 'Cyan'

$consoleStatusCheck = $null
$consoleStatusCheck = Get-ConsoleStatus

#Give the user some feedback
Write-Host -Object '[PS Profile Load] Profile load complete.' -ForegroundColor Cyan -BackgroundColor DarkBLue
Write-Host ' '
Write-Host 'ComputerName: ' -NoNewline   ; Write-Host "  $($consoleStatusCheck.ComputerName)" -ForegroundColor Green
Write-Host 'User: ' -NoNewline 			 ; Write-Host "          $($consoleStatusCheck.User)" -ForegroundColor Green
Write-Host 'IsAdmin: ' -NoNewline        ; Write-Host "       $($consoleStatusCheck.IsAdmin)" -ForegroundColor Green
Write-Host 'PSVersion: ' -NoNewline      ; Write-Host "     $($consoleStatusCheck.PSVersion)" -ForegroundColor Green
Write-Host 'PSEdition: ' -NoNewline      ; Write-Host "     $($consoleStatusCheck.PSEdition)" -ForegroundColor Green
Write-Host ' '

#Adding Hack until powerNSX construction is over.
Import-Module c:\temp\PowerNSX.psm1

Write-host 'Importing Modules'
Start-PowerCLI
Start-Environment
Write-Host 'Enjoy Using PowerTools!'
Write-Host 'For more information visit http://invoke-automation.blog'