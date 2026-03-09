#Requires AutoHotkey v2.0

; Specialized keybinds for Stalker Anomaly using GameKeybindAutoLib 
; 1. ESDF movement 
; 2. Short and Long Presses 
; 3. Experimental Simple Radial Menu (up, down, left, right) / Works only in windowed or borderless mode 

#include GameKeybindAutoLib.ahk ; make sure the file "GameKeybindAutoLib.ahk" and "GuiAutoLib.ahk" is in same folder of this script 

; -- Script Toggle Key 
; use pause to activate or deactivate the hotkeys in-game 
; read the script carefully, I recommend to set the keymap in windowed mode 

Pause::ToggleScript() 
ScrollLock::Borderless() 

; -- Subroutines and Definitions for Weapon Toggle System 

GetCurrentWeapon() {
	Send("{" GetCurrentKey_ToggleKeys(3, "Numpad2") "}")
} 
GetCurrentKnife(){
	Send("{" GetCurrentKey_ToggleKeys(2, "Numpad1") "}")
}
WeaponDetectorToggle() {
	ToggleActions_VI("Dect2Weap", (*)=>Send("{Numpad4}"), GetCurrentWeapon )
}
WeaponBinocularsToggle() {
	ToggleActions_VI("Bin2Weap", (*)=>Send("{Numpad5}"), GetCurrentWeapon ) 
}
WeaponKnifeToggle() {
	ToggleActions_VI("Knife2Weap", GetCurrentKnife, GetCurrentWeapon ) 
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

~q::Autowalk("h")
e::KeypressAutowalk_VI("e", "h", 5500)
~d::CancelKeys("h")

; -- Tap/Long Press keybinds 
; long presses are long than half-second, to activate the long press hold the key for a second and release. 
; ... the long press need the release key event to trigger, so keep pressing will not trigger until release.

Tab::LongPress_Action( "Tab", (*)=>DoubleTap("LButton"), (*)=>Send("{Enter}") ) 

; long press to send: u, i, o, p 
w::AutoLongpress_Action("w", (*)=>SendAlt("w",1), (*)=>Send("u") )
r::LongPress("r","r","i")
t::LongPress("t","t","o")
; long press to send: k, l
c::LongPress("c","c","k")
v::LongPress("v","v","l")
; long press to send: n, m
x::LongPress("x","x","m")
; long press to send alt gr 
LAlt::LAlt_LongPress() 
; recommended to use a, g to lean left and right respectively 
a::LongPress("a","a","p")
g::LongPress_Action( "g", (*)=>Send("g"), WeaponBinocularsToggle ) ; long press activate binocule 

; -- Radial Menu for Utility Items 
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
$z::CardinalMenu("z", zActions, zNames) 

; Weapons Toggle System - remap first 1,2,3,4,5,6,7 keybinds to numpad version on game menu so the togglers don't interfere with npc interaction gui  
; Numpad1 - weapon 1
; Numpad2 - weapon 2
; Numpad3 - weapon 3 
; Numpad4 - Detector 
; Numpad5 - Binoculars 
; Numpad6 - Bolt  

1::Numpad1 ; manual knife selection 
2::ToggleKeys_VI(2,"Numpad1","Numpad6") ; cycle knife and beads  

; Actions3 := Map()
; Names3 := Map() 
; Names3["Up"] := "Last Primary"
; Actions3["Up"] := GetCurrentWeapon
; Names3["Down"] := "Secondary Weapon"
; Actions3["Down"] := (*)=>Send("{Numpad1}")
; Names3["Left"] := "Primary Weapon 1"
; Actions3["Left"] := (*)=>ActSetCurrentKey_ToggleKeys(3, 1, "Numpad2") 
; Names3["Right"] := "Primary Weapon 2"
; Actions3["Right"] := (*)=>ActSetCurrentKey_ToggleKeys(3, 2, "Numpad3") 
; defaultAction3() {
	; ToggleKeys(3,"Numpad2","Numpad3")
	; Autowalk("e")
; }
; 3::CardinalMenu(3, Actions3, Names3, defaultAction3 )

; 3::ToggleKeys_VI(3,"Numpad2","Numpad3")
3::TripleToggle(3,"Numpad2","Numpad3","Numpad1")

4::WeaponDetectorToggle() ; toggle current weapon and detector 
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

; Substitute these to your Anomaly/appdata/user.ltx file for quick bind setup
; note: I'm using R to aim, SPACE to fire, B to jump. So if you're using mouse keys, you should remap those in-game. 
/*

bind left kLEFT
bind right kRIGHT
bind up kUP
bind down kDOWN
bind jump kB
bind crouch kV
bind accel kL
bind sprint_toggle kLSHIFT
bind forward kH
bind back kD
bind lstrafe kS
bind rstrafe kF
bind llookout kA
bind rlookout kG
bind cam_zoom_out kRBRACKET
bind torch kZ
bind night_vision kN
bind show_detector kNUMPAD4
bind wpn_1 kNUMPAD1
bind wpn_2 kNUMPAD2
bind wpn_3 kNUMPAD3
bind wpn_4 k4
bind wpn_5 kNUMPAD5
bind wpn_6 kNUMPAD6
bind wpn_next kO
bind wpn_fire kSPACE
bind wpn_zoom kR
bind wpn_reload kT
bind wpn_firemode_prev k9
bind wpn_firemode_next kLMENU
bind pause kPAUSE
bind drop kJ
bind use kW
bind screenshot kF12
bind quit kESCAPE
bind console kGRAVE
bind inventory kU
bind active_jobs kX
bind quick_use_1 kF1
bind quick_use_2 kF2
bind quick_use_3 kF3
bind quick_use_4 kF4
bind quick_save kF5
bind quick_load kF9
bind custom1 kK
bind custom2 kM
bind custom6 kNUMPAD0
bind custom13 kPERIOD
bind custom14 kTAB
bind custom15 kP
bind custom17 kF7
bind custom18 kC
bind custom19 kLCONTROL
bind custom21 kRMENU
bind safemode kI
bind freelook kQ
bind editor kF11

g_crouch_toggle on

g_lookout_toggle on

g_sprint_toggle on

g_walk_toggle on

wpn_aim_toggle on

*/

; END 