@echo off
setlocal EnableExtensions
cd /d "%~dp0"

set "PY=%~dp0.venv\Scripts\python.exe"

if not exist "%PY%" (
    echo [ERROR] .venv Python not found:
    echo %PY%
    pause
    exit /b 1
)

set "SSL_CERT_FILE="
set "REQUESTS_CA_BUNDLE="
set "CURL_CA_BUNDLE="

echo ============================================================
echo GPT-SoVITS WebUI compatibility repair
echo Pinning Gradio 4.44.1 compatible FastAPI / Starlette stack
echo ============================================================
echo.

"%PY%" -m pip install --upgrade --force-reinstall "fastapi==0.115.6" "starlette==0.41.3" "pydantic==2.10.6"
if errorlevel 1 goto :fail

echo.
"%PY%" -m pip check
if errorlevel 1 goto :fail

echo.
"%PY%" -c "import gradio,fastapi,starlette,pydantic; print('gradio =',gradio.__version__); print('fastapi =',fastapi.__version__); print('starlette =',starlette.__version__); print('pydantic =',pydantic.__version__); print('WEB STACK OK')"
if errorlevel 1 goto :fail

echo.
echo ============================================================
echo [SUCCESS] WebUI compatibility repair completed.
echo Now run the corrected startup BAT.
echo ============================================================
pause
exit /b 0

:fail
echo.
echo ============================================================
echo [ERROR] Repair failed. Check the error above.
echo ============================================================
pause
exit /b 1
