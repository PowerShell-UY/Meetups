#########################
## Otras Herramientas  ##
#########################

##Brent Ozar
Install-DbaFirstResponderKit -SqlInstance SQL2017 -Force

##Ola Hallengren
Install-DbaMaintenanceSolution -SqlInstance SQL2017 -ReplaceExisting
Get-DbaMaintenanceSolutionLog -SqlInstance SQL2017

##(Marcin Gminski)
Install-DbaSqlWatch -SqlInstance SQL2017
Uninstall-DbaSqlWatch  -SqlInstance SQL2017

##(Adam Machanic)
Install-DbaWhoIsActive -SqlInstance SQL2017 -Database master
Invoke-DbaWhoIsActive -SqlInstance SQL2017

