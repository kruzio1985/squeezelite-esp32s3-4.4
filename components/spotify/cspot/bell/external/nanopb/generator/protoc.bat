@echo off
:: This file acts as a drop-in replacement of binary protoc.exe.
:: It will use either Python-based protoc from grpcio-tools package,
:: or if it is not available, protoc.exe from path if found.

setLocal enableDelayedExpansion
set mydir=%~dp0
"C:\Espressif\python_env\idf4.3_py3.9_env\Scripts\python.exe" "%mydir%\protoc" %*
exit /b %ERRORLEVEL%
