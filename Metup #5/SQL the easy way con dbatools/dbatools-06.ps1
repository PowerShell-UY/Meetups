
##########################
## Tareas clásicas DBA  ##
##########################

## Copiar estructura y datos (Sin FK's ni índices!)
Copy-DbaDbTableData -SqlInstance "SQL2016" -Database ReportServer -Table ConfigurationInfo -Destination SQL2017 -DestinationDatabase Test -DestinationTable ConfigurationInfo -AutoCreateTable

## También podemos usar splatting
$paramSplatting = @{
	SqlInstance='SQL2016' 
	Database='ReportServer'
	Table='ConfigurationInfo'
	Destination='SQL2017'
	DestinationDatabase='Test'
	DestinationTable='ConfigurationInfo'
	AutoCreateTable=$true
}
Copy-DbaDbTableData @paramSplatting

# Crear y obtener logins
New-DbaLogin -SqlInstance SQL2017 -Login dbatools -Force
Get-DbaLogin -SqlInstance SQL2017 ##-Login dbatools

# Crear y obtener usuarioS
New-DbaDbUser -SqlInstance SQL2017 -Database Test -Login dbatools -Username dbatools -Force
Get-DbaDbUser -SqlInstance SQL2017 -Database Test | Select-Object Name

# Identificar y reparar usuarios huérfanos
Get-DbaDbOrphanUser -SqlInstance SQL2016
Repair-DbaDbOrphanUser -SqlInstance SQL2016

# Obtener permisos en la instancia
Get-DbaUserPermission -SqlInstance SQL2017 -Database Test | Select-Object Object, Member, RoleSecurableClass

#Exportar logins (sp_help_revlogin)
Export-DbaLogin -SqlInstance SQL2016 -Path C:\dbatools -ExcludePassword -ExcludeLogin sa

#A qué grupos de AD pertenece un login
Find-DbaLoginInGroup -SqlInstance SQL2017 -Login LOCAL\daniel
Find-DbaLoginInGroup -SqlInstance SQL2017 | Select-Object SqlInstance, Login, MemberOf