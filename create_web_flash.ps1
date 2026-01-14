# Create Web Flash files for ESP32-S3 Squeezelite
# Run this after build to create files for ESP Web Flasher

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Creating Web Flash package..." -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

Set-Location -Path $PSScriptRoot

# Setup ESP-IDF environment
$env:IDF_PATH = "C:\Espressif\frameworks\esp-idf-v4.4"
$env:IDF_PYTHON_ENV_PATH = "C:\Espressif\python_env\idf4.4_py3.9_env"

$python = Join-Path $env:IDF_PYTHON_ENV_PATH "Scripts\python.exe"
$esptool = Join-Path $env:IDF_PATH "components\esptool_py\esptool\esptool.py"
$webFlashDir = Join-Path $PSScriptRoot "web_flash"
$buildDir = Join-Path $PSScriptRoot "build"

# Verify build files exist
$bootloader = Join-Path $buildDir "bootloader\bootloader.bin"
$partTable = Join-Path $buildDir "partition_table\partition-table.bin"
$otaData = Join-Path $buildDir "ota_data_initial.bin"
$appBin = Join-Path $buildDir "squeezelite.bin"

if (-not (Test-Path $appBin)) {
    Write-Host "ERROR: Build files not found! Run build first." -ForegroundColor Red
    exit 1
}

# Create web_flash directory if not exists
if (-not (Test-Path $webFlashDir)) {
    New-Item -ItemType Directory -Path $webFlashDir | Out-Null
}

# Copy individual files
Write-Host "Copying individual bin files..." -ForegroundColor Yellow
Copy-Item $bootloader $webFlashDir -Force
Copy-Item $partTable $webFlashDir -Force
Copy-Item $otaData $webFlashDir -Force
Copy-Item $appBin $webFlashDir -Force

# Create merged binary
$mergedBin = Join-Path $webFlashDir "squeezelite_esp32s3_full.bin"
Write-Host "Creating merged binary: squeezelite_esp32s3_full.bin" -ForegroundColor Yellow

& $python $esptool --chip esp32s3 merge_bin `
    -o $mergedBin `
    --flash_mode dio `
    --flash_freq 80m `
    --flash_size 16MB `
    0x0 $bootloader `
    0x8000 $partTable `
    0x49000 $otaData `
    0x1D0000 $appBin

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to create merged binary!" -ForegroundColor Red
    exit 1
}

# Get file sizes
$mergedSize = (Get-Item $mergedBin).Length / 1MB
$appSize = (Get-Item $appBin).Length / 1MB

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "Web Flash package created successfully!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Files in web_flash folder:" -ForegroundColor Cyan
Get-ChildItem $webFlashDir -Filter "*.bin" | ForEach-Object {
    $sizeMB = "{0:N2}" -f ($_.Length / 1MB)
    Write-Host "  $($_.Name) - $sizeMB MB"
}
Write-Host ""
Write-Host "To flash via web:" -ForegroundColor Yellow
Write-Host "1. Open https://web.esptool.io/" -ForegroundColor White
Write-Host "2. Connect to ESP32-S3" -ForegroundColor White
Write-Host "3. Select: squeezelite_esp32s3_full.bin" -ForegroundColor White
Write-Host "4. Set offset: 0x0" -ForegroundColor White
Write-Host "5. Click Program" -ForegroundColor White
Write-Host ""

exit 0
