 @echo off
:: --- Check for Administrative Privileges ---
NET SESSION >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /B
)

:: --- Once elevated, run the Bash installer ---
:: Make sure Git Bash is installed and 'bash' is available in PATH.
echo Running Windows installer with admin privileges...
bash "%~dp0install_windows.sh"

pause
