; Basic Keybinds for WASD Movement Style 
; 1. Autowalk 
; 2. Short and Longpresses 

#Requires AutoHotkey v2.0
#include GameKeybindAutoLib.ahk 

; use pause to activate or deactivate the hotkeys in-game 
; read the script carefully, I recommend to set the keymap in windowed mode 

; ===================================================================================
Pause::ToggleScript()
#HotIf ( isScriptActive() ) 
\::Autowalk("w")
q::AssignLongPress("q", "q", "y")
e::AssignLongPress("e", "e", "u")
r::AssignLongPress("r", "r", "i")
f::AssignLongPress("f", "f", "o")
v::AssignLongPress("v", "v", "p")
c::AssignLongPress("c", "c", "j")
x::AssignLongPress("x", "x", "k")
z::AssignLongPress("z", "z", "l")
LAlt::LAlt_LongPress() 
CapsLock::n 
LWin::m 
; -- END 
