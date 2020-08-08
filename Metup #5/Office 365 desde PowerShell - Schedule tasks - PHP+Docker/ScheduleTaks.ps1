#region Variables y parametros
Clear-Host
Set-Location "C:\Users\vmsilvamolina\Desktop"
$ChecklistFile = (Get-Location).Path + "\Reporte.html"
[string]$Char = [char]9608
$CPUtime = 10
$CurrentTime = Get-Date -Format D
$Computer = $env:COMPUTERNAME
[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.DataVisualization")
#endregion

Function New-DoughnutChart() {
	param([string]$FileName, $Used, $Free)
    
	#Crea el objeto gráfica
	$Chart = New-object System.Windows.Forms.DataVisualization.Charting.Chart
	$Chart.Width = 170
	$Chart.Height = 100

	#Crea el área de la gráfica para construir
	$ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
	$Chart.ChartAreas.Add($ChartArea)
	[void]$Chart.Series.Add("Data")

	#Agregar los valores a la gráfica
	$Dato1 = New-Object System.Windows.Forms.DataVisualization.Charting.DataPoint(0, $Used)
	$Dato1.AxisLabel = "$Used" + " GB"
	$Dato1.Color = [System.Drawing.ColorTranslator]::FromHtml("#A55353")
	$Chart.Series["Data"].Points.Add($Dato1)
	$Dato2 = New-Object System.Windows.Forms.DataVisualization.Charting.DataPoint(0, $Free)
	$Dato2.AxisLabel = "$Free" + " GB"
	$Dato2.Color = [System.Drawing.ColorTranslator]::FromHtml("#99CD4E")
	$Chart.Series["Data"].Points.Add($Dato2)

	#Defino la forma de la gráfica
	$Chart.Series["Data"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Doughnut
	$Chart.Series["Data"]["PieLabelStyle"] = "Disabled"

	#Leyenda
	$Legend = New-Object system.Windows.Forms.DataVisualization.Charting.Legend
	$Legend.name = "Leyenda"
	$Chart.Legends.Add($Legend)

	#Guarda la gráfica como archivo .png
	$Chart.SaveImage($FileName + ".png","png")
}
Function New-LineChart {
	param([string]$FileName, $Values)

	#Crea el objeto gráfica
	$Chart = New-object System.Windows.Forms.DataVisualization.Charting.Chart
	$Chart.Width = 170
	$Chart.Height = 100

	#Crea el área de la gráfica para construir
	$ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
	$ChartArea.AxisX.Title = "Tiempo (s)"
	$ChartArea.AxisX.Interval = 5
	$ChartArea.AxisY.Interval = 10
	$ChartArea.AxisY.LabelStyle.Format = "{#}%"
	$Chart.ChartAreas.Add($ChartArea)
	[void]$Chart.Series.Add("Data")

	#Agrega los valores a la gráfica
	$Chart.Series["Data"].Points.DataBindXY($Values.Keys, $Values.Values)

	#Defino la forma de la gráfica
	$Chart.Series["Data"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
	$Chart.Series["Data"].BorderWidth = 3
	$Chart.Series["Data"].Color = "#3A539B"

	#Guarda la gráfica como archivo .png
	$Chart.SaveImage($FileName + ".png","png")
}

#Comienzo
Write-Host "Reporte del sistema..."

If ((Test-Path $ChecklistFile) -eq $true) {
	Remove-Item $ChecklistFile
}

$HTMLHeader = @" 
<!doctype html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>CheckList de Servidores</title>
<style type="text/css">

body {
	font-family: Segoe UI Light,SegoeUILightWF,Arial,Sans-Serif;
}

.barra {
	background-color: #3A539B;
	color: #FFFFFF;
	line-height: 20px;
	padding: 15px;
	padding-left: 35px;
	border-radius:25px;
}

.encabezado {
	color: #FFFFFF;
	line-height: 40px;
	padding: 25px;
	background: #00A2F4;
}

.message {
	margin-left: 30px
}

.diez {
	width: 10%
}

.veinte {
	width: 20%
}

.bold {
	font-weight: bold;
	font-size: larger;
}

.size {
	padding: 10px
}

.disk th {
	background-color:#247687;
	font-size: 12px;
}

table {
	color: black;
	margin: 10px;
	box-shadow: 1px 1px 6px #000;
	-moz-box-shadow: 1px 1px 6px #000;
	-webkit-box-shadow: 1px 1px 6px #000;
	border-collapse: separate;
}

table td {
	font-size: 14px;
}

table th {
	background-color:#647687;
	color:#ffffff;
	font-size: 14px;
	font-weight: bold;
}

.list table {
	margin-left:auto; 
	margin-right:auto;
}

.list td, .list th {
	padding:3px 7px 2px 7px;
}

h2{
	clear: both; 
	font-size: 130%;
}

h3{
	clear: both;
	font-size: 115%;
	margin-left: 20px;
	margin-top: 15px;
	margin-bottom: 5px;
}

p{
	margin-left: 20px; font-size: 14px;
}

div .column {
	width: 490px; 
	float: left;
}

div .second{
	margin-left: 20px;
}

div {
	padding-bottom: 40px;
	width: 1000px;
}

</style>
</head>
<body>
<div>
<h1 class="encabezado"> Reporte de Servidores - $CurrentTime</h1>
"@
$HtmlFile += $HTMLHeader
$HtmlFile | Out-File -Encoding utf8 -FilePath $ChecklistFile

## Información de discos ##
$DiskInfo = Get-WMIObject -ComputerName $Computer -Class Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3}  `
	| Select-Object @{Name="Unidad";Expression={($_.Name)}},
									@{Name="Total (GB)";Expression={([math]::Round($_.size/1gb))}},
									@{Name="Libre (GB)";Expression={([math]::Round($_.freespace/1gb))}},
									@{Name="% Uso";Expression={(100-([math]::Round($_.freespace/$_.size*100)))}},
									@{Name="Grafica de uso";Expression={
											$UsedPer= (($_.Size - $_.Freespace)/$_.Size)*100
											$UsedPer = [math]::Round($UsedPer)
											$UsedGraph = $Char * (($UsedPer * 20 )/100)
											$FreeGraph = $Char * (20-(($UsedPer * 20 )/100))
											"xopenspan style=xcomillascolor:#A55353xcomillasxclose{0}xopen/spanxclosexopenspan style=xcomillascolor:#99CD4Excomillasxclose{1}xopen/spanxclose" -f $UsedGraph,$FreeGraph}} | ConvertTo-HTML -fragment
#Reemplazo de caracteres...
$DiskInfo = $DiskInfo -replace "xopen","<"
$DiskInfo = $DiskInfo -replace "xclose",">"
$DiskInfo = $DiskInfo -replace "xcomillas",'"'
## Información de memoria ##
$SystemInfo = Get-WmiObject -ComputerName $Computer -Class Win32_OperatingSystem  | Select-Object Name, TotalVisibleMemorySize, FreePhysicalMemory
$TotalRAM = [Math]::Round($SystemInfo.TotalVisibleMemorySize/1MB, 1)
$FreeRAM = [Math]::Round($SystemInfo.FreePhysicalMemory/1MB, 1)
$UsedRAM = $TotalRAM - $FreeRAM
New-DoughnutChart -FileName ((Get-Location).Path + "\GraficaMemoria-$Computer") -Used $UsedRAM -Free $FreeRAM
## Información de CPU ##
$CPUtotal = @{}
for ($i=1; $i -le $CPUtime; $i++) {
	Start-Sleep -Seconds 1
	$CPU = Get-WmiObject -Class win32_processor -ComputerName $Computer | Select-Object LoadPercentage -ExpandProperty LoadPercentage -First 1
	$CPUtotal.Add($i, $CPU)
}
New-LineChart -FileName ((Get-Location).Path + "\GraficaCPU-$Computer") -Values $CPUtotal
            
$HtmlSystem = @"
<div>
<section class="list">
<h2 class="barra">Información del sistema</h2>
<table>
<tr>
  <th class="diez">Servidor</th>
  <th>Datos de las unidades</th>
  <th>Memoria</th>
  <th>CPU</th>
</tr>
<tr>
  <td class="bold size">$Computer</td>
  <td class="disk">$DiskInfo</td>
  <td> <img src=GraficaMemoria-$Computer.png alt="Gráfica Memoria"> </td>
  <td> <img src=GraficaCPU-$Computer.png alt="Gráfica CPU"> </td>
</tr>
"@
$HtmlFile += $HtmlSystem
    
$HtmlFile | Out-File $ChecklistFile -Force
$HtmlSystemClose = @"
</table>
</section>
</div>
"@
Add-Content -Path $ChecklistFile -Value $HtmlSystemClose

####################################################################################

# Agregamos la parte final del reporte
$HtmlEnd = @"
</div>
</body>
</html>
"@
Add-Content -Path $ChecklistFile -Value $HtmlEnd

#Guardo el archivo sin el BOM
$ExtractBOM = Get-Content $ChecklistFile
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)
[System.IO.File]::WriteAllLines($ChecklistFile, $ExtractBOM, $Utf8NoBomEncoding)

Write-Host "Finalizado"