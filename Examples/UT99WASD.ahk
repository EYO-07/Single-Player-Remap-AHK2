; Basic Keybinds for WASD Movement Style 
; 1. Autowalk 
; 2. Short and Longpresses 
#Requires AutoHotkey v2.0
#include GameKeybindAutoLib.ahk 
; use pause to activate or deactivate the hotkeys in-game 
; read the script carefully, I recommend to set the keymap in windowed mode 
; some games needs the execution with administrative privileges 
; ===================================================================================

Activate_Minigun(){
	DisplayMessage("Minigun",1)
	Send("y")
}
Activate_Flack(){
	DisplayMessage("Flack Cannon",1)
	Send("o")
}
Activate_Pulse(){
	DisplayMessage("Pulse Gun",1)
	Send("i")
}
Activate_Shock(){
	DisplayMessage("Shock Rifle",1)
	Send("h")
}

Pause::ToggleScript()
#HotIf ( isScriptActive() && isGameActive("UnrealTournament.exe") ) 
\::Autowalk("w")
LAlt::LAlt_LongPress() 
LWin::n 
CapsLock::m
n::LButton 
m::RButton 
; Radial Menu Only Works for Windowed or Borderless Gameplay 
e::ToggleActions("Minigun/Flack Cannon", Activate_Minigun, Activate_Flack)
f::ToggleActions("Pulse Gun/Shock Rifle", Activate_Pulse, Activate_Shock)
; -- END 
