# Need to import all the files first of course.

$BaseDir = "C:\OPEN_PROJECTS\Invoke-Automation\Powercli\VMWorld2018\FunctionBased"

Set-Location "C:\OPEN_PROJECTS\Invoke-Automation\Powercli\VMWorld2018\"

$FoundError = $false

$Directories = ("private", "public")
foreach ($Directory in $Directories)
{
    # Import the functions.
    $PSCodeHealthParameters = @{
        Path = ".\FunctionBased\$Directory\"
        TestsPath = ".\FunctionBased\tests\$Directory\"
        HtmlReportPath = "$BaseDir\vmworldReport_$Directory.html"
        PassThru = $true
    }
    $DirectoryResults = Invoke-PSCodeHealth @PSCodeHealthParameters

    if($DirectoryResults.CommandsMissedTotal -ne 0) {
        $MissedCommands = $DirectoryResults.CommandsMissedTotal
        $FoundError = $true
        Write-Output "Missed Commands for Directory: $Directory - ($MissedCommands)"
    }
    if($DirectoryResults.NumberOfFailedTests -ne 0) {
        $FailedTests
        $FoundError = $true
        Write-Output "Failed Tests for Directory: $Directory - ($FailedTests)"
    }
    # Open the Report in the default web browser.
    write-host "$BaseDir\vmworldReport_$Directory.html"
    Start-Process ("file:///$BaseDir\vmworldReport_$Directory.html")
}

if ($FoundError -eq $true)
{
    # An error was found in the Unit tests.
    Write-Error "An error has been found in the unit Tests. Please review them before commiting the code."
} 
else
{
    # No Errors found. Hooray!
    Write-Output "Tests cover 100% and all pass! Hooray!"
}