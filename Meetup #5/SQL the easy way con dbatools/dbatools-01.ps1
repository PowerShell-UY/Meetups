## Cleanup
Remove-Module Dbatools -Force
Uninstall-Module Dbatools -Force

###################
## Instalar      ##
###################

## Instalar desde la PowerShell Gallery
Install-Module Dbatools

## Actualizar desde la PowerShell Gallery
Update-Module Dbatools

###################
## Obtener Ayuda ##
###################

## Ver comandos disponibles
(Get-Command -Module Dbatools).Count
Get-Command -Module Dbatools

Get-Help *Restore* 

## Buscar comandos con wildcard
Get-Command -Module Dbatools *Dba*
Get-Command -Module Dbatools -Tag Backup

## Buscar comandos con wildcard
Find-DbaCommand Dba
Find-DbaCommand -Tag Connection

## Obtener ayuda de un comando particular
Get-Help Test-DbaConnection
Get-Help Test-DbaConnection -Full

##############################
## Reglas generales ##
##############################

-EnableException

