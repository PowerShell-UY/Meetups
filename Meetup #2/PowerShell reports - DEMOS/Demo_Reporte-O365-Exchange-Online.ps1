$Credential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange `
    -ConnectionUri https://outlook.office365.com/powershell-liveid/ `
    -Credential $Credential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking

$Result=@() 
$mailboxes = Get-Mailbox -RecipientTypeDetails UserMailbox -ResultSize Unlimited
$totalmbx = $mailboxes.Count
$i = 1
$mailboxes | ForEach-Object {
    $i++
    $mbx = $_
    $mbs = Get-MailboxStatistics -Identity $mbx.UserPrincipalName | 
        Select @{name="TotalItemSize (GB)"; expression={[math]::Round( `
        ($_.TotalItemSize.ToString().Split("(")[1].Split(" ")[0].Replace(",","")/1GB),2)}}

    Write-Progress -activity "Procesando $mbx" -status "$i de $totalmbx completado"
    $Result += New-Object PSObject -property @{ 
        UserPrincipalName = $mbx.UserPrincipalName
        TotalSize = $mbs."TotalItemSize (GB)"
    }
}
$reporte = $Result | Sort TotalSize -Descending | Select UserPrincipalName, TotalSize -First 10 | ConvertTo-HTML -Fragment | Out-String

Send-MailMessage -From "Reportes <soporte@at.com.uy>" -To "Victor Silva <vsilva@at.com.uy>" `    -Subject "Exchange Online - Top Mailbox" -BodyAsHtml `    -Body $reporte -SmtpServer "at-mailserver.at.interno"