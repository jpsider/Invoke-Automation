##############################
# Switch to RESTServerConsole
##############################

## Securing your Endpoint

You can take advantage of SSL certificates to apply three different types of security based on your business needs.

* Enabling an Endpoint with SSL
* Client Verification
    * Access list
* Client Authentication
    * Password
    * Token


##############################
# Switch to RESTServerConsole
##############################
$RESTServerCert = Get-ChildItem -Path Cert:\LocalMachine\My\ | Where-Object { $_.Subject -eq 'CN=RESTServer.PowerShellDemo.io'}


### Enabling an Endpoint with SSL

This error; _'SSL Certificate deletion failed, Error: 2'_, caused by the failure to delete a non-existing binding, you can ignore this error.


# RESTServerConsole
$RESTServerThumbprint = $RESTServerCert.Thumbprint
$ListenerParams = @{
  RoutesFilePath = 'C:\RestPS\endpoints\RestPSRoutes.json'
  Port = '8080'
  SSLThumbprint = "$RESTServerThumbprint"
}
Start-RestPSListener @ListenerParams



##############################
# Switch to ClientConsole
##############################
$ClientCert = Get-ChildItem -Path Cert:\LocalMachine\My\ | Where-Object { $_.Subject -eq 'CN=DemoClient.PowerShellDemo.io'}
$badCert = Get-ChildItem -Path Cert:\LocalMachine\My\ | Where-Object { $_.Subject -eq 'CN=badCert.PowerShellDemo.io'}

# Try HTTP
$RestMethodParamsHttps = @{
  Uri = 'http://localhost:8080/process?name=powershell'
  Method = 'Get'
  UseBasicParsing = $true
}
Invoke-RestMethod @RestMethodParamsHttps


# Try HTTPS

$RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/process?name=powershell'
  Method = 'Get'
  UseBasicParsing = $true
}
Invoke-RestMethod @RestMethodParamsHttps

#The following error message reflects that the SSL binding is using a Self-Signed certificate; _Invoke-RestMethod : The underlying connection was closed: Could not establish trust relationship for the SSL/TLS secure channel._

To prevent this error, run the following command, `Disable-SSLValidation`, included with the RestPS module. Then run the `Invoke-RestMethod` again.


# ClientConsole
Disable-SSLValidation

# Rerun the command
Invoke-RestMethod @RestMethodParamsHttps

# Still works in a browser!
Start-Process https://localhost:8080/process?name=powershell


# Shutdown the Endpoint
$RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/endpoint/shutdown'
  Method = 'Get'
  UseBasicParsing = $true
}
Invoke-RestMethod @RestMethodParamsHttps


# Using SSL only, with no 'VerificationType' will give you a false sense of security. SSL by itself does not prevent unauthorized access, it simply establishes whether or not the client should trust the server.

## Client Verification
<#
For the RestPS, verification is used to ensure two main items:

* Both the client and RESTServer are using a certificate signed/created by the same RootCA.
* The RESTServer can validate that the client is permitted to access the specified data.

To accomplish this you need to understand the details that define a SSL certificate and how they can be used for client verification.

In order to enable basic client verification add the 'VerifyRootCA' option for the 'VerificationType' parameter. This will require the client to present a certificate signed by the same RootCA as the RESTServer.
#>

##############################
# Switch to RESTServerConsole
##############################
# Enable a SSL Endpoint with client certificate verification
$RESTServerParams = @{
  RoutesFilePath = 'C:\RestPS\endpoints\RestPSRoutes.json'
  Port = 8080
  SSLThumbprint = $RESTServerCert.Thumbprint
  VerificationType = 'VerifyRootCA'
}
Start-RestPSListener @RESTServerParams

##############################
# Switch to ClientConsole
##############################
# Execute an Invoke-RestMethod command with no client certificate (401)
$RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/process?name=powershell'
  Method = 'Get'
  UseBasicParsing = $true
}
Invoke-RestMethod @RestMethodParamsHttps


# Execute an Invoke-RestMethod command with a valid client certificate
$RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/process?name=powershell'
  Method = 'Get'
  Certificate = $ClientCert
  UseBasicParsing = $true
}
Invoke-RestMethod @RestMethodParamsHttps


# Shutdown the Endpoint
$RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/endpoint/shutdown'
  Method = 'Get'
  Certificate = $ClientCert
  UseBasicParsing = $true
}
Invoke-RestMethod @RestMethodParamsHttps

<#
The next layer of verification is Access Control. 
  This step includes verification that the client is on an ACL that allows access to the Endpoint. 
  RestPS includes an example file that is deployed to the bin directory. 
  The filename is called "Get-RestAclList.ps1" and is a place holder to add logic specific to your environment where you can generate a list of clients that have been granted access.

Client verification includes the 'VerifyRootCA' verification type that RestPS offers, if a client fails the RootCA check, the 'VerifySubject' check will also fail.
#>


# Example File

function Get-RestAclList
{
    # This function represents a way to gather a list to compare a client Subject/CN name.
    #   This is meant to be updated to suit your specific needs. Such as:
    #   Getting a list of names from Active Directory
    #   Getting a list of names from a real Certificate Authority 
    #     (or ensuring they are not on the certificate revocation list)
    #   Getting a list of names from a remote endpoint of a different web application
    $AclList = @('RESTServer', 'Client', 'DemoClient.PowerShellDemo.io')
    $AclList
}


# The 'VerifySubject' option for the 'VerificationType' parameter compares the Subject of the client certificate to an ACL generated by the `Get-RestAclList` command located in the bin directory. 
#   For each verification request an updated list is generated by the script to ensure the latest data is always referenced.


##############################
# Switch to RESTServerConsole
##############################
# Start an Endpoint with the 'VerifySubject' verification type.
$RESTServerParams = @{
  RoutesFilePath = 'C:\RestPS\endpoints\RestPSRoutes.json'
  Port = 8080
  SSLThumbprint = $RESTServerCert.Thumbprint
  VerificationType = 'VerifySubject'
}
Start-RestPSListener @RESTServerParams

##############################
# Switch to ClientConsole
##############################
# Perform a Invoke-RestMethod command with no client certificate
$RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/process?name=powershell'
  Method = 'Get'
  UseBasicParsing = $true
}
Invoke-RestMethod @RestMethodParamsHttps

# Execute an Invoke-RestMethod command with a known bad certificate
$RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/process?name=powershell'
  Method = 'Get'
  Certificate = $badCert
  UseBasicParsing = $true
}
Invoke-RestMethod @RestMethodParamsHttps


# Then execute the same REST Call with a known good client certificate.
$RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/process?name=powershell'
  Method = 'Get'
  Certificate = $ClientCert
  UseBasicParsing = $true
}
Invoke-RestMethod @RestMethodParamsHttps



# Shutdown the Endpoint
$RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/endpoint/shutdown'
  Method = 'Get'
  Certificate = $ClientCert
  UseBasicParsing = $true
}
Invoke-RestMethod @RestMethodParamsHttps


## Client Authentication

For the RestPS module, authentication is used to ensure that the client can provide a specific token before access is granted to the requested information. Authentication can come in many forms, including but not limited to:

* A password (encrypted/hashed)
* Web token
* RSA token

Client authentication includes two other 'VerificationType' options 'VerifyRootCA' and 'VerifySubject'. If a client fails either of these two verification methods, authentication will also fail.

### Authentication Example

To enable client authentication specify 'VerifyUserAuth' as the 'VerificationType' parameter. For the simplicity of this example a plain text string represents the token (NOT a recommended solution for a production environment).

RestPS includes an example file called "Get-RestUserAuth.ps1" that is deployed to the bin directory as a placeholder for logic specific to your environment where you can generate a list of clients that have been granted access. An example file:


function Get-RestUserAuth
{
    # This function represents a way to gather a UserAuth string.
    #   This is meant to be updated to suit your specific needs. Such as:
    #     Getting a password hash
    #     Getting a web token
    #     Or any other authentication type
  $UserAuth = @{
    UserData = @(
      @{
        UserName = 'DemoClient.PowerShellDemo.io'
        SystemAuthString = 'abcd1234'
      }
    )
  }
  $UserAuth
}


#The 'VerifyUserAuth' option for the 'VerificationType' parameter compares the token of the client authorization header property to a list generated by the `Get-RestUserAuth` located in the bin directory. For each authentication request an updated list is generated by the script to ensure the latest data is always referenced.


##############################
# Switch to RESTServerConsole
##############################
# Enable a SSL Endpoint with client authentication
$RESTServerParams = @{
  RoutesFilePath = 'C:\RestPS\endpoints\RestPSRoutes.json'
  Port = 8080
  SSLThumbprint = $RESTServerCert.Thumbprint
  VerificationType = 'VerifyUserAuth'
}
Start-RestPSListener @RESTServerParams

#In order for a client to authenticate with your new Endpoint an authorization type and string is required in the request headers.


##############################
# Switch to ClientConsole
##############################
$ClientHeaders = New-Object -TypeName `
'System.Collections.Generic.Dictionary[[String],[String]]'
$ClientHeaders.Add('Accept','Application/Json')
$ClientHeaders.Add('Authorization','Basic abcd1234')

# Perform Invoke-RestMethod command with no headers
$RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/process?name=powershell'
  Method = 'Get'
  Certificate = $ClientCert
  UseBasicParsing = $true
}
Invoke-RestMethod @RestMethodParamsHttps

401 Client failed Verification or Authentication

# Perform Invoke-RestMethod command with proper headers
$RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/process?name=powershell'
  Method = 'Get'
  Certificate = $ClientCert
  Headers = $ClientHeaders
  UseBasicParsing = $true
}
Invoke-RestMethod @RestMethodParamsHttps


# Shutdown the Endpoint
$RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/endpoint/shutdown'
  Method = 'Get'
  Certificate = $ClientCert
  Headers = $ClientHeaders
  UseBasicParsing = $true
}
Invoke-RestMethod @RestMethodParamsHttps

