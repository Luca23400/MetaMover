#RequireAdmin
#include <AutoItConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <WindowsConstants.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <Process.au3>
#include <WinAPISys.au3>
#include <WinAPI.au3>

#Region ### GUI ###
$Form1 = GUICreate("PicCopier (Admin)", 650, 400)
$Input1 = GUICtrlCreateInput("", 120, 20, 400, 21)
$Input2 = GUICtrlCreateInput("", 120, 60, 400, 21)
GUICtrlCreateLabel("Quelle:", 40, 20, 60, 17)
GUICtrlCreateLabel("Ziel:", 40, 60, 60, 17)
$Button1 = GUICtrlCreateButton("Kopieren", 260, 100, 120, 30)
$Button2 = GUICtrlCreateButton("...", 530, 20, 50, 25)
$Button3 = GUICtrlCreateButton("...", 530, 60, 50, 25)
$Output = GUICtrlCreateEdit("", 30, 150, 590, 220, BitOR($ES_READONLY, $WS_VSCROLL, $ES_AUTOVSCROLL))
GUICtrlSetFont($Output, 9, 400, 0, "Consolas")
GUISetState(@SW_SHOW)
#EndRegion ###

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

            GUICtrlSetData($Output, "Starte Kopiervorgang..." & @CRLF)

            ; --- Befehl vorbereiten ---
            Local $sCmd = @ComSpec & ' /c "' & _
                          '"' & $sBatch & '" "' & $sSource & '" "' & $sTarget & '" 2>&1"'

            Local $iPID = Run($sCmd, "", @SW_HIDE, $STDOUT_CHILD)
            Local $hEdit = GUICtrlGetHandle($Output)

            While 1
                Local $line = StdoutRead($iPID)
                If @error Then ExitLoop
                If $line <> "" Then
                    ; Zeile anfügen
                    GUICtrlSetData($Output, $line, 1)
                    ; Scrollen ans Ende
                    _GUIScrollToBottom($hEdit)
                EndIf
                Sleep(30)
            WEnd

            GUICtrlSetData($Output, @CRLF & "✅ Kopiervorgang abgeschlossen.", 1)
            _GUIScrollToBottom($hEdit)
    EndSwitch
WEnd
; Automatisches Scrollen
Func _GUIScrollToBottom($hEdit)
    Local Const $WM_VSCROLL = 0x115
    Local Const $SB_BOTTOM = 7
    DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $hEdit, "uint", $WM_VSCROLL, "wparam", $SB_BOTTOM, "lparam", 0)
EndFunc
