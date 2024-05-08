$settingsPath = "$env:USERPROFILE\Documents\Overwatch\Settings\Settings_v0.ini"
$backupPath = "$settingsPath.bak"

Write-Host "=======================================================================" -ForegroundColor Black
Write-Host "                    Noverse Optimized Overwatch Settings               " -ForegroundColor White
Write-Host "=======================================================================" -ForegroundColor Black
Write-Host "Beginning import process..." -ForegroundColor White
Write-Host ""

if (-Not (Test-Path $settingsPath)) {
    Write-Host "Error: Overwatch settings file not found. Please check your installation." -ForegroundColor Red
    exit
}

try {
    Copy-Item -Path $settingsPath -Destination $backupPath -Force
    Write-Host "Backup at: $backupPath" -ForegroundColor Green
} catch {
    Write-Host "Failed to create backup. Check your file permissions." -ForegroundColor Red
    exit
}

$existingSettings = Get-Content -Path $settingsPath

# Variables for capturing specific settings sections
$gpuSettings = @()
$fullScreenRefresh = ""
$windowedRefresh = ""

foreach ($line in $existingSettings) {
    if ($line -match '^\[GPU\.6\]$') {
        $gpuSection = $true
        $gpuSettings += $line
        continue
    }

    if ($gpuSection) {
        if ($line -match '^$') {
            $gpuSection = $false
        } else {
            $gpuSettings += $line
        }
    }

    if ($line -match '^FullScreenRefresh = "\d+"$') {
        $fullScreenRefresh = $line
    }

    if ($line -match '^WindowedRefresh = "\d+"$') {
        $windowedRefresh = $line
    }
}

if ($gpuSettings.Count -eq 0) {
    Write-Host "No GPU settings found. Proceeding with default values." -ForegroundColor Red
}

$newSettings = @"
[Cinematics.1]
ShowIntro = "0"

[General.0]
ShowIntro = "0"

$($gpuSettings -join "`n")

[Input.1]
HighTickInput = "1"

[Render.13]
AADetail = "0"
CpuForceSyncEnabled = "1"
DirectionalShadowDetail = "2"
DynamicRenderScale = "0"
FrameRateCap = "330"
$fullScreenRefresh
FullscreenWindow = "1"
FullscreenWindowEnabled = "1"
GFXPresetLevel = "1"
HighQualityUpsample = "0"
ImageSharpening = "0.00000"
LocalReflections = "0"
MaxWorldScale = "100.000000"
PhysicsQuality = "2"
ReflexMode = "2"
ShowFPSCounter = "1"
SimpleDirectionalShadows = "0"
SoundQuality = "1"
SSAODetail = "0"
SSLRDetailLevel = "0"
TextureDetail = "2"
UseCustomFrameRates = "1"
UseCustomWorldScale = "1"
VerticalSyncEnabled = "0"
WaterCombineCascades = "0"
WindowedFullscreen = "0"
$windowedRefresh
WindowMode = "0"

[Sound.3]
AudioMix = "3"
MusicVolume = "0.000000"

[Subtitles.1]
Subtitles = "1"

[TankMenuItems.1]
FPSOverlay = "0"
"@

Set-Content -Path $settingsPath -Value $newSettings -Force
Write-Host "Successfully imported optimized Overwatch Preset!" -ForegroundColor Green

Write-Host ""
Write-Host "=======================================================================" -ForegroundColor Black
Write-Host "`nThank you for using the Noverse Script." -ForegroundColor White
Write-Host "For further assistance, join the Discord server:" -ForegroundColor White
Write-Host ""
Write-Host "https://discord.gg/E2ybG4j9jU" -ForegroundColor Red
Write-Host ""
Write-Host "=======================================================================" -ForegroundColor Black
Write-Host ""


Write-Host "`nPress any key to exit..." -ForegroundColor White
$null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
