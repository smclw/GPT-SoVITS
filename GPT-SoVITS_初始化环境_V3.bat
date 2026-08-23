@echo off
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"
title GPT-SoVITS Initializer V3

set "SYS_PY=C:\Users\o\AppData\Local\Programs\Python\Python310\python.exe"
set "PY=%~dp0.venv\Scripts\python.exe"

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

echo [1/7] Check FFmpeg Shared
set "FFMPEG_SHARED_BIN="
for /f "usebackq delims=" %%D in (`powershell -NoProfile -Command "$p=Get-ChildItem \"$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Gyan.FFmpeg.Shared_*\" -Recurse -Filter 'avcodec-*.dll' -ErrorAction SilentlyContinue ^| Select-Object -First 1 -ExpandProperty DirectoryName; if($p){$p}"`) do set "FFMPEG_SHARED_BIN=%%D"

if not defined FFMPEG_SHARED_BIN (
  where winget >nul 2>nul
  if errorlevel 1 goto :fail
  winget install --id Gyan.FFmpeg.Shared --exact --version 8.1.2 --accept-package-agreements --accept-source-agreements
  if errorlevel 1 goto :fail
  for /f "usebackq delims=" %%D in (`powershell -NoProfile -Command "$p=Get-ChildItem \"$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Gyan.FFmpeg.Shared_*\" -Recurse -Filter 'avcodec-*.dll' -ErrorAction SilentlyContinue ^| Select-Object -First 1 -ExpandProperty DirectoryName; if($p){$p}"`) do set "FFMPEG_SHARED_BIN=%%D"
)
if not defined FFMPEG_SHARED_BIN goto :fail
set "PATH=%FFMPEG_SHARED_BIN%;%PATH%"

echo [2/7] Create .venv
if not exist "%PY%" (
  "%SYS_PY%" -m venv ".venv"
  if errorlevel 1 goto :fail
)

call ".venv\Scripts\activate.bat"
set "NLTK_DATA=%~dp0.venv\nltk_data"

echo [3/7] Base packages
"%PY%" -m pip install --upgrade pip setuptools wheel cmake ninja
if errorlevel 1 goto :fail

echo [4/7] PyTorch stack
"%PY%" -m pip install --upgrade "torch==2.13.0+cu126" "torchaudio==2.11.0+cu126" "torchcodec==0.16.0+cu126" --index-url https://download.pytorch.org/whl/cu126
if errorlevel 1 goto :fail

echo [5/7] Windows compatibility packages
"%PY%" -m pip install --upgrade "numpy==1.26.4" "pyopenjtalk-plus==0.4.1.post8" "OpenCC==1.1.9" "jieba==0.42.1"
if errorlevel 1 goto :fail

echo [6/7] WebUI compatibility lock
"%PY%" -m pip install --upgrade --force-reinstall "gradio==4.44.1" "gradio-client==1.3.0" "fastapi==0.115.6" "starlette==0.41.3" "pydantic==2.10.6"
if errorlevel 1 goto :fail

echo [7/7] Verify
"%PY%" -m pip check
if errorlevel 1 goto :fail
"%PY%" -c "import torch,torchcodec; print('torch =',torch.__version__); print('torchcodec =',torchcodec.__version__); print('CUDA =',torch.cuda.is_available()); print('GPU =',torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'CPU'); print('TORCHCODEC OK')"
if errorlevel 1 goto :fail

echo.
echo [SUCCESS] Initializer V3 completed.
echo Run the V3 startup BAT.
pause
exit /b 0

:fail
echo.
echo [ERROR] Initializer failed.
pause
exit /b 1
