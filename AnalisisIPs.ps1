# ===============================
# 🔍 Análisis de procesos e IPs remotas
# ===============================

# 1. Obtener procesos activos
$procesosAct = Get-Process
Write-Host -BackgroundColor Cyan -ForegroundColor Black "Lista de procesos activos"
$procesosAct | Format-Table Name, Id, Path -AutoSize

# 2. Obtener PIDs conectados a internet
$pidsConectados = Get-NetTCPConnection -State Established | Select-Object -ExpandProperty OwningProcess

# 3. Filtrar procesos conectados
$procesosInternet = $procesosAct | Where-Object { $_.Id -in $pidsConectados }
Write-Host -BackgroundColor Green -ForegroundColor Black "Procesos conectados a internet"
$procesosInternet | Format-Table ProcessName, Id, Path -AutoSize

# 4. Obtener información de conexión
$net = Get-NetTCPConnection -State Established | Select-Object LocalPort, RemoteAddress, RemotePort, OwningProcess

$procesosNetInfo = foreach ($conexion in $net){
    $proceso = $procesosInternet | Where-Object { $_.Id -eq $conexion.OwningProcess }
    if ($proceso) {
        [PSCustomObject]@{
            ProcessName = $proceso.ProcessName
            ID = $proceso.Id
            Path = $proceso.Path
            LocalPort = $conexion.LocalPort
            RemoteAddress = $conexion.RemoteAddress
            RemotePort = $conexion.RemotePort
        }
    }
}
$procesosNetInfo | Format-Table -AutoSize

# 5. Comprobación de firmas digitales
Write-Host -BackgroundColor Magenta -ForegroundColor Black "Comprobación de firmas digitales"
$procesosInternet | ForEach-Object {
    if (Get-AuthenticodeSignature $_.Path){
        Write-Host "$($_.ProcessName) cuenta con firma digital ✔️"
    } else {
        Write-Host "$($_.ProcessName) NO cuenta con firma digital 🚨🚨🚨"
    }
}

# ===============================
# 📡 Consulta de reputación de IPs con AbuseIPDB
# ===============================

# 6. Extraer IPs únicas
$ipsRemotas = $procesosNetInfo | Select-Object -ExpandProperty RemoteAddress | Sort-Object -Unique
Write-Host -BackgroundColor DarkCyan -ForegroundColor White "Direcciones IP remotas detectadas:"
$ipsRemotas

# 7. Configuración de API
$apiKey = "2fcd6bcb2cd87e864ee765895836353034768a893f5c1f4374aae1251de87102de32fe8f79fbb4b2"  # ← Reemplaza con tu clave real
$endpoint = "https://api.abuseipdb.com/api/v2/check"

# 8. Función para consultar reputación
function Verificar-IP {
    param ([string]$ip)

    $headers = @{
        Key = $apiKey
        Accept = "application/json"
    }

    $params = @{
        uri = "$endpoint?ipAddress=$ip"
        Method = "GET"
        Headers = $headers
    }

    try {
        $respuesta = Invoke-RestMethod @params
        return [PSCustomObject]@{
            IP = $ip
            AbusoScore = $respuesta.data.abuseConfidenceScore
            País = $respuesta.data.countryCode
            ISP = $respuesta.data.isp
            ÚltimoReporte = $respuesta.data.lastReportedAt
        }
    } catch {
        Write-Warning "Error al consultar la IP $ip"
        return $null
    }
}

# 9. Consulta masiva y clasificación
$reputacionIPs = foreach ($ip in $ipsRemotas) {
    Verificar-IP -ip $ip
} Select-Object | Where-Object { $_ -ne $null }

$reputacionIPs | Select-Object IP, AbusoScore, País, ISP, ÚltimoReporte,
@{Name="NivelRiesgo"; Expression={
    if ($_.AbusoScore -ge 80) {"Alto 🚨"}
    elseif ($_.AbusoScore -ge 40) {"Medio ⚠️"}
    else {"Bajo ✅"}
}} | Format-Table -AutoSize
