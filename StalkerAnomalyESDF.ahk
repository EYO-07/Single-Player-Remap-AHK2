#Requires AutoHotkey v2.0

; Specialized keybinds for Stalker Anomaly using GameKeybindAutoLib 
; 1. ESDF movement 
; 2. Short and Long Presses 
; 3. Experimental Simple Radial Menu (up, down, left, right) 

#include GameKeybindAutoLib.ahk ; make sure the file "GameKeybindAutoLib.ahk" is in same folder of this script 

; -- Script Toggle Key 
; use pause to activate or deactivate the hotkeys in-game 
; read the script carefully, I recommend to set the keymap in windowed mode 

Pause::ToggleScript() 

; -- Subroutines and Definitions for Weapon Toggle System 

GetCurrentWeapon() {
	Send("{" GetCurrentKey_ToggleKeys(3, "Numpad2") "}")
} 
GetCurrentKnife(){
	Send("{" GetCurrentKey_ToggleKeys(2, "Numpad1") "}")
}
WeaponDetectorToggle() {
	ToggleActions("Dect2Weap", (*)=>Send("{Numpad4}"), GetCurrentWeapon )
}
WeaponBinocularsToggle() {
	ToggleActions("Bin2Weap", (*)=>Send("{Numpad5}"), GetCurrentWeapon ) 
}
WeaponKnifeToggle() {
	ToggleActions("Knife2Weap", GetCurrentKnife, GetCurrentWeapon ) 
}

; ====================================================================================================

#HotIf ( isScriptActive() && isGameActive("AnomalyDX") ) 

; everything below will only be active with the hot if expression satisfied 
; you should do a manual remap for ESDF movement in game options

; -- Remap of Unusual Keys 
\::LShift ; it's the button right to the shift, some keyboards are different by country, change it if is the case.
LWin::LCtrl ; in this setup you can assign grenade quick-throw as LCtrl in game options and trigger by win button.

; -- Mouse Keybinds - it's just for ease inventory management without relying on mouse buttons and scroll. 
; ... scrolling with keyboard works for zoom-in/zoom-out in binoculars and some scoped weapons.
LShift::ScrollUp() 
LCtrl::ScrollDown() 
n::LButton 
m::RButton 

; -- Autowalk - assign q as freelook in game options, so you can freelook while autowalking 
~q::Autowalk("e")

; -- Tap/Long Press keybinds 
; long presses are long than half-second, to activate the long press hold the key for a second and release. 
; ... the long press need the release key event to trigger, so keep pressing will not trigger until release.
Tab::AssignLongPress_Action( "Tab", (*)=>DoubleTap("LButton"), (*)=>Send("{Enter}") ) 
; long press to send: u, i, o, p 
w::AssignLongPress_Action("w", (*)=>SendAlt("w",1), (*)=>Send("u") )
r::AssignLongPress("r","r","i")
t::AssignLongPress("t","t","o")
; long press to send: k, l
c::AssignLongPress("c","c","k")
v::AssignLongPress("v","v","l")
; long press to send: n, m
x::AssignLongPress("x","x","m")
; long press to send alt gr 
LAlt::LAlt_LongPress() 
; recommended to use a, g to lean left and right respectively 
a::AssignLongPress("a","a","p")
g::AssignLongPress_Action( "g", (*)=>Send("g"), WeaponBinocularsToggle ) ; long press activate binocule 

; -- Radial Menu 
zActions := Map()
zNames := Map() 
zNames["Up"] := "Head Lamp"
zActions["Up"] := (*)=>Send("z")
zNames["Down"] := "Night Vision"
zActions["Down"] := (*)=>Send("n")
zNames["Left"] := "Binoculars"
zActions["Left"] := WeaponBinocularsToggle
zNames["Right"] := "Detector"
zActions["Right"] := WeaponDetectorToggle
z::RadialMenu4d("z", zActions, zNames) 

; Weapons Toggle System - remap first 1,2,3,4,5,6,7 keybinds to numpad version on game menu so the togglers don't interfere with npc interaction gui  
; Numpad1 - weapon 1
; Numpad2 - weapon 2
; Numpad3 - weapon 3 
; Numpad4 - Detector 
; Numpad5 - Binoculars 
; Numpad6 - Bolt  
1::Numpad1 ; manual knife selection 
2::ToggleKeys(2,"Numpad1","Numpad6") ; cycle knife and beads  
3::ToggleKeys(3,"Numpad2","Numpad3") ; cycle primary weapons 
4::WeaponDetectorToggle() ; toggle current weapon with detector 
5::WeaponKnifeToggle() ; toggle current weapon and knife 
6::Tab ; free button 
7::Numpad7 

; Recommended keymap 
; y - toggle stealth for companion 
; u - open inventory 
; i - raise/unraise weapon
; o - select ammo type 
; p - unload weapons in inventory 
; k - toggle combat mode for companion 
; l - slow walk, when on slow walk the crouch behaves different 
; n - night vision 
; m - wait/follow for companion 
; j - drop weapon 
; . - supressor 
; space - fire 

; -- unused/deprecated 
; z::AssignLongPress("z","z","n")
; b::AssignLongPress_Action("b", (*)=>SendAlt("b",1), (*)=>Send("p") )

; END 