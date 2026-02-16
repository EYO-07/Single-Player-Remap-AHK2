; ESDF keybinds for Stalker Anomaly using GameKeybindAutoLib - 
#Requires AutoHotkey v2.0
#include GameKeybindAutoLib.ahk 
; use pause to activate or deactivate the hotkeys in-game 
; read the script carefully, I recommend to set the keymap in windowed mode 
b_active := true 
Pause:: {
    global b_active
    b_active := !b_active
}
; Subroutines and Definitions for Weapon Toggle System 
cyc_knife := [1,"Numpad1","Numpad6"] ; actually is cycle for knife or metal beads
cyc_weaps := [1,"Numpad2","Numpad3"]
toggle_detect_weap := 1
get_state_detect_weap() {
	global toggle_detect_weap
	aux := toggle_detect_weap
	if (toggle_detect_weap = 1) {
		toggle_detect_weap := 2 
	} else {
		toggle_detect_weap := 1
	}
	return aux 
}
get_current_detector() {
	return "Numpad4"
}
WeaponDetectorToggle() {
	ToggleKeysByGetters(get_state_detect_weap, get_current_detector, get_current_weap)
}
toggle_melee := 1 
get_state_toggle_melee() { 
	global toggle_melee 
	aux := toggle_melee
	if (toggle_melee = 1) {
		toggle_melee := 2 
	} else {
		toggle_melee := 1
	}
	return aux 
}
get_current_knife() {
	global cyc_knife
	return cyc_knife[2]
}
get_current_weap() {
	global cyc_weaps 
	return cyc_weaps[ cyc_weaps[1]+1 ]
} 
WeaponKnifeToggle() {
	ToggleKeysByGetters( get_state_toggle_melee, get_current_knife, get_current_weap )
}
; ====================================================================================================
#HotIf ( b_active && isGameActive("AnomalyDX") ) 
; map ESDF for movement 
\::LShift ; it's the button right to the shift, some keyboards are different by country, change it if the case.
LWin::LCtrl 
; mouse keybinds - it's just for ease inventory management without relying on mouse buttons and scroll. 
LCtrl::Send("{WheelDown}") 
LShift::Send("{WheelUp}") 
n::LButton 
m::RButton 
; long presses are long than half-second 
Tab::AssignLongPress_Action( "Tab", (*)=>DoubleTap("LButton"), (*)=>Send("{Enter}") ) 
; autowalk - assign q as freelook with this script inactive or closed, so you can freelook while autowalking 
~q::Autowalk("e")
; long press to send: y, u, i, o, p
a::AssignLongPress("a","a","y") 
w::AssignLongPress_Action("w", (*)=>SendAlt("w",1), (*)=>Send("u") )
r::AssignLongPress("r","r","i")
t::AssignLongPress("t","t","o")
b::AssignLongPress_Action("b", (*)=>SendAlt("b",1), (*)=>Send("p") )
; long press to send: k, l
c::AssignLongPress("c","c","k")
v::AssignLongPress("v","v","l")
; long press to send: n, m
z::AssignLongPress("z","z","n")
x::AssignLongPress("x","x","m")
; h, j are free buttons 
; long press to send alt gr 
LAlt::AssignLongPress("LAlt", "LAlt", "RAlt")
; Weapons Toggle System - remap first 1,2,3,4,5,6,7 keybinds to numpad version on game menu so the togglers don't interfere with npc interaction gui  
; Numpad1 - weapon 1
; Numpad2 - weapon 2
; Numpad3 - weapon 3 
; Numpad4 - Detector 
; Numpad5 - Binoculars 
; Numpad6 - Bolt  
1::Numpad1 ; manual knife selection 
2::ToggleKeys(cyc_knife) ; cycle knife and beads  
3::ToggleKeys(cyc_weaps) ; cycle primary weapons 
4::WeaponDetectorToggle() ; toggle current weapon with detector 
5::WeaponKnifeToggle() ; toggle current weapon and knife 
6::Tab ; free button 
7::Numpad7 
; recommended to use a, g to lean left and right respectively, long press will  
G_Long(){
	global toggle_detect_weap
	Send("{Numpad5}")
	toggle_detect_weap := 2 
}
g::AssignLongPress_Action( "g", (*)=>Send("g"), (*)=>G_Long() ) ; long press activate binocule 
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

; END 