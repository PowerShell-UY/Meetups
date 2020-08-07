
#######################
## Exportar/Importar ##
#######################

## Exportar a CSV
Get-DbaDatabase -Sqlinstance "SQL2016" -ExcludeSystem | Select-Object Name, Size | Export-Csv -Path C:\Dbatools\Export2016.csv -NoTypeInformation
Get-DbaDatabase -Sqlinstance "SQL2017" -ExcludeSystem | Select-Object Name, Size | Export-Csv -Path C:\Dbatools\Export2017.csv -NoTypeInformation

## Importar un CSV
Import-DbaCsv -Path C:\Dbatools\Export2016.csv -SqlInstance SQL2017 -Database Test -Table bd2016 -AutoCreateTable

## Importar multiples CSV
Get-ChildItem -Path C:\Dbatools\*.csv | Import-DbaCsv -SqlInstance SQL2017 -Database Test -AutoCreateTable

## Exportar a una tabla
Get-DbaDatabase -Sqlinstance "SQL2016" -ExcludeSystem | Select-Object Name, Size | Write-DbaDataTable -SqlInstance SQL2017 -Database Test -Table Tablas -AutoCreateTable
