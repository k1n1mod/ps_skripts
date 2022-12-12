# Kennwort speichern
# Get-Credential | Export-CliXML C:\Script\CertRenew\Secret.xml

# Kennwort importieren
$Cred = Import-Clixml C:\Script\CertRenew\Secret.xml

$PWDSecure = $Cred.Password

# SecureString in klartext umwandeln
$PWDUnsecure = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Cred.Password))


# In Arbeitsverzeichnis wechseln
cd C:\Certbot\live\domain

# Zertifikat erneuern
certbot --force-renew -d domain

# OpenSSL Kennwort mitgeben?
openssl pkcs12 -inkey privkey.pem -in cert.pem -export -out cert.pfx -certfile chain.pem -password pass:$PWDUnsecure

# Hier auch Kennwort mitgeben?
$NewCert = Import-PfxCertificate -FilePath .\cert.pfx -CertStoreLocation Cert:\LocalMachine\My\ -Password $PWDSecure


#IIS Certificate Bindings Thumbprint finden
#Import-Module WebAdministration
#$siteThumbs = Get-ChildItem IIS:SSLBindings | Foreach-Object {
#   [PSCustomObject]@{
#       Site       = $_.Sites.Value
#       Thumbprint = $_.Thumbprint
#    } 
#}



#Zertifikat am IIS binden
netsh http update sslcert hostnameport="domain:443" certhash=($NewCert.Thumbprint) certstorename=MY appid="{0815}"

# Nur für neue Bindings
#netsh http add sslcert hostnameport="domain:443" certhash=$NewCert.Thumbprint certstorename=MY appid="{0815}"
#New-WebBinding -name "name of iis folder" -Protocol https  -HostHeader "domain" -Port 443 -SslFlags 1

Remove-Item C:\Certbot\live\domain\cert.pfx -Force


