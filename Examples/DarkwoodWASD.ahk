; DarkwoodWASD 
; 1. Script Designed for Darkwood Gameplay in WASD using E to aim and Space to Fire 
#Requires AutoHotkey v2.0
#include GameKeybindAutoLib.ahk ; make sure the this script is in CoreFiles folder

; use pause to activate or deactivate the hotkeys in-game 
; use scrollock to change between windowed and borderless windowed, the function will center the game window
Pause::ToggleScript()
ScrollLock::Borderless() 
 
; Everything below hotif statements only works with script active 
; Additionaly you can use isGameActive(GAMENAME) to filter the functionality only for your game 
; #HotIf ( isScriptActive() && isGameActive(GAMENAME) )  
; ===================================================================================
#HotIf ( isScriptActive() && isGameActive("Darkwood") ) 

; keyboard mouse controls 
n::LButton 
m::RButton 
CapsLock::ScrollUp()
LCtrl::ScrollDown()

; Game Menu KeyBinds:
; y ~ aim 
; r/u ~ reload/skill menu 
; v/i ~ dodge/vault
; q/o ~ inventory/map 
; LAlt/p ~ attack/secondary attack
; c ~ cycle interaction options 
; tab ~ journal 
; LShift - run 
2::TripleToggle(2,2,3,1)
4::ToggleActions(4,(*)=>Send(4), (*)=>ActGetCurrentKey_ToggleKeys(2,2) )
5::ToggleActions(5,(*)=>Send(5), (*)=>ActGetCurrentKey_ToggleKeys(2,2) )
f::ToggleActions("f",(*)=>Send(6), (*)=>ActGetCurrentKey_ToggleKeys(2,2) )
z::ToggleActions("z",(*)=>Send(7), (*)=>ActGetCurrentKey_ToggleKeys(2,2) )
x::ToggleActions("x",(*)=>Send(8), (*)=>ActGetCurrentKey_ToggleKeys(2,2) )
e::KeyStateToggle("y") ; aim 
r::AutoLongpress("r","r","u") ; reload/skill menu 
v::AutoLongpress("v","v","i") ; dodge/vault
q::AutoLongpress("q","q","o") ; inventory/map 
Space::AutoLongpress("Space","LAlt","p") ; attack/secondary attack
~LShift::CancelKeys("y")
\::ToggleActions(9,(*)=>Send(9), (*)=>ActGetCurrentKey_ToggleKeys(2,2) ) ; ?
LWin::j ; ? 

; -- END 