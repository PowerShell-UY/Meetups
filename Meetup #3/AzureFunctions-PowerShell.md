#### Iniciar sesión en el portal

- Ingresar a https://functions.azure.com/signin

- Habiendo iniciado sesión en el portal lo siguiente es nombrar nuestra futura función e ingresar la región donde será creada.
- Vamos a **crear**.
- Teniendo la function app creada, vamos a generar una Función del tipo *TimerTrigger-PowerShell*.

#### Scheduler

- Posteriormente debemos seleccionar la periodicidad en la que se va a ejecutar nuestra función. Azure Functions utiliza expresiones CRON para planificar la ejecución de nuestra función. No pretendo profundizar sobre como funciona pero básicamente debemos tener clara la estructura que es la siguiente:


```
{second} {minute} {hour} {day} {month} {day of the week}
```

Un ejemplo de uso sería el siguiente:

- Para ejecutar todos los días a las 10:00hs (en horario UTC-3:00) debemos ingresar lo siguiente:

>0 0 13 * * *

#### Código

Como se comenzó al principio vamos a reemplazar el código con el siguiente fragmento de PowerShell para poder realizar nuestro objetivo:

```powershell
#Datos
$web = Invoke-WebRequest -Uri https://www.packtpub.com/packt/offers/free-learning -UseBasicParsing
$texto = ($web.RawContent -split '<div class="dotd-title">' | select -Last 1)
$title = (($texto -split '</h2>' | select -First 1) -split '<h2>' | select -Last 1).trim()
#Credenciales
$user = 'GlobalAzure@victorsilva.com.uy'
$pass = (ConvertTo-SecureString 'password.01' -AsPlainText -Force)
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $pass
#Envío de mail 
$date = Get-Date -Format dd/MM
Send-MailMessage -To vmsilvamolina@gmail.com -From GlobalAzure@victorsilva.com.uy -Subject "Packtpub: Libro gratis - $date" -Body $title -SmtpServer smtp.office365.com -UseSsl -Credential $cred -Port 587
```

> Tener presente de modificar el destinatario del mail (en este caso lo vemos en la función **Send-MailMessage**, en el parámetro **To**)

- Ya con el código ingresado, vamos a guardar los cambios y como último paso a ejecutar, para poder obtener como resultado nuestro mail con la información del título del libro sin necesidad de acceder a la página, utilizando una función simple en Azure y de forma automática.