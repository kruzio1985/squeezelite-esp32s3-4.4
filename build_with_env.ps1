# Build ESP32-S3 Audio Project with Environment Setup (ESP-IDF 4.4)
Write-Host "================================" -ForegroundColor Cyan
Write-Host "ESP32-S3 Audio - Build (IDF 4.4)" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Always run from project directory (script folder)
Set-Location -Path $PSScriptRoot

# Setup ESP-IDF environment
Write-Host "Setting up ESP-IDF 4.4 environment..." -ForegroundColor Yellow
$env:IDF_PATH = "C:\Espressif\frameworks\esp-idf-v4.4"
$env:IDF_PYTHON_ENV_PATH = "C:\Espressif\python_env\idf4.4_py3.9_env"
$env:IDF_TOOLS_PATH = "C:\Espressif"
$env:Path = "C:\Espressif\tools\xtensa-esp32s3-elf\esp-2021r2-patch5-8.4.0\xtensa-esp32s3-elf\bin;C:\Espressif\tools\cmake\3.23.1\bin;C:\Espressif\tools\ninja\1.10.2;$env:IDF_PYTHON_ENV_PATH\Scripts;$env:IDF_PATH\tools;C:\WINDOWS\system32;C:\WINDOWS"

$python = Join-Path $env:IDF_PYTHON_ENV_PATH "Scripts\python.exe"
$idfpy = Join-Path $env:IDF_PATH "tools\idf.py"

Write-Host ""
Write-Host "Building firmware..." -ForegroundColor Yellow
& $python $idfpy build
$code = $LASTEXITCODE

if ($code -ne 0) {
    Write-Host "Build FAILED! (exit code: $code)" -ForegroundColor Red
    exit $code
}

Write-Host ""
Write-Host "Build SUCCESSFUL!" -ForegroundColor Green
Write-Host ""
exit 0
