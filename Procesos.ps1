$cont=1
$procesos=Get-Process

$procesos | ForEach-Object{ 
    Write-Host -BackgroundColor Cyan "$($cont), $($_.Name), $($_.Path)"
    $cont++
}