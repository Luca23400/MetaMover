#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>

; === GUI erstellen ===
$hGUI = GUICreate("Batch Monitor", 600, 400)
; Edit-Feld für Ausgabe (mehrzeilig, readonly, mit Scrollbalken)
$Output = GUICtrlCreateEdit("", 10, 10, 580, 340, BitOR($ES_AUTOVSCROLL, $ES_MULTILINE, $ES_READONLY, $WS_VSCROLL))
$BtnStart = GUICtrlCreateButton("Batch starten", 10, 360, 150, 30)
GUISetState(@SW_SHOW)

; === Hauptloop ===
While True
    $msg = GUIGetMsg()
    Switch $msg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $BtnStart
            GUICtrlSetData($Output, "") ; Ausgabe leeren
            StartBatch($Output)
    EndSwitch
WEnd


Func StartBatch($hOutput)
    ; --- Hier Pfad zur Batchdatei ---
    Local $sBatch = @ScriptDir & "\copyWithMetaData.bat"

    If Not FileExists($sBatch) Then
        GUICtrlSetData($hOutput, "Fehler: Batchdatei nicht gefunden: " & $sBatch & @CRLF)
        Return
    EndIf

    ; --- Prozess starten (unsichtbar, mit Pipe) ---
    Local $iPID = Run(@ComSpec & " /c " & '"' & $sBatch & '"', "", @SW_HIDE, $STDOUT_CHILD)

    ; --- Live-Ausgabe einlesen ---
    While ProcessExists($iPID)
        Local $sLine = StdoutRead($iPID)
        If $sLine <> "" Then
            GUICtrlSetData($hOutput, $sLine, 1) ; "1" = Text anhängen
        EndIf
        Sleep(100)
    WEnd

    ; --- Letzte Ausgabe holen ---
    Local $sRemaining = StdoutRead($iPID)
    If $sRemaining <> "" Then GUICtrlSetData($hOutput, $sRemaining, 1)

    GUICtrlSetData($hOutput, @CRLF & "=== Batch abgeschlossen ===" & @CRLF, 1)
EndFunc