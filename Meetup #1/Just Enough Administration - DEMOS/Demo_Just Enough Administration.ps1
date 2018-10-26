#Creamos el rol, junto con los comandos que van a estar disponibles
$powerShellPath = "$env:SystemRoot\System32\WindowsPowerShell\v1.0" 
$MaintenanceRoleCapabilityCreationParams = @{
    Author =
        "Victor Silva"
    ModulesToImport=
        "Microsoft.PowerShell.Core"
    VisibleCmdlets=
        "Restart-Service"
    CompanyName=
        "vmsilvamolina"
    FunctionDefinitions = @{ Name = 'Get-UserInfo'; ScriptBlock = {$PSSenderInfo}}
        }

# Creamos el modulo demo, que va a contener el archivo Role Capability
New-Item -Path "$env:ProgramFiles\WindowsPowerShell\Modules\Demo_Module" -ItemType Directory
New-ModuleManifest -Path "$env:ProgramFiles\WindowsPowerShell\Modules\Demo_Module\Demo_Module.psd1"
New-Item -Path “$env:ProgramFiles\WindowsPowerShell\Modules\Demo_Module\RoleCapabilities” -ItemType Directory 

# Creamos el archivo Role Capability
New-PSRoleCapabilityFile -Path "$env:ProgramFiles\WindowsPowerShell\Modules\Demo_Module\RoleCapabilities\Maintenance.psrc" @MaintenanceRoleCapabilityCreationParams


#Definimos la configuración en base al rol
$domain = (Get-CimInstance -ClassName Win32_ComputerSystem).Domain
$NonAdministrator = "$domain\Usuario"
$JEAConfigParams = @{
        SessionType= "RestrictedRemoteServer" 
        RunAsVirtualAccount = $true
        RoleDefinitions = @{ $NonAdministrator = @{RoleCapabilities = 'Maintenance'}}
        TranscriptDirectory = "$env:ProgramData\JEAConfiguration\Transcripts”
        }     
if(-not (Test-Path "$env:ProgramData\JEAConfiguration")) {
    New-Item -Path "$env:ProgramData\JEAConfiguration” -ItemType Directory
}
$sessionName = "JEA_Demo"
if(Get-PSSessionConfiguration -Name $sessionName -ErrorAction SilentlyContinue) {
    Unregister-PSSessionConfiguration -Name $sessionName -ErrorAction Stop
}
New-PSSessionConfigurationFile -Path "$env:ProgramData\JEAConfiguration\JEADemo.pssc" @JEAConfigParams
Register-PSSessionConfiguration -Name $sessionName -Path "$env:ProgramData\JEAConfiguration\JEADemo.pssc"
Restart-Service WinRM

#Iniciamos sesión contra el servidor, indicando el rol
$NonAdminCred = Get-Credential
Enter-PSSession -ComputerName . -ConfigurationName JEA_Demo -Credential $NonAdminCred
#Comandos disponibles
Get-Command

#Comando custom habilitado por medio de JEA
Get-UserInfo
#Comando habilitado por medio de JEA
Restart-Service -Name Spooler -Verbose
#Ejecutar el siguiente comando para poder obtener un error en la ejecución
Restart-Computer

#Salir de la sesión
Exit-PSSession