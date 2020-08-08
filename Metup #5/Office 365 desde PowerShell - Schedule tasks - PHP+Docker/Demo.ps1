#Generar el archivo de variables
$secureString = Read-Host -AsSecureString
$encryptedPassWord = ConvertFrom-SecureString -SecureString $secureString
Set-Content -Path "~\documents\Dev\Meetup\pass.txt" -Value $encryptedPassWord


#Credenciales
$encryptedPassWord = Get-Content -Path "~\documents\Dev\Meetup\pass.txt"
$secureString = ConvertTo-SecureString -String $encryptedPassWord
$credential = New-Object System.Management.Automation.PSCredential "vmsilvamolina@victorsilva.com.uy", $secureString

#Conectar a Exchange Online
$ExchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange `
    -ConnectionUri "https://outlook.office365.com/powershell-liveid/" `
    -Credential $credential `
    -Authentication "Basic" `
    -AllowRedirection
Import-PSSession $ExchangeSession | Out-Null

#Conectar al tenant
Install-Module -Name MSOnline
Connect-MsolService -Credential $credential

##  Comandos a ejecutar ##

#Obtener mailbox
Get-Mailbox | Where-Object {$_.Name -notmatch "Discovery"}

#Información detallada
Get-MsolUser | Format-List

#Filtrar información del usuario
Get-MsolUser | Select-Object UserPrincipalName, PhoneNumber, MobilePhone

#Usuarios sin licencia
Get-MsolUser -UnlicensedUsersOnly

#Nuevo usuario
New-MsolUser -UserPrincipalName DanielSuarez@victorsilva.com.uy -DisplayName "Daniel Suarez" -FirstName "Daniel" -LastName "Suarez"

#Ver licencias disponibles
Get-MsolAccountSku

#Asignar licencia
Set-MsolUser -UserPrincipalName "DanielSuarez@victorsilva.com.uy" -UsageLocation "UY" 
Get-MsolUser -UnlicensedUsersOnly | Set-MsolUserLicense -AddLicense 'vmsilvamolina:ENTERPRISEPACK'

#Configurar contraseña
Set-MsolUserPassword -UserPrincipalName "DanielSuarez@victorsilva.com.uy" -NewPassword "P@SSw0rd!"