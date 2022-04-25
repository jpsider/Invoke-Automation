### Anatomy of a RestPS Endpoint

The RestPS module creates a HttpListener that simply passes parameters from the clients request to a PowerShell process where the details are consumed. The entire web request process (inclusive of the response delivered to the client) is synchronous. You can choose to not block your endpoint script, but it is not recommended for GET, or POST requests. The response should be concise with whether or not the task was successful, not just received. It is the responsibility of the Endpoint script to consume the URL arguments and the body of the web request.

When you start an Endpoint you can specify several different parameters:

* Port
  * A Port can be specified, but is not required. The default is 8080.
* SSLThumbprint
  * A SSLThumbprint is used to identify the SSL certificate for the HTTPS binding, but is not required. If no SSLThumbprint is set, RestPS will default to HTTP traffic.
  * SSL can be used without a VerificationType
* RestPSLocalRoot
  * RestPSLocalRoot is a local directory where Endpoint scripts are stored, but is not required. The default is C:\\RestPS
* AppGuid
  * An AppGuid defines an application ID (not required). If a SSLThumbprint is specified, an AppGuid will be auto-generated unless supplied as a parameter.
* VerificationType
  * A VerificationType (optional) - accepted values:
    * VerifyRootCA - Verifies the Root Certificate Authority (CA) of the server and client certificate match.
    * VerifySubject - Verifies the RootCA, and the client is on a user provided Access Control List (ACL).
    * VerifyUserAuth - Provides an option for advanced authentication, plus the RootCA, subject checks.
* RoutesFilePath
  * A custom Routes file can be specified (highly recommended, but not required). A default file is included in the RestPS module and it expects the 'RestPSLocalRoot' to be C:\\RestPS.

# Other Modules used:
  jpsider
  carbon

### Here is the example Routes JSON file included in the RestPS module:
### Flip to the example Routes file

## Getting Started with a Simple HTTP Endpoint

Open two PowerShell consoles, 
  a REST server (RESTServerConsole) and one to represent a client (ClientConsole). 
  You can rename the PowerShell console title using the following command:

##############################
# Switch to RESTServerConsole
##############################
Update-ConsoleTitle -Title 'RESTServerConsole'

##############################
# Switch to ClientConsole
##############################
Update-ConsoleTitle -Title 'ClientConsole'


Be aware that the RestPS module will change the console title when starting an Endpoint. The format looks like this : _'RestPS - http(s):// - Port: XXXX'_.

To verify that an SSL certificate is not being used on port 8080 you can run the commands from the Carbon PowerShell module in the REST server console window.

##############################
# Switch to RESTServerConsole
##############################
Get-CSslCertificateBinding -IPAddress 0.0.0.0 -Port 8080

### Need to remove one?
# RESTServerConsole
# Remove a certificate binding from port 8080.
Remove-CSslCertificateBinding -IPAddress 0.0.0.0 -Port 8080
# Verify the binding was removed.
Get-CSslCertificateBinding -IPAddress 0.0.0.0 -Port 8080

#### Installing Required Modules

#### Configure the Local Directory Structure

##############################
# Switch to RESTServerConsole
##############################
Import-Module -Name RestPS
Invoke-DeployRestPS -LocalDir 'C:\RestPS'


#### Setting up a Non-Secure Endpoint

# RESTServerConsole
$RestPSparams = @{
  RoutesFilePath = 'C:\RestPS\endpoints\RestPSRoutes.json'
  Port = '8080'
}
Start-RestPSListener @RestPSparams

# This is a blocking command, from this point you will only see output
#   if and when a REST call is made to this endpoint.

##############################
# Switch to ClientConsole
##############################
# Perform Invoke-WebRequest
$WebRequestParams = @{
  Uri = 'http://localhost:8080/process?name=powershell'
  Method = 'Get'
  UseBasicParsing = $true
}

Invoke-WebRequest @WebRequestParams

(Invoke-WebRequest @WebRequestParams).content

# Perform Invoke-RestMethod
$RestMethodParams = @{
  Uri = 'http://localhost:8080/process?name=powershell'
  Method = 'Get'
  UseBasicParsing = $true
}
Invoke-RestMethod @RestMethodParams

# When you use a web browser to visit the same Endpoint the output/results are identical.

Start-Process http://localhost:8080/process?name=powershell

### Other Included endpoints
# Status
Invoke-RestMethod -Method Get -Uri http://localhost:8080/endpoint/status -UseBasicParsing
# Routes
Invoke-RestMethod -Method Get -Uri http://localhost:8080/endpoint/routes -UseBasicParsing

##### Shutting down the Endpoint
# ClientConsole
$RestMethodParams = @{
  Uri = 'http://localhost:8080/endpoint/shutdown'
  Method = 'Get'
  UseBasicParsing = $true
}
Invoke-RestMethod @RestMethodParams