Scriptname _rbt_DAKVR extends Quest
; custom VR implementation for Dynamic Activation Key by JaySerpa
; Original mod: https://www.nexusmods.com/skyrimspecialedition/mods/96273

; DAK global
GlobalVariable Property MyDAKGlobal Auto

; Internal settings
int property MyDAKButton = 34 auto ; see ini
int property MyDAKDeviceID = 1 auto ; 1 = right
bool property DAKUseEitherHand = false auto ; does what it says
bool property ToggleGlobalAccessibility = false auto; press events toggle

; Startup
Event OnInit()
    DoInit()
EndEvent

Function DoInit()
    PapyrusVR.RegisterForVRButtonEvents(Self)
	DoIniSettings()
EndFunction

Function DoIniSettings()
	int MyVRKey = papyrusinimanipulator.PullIntFromIni("Data/DynamicActivationKeyVR_Config.ini", "config", "ActivationButton", 34)
	bool UseLeft = papyrusinimanipulator.PullBoolFromIni("Data/DynamicActivationKeyVR_Config.ini", "config", "UseLeftHand", true)
	DAKUseEitherHand = papyrusinimanipulator.PullBoolFromIni("Data/DynamicActivationKeyVR_Config.ini", "config", "UseEitherHand", false)
	ToggleGlobalAccessibility = papyrusinimanipulator.PullBoolFromIni("Data/DynamicActivationKeyVR_Config.ini", "experimental", "KeyPressToggles", false)
	String ControllerHand = "Left"
	If UseLeft
		MyDAKDeviceID = 2
	Else
		MyDAKDeviceID = 1
		ControllerHand = "Right"
	EndIf
	If MyDAKButton != MyVRKey
		MyDAKButton = MyVRKey
		If !DAKUseEitherHand
			Debug.Notification("DAK key set to " + MyDAKButton + " on " + ControllerHand + " Controller.")
		Else
			Debug.Notification("DAK key set to " + MyDAKButton)
		EndIF
	EndIF
EndFunction

; Wrapper for the actual toggle behavior
Function ToggleDAK(bool abEnable = True)
	If abEnable
		MyDAKGlobal.SetValue(1)
	Else
		MyDAKGlobal.SetValue(0)
	EndIf
	PO3_SKSEFunctions.UpdateCrosshairs() ; not working as of latest builds 11/13/25
EndFunction

; Changes state according to prior state
Function ToggleDAKAlternative()
	If MyDAKGlobal.GetValue() == 0
		MyDAKGlobal.SetValue(1)
	Else
		MyDAKGlobal.SetValue(0)
	EndIf
	PO3_SKSEFunctions.UpdateCrosshairs() ; not working as of latest builds 11/13/25
EndFunction

Event OnVRButtonEvent(int buttonEvent, int buttonId, int deviceId)
	If UI.IsTextInputEnabled() || Utility.IsInMenuMode()
		Return
	EndIF

	If ButtonID == MyDAKButton && ( ( deviceID == MyDAKDeviceID ) || DAKUseEitherHand )

		If !ToggleGlobalAccessibility
			; Do normal DAK behavior
			if buttonEvent == 2 ; press
				ToggleDAK(True)
			Elseif buttonEvent == 3 ; release
				ToggleDAK(False)
			endIf
		Else
			if buttonEvent == 2 ; press
				ToggleDAKAlternative()
			EndIF
		EndIF
	EndIf
EndEvent