Set-StrictMode -Version Latest

function Get-ForensicEvents {
    <#
    .SYNOPSIS
        Extrae eventos relevantes o sospechosos del Visor de eventos en Windows.

    .DESCRIPTION
        Esta función permite filtrar y exportar eventos del Visor de eventos 
        (Application, System, Security) en un rango de fechas específico.
        Puede enfocarse en eventos sospechosos si se indica.

    .PARAMETER LogName
        Nombre del log a consultar. Ejemplos: Application, System, Security.

    .PARAMETER StartDate
        Fecha de inicio para filtrar eventos.

    .PARAMETER EndDate
        Fecha de fin para filtrar eventos.

    .PARAMETER OutputPath
        Ruta del archivo donde se exportarán los resultados (formato CSV).

    .PARAMETER SuspiciousOnly
        Si se especifica, solo se extraen eventos considerados sospechosos.

    .EXAMPLE
        Get-ForensicEvents -LogName Security -StartDate "2025-08-25" -EndDate "2025-09-02" -OutputPath "C:\eventos.csv" -SuspiciousOnly
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
        [string]$OutputPath,

        [switch]$SuspiciousOnly
    )

    try {
        Write-Host "Extrayendo eventos del log $LogName entre $StartDate y $EndDate ..." -ForegroundColor Cyan

        $eventIDsSospechosos = @(
            4625, 4624, 4670, 4732, 4720, 4726, 4672, # Security
            6008, 7031, 7034                         # System
        )

        $rawEvents = @(Get-WinEvent -LogName $LogName | Where-Object {
            $_.TimeCreated -ge $StartDate -and $_.TimeCreated -le $EndDate
        })

        $filteredEvents = @()
        if ($SuspiciousOnly) {
            $filteredEvents = @($rawEvents | Where-Object {
                $eventIDsSospechosos -contains $_.Id
            })
        }
        else {
            $filteredEvents = $rawEvents
        }

        $events = $filteredEvents | Select-Object TimeCreated, Id, LevelDisplayName, ProviderName, Message

        if ($events) {
            $events | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8
            Write-Host "Eventos exportados correctamente a $OutputPath" -ForegroundColor Green
        }
        else {
            Write-Warning "No se encontraron eventos en el rango especificado."
        }
    }
    catch {
        Write-Error "Ocurrió un error: $_"
    }
}

Export-ModuleMember -Function Get-ForensicEvents
