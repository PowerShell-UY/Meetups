########################
## Backup/Restore/DR ##
########################

Backup-DbaDatabase -Sqlinstance SQL2016 -Database DemoSSAS -Type Full -Path D:\Temp -FilePath DemoSSAS_Full.bak [-CompressBackup -CheckSum -Verify]
Backup-DbaDatabase -Sqlinstance SQL2016 -Database DemoSSAS -Type Differential -Path D:\Temp -FilePath DemoSSAS_Diff.bak
Backup-DbaDatabase -Sqlinstance SQL2016 -Database DemoSSAS -Type Log -Path D:\Temp -FilePath DemoSSAS_Log1.trn
Backup-DbaDatabase -Sqlinstance SQL2016 -Database DemoSSAS -Type Log -Path D:\Temp -FilePath DemoSSAS_Log2.trn
Backup-DbaDatabase -Sqlinstance SQL2016 -Database DemoSSAS -Type Log -Path D:\Temp -FilePath DemoSSAS_Log3.trn

## Historia de backups
Get-DbaDbBackupHistory -SqlInstance SQL2016 -Database DemoSSAS

## Qué debería restaurar?
$stop_at = '2020-07-30 21:24:55.000'
Get-DbaDbBackupHistory -SqlInstance SQL2016 `
					   -Database DemoSSAS | `
					    Select-DbaBackupInformation -RestoreTime $stop_at
						-Path "\\$Source\$database" `

$stop_at = '2020-07-30 21:24:55.000'
Restore-DbaDatabase -SqlInstance SQL2016 `
					-Path D:\Temp
					-DatabaseName DemoSSAS `
					-DestinationDataDirectory D:\Temp `
					-DestinationLogDirectory D:\Temp `
					-RestoreTime $stop_at `
					-WithReplace `
					-AllowContinue `
					-OutputScriptOnly | Out-File -FilePath $FilePath
