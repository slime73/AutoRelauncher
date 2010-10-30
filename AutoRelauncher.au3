#include <GuiConstantsEx.au3>

Local $version = 1.0

AutoItSetOption("MustDeclareVars", 1)

Opt("GUIOnEventMode", 1) ; event mode, allows the GUI to be responsive while having Sleeps in the main loop

Local $dlg, $startbutton, $stopbutton, $enabled, $state

$dlg = GUICreate("Vendetta Auto-Relauncher", 300, 80)
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseClicked")

$startbutton = GUICtrlCreateButton("Start Auto-Relauncher", 0, -1, 300, 40)
$stopbutton = GUICtrlCreateButton("Stop Auto-Relauncher", 0, 40, 300, 40)

GUICtrlSetOnEvent($startbutton, "StartButton")
GUICtrlSetOnEvent($stopbutton, "StopButton")

GUICtrlSetState($stopbutton, $GUI_DISABLE)

GUISetState(@SW_SHOW) ; Show GUI window

$enabled = False
$state = 0

Func CloseClicked()
	Exit ; quit...
EndFunc

Func StartButton()
	GUICtrlSetState($startbutton, $GUI_DISABLE)
	GUICtrlSetState($stopbutton, $GUI_ENABLE)
	$enabled = True
EndFunc

Func StopButton()
	GUICtrlSetState($startbutton, $GUI_ENABLE)
	GUICtrlSetState($stopbutton, $GUI_DISABLE)
	$enabled = False
EndFunc

If NOT FileExists("vendetta.exe") AND NOT FileExists("vendetta.rlb") Then
	Exit ; Will not run unless in correct directory
EndIf

While 1 ; Main loop
	$state = 0 ; reset state. 0 = VO is closed, 1 = VO launcher running, 2 = VO running
	If ProcessExists("vendetta.rlb") Then
		$state = 2 ; Vendetta is running
	ElseIf ProcessExists("vendetta.exe") Then
		$state = 1 ; Launcher is running
	EndIf
	
	If $enabled = True Then
		Select
		Case $state = 0 ; Vendetta is closed
			Run("vendetta.exe")
			WinWaitActive("Vendetta Update Utility")
		Case $state = 1 ; Launcher is running
			Local $i = ControlCommand("Vendetta Update Utility", "", 1007, "IsEnabled") ; Check if Play button is active
			If $i = 1 Then
				ControlClick("Vendetta Update Utility", "", 1007) ; Press Play!
			EndIf
		Case $state = 2 ; Vendetta is running
			; do nothing
		EndSelect
	EndIf
	
	Sleep(250) ; more sleep time = less CPU but less automation responsiveness
WEnd
