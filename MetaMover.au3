;#RequireAdmin
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Batch Kopierer", 577, 400, 244, 312)
$Button1 = GUICtrlCreateButton("Kopieren", 208, 96, 129, 25)
$Input1 = GUICtrlCreateInput("", 104, 8, 377, 21)
$Input2 = GUICtrlCreateInput("", 104, 48, 377, 21)
$ort = GUICtrlCreateLabel("Ort", 32, 8, 21, 17)
$Ziel = GUICtrlCreateLabel("Ziel", 32, 48, 21, 17)
$Button2 = GUICtrlCreateButton("...", 488, 8, 51, 25)
$Button3 = GUICtrlCreateButton("...", 488, 48, 51, 25)

; === Neues Edit-Feld für Batch-Ausgabe ===
$Output = GUICtrlCreateEdit("", 10, 140, 555, 250, BitOR($ES_AUTOVSCROLL, $ES_MULTILINE, $ES_READONLY, $WS_VSCROLL))
GUICtrlSetFont($Output, 9, 400, 0, "Consolas")

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


; === Hauptloop ===
While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit

        Case $Button1
            Local $InputSource = GUICtrlRead($Input1)
            Local $InputDestination = GUICtrlRead($Input2)
            If $InputSource = "" Or $InputDestination = "" Then
                GUICtrlSetData($Output, "Bitte Quell- und Zielordner angeben." & @CRLF)
                ContinueLoop
            EndIf
            GUICtrlSetData($Output, "Starte Kopiervorgang..." & @CRLF)
            StartBatch($InputSource, $InputDestination, $Output)

        Case $Button2
            Local $sourceFolder = FileSelectFolder("Quellordner auswählen", "")
            If $sourceFolder <> "" Then GUICtrlSetData($Input1, $sourceFolder)

        Case $Button3
            Local $targetFolder = FileSelectFolder("Zielordner auswählen", "")
            If $targetFolder <> "" Then GUICtrlSetData($Input2, $targetFolder)
    EndSwitch
WEnd


; === Funktion zum Starten der Batchdatei mit Live-Ausgabe ===
Func StartBatch($sSource, $sTarget, $hOutput)
    Local $sBatch = @ScriptDir & "\copyWithMetaData.bat"
    If Not FileExists($sBatch) Then
        GUICtrlSetData($hOutput, "Fehler: Batchdatei nicht gefunden: " & $sBatch & @CRLF, 1)
        Return
    EndIf

    ; Prozess mit Pipe starten
   ; Local $iPID = Run(@ComSpec & " /c " & '"' & $sBatch & '" "' & $sSource & '" "' & $sTarget & '"', "", @SW_HIDE, $STDOUT_CHILD)
   ;Local $iPID = Run(@ComSpec & " /c " & '"' & $sBatch & '" "' & $sSource & '" "' & $sTarget & '" 2>&1"', "", @SW_HIDE, $STDOUT_CHILD)
   ;Local $iPID = Run(@ComSpec & " /c " & '"' & $sBatch & '" "' & $sSource & '" "' & $sTarget & '" 2>&1"', "", @SW_HIDE, $STDOUT_CHILD)
   Local $iPID = Run(@ComSpec & " /c " & 'cmd /q /k "' & $sBatch & ' ' & '"' & $sSource & '" "' & $sTarget & '" 2>&1"', "", @SW_HIDE, $STDOUT_CHILD)


    ; Live-Ausgabe lesen
    While ProcessExists($iPID)
        Local $sLine = StdoutRead($iPID)
        If $sLine <> "" Then GUICtrlSetData($hOutput, $sLine, 1)
        Sleep(100)
    WEnd

    ; Letzte Zeilen ausgeben
    Local $sRemaining = StdoutRead($iPID)
    If $sRemaining <> "" Then GUICtrlSetData($hOutput, $sRemaining, 1)

    GUICtrlSetData($hOutput, @CRLF & "=== Kopiervorgang abgeschlossen ===" & @CRLF, 1)
EndFunc
