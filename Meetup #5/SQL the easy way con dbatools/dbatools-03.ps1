#############################
## Conectar a un servidor ##
#############################

Get-DbaService -ComputerName SQL2014
Get-DbaService -ComputerName SQL2014 -Credential LOCAL\Administrator
Get-DbaService -ComputerName SQL2014,SQL2016

$servers = "SQL2012","SQL2014"
$servers | Get-DbaService

