$PSCodeHealthParameters = @{
    Path           = ".\demo04.ps1"
    TestsPath      = ".\demo04.tests.ps1"
    HtmlReportPath = ".\Test_Results\PSCodeHealthReport.html"
    PassThru       = $true
}
$Results = Invoke-PSCodeHealth @PSCodeHealthParameters
if ($Results.CommandsMissedTotal -ne 0)
{
    $MissedCommands = $Results.CommandsMissedTotal
    Write-Output "Missed Commands - ($MissedCommands)"
}
if ($Results.NumberOfFailedTests -ne 0)
{
    $FailedTests
    Write-Output "Failed Tests - ($FailedTests)"
}

Start-Process (".\Test_Results\PSCodeHealthReport.html")