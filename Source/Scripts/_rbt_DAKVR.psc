Scriptname _rbt_DAKVR extends Quest

GlobalVariable Property MyDAKGlobal Auto

int property MyDAKButton = 32 auto ; 32 = touchpad/thumbstick press

Function Init()
    PapyrusVR.RegisterForVRButtonEvents(Self)
EndFunction

Event OnInit()
    Init()
EndEvent

Function SetDAKVRKey(int aiInputKey = 32)
	If MyDAKButton != aiInputKey
		MyDAKButton = aiInPutKey
		Debug.Notification("Updated DAKVR key to " + MyDAKButton)
		Debug.Trace("Updated DAKVR key to " + MyDAKButton + " following " + aiInputKey) 
	EndIF
EndFunction


Function ToggleDAK(bool abEnable = True)
	If abEnable
		MyDAKGlobal.SetValue(1)
	Else
		MyDAKGlobal.SetValue(0)
	EndIf
	PO3_SKSEFunctions.UpdateCrosshairs() ; equivalent to game.requesthudrolloverrefresh from newer titles
EndFunction

Event OnVRButtonEvent(int buttonEvent, int buttonId, int deviceId)
	If ButtonID == MyDAKButton
		if buttonEvent == 2 ; press
			ToggleDAK(True)
		Elseif buttonEvent == 3 ; release
			ToggleDAK(False)
		endIf
	EndIf
EndEvent