
#Requires -Version 5.1
<#
.SYNOPSIS
    J&J TECNOLOGÍA ULTIMATE OPTIMIZER PRO
.DESCRIPTION
    Herramienta profesional de mantenimiento, monitoreo y diagnóstico para técnicos informáticos.
    Compatible con Windows 10 y Windows 11.
.AUTHOR
    J&J Tecnología - Jayanca, Lambayeque, Perú
.VERSION
    3.0.0
.DATE
    2026
#>

Set-StrictMode -Off
$ErrorActionPreference = "SilentlyContinue"

# ============================================================
# CONFIGURACIÓN GLOBAL
# ============================================================
$Global:AppVersion    = "3.0.0"
$Global:AppName       = "J&J TECNOLOGÍA ULTIMATE OPTIMIZER PRO"
$Global:LogFolder     = "$env:USERPROFILE\Desktop\Reportes_JJ"
$Global:LogFile       = "$Global:LogFolder\actividad_$(Get-Date -Format 'yyyyMMdd').log"
$Global:ReportFolder  = $Global:LogFolder
$Global:StartTime     = Get-Date

# ============================================================
# FUNCIÓN: Verificar Administrador
# ============================================================
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal   = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# ============================================================
# FUNCIÓN: Escribir Log
# ============================================================
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    try {
        if (-not (Test-Path $Global:LogFolder)) {
            New-Item -ItemType Directory -Path $Global:LogFolder -Force | Out-Null
        }
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $entry     = "[$timestamp] [$Level] $Message"
        Add-Content -Path $Global:LogFile -Value $entry -Encoding UTF8
    } catch { }
}

# ============================================================
# FUNCIÓN: Barra de Progreso Visual
# ============================================================
function Show-ProgressBar {
    param(
        [int]$Percent,
        [int]$Width = 30,
        [ConsoleColor]$BarColor = "Cyan",
        [ConsoleColor]$BgColor  = "DarkGray"
    )
    $filled = [math]::Round(($Percent / 100) * $Width)
    $empty  = $Width - $filled

    $color = if ($Percent -ge 90) { "Red" }
             elseif ($Percent -ge 70) { "Yellow" }
             else { $BarColor }

    Write-Host "[" -NoNewline -ForegroundColor White
    Write-Host ("█" * $filled) -NoNewline -ForegroundColor $color
    Write-Host ("░" * $empty)  -NoNewline -ForegroundColor $BgColor
    Write-Host "] " -NoNewline -ForegroundColor White
    Write-Host ("{0,3}%" -f $Percent) -NoNewline -ForegroundColor $color
}

# ============================================================
# FUNCIÓN: Header decorado
# ============================================================
function Show-Header {
    param([string]$Title, [ConsoleColor]$Color = "Cyan")
    $line = "═" * 60
    Write-Host ""
    Write-Host "  $line" -ForegroundColor $Color
    Write-Host "  ║  $($Title.PadRight(55))║" -ForegroundColor $Color
    Write-Host "  $line" -ForegroundColor $Color
    Write-Host ""
}

# ============================================================
# FUNCIÓN: Logo ASCII Principal
# ============================================================
function Show-Logo {
    Clear-Host
    $cyan  = "Cyan"
    $blue  = "Blue"
    $green = "Green"
    $white = "White"
    $gray  = "DarkCyan"

    Write-Host ""
    Write-Host "  ╔══════════════════════════════════════════════════════════════╗" -ForegroundColor $cyan
    Write-Host "  ║                                                              ║" -ForegroundColor $cyan
    Write-Host "  ║    ░░       ░░  ░░░░░░░  ░░░░░░░░   ░░░░░░░  ░░░░░░░░      ║" -ForegroundColor $blue
    Write-Host "  ║     ░░     ░░   ░░   ░░     ░░      ░░       ░░            ║" -ForegroundColor $blue
    Write-Host "  ║      ░░   ░░    ░░░░░░░     ░░      ░░░░░    ░░░░░░░       ║" -ForegroundColor $cyan
    Write-Host "  ║       ░░ ░░     ░░   ░░     ░░      ░░       ░░            ║" -ForegroundColor $cyan
    Write-Host "  ║        ░░░      ░░   ░░     ░░      ░░░░░░░  ░░░░░░░░      ║" -ForegroundColor $blue
    Write-Host "  ║                                                              ║" -ForegroundColor $cyan
    Write-Host "  ║   ░░░░░░░░  ░░░░░░░  ░░░░░░░  ░░░░░░░░  ░░░░░░   ░░░░░░   ║" -ForegroundColor $green
    Write-Host "  ║      ░░     ░░       ░░           ░░     ░░   ░░  ░░   ░░  ║" -ForegroundColor $green
    Write-Host "  ║      ░░     ░░░░░    ░░           ░░     ░░░░░░   ░░░░░░   ║" -ForegroundColor $cyan
    Write-Host "  ║      ░░     ░░       ░░           ░░     ░░   ░░  ░░   ░░  ║" -ForegroundColor $cyan
    Write-Host "  ║      ░░     ░░░░░░░  ░░░░░░░      ░░     ░░   ░░  ░░   ░░  ║" -ForegroundColor $blue
    Write-Host "  ║                                                              ║" -ForegroundColor $cyan
    Write-Host "  ╠══════════════════════════════════════════════════════════════╣" -ForegroundColor $cyan
    Write-Host "  ║        ULTIMATE OPTIMIZER PRO  v$Global:AppVersion                    ║" -ForegroundColor $white
    Write-Host "  ║        Herramienta Profesional de Soporte Técnico            ║" -ForegroundColor $gray
    Write-Host "  ║        Jayanca, Lambayeque, Perú  ·  J&J Tecnología          ║" -ForegroundColor $gray
    Write-Host "  ╚══════════════════════════════════════════════════════════════╝" -ForegroundColor $cyan
    Write-Host ""

    # Estado de administrador
    if (Test-Administrator) {
        Write-Host "  ✔  Ejecutando como ADMINISTRADOR" -ForegroundColor Green
    } else {
        Write-Host "  ⚠  Sin privilegios de Administrador (funciones limitadas)" -ForegroundColor Yellow
    }

    $os = (Get-CimInstance Win32_OperatingSystem).Caption
    Write-Host "  ℹ  Sistema: $os" -ForegroundColor DarkCyan
    Write-Host "  ℹ  Usuario: $env:USERNAME  ·  Equipo: $env:COMPUTERNAME" -ForegroundColor DarkCyan
    Write-Host "  ℹ  Fecha  : $(Get-Date -Format 'dddd, dd MMMM yyyy  HH:mm:ss')" -ForegroundColor DarkCyan
    Write-Host ""
}

# ============================================================
# FUNCIÓN: Menú Principal
# ============================================================
function Show-MainMenu {
    Show-Logo
    Write-Host "  ╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "  ║                     MENÚ PRINCIPAL                          ║" -ForegroundColor Cyan
    Write-Host "  ╠══════════════════════════════════════════════════════════════╣" -ForegroundColor Cyan
    Write-Host "  ║                                                              ║" -ForegroundColor DarkCyan
    Write-Host "  ║   [1]  📊  Dashboard en Tiempo Real                         ║" -ForegroundColor White
    Write-Host "  ║   [2]  🚀  Optimización del Sistema                         ║" -ForegroundColor White
    Write-Host "  ║   [3]  🔧  Reparación del Sistema                           ║" -ForegroundColor White
    Write-Host "  ║   [4]  💻  Diagnóstico de Hardware                          ║" -ForegroundColor White
    Write-Host "  ║   [5]  🌐  Herramientas de Red                              ║" -ForegroundColor White
    Write-Host "  ║   [6]  ⚙️   Gestor de Procesos                               ║" -ForegroundColor White
    Write-Host "  ║   [7]  🔁  Programas de Inicio                              ║" -ForegroundColor White
    Write-Host "  ║   [8]  📄  Generar Reportes                                 ║" -ForegroundColor White
    Write-Host "  ║   [9]  🛠️   Herramientas de Windows                          ║" -ForegroundColor White
    Write-Host "  ║                                                              ║" -ForegroundColor DarkCyan
    Write-Host "  ║   [0]  ❌  Salir                                            ║" -ForegroundColor DarkGray
    Write-Host "  ║                                                              ║" -ForegroundColor DarkCyan
    Write-Host "  ╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Selecciona una opción: " -ForegroundColor Yellow -NoNewline
}

# ============================================================
# MÓDULO 1: DASHBOARD EN TIEMPO REAL
# ============================================================
function Show-Dashboard {
    Write-Log "Dashboard iniciado"
    Write-Host ""
    Write-Host "  Presiona " -ForegroundColor DarkCyan -NoNewline
    Write-Host "Q" -ForegroundColor Yellow -NoNewline
    Write-Host " para volver al menú principal..." -ForegroundColor DarkCyan
    Write-Host "  Actualizando cada 2 segundos..." -ForegroundColor DarkGray
    Start-Sleep -Milliseconds 800

    while ($true) {
        # Detectar tecla sin bloquear
        if ([Console]::KeyAvailable) {
            $key = [Console]::ReadKey($true)
            if ($key.Key -eq "Q") { break }
        }

        Clear-Host
        Show-Header "📊  DASHBOARD EN TIEMPO REAL" "Cyan"

        try {
            # --- CPU ---
            $cpuLoad = (Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average
            if ($null -eq $cpuLoad) { $cpuLoad = 0 }
            $cpuInfo = Get-CimInstance Win32_Processor | Select-Object -First 1

            # --- RAM ---
            $os       = Get-CimInstance Win32_OperatingSystem
            $ramTotal = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
            $ramFree  = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
            $ramUsed  = [math]::Round($ramTotal - $ramFree, 2)
            $ramPct   = if ($ramTotal -gt 0) { [math]::Round(($ramUsed / $ramTotal) * 100) } else { 0 }

            # --- GPU ---
            $gpu = (Get-CimInstance Win32_VideoController | Select-Object -First 1).Caption

            # --- Uptime ---
            $uptime   = (Get-Date) - $os.LastBootUpTime
            $uptimeStr = "{0}d {1}h {2}m {3}s" -f $uptime.Days, $uptime.Hours, $uptime.Minutes, $uptime.Seconds

            # --- Windows Version ---
            $winVer = $os.Caption + " (Build " + $os.BuildNumber + ")"

            # --- Discos ---
            $disks = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }

            # Sección CPU
            Write-Host "  ┌─────────────────────────────────────────────────────────┐" -ForegroundColor Blue
            Write-Host "  │  🖥️  PROCESADOR                                           │" -ForegroundColor Blue
            Write-Host "  ├─────────────────────────────────────────────────────────┤" -ForegroundColor DarkBlue
            Write-Host "  │  Modelo : " -NoNewline -ForegroundColor DarkCyan
            Write-Host ("{0,-45}" -f ($cpuInfo.Name -replace '\s+',' ')) -NoNewline -ForegroundColor White
            Write-Host "│" -ForegroundColor Blue
            Write-Host "  │  Núcleos: " -NoNewline -ForegroundColor DarkCyan
            Write-Host ("{0,-45}" -f "$($cpuInfo.NumberOfLogicalProcessors) lógicos / $($cpuInfo.NumberOfCores) físicos") -NoNewline -ForegroundColor White
            Write-Host "│" -ForegroundColor Blue
            Write-Host "  │  Uso CPU: " -NoNewline -ForegroundColor DarkCyan
            Show-ProgressBar -Percent $cpuLoad -Width 25
            Write-Host ("  " + " " * 14) -NoNewline
            Write-Host "│" -ForegroundColor Blue
            Write-Host "  └─────────────────────────────────────────────────────────┘" -ForegroundColor Blue

            Write-Host ""

            # Sección RAM
            Write-Host "  ┌─────────────────────────────────────────────────────────┐" -ForegroundColor Cyan
            Write-Host "  │  🧠  MEMORIA RAM                                          │" -ForegroundColor Cyan
            Write-Host "  ├─────────────────────────────────────────────────────────┤" -ForegroundColor DarkCyan
            Write-Host "  │  Total  : " -NoNewline -ForegroundColor DarkCyan
            Write-Host ("{0,-45}" -f "$ramTotal GB") -NoNewline -ForegroundColor White
            Write-Host "│" -ForegroundColor Cyan
            Write-Host "  │  Usada  : " -NoNewline -ForegroundColor DarkCyan
            Write-Host ("{0,-45}" -f "$ramUsed GB") -NoNewline -ForegroundColor Yellow
            Write-Host "│" -ForegroundColor Cyan
            Write-Host "  │  Libre  : " -NoNewline -ForegroundColor DarkCyan
            Write-Host ("{0,-45}" -f "$ramFree GB") -NoNewline -ForegroundColor Green
            Write-Host "│" -ForegroundColor Cyan
            Write-Host "  │  Uso RAM: " -NoNewline -ForegroundColor DarkCyan
            Show-ProgressBar -Percent $ramPct -Width 25
            Write-Host ("  " + " " * 14) -NoNewline
            Write-Host "│" -ForegroundColor Cyan
            Write-Host "  └─────────────────────────────────────────────────────────┘" -ForegroundColor Cyan

            Write-Host ""

            # Sección GPU
            Write-Host "  ┌─────────────────────────────────────────────────────────┐" -ForegroundColor Magenta
            Write-Host "  │  🎮  GPU / TARJETA GRÁFICA                                │" -ForegroundColor Magenta
            Write-Host "  ├─────────────────────────────────────────────────────────┤" -ForegroundColor DarkMagenta
            Write-Host "  │  Modelo : " -NoNewline -ForegroundColor DarkCyan
            Write-Host ("{0,-45}" -f ($gpu -replace '\s+',' ')) -NoNewline -ForegroundColor White
            Write-Host "│" -ForegroundColor Magenta
            Write-Host "  └─────────────────────────────────────────────────────────┘" -ForegroundColor Magenta

            Write-Host ""

            # Sección Discos
            Write-Host "  ┌─────────────────────────────────────────────────────────┐" -ForegroundColor Green
            Write-Host "  │  💾  ALMACENAMIENTO                                       │" -ForegroundColor Green
            Write-Host "  ├──────┬──────────────┬──────────────┬─────────────────────┤" -ForegroundColor DarkGreen
            Write-Host "  │ Drv  │    Total     │    Libre     │    Uso              │" -ForegroundColor DarkGreen
            Write-Host "  ├──────┼──────────────┼──────────────┼─────────────────────┤" -ForegroundColor DarkGreen
            foreach ($disk in $disks) {
                $dTotal = [math]::Round($disk.Size / 1GB, 1)
                $dFree  = [math]::Round($disk.FreeSpace / 1GB, 1)
                $dUsed  = $dTotal - $dFree
                $dPct   = if ($dTotal -gt 0) { [math]::Round(($dUsed / $dTotal) * 100) } else { 0 }
                $dColor = if ($dPct -ge 90) { "Red" } elseif ($dPct -ge 70) { "Yellow" } else { "Green" }
                Write-Host ("  │ {0,-4} │ {1,-12} │ {2,-12} │ " -f $disk.DeviceID, "$dTotal GB", "$dFree GB") -NoNewline -ForegroundColor White
                Show-ProgressBar -Percent $dPct -Width 8
                Write-Host "       │" -ForegroundColor Green
            }
            Write-Host "  └──────┴──────────────┴──────────────┴─────────────────────┘" -ForegroundColor Green

            Write-Host ""

            # Sección Sistema
            Write-Host "  ┌─────────────────────────────────────────────────────────┐" -ForegroundColor Yellow
            Write-Host "  │  ℹ️   INFORMACIÓN DEL SISTEMA                             │" -ForegroundColor Yellow
            Write-Host "  ├─────────────────────────────────────────────────────────┤" -ForegroundColor DarkYellow
            Write-Host ("  │  SO       : {0,-44}│" -f ($winVer.Substring(0, [math]::Min(44, $winVer.Length)))) -ForegroundColor White
            Write-Host ("  │  Equipo   : {0,-44}│" -f $env:COMPUTERNAME) -ForegroundColor White
            Write-Host ("  │  Usuario  : {0,-44}│" -f $env:USERNAME) -ForegroundColor White
            Write-Host ("  │  Uptime   : {0,-44}│" -f $uptimeStr) -ForegroundColor White
            Write-Host ("  │  Hora     : {0,-44}│" -f (Get-Date -Format "HH:mm:ss  dd/MM/yyyy")) -ForegroundColor White
            Write-Host "  └─────────────────────────────────────────────────────────┘" -ForegroundColor Yellow

            Write-Host ""
            Write-Host "  [ Presiona Q para volver ]  Actualizando..." -ForegroundColor DarkGray

        } catch {
            Write-Host "  Error al obtener datos: $_" -ForegroundColor Red
        }

        Start-Sleep -Seconds 2
    }
}

# ============================================================
# MÓDULO 2: OPTIMIZACIÓN
# ============================================================
function Invoke-Optimization {
    Show-Header "🚀  MÓDULO DE OPTIMIZACIÓN" "Green"

    if (-not (Test-Administrator)) {
        Write-Host "  ⚠  Se requieren privilegios de Administrador para algunas funciones." -ForegroundColor Yellow
        Write-Host ""
    }

    Write-Host "  ┌─────────────────────────────────────────┐" -ForegroundColor Green
    Write-Host "  │         OPCIONES DE OPTIMIZACIÓN        │" -ForegroundColor Green
    Write-Host "  ├─────────────────────────────────────────┤" -ForegroundColor DarkGreen
    Write-Host "  │  [1]  Limpiar archivos temporales       │" -ForegroundColor White
    Write-Host "  │  [2]  Limpiar caché Windows Update      │" -ForegroundColor White
    Write-Host "  │  [3]  Vaciar papelera de reciclaje      │" -ForegroundColor White
    Write-Host "  │  [4]  Limpiar caché DNS                 │" -ForegroundColor White
    Write-Host "  │  [5]  Reiniciar Explorer                │" -ForegroundColor White
    Write-Host "  │  [6]  Cerrar apps sin respuesta         │" -ForegroundColor White
    Write-Host "  │  [7]  Activar plan Alto Rendimiento     │" -ForegroundColor White
    Write-Host "  │  [8]  🔥 LIMPIEZA COMPLETA              │" -ForegroundColor Yellow
    Write-Host "  │  [0]  Volver al menú principal          │" -ForegroundColor DarkGray
    Write-Host "  └─────────────────────────────────────────┘" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Opción: " -ForegroundColor Yellow -NoNewline
    $opt = Read-Host

    switch ($opt) {
        "1" { Clear-TempFiles }
        "2" { Clear-WindowsUpdateCache }
        "3" { Clear-RecycleBin }
        "4" { Clear-DnsCache }
        "5" { Restart-Explorer }
        "6" { Close-NotRespondingApps }
        "7" { Set-HighPerformancePlan }
        "8" {
            Write-Host ""
            Write-Host "  ⚠  ¿Confirmas la LIMPIEZA COMPLETA? (S/N): " -ForegroundColor Yellow -NoNewline
            $confirm = Read-Host
            if ($confirm -match "^[Ss]$") {
                Clear-TempFiles
                Clear-WindowsUpdateCache
                Clear-RecycleBin
                Clear-DnsCache
                Restart-Explorer
                Set-HighPerformancePlan
                Write-Host ""
                Write-Host "  ✔  Limpieza completa finalizada." -ForegroundColor Green
                Write-Log "Limpieza completa ejecutada"
            }
        }
        "0" { return }
    }

    Write-Host ""
    Write-Host "  Presiona ENTER para continuar..." -ForegroundColor DarkGray
    Read-Host | Out-Null
}

function Clear-TempFiles {
    Show-Header "🗑️   Limpiando Archivos Temporales" "Yellow"
    Write-Log "Inicio limpieza de temporales"
    $totalFreed = 0

    $paths = @(
        "$env:TEMP",
        "$env:TMP",
        "$env:LOCALAPPDATA\Temp",
        "$env:WINDIR\Temp",
        "$env:LOCALAPPDATA\Microsoft\Windows\INetCache"
    )

    foreach ($path in $paths) {
        if (Test-Path $path) {
            try {
                $before = (Get-ChildItem $path -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
                Get-ChildItem $path -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
                $after  = (Get-ChildItem $path -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
                $freed  = [math]::Round((($before - $after) / 1MB), 2)
                $totalFreed += $freed
                Write-Host "  ✔  " -NoNewline -ForegroundColor Green
                Write-Host $path -NoNewline -ForegroundColor White
                Write-Host "  →  $freed MB liberados" -ForegroundColor Cyan
            } catch {
                Write-Host "  ⚠  No se pudo limpiar: $path" -ForegroundColor Yellow
            }
        }
    }

    Write-Host ""
    Write-Host "  ══════════════════════════════════════" -ForegroundColor Green
    Write-Host "  TOTAL LIBERADO: " -NoNewline -ForegroundColor White
    Write-Host "$totalFreed MB" -ForegroundColor Yellow
    Write-Log "Temporales limpiados. Total: $totalFreed MB"
}

function Clear-WindowsUpdateCache {
    Show-Header "🔄  Limpiando Caché de Windows Update" "Yellow"
    if (-not (Test-Administrator)) {
        Write-Host "  ⚠  Requiere permisos de Administrador." -ForegroundColor Yellow
        return
    }
    try {
        Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
        Stop-Service -Name bits    -Force -ErrorAction SilentlyContinue
        $path = "$env:WINDIR\SoftwareDistribution\Download"
        if (Test-Path $path) {
            Remove-Item "$path\*" -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "  ✔  Caché de Windows Update eliminada." -ForegroundColor Green
        }
        Start-Service -Name wuauserv -ErrorAction SilentlyContinue
        Start-Service -Name bits    -ErrorAction SilentlyContinue
        Write-Host "  ✔  Servicios reiniciados." -ForegroundColor Green
        Write-Log "Cache Windows Update limpiada"
    } catch {
        Write-Host "  ✘  Error: $_" -ForegroundColor Red
        Write-Log "Error limpiando WU Cache: $_" "ERROR"
    }
}

function Clear-RecycleBin {
    Show-Header "🗑️   Vaciando Papelera de Reciclaje" "Yellow"
    try {
        $shell = New-Object -ComObject Shell.Application
        $rb    = $shell.Namespace(0xa)
        $count = ($rb.Items()).Count
        Clear-RecycleBin -Force -ErrorAction SilentlyContinue
        Write-Host "  ✔  Papelera vaciada ($count elementos)." -ForegroundColor Green
        Write-Log "Papelera vaciada: $count elementos"
    } catch {
        Write-Host "  ⚠  No se pudo vaciar la papelera completamente." -ForegroundColor Yellow
    }
}

function Clear-DnsCache {
    Show-Header "🌐  Limpiando Caché DNS" "Yellow"
    try {
        ipconfig /flushdns | Out-Null
        Write-Host "  ✔  Caché DNS limpiada correctamente." -ForegroundColor Green
        Write-Log "Cache DNS limpiada"
    } catch {
        Write-Host "  ✘  Error al limpiar DNS: $_" -ForegroundColor Red
    }
}

function Restart-Explorer {
    Show-Header "🔁  Reiniciando Explorer" "Yellow"
    Write-Host "  ⚠  La pantalla parpadeará brevemente. Esto es normal." -ForegroundColor Yellow
    try {
        Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 1
        Start-Process explorer
        Write-Host "  ✔  Explorer reiniciado correctamente." -ForegroundColor Green
        Write-Log "Explorer reiniciado"
    } catch {
        Write-Host "  ✘  Error al reiniciar Explorer: $_" -ForegroundColor Red
    }
}

function Close-NotRespondingApps {
    Show-Header "⛔  Cerrando Aplicaciones Sin Respuesta" "Yellow"
    try {
        $notResponding = Get-Process | Where-Object { $_.Responding -eq $false }
        if ($notResponding.Count -eq 0) {
            Write-Host "  ✔  No hay aplicaciones sin respuesta." -ForegroundColor Green
        } else {
            foreach ($proc in $notResponding) {
                Write-Host "  Cerrando: $($proc.Name) (PID: $($proc.Id))" -ForegroundColor Yellow
                Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
            }
            Write-Host "  ✔  $($notResponding.Count) procesos cerrados." -ForegroundColor Green
            Write-Log "Procesos sin respuesta cerrados: $($notResponding.Count)"
        }
    } catch {
        Write-Host "  ✘  Error: $_" -ForegroundColor Red
    }
}

function Set-HighPerformancePlan {
    Show-Header "⚡  Activando Plan de Alto Rendimiento" "Yellow"
    if (-not (Test-Administrator)) {
        Write-Host "  ⚠  Requiere permisos de Administrador." -ForegroundColor Yellow
        return
    }
    try {
        powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null
        $current = powercfg /getactivescheme
        Write-Host "  ✔  Plan activado: $current" -ForegroundColor Green
        Write-Log "Plan alto rendimiento activado"
    } catch {
        Write-Host "  ⚠  No se pudo cambiar el plan de energía." -ForegroundColor Yellow
    }
}

# ============================================================
# MÓDULO 3: REPARACIÓN DEL SISTEMA
# ============================================================
function Invoke-SystemRepair {
    Show-Header "🔧  MÓDULO DE REPARACIÓN DEL SISTEMA" "Blue"

    if (-not (Test-Administrator)) {
        Write-Host "  ✘  Este módulo requiere permisos de Administrador." -ForegroundColor Red
        Write-Host "  Presiona ENTER..." -ForegroundColor DarkGray
        Read-Host | Out-Null
        return
    }

    Write-Host "  ┌──────────────────────────────────────┐" -ForegroundColor Blue
    Write-Host "  │       OPCIONES DE REPARACIÓN         │" -ForegroundColor Blue
    Write-Host "  ├──────────────────────────────────────┤" -ForegroundColor DarkBlue
    Write-Host "  │  [1]  SFC /SCANNOW                   │" -ForegroundColor White
    Write-Host "  │  [2]  DISM /RestoreHealth            │" -ForegroundColor White
    Write-Host "  │  [3]  CHKDSK (próximo reinicio)      │" -ForegroundColor White
    Write-Host "  │  [4]  Reinicio de configuración red  │" -ForegroundColor White
    Write-Host "  │  [5]  🔥 Reparación Completa          │" -ForegroundColor Yellow
    Write-Host "  │  [0]  Volver                         │" -ForegroundColor DarkGray
    Write-Host "  └──────────────────────────────────────┘" -ForegroundColor Blue
    Write-Host ""
    Write-Host "  Opción: " -ForegroundColor Yellow -NoNewline
    $opt = Read-Host

    switch ($opt) {
        "1" { Invoke-SFC }
        "2" { Invoke-DISM }
        "3" { Invoke-CHKDSK }
        "4" { Reset-NetworkConfig }
        "5" {
            Write-Host ""
            Write-Host "  ⚠  La Reparación Completa puede tardar 30+ minutos. ¿Continuar? (S/N): " -ForegroundColor Yellow -NoNewline
            $confirm = Read-Host
            if ($confirm -match "^[Ss]$") {
                Invoke-SFC
                Invoke-DISM
                Reset-NetworkConfig
                Write-Host ""
                Write-Host "  ✔  Reparación completa finalizada." -ForegroundColor Green
                Write-Log "Reparacion completa finalizada"
            }
        }
        "0" { return }
    }

    Write-Host ""
    Write-Host "  Presiona ENTER para continuar..." -ForegroundColor DarkGray
    Read-Host | Out-Null
}

function Invoke-SFC {
    Write-Host ""
    Write-Host "  🔍 Ejecutando SFC /SCANNOW..." -ForegroundColor Cyan
    Write-Host "  (Este proceso puede tardar varios minutos)" -ForegroundColor DarkGray
    Write-Log "SFC /SCANNOW iniciado"
    try {
        $result = sfc /scannow 2>&1
        $result | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
        Write-Host "  ✔  SFC completado." -ForegroundColor Green
        Write-Log "SFC completado"
    } catch {
        Write-Host "  ✘  Error en SFC: $_" -ForegroundColor Red
        Write-Log "Error SFC: $_" "ERROR"
    }
}

function Invoke-DISM {
    Write-Host ""
    Write-Host "  🔍 Ejecutando DISM /RestoreHealth..." -ForegroundColor Cyan
    Write-Host "  (Este proceso puede tardar 15-20 minutos)" -ForegroundColor DarkGray
    Write-Log "DISM iniciado"
    try {
        $result = DISM /Online /Cleanup-Image /RestoreHealth 2>&1
        $result | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
        Write-Host "  ✔  DISM completado." -ForegroundColor Green
        Write-Log "DISM completado"
    } catch {
        Write-Host "  ✘  Error en DISM: $_" -ForegroundColor Red
        Write-Log "Error DISM: $_" "ERROR"
    }
}

function Invoke-CHKDSK {
    Write-Host ""
    Write-Host "  💾 Programando CHKDSK para el próximo inicio..." -ForegroundColor Cyan
    try {
        echo Y | chkdsk C: /f /r /x 2>&1 | Out-Null
        Write-Host "  ✔  CHKDSK programado. Se ejecutará en el próximo reinicio." -ForegroundColor Green
        Write-Log "CHKDSK programado"
    } catch {
        Write-Host "  ⚠  No se pudo programar CHKDSK: $_" -ForegroundColor Yellow
    }
}

function Reset-NetworkConfig {
    Write-Host ""
    Write-Host "  🌐 Reiniciando configuración de red..." -ForegroundColor Cyan
    Write-Log "Reinicio de red iniciado"
    try {
        netsh int ip reset         2>&1 | Out-Null
        netsh winsock reset        2>&1 | Out-Null
        netsh advfirewall reset    2>&1 | Out-Null
        ipconfig /release          2>&1 | Out-Null
        ipconfig /flushdns         2>&1 | Out-Null
        ipconfig /renew            2>&1 | Out-Null
        Write-Host "  ✔  Configuración de red restablecida." -ForegroundColor Green
        Write-Host "  ℹ  Se recomienda reiniciar el equipo." -ForegroundColor Yellow
        Write-Log "Red restablecida exitosamente"
    } catch {
        Write-Host "  ✘  Error al restablecer red: $_" -ForegroundColor Red
        Write-Log "Error restableciendo red: $_" "ERROR"
    }
}

# ============================================================
# MÓDULO 4: DIAGNÓSTICO DE HARDWARE
# ============================================================
function Show-HardwareDiagnostic {
    Show-Header "💻  DIAGNÓSTICO DE HARDWARE COMPLETO" "Magenta"
    Write-Log "Diagnostico de hardware iniciado"

    try {
        # CPU
        $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
        Write-Host "  ┌──────────────────────────────────────────────────────────┐" -ForegroundColor Blue
        Write-Host "  │  🖥️  PROCESADOR (CPU)                                      │" -ForegroundColor Blue
        Write-Host "  ├──────────────────────────────────────────────────────────┤" -ForegroundColor DarkBlue
        Write-Host ("  │  Nombre       : {0,-42}│" -f ($cpu.Name -replace '\s+',' ').Substring(0, [math]::Min(42,$cpu.Name.Length))) -ForegroundColor White
        Write-Host ("  │  Fabricante   : {0,-42}│" -f $cpu.Manufacturer) -ForegroundColor White
        Write-Host ("  │  Núcleos Fís. : {0,-42}│" -f $cpu.NumberOfCores) -ForegroundColor White
        Write-Host ("  │  Núcleos Lóg. : {0,-42}│" -f $cpu.NumberOfLogicalProcessors) -ForegroundColor White
        Write-Host ("  │  Velocidad    : {0,-42}│" -f "$($cpu.MaxClockSpeed) MHz") -ForegroundColor White
        Write-Host ("  │  Uso actual   : {0,-42}│" -f "$($cpu.LoadPercentage) %") -ForegroundColor White
        Write-Host ("  │  Arquitectura : {0,-42}│" -f $cpu.AddressWidth) -ForegroundColor White
        Write-Host "  └──────────────────────────────────────────────────────────┘" -ForegroundColor Blue
        Write-Host ""

        # RAM
        $ramSticks = Get-CimInstance Win32_PhysicalMemory
        $os        = Get-CimInstance Win32_OperatingSystem
        $totalRam  = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
        $freeRam   = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
        Write-Host "  ┌──────────────────────────────────────────────────────────┐" -ForegroundColor Cyan
        Write-Host "  │  🧠  MEMORIA RAM                                           │" -ForegroundColor Cyan
        Write-Host "  ├──────────────────────────────────────────────────────────┤" -ForegroundColor DarkCyan
        Write-Host ("  │  Total instalada : {0,-39}│" -f "$totalRam GB") -ForegroundColor White
        Write-Host ("  │  Memoria libre   : {0,-39}│" -f "$freeRam GB") -ForegroundColor White
        Write-Host ("  │  Módulos RAM     : {0,-39}│" -f $ramSticks.Count) -ForegroundColor White
        $i = 0
        foreach ($stick in $ramSticks) {
            $i++
            $ramGB = [math]::Round($stick.Capacity / 1GB, 0)
            Write-Host ("  │  Módulo $i        : {0,-39}│" -f "$ramGB GB  $($stick.Speed) MHz  $($stick.MemoryType)") -ForegroundColor Gray
        }
        Write-Host "  └──────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
        Write-Host ""

        # Motherboard
        $mb = Get-CimInstance Win32_BaseBoard | Select-Object -First 1
        Write-Host "  ┌──────────────────────────────────────────────────────────┐" -ForegroundColor Yellow
        Write-Host "  │  🔌  PLACA MADRE (MOTHERBOARD)                            │" -ForegroundColor Yellow
        Write-Host "  ├──────────────────────────────────────────────────────────┤" -ForegroundColor DarkYellow
        Write-Host ("  │  Fabricante   : {0,-42}│" -f $mb.Manufacturer) -ForegroundColor White
        Write-Host ("  │  Producto     : {0,-42}│" -f $mb.Product) -ForegroundColor White
        Write-Host ("  │  Serial       : {0,-42}│" -f $mb.SerialNumber) -ForegroundColor White
        Write-Host "  └──────────────────────────────────────────────────────────┘" -ForegroundColor Yellow
        Write-Host ""

        # BIOS
        $bios = Get-CimInstance Win32_BIOS
        Write-Host "  ┌──────────────────────────────────────────────────────────┐" -ForegroundColor DarkYellow
        Write-Host "  │  ⚙️   BIOS                                                  │" -ForegroundColor DarkYellow
        Write-Host "  ├──────────────────────────────────────────────────────────┤" -ForegroundColor DarkYellow
        Write-Host ("  │  Fabricante   : {0,-42}│" -f $bios.Manufacturer) -ForegroundColor White
        Write-Host ("  │  Versión      : {0,-42}│" -f $bios.SMBIOSBIOSVersion) -ForegroundColor White
        Write-Host ("  │  Fecha BIOS   : {0,-42}│" -f $bios.ReleaseDate) -ForegroundColor White
        Write-Host ("  │  Serial PC    : {0,-42}│" -f $bios.SerialNumber) -ForegroundColor White
        Write-Host "  └──────────────────────────────────────────────────────────┘" -ForegroundColor DarkYellow
        Write-Host ""

        # GPU
        $gpus = Get-CimInstance Win32_VideoController
        Write-Host "  ┌──────────────────────────────────────────────────────────┐" -ForegroundColor Magenta
        Write-Host "  │  🎮  TARJETA GRÁFICA (GPU)                                 │" -ForegroundColor Magenta
        Write-Host "  ├──────────────────────────────────────────────────────────┤" -ForegroundColor DarkMagenta
        foreach ($g in $gpus) {
            $vramMB = [math]::Round($g.AdapterRAM / 1MB, 0)
            Write-Host ("  │  Nombre       : {0,-42}│" -f ($g.Caption -replace '\s+',' ')) -ForegroundColor White
            Write-Host ("  │  VRAM         : {0,-42}│" -f "$vramMB MB") -ForegroundColor White
            Write-Host ("  │  Resolución   : {0,-42}│" -f "$($g.CurrentHorizontalResolution) x $($g.CurrentVerticalResolution)") -ForegroundColor White
            Write-Host ("  │  Driver       : {0,-42}│" -f $g.DriverVersion) -ForegroundColor White
            Write-Host "  │──────────────────────────────────────────────────────────│" -ForegroundColor DarkMagenta
        }
        Write-Host "  └──────────────────────────────────────────────────────────┘" -ForegroundColor Magenta
        Write-Host ""

        # Discos
        $diskInfo = Get-CimInstance Win32_DiskDrive
        Write-Host "  ┌──────────────────────────────────────────────────────────┐" -ForegroundColor Green
        Write-Host "  │  💾  DISCOS FÍSICOS                                        │" -ForegroundColor Green
        Write-Host "  ├──────────────────────────────────────────────────────────┤" -ForegroundColor DarkGreen
        foreach ($d in $diskInfo) {
            $sizeGB = [math]::Round($d.Size / 1GB, 1)
            Write-Host ("  │  Modelo       : {0,-42}│" -f ($d.Model -replace '\s+',' ')) -ForegroundColor White
            Write-Host ("  │  Interfaz     : {0,-42}│" -f $d.InterfaceType) -ForegroundColor White
            Write-Host ("  │  Capacidad    : {0,-42}│" -f "$sizeGB GB") -ForegroundColor White
            Write-Host ("  │  Serial       : {0,-42}│" -f $d.SerialNumber) -ForegroundColor White
            Write-Host "  │──────────────────────────────────────────────────────────│" -ForegroundColor DarkGreen
        }
        Write-Host "  └──────────────────────────────────────────────────────────┘" -ForegroundColor Green

    } catch {
        Write-Host "  ✘  Error al obtener información de hardware: $_" -ForegroundColor Red
        Write-Log "Error diagnostico hardware: $_" "ERROR"
    }

    Write-Host ""
    Write-Host "  Presiona ENTER para continuar..." -ForegroundColor DarkGray
    Read-Host | Out-Null
}

# ============================================================
# MÓDULO 5: RED
# ============================================================
function Show-NetworkTools {
    Show-Header "🌐  HERRAMIENTAS DE RED" "Cyan"

    Write-Host "  ┌──────────────────────────────────────┐" -ForegroundColor Cyan
    Write-Host "  │         HERRAMIENTAS DE RED          │" -ForegroundColor Cyan
    Write-Host "  ├──────────────────────────────────────┤" -ForegroundColor DarkCyan
    Write-Host "  │  [1]  Mostrar IP local               │" -ForegroundColor White
    Write-Host "  │  [2]  Mostrar IP pública             │" -ForegroundColor White
    Write-Host "  │  [3]  Ping a Google                  │" -ForegroundColor White
    Write-Host "  │  [4]  Mostrar adaptadores de red     │" -ForegroundColor White
    Write-Host "  │  [5]  Reiniciar TCP/IP               │" -ForegroundColor White
    Write-Host "  │  [6]  Flush DNS                      │" -ForegroundColor White
    Write-Host "  │  [7]  Winsock Reset                  │" -ForegroundColor White
    Write-Host "  │  [8]  Diagnóstico completo de red    │" -ForegroundColor White
    Write-Host "  │  [0]  Volver                         │" -ForegroundColor DarkGray
    Write-Host "  └──────────────────────────────────────┘" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Opción: " -ForegroundColor Yellow -NoNewline
    $opt = Read-Host

    switch ($opt) {
        "1" { Show-LocalIP }
        "2" { Show-PublicIP }
        "3" { Invoke-PingGoogle }
        "4" { Show-NetworkAdapters }
        "5" { Reset-TCPIP }
        "6" { Clear-DnsCache }
        "7" { Invoke-WinsockReset }
        "8" {
            Show-LocalIP
            Show-PublicIP
            Invoke-PingGoogle
            Show-NetworkAdapters
        }
        "0" { return }
    }

    Write-Host ""
    Write-Host "  Presiona ENTER para continuar..." -ForegroundColor DarkGray
    Read-Host | Out-Null
}

function Show-LocalIP {
    Write-Host ""
    Write-Host "  📍 IP LOCAL:" -ForegroundColor Cyan
    try {
        $adapters = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notmatch "Loopback" }
        foreach ($a in $adapters) {
            Write-Host ("  │  {0,-30} : {1}" -f $a.InterfaceAlias, $a.IPAddress) -ForegroundColor White
        }
    } catch {
        $ip = (Test-Connection -ComputerName (hostname) -Count 1).IPV4Address.IPAddressToString
        Write-Host "  │  IP: $ip" -ForegroundColor White
    }
    Write-Log "IP local consultada"
}

function Show-PublicIP {
    Write-Host ""
    Write-Host "  🌍 IP PÚBLICA:" -ForegroundColor Cyan
    try {
        $publicIP = (Invoke-WebRequest -Uri "https://api.ipify.org" -UseBasicParsing -TimeoutSec 5).Content
        Write-Host "  │  IP Pública: $publicIP" -ForegroundColor Yellow
        Write-Log "IP publica: $publicIP"
    } catch {
        Write-Host "  ⚠  No se pudo obtener la IP pública (sin internet)." -ForegroundColor Yellow
    }
}

function Invoke-PingGoogle {
    Write-Host ""
    Write-Host "  📡 Ping a Google (8.8.8.8):" -ForegroundColor Cyan
    try {
        $pingResult = Test-Connection -ComputerName 8.8.8.8 -Count 4 -ErrorAction Stop
        foreach ($p in $pingResult) {
            $latColor = if ($p.ResponseTime -lt 50) { "Green" } elseif ($p.ResponseTime -lt 150) { "Yellow" } else { "Red" }
            Write-Host "  │  Respuesta de $($p.Address) : " -NoNewline -ForegroundColor White
            Write-Host "$($p.ResponseTime) ms" -ForegroundColor $latColor
        }
        $avg = ($pingResult | Measure-Object ResponseTime -Average).Average
        Write-Host "  │  Promedio: $([math]::Round($avg,1)) ms" -ForegroundColor Cyan
        Write-Log "Ping Google OK - Promedio: $([math]::Round($avg,1)) ms"
    } catch {
        Write-Host "  ✘  Sin conexión a Internet." -ForegroundColor Red
        Write-Log "Ping Google fallido" "WARN"
    }
}

function Show-NetworkAdapters {
    Write-Host ""
    Write-Host "  🔌 ADAPTADORES DE RED:" -ForegroundColor Cyan
    try {
        $adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
        foreach ($a in $adapters) {
            Write-Host "  ┌──────────────────────────────────────────┐" -ForegroundColor DarkCyan
            Write-Host ("  │  Nombre : {0,-32}│" -f $a.Name) -ForegroundColor White
            Write-Host ("  │  Estado : {0,-32}│" -f $a.Status) -ForegroundColor Green
            Write-Host ("  │  MAC    : {0,-32}│" -f $a.MacAddress) -ForegroundColor Gray
            Write-Host ("  │  Veloc. : {0,-32}│" -f "$([math]::Round($a.LinkSpeed/1MB,0)) Mbps") -ForegroundColor White
            Write-Host "  └──────────────────────────────────────────┘" -ForegroundColor DarkCyan
        }
    } catch {
        ipconfig | Write-Host -ForegroundColor Gray
    }
}

function Reset-TCPIP {
    Write-Host ""
    Write-Host "  🔄 Reiniciando TCP/IP..." -ForegroundColor Cyan
    if (-not (Test-Administrator)) {
        Write-Host "  ✘  Requiere Administrador." -ForegroundColor Red
        return
    }
    try {
        netsh int ip reset 2>&1 | Out-Null
        ipconfig /release 2>&1 | Out-Null
        ipconfig /renew   2>&1 | Out-Null
        Write-Host "  ✔  TCP/IP restablecido." -ForegroundColor Green
        Write-Log "TCP/IP restablecido"
    } catch {
        Write-Host "  ✘  Error: $_" -ForegroundColor Red
    }
}

function Invoke-WinsockReset {
    Write-Host ""
    Write-Host "  🔄 Ejecutando Winsock Reset..." -ForegroundColor Cyan
    if (-not (Test-Administrator)) {
        Write-Host "  ✘  Requiere Administrador." -ForegroundColor Red
        return
    }
    try {
        netsh winsock reset 2>&1 | Out-Null
        Write-Host "  ✔  Winsock restablecido. Reinicia el equipo para aplicar." -ForegroundColor Green
        Write-Log "Winsock reset ejecutado"
    } catch {
        Write-Host "  ✘  Error: $_" -ForegroundColor Red
    }
}

# ============================================================
# MÓDULO 6: PROCESOS
# ============================================================
function Show-ProcessManager {
    Show-Header "⚙️   GESTOR DE PROCESOS" "Yellow"

    Write-Host "  ┌──────────────────────────────────────┐" -ForegroundColor Yellow
    Write-Host "  │         GESTOR DE PROCESOS           │" -ForegroundColor Yellow
    Write-Host "  ├──────────────────────────────────────┤" -ForegroundColor DarkYellow
    Write-Host "  │  [1]  Top 20 por uso de RAM          │" -ForegroundColor White
    Write-Host "  │  [2]  Top 20 por uso de CPU          │" -ForegroundColor White
    Write-Host "  │  [3]  Buscar proceso por nombre      │" -ForegroundColor White
    Write-Host "  │  [4]  Finalizar proceso              │" -ForegroundColor White
    Write-Host "  │  [0]  Volver                         │" -ForegroundColor DarkGray
    Write-Host "  └──────────────────────────────────────┘" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Opción: " -ForegroundColor Yellow -NoNewline
    $opt = Read-Host

    switch ($opt) {
        "1" { Show-TopRAMProcesses }
        "2" { Show-TopCPUProcesses }
        "3" { Find-ProcessByName }
        "4" { Stop-SelectedProcess }
        "0" { return }
    }

    Write-Host ""
    Write-Host "  Presiona ENTER para continuar..." -ForegroundColor DarkGray
    Read-Host | Out-Null
}

function Show-TopRAMProcesses {
    Write-Host ""
    Write-Host "  🧠 TOP 20 PROCESOS POR USO DE RAM:" -ForegroundColor Cyan
    Write-Host ("  {0,-8} {1,-35} {2,-12} {3}" -f "PID", "Nombre", "RAM (MB)", "Hilos") -ForegroundColor DarkCyan
    Write-Host "  " + ("─" * 62) -ForegroundColor DarkGray
    try {
        $procs = Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 20
        foreach ($p in $procs) {
            $ramMB = [math]::Round($p.WorkingSet64 / 1MB, 1)
            $color = if ($ramMB -gt 500) { "Red" } elseif ($ramMB -gt 200) { "Yellow" } else { "White" }
            Write-Host ("  {0,-8} {1,-35} {2,-12} {3}" -f $p.Id, $p.Name.Substring(0,[math]::Min(34,$p.Name.Length)), $ramMB, $p.Threads.Count) -ForegroundColor $color
        }
    } catch {
        Write-Host "  Error: $_" -ForegroundColor Red
    }
    Write-Log "Top procesos RAM consultados"
}

function Show-TopCPUProcesses {
    Write-Host ""
    Write-Host "  🖥️  TOP 20 PROCESOS POR USO DE CPU:" -ForegroundColor Cyan
    Write-Host ("  {0,-8} {1,-35} {2,-15}" -f "PID", "Nombre", "CPU (seg)") -ForegroundColor DarkCyan
    Write-Host "  " + ("─" * 55) -ForegroundColor DarkGray
    try {
        $procs = Get-Process | Sort-Object CPU -Descending | Select-Object -First 20
        foreach ($p in $procs) {
            $cpu = [math]::Round($p.CPU, 2)
            $color = if ($cpu -gt 100) { "Red" } elseif ($cpu -gt 30) { "Yellow" } else { "White" }
            Write-Host ("  {0,-8} {1,-35} {2,-15}" -f $p.Id, $p.Name.Substring(0,[math]::Min(34,$p.Name.Length)), $cpu) -ForegroundColor $color
        }
    } catch {
        Write-Host "  Error: $_" -ForegroundColor Red
    }
    Write-Log "Top procesos CPU consultados"
}

function Find-ProcessByName {
    Write-Host ""
    Write-Host "  🔍 Nombre del proceso a buscar: " -ForegroundColor Yellow -NoNewline
    $name = Read-Host
    if ([string]::IsNullOrWhiteSpace($name)) { return }
    try {
        $procs = Get-Process -Name "*$name*" -ErrorAction SilentlyContinue
        if ($procs.Count -eq 0) {
            Write-Host "  ⚠  No se encontró ningún proceso con ese nombre." -ForegroundColor Yellow
        } else {
            Write-Host ("  {0,-8} {1,-30} {2,-12} {3,-12}" -f "PID", "Nombre", "RAM (MB)", "Estado") -ForegroundColor DarkCyan
            Write-Host "  " + ("─" * 55) -ForegroundColor DarkGray
            foreach ($p in $procs) {
                $ramMB   = [math]::Round($p.WorkingSet64 / 1MB, 1)
                $estado  = if ($p.Responding) { "OK" } else { "NO RESP." }
                $color   = if (-not $p.Responding) { "Red" } else { "White" }
                Write-Host ("  {0,-8} {1,-30} {2,-12} {3,-12}" -f $p.Id, $p.Name.Substring(0,[math]::Min(29,$p.Name.Length)), $ramMB, $estado) -ForegroundColor $color
            }
        }
    } catch {
        Write-Host "  ✘  Error: $_" -ForegroundColor Red
    }
}

function Stop-SelectedProcess {
    Write-Host ""
    Write-Host "  ⛔ PID del proceso a finalizar: " -ForegroundColor Red -NoNewline
    $pidInput = Read-Host
    if (-not ($pidInput -match "^\d+$")) {
        Write-Host "  ✘  PID inválido." -ForegroundColor Red
        return
    }
    $pid2kill = [int]$pidInput
    try {
        $proc = Get-Process -Id $pid2kill -ErrorAction Stop
        # Protección contra procesos críticos del sistema
        $systemProcs = @("System","smss","csrss","wininit","winlogon","lsass","services","svchost")
        if ($proc.Name -in $systemProcs) {
            Write-Host "  ✘  No se puede terminar un proceso crítico del sistema: $($proc.Name)" -ForegroundColor Red
            Write-Log "Intento de terminar proceso critico: $($proc.Name)" "WARN"
            return
        }
        Write-Host "  ⚠  ¿Confirmas finalizar '$($proc.Name)' (PID: $pid2kill)? (S/N): " -ForegroundColor Yellow -NoNewline
        $confirm = Read-Host
        if ($confirm -match "^[Ss]$") {
            Stop-Process -Id $pid2kill -Force
            Write-Host "  ✔  Proceso finalizado." -ForegroundColor Green
            Write-Log "Proceso terminado: $($proc.Name) PID:$pid2kill"
        } else {
            Write-Host "  Operación cancelada." -ForegroundColor DarkGray
        }
    } catch {
        Write-Host "  ✘  No se encontró el proceso con PID $pid2kill." -ForegroundColor Red
    }
}

# ============================================================
# MÓDULO 7: PROGRAMAS DE INICIO
# ============================================================
function Show-StartupManager {
    Show-Header "🔁  PROGRAMAS DE INICIO" "Cyan"
    Write-Log "Modulo inicio consultado"

    $startupItems = @()

    # Registro HKCU
    $regPath1 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    if (Test-Path $regPath1) {
        $items = Get-ItemProperty -Path $regPath1 -ErrorAction SilentlyContinue
        $items.PSObject.Properties | Where-Object { $_.Name -notmatch "^PS" } | ForEach-Object {
            $startupItems += [PSCustomObject]@{
                Nombre  = $_.Name
                Valor   = $_.Value
                Origen  = "HKCU"
                Estado  = "Activo"
            }
        }
    }

    # Registro HKLM
    $regPath2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    if (Test-Path $regPath2) {
        $items = Get-ItemProperty -Path $regPath2 -ErrorAction SilentlyContinue
        $items.PSObject.Properties | Where-Object { $_.Name -notmatch "^PS" } | ForEach-Object {
            $startupItems += [PSCustomObject]@{
                Nombre  = $_.Name
                Valor   = $_.Value
                Origen  = "HKLM"
                Estado  = "Activo"
            }
        }
    }

    # Carpeta de inicio usuario
    $startFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
    if (Test-Path $startFolder) {
        Get-ChildItem $startFolder | ForEach-Object {
            $startupItems += [PSCustomObject]@{
                Nombre  = $_.Name
                Valor   = $_.FullName
                Origen  = "Carpeta"
                Estado  = "Activo"
            }
        }
    }

    if ($startupItems.Count -eq 0) {
        Write-Host "  ℹ  No se encontraron programas de inicio." -ForegroundColor Yellow
    } else {
        Write-Host ("  {0,-4} {1,-35} {2,-8} {3}" -f "#", "Nombre", "Origen", "Ruta") -ForegroundColor DarkCyan
        Write-Host "  " + ("─" * 78) -ForegroundColor DarkGray
        $idx = 1
        foreach ($item in $startupItems) {
            $shortVal = if ($item.Valor.Length -gt 30) { $item.Valor.Substring(0,30) + "..." } else { $item.Valor }
            Write-Host ("  {0,-4} {1,-35} {2,-8} {3}" -f $idx, ($item.Nombre.Substring(0,[math]::Min(34,$item.Nombre.Length))), $item.Origen, $shortVal) -ForegroundColor White
            $idx++
        }
    }

    Write-Host ""
    Write-Host "  ┌──────────────────────────────┐" -ForegroundColor Cyan
    Write-Host "  │  [E]  Exportar a TXT         │" -ForegroundColor White
    Write-Host "  │  [0]  Volver                 │" -ForegroundColor DarkGray
    Write-Host "  └──────────────────────────────┘" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Opción: " -ForegroundColor Yellow -NoNewline
    $opt = Read-Host

    if ($opt -match "^[Ee]$") {
        if (-not (Test-Path $Global:ReportFolder)) {
            New-Item -ItemType Directory -Path $Global:ReportFolder -Force | Out-Null
        }
        $exportPath = "$Global:ReportFolder\inicio_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
        $startupItems | Format-Table -AutoSize | Out-String | Set-Content $exportPath -Encoding UTF8
        Write-Host "  ✔  Exportado en: $exportPath" -ForegroundColor Green
        Write-Log "Startup exportado: $exportPath"
    }

    Write-Host ""
    Write-Host "  Presiona ENTER para continuar..." -ForegroundColor DarkGray
    Read-Host | Out-Null
}

# ============================================================
# MÓDULO 8: REPORTES
# ============================================================
function Generate-Reports {
    Show-Header "📄  GENERADOR DE REPORTES" "White"
    Write-Log "Generacion de reportes iniciada"

    Write-Host "  ┌──────────────────────────────────────┐" -ForegroundColor White
    Write-Host "  │         TIPO DE REPORTE              │" -ForegroundColor White
    Write-Host "  ├──────────────────────────────────────┤" -ForegroundColor Gray
    Write-Host "  │  [1]  Reporte TXT                    │" -ForegroundColor White
    Write-Host "  │  [2]  Reporte HTML                   │" -ForegroundColor White
    Write-Host "  │  [3]  Ambos (TXT + HTML)             │" -ForegroundColor White
    Write-Host "  │  [0]  Volver                         │" -ForegroundColor DarkGray
    Write-Host "  └──────────────────────────────────────┘" -ForegroundColor White
    Write-Host ""
    Write-Host "  Opción: " -ForegroundColor Yellow -NoNewline
    $opt = Read-Host

    if ($opt -in @("1","3")) { Generate-TXTReport }
    if ($opt -in @("2","3")) { Generate-HTMLReport }

    Write-Host ""
    Write-Host "  Presiona ENTER para continuar..." -ForegroundColor DarkGray
    Read-Host | Out-Null
}

function Get-SystemData {
    $cpu    = Get-CimInstance Win32_Processor | Select-Object -First 1
    $os     = Get-CimInstance Win32_OperatingSystem
    $mb     = Get-CimInstance Win32_BaseBoard | Select-Object -First 1
    $bios   = Get-CimInstance Win32_BIOS
    $gpu    = Get-CimInstance Win32_VideoController | Select-Object -First 1
    $disks  = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }
    $net    = Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1

    $ramTotal = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
    $ramFree  = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
    $ramUsed  = [math]::Round($ramTotal - $ramFree, 2)
    $ramPct   = if ($ramTotal -gt 0) { [math]::Round(($ramUsed / $ramTotal) * 100) } else { 0 }
    $cpuLoad  = $cpu.LoadPercentage
    $uptime   = (Get-Date) - $os.LastBootUpTime

    return @{
        CPU      = $cpu
        OS       = $os
        MB       = $mb
        BIOS     = $bios
        GPU      = $gpu
        Disks    = $disks
        Net      = $net
        RamTotal = $ramTotal
        RamFree  = $ramFree
        RamUsed  = $ramUsed
        RamPct   = $ramPct
        CpuLoad  = $cpuLoad
        Uptime   = $uptime
        Date     = Get-Date
    }
}

function Generate-TXTReport {
    try {
        if (-not (Test-Path $Global:ReportFolder)) {
            New-Item -ItemType Directory -Path $Global:ReportFolder -Force | Out-Null
        }
        $d    = Get-SystemData
        $path = "$Global:ReportFolder\Reporte_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

        $report = @"
══════════════════════════════════════════════════════════════
        J&J TECNOLOGÍA - ULTIMATE OPTIMIZER PRO v$Global:AppVersion
              REPORTE DE DIAGNÓSTICO DEL SISTEMA
══════════════════════════════════════════════════════════════

Fecha      : $($d.Date.ToString('dddd dd/MM/yyyy'))
Hora       : $($d.Date.ToString('HH:mm:ss'))
Técnico    : $env:USERNAME
Equipo     : $env:COMPUTERNAME

══════════════════════════════════════════════════════════════
  SISTEMA OPERATIVO
══════════════════════════════════════════════════════════════
SO         : $($d.OS.Caption)
Build      : $($d.OS.BuildNumber)
Arquitect. : $($d.OS.OSArchitecture)
Uptime     : $($d.Uptime.Days)d $($d.Uptime.Hours)h $($d.Uptime.Minutes)m

══════════════════════════════════════════════════════════════
  PROCESADOR
══════════════════════════════════════════════════════════════
Modelo     : $($d.CPU.Name)
Núcleos    : $($d.CPU.NumberOfCores) físicos / $($d.CPU.NumberOfLogicalProcessors) lógicos
Velocidad  : $($d.CPU.MaxClockSpeed) MHz
Uso actual : $($d.CpuLoad) %

══════════════════════════════════════════════════════════════
  MEMORIA RAM
══════════════════════════════════════════════════════════════
Total      : $($d.RamTotal) GB
Usada      : $($d.RamUsed) GB ($($d.RamPct)%)
Libre      : $($d.RamFree) GB

══════════════════════════════════════════════════════════════
  PLACA MADRE / BIOS
══════════════════════════════════════════════════════════════
Placa      : $($d.MB.Manufacturer) $($d.MB.Product)
Serial MB  : $($d.MB.SerialNumber)
BIOS       : $($d.BIOS.Manufacturer) $($d.BIOS.SMBIOSBIOSVersion)

══════════════════════════════════════════════════════════════
  TARJETA GRÁFICA
══════════════════════════════════════════════════════════════
GPU        : $($d.GPU.Caption)
Driver     : $($d.GPU.DriverVersion)

══════════════════════════════════════════════════════════════
  ALMACENAMIENTO
══════════════════════════════════════════════════════════════
"@
        foreach ($disk in $d.Disks) {
            $tGB = [math]::Round($disk.Size / 1GB, 1)
            $fGB = [math]::Round($disk.FreeSpace / 1GB, 1)
            $pct = if ($tGB -gt 0) { [math]::Round((($tGB-$fGB)/$tGB)*100) } else { 0 }
            $report += "Unidad $($disk.DeviceID)  Total: $tGB GB  Libre: $fGB GB  Uso: $pct%`n"
        }

        $report += @"

══════════════════════════════════════════════════════════════
  RED
══════════════════════════════════════════════════════════════
Adaptador  : $($d.Net.Name)
Estado     : $($d.Net.Status)

══════════════════════════════════════════════════════════════
  Generado por J&J Tecnología Ultimate Optimizer Pro
  Jayanca, Lambayeque, Perú
══════════════════════════════════════════════════════════════
"@

        $report | Set-Content -Path $path -Encoding UTF8
        Write-Host "  ✔  Reporte TXT guardado en:" -ForegroundColor Green
        Write-Host "     $path" -ForegroundColor Cyan
        Write-Log "Reporte TXT generado: $path"

    } catch {
        Write-Host "  ✘  Error generando reporte TXT: $_" -ForegroundColor Red
        Write-Log "Error reporte TXT: $_" "ERROR"
    }
}

function Generate-HTMLReport {
    try {
        if (-not (Test-Path $Global:ReportFolder)) {
            New-Item -ItemType Directory -Path $Global:ReportFolder -Force | Out-Null
        }
        $d    = Get-SystemData
        $path = "$Global:ReportFolder\Reporte_$(Get-Date -Format 'yyyyMMdd_HHmmss').html"

        $diskRows = ""
        foreach ($disk in $d.Disks) {
            $tGB = [math]::Round($disk.Size / 1GB, 1)
            $fGB = [math]::Round($disk.FreeSpace / 1GB, 1)
            $uGB = [math]::Round($tGB - $fGB, 1)
            $pct = if ($tGB -gt 0) { [math]::Round(($uGB/$tGB)*100) } else { 0 }
            $barColor = if ($pct -ge 90) { "#e74c3c" } elseif ($pct -ge 70) { "#f39c12" } else { "#27ae60" }
            $diskRows += "<tr><td>$($disk.DeviceID)</td><td>$tGB GB</td><td>$uGB GB</td><td>$fGB GB</td><td><div class='bar-bg'><div class='bar-fill' style='width:$pct%;background:$barColor'></div></div> $pct%</td></tr>"
        }

        $ramPctColor = if ($d.RamPct -ge 90) { "#e74c3c" } elseif ($d.RamPct -ge 70) { "#f39c12" } else { "#27ae60" }
        $cpuColor    = if ($d.CpuLoad -ge 90) { "#e74c3c" } elseif ($d.CpuLoad -ge 70) { "#f39c12" } else { "#27ae60" }

        $html = @"
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Reporte - J&amp;J Tecnología</title>
<style>
  * { margin:0; padding:0; box-sizing:border-box; }
  body { font-family: 'Segoe UI', sans-serif; background:#0a0e1a; color:#c9d1e0; }
  .header { background:linear-gradient(135deg,#0d2e6e,#1a4a8a); padding:30px 40px; border-bottom:3px solid #00d4ff; }
  .header h1 { color:#00d4ff; font-size:28px; letter-spacing:2px; }
  .header p  { color:#7a8fa6; margin-top:5px; font-size:14px; }
  .badge { display:inline-block; background:#00d4ff22; color:#00d4ff; border:1px solid #00d4ff44; padding:4px 12px; border-radius:20px; font-size:12px; margin-top:10px; }
  .container { max-width:1100px; margin:30px auto; padding:0 20px; }
  .grid { display:grid; grid-template-columns:1fr 1fr; gap:20px; margin-bottom:20px; }
  .card { background:#111827; border:1px solid #1e2d45; border-radius:12px; padding:20px; }
  .card h2 { color:#00d4ff; font-size:16px; margin-bottom:15px; padding-bottom:8px; border-bottom:1px solid #1e2d45; display:flex; align-items:center; gap:8px; }
  .row { display:flex; justify-content:space-between; padding:6px 0; border-bottom:1px solid #1a2535; font-size:14px; }
  .row:last-child { border-bottom:none; }
  .label { color:#7a8fa6; }
  .value { color:#e2e8f0; font-weight:500; }
  .bar-bg { background:#1e2d45; border-radius:10px; height:8px; width:150px; display:inline-block; vertical-align:middle; overflow:hidden; }
  .bar-fill { height:100%; border-radius:10px; transition:width .3s; }
  .meter { display:flex; align-items:center; gap:10px; padding:10px 0; }
  .meter-label { color:#7a8fa6; font-size:13px; width:80px; }
  .meter-pct { font-size:13px; font-weight:700; }
  table { width:100%; border-collapse:collapse; font-size:13px; }
  th { background:#0d2e6e; color:#00d4ff; padding:10px; text-align:left; }
  td { padding:9px 10px; border-bottom:1px solid #1e2d45; }
  tr:hover td { background:#1a2535; }
  .full { grid-column:1/-1; }
  .footer { text-align:center; padding:30px; color:#4a5568; font-size:13px; border-top:1px solid #1e2d45; margin-top:30px; }
</style>
</head>
<body>
<div class="header">
  <h1>⚡ J&amp;J TECNOLOGÍA · REPORTE DE DIAGNÓSTICO</h1>
  <p>Ultimate Optimizer Pro v$Global:AppVersion</p>
  <span class="badge">📅 $($d.Date.ToString('dd/MM/yyyy HH:mm:ss'))</span>
  <span class="badge">👤 $env:USERNAME @ $env:COMPUTERNAME</span>
</div>
<div class="container">
  <div class="grid">
    <div class="card">
      <h2>🖥️ Sistema Operativo</h2>
      <div class="row"><span class="label">SO</span><span class="value">$($d.OS.Caption)</span></div>
      <div class="row"><span class="label">Build</span><span class="value">$($d.OS.BuildNumber)</span></div>
      <div class="row"><span class="label">Arquitectura</span><span class="value">$($d.OS.OSArchitecture)</span></div>
      <div class="row"><span class="label">Uptime</span><span class="value">$($d.Uptime.Days)d $($d.Uptime.Hours)h $($d.Uptime.Minutes)m</span></div>
    </div>
    <div class="card">
      <h2>🖥️ Procesador</h2>
      <div class="row"><span class="label">Modelo</span><span class="value">$($d.CPU.Name -replace '\s+',' ')</span></div>
      <div class="row"><span class="label">Núcleos</span><span class="value">$($d.CPU.NumberOfCores) fís. / $($d.CPU.NumberOfLogicalProcessors) lóg.</span></div>
      <div class="row"><span class="label">Velocidad</span><span class="value">$($d.CPU.MaxClockSpeed) MHz</span></div>
      <div class="row"><span class="label">Uso CPU</span><span class="value">
        <div class="bar-bg"><div class="bar-fill" style="width:$($d.CpuLoad)%;background:$cpuColor"></div></div>
        <span style="color:$cpuColor;margin-left:6px">$($d.CpuLoad)%</span>
      </span></div>
    </div>
    <div class="card">
      <h2>🧠 Memoria RAM</h2>
      <div class="row"><span class="label">Total</span><span class="value">$($d.RamTotal) GB</span></div>
      <div class="row"><span class="label">Usada</span><span class="value">$($d.RamUsed) GB</span></div>
      <div class="row"><span class="label">Libre</span><span class="value">$($d.RamFree) GB</span></div>
      <div class="row"><span class="label">Uso RAM</span><span class="value">
        <div class="bar-bg"><div class="bar-fill" style="width:$($d.RamPct)%;background:$ramPctColor"></div></div>
        <span style="color:$ramPctColor;margin-left:6px">$($d.RamPct)%</span>
      </span></div>
    </div>
    <div class="card">
      <h2>🔌 Placa Madre / BIOS</h2>
      <div class="row"><span class="label">Fabricante</span><span class="value">$($d.MB.Manufacturer)</span></div>
      <div class="row"><span class="label">Producto</span><span class="value">$($d.MB.Product)</span></div>
      <div class="row"><span class="label">Serial MB</span><span class="value">$($d.MB.SerialNumber)</span></div>
      <div class="row"><span class="label">BIOS</span><span class="value">$($d.BIOS.SMBIOSBIOSVersion)</span></div>
    </div>
    <div class="card full">
      <h2>💾 Almacenamiento</h2>
      <table>
        <tr><th>Unidad</th><th>Total</th><th>Usado</th><th>Libre</th><th>Uso</th></tr>
        $diskRows
      </table>
    </div>
    <div class="card">
      <h2>🎮 Tarjeta Gráfica</h2>
      <div class="row"><span class="label">GPU</span><span class="value">$($d.GPU.Caption)</span></div>
      <div class="row"><span class="label">Driver</span><span class="value">$($d.GPU.DriverVersion)</span></div>
      <div class="row"><span class="label">Resolución</span><span class="value">$($d.GPU.CurrentHorizontalResolution) x $($d.GPU.CurrentVerticalResolution)</span></div>
    </div>
    <div class="card">
      <h2>🌐 Red</h2>
      <div class="row"><span class="label">Adaptador</span><span class="value">$($d.Net.Name)</span></div>
      <div class="row"><span class="label">Estado</span><span class="value" style="color:#27ae60">$($d.Net.Status)</span></div>
      <div class="row"><span class="label">MAC</span><span class="value">$($d.Net.MacAddress)</span></div>
    </div>
  </div>
</div>
<div class="footer">
  Generado por J&amp;J Tecnología · Ultimate Optimizer Pro v$Global:AppVersion · Jayanca, Lambayeque, Perú
</div>
</body>
</html>
"@
        $html | Set-Content -Path $path -Encoding UTF8
        Write-Host "  ✔  Reporte HTML guardado en:" -ForegroundColor Green
        Write-Host "     $path" -ForegroundColor Cyan
        Write-Log "Reporte HTML generado: $path"

        # Intentar abrir en el navegador
        try { Start-Process $path } catch { }

    } catch {
        Write-Host "  ✘  Error generando reporte HTML: $_" -ForegroundColor Red
        Write-Log "Error reporte HTML: $_" "ERROR"
    }
}

# ============================================================
# MÓDULO 9: HERRAMIENTAS DE WINDOWS
# ============================================================
function Show-WindowsTools {
    Show-Header "🛠️   HERRAMIENTAS DE WINDOWS" "DarkCyan"

    Write-Host "  ┌───────────────────────────────────────────┐" -ForegroundColor DarkCyan
    Write-Host "  │         HERRAMIENTAS DEL SISTEMA          │" -ForegroundColor DarkCyan
    Write-Host "  ├───────────────────────────────────────────┤" -ForegroundColor DarkCyan
    Write-Host "  │  [1]  Administrador de Tareas            │" -ForegroundColor White
    Write-Host "  │  [2]  Monitor de Recursos                │" -ForegroundColor White
    Write-Host "  │  [3]  Servicios                          │" -ForegroundColor White
    Write-Host "  │  [4]  Información del Sistema (msinfo32) │" -ForegroundColor White
    Write-Host "  │  [5]  Administrador de Dispositivos      │" -ForegroundColor White
    Write-Host "  │  [6]  Configuración de Energía           │" -ForegroundColor White
    Write-Host "  │  [7]  Editor del Registro                │" -ForegroundColor White
    Write-Host "  │  [8]  Directiva de Grupo                 │" -ForegroundColor White
    Write-Host "  │  [9]  Opciones de Carpeta                │" -ForegroundColor White
    Write-Host "  │  [0]  Volver                             │" -ForegroundColor DarkGray
    Write-Host "  └───────────────────────────────────────────┘" -ForegroundColor DarkCyan
    Write-Host ""
    Write-Host "  Opción: " -ForegroundColor Yellow -NoNewline
    $opt = Read-Host

    switch ($opt) {
        "1" { Start-Process taskmgr }
        "2" { Start-Process perfmon -ArgumentList "/res" }
        "3" { Start-Process services.msc }
        "4" { Start-Process msinfo32 }
        "5" { Start-Process devmgmt.msc }
        "6" { Start-Process powercfg.cpl }
        "7" {
            Write-Host "  ⚠  El Editor del Registro puede dañar el sistema. ¿Continuar? (S/N): " -ForegroundColor Yellow -NoNewline
            $c = Read-Host
            if ($c -match "^[Ss]$") { Start-Process regedit }
        }
        "8" { Start-Process gpedit.msc }
        "9" { Start-Process control -ArgumentList "folders" }
        "0" { return }
    }

    if ($opt -ne "0") {
        Write-Host "  ✔  Herramienta iniciada." -ForegroundColor Green
        Write-Log "Herramienta Windows abierta: opcion $opt"
    }

    Start-Sleep -Seconds 1
}

# ============================================================
# FUNCIÓN: Splash de bienvenida
# ============================================================
function Show-Splash {
    Clear-Host
    Write-Host ""
    Write-Host "  ┌──────────────────────────────────────────────────────────┐" -ForegroundColor Cyan
    Write-Host "  │                                                          │" -ForegroundColor Cyan
    Write-Host "  │           Cargando J&J TECNOLOGÍA Optimizer...           │" -ForegroundColor White
    Write-Host "  │                                                          │" -ForegroundColor Cyan
    Write-Host "  └──────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
    Write-Host ""

    $steps = @(
        "  Verificando privilegios...",
        "  Cargando módulos del sistema...",
        "  Inicializando monitor de hardware...",
        "  Preparando interfaz...",
        "  Listo."
    )

    $barWidth = 40
    $total    = $steps.Count

    for ($i = 0; $i -lt $total; $i++) {
        $pct    = [math]::Round((($i + 1) / $total) * 100)
        $filled = [math]::Round(($pct / 100) * $barWidth)
        $empty  = $barWidth - $filled

        Write-Host "`r  [" -NoNewline -ForegroundColor White
        Write-Host ("█" * $filled) -NoNewline -ForegroundColor Cyan
        Write-Host ("░" * $empty)  -NoNewline -ForegroundColor DarkGray
        Write-Host ("] $pct%  ") -NoNewline -ForegroundColor Yellow
        Write-Host $steps[$i]      -NoNewline -ForegroundColor Gray

        if (-not (Test-Path $Global:LogFolder)) {
            New-Item -ItemType Directory -Path $Global:LogFolder -Force | Out-Null
        }

        Start-Sleep -Milliseconds 350
    }

    Write-Host ""
    Start-Sleep -Milliseconds 400
}

# ============================================================
# PUNTO DE ENTRADA PRINCIPAL
# ============================================================
function Main {
    # Crear carpeta de logs si no existe
    try {
        if (-not (Test-Path $Global:LogFolder)) {
            New-Item -ItemType Directory -Path $Global:LogFolder -Force | Out-Null
        }
    } catch { }

    Show-Splash
    Write-Log "=== J&J Tecnologia Ultimate Optimizer Pro v$Global:AppVersion INICIADO ==="
    Write-Log "Usuario: $env:USERNAME  Equipo: $env:COMPUTERNAME"
    Write-Log "Administrador: $(Test-Administrator)"

    # Bucle principal
    do {
        Show-MainMenu
        $choice = Read-Host

        switch ($choice.Trim()) {
            "1" { Show-Dashboard }
            "2" { Invoke-Optimization }
            "3" { Invoke-SystemRepair }
            "4" { Show-HardwareDiagnostic }
            "5" { Show-NetworkTools }
            "6" { Show-ProcessManager }
            "7" { Show-StartupManager }
            "8" { Generate-Reports }
            "9" { Show-WindowsTools }
            "0" {
                Write-Host ""
                Write-Host "  ¿Confirmas salir? (S/N): " -ForegroundColor Yellow -NoNewline
                $exit = Read-Host
                if ($exit -match "^[Ss]$") {
                    Clear-Host
                    Write-Host ""
                    Write-Host "  ╔══════════════════════════════════════════════════╗" -ForegroundColor Cyan
                    Write-Host "  ║    Gracias por usar J&J Tecnología Optimizer    ║" -ForegroundColor Cyan
                    Write-Host "  ║         Jayanca, Lambayeque, Perú               ║" -ForegroundColor White
                    Write-Host "  ╚══════════════════════════════════════════════════╝" -ForegroundColor Cyan
                    Write-Host ""
                    Write-Log "=== APLICACION CERRADA ==="
                    exit 0
                }
            }
            default {
                Write-Host "  ⚠  Opción inválida. Elige entre 0 y 9." -ForegroundColor Yellow
                Start-Sleep -Seconds 1
            }
        }

    } while ($true)
}

# Ejecutar
Main
