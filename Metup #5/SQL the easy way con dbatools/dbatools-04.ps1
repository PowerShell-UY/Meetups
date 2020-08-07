#############################
## Inventario ##
#############################

## Encontrar instancias
Find-DbaInstance -DiscoveryType Domain -ScanType Browser
Find-DbaInstance -DiscoveryType DataSourceEnumeration -ScanType Browser         ##DNSResolve/Ping/SPN/SqlConnect/SqlService/All
Find-DbaInstance -DiscoveryType IPRange -IPAddress 172.16.0.1/16                ##Demooooora
Find-DbaInstance -DiscoveryType DataSourceEnumeration -MinimumConfidence High
Find-DbaInstance -ComputerName SQL2012

## Detalles del servidor
Get-DbaComputerSystem -ComputerName SQL2012

## Detalles del OS
Get-DbaOperatingSystem -ComputerName SQL2012

## Features de SQL Server instaladas
Get-DbaFeature -ComputerName SQL2012

## Obtener versión de datos
Get-DbaBuildReference -SqlInstance SQL2012

## Validar build de la instancia
Test-DbaBuild -SqlInstance SQL2012 -Latest | Select-Object SqlInstance, BuildLevel, BuildTarget, Compliant

## Obtener bases de datos
Get-DbaDatabase -Sqlinstance "SQL2017" -ExcludeSystem
Get-DbaDatabase -Sqlinstance "SQL2017" -ExcludeSystem | Select-Object Name, Size, LastFullBackup | clip
Get-DbaDatabase -Sqlinstance "SQL2017" -ExcludeSystem | Export-Csv -Path C:\dbatools\Export.csv -NoTypeInformation

## Identificar objetos
Find-DbaUserObject -SqlInstance SQL2016 | Select-Object ComputerName, Type, Owner, Name
Find-DbaUserObject -SqlInstance SQL2016 -Pattern LOCAL\daniel | Select-Object ComputerName, Type, Owner, Name

## Obtener tablas
Get-DbaDBTable -SqlInstance SQL2017 -Database ReportServer | Select-Object Schema, Name, RowCount

##Obtener columnas
(Get-DbaDbTable -SqlInstance SQL2017 -Database ReportServer -Table ConfigurationInfo).Columns | Select-Object Parent, Name, Datatype