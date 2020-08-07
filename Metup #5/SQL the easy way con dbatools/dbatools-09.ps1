########################
## Troubleshooting    ##
########################

Get-DbaErrorLog -SqlInstance SQL2016 -After (GetDate).AddMinutes(-5) | Select-Object LogDate, Source, Text

## Tiempo de backups
Measure-DbaBackupThroughput -SqlInstance SQL2016 -Database DemoSSAS

Find-DbaDbDisabledIndex -SqlInstance 
Find-DbaDbDuplicateIndex

Get-DbaIoLatency -SqlInstance SQL2016																#sys.dm_io_virtual_file_stats
Test-DbaDiskSpeed -SqlInstance SQL2016  | Select-Object Database, ReadPerformance, WritePerformance #Rich Benner
Test-DbaTempdbConfig -SqlInstance SQL2016 | Select-Object SqlInstance, Rule, Notes

Get-DbaTopResourceUsage -SqlInstance SQL2016  -Database DemoSSAS -Limit 3 							#Top 20
Get-DbaWaitStatistic -SqlInstance SQL2017 | Select-Object WaitType, WaitCount, WaitSeconds			#Paul Randal

Clear-DbaPlanCache
Clear-DbaWaitStatistics

Reset-DbaAdmin -SqlInstance SQL2017 -Login dbatools

Start-DbaMigration -Source SQL2017 -Destination SQL20172
