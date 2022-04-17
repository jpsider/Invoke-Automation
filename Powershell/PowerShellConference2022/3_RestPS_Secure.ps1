When you start an Endpoint you can specify several different parameters:

* Port
  * A Port can be specified, but is not required. The default is 8080.
* SSLThumbprint
  * A SSLThumbprint is used to identify the SSL certificate for the HTTPS binding, but is not required. If no SSLThumbprint is set, RestPS will default to HTTP traffic.
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

Any directory can be specified for the LocalDir parameter when executing the `Invoke-DeployRestPS` command. If the default directory is not specified, all file path references in the 'Invoke-AvailableRouteSet.ps1' file will need to be updated with the value specified in the LocalDir parameter. A customized file can also be specified for the RoutesFilePath parameter when executing the `Start-RestPSListener` command, all routes listed in this custom file must have valid commands and file paths in order for the Endpoints to return expected data. The examples in this chapter utilize all default parameters.

If no VerificationType is specified, SSL can still be utilized.

```powershell
# Example RestPSRoutes.json included in the RestPS module.

### TODO
### Add minimum example Json file



##############################
# Switch to RESTServerConsole
##############################
$Host.UI.RawUI.WindowTitle = 'RESTServerConsole'
PS C:\>
##############################
# Switch to ClientConsole
##############################
$Host.UI.RawUI.WindowTitle = 'ClientConsole'


##############################
# Switch to RESTServerConsole
##############################
# Install the Carbon Module:
Install-Module -Name Carbon -AllowClobber
# List the bindings on port 8080.
Get-CSslCertificateBinding -IPAddress 0.0.0.0 -Port 8080

IPAddress  Port CertificateHash                          CertificateStoreName
---------  ---- ---------------                          --------------------
0.0.0.0    8080 661157d24ddb67801671751f7cd2abbd6bd4fa3b
PS C:\>
```

X> To remove a binding you can execute the following command from the Carbon PowerShell module:

```powershell
# RESTServerConsole
# Remove a certificate binding from port 8080.
Remove-CSslCertificateBinding -IPAddress 0.0.0.0 -Port 8080
# Verify the binding was removed (no output returned).
Get-CSslCertificateBinding -IPAddress 0.0.0.0 -Port 8080
PS C:\>
```

## Securing your Endpoint

Now that you have successfully created and tested your Endpoint it is time to secure it. You will take advantage of SSL certificates to apply three different types of security based on your business needs.

* Enabling an Endpoint with SSL
* Client Verification
* Client Authentication



```powershell
##############################
# Switch to RESTServerConsole
##############################
$RESTServerCert = Get-ChildItem -Path Cert:\LocalMachine\My\ |
Where-Object { $_.Subject -eq 'CN=RESTServer.PowerShellDemo.io'}
PS C:\>
```

### Enabling an Endpoint with SSL

You have now created a local certificate environment and can enable SSL for RESTful Endpoints. Add the SSLThumbprint parameter to the `Start-RestPSListener` command using the thumbprint value of the RESTServer certificate.

E> This error; _'SSL Certificate deletion failed, Error: 2'_, caused by the failure to delete a non-existing binding, you can ignore this error.

```powershell
# RESTServerConsole
$RESTServerThumbprint = $RESTServerCert.Thumbprint
$ListenerParams = @{
  RoutesFilePath = 'C:\RestPS\endpoints\RestPSRoutes.json'
  Port = '8080'
  SSLThumbprint = "$RESTServerThumbprint"
}
Start-RestPSListener @ListenerParams

SSL Certificate deletion failed, Error: 2
The system cannot find the file specified.

SSL Certificate successfully added

Starting: https:// Listener on Port: 8080
```

Once the Endpoint is started, you can rerun the previous command with a HTTPS prefix.

```powershell
##############################
# Switch to ClientConsole
##############################
$RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/process?name=powershell'
  Method = 'Get'
  UseBasicParsing = $true
}
Invoke-RestMethod @RestMethodParamsHttps
# Error:
#Invoke-RestMethod : The underlying connection was closed: Could not establish
#trust relationship for the SSL/TLS secure channel.
#At line:1 char:1
#+ Invoke-RestMethod @RestMethodParamsHttps
#+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#    + CategoryInfo          : InvalidOperation: (System.Net.HttpWebRequest:Htt
#   pWebRequest) [Invoke-RestMethod], WebException
#    + FullyQualifiedErrorId : WebCmdletWebResponseException,Microsoft.PowerShe
#   ll.Commands.InvokeRestMethodCommand
```

The following error message reflects that the SSL binding is using a Self-Signed certificate; _Invoke-RestMethod : The underlying connection was closed: Could not establish trust relationship for the SSL/TLS secure channel._

To prevent this error, run the following command, `Invoke-SSLIgnore`, included with the RestPS module. Then run the `Invoke-RestMethod` again.

```powershell
# ClientConsole
Invoke-SSLIgnore
True
# Rerun the command
Invoke-RestMethod @RestMethodParamsHttps

ProcessName    Id MainWindowTitle
-----------    -- ---------------
powershell   1992 Administrator: powershell.exe - Shortcut
powershell   3380 Administrator: powershell.exe - Shortcut
powershell   6668 RestPS - https:// - Port: 8080
powershell  11440
PS C:\>

# Shutdown the Endpoint
$RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/endpoint/shutdown'
  Method = 'Get'
  UseBasicParsing = $true
}
Invoke-RestMethod @RestMethodParamsHttps
```

Using SSL only, with no 'VerificationType' will give you a false sense of security. SSL by itself does not prevent unauthorized access, it simply establishes whether or not the client should trust the server. The next section will address the server verifying and authorizing the client. You will learn how to inspect the details of a SSL certificate using PowerShell.

## Client Verification

For the RestPS module, verification is used to ensure two main items:

* Both the client and RESTServer are using a certificate signed/created by the same RootCA.
* The RESTServer can validate that the client is permitted to access the specified data.

To accomplish this you need to understand the details that define a SSL certificate and how they can be used for client verification.

In order to enable basic client verification add the 'VerifyRootCA' option for the 'VerificationType' parameter. This will require the client to present a certificate signed by the same RootCA as the RESTServer.

```powershell
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

SSL Certificate successfully deleted

SSL Certificate successfully added

Starting: https:// Listener on Port: 8080

##############################
# Switch to ClientConsole
##############################
# Execute an Invoke-RestMethod command with no client certificate
$RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/process?name=powershell'
  Method = 'Get'
  UseBasicParsing = $true
}
Invoke-RestMethod @RestMethodParamsHttps

401 Client failed Verification or Authentication

# Execute an Invoke-RestMethod command with a valid client certificate
$RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/process?name=powershell'
  Method = 'Get'
  Certificate = $ClientCert
  UseBasicParsing = $true
}
Invoke-RestMethod @RestMethodParamsHttps

ProcessName    Id MainWindowTitle
-----------    -- ---------------
powershell   5708
powershell  10072 Administrator: powershell.exe - Shortcut
powershell  12772 RestPS - https:// - Port: 8080
PS C:\>

# Shutdown the Endpoint
$RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/endpoint/shutdown'
  Method = 'Get'
  Certificate = $ClientCert
  UseBasicParsing = $true
}
Invoke-RestMethod @RestMethodParamsHttps
```

The next layer of verification is Access Control. This step includes verification that the client is on an ACL that allows access to the Endpoint. RestPS includes an example file that is deployed to the bin directory. The filename is called "Get-RestAclList.ps1" and is a place holder to add logic specific to your environment where you can generate a list of clients that have been granted access.

Client verification includes the 'VerifyRootCA' verification type that RestPS offers, if a client fails the RootCA check, the 'VerifySubject' check will also fail.

```powershell
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
```

The 'VerifySubject' option for the 'VerificationType' parameter compares the Subject of the client certificate to an ACL generated by the `Get-RestAclList` command located in the bin directory. For each verification request an updated list is generated by the script to ensure the latest data is always referenced.

```powershell
##############################
# Switch to RESTServerConsole
##############################
# Start an Endpoint with the 'VerifySubject' verification type.
$RESTServerParams = @{
  RoutesFilePath = 'C:\RestPS\endpoints\Invoke-AvailableRouteSet.ps1'
  Port = 8080
  SSLThumbprint = $RESTServerCert.Thumbprint
  VerificationType = 'VerifySubject'
}
Start-RestPSListener @RESTServerParams

SSL Certificate successfully deleted

SSL Certificate successfully added

Starting: https:// Listener on Port: 8080

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

401 Client failed Verification or Authentication
PS C:\>
```

Now you can use the known invalid certificate and attempt to perform the REST call.

```powershell
# Execute an Invoke-RestMethod command with a known bad certificate
$RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/process?name=powershell'
  Method = 'Get'
  Certificate = $badCert
  UseBasicParsing = $true
}
Invoke-RestMethod @RestMethodParamsHttps

401 Client failed Verification or Authentication
PS C:\>

# Then execute the same REST Call with a known good client certificate.
$RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/process?name=powershell'
  Method = 'Get'
  Certificate = $ClientCert
  UseBasicParsing = $true
}
Invoke-RestMethod @RestMethodParamsHttps

ProcessName    Id MainWindowTitle
-----------    -- ---------------
powershell   5708
powershell  10072 Administrator: powershell.exe - Shortcut
powershell  12772 RestPS - https:// - Port: 8080
PS C:\>

# Shutdown the Endpoint
$RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/endpoint/shutdown'
  Method = 'Get'
  Certificate = $ClientCert
  UseBasicParsing = $true
}
Invoke-RestMethod @RestMethodParamsHttps
```

## Client Authentication

For the RestPS module, authentication is used to ensure that the client can provide a specific token before access is granted to the requested information. Authentication can come in many forms, including but not limited to:

* A password (encrypted/hashed)
* Web token
* RSA token

Client authentication includes two other 'VerificationType' options 'VerifyRootCA' and 'VerifySubject'. If a client fails either of these two verification methods, authentication will also fail.

### Authentication Example

To enable client authentication specify 'VerifyUserAuth' as the 'VerificationType' parameter. For the simplicity of this example a plain text string represents the token (NOT a recommended solution for a production environment).

RestPS includes an example file called "Get-RestUserAuth.ps1" that is deployed to the bin directory as a placeholder for logic specific to your environment where you can generate a list of clients that have been granted access. An example file:

```powershell
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
```

The 'VerifyUserAuth' option for the 'VerificationType' parameter compares the token of the client authorization header property to a list generated by the `Get-RestUserAuth` located in the bin directory. For each authentication request an updated list is generated by the script to ensure the latest data is always referenced.

```powershell
##############################
# Switch to RESTServerConsole
##############################
# Enable a SSL Endpoint with client authentication
$RESTServerParams = @{
  RoutesFilePath = 'C:\RestPS\endpoints\Invoke-AvailableRouteSet.ps1'
  Port = 8080
  SSLThumbprint = $RESTServerCert.Thumbprint
  VerificationType = 'VerifyUserAuth'
}
Start-RestPSListener @RESTServerParams

SSL Certificate successfully deleted

SSL Certificate successfully added

Starting: https:// Listener on Port: 8080
```

In order for a client to authenticate with your new Endpoint an authorization type and string is required in the request headers.

```powershell
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

ProcessName    Id MainWindowTitle
-----------    -- ---------------
powershell   5708
powershell  10072 Administrator: powershell.exe - Shortcut
powershell  12772 RestPS - https:// - Port: 8080
PS C:\>
# Shutdown the Endpoint
$RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/endpoint/shutdown'
  Method = 'Get'
  Certificate = $ClientCert
  Headers = $ClientHeaders
  UseBasicParsing = $true
}
Invoke-RestMethod @RestMethodParamsHttps
```
