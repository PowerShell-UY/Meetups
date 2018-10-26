#cURL
if ((Invoke-WebRequest https://blog.victorsilva.com.uy).StatusCode -eq 200) { 
    Write-host "Funca!"
}