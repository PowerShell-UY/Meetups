
##############################
## Conectar a una instancia ##
##############################

## Para una instancia
Test-DbaConnection -Sqlinstance SQL2017
Test-DbaConnection -Sqlinstance "SQL2017,1433"

## Para más de una instancia
Test-DbaConnection -Sqlinstance SQL2017,SQL2019

## Para múltiples instancias
$servers = "SQL2012","SQL2014"
$servers | Test-DbaConnection

## Con seguridad nativa
Test-DbaConnection -Sqlinstance SQL2017 -SqlCredential yoda 

## Con seguridad nativa y credenciales guardadas
$cred = Get-Credential
Connect-DbaInstance -Sqlinstance SQL2017 -SqlCredential $cred 

## Run as different user
Connect-DbaInstance -Sqlinstance SQL2017 -SqlCredential LOCAL\Administrator 

## Conectar por medio de Azure AD
Connect-DbaInstance -Sqlinstance "sqlazure-server.database.windows.net" -SqlCredential demo@whatever.com -Database Dbatools
