$WebRequestParams = @{
    Uri = 'http://localhost:8080/process?name=powershell'
    Method = 'Get'
    UseBasicParsing = $true
}
(Invoke-WebRequest @WebRequestParams).content

###
$RestMethodParams = @{
    Uri = 'http://localhost:8080/process?name=powershell'
    Method = 'Get'
    UseBasicParsing = $true
}
Invoke-RestMethod @RestMethodParams

# Capturing RestMethod Errors (Server not found)
try {
    $RestMethodParams = @{
        Uri = 'http://localhost:8081/process?name=powershell'
        Method = 'Get'
        UseBasicParsing = $true
    }
    Invoke-RestMethod @RestMethodParams
}
catch {
    $ErrorMessage = $_.Exception.Message
    Write-Host -ForegroundColor Yellow "The errorMessage: $errorMessage"
}

# Capturing RestMethod Errors (Route not found)
try {
    $RestMethodParams = @{
        Uri = 'http://localhost:8080/noroute'
        Method = 'Get'
        UseBasicParsing = $true
    }
    Invoke-RestMethod @RestMethodParams
}
catch {
    $ErrorMessage = $_.Exception.Message
    Write-Host -ForegroundColor Yellow "The errorMessage: $errorMessage"
}