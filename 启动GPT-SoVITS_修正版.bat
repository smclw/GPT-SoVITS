@echo off
setlocal EnableExtensions
cd /d "%~dp0"

set "PY=%~dp0.venv\Scripts\python.exe"

if not exist "%PY%" (
    echo.
    echo [ERROR] .venv Python not found:
    echo %PY%
    echo Run the initializer first.
    echo.
    pause
    exit /b 1
)

if not exist "%~dp0webui.py" (
    echo.
    echo [ERROR] webui.py not found.
    echo Put this BAT in the GPT-SoVITS root folder.
    echo.
    pause
    exit /b 1
)

set "SSL_CERT_FILE="
set "REQUESTS_CA_BUNDLE="
set "CURL_CA_BUNDLE="
set "PYTHONUTF8=1"
set "PYTHONUNBUFFERED=1"
set "NLTK_DATA=%~dp0.venv\nltk_data"
set "NO_PROXY=localhost,127.0.0.1,::1"
set "no_proxy=localhost,127.0.0.1,::1"
set "ALL_PROXY="
set "all_proxy="
set "HTTP_PROXY="
set "http_proxy="
set "HTTPS_PROXY="
set "https_proxy="

echo.
echo ============================================================
echo GPT-SoVITS
echo Web UI: http://127.0.0.1:9874
echo ============================================================
echo.
echo Starting...
echo.

start "" powershell -NoProfile -WindowStyle Hidden -Command "Start-Sleep -Seconds 12; Start-Process 'http://127.0.0.1:9874'"

"%PY%" webui.py zh_CN

echo.
echo ============================================================
echo GPT-SoVITS has stopped.
echo ============================================================
echo.
pause
endlocal
