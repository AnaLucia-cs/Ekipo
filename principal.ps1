Import-Module -Name "C:\Users\Mario Alonso\Documents\WindowsPowerShell\T1\mymodule" -Verbose

Set-StrictMode -Version Latest
#Controla si repetir o no
$ini=$true

while ($ini){
    Write-Host '
    MENÚ DE PROCESOS:
        a) x
        b) y
        c) z
        d) Salir
        '

    $op= Read-Host "Ingrese la opción deseada"
    switch ($op){
        "a" {
            saludar
            Write-Host "xdd"
            $ini= preguntar
        }
        "b"{
            Write-Host "Bbb"
            $ini= preguntar
        }
        "c"{
            Write-Host "ccc"
            $ini= preguntar
        }
        "d" {
            Write-Host "Saliendo..."
            $ini=$false
        }

        default{
            Write-Host "Opción no disponible, seleccione una de las indicadas"
        }
    } 
      
}


#Pregunta si se quiere volver a ejecutar el programa, si no sale del bucle
function preguntar{
    Write-Host "Proceso finalizado :)"
    $preg=Read-Host "¿Desea volver al menú principal? 'y' para sí, cualquier otro para no"
    if ($preg -eq "y"){
        return $true
    }
    else{
        Write-Host "Saliendo...."
        return $false
    }
}
