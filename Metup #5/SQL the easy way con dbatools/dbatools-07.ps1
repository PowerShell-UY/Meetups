
########################
## Trabajar con datos ##
########################

## Ejecutar una consulta
$consulta = "SELECT [name], create_date, recovery_model_desc FROM sys.databases ORDER BY [name]"
Invoke-DbaQuery -SqlInstance SQL2017 -Query $consulta -Database Test

## Capturar el resultado
$results = Invoke-DbaQuery -SqlInstance SQL2017 -Query $consulta -Database Test
$results
