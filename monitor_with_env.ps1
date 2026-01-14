# Monitor ESP32-S3 Audio Project with Environment Setup (ESP-IDF 4.4)
param(
    [string]$Port = "COM13",
    [int]$Baud = 115200
)

Write-Host "================================" -ForegroundColor Cyan
Write-Host "ESP32-S3 Audio - Monitor (IDF 4.4)" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host "Port: $Port, Baud: $Baud" -ForegroundColor Yellow
Write-Host ""

# Always run from project directory (script folder)
Set-Location -Path $PSScriptRoot

# Setup ESP-IDF environment
Write-Host "Setting up ESP-IDF 4.4 environment..." -ForegroundColor Yellow
$env:IDF_PATH = "C:\Espressif\frameworks\esp-idf-v4.4"
$env:IDF_PYTHON_ENV_PATH = "C:\Espressif\python_env\idf4.4_py3.9_env"
$env:IDF_TOOLS_PATH = "C:\Espressif"
& "$env:IDF_PATH\export.ps1" 2>&1 | Out-Null

Write-Host ""
Write-Host "Starting monitor on $Port at $Baud baud..." -ForegroundColor Yellow
Write-Host "Press Ctrl+] to exit" -ForegroundColor Yellow
Write-Host ""
& idf.py -C $PSScriptRoot -p $Port monitor
$code = $LASTEXITCODE

exit $code
