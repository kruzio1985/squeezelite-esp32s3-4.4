# Flash ESP32-S3 Audio Project with Environment Setup (ESP-IDF 4.4)
# IMPORTANT: Always flashes to ota_0 partition (0x1D0000) for Squeezelite main app
# Recovery partition (0x50000) is intentionally smaller and not used for main app
param(
    [string]$Port = "COM13",
    [int]$Baud = 460800,
    [switch]$FullFlash  # Use this to flash bootloader + partition table + ota_data + app
)

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "ESP32-S3 Audio - Flash to OTA_0 (IDF 4.4)" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Port: $Port, Baud: $Baud" -ForegroundColor Yellow
Write-Host "Target partition: ota_0 @ 0x1D0000" -ForegroundColor Yellow
Write-Host ""

# Always run from project directory (script folder)
Set-Location -Path $PSScriptRoot

# Setup ESP-IDF environment
Write-Host "Setting up ESP-IDF 4.4 environment..." -ForegroundColor Yellow
$env:IDF_PATH = "C:\Espressif\frameworks\esp-idf-v4.4"
$env:IDF_PYTHON_ENV_PATH = "C:\Espressif\python_env\idf4.4_py3.9_env"
$env:IDF_TOOLS_PATH = "C:\Espressif"
$env:Path = "C:\Espressif\tools\xtensa-esp32s3-elf\esp-2021r2-patch5-8.4.0\xtensa-esp32s3-elf\bin;C:\Espressif\tools\cmake\3.23.1\bin;C:\Espressif\tools\ninja\1.10.2;$env:IDF_PYTHON_ENV_PATH\Scripts;$env:IDF_PATH\tools;C:\WINDOWS\system32;C:\WINDOWS"

# Verify build files exist
$buildDir = Join-Path $PSScriptRoot "build"
$bootloader = Join-Path $buildDir "bootloader\bootloader.bin"
$partTable = Join-Path $buildDir "partition_table\partition-table.bin"
$otaData = Join-Path $buildDir "ota_data_initial.bin"
$appBin = Join-Path $buildDir "squeezelite.bin"

if (-not (Test-Path $appBin)) {
    Write-Host "ERROR: squeezelite.bin not found! Run build first." -ForegroundColor Red
    exit 1
}

$esptool = Join-Path $env:IDF_PATH "components\esptool_py\esptool\esptool.py"
$python = Join-Path $env:IDF_PYTHON_ENV_PATH "Scripts\python.exe"

Write-Host ""
Write-Host "Flashing to OTA_0 partition..." -ForegroundColor Yellow

if ($FullFlash -or -not (Test-Path (Join-Path $buildDir ".flashed_once"))) {
    # Full flash: bootloader + partition table + ota_data + app to ota_0
    Write-Host "Full flash: bootloader + partition-table + ota_data + squeezelite.bin" -ForegroundColor Cyan
    & $python $esptool -p $Port -b $Baud --chip esp32s3 write_flash `
        --flash_mode dio --flash_freq 80m `
        0x0 $bootloader `
        0x8000 $partTable `
        0x49000 $otaData `
        0x1D0000 $appBin
    $code = $LASTEXITCODE
    
    if ($code -eq 0) {
        # Mark as flashed once
        "Flashed: $(Get-Date)" | Out-File (Join-Path $buildDir ".flashed_once")
    }
} else {
    # App-only flash to ota_0
    Write-Host "App-only flash: squeezelite.bin -> ota_0 @ 0x1D0000" -ForegroundColor Cyan
    & $python $esptool -p $Port -b $Baud --chip esp32s3 write_flash `
        --flash_mode dio --flash_freq 80m `
        0x1D0000 $appBin
    $code = $LASTEXITCODE
}

if ($code -ne 0) {
    Write-Host "Flash FAILED! (exit code: $code)" -ForegroundColor Red
    exit $code
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Flash SUCCESSFUL to OTA_0 partition!" -ForegroundColor Green
Write-Host "Device will boot Squeezelite from ota_0" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
exit 0
