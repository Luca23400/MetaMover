#RequireAdmin
#include <AutoItConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <Process.au3>

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("PicCopier (Admin)", 600, 200, -1, -1)
$Input1 = GUICtrlCreateInput("", 100, 20, 400, 21)
$Input2 = GUICtrlCreateInput("", 100, 60, 400, 21)
$Label1 = GUICtrlCreateLabel("Quelle:", 30, 20, 60, 17)
$Label2 = GUICtrlCreateLabel("Ziel:", 30, 60, 60, 17)
$Button1 = GUICtrlCreateButton("Kopieren", 240, 100, 120, 30)
$Button2 = GUICtrlCreateButton("...", 510, 20, 50, 25)
$Button3 = GUICtrlCreateButton("...", 510, 60, 50, 25)
$Output = GUICtrlCreateEdit("", 30, 140, 540, 40, BitOR($ES_READONLY, $WS_VSCROLL))
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            Exit

        Case $Button2
            Local $src = FileSelectFolder("Quellordner auswählen", "")
            If $src <> "" Then GUICtrlSetData($Input1, $src)

        Case $Button3
            Local $dst = FileSelectFolder("Zielordner auswählen", "")
            If $dst <> "" Then GUICtrlSetData($Input2, $dst)

        Case $Button1
            Local $sSource = GUICtrlRead($Input1)
            Local $sTarget = GUICtrlRead($Input2)
            Local $sBatch = @ScriptDir & "\copyWithMetaData.bat"

            If Not FileExists($sBatch) Then
                MsgBox($MB_ICONERROR, "Fehler", "Batchdatei nicht gefunden: " & $sBatch)
                ContinueLoop
            EndIf

            If $sSource = "" Or $sTarget = "" Then
                MsgBox($MB_ICONWARNING, "Fehler", "Bitte Quelle und Ziel angeben.")
                ContinueLoop
            EndIf

            ; --- Starte Batch und lese stdout live ---
            GUICtrlSetData($Output, "Starte Kopiervorgang..." & @CRLF)

            Local $sCmd = @ComSpec & ' /c "' & _
                          '"' & $sBatch & '" "' & $sSource & '" "' & $sTarget & '" 2>&1"'
            Local $iPID = Run($sCmd, "", @SW_HIDE, $STDOUT_CHILD)

            While 1
                Local $line = StdoutRead($iPID)
                If @error Then ExitLoop
                If $line <> "" Then
                    GUICtrlSetData($Output, $line, 1)
                EndIf
                Sleep(50)
            WEnd

            GUICtrlSetData($Output, @CRLF & "✅ Kopiervorgang abgeschlossen.", 1)
    EndSwitch
WEnd
