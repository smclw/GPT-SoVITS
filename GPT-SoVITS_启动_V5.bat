@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title GPT-SoVITS Startup V5

set "PY=%~dp0.venv\Scripts\python.exe"

if not exist "%PY%" (
  echo [ERROR] .venv Python not found.
  pause
  exit /b 1
)

if not exist "%~dp0webui.py" (
  echo [ERROR] webui.py not found.
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

echo.
echo ============================================================
echo GPT-SoVITS Startup V5
echo URL: http://localhost:9874/
echo ============================================================
echo.

if not exist "%~dp0.venv\Lib\site-packages\gpt_sovits_ffmpeg_dll.pth" (
  echo [ERROR] Permanent TorchCodec DLL fix is not installed.
  echo Run GPT-SoVITS_TorchCodec_DLL_Permanent_Fix.bat first.
  pause
  exit /b 1
)

echo Testing actual TorchCodec core libraries...
"%PY%" -c "from torchcodec._internally_replaced_utils import load_core_libraries; load_core_libraries(); import torch,torchcodec; print('torch =',torch.__version__); print('torchcodec =',torchcodec.__version__); print('TORCHCODEC CORE LOAD OK')"
if errorlevel 1 (
  echo [ERROR] TorchCodec core verification failed.
  pause
  exit /b 1
)

echo.
echo Starting GPT-SoVITS...
echo.

REM webui.py already has inbrowser=True, so do not open another browser tab here.
"%PY%" webui.py zh_CN

echo.
echo GPT-SoVITS has stopped.
pause
endlocal
