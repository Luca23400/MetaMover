;#RequireAdmin
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Form1", 577, 139, 244, 312)
$Button1 = GUICtrlCreateButton("Kopieren", 208, 96, 129, 25)
$Input1 = GUICtrlCreateInput("", 104, 8, 377, 21)
$Input2 = GUICtrlCreateInput("", 104, 48, 377, 21)
$ort = GUICtrlCreateLabel("Ort", 32, 8, 21, 17)
$Ziel = GUICtrlCreateLabel("Ziel", 32, 48, 21, 17)
$Button2 = GUICtrlCreateButton("...", 488, 8, 51, 25)
$Button3 = GUICtrlCreateButton("...", 488, 48, 51, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $Button1
			Local $InputSource = GUICtrlRead($Input1)
			Local $InputDestination = GUICtrlRead($Input2)
			Run(@ScriptDir & "\copyWithMetaData.bat " & '"' & $InputSource & '" "' & $InputDestination & '"')

		Case $Button2
			Local $sourceFolder = FileSelectFolder("Quellordner auswählen", "")
			If $sourceFolder <> "" Then GUICtrlSetData($Input1, $sourceFolder)

		Case $Button3
			Local $targetFolder = FileSelectFolder("Zielordner auswählen", "")
			If $targetFolder <> "" Then GUICtrlSetData($Input2, $targetFolder)
	EndSwitch
WEnd