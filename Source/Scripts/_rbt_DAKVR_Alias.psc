ScriptName _rbt_DAKVR_Alias Extends ReferenceAlias

_rbt_DAKVR property _rbt_DAKVRQUEST auto

Event OnPlayerLoadGame()
	int MyVRKey = papyrusinimanipulator.PullIntFromIni("Data/DynamicActivationKeyVR_Config.ini", "config", "DAKVRKEY", 32)
	_rbt_DAKVRQUEST.SetDAKVRKey(MyVRKey)
EndEvent