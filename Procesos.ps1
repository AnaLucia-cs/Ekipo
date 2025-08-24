$cont=1
$procesos=Get-Process
$dicc = New-Object System.Collections.Generic.Dictionary"[Int,System.Collections.Generic.List[String]]" 

$procesos | ForEach-Object{
    $List = New-Object System.Collections.Generic.List[string]
    $List.Add($_.Name)
    $List.Add($_.Path)
    $dicc.Add($cont, $List) 
    $cont++
}

#Obtener Procesos Así
$dicc[1] #Te da el primer proceso guardado. 
$dicc[1][0] #Te da el nombre del primer proceso guardado
$dicc[1][1] #Te da la ruta del primer proceso guardado 


### Conexiones 
$active= netstat -ano | findstr "ESTABLISHED"
$c=1
Get-Process | ForEach-Object{
    if ($active | findstr "$($_.Id)"){
        Write-Host -BackgroundColor Cyan "#Proceso: $($c), Nombre $($_.Name) conectado a internet"
    }else{
        Write-Host -BackgroundColor Red "#Proceso: $($c), Nombre $($_.Name) no está conectado"
    }
    $c++
}