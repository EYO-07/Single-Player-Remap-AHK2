; Basic Keybinds for WASD Movement Style 
; 1. Autowalk 
; 2. Short and Longpresses 
#Requires AutoHotkey v2.0
#include GameKeybindAutoLib.ahk 
; use pause to activate or deactivate the hotkeys in-game 
; read the script carefully, I recommend to set the keymap in windowed mode 
; some games needs the execution with administrative privileges 
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
LWin::n
n::LButton 
m::RButton 
; Radial Menu Only Works for Windowed or Borderless Gameplay 
CapsLock_Names := Map()
CapsLock_Actions := Map()
CapsLock_Names["Up"] := "number key 1"
CapsLock_Actions["Up"] := (*)=>Send(1)
CapsLock_Names["Right"] := "number key 2"
CapsLock_Actions["Right"] := (*)=>Send(2)
CapsLock_Names["Down"] := "number key 3"
CapsLock_Actions["Down"] := (*)=>Send(3)
CapsLock_Names["Left"] := "number key 4"
CapsLock_Actions["Left"] := (*)=>Send(4)
CapsLock::RadialMenu4d("CapsLock", CapsLock_Actions, CapsLock_Names)
LCtrl_Names := Map()
LCtrl_Actions := Map()
LCtrl_Names["Up"] := "number key 5"
LCtrl_Actions["Up"] := (*)=>Send(5)
LCtrl_Names["Right"] := "number key 6"
LCtrl_Actions["Right"] := (*)=>Send(6)
LCtrl_Names["Down"] := "number key 7"
LCtrl_Actions["Down"] := (*)=>Send(7)
LCtrl_Names["Left"] := "number key 8"
LCtrl_Actions["Left"] := (*)=>Send(8)
LCtrl::RadialMenu4d("LCtrl", LCtrl_Actions, LCtrl_Names) 

; -- END 
