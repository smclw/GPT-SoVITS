@echo off
setlocal EnableExtensions
cd /d "%~dp0"
set "PY=%~dp0.venv\Scripts\python.exe"

if not exist "%PY%" (
    echo.
    echo [ERROR] Python environment not found:
    echo %PY%
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

echo.
echo ============================================================
echo GPT-SoVITS
echo SOURCE INSTALL / PROJECT .venv
echo Web UI: http://127.0.0.1:9874
echo ============================================================
echo.
echo Python:
echo %PY%
echo.
echo Starting GPT-SoVITS...
echo.

start "" powershell -NoProfile -WindowStyle Hidden -Command "Start-Sleep -Seconds 8; Start-Process 'http://127.0.0.1:9874'"

"%PY%" webui.py zh_CN

echo.
echo ============================================================
echo GPT-SoVITS has stopped.
echo ============================================================
echo.
pause
endlocal
