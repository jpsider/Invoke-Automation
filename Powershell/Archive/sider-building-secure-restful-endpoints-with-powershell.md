# Building Secure RESTful Endpoints with PowerShell

A> ## by Justin P. Sider

## Prerequisites

This chapter assumes you're already at an intermediate skill level with PowerShell, Representational State Transfer (REST)ful Endpoints, and have a basic knowledge of using Secure Sockets Layer (SSL)/Certificates for security purposes. To follow along with the commands in this chapter, Windows PowerShell 5.1 is required. No other versions of PowerShell have been tested with the code referenced in this chapter. The RestPS PowerShell module version used for this chapter is 7.0.8. For the majority of this chapter, you will need to have two PowerShell consoles open at the same time, one to represent a REST Server (RESTServerConsole) and one to represent a Client (ClientConsole).

## Introduction

Creating RESTful Endpoints is a valuable tool to have in any environment. You have the flexibility to control what data is available and ensure controlled access to data. Using RESTful methods conforms to industry standards allowing your system users, external systems and software secure access to data. The Endpoints are a simple front end that provide secure access to commands and scripts on the endpoint machine.

The benefit of using RestPS is the availability of fine grain security controls available to each Endpoint, that you can customize to meet organizational needs. For example, a HelpDesk can be limited to only perform GET requests to diagnose problems while tier two support may possess additional access to perform PUT or POST requests to take action on the machine. Secure PowerShell Endpoints are great for reviewing sensor or remote health data and distributing the parsing of logs. RestPS can completely remove the need to use PowerShell Remoting as well as using Remote Desktop to interactively log in and execute scripts.

## The RestPS Module

RestPS is a PowerShell module that allows users to create secure RESTful Endpoints that can be customized to run any command or script located on the host machine. RestPS utilizes Microsoft's DotNet [HttpListener Class](https://docs.microsoft.com/en-us/dotnet/api/system.net.httplistener?view=netframework-4.7.1) to create Secure Endpoints via Secure Socket Layers (SSL). In addition to SSL, you are able to enable Client authentication and authorization.

You can customize each standard REST verbs/Methods (GET, PUT, POST, DELETE) or create your own verb/Method. The RestPS module is [OpenSource](https://github.com/jpsider/RestPS) and available to download via the [PowerShell Gallery](https://www.powershellgallery.com/packages/RestPS/7.0.8).

### Anatomy of a RestPS Endpoint

The RestPS module creates a HttpListener that simply passes parameters from the clients request to a PowerShell process where the details are consumed. The entire web request process (inclusive of the response delivered to the client) is synchronous. You can choose to not block your endpoint script, but it is not recommended for GET, or POST requests. The response should be concise with whether or not the task was successful, not just received. It is the responsibility of the Endpoint script to consume the URL arguments and the body of the web request.

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

T> If no VerificationType is specified, SSL can still be utilized.

All of the Endpoints tasks/actions are defined in the Routes file. During the execution of each web request the Routes file is loaded/re-loaded into memory and the appropriate route command/file is executed. Loading the Routes file on each request allows you to add or edit any Route without having to restart the Endpoint. Here is the example Routes file included in the RestPS module:

```powershell
# Example Invoke-AvailableRouteSet.ps1 included in the RestPS module.
function Invoke-AvailableRouteSet
{
  <#
  .DESCRIPTION
    This function defines available Routes (REST methods and commands/scripts).
  .EXAMPLE
    Invoke-AvailableRouteSet
  .NOTES
    This will return specified data to the client.
  #>
  $script:Routes = @(
    @{
      'RequestType'    = 'GET'
      'RequestURL'     = '/proc'
      'RequestCommand' = 'Get-Process |
      Select-Object -Property ProcessName,Id,MainWindowTitle'
    }
    @{
      'RequestType'    = 'GET'
      'RequestURL'     = '/process'
      'RequestCommand' = 'C:\RestPS\endpoints\GET\Invoke-GetProcess.ps1'
    }
    @{
      'RequestType'    = 'GET'
      'RequestURL'     = '/endpoint/status'
      'RequestCommand' = 'return 1'
    }
    @{
      'RequestType'    = 'PUT'
      'RequestURL'     = '/Service'
      'RequestCommand' = 'C:\RestPS\endpoints\PUT\Invoke-GetProcess.ps1'
    }
    @{
      'RequestType'    = 'POST'
      'RequestURL'     = '/data'
      'RequestCommand' = 'C:\RestPS\endpoints\POST\Invoke-GetProcess.ps1'
    }
    @{
      'RequestType'    = 'POST'
      'RequestURL'     = '/processbody'
      'RequestCommand' = 'C:\RestPS\endpoints\POST\Invoke-GetProcessBody.ps1'
    }
    @{
      'RequestType'    = 'DELETE'
      'RequestURL'     = '/data'
      'RequestCommand' = 'C:\RestPS\endpoints\DELETE\Invoke-GetProcess.ps1'
    }
  )
}
Invoke-AvailableRouteSet
```

## Getting Started with a Simple HTTP Endpoint

To demonstrate the basic functionality of RestPS begin with a single HTTP endpoint that provides no security. This is not a recommended practice, but is intended to familiarize you with the commands to create an Endpoint, understand the application structure, and test the functionality. You should never deploy an PowerShell Endpoint or application to a production system with no security.

### Configuring your Environment for this Chapter

Creating a clean environment is very important when running any script or application. Before you begin, verify port 8080 is not currently being utilized.

I> The `Import-Module` command requires the script execution policy be set to [RemoteSigned](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-6) or [less restricted policy](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-6&viewFallbackFrom=powershell-Microsoft.PowerShell.Core).

```powershell
# Determine the current script execution policy.
PS C:\> Get-ExecutionPolicy
Restricted

# Execute the following command to change the PowerShell execution policy.
PS C:\> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

# Verify the command updated the script execution policy.
PS C:\> Get-ExecutionPolicy
RemoteSigned
PS C:\>
```

X> Open two PowerShell consoles **with elevated privileges or an account with administrative access**, a REST server (RESTServerConsole) and one to represent a client (ClientConsole). You can rename the PowerShell console title using the following command:

```powershell
##############################
# Switch to RESTServerConsole
##############################
PS C:\> $Host.UI.RawUI.WindowTitle = 'RESTServerConsole'
PS C:\>
##############################
# Switch to ClientConsole
##############################
PS C:\> $Host.UI.RawUI.WindowTitle = 'ClientConsole'
PS C:\>
```

W> Be aware that the RestPS module will change the console title when starting an Endpoint. The format looks like this : _'RestPS - http(s):// - Port: XXXX'_.

To verify that an SSL certificate is not being used on port 8080 you can run the commands from the Carbon PowerShell module in the REST server console window.

```powershell
##############################
# Switch to RESTServerConsole
##############################
# Install the Carbon Module:
PS C:\> Install-Module -Name Carbon -AllowClobber
# List the bindings on port 8080.
PS C:\> Get-SslCertificateBinding -IPAddress 0.0.0.0 -Port 8080

IPAddress  Port CertificateHash                          CertificateStoreName
---------  ---- ---------------                          --------------------
0.0.0.0    8080 661157d24ddb67801671751f7cd2abbd6bd4fa3b
PS C:\>
```

X> To remove a binding you can execute the following command from the Carbon PowerShell module:

```powershell
# RESTServerConsole
# Remove a certificate binding from port 8080.
PS C:\> Remove-SslCertificateBinding -IPAddress 0.0.0.0 -Port 8080
# Verify the binding was removed (no output returned).
PS C:\> Get-SslCertificateBinding -IPAddress 0.0.0.0 -Port 8080
PS C:\>
```

E> If there is no SSL certificate to delete you will receive this error: _SSL Certificate deletion failed, Error: 2 The system cannot find the file specified._

#### Installing Required Modules

X> First ensure you can find the module in the [PowerShell Gallery](https://www.powershellgallery.com/packages/RestPS/7.0.8). This will require the computer have a connection to the Internet.

```powershell
# RESTServerConsole
PS C:\> Find-Module -Name RestPS -RequiredVersion 7.0.8 -Repository PSGallery

Version    Name                                Repository           Description
-------    ----                                ----------           -----------
7.0.8      RestPS                              PSGallery            PowerShe...

PS C:\>
```

X> Install the RestPS module using the following parameters.

```powershell
# RESTServerConsole
PS C:\> $InstallParams = @{
  Name = 'RestPS'
  RequiredVersion = '7.0.8'
  Repository = 'PSGallery'
  Scope = 'AllUsers'
  Force = $true
}
PS C:\> Install-Module @InstallParams
PS C:\>
```

X> Verify the module is installed by utilizing `Get-Module`.

```powershell
# RESTServerConsole
PS C:\> Get-Module -Name RestPS -ListAvailable

    Directory: C:\Program Files\WindowsPowerShell\Modules

ModuleType Version    Name                                ExportedCommands
---------- -------    ----                                ----------------
Script     7.0.8      RestPS                              {Invoke-DeployRest...
Script     7.0.0      RestPS                              {Invoke-DeployRest...
Script     6.0.2      RestPS                              Start-RestPSListener

PS C:\>
```

#### Configure the Local Directory Structure

RestPS comes with built in functionality to create a local directory structure where all of the Endpoint data is stored and executed. The following command will create the local structure and copy the example files to the specified location. The default base directory is 'C:\\RestPS'. Running this command will output details to the console.

```powershell
# RESTServerConsole
PS C:\> Import-Module -Name RestPS
PS C:\> Invoke-DeployRestPS -LocalDir 'C:\RestPS'

# This will output a list of directories created and files copied. (output not shown)
PS C:\>
```

#### Your First Endpoint

Use the files included within the RestPS module to create your first Endpoint. An example Routes file has been included in the root of the Endpoints directory. Run the following command to start an HTTP Endpoint on port 8080:

```powershell
# RESTServerConsole
PS C:\> $RestPSparams = @{
  RoutesFilePath = 'C:\RestPS\endpoints\Invoke-AvailableRouteSet.ps1'
  Port = '8080'
}
PS C:\> Start-RestPSListener @RestPSparams
Starting: http:// Listener on Port: 8080
# This is a blocking command, from this point you will only see output
#   if and when a REST call is made to this endpoint.
```

X> Now use `Invoke-WebRequest` or `Invoke-RestMethod` to access the data the Endpoint is providing.

In this example, you will retrieve a list of running PowerShell processes with their ProcessName, ID and MainWindowTitle (console title).

```powershell
##############################
# Switch to ClientConsole
##############################
# Perform Invoke-WebRequest
PS C:\> $WebRequestParams = @{
  Uri = 'http://localhost:8080/process?name=powershell'
  Method = 'Get'
  UseBasicParsing = $true
}

PS C:\> (Invoke-WebRequest @WebRequestParams).content
# command output:
[
    {
        "ProcessName":  "powershell",
        "Id":  1992,
        "MainWindowTitle":  "Administrator: powershell.exe - Shortcut"
    },
    {
        "ProcessName":  "powershell",
        "Id":  6668,
        "MainWindowTitle":  "RestPS - http:// - Port: 8080"
    },
    {
        "ProcessName":  "powershell",
        "Id":  11440,
        "MainWindowTitle":  ""
    }
]
# ClientConsole
# Perform Invoke-RestMethod
PS C:\> $RestMethodParams = @{
  Uri = 'http://localhost:8080/process?name=powershell'
  Method = 'Get'
  UseBasicParsing = $true
}
PS C:\> Invoke-RestMethod @RestMethodParams

ProcessName    Id MainWindowTitle
-----------    -- ---------------
powershell   1992 Administrator: powershell.exe - Shortcut
powershell   3380 Administrator: powershell.exe - Shortcut
powershell   6668 RestPS - http:// - Port: 8080
powershell  11440

PS C:\>
```

I> When you use a web browser to visit the same Endpoint the output/results are identical.

```powershell
PS C:\> Start-Process http://localhost:8080/process?name=powershell
```

![Firefox rendering of the same Endpoint](images/sider-endpoint-browser-view.png)

##### Shutting down the Endpoint

Run the following command to shutdown the Endpoint:

```powershell
# ClientConsole
PS C:\> $RestMethodParams = @{
  Uri = 'http://localhost:8080/endpoint/shutdown'
  Method = 'Get'
  UseBasicParsing = $true
}
PS C:\> Invoke-RestMethod @RestMethodParams
Shutting down ReST Endpoint.
PS C:\>
```

W> In the following section the client will need to have the appropriate access to shutdown the Endpoint. Be sure to shutdown the Endpoint before starting the next section in this chapter.

## Securing your Endpoint

Now that you have successfully created and tested your Endpoint it's time to secure it. You will take advantage of SSL certificates to apply three different types of security based on your business needs.

* Enabling an Endpoint with SSL
* Client Verification
* Client Authentication

### Creating local Test Certificate Structure

In order to test locally create a simple hierarchy of certificates.

* Local Root Certificate Authority (CA)
  * This will be used to sign the server and client certificate.
* REST Server Certificate
  * This will be used to bind the HTTPS listener to the specified port.
* Client Certificate
  * This will be used when you access the SSL Endpoint.

#### Define, Create, Review and Import the RootCA

Creating a local RootCA is simple with the `New-SelfSignedCertificate` command. Ensure you review the parameters carefully. Once created, import the RootCA to the Root Certificate Store. Throughout this chapter you have the option to add a password to the certificates which is highly recommended. Passwords were not used below in order to simplify the commands and potential added complexity.

```powershell
# ClientConsole
# Edit parameters to create local RootCA
PS C:\> $rootCAparams = @{
  DnsName = 'PowerShellDemo.io Root Cert'
  KeyLength = 2048
  KeyAlgorithm = 'RSA'
  HashAlgorithm = 'SHA256'
  KeyExportPolicy = 'Exportable'
  NotAfter = (Get-Date).AddYears(5)
  CertStoreLocation = 'Cert:\LocalMachine\My'
  KeyUsage = 'CertSign','CRLSign' #fixes invalid certificate error
}
# Create the certificate
PS C:\> $rootCA = New-SelfSignedCertificate @rootCAparams
PS C:\> $rootCA

   PSParentPath: Microsoft.PowerShell.Security\Certificate::LocalMachine\My

Thumbprint                                Subject
----------                                -------
8576D38B872A1C3E7AA363BDC1DA0300CF2E7E88  CN=PowerShellDemo.io Root Cert

# Add/Import the RootCA to the 'Root' Certificate Store
PS C:\> $CertStore = New-Object -TypeName `
System.Security.Cryptography.X509Certificates.X509Store(
[System.Security.Cryptography.X509Certificates.StoreName]::Root,
'LocalMachine')
PS C:\> $CertStore.open('MaxAllowed')
PS C:\> $CertStore.add($rootCA)
PS C:\> $CertStore.close()
PS C:\>
```

#### Define, Create and Review the RESTServer Certificate

Using the `New-SelfSignedCertificate` command, create a certificate for the REST server. This certificate will remain in the My Certificate Store; review the parameters carefully to ensure you include the newly created RootCA as the 'Signer'.

```powershell
# ClientConsole
PS C:\> $params = @{
  DnsName = 'RESTServer.PowerShellDemo.io'
  Signer = $rootCA # <------ Notice the Signer is the newly created RootCA
  KeyLength = 2048
  KeyAlgorithm = 'RSA'
  HashAlgorithm = 'SHA256'
  KeyExportPolicy = 'Exportable'
  NotAfter = (Get-Date).AddYears(2)
  CertStoreLocation = 'Cert:\LocalMachine\My'
}
PS C:\> $RESTServerCert = New-SelfSignedCertificate @params
PS C:\> $RESTServerCert

   PSParentPath: Microsoft.PowerShell.Security\Certificate::LocalMachine\My

Thumbprint                                Subject
----------                                -------
F17FD4BC4D14EF9E2CBE6A55A2D855D830FE23D0  CN=RESTServer.PowerShellDemo.io

PS C:\>
```

#### Define, Create and Review the Client Certificate

Using the `New-SelfSignedCertificate` command, create a certificate for the client. This certificate will remain in the My Certificate Store; review the parameters carefully to ensure you include the newly created RootCA as the 'Signer'.

```powershell
# ClientConsole
PS C:\> $params = @{
  DnsName = 'DemoClient.PowerShellDemo.io'
  FriendlyName = 'DemoClient'
  Signer = $rootCA # <------ Notice the Signer is the newly created RootCA
  KeyLength = 2048
  KeyAlgorithm = 'RSA'
  HashAlgorithm = 'SHA256'
  KeyExportPolicy = 'Exportable'
  NotAfter = (Get-Date).AddYears(2)
  CertStoreLocation = 'Cert:\LocalMachine\My'
}
PS C:\> $ClientCert = New-SelfSignedCertificate @params
PS C:\> $ClientCert

   PSParentPath: Microsoft.PowerShell.Security\Certificate::LocalMachine\My

Thumbprint                                Subject
----------                                -------
B2B3497FE918666C5CCB7AEE178C8134D61E8F95  CN=DemoClient.PowerShellDemo.io

# Create a invalid certificate for use in a failure scenario.
PS C:\> $params = @{
  DnsName = 'badCert.PowerShellDemo.io'
  FriendlyName = 'badCert'
  Signer = $rootCA # <------ Notice the Signer is the newly created RootCA
  KeyLength = 2048
  KeyAlgorithm = 'RSA'
  HashAlgorithm = 'SHA256'
  KeyExportPolicy = 'Exportable'
  NotAfter = (Get-Date).AddYears(2)
  CertStoreLocation = 'Cert:\LocalMachine\My'
}
PS C:\> $badCert = New-SelfSignedCertificate @params
PS C:\> $badCert

   PSParentPath: Microsoft.PowerShell.Security\Certificate::LocalMachine\My

Thumbprint                                Subject
----------                                -------
02D48DA2E49075BD15489F7B5466B503C9F2183E  CN=badCert.PowerShellDemo.io
```

#### Review the list of Certificates in 'My' Certificate Store

Notice all four newly created certificates are listed.

```powershell
# ClientConsole
PS C:\> Get-ChildItem -Path Cert:\LocalMachine\My\

   PSParentPath: Microsoft.PowerShell.Security\Certificate::LocalMachine\My

Thumbprint                                Subject
----------                                -------
F17FD4BC4D14EF9E2CBE6A55A2D855D830FE23D0  CN=RESTServer.PowerShellDemo.io
B2B3497FE918666C5CCB7AEE178C8134D61E8F95  CN=DemoClient.PowerShellDemo.io
8576D38B872A1C3E7AA363BDC1DA0300CF2E7E88  CN=PowerShellDemo.io Root Cert
02D48DA2E49075BD15489F7B5466B503C9F2183E  CN=badCert.PowerShellDemo.io

PS C:\>
```

List of certificates in the Root Store (full list not shown), notice the newly created local RootCA.

```powershell
# ClientConsole
PS C:\> Get-ChildItem -Path Cert:\LocalMachine\Root\

   PSParentPath: Microsoft.PowerShell.Security\Certificate::LocalMachine\Root

Thumbprint                                Subject
----------                                -------
CDD4EEAE6000AC7F40C3802C171E30148030C072  CN=Microsoft Root Certificate Auth...
BE36A4562FB2EE05DBB3D32323ADF445084ED656  CN=Thawte Timestamping CA, OU=Thaw...
A43489159A520F0D93D032CCAF37E7FE20A8B419  CN=Microsoft Root Authority, OU=Mi...
92B46C76E13054E104F230517E6E504D43AB10B5  CN=Symantec Enterprise Mobile Root...
8F43288AD272F3103B6FB1428485EA3014C0BCFE  CN=Microsoft Root Certificate Auth...
8576D38B872A1C3E7AA363BDC1DA0300CF2E7E88  CN=PowerShellDemo.io Root Cert
7F88CD7223F3C813818C994614A89C99FA3B5247  CN=Microsoft Authenticode(tm) Root...

# This list was cropped, expect to see additional entries.
PS C:\>
```

T> Set a certificate as a variable by using the `Get-ChildItem` command specifying the unique Thumbprint. This is useful when opening a new console to execute commands.

```powershell
##############################
# Switch to RESTServerConsole
##############################
PS C:\> $RESTServerCert = Get-ChildItem -Path Cert:\LocalMachine\My\ |
Where-Object { $_.Subject -eq 'CN=RESTServer.PowerShellDemo.io'}
PS C:\>
```

### Enabling an Endpoint with SSL

You have now created a local certificate environment and can enable SSL for RESTful Endpoints. Add the SSLThumbprint parameter to the `Start-RestPSListener` command using the thumbprint value of the RESTServer certificate.

E> This error; _'SSL Certificate deletion failed, Error: 2'_, caused by the failure to delete a non-existing binding, you can ignore this error.

```powershell
# RESTServerConsole
PS C:\> $RESTServerThumbprint = $RESTServerCert.Thumbprint
PS C:\> $ListenerParams = @{
  RoutesFilePath = 'C:\RestPS\endpoints\Invoke-AvailableRouteSet.ps1'
  Port = '8080'
  SSLThumbprint = "$RESTServerThumbprint"
}
PS C:\> Start-RestPSListener @ListenerParams

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
PS C:\> $RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/process?name=powershell'
  Method = 'Get'
  UseBasicParsing = $true
}
PS C:\> Invoke-RestMethod @RestMethodParamsHttps
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

E> The following error message reflects that the SSL binding is using a Self-Signed certificate; _Invoke-RestMethod : The underlying connection was closed: Could not establish trust relationship for the SSL/TLS secure channel._

T> To prevent this error, run the following command, `Invoke-SSLIgnore`, included with the RestPS module. Then run the `Invoke-RestMethod` again.

```powershell
# ClientConsole
PS C:\> Invoke-SSLIgnore
True
# Rerun the command
PS C:\> Invoke-RestMethod @RestMethodParamsHttps

ProcessName    Id MainWindowTitle
-----------    -- ---------------
powershell   1992 Administrator: powershell.exe - Shortcut
powershell   3380 Administrator: powershell.exe - Shortcut
powershell   6668 RestPS - https:// - Port: 8080
powershell  11440
PS C:\>

# Shutdown the Endpoint
PS C:\> $RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/endpoint/shutdown'
  Method = 'Get'
  UseBasicParsing = $true
}
PS C:\> Invoke-RestMethod @RestMethodParamsHttps
```

D> Using SSL only, with no 'VerificationType' will give you a false sense of security. SSL by itself does not prevent unauthorized access, it simply establishes whether or not the client should trust the server. The next section will address the server verifying and authorizing the client. You will learn how to inspect the details of a SSL certificate using PowerShell.

## Client Verification

For the RestPS module, verification is used to ensure two main items:

* Both the client and RESTServer are using a certificate signed/created by the same RootCA.
* The RESTServer can validate that the client is permitted to access the specified data.

To accomplish this you need to understand the details that define a SSL certificate and how they can be used for client verification.

### Exploring Certificates with PowerShell

W> Viewing the Issuer of a certificate appears to list the RootCA of the certificate. While this seems like a good way to verify if a client is valid, it can easily be spoofed with a Self-Signed CA.

```powershell
# ClientConsole
PS C:\> $RESTServerCert.Issuer
CN=PowerShellDemo.io Root Cert
PS C:\>
```

Get the certificate 'Extensions' for more details about the authenticity of a certificate.

```powershell
# ClientConsole
PS C:\> $RESTServerCert.Extensions
       KeyUsages Critical Oid                              RawData
       --------- -------- ---                              -------
DigitalSignature     True System.Security.Cryptography.Oid {3, 2, 5, 160}
                    False System.Security.Cryptography.Oid {48, 20, 6, 8...}
                    False System.Security.Cryptography.Oid {48, 30, 130, 28...}
                    False System.Security.Cryptography.Oid {48, 22, 128, 20...}
                    False System.Security.Cryptography.Oid {4, 20, 34, 81...}
PS C:\>
```

Ensure the server certificate's 'Authority Key Identifier' (AKI) matches the AKI of a client certificate to verify the certificate authenticity. The AKI can be referenced by a value of '2.5.29.35' found in the Oid property of an Extension Item. Once you find the correct Oid property compare the 'RawData' values to verify if the two certificates were signed by the same RootCA.

X> Retrieving the AKI of signed certificates.

```powershell
# ClientConsole
# Identify the RESTServer certificate AKI
PS C:\> $RESTServerCert.Extensions |
Where-Object {$_.Oid.Value -match '2.5.29.35'}

Critical Oid                              RawData
-------- ---                              -------
   False System.Security.Cryptography.Oid {48, 22, 128, 20...}
PS C:\>

# Identify the client certificate AKI
PS C:\> $ClientCert.Extensions |
Where-Object {$_.Oid.Value -match '2.5.29.35'}

Critical Oid                              RawData
-------- ---                              -------
   False System.Security.Cryptography.Oid {48, 22, 128, 20...}
PS C:\>
```

As shown, the client and RESTServer certificates appear to have matching values in the RawData property. To view the value of the RawData run the following command (output not shown):

```powershell
# ClientConsole
PS C:\> ($RESTServerCert.Extensions |
Where-Object {$_.Oid.Value -match '2.5.29.35'}).RawData
# output not shown
PS C:\>
```

### Verification Example

In order to enable basic client verification add the 'VerifyRootCA' option for the 'VerificationType' parameter. This will require the client to present a certificate signed by the same RootCA as the RESTServer.

```powershell
##############################
# Switch to RESTServerConsole
##############################
# Enable a SSL Endpoint with client certificate verification
PS C:\> $RESTServerParams = @{
  RoutesFilePath = 'C:\RestPS\endpoints\Invoke-AvailableRouteSet.ps1'
  Port = 8080
  SSLThumbprint = $RESTServerCert.Thumbprint
  VerificationType = 'VerifyRootCA'
}
PS C:\> Start-RestPSListener @RESTServerParams

SSL Certificate successfully deleted

SSL Certificate successfully added

Starting: https:// Listener on Port: 8080

##############################
# Switch to ClientConsole
##############################
# Execute an Invoke-RestMethod command with no client certificate
PS C:\> $RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/process?name=powershell'
  Method = 'Get'
  UseBasicParsing = $true
}
PS C:\> Invoke-RestMethod @RestMethodParamsHttps

401 Client failed Verification or Authentication

# Execute an Invoke-RestMethod command with a valid client certificate
PS C:\> $RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/process?name=powershell'
  Method = 'Get'
  Certificate = $ClientCert
  UseBasicParsing = $true
}
PS C:\> Invoke-RestMethod @RestMethodParamsHttps

ProcessName    Id MainWindowTitle
-----------    -- ---------------
powershell   5708
powershell  10072 Administrator: powershell.exe - Shortcut
powershell  12772 RestPS - https:// - Port: 8080
PS C:\>

# Shutdown the Endpoint
PS C:\> $RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/endpoint/shutdown'
  Method = 'Get'
  Certificate = $ClientCert
  UseBasicParsing = $true
}
PS C:\> Invoke-RestMethod @RestMethodParamsHttps
```

The next layer of verification is Access Control. This step includes verification that the client is on an ACL that allows access to the Endpoint. RestPS includes an example file that is deployed to the bin directory. The filename is called "Get-RestAclList.ps1" and is a place holder to add logic specific to your environment where you can generate a list of clients that have been granted access.

I> Client verification includes the 'VerifyRootCA' verification type that RestPS offers, if a client fails the RootCA check, the 'VerifySubject' check will also fail.

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
PS C:\> $RESTServerParams = @{
  RoutesFilePath = 'C:\RestPS\endpoints\Invoke-AvailableRouteSet.ps1'
  Port = 8080
  SSLThumbprint = $RESTServerCert.Thumbprint
  VerificationType = 'VerifySubject'
}
PS C:\> Start-RestPSListener @RESTServerParams

SSL Certificate successfully deleted

SSL Certificate successfully added

Starting: https:// Listener on Port: 8080

##############################
# Switch to ClientConsole
##############################
# Perform a Invoke-RestMethod command with no client certificate
PS C:\> $RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/process?name=powershell'
  Method = 'Get'
  UseBasicParsing = $true
}
PS C:\> Invoke-RestMethod @RestMethodParamsHttps

401 Client failed Verification or Authentication
PS C:\>
```

Now you can use the known invalid certificate and attempt to perform the REST call.

```powershell
# Execute an Invoke-RestMethod command with a known bad certificate
PS C:\> $RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/process?name=powershell'
  Method = 'Get'
  Certificate = $badCert
  UseBasicParsing = $true
}
PS C:\> Invoke-RestMethod @RestMethodParamsHttps

401 Client failed Verification or Authentication
PS C:\>

# Then execute the same REST Call with a known good client certificate.
PS C:\> $RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/process?name=powershell'
  Method = 'Get'
  Certificate = $ClientCert
  UseBasicParsing = $true
}
PS C:\> Invoke-RestMethod @RestMethodParamsHttps

ProcessName    Id MainWindowTitle
-----------    -- ---------------
powershell   5708
powershell  10072 Administrator: powershell.exe - Shortcut
powershell  12772 RestPS - https:// - Port: 8080
PS C:\>

# Shutdown the Endpoint
PS C:\> $RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/endpoint/shutdown'
  Method = 'Get'
  Certificate = $ClientCert
  UseBasicParsing = $true
}
PS C:\> Invoke-RestMethod @RestMethodParamsHttps
```

## Client Authentication

For the RestPS module, authentication is used to ensure that the client can provide a specific token before access is granted to the requested information. Authentication can come in many forms, including but not limited to:

* A password (encrypted/hashed)
* Web token
* RSA token

I> Client authentication includes two other 'VerificationType' options 'VerifyRootCA' and 'VerifySubject'. If a client fails either of these two verification methods, authentication will also fail.

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
PS C:\> $RESTServerParams = @{
  RoutesFilePath = 'C:\RestPS\endpoints\Invoke-AvailableRouteSet.ps1'
  Port = 8080
  SSLThumbprint = $RESTServerCert.Thumbprint
  VerificationType = 'VerifyUserAuth'
}
PS C:\> Start-RestPSListener @RESTServerParams

SSL Certificate successfully deleted

SSL Certificate successfully added

Starting: https:// Listener on Port: 8080
```

In order for a client to authenticate with your new Endpoint an authorization type and string is required in the request headers.

```powershell
##############################
# Switch to ClientConsole
##############################
PS C:\> $ClientHeaders = New-Object -TypeName `
'System.Collections.Generic.Dictionary[[String],[String]]'
PS C:\> $ClientHeaders.Add('Accept','Application/Json')
PS C:\> $ClientHeaders.Add('Authorization','Basic abcd1234')

# Perform Invoke-RestMethod command with no headers
PS C:\> $RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/process?name=powershell'
  Method = 'Get'
  Certificate = $ClientCert
  UseBasicParsing = $true
}
PS C:\> Invoke-RestMethod @RestMethodParamsHttps

401 Client failed Verification or Authentication

# Perform Invoke-RestMethod command with proper headers
PS C:\> $RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/process?name=powershell'
  Method = 'Get'
  Certificate = $ClientCert
  Headers = $ClientHeaders
  UseBasicParsing = $true
}
PS C:\> Invoke-RestMethod @RestMethodParamsHttps

ProcessName    Id MainWindowTitle
-----------    -- ---------------
powershell   5708
powershell  10072 Administrator: powershell.exe - Shortcut
powershell  12772 RestPS - https:// - Port: 8080
PS C:\>
# Shutdown the Endpoint
PS C:\> $RestMethodParamsHttps = @{
  Uri = 'https://localhost:8080/endpoint/shutdown'
  Method = 'Get'
  Certificate = $ClientCert
  Headers = $ClientHeaders
  UseBasicParsing = $true
}
PS C:\> Invoke-RestMethod @RestMethodParamsHttps
```

## Other Useful Information

### Common Errors

Common errors encountered with initial use of RestPS.

E> _'404 No Matching Routes'_

Verify that your URI exists in the Available Routes File.

E> _'400 Invalid Command'_

Verify the PowerShell script properly handles all parameters and errors. Above error indicates there was an exception not properly handled.

E> _'Invoke-StartListener: Exception calling "Start" with "0" argument(s): "Failed to listen on prefix 'http://+:8080/' because it conflicts with an existing registration on the machine."'_

Verify that no other process is listening on the desired port. If there is, review the OwningProcess ID and determine if you can safely kill the process.

```powershell
# Determine if a tcp port has an active process listening.
PS C:\> Get-NetTCPConnection -LocalPort 8080 |
Select-Object LocalPort, State, OwningProcess

LocalPort  State OwningProcess
---------  ----- -------------
     8080 Listen             4
PS C:\>
```

### Endpoint Status

T> The file "Invoke-AvailableRouteSet.ps1" that is included with the RestPS module contains a route for Endpoint status. This allows you to quickly verify whether the Endpoint is up and available for other calls.

```powershell
# Status route included in the 'Invoke-AvailableRouteSet.ps1' file.
    @{
      'RequestType'    = 'GET'
      'RequestURL'     = '/endpoint/status'
      'RequestCommand' = 'return 1'
    }
```

X> Retrieve your Endpoint status with the '/endpoint/status' url.

```powershell
##############################
# Switch to RESTServerConsole
##############################
# Start an HTTP listener.
PS C:\> $RestPSparams = @{
  RoutesFilePath = 'C:\RestPS\endpoints\Invoke-AvailableRouteSet.ps1'
  Port = '8080'
}
PS C:\> Start-RestPSListener @RestPSparams
Starting: http:// Listener on Port: 8080

```

Execute the following `Invoke-RestMethod` to check the Endpoint status.

```powershell
##############################
# Switch to ClientConsole
##############################
# Perform Invoke-RestMethod command to determine Endpoint status.
PS C:\> $RestMethodParamsHttp = @{
  Uri = 'http://localhost:8080/endpoint/status'
  Method = 'Get'
  UseBasicParsing = $true
}
PS C:\> Invoke-RestMethod @RestMethodParamsHttp
PS C:\> 1 # <---- Actual return is a single digit.
# Shutdown the Endpoint.
PS C:\> $RestMethodParamsHttp = @{
  Uri = 'http://localhost:8080/endpoint/shutdown'
  Method = 'Get'
  UseBasicParsing = $true
}
PS C:\> Invoke-RestMethod @RestMethodParamsHttp
PS C:\> 1 # <---- Actual return is a single digit.
PS C:\>
```

### Logging

Currently no log files are generated by the RestPS module. Future enhancements are planned to support advanced logging via [PowerLumber](https://www.powershellgallery.com/packages/PowerLumber). To view any information output by the REST Endpoint, the console will need to be visually inspected. Here is an example excerpt of an Endpoint console window:

```powershell
##############################
# Switch to RESTServerConsole
##############################
PS C:\> Start-RestPSListener @RestPSparams
Starting: http:// Listener on Port: 8080
Not Validating Client # because SSL is not used.
Processing RequestType: GET URL: /process Args: name=powershell
Not Validating Client
Processing RequestType: GET URL: /process Args: name=firefox
Not Validating Client
Processing RequestType: GET URL: /endpoint/status Args:
Not Validating Client
Received Request to shutdown Endpoint.
Stopping HTTP Listener on port: 8080 ...
Listener Stopped
PS C:\>
```

### Removing artifacts related to this Chapter

I have provided a script to remove artifacts from your environment assuming you followed the chapter and used the recommended parameter values. The script is named [Remove-RestPSChapterData.ps1](code/sider-building-secure-restful-endpoints-with-powershell/Remove-RestPSChapterData.ps1) and has no parameters. It is recommended to run this script in a PowerShell console with elevated permissions.

## Summary

You should now have the basic tools to write customized, secure, and industry acceptable RESTful Endpoints in PowerShell. The RestPS module includes example scripts, as well as examples for verification and authentication. Utilizing these new skills will allow you to build scalable PowerShell applications to administer any environment. The examples provided in this chapter were used to demonstrate the functionality of the RestPS module and the security capabilities. When building and deploying production applications always use SSL, encrypt passwords in transit, and provide an appropriate type of authentication to protect your organization's data. Now go get some REST!