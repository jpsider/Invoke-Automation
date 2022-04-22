### Creating local Test Certificate Structure

In order to test locally create a simple hierarchy of certificates.

* Local Root Certificate Authority (CA)
  * This will be used to sign the server and client certificate.
* REST Server Certificate
  * This will be used to bind the HTTPS listener to the specified port.
* Client Certificate
  * This will be used when you access the SSL Endpoint.

#### Define, Create, Review and Import the RootCA

# ClientConsole
# Edit parameters to create local RootCA
$rootCAparams = @{
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
$rootCA = New-SelfSignedCertificate @rootCAparams
$rootCA


# Add/Import the RootCA to the 'Root' Certificate Store
$CertStore = New-Object -TypeName `
System.Security.Cryptography.X509Certificates.X509Store(
[System.Security.Cryptography.X509Certificates.StoreName]::Root,
'LocalMachine')
$CertStore.open('MaxAllowed')
$CertStore.add($rootCA)
$CertStore.close()

#### Define, Create and Review the RESTServer Certificate

# ClientConsole
$params = @{
  DnsName = 'RESTServer.PowerShellDemo.io'
  Signer = $rootCA # <------ Notice the Signer is the newly created RootCA
  KeyLength = 2048
  KeyAlgorithm = 'RSA'
  HashAlgorithm = 'SHA256'
  KeyExportPolicy = 'Exportable'
  NotAfter = (Get-Date).AddYears(2)
  CertStoreLocation = 'Cert:\LocalMachine\My'
}
$RESTServerCert = New-SelfSignedCertificate @params
$RESTServerCert

#### Define, Create and Review the Client Certificate

# ClientConsole
$params = @{
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
$ClientCert = New-SelfSignedCertificate @params
$ClientCert

# Create a invalid certificate for use in a failure scenario.
$params = @{
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
$badCert = New-SelfSignedCertificate @params
$badCert

#### Review the list of Certificates in 'My' Certificate Store

Notice all four newly created certificates are listed.

# ClientConsole
Get-ChildItem -Path Cert:\LocalMachine\My\

#List of certificates in the Root Store (full list not shown), notice the newly created local RootCA.


# ClientConsole
Get-ChildItem -Path Cert:\LocalMachine\Root\
Get-ChildItem -Path Cert:\LocalMachine\Root\ | where {$_.subject -like '*Demo*'}

##############################
# Switch to RESTServerConsole
##############################
# Set a certificate as a variable by using the `Get-ChildItem` command specifying the unique Thumbprint. This is useful when opening a new console to execute commands.
$RESTServerCert = Get-ChildItem -Path Cert:\LocalMachine\My\ | Where-Object { $_.Subject -eq 'CN=RESTServer.PowerShellDemo.io'}
$RESTServerCert