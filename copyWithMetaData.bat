@echo off
setlocal

:: --- Parameter prüfen ---
if "%~1"=="" (
    echo [FEHLER] Keine Quelle angegeben.
    exit /b 1
)
if "%~2"=="" (
    echo [FEHLER] Kein Ziel angegeben.
    exit /b 1
)

set "Quelle=%~1"
set "Ziel=%~2"

echo Starte Kopiervorgang...
echo Quelle: "%Quelle%"
echo Ziel:   "%Ziel%"
echo.

:: --- Test auf Adminrechte ---
>nul 2>&1 net session
if %errorlevel% neq 0 (
    echo [i] Starte mit Administratorrechten neu...
    powershell -Command "Start-Process '%~f0' -Verb RunAs -ArgumentList '%*'"
    exit /b
)

:: --- Kopiervorgang ---
robocopy "%Quelle%" "%Ziel%" /E /COPY:DAT /R:2 /W:2
set "RC=%ERRORLEVEL%"

if %RC% GEQ 8 (
    echo ❌ FEHLER: Robocopy hat Fehler gemeldet! (Fehlercode: %RC%)
) else (
    echo ✅ Kopiervorgang abgeschlossen. (Code: %RC%)
)

exit /b %RC%
