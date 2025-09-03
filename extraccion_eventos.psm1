Set-StrictMode -Version Latest

function Get-ForensicEvents {
    <#
    .SYNOPSIS
        Extrae eventos relevantes del Visor de eventos en Windows.

    .DESCRIPTION
        Esta función permite filtrar y exportar eventos del Visor de eventos 
        (Application, System, Security) en un rango de fechas específico.
        Ideal para análisis forense automatizado.

    .PARAMETER LogName
        Nombre del log a consultar. Ejemplos: Application, System, Security.

    .PARAMETER StartDate
        Fecha de inicio para filtrar eventos.

    .PARAMETER EndDate
        Fecha de fin para filtrar eventos.

    .PARAMETER OutputPath
        Ruta del archivo donde se exportarán los resultados (formato CSV).

    .EXAMPLE
        Get-ForensicEvents -LogName Security -StartDate "2025-08-25" -EndDate "2025-09-02" -OutputPath "C:\Users\Escritorio\archivos_pc\eventos.csv"
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet("Application","System","Security")]
        [string]$LogName,

        [Parameter(Mandatory=$true)]
        [datetime]$StartDate,

        [Parameter(Mandatory=$true)]
        [datetime]$EndDate,

        [Parameter(Mandatory=$true)]
        [string]$OutputPath
    )

    try {
        Write-Host "Extrayendo eventos del log $LogName entre $StartDate y $EndDate ..." -ForegroundColor Cyan

        $events = @(Get-WinEvent -LogName $LogName | Where-Object {
            $_.TimeCreated -ge $StartDate -and $_.TimeCreated -le $EndDate
        } | Select-Object TimeCreated, Id, LevelDisplayName, ProviderName, Message)

        if ($events.Count -eq 0) {
            Write-Warning "No se encontraron eventos en el rango especificado."
        }
        else {
            $events | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8
            Write-Host "Se exportaron $($events.Count) eventos a $OutputPath" -ForegroundColor Green
        }
    }
    catch {
        Write-Error "Ocurrió un error: $_"
    }
}

Export-ModuleMember -Function Get-ForensicEvents
