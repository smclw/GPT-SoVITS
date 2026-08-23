@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title GPT-SoVITS TorchCodec FFmpeg DLL Permanent Fix V2

set "PY=%~dp0.venv\Scripts\python.exe"
set "SITEPKG=%~dp0.venv\Lib\site-packages"

if not exist "%PY%" (
  echo [ERROR] .venv Python not found.
  pause
  exit /b 1
)

if not exist "%SITEPKG%" (
  echo [ERROR] site-packages not found.
  pause
  exit /b 1
)

echo.
echo ============================================================
echo GPT-SoVITS TorchCodec FFmpeg DLL Permanent Fix V2
echo ============================================================
echo.

echo [1/4] Writing DLL bootstrap module...
"%PY%" -c "import base64,pathlib; pathlib.Path(r'%SITEPKG%\gpt_sovits_ffmpeg_dll.py').write_bytes(base64.b64decode('aW1wb3J0IG9zCmZyb20gcGF0aGxpYiBpbXBvcnQgUGF0aAoKX2ZmbXBlZ19kbGxfaGFuZGxlID0gTm9uZQpfZmZtcGVnX3NoYXJlZF9iaW4gPSBOb25lCgppZiBvcy5uYW1lID09ICJudCI6CiAgICByb290ID0gUGF0aChvcy5lbnZpcm9uLmdldCgiTE9DQUxBUFBEQVRBIiwgIiIpKSAvICJNaWNyb3NvZnQiIC8gIldpbkdldCIgLyAiUGFja2FnZXMiCiAgICBjYW5kaWRhdGVzID0gW10KICAgIGlmIHJvb3QuZXhpc3RzKCk6CiAgICAgICAgZm9yIHBrZyBpbiByb290Lmdsb2IoIkd5YW4uRkZtcGVnLlNoYXJlZF8qIik6CiAgICAgICAgICAgIGNhbmRpZGF0ZXMuZXh0ZW5kKHBrZy5yZ2xvYigiYXZjb2RlYy0qLmRsbCIpKQogICAgaWYgY2FuZGlkYXRlczoKICAgICAgICBfZmZtcGVnX3NoYXJlZF9iaW4gPSBzdHIoY2FuZGlkYXRlc1swXS5wYXJlbnQpCiAgICAgICAgdHJ5OgogICAgICAgICAgICBfZmZtcGVnX2RsbF9oYW5kbGUgPSBvcy5hZGRfZGxsX2RpcmVjdG9yeShfZmZtcGVnX3NoYXJlZF9iaW4pCiAgICAgICAgZXhjZXB0IEV4Y2VwdGlvbjoKICAgICAgICAgICAgX2ZmbXBlZ19kbGxfaGFuZGxlID0gTm9uZQogICAgICAgIG9zLmVudmlyb25bIlBBVEgiXSA9IF9mZm1wZWdfc2hhcmVkX2JpbiArIG9zLnBhdGhzZXAgKyBvcy5lbnZpcm9uLmdldCgiUEFUSCIsICIiKQo='))"
if errorlevel 1 goto :fail

echo [2/4] Writing .pth auto-loader...
"%PY%" -c "import base64,pathlib; pathlib.Path(r'%SITEPKG%\gpt_sovits_ffmpeg_dll.pth').write_bytes(base64.b64decode('aW1wb3J0IGdwdF9zb3ZpdHNfZmZtcGVnX2RsbA0K'))"
if errorlevel 1 goto :fail

echo [3/4] Verifying FFmpeg Shared DLL directory...
"%PY%" -c "import gpt_sovits_ffmpeg_dll as m; print('FFmpeg Shared =', m._ffmpeg_shared_bin); raise SystemExit(0 if m._ffmpeg_shared_bin else 1)"
if errorlevel 1 goto :fail

echo [4/4] Testing actual TorchCodec core loading...
"%PY%" -c "from torchcodec._internally_replaced_utils import load_core_libraries; load_core_libraries(); import torch,torchcodec; print('torch =',torch.__version__); print('torchcodec =',torchcodec.__version__); print('TORCHCODEC CORE LOAD OK')"
if errorlevel 1 goto :fail

echo.
echo ============================================================
echo [SUCCESS] Permanent DLL fix V2 applied.
echo All Python child processes in this .venv will automatically
echo register the FFmpeg Shared DLL directory.
echo ============================================================
echo.
pause
exit /b 0

:fail
echo.
echo ============================================================
echo [ERROR] Permanent DLL fix V2 failed.
echo Copy the last error above and send it back.
echo ============================================================
echo.
pause
exit /b 1
