@echo off
setlocal

set "Quelle=%1"
set "Ziel=%2"

echo Starte Kopiervorgang von:
echo Quelle: %Quelle%
echo Ziel:   %Ziel%
echo.

REM robocopy %Quelle% %Ziel% 
robocopy "%Quelle%" "%Ziel%" /E 

if %ERRORLEVEL% GEQ 8 (
    echo.
    echo ❌ FEHLER: Robocopy hat Fehler gemeldet! (Fehlercode: %ERRORLEVEL%)
    echo Siehe Log-Datei: "%Ziel%\Robocopy_Log.txt"
) else (
    echo.
    echo ✅ Kopiervorgang abgeschlossen. (Code: %ERRORLEVEL%)
    echo Siehe Log-Datei: "%Ziel%\Robocopy_Log.txt"
)

pause
