Function Create-DoughnutChart() {

param([string]$FileName, $Used, $Free)
    
    #Agrego el assembly
    #[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.DataVisualization")

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

$Computer = "localhost"
$SystemInfo = Get-WmiObject -ComputerName $Computer -Class Win32_OperatingSystem  | Select-Object Name, TotalVisibleMemorySize, FreePhysicalMemory
$TotalRAM = [Math]::Round($SystemInfo.TotalVisibleMemorySize/1MB, 1)
$FreeRAM = [Math]::Round($SystemInfo.FreePhysicalMemory/1MB, 1)
$UsedRAM = $TotalRAM - $FreeRAM
Create-DoughnutChart -FileName  "C:\users\vmsilvamolina\Desktop\GraficaMemoria" -Used $UsedRAM -Free $FreeRAM

Invoke-Item C:\Users\vmsilvamolina\Desktop\GraficaMemoria.png