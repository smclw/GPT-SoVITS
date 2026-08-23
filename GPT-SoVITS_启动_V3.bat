@echo off
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"
title GPT-SoVITS Startup V3

set "PY=%~dp0.venv\Scripts\python.exe"

if not exist "%PY%" (
  echo [ERROR] .venv Python not found.
  pause
  exit /b 1
)

set "SSL_CERT_FILE="
set "REQUESTS_CA_BUNDLE="
set "CURL_CA_BUNDLE="
set "HTTP_PROXY="
set "HTTPS_PROXY="
set "ALL_PROXY="
set "http_proxy="
set "https_proxy="
set "all_proxy="
set "NO_PROXY=localhost,127.0.0.1,::1"
set "no_proxy=localhost,127.0.0.1,::1"
set "PYTHONUTF8=1"
set "PYTHONUNBUFFERED=1"
set "NLTK_DATA=%~dp0.venv\nltk_data"

set "FFMPEG_SHARED_BIN="
for /f "usebackq delims=" %%D in (`powershell -NoProfile -Command "$p=Get-ChildItem \"$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Gyan.FFmpeg.Shared_*\" -Recurse -Filter 'avcodec-*.dll' -ErrorAction SilentlyContinue ^| Select-Object -First 1 -ExpandProperty DirectoryName; if($p){$p}"`) do set "FFMPEG_SHARED_BIN=%%D"

if not defined FFMPEG_SHARED_BIN (
  echo [ERROR] FFmpeg Shared DLLs not found.
  pause
  exit /b 1
)

set "PATH=%FFMPEG_SHARED_BIN%;%PATH%"

echo.
echo FFmpeg Shared:
echo %FFMPEG_SHARED_BIN%
echo.

"%PY%" -c "import torch,torchcodec; print('torch =',torch.__version__); print('torchcodec =',torchcodec.__version__); print('TORCHCODEC OK')"
if errorlevel 1 (
  echo [ERROR] TorchCodec verification failed.
  pause
  exit /b 1
)

start "" powershell -NoProfile -WindowStyle Hidden -Command "Start-Sleep -Seconds 12; Start-Process 'http://127.0.0.1:9874'"

"%PY%" webui.py zh_CN

echo.
echo GPT-SoVITS has stopped.
pause
endlocal
