#Crea un diccionario, en el cual la clave es el # de proceso y el valor contiene una lista con el nombre del proceso y ruta. 
$cont=1
$procesos=Get-Process
$dicc = New-Object System.Collections.Generic.Dictionary"[Int,String]" 

$procesos | ForEach-Object{
    $List = New-Object System.Collections.Generic.List[string]
    $List.Add($_.Name)
    $List.Add($_.Path)
    $dicc.Add($cont, $List) 
    $cont++
}

$dicc
