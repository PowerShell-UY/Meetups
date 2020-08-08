#Crear tarea programada
$Action = New-ScheduledTaskAction -Execute 'Powershell.exe' `
    -Argument '-File C:\Users\vmsilvamolina\Documents\Dev\Meetup\ScheduleTaks.ps1'
$Trigger =  New-ScheduledTaskTrigger -Daily -At 9am
Register-ScheduledTask -Action $Action `
    -Trigger $Trigger `
    -TaskName "PowerShell Task" `
    -Description "Tarea programada generada por la consola."

#Información de la tarea
Get-ScheduledTask -TaskName "PowerShell Task"

#Iniciar tarea
Get-ScheduledTask -TaskName "PowerShell Task" | Start-ScheduledTask

#Abrir el reporte
Start-Process ~\desktop\Reporte.html

#Iniciar administrador de tareas
Start-Process taskschd.msc

#Remover tarea programada
Get-ScheduledTask -TaskName "PowerShell Task" | Unregister-ScheduledTask -Confirm